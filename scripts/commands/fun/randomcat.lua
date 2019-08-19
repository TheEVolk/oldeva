local command = botcmd.new("котик", "случайный котик")

function command.exe(msg, args, other, rmsg)
    local image_url = net.jSend("https://api.thecatapi.com/v1/images/search")[1].url
    return { attachment = upload.get("photo_messages", msg.peer_id, image_url), message = "Держи котейку ^-^" }
end

return command
