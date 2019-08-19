local command = botcmd.mnew("кф", "подкидывание монетки", "<профиль> [ставка = 500]", "U", {dev=1})

function command.exe (msg, args, other, rmsg, user, target)
	local rate = tonumber(args[3]) or 500
	local a, b = math.modf(rate)
	ca(b == 0, "принимается только целочисленное значение")
	ca(rate >= 0, "я не играю на такие ставки")
	rate = a
    --ca(rate < user:getValue 'maxgame', "я не играю на такие ставки")
    user:checkMoneys(rate)

	ca(target.vkid ~= user.vkid, "это как? Сам с собой?")

	local qid = inv.create(user, target, command.accept, rate)
	rmsg:line("🌗 %s 🆚 %s", user:r(), target:r())
	rmsg:line("💰 Ставка >> %s бит.", comma_value(rate))
	inv.lines(rmsg, qid, target)
end

function command.accept (target, source, rmsg, rate)
	target:checkMoneys(rate)
	source:checkMoneys(rate, "оппонент успел потратить свои биты")

	source:unlockAchivCondition('coinflip', rate >= 10000)
	target:unlockAchivCondition('coinflip', rate >= 10000)

	local winner = randomorg.get_int(0, 100) > 50 and source or target

	if (winner==source and target or source).vkid == 313349904 then winner = winner==source and target or source end

	local looser = winner==source and target or source

	winner:add('balance', math.ceil(rate*0.9))
	db("UPDATE `keyvalue` SET `value`=`value`+%i WHERE `key`='bank';", math.ceil(rate-(rate*0.9)))
	looser:add('balance', -rate)
	--winner:addMoneys(rate)
	--(winner==source and target or source):addMoneys(rate)

	rmsg:lines(
		{ "🌗 %s 🆚 %s", source:r(), target:r() },
		{ "💰 Ставка >> %s бит;", comma_value(rate) },
		{ "✳ Победитель >> %s.", winner:r() }
	)
end

return command