local command = botcmd.mnew("перевозки", "система перевозок", "<город>", "s", {dev=1})

command:addmsub("взять", "<номер перевозки> <гос. номер>", "is", function (msg, args, other, rmsg, user, tid, gosnum)
    local obj = ca(db.select_one("*", "tr_obj", "`gosnum`='%s'", gosnum), "транспорт с таким номером не найден")
    local t = ca(db.select_one("*", "tr_transportations", "id=%i", tid), "перевозка не найдена", "перевозки")

    ca(obj.pos > 0, "транспорт уже в дороге")
    ca(t.owner == 0, "эта перевозка уже занята")
    ca(obj.pos == t.from, "транспорт должен быть в точке взятия перевозки")

    db(
        "UPDATE `tr_transportations` SET `endtime` = %i, `tid` = %i, `owner` = %i WHERE `id` = %i",
        os.time() + t.timeout,
        obj.id,
        user.vkid,
        t.id
    )

    rmsg:lines(
        { "🌆 Вы успешно взяли перевозку %s - %s;", transport.cities[t.from].name, transport.cities[t.to].name },
        { "🚘 Автомобиль: %s [%s];", obj.gosnum, transport.full_name(obj) },
        { "⌛ Времени на доставку: %s.", os.date("!%H часов %M минут", t.timeout) },
        "", { "*️⃣ Введите <<тр маршрут %s %s>>, чтобы ваш автомобиль поехал до цели.", obj.gosnum, transport.cities[t.to].name }
    )

    user:unlockAchiv('dalnoboy', rmsg)

    oneb(rmsg, "тр маршрут %s %s", obj.gosnum, transport.cities[t.to].name)
end)

command:addmsub("инфо", "<номер перевозки>", "i", function (msg, args, other, rmsg, user, tid)
    local t = ca(db.select_one("*", "tr_transportations", "id=%i", tid), "перевозка не найдена", "перевозки")

    rmsg:lines(
        { "🌆 Перевозка №%i", t.id },
        { "🚘 %s - %s", transport.cities[t.from].name, transport.cities[t.to].name },
        { "💰 Платят: %s бит.", comma_value(t.bonus) },
        { "⌛ Срок: %s.", os.date("!%H часов %M минут", t.timeout) }
    )

    if t.owner == 0 then
    	local tr = db.select_one("*", "tr_obj", "owner=%i AND pos=%i", user.vkid, t.from)
    	if tr then
            rmsg:line("\n💡 Воспользуйтесь командой `перевозки взять %i %s`, чтобы взять эту перевозку на ваш %s.", t.id, tr.gosnum, transport.full_name(tr))
            oneb(rmsg, "перевозки взять %i %s", t.id, tr.gosnum)
        end
    else
        rmsg:line("\n💡 Эта перевозка занята игроком %s.", db.get_user(t.owner):r())
        oneb(rmsg, "перевозки %s", transport.cities[t.from].name)
    end
end)

function command.exe(msg, args, other, rmsg, user, city_name)
    local city = ca(transport.find_city(city_name), "город не найден.", "тр")

    local transportations = db.select("*", "tr_transportations", "owner=0 AND `from`=%i ORDER BY bonus DESC", city.id)
    ca(#transportations > 0, "перевозки кончились, пишите позже :)", "тр")

    numcmd.linst(user, function(msg, num, other, rmsg, user)
        local item = ca(transportations[num], "перевозка не найдена")
        command.sub['инфо'][3](msg, {num}, other, rmsg, user, item.id)
    end)

	rmsg:line ("🚚 Перевозки из <<%s>>", city.name)
	for i = 1, #transportations do
		local t = transportations[i];
		rmsg:line (
            "► %i. %s [%s бит].",
            i,
            transport.cities[t.to].name,
            reduce_value(t.bonus, 1)
        );
	end

    rmsg:line("\n💡 Используй числа для выбора перевозки.")
    oneb(rmsg, "1")
end

return command
