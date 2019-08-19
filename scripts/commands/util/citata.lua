local command = botcmd.new("цитата", "цитата в рамочке", {use = '(пересланные сообщения)', dev = 1})

local ms = { "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря" }

function command.exe(msg, args, other, rmsg, user)
    local text = ''--'Some very long text A straight spreading of a font color using "-blur" operator. This operator allows you to take a image and spread it out in all directions. This allows you to generate softer looking shadows, and or spray paint like effects. The following exa'

	for i = 1, #msg.fwd_messages do
        text = text .. msg.fwd_messages[i].text .. (i~=#msg.fwd_messages and '\n' or '')
    end

	ca(string.len(text) > 0, "прикрепите сообщение с текстом");
	local target = (msg.fwd_messages[1].from_id > 0 and VK.users.get { user_ids = msg.fwd_messages[1].from_id, fields = 'photo_200' } or VK.groups.getById { group_id = -msg.fwd_messages[1].from_id, fields = 'photo_200' }).response[1];

    local owner_photo = target.photo_200--'https://pp.userapi.com/c849320/v849320729/160b2b/0ElBBflfQOc.jpg'
    local title = target.name or target.first_name..' '..target.last_name--"Ева Цифрова | Игровой бот"
    if #title:split(' ') > 1 then title = title:split(' ')[1]..' '..title:split(' ')[2] end
    local date_str = os.date("!%d", os.time()).." "..ms[tonumber(os.date("!%m", os.time()))].." "..os.date("!%Y", os.time()).." г."

    local img = assert(magick.open(root.."/images/citata_backs/"..math.random(18)..".jpg"))
    img:blur(10, 5)

    -- Для начала подготовим блоки
    draw_box(img, 20, 200, 350, 290)
    draw_box(img, 350 + 80, 30, 500, 80)
    draw_box(img, 350 + 80, 30, 500, 460)

    -- Аватарка
    local img_file = io.open(root.."/temp/"..user.vkid.."_photo.jpg", "w")
    img_file:write(net.send(owner_photo))
    img_file:close()
    local owner_photo_img = magick.open(root.."/temp/"..user.vkid.."_photo.jpg")

    owner_photo_img:set_bg_color("transparent")
	owner_photo_img:distort(magick.distort_method["DePolarDistortion"], { 0 }, true)
	owner_photo_img:distort(magick.distort_method["PolarDistortion"], { 0 }, true)
	owner_photo_img:adaptive_resize(350, 350)
	owner_photo_img:composite(magick.open(root.."/images/sphere.png"), 0, 0, magick.composite_op["DstInCompositeOp"])
	img:composite(owner_photo_img, 20, 30)

    img:set_font(root.."/res/segoeuilight.ttf")

    draw_text(img, title, 350 / 2 + 20, 512 - 80, 600 / utf8.len(title))
    draw_text(img, date_str, 350 / 2 + 20, 512 - 40, 26)
    --img:set_font_style(magick.font_style["ObliqueStyle"])
    draw_text(img, "Цитаты великих людей...", 350 + 80 + 500 / 2, 80, 44)

    --[[img:composite(
        magick.open_pseudo(500, 500, "magick:logo,label:\""..text.."\""),
        350 + 80,
        90
    )]]

    local width_text = 30
    local words = text:split(' ')
	local resp = ""
    local line = ""
    for k,v in ipairs(words) do
        line = line .. v .. " "
        if #line >= width_text or k == #words then
            resp = resp .. line .. "\n"
            line = ""
        end
    end

    draw_text(img, resp, 350 + 80 + 40, 150, 30, 1)

    -- Watermark
    img:set_font_size(14)
    img:set_font_align(1)
    img:annotate("rgb(0,0,0)", "@evarobotgroup", 350 + 80 + 5, 512 - 30, 0)

    img:write(root.."/temp/citata.png")
    rmsg.attachment = upload.get("photo_messages", msg.peer_id, root.."/temp/citata.png")
    --local p = photo_messages(msg.from_id, root.."/temp/citata.png")
    --rmsg.attachment = "photo"..p.owner_id.."_"..p.id
end

local function draw_box(img, x, y, sx, sy)
    img:composite(magick.open_pseudo(math.floor(sx), math.floor(sy), "canvas:rgba(0, 0, 0, 0.5)"), math.floor(x), math.floor(y))
end

local function draw_text(img, text, x, y, size, align)
    img:set_font_size(size)
    img:set_font_align(align or 2)
    img:annotate("rgb(255,255,255)", text, x, y, 0)
end

local function photo_messages(peer_id, filename)
    local server = VK.photos.getMessagesUploadServer{peer_id=peer_id}.response
    local loaded_file = net.jSend(server.upload_url, { ['@file'] = filename }, "multipart/form-data")
    local saved = VK.photos.saveMessagesPhoto(loaded_file)
    if not saved.response then
        console.log(saved.error.error_code, json.encode(loaded_file))
        os.execute("sleep 1")
        return module.photo_messages(peer_id, filename)
    end
    return saved.response[1]
end


return command;
