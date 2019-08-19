local command = botcmd.new("баланс", "узнать свой баланс")

function command.exe(msg, args, other, rmsg, user)
	rmsg:line ("💳 Счёт: %s бит", user:getMoneys())
	if user.job ~= 0 then
		rmsg:line ("💼 Работа: %s", user:getJobName())
	end

	--numcmd.menu_funcs(rmsg, user, {{{ 1, "Купить биты", botcmd.commands['донат'].exe, "positive" }}})
end

return command
