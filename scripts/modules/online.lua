local module = {}
module.users = {}
module.time = 600

function module.start()
    hooks.add_action("bot_post", function(msg, other, user, rmsg)
        module.users[user.vkid] = os.time()
    end)
end

function module.get_count()
    local online_count = 0
    for k,v in pairs(module.users) do
        if v + module.time >= os.time() then
            online_count = online_count + 1
        end
    end

    return online_count
end

function module.is_online(vkid)
    return module.users[vkid] and module.users[vkid] + module.time >= os.time() 
end

return module
