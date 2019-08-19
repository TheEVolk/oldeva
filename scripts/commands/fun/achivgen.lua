local command = botcmd.mnew("ачген", "генератор ачивок", "<текст>", "d", {dev=1})

function command.exe(msg, args, other, rmsg, user, str)
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
    img:annotate("rgb(255,255,255)", str:split('\n')[1] or "Заголовок достижения", 250, 102, 0)

    img:set_font_size(40)
    img:annotate("rgb(255,255,255)", str:split('\n')[2] or "перенеси описание на вторую строчку", 250, 150, 0)

    -- Upload
    local temp_path = temp.get_path("png")
    img:write(temp_path)
    rmsg.attachment = upload.get("photo_messages", msg.peer_id, temp_path)
    temp.free_path(temp_path)

    user:unlockAchiv('achman')
end

return command
