local command = botcmd.mnew("свадьба", "устроить свадьбу", "<цель>", "U")
command.braks = {}

command:addsub("развод", function(msg, args, other, rmsg, user, bid)
    ca (user.married ~= 0, "вы не в браке")

    db.get_user(user.married):ls("%s разорил брак с вами", user:r())
    db.get_user(user.married):set('married', 0)
    user:set("married", 0)

    return "Вы только что развелись."
end)

command:addmsub("подтвердить", "<номер>", "i", function(msg, args, other, rmsg, user, bid)
    ca (user.job == 38, "вы не Работник ЗАГСа")
    local brak = ca(command.braks[bid], "мы не нашли брака с таким ID")
    brak[1]:checkMoneys(250000, "у создателя свадьбы нет 250'000 бит")
    brak[1]:buy(250000)

    command.braks[bid] = nil
    brak[1]:set('married', brak[2].vkid)
    brak[2]:set('married', brak[1].vkid)

    user:addMoneys(20000)

    rmsg:lines({"💍 %s и %s теперь состоят в браке!", brak[1]:r(), brak[2]:r()}, "💑 Можете поцеловаться!")
end)

function command.exe(msg, args, other, rmsg, user, target)
    ca(target.vkid ~= user.vkid, "жениться на самом себе нельзя :)")
    user:checkMoneys(250000)

    local qid = inv.create(user, target, command.accept)
    rmsg:line("💍 Вы хотите брак с %s", target:r())
    inv.lines(rmsg, qid, target)
end

function command.accept (target, source, rmsg)
    ca (target.married == 0 and source.married == 0, "ни один из возлюбленных не должен быть в браке")
	source:checkMoneys(250000, "у него свадьбы нет 250'000 бит")
    --source:addMoneys(250000)

    local bid = math.random(9000) + 999;
    command.braks[bid] = { source, target }

    rmsg:lines(
        { "🎀 %s 💞 %s", source:r(), target:r() },
        { "💍 Работник ЗАГСа должен подтвердить ваш брак командой:" },
        { "💖 свадьба подтвердить %i", bid }
    )
end

return command
