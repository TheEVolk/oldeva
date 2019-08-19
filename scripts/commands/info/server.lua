local command = botcmd.new("майн", "информация о майнкрафт сервере", {dev=1})

command:addmsub("купить", "<никнейм> <кол-во>", "si", function(msg, args, other, rmsg, user, nickname, count)
    ca(count >= 50, "минимум - 100 рублей на сервере");
	ca(nickname:find(' ') == nil, "в никнейме не должно быть пробелов")

    user:checkMoneys(count * 50);
    user:addMoneys(-count * 50);

	print(string.format("mcrcon -H vs1-vps.weryskok.space -p GVOxa8g5U6xR6bXNCNICdLTmJBtaJmfP \"eco give %s %i\"", nickname, count))
	os.execute(string.format("mcrcon -H vs1-vps.weryskok.space -p GVOxa8g5U6xR6bXNCNICdLTmJBtaJmfP \"eco give %s %i\"", nickname, count))

	rmsg:line("💱 Вы купили %s руб. на сервере за %s бит.", comma_value(count), comma_value(count * 50))
end)

command.exe = function (msg, args, other, rmsg)
	local status = net.jSend('https://mcapi.us/server/status?ip=vanillaskymc.ru&port=25565')

	rmsg:lines(
		"💻 VanillaSky [1.13.2]",
		"📡 IP: vanillaskymc.ru",
		{ "🕹 Онлайн: %i/%i", status.players.now, status.players.max }
	)
end

return command
