local command = botcmd.mnew("addbits", "тупа для доната", "<профиль> <кол-во>", "Ui", {dev=1,right="addbits"})

function command.exe (msg, args, other, rmsg, user, target, count)
	target:addMoneys(count)
    target:ls("💳 Вам зачислено %s бит.", comma_value(count))
    return "💳 Успех!"
end

return command
