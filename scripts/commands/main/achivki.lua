local command = botcmd.new("ачивки", "система ачивок", {dev=1})

function command.exe(msg, args, other, rmsg, user)
    rmsg:line("💡 Ваши достижения:")
    local my_achivs = {}
    for k,v in pairs(achivs.achivs) do
        table.insert(my_achivs, { v, db.select_one('id', 'unlocked_achivs', "vkid=%i AND slug='%s'", user.vkid, k) ~= nil })
    end

    table.sort(my_achivs, function(a,b) return a[2] and not b[2] end)

    for k,v in ipairs(my_achivs) do
        rmsg:line("► %s %s.\n↳ %s.", v[2] and '✔' or '❌', v[1].name, v[1].desc)
    end

    rmsg:line("\nvk.com/@evarobotgroup-atut")
end

return command
