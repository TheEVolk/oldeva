local command = botcmd.new("помощь", "помощь по боту", {dev=1})


function command.exe (msg, args, other, rmsg, user)
	rmsg:lines(
		"🎮 Как играть » \nvk.com/@evarobotgroup-start",
		"💰 Донат » \nvk.com/market-134466548",
		"🛎 @evabottp(Здесь тебе помогут).",

		"\n💡 Введите `команды`, чтобы получить список доступных команд в боте."
	)
end

return command
