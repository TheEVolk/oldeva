local command = botcmd.new("забив", "забив в боте", {dev=1})

zabiv_user = zabiv_user or nil

command:addsub("лечить", function (msg, args, other, rmsg, user)
    ca(zabiv_user[1] == user.vkid, "вы не на забиве :/")
    user:buy(5000)
    zabiv_user[2] = zabiv_user[2] + 500
    rmsg:line("💥 Вы пополнили здоровье на 500 HP >> %i", zabiv_user[2])
end)

function command.exe(msg, args, other, rmsg, user)
    user:buy(500)
	if not zabiv_user then
        zabiv_user = { user.vkid, math.random(user.force + 1000), 500 }
        rmsg:line "🐅 А на забиве никого! Вы пришли первый!"
        user:unlockAchiv('zabivnoy', rmsg)
        return
    end

    if zabiv_user[1] == user.vkid then
        rmsg:lines(
            "🌼 Нельзя напасть на самого себя!",
            "🎋 За то можно себя вылечить командой <<забив лечить>>"
        )

        return
    end

    rmsg:line("🦑 Вы дерётесь с %s", db.get_user(zabiv_user[1]):r())

    local force = math.random(user.force + 1000)
    zabiv_user[2] = zabiv_user[2] - force
    rmsg:line("💥 Вы отняли %i HP у противника.", force)

    if zabiv_user[2] > 0 then
        rmsg:line("🦍 Противник остался жив.")
        zabiv_user[3] = zabiv_user[3] + 300
        db.get_user(zabiv_user[1]):addMoneys(200)
        db.get_user(zabiv_user[1]):ls("💥 На вас напал %s и оставил вам %i HP\n💰 +200 бит.", user:r(), zabiv_user[2])
    else
        rmsg:line("🕸 Противник был побеждён!")
        user:addMoneys(zabiv_user[3] + 500)
        db.get_user(zabiv_user[1]):ls("💥 На вас напал %s и победил вас!", user:r())
        VK.messages.send { peer_id = 2000000002, message = string.format("💥 %s напал на %s и победил!\n>> Ева, забив", user:r(), db.get_user(zabiv_user[1]):r())}
        zabiv_user = { user.vkid, math.random(user.force + 1000), 500 }
        user:unlockAchiv('zabivnoy', rmsg)
    end
end

return command
