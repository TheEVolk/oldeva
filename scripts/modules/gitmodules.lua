local module = {}

function module.start()
    --module.install_module("https://github.com/ebpmodules/hooks")
end

function module.install_module(giturl, target)
    target = target or "master"

    assert_argument(giturl, "string")
    assert_argument(target, "string")

    if giturl:starts("https://") then giturl = giturl:sub(9) end
    if giturl:starts("github.com/") then giturl = giturl:sub(12) end
    assert(string.match(giturl, "[_%-%.%a%d]+/[_%-%.%a%d]+", 1) == giturl)

    console.log("GITMODULES", "Поиск `%s` на github...", giturl)
    local status, repo = pcall(net.jSend, "https://api.github.com/repos/"..giturl)
    assert(status, "repository `"..giturl.."` not found")

    local commits = net.jSend("https://api.github.com/repos/"..giturl.."/commits")

    local status, settings = pcall(net.jSend, "https://raw.githubusercontent.com/"..giturl.."/"..target.."/.ebpmodule.json")
    assert(status, "module `"..giturl.."` not found")
    -- Check fields
    assert(settings.file)

    console.log("GITMODULES", "Загрузка `%s`...", settings.file)
    local status, file_data = pcall(net.send, "https://raw.githubusercontent.com/"..giturl.."/"..target.."/"..settings.file)
    assert(status, "file `"..settings.file.."` not found")

    --assert(not file_exists(root.."/scripts/modules/"..settings.file), "module `"..settings.file.."` exists")
    local file = io.open(root.."/scripts/modules/"..settings.file, "w")
    file:write("-- Loaded from GITMODULES\n")
    file:write("-- URL: "..giturl.."\n")
    file:write("-- Commit: "..commits[1].sha.."\n")
    file:write("-- Message: "..commits[1].commit.message.."\n")
    file:write(file_data)
    file:close()
end

function module.get_updates()

end

return module
