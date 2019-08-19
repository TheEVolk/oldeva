local command = botcmd.new("бонус", "ежедневный бонус")

function command.exe(msg, args, other, rmsg, user)
	local last = db.select_one('last', 'daily_bonus', "`vkid` = %i AND `last` + 86400 > %i", user.vkid, os.time())
	if last then
		botcmd.cmd_error(os.date("!до следующего бонуса %H часов %M минут %S секунд.", 86400 - os.time() + last.last))
	end

	db("DELETE FROM `daily_bonus` WHERE `vkid` = %i", user.vkid)
	db("INSERT INTO `daily_bonus`(`last`, `vkid`) VALUES (%i, %i)", os.time(), user.vkid)
	user:addMoneys(math.random(1000))
	rmsg:line "🎁 Вы получили бонус!"
	rmsg:line "\n💡 Введите `кейс`, чтобы начать открывать кейсы."
end

return command;
