local module = {}

function module.check_install ()
    check_module 'db'
    db.check_table ('achivs', 'unlocked_achivs', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`vkid` int(11) NOT NULL,
            `slug` text NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);
end

function module.start ()
    function db.oop:unlockAchiv (slug)
        if not module.achivs[slug] then -- Safe
            db.get_user(admin):ls("🅰 Неизвестное достижение: " .. slug)
            return
        end

        if not db.select_one('id', 'unlocked_achivs', "vkid=%i AND slug='%s'", self.vkid, slug) then
            local achiv = module.achivs[slug]
            self:addMoneys(math.random(50000))
            self:addScore(math.random(1000))
            db("INSERT INTO unlocked_achivs VALUES(NULL, %i, '%s')", self.vkid, slug)

            local temp_path = temp.get_path("png")
            module.get_image(achiv.name, achiv.desc):write(temp_path)
            VK.messages.send {
                peer_id = self.vkid,
                attachment = upload.get("photo_messages", self.vkid, temp_path),
                message = "💖 Вы разблокировали новое достижение <<"..achiv.name..">>!\n#⃣ Введите `ачивки`, чтобы просмотреть список достижений."
            }
            temp.free_path(temp_path)
        end
    end

    function db.oop:unlockAchivCondition(slug, condition)
        if condition then self:unlockAchiv(slug) end
        return condition
    end

    module.achivs = dofile(root .. '/settings/achivs.lua')
end

function module.get_image (title, desc)
    local function draw_box(img, x, y, sx, sy)
        img:composite(magick.open_pseudo(math.floor(sx), math.floor(sy), "canvas:rgba(0, 0, 0, 0.5)"), math.floor(x), math.floor(y))
    end

    local img = magick.open(root.."/images/afon.png")

    -- Lines
    draw_box(img, 124, 36, 1024, 80)
    draw_box(img, 124, 36, 1024, 180)

    -- Icon
    local img_icon = magick.open(root.."/images/a/1.png")
    img_icon:resize(256, 256)
    img:composite(img_icon, 0, 0)

    -- Text
    img:set_font_align(1)
    img:set_font(root.."/res/segoeuilight.ttf")

    img:set_font_size(80)
    img:annotate("rgb(255,255,255)", title, 250, 102, 0)

    img:set_font_size(40)
    img:annotate("rgb(255,255,255)", desc, 250, 150, 0)

    return img
end

return module
