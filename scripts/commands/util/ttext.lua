local command = botcmd.mnew("ттекст", "генератор текста для подсказок", "<текст>", "d", {dev=1, right='photo'})

function command.exe(msg, args, other, rmsg, user, str)
    --str = "Заголовок"
    local image

    if msg.attachments[1] and msg.attachments[1].photo then
        image = msg.attachments[1].photo.sizes[#msg.attachments[1].photo.sizes].url
    end

    if not image and msg.fwd_messages[1] then
        if msg.fwd_messages[1].attachments[1] and msg.fwd_messages[1].attachments[1].photo then
            image = msg.fwd_messages[1].attachments[1].photo.sizes[#msg.fwd_messages[1].attachments[1].photo.sizes].url
        end
    end

    if image then
        local img_file = io.open(root.."/temp/"..user.vkid.."_photo.jpg", "w")
        img_file:write(net.send(image))
        img_file:close()
    else
        local img_file = assert(magick.open(root.."/images/citata_backs/"..math.random(18)..".jpg"))
        img_file:write(root.."/temp/"..user.vkid.."_photo.jpg")
    end

    local img = magick.open_pseudo(1024, 660, "canvas:rgb(0, 0, 0)")--assert(magick.open(root.."/temp/"..user.vkid.."_photo.jpg"))

    local back_img = magick.open(root.."/temp/"..user.vkid.."_photo.jpg")
    back_img:blur(10, 10)
    back_img:resize(1024, 660)
    img:composite(back_img, 0, 0)

    local white_img = magick.open(root.."/images/sphere.png")
    white_img:resize(128, 128)
    img:composite(white_img, 1024 - 128 - 20, 20)

    local person_img = magick.open(root.."/images/person.png")
    person_img:resize(128, 128)
    img:composite(person_img, 1024 - 128 - 20, 20)

    local bot_img = magick.open(root.."/images/bot.png")

    bot_img:set_bg_color("transparent")
	bot_img:distort(magick.distort_method["DePolarDistortion"], { 0 }, true)
	bot_img:distort(magick.distort_method["PolarDistortion"], { 0 }, true)
	bot_img:adaptive_resize(128, 128)
    local a = magick.open(root.."/images/sphere.png")
    a:resize(128, 128)
	bot_img:composite(a, 0, 0, magick.composite_op["DstInCompositeOp"])
	img:composite(bot_img, 20, 660 - 20 - 260)

    img:composite(
        magick.open_pseudo(1024 - 128 - 60, 260, "canvas:rgba(0, 0, 0, 0.5)"),
        20,
        20
    )

    img:composite(
        magick.open_pseudo(1024 - 128 - 60, 260, "canvas:rgba(0, 0, 0, 0.5)"),
        20 + 128 + 20,
        660 - 20 - 260
    )

    img:set_font_align(2)
    img:set_font(root.."/res/segoeuilight.ttf")

    local user_text = str:split('\n')[1] or "Сообщение пользователя"
    img:set_font_size(700 / (utf8.len(user_text) / 2))
    img:annotate("rgb(255,255,255)", user_text, 20 + (1024 - 128 - 60 - 20) / 2, 20 + 130 + 20, 0)

    local bot_text = str:split('\n')[2] or "Сообщение бота"
    img:set_font_size(700 / (utf8.len(bot_text) / 2))
    img:annotate("rgb(255,255,255)", bot_text, 40 + 128 + (1024 - 128 - 60 - 20) / 2, 20 + 130 + 10 + 260 + 130, 0)

--[[
    img:composite(
        magick.open_pseudo(1024, 260, "canvas:rgba(0, 0, 0, 0.5)"),
        0,
        (660 - 260) / 2
    )

    img:set_font_align(2)
    img:set_font(root.."/res/segoeuilight.ttf")

    img:set_font_size(100)
    img:annotate("rgb(255,255,255)", str:split('\n')[1], 1024 / 2, 660 / 2, 0)

    img:set_font_size(40)
    img:annotate("rgb(255,255,255)", str:split('\n')[2] or "описание", 1024 / 2, 400, 0)
]]
    img:write(root.."/temp/number_place.png")
    local p = photo_messages(msg.from_id, root.."/temp/number_place.png")
    rmsg.attachment = "photo"..p.owner_id.."_"..p.id
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

return command
