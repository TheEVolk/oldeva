local token = "2c0bc2d4c90d33d04909f2f620cbb37d8cb6774e2128566e823d945f120fbe76a87296d2cc00f7162002e"

local function get_course()
	local bdg = tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)
	local all = db.select_one("SUM(count)", "bank_contributions")["SUM(count)"]
	return math.max(10, math.floor(bdg/all))
end

local function upload_image(img)
    img:write(root.."/temp/widget.jpg")
    local server = VK.appWidgets.getGroupImageUploadServer{image_type="160x240",access_token=token}
    local loaded_file = net.jSend(server.response.upload_url, { ['@file'] = root.."/temp/widget.jpg" }, "multipart/form-data")
    return VK.appWidgets.saveGroupImage({ hash = loaded_file.hash, image = loaded_file.image, access_token = token}).response.id
end

function draw_text(img, text, x, y, size, align)
    img:set_font_size(size)
    img:set_font_align(align or 2)
    img:annotate("rgb(255,255,255)", text, x, y, 0)
end

timers.create(60000, 0, function()
    --[[local img0 = assert(magick.open(root.."/images/widget/0.png"))
    draw_text(img0, comma_value(online.get_count()).." чел.", 480 / 2, 720 / 2, 100, 2)

    local img1 = assert(magick.open(root.."/images/widget/1.png"))
    draw_text(img1, comma_value(get_course()).." бит", 480 / 2, 720 / 2, 100, 2)

    local img2 = assert(magick.open(root.."/images/widget/2.png"))
    draw_text(img2, comma_value(db.get_count('p_pets', 'issleep=1')).." пит.", 480 / 2, 720 / 2, 100, 2)

    local code = {
        title = "Статистика бота",
        tiles = {
            {
                title = "Онлайн бота",
                descr = "Игроки за 10 минут",
                icon_id = upload_image(img0)
            }, {
                title = "Курс ярика",
                descr = "Цена 1 ярика в битах",
                icon_id = upload_image(img1)
            }, {
                title = "Спящие питомцы",
                descr = "Кол-во спящих питомцев",
                icon_id = upload_image(img2)
            }
        }
    }

    VK.appWidgets.update {
        type = 'tiles',
        code = "return "..json.encode(code)..";",
        access_token = token
    }]]

	local acount = 0
	for k,v in pairs(achivs.achivs) do acount = acount + 1 end

	local allopendb = db.select_one('vkid', 'accounts', 'level > 2 AND (SELECT COUNT(id) FROM unlocked_achivs WHERE vkid = accounts.vkid) = %i ORDER BY RAND()', acount)
	local allopen = allopendb and db.get_user(allopendb.vkid) or db.get_user(1)
	local lastdonater = db.get_user(db.select_one('value', 'keyvalue', 'id=4').value)
	local lastcase = db.get_user(db.select_one('value', 'keyvalue', 'id=5').value)

	local code = {
        title = "Аллея славы",
        tiles = {
            {
                title = allopen.nickname,
                descr = "открыл все ачивки",
                icon_id = "id"..allopen.vkid,
				url = "vk.com/id"..allopen.vkid
            }, {
				title = lastdonater.nickname,
                descr = "последний донатер",
                icon_id = "id"..lastdonater.vkid,
				url = "vk.com/id"..lastdonater.vkid
            }, {
				title = lastcase.nickname,
                descr = "последний открыл кейс",
                icon_id = "id"..lastcase.vkid,
				url = "vk.com/id"..lastcase.vkid
            }
        }
    }

    VK.appWidgets.update {
        type = 'tiles',
        code = "return "..json.encode(code)..";",
        access_token = token
    }

    console.log("WD", "Обновлен виджет: "..vk.send('appWidgets.update', {
        type = 'tiles',
        code = "return "..json.encode(code)..";",
        access_token = token
    }))
end)
