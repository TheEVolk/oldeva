local command = botcmd.mnew("смайл", "сменить смайл", "<смайл>", "s", {right='smile'})

function command.exe(msg, args, other, rmsg, user, smile)
	ca(#smile == 4 and smile:byte() == 240, "это не смайл")
	user:set("smile", smile)
	rmsg:line("%s Вы успешно изменили свой смайл!", smile)
end

return command
