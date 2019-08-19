local command = botcmd.new("дом", "система домов", {dev=1})

command:addsub("покинуть", function(msg, args, other, rmsg, user)
	local house = ca(db.select_one("*", "houses", "id = %i", user.home), "у вас нет своего дома или участка")
	local structure = cities.structures[house.structure]

	local yes = function(msg, args, other, rmsg, user)
		if house.owner == user.vkid then
			db("DELETE FROM `houses` WHERE id=%i", house.id)
			db("UPDATE `accounts` SET `home`=0 WHERE `home`=%i", house.id)
		end
		user:set("home", 0)
		rmsg:line("🚩 Вы только что покинули участок.")
	end

	rmsg:line("Вы точно хотите покинуть свой дом?")
	numcmd.lmenu_funcs(rmsg, user, {{
		{ 1, "Нет", command.exe, "positive" },
		{ 2, "Да", yes, "negative" }
	}})
end)

command:addmsub("жить", "<ид участка>", "h", function(msg, args, other, rmsg, user, house)
	ca(user.home == 0, "вы уже состоите в участке\nПокинуть участок >> дом покинуть")
    local target = db.get_user(house.owner)

    local accepttohouse = function(target, source, rmsg)
        local house = ca(db.select_one("*", "houses", "owner=%i", target.vkid), "у вас нет участка")
		ca(source.home == 0, "пользователь уже состоит в участке")

        source:set("home", house.id)

        source:ls("✅ Вас приняли в участок №%i.", house.id)
        rmsg:line("✅ Вы успешно приняли %s в участок.", source:r())

		source:unlockAchiv('myhome')
    end

    local qid = inv.create(user, target, accepttohouse)
	rmsg:line("✳ Вы успешно подали заявку в участок №%i", house.id)
	inv.lines(rmsg, qid, target)
end)

command:addmsub("инфо", "<ид участка>", "h", function(msg, args, other, rmsg, user, house)
	local structure = cities.structures[house.structure]

	rmsg:lines(
		{ "🏘 Постройка №%i", house.id },
        { "🏙 г. %s ул. %s %i", cities.cities[house.city].name, cities.streets[house.city][house.street], house.number },
        { "🏣 Постройка >> %s", structure[1] },
		{ "👤 Владелец >> %s", db.get_user(house.owner):r() },
		{ "👥 Жителей >> %i чел.", db.get_count("accounts", "home=%i", house.id) }
    )

    rmsg.attachment = homes.get_structure_image(msg.peer_id, house.structure, house.structure_variant)

	numcmd.menu_funcs(rmsg, user, {
        {{ 1, "👥 Жители", command.sub['жители'][3] }},
        {user.home ~= house.id and { 2, "🖊 Жить в этом доме", command.sub['жить'][3], 'primary' } or { 2, "👒 Покинуть дом", command.sub['покинуть'], 'negative' }}
    }, house)
end)

command:addmsub("жители", "<ид участка>", "h", function(msg, args, other, rmsg, user, house)
	local structure = cities.structures[house.structure]

	rmsg:lines(
		{ "🏘 Постройка №%i", house.id },
		{ "👤 Владелец >> %s", db.get_user(house.owner):r() },
		{ "👥 Жители (%i чел.)", db.get_count("accounts", "home=%i", house.id) },
		{ db.select("*", "accounts", "home=%i", house.id), "➤ :i:. :names.dbr(v):" }
    )

    rmsg.attachment = homes.get_structure_image(msg.peer_id, house.structure, house.structure_variant)
end)

function command.exe(msg, args, other, rmsg, user)
    local house = db.select_one("*", "houses", "id = %i", user.home)

    if not house then
        rmsg:lines("🏚 У вас пока нет своего дома или участка.", "🏘 Но вы можете его приобрести!")
        numcmd.onef(rmsg, user, "Получить участок", "участки")
        return
    end

    return command.sub["инфо"][3](msg, args, other, rmsg, user, house)
end


return command
