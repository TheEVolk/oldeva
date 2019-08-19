local command = botcmd.mnew("краш", "Делаем ставки на обвал", "<ставка> <время обвала>", "ii")

function command.exe(msg, args, other, rmsg, user, count, time)
	ca(count >= 0, "я не играю на такие ставки")
    ca(count < user:getValue 'maxgame', "я не играю на такие ставки")
    user:checkMoneys(count)

    ca(time >= 20 and time <= 100, "предел времени: 20-100")

	local real_time = math.random(20, 100)
	while (math.random(20, 100) > 80) do real_time = math.random(real_time) end

    local calc = function (n, rt) return math.floor(n / 2000.0 * rt*rt) end
	if time <= real_time then -- Win
		user:unlockAchivCondition('sovpalo', time == real_time)
		user:addMoneys(calc(count, time), "Победа в краше")

		rmsg:lines(
			{ "🎉 Вы выиграли!" },
			{ "⏰ Время обвала: %i", real_time },
			{ "📈 На обвале: %s бит.", comma_value(calc(count, real_time)) }
		)
	else
		user:addMoneys(-count)
		db("UPDATE `keyvalue` SET `value`=`value`+%i WHERE `key`='bank';", count)
		rmsg:lines(
		{ "💸 Вы проиграли." },
		{ "⏰ Время обвала: %i", real_time },
		{ "📈 На обвале: %s бит.", comma_value(calc(count, real_time)) }
		)
	end
end

return command
