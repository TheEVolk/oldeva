local command = botcmd.mnew("вп", "картинка для важных", "<имя>", "d", {dev=1})

function loadImages()
    local images_response = VK.photos.get { owner_id = -134466548, album_id = 262950763, access_token = evatoken, count = 1000 }.response
    local result = {}
    for i,v in ipairs(images_response.items) do
        result[v.text] = "photo"..v.owner_id.."_"..v.id
    end
    return result
end

command.images = command.images or loadImages()

command:addsub("rl", function(msg, args, other, rmsg, user)
    command.images = loadImages()
    return "Loaded images."
end)

function command.exe(msg, args, other, rmsg, user, str)
    return { attachment = ca(command.images["Ева, вп " .. str], "ищите мемы в альбоме >> https://vk.com/album-134466548_262950763") }
end

return command
