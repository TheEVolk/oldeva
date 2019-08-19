local command = botcmd.new("он", "двойные мемы", {use="(картинка) (картинка)", dev=1, right='dev'})

function command.exe(msg, args, other, rmsg, user)
    --[[ca(msg.attachments, "прикрепите 2 картинки к сообщению")
    local image1
    local image2

    if msg.attachments[1].photo and msg.attachments[2].photo then
        image1 = msg.attachments[1].photo.sizes[#msg.attachments[1].photo.sizes].url
        image2 = msg.attachments[2].photo.sizes[#msg.attachments[2].photo.sizes].url
    end
rmsg.attachments = {image1, image2}]]
return chat.active_users
end

return command
