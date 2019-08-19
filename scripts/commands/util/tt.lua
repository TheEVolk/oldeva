local command = botcmd.mnew("птекст", "генератор текста для поста", "<текст>", "d", {dev=1, right='photo'})

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

    ca(image, "прикрепите картинку или перешлите сообщение с картинкой")

    local img_file = io.open(root.."/temp/"..user.vkid.."_photo.jpg", "w")
    img_file:write(net.send(image))
    img_file:close()
    local img = magick.open_pseudo(1024, 660, "canvas:rgb(0, 0, 0)")--assert(magick.open(root.."/temp/"..user.vkid.."_photo.jpg"))

    local back_img = magick.open(root.."/temp/"..user.vkid.."_photo.jpg")
    back_img:blur(10, 10)
    back_img:resize(1024, 660)
    img:composite(back_img, 0, 0)

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
    img:annotate("rgb(255,255,255)", str:split('\n')[2] or "", 1024 / 2, 400, 0)

    -- Water
    local bns_img = magick.open(root.."/images/bns.png")
    bns_img:resize(64, 64)
    img:composite(bns_img, 20, 660 - 64 - 10)

    local ev_img = magick.open(root.."/images/ev.png")
    ev_img:resize(64, 64)
    img:composite(ev_img, 20 + 15 + 64, 660 - 64 - 10)


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
