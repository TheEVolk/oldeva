timers.create(60000, 0, function()
    -- Получаем нужную инфу
    local accounts_count = db.get_count("accounts")
    local online_count = online.get_count()

    local img = assert(magick.open(root.."/images/cover.png"))

    draw_box(img, 0, 50, 1590, 100)
    draw_box(img, 0, 155, 1590, 100)
    draw_box(img, 0, 260, 1590, 100)

    draw_text(img, "Пользователей", 250, 115, 50, 1)
    draw_text(img, comma_value(accounts_count), 1590 - 300, 120, 64, 3)

    draw_text(img, "Онлайн", 250, 220, 50, 1)
    local online_text = string.format("%i (%.2f%%)", comma_value(online_count), online_count/accounts_count*100)
    draw_text(img, online_text, 1590 - 300, 225, 64, 3)

    draw_text(img, "Всего бит", 250, 325, 50, 1)
    draw_text(img, comma_value(db.select_one("SUM(balance)", "accounts")["SUM(balance)"]), 1590 - 300, 330, 64, 3)

    img:write(root.."/temp/cover.jpg")

    local server = VK.photos.getOwnerCoverPhotoUploadServer{group_id=cvars.get'vk_groupid',crop_x2=1590,crop_y2=400}
    local loaded_file = net.jSend(server.response.upload_url, { ['@file'] = root.."/temp/cover.jpg" }, "multipart/form-data")
    VK.photos.saveOwnerCoverPhoto(loaded_file)
    console.log("LIVECOVER", "Обновлена живая обложка.")
end)

function draw_box(img, x, y, sx, sy)
    img:composite(magick.open_pseudo(math.floor(sx), math.floor(sy), "canvas:rgba(0, 0, 0, 0.5)"), math.floor(x), math.floor(y))
end

function draw_text(img, text, x, y, size, align)
    img:set_font_size(size)
    img:set_font_align(align or 2)
    img:annotate("rgb(255,255,255)", text, x, y, 0)
end
