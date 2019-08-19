--[[
    Принудительная смена роли.
    botcmd.mnew("команда", "описание", "инструкция", "аргументы", "смайл"[, { ... }])
]]
local command = botcmd.mnew("сетроль", "изменить роль пользователя", "<цель> [роль]", "U", {right="setrole"})

function command.exe(msg, args, other, rmsg, user, target)
	local newrole = args[3] or 'default'
	ca (rights.roles[newrole], "такого права не бывает")
	ca (user:isRight ('setrole.'..newrole), "вы не можете ставить такое право")
	ca (user:isRight ('setrole.'..target.role), "вы не можете снимать с такого права")

	rmsg:lines(
		{ "🎫 %s", target:r() },
		{ "📝 %s » %s", target:getRoleName(), rights.roles[newrole].screenname }
	)
	target:ls('📝 Вам выдана роль %s пользователем %s.', rights.roles[newrole].screenname, user:r())
	target:set('role', newrole=='default' and '' or newrole)
end

return command