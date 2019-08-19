local command = botcmd.mnew("фтекст", "текст на фото", "<текст> (картинка)", "d")

function command.exe(msg, args, other, rmsg, user, text)
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

	rmsg.attachment = net.send('http://elektro-volk.ru/image_filters/do.php', {
		img = image,
		text = text,
		method = 'text',
		access_token = cvars.get 'vk_token'
	})

    user:unlockAchiv('mymem', rmsg)
end

return command
