local module = {}

function module.dialog(peer_id, user_text_str, bot_response_str)
    local img_file = assert(magick.open(root.."/images/citata_backs/"..math.random(18)..".jpg"))
    img_file:write(root.."/temp/help_photo.jpg")

    local img = magick.open_pseudo(1024, 660, "canvas:rgb(0, 0, 0)")--assert(magick.open(root.."/temp/"..user.vkid.."_photo.jpg"))

    local back_img = magick.open(root.."/temp/help_photo.jpg")
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

    img:composite(magick.open_pseudo(1024 - 128 - 60, 260, "canvas:rgba(0, 0, 0, 0.5)"), 20, 20)
    img:composite(magick.open_pseudo(1024 - 128 - 60, 260, "canvas:rgba(0, 0, 0, 0.5)"), 20 + 128 + 20, 660 - 20 - 260)

    img:set_font_align(2)
    img:set_font(root.."/res/segoeuilight.ttf")

    img:set_font_size(700 / (utf8.len(user_text_str) / 2))
    img:annotate("rgb(255,255,255)", user_text_str, 20 + (1024 - 128 - 60 - 20) / 2, 20 + 130 + 20, 0)

    img:set_font_size(700 / (utf8.len(bot_response_str) / 2))
    img:annotate("rgb(255,255,255)", bot_response_str, 40 + 128 + (1024 - 128 - 60 - 20) / 2, 20 + 130 + 10 + 260 + 130, 0)


    img:write(root.."/temp/number_place.png")
    return upload.get("photo_messages", peer_id, root.."/temp/number_place.png")
end

return module
