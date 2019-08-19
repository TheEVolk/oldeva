local command = botcmd.new("вв", "тест виджета", {right="dodonat", dev=1})
local token = "2c0bc2d4c90d33d04909f2f620cbb37d8cb6774e2128566e823d945f120fbe76a87296d2cc00f7162002e"

local function get_course()
	local bdg = tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)
	local all = db.select_one("SUM(count)", "bank_contributions")["SUM(count)"]
	return math.max(10, math.floor(bdg/all))
end

local function upload_image(img)
    img:write(root.."/temp/widget.jpg")
    local server = VK.appWidgets.getGroupImageUploadServer{image_type="160x240",access_token=token}
    console.log("LIVEWIDGET", json.encode(server))
    local loaded_file = net.jSend(server.response.upload_url, { ['@file'] = root.."/temp/widget.jpg" }, "multipart/form-data")
    return VK.appWidgets.saveGroupImage({ hash = loaded_file.hash, image = loaded_file.image, access_token = token}).response.id
end

function command.exe(msg, args, other, rmsg, user)
    local img0 = assert(magick.open(root.."/images/widget/0.png"))
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

    return json.encode(VK.appWidgets.update {
        type = 'tiles',
        code = "return "..json.encode(code)..";",
        access_token = token
    })
end


return command
