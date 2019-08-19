local command = botcmd.new("лиса", "случайная лиса")

function command.exe(msg, args, other, rmsg)
    local image_url = net.jSend("https://randomfox.ca/floof/").image:gsub("http", "https")
    return { attachment = upload.get("photo_messages", msg.peer_id, image_url), message = "Держи лисичку ^-^" }
end

return command
