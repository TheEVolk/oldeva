local command = botcmd.new("админы", "список ТПБ")

local function printlist (rmsg, right, title)
	rmsg:line(title..":")
	local members = db.select("smile,vkid,nickname", db.acctable, "`role` = '%s'", right)
	for i = 1,#members do rmsg:line("%s %s", members[i].smile, names.dbr(members[i])) end
end

function command.exe (msg, args, other, rmsg, user)
    rmsg:line ("❔ [evabottp|Тех. Поддержка]")
	printlist(rmsg, 'mainadmin', "⬛ Главный админ")
	printlist(rmsg, 'admin', "⚫ Администрация")
	printlist(rmsg, 'moderator', "▪ Модерация")
end

return command
