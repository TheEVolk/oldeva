local command = botcmd.new("инвест", "Игра в инвестиции", {dev=1})

command.sub = {
    ['ставка'] = { '<кол-во>', 'i', function (msg, args, other, rmsg, user, count)
		ca(count > 10, "я не ставлю всю зарплату админa");
		user:buy(count)
    db("UPDATE `keyvalue` SET `value`=`value`+%i WHERE `key`='bank';", count)
		if db("SELECT id FROM `invest` WHERE vkid = %i", user.vkid)[1] then
			db("UPDATE `invest` SET `count` = `count` + %i WHERE vkid = %i", count, user.vkid);
		else
			db("INSERT INTO `invest`(`count`, `vkid`) VALUES (%i, %i)", count, user.vkid);
		end

		local rate = db("SELECT count FROM `invest` WHERE vkid = %i", user.vkid)[1].count;
		rmsg:lines (
    { "✳ Вы успешно сделали ставку!" },
		{ "🌝 Ваша ставка %s бит", comma_value(rate) },
		{ "⏳ До игры %s", os.date("!%M минут %S секунд", 3600 - os.time()%3600) }
    )
    end }
};

function command.exe(msg, args, other, rmsg, user)
	local rates_count = #db("SELECT id FROM `invest`");
    rmsg:lines (
      { "⏳ До следующей игры осталось %s", os.date("!%M минут %S секунд", 3600 - os.time()%3600) },
      { "🙇 Ставок >> %i", rates_count },
      { "🔥 Выигрывает тот, чья ставка ближе всего к средней. Победитель забирает всё из инвестиций." },
      { "❕ Вы можете сделать свою ставку:" },
      { "➡ инвест ставка <ставка>" }
    )
	-- X = (A + X) / 2;
    --
	local recount = math.min(tonumber(user.balance), rates_count > 0 and  tonumber(db("SELECT SUM(count) FROM `invest`")[1]['SUM(count)']) or 5000);
	rmsg.keyboard = [[{"one_time": true,"buttons": [ [{"action": {"type": "text","label": "инвест ставка ]] .. recount .. [["},"color": "default"}] ]}]]
end

return command;
