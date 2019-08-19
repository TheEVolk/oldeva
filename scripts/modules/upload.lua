-- VERSION: 01.02.2019
local module = {}

function module.photo_messages(peer_id, filename)
    if filename:starts("http://") or filename:starts("https://") then
        print("save "..filename)
        local _filename = filename
        filename = root.."/temp/"..peer_id.."_"..math.random(10)..".png"
        local file = io.open(filename, "w")
        file:write(net.send(_filename))
        file:flush()
        file:close()
    end

    local server_r = VK.photos.getMessagesUploadServer{peer_id=peer_id}
    if not server_r.response then
        if server_r.error.error_code == 901 then return '' end
        console.log(server_r.error.error_code, json.encode(server_r.error))
        os.execute("sleep 1")
        return module.photo_messages(peer_id, filename)
    end
    local server = server_r.response
    local loaded_file = net.jSend(server.upload_url, { ['@file'] = filename }, "multipart/form-data")

    local saved = VK.photos.saveMessagesPhoto(loaded_file)
    if not saved.response or not saved.response[1].id then
        console.log(saved.error.error_code, json.encode(loaded_file))
        db.get_user(admin):ls(json.encode(saved))
        os.execute("sleep 1")
        return module.photo_messages(peer_id, filename)
    end

    return saved.response[1]
end

function module.get(function_name, ...)
    assert_argument(function_name, "string")
    local p = module[function_name](...)
    return function_name:split("_")[1]..p.owner_id.."_"..p.id
end

return module
