local command = botcmd.mnew("слот", "Игровой автомат Слот", "<ставка>", "i", {dev=1})

command.smiles = { '🍌', '🍞', '🍒', '🍔', '🍦', '🍪', '7⃣', '🌶', '🌯', '🧀' };

function command.exe(msg, args, other, rmsg, user, count)
--ca(false, 'упс, похоже слот роняет экономику. Скоро исправим <3')
    ca (count > 10, "я не играю на всю зарплату админa")
    ca(user:getValue 'maxlot' >= count, "вы не можете ставить так много бит")
	user:checkMoneys(count)

	local results = { math.random(1, 10), math.random(1, 10), math.random(1, 10) };
    if math.random(100) > 100 - user:getValue 'slotadd' then results[2] = results[1] end
    if math.random(100) > 100 - user:getValue 'slotadd' then results[3] = results[2] end

	local win = -1;
	if (results[1]-1 > 0 and results[1]-1 or results[1]+9) == results[2] and results[2] == (results[3]+1 < 11 and results[3]+1 or results[3]-9) then win = win + 10 end
	if (results[3]-1 > 0 and results[3]-1 or results[3]+9) == results[2] and results[2] == (results[1]+1 < 11 and results[1]+1 or results[1]-9) then win = win + 10 end

	if results[1] == results[2] and results[1] == results[3] then win = win + 15; if results[1] == 7 then win = win + 15 end end
	if results[1] == results[3] then win = win + 2 end

    -- Азаза
    if count * win > keyvalue.get_integer('bank') / 6 then
        win = -1
        results[1] = results[3] + 1
        if results[1] > 10 then results[1] = 1 end
    end

    -- Азаза
    if math.random(100) > 100 - (user.balance / 700000000 * 100) then
        win = -1
        results[1] = results[3] + 1
        if results[1] > 10 then results[1] = 1 end
    end

    keyvalue.set('bank', keyvalue.get_integer('bank') - count * win)
	user:addMoneys(count * win)
    user:unlockAchivCondition('777', results[1] == 7 and results[2] == 7 and results[3] == 7)
    user:unlockAchivCondition('77lol', results[1] == 7 and results[2] == 7 and results[3] ~= 7)

	rmsg:line(
		"⚪ %s %s %s",
		 command.smiles[results[1]-1 > 0 and results[1]-1 or results[1]+9],
		 command.smiles[results[2]-1 > 0 and results[2]-1 or results[2]+9],
		 command.smiles[results[3]-1 > 0 and results[3]-1 or results[3]+9]
	);

	rmsg:line("➡ %s %s %s",  command.smiles[results[1]], command.smiles[results[2]], command.smiles[results[3]]);

	rmsg:line(
		"⚪ %s %s %s",
		 command.smiles[results[1]+1 < 11 and results[1]+1 or results[1]-9],
		 command.smiles[results[2]+1 < 11 and results[2]+1 or results[2]-9],
		 command.smiles[results[3]+1 < 11 and results[3]+1 or results[3]-9]
	);

    if math.random(100) >= 80 then
        rmsg:line("\n💡 Любишь испытывать удачу? Попробуй команду `кейс` прямо сейчас!")
        oneb(rmsg, "кейс")
    end

    if user.balance > 0 then
	       --oneb(rmsg, "слот %i", math.random(math.min(user.balance, user:getValue 'maxlot')));
    end
end

return command;
