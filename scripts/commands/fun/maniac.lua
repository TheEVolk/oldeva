local command = botcmd.new("маньяк", "заменяет лицо на маньяка", {use="(картинка)"})

function command.exe(msg, args, other, rmsg, user)
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
		method = 'maniac',
		access_token = cvars.get 'vk_token'
	})

    print(rmsg.attachment)
    ca(rmsg.attachment ~= "noface", "на картинке, которую вы мне дали нет человеческого лица. Кого маньячить?")

    user:unlockAchiv('itsmax')
end

return command
