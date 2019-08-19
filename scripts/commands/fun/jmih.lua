local command = botcmd.new("жмых", "жмыхает картинку", {use="(картинка)"})

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

    ca(image, "прикрепите картинку или перешлите сообщение с картинкой.\nДанная команда может не работать из-за проблем на сервере. Приносим извинения. (эта команда есть тут >> @bonbot")

	rmsg.attachment = net.send('http://elektro-volk.ru/image_filters/do.php', {
		img = image,
		method = 'jmih',
		access_token = cvars.get 'vk_token'
	})

    rmsg:line("Так же попробуйте команду: <<жмыхфейс>>");
    user:unlockAchiv('jmihnulo', rmsg)
end

return command
