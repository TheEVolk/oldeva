local command = botcmd.new("участки", "покупка домов и участков", {dev=1})

command:addmsub("искать", "<город>", "C", function(msg, args, other, rmsg, user, city)
    local street_id, number = homes.get_random_pos(city.id)
    local structure_name = trand(cities.structure_names)
    local structure = cities.structures[structure_name]
    local structure_variant_id = math.random(structure[4])
    local price = math.random(structure[2], structure[3])

    local buy = function(msg, args, other, rmsg, user)
        ca(user.home == 0, "у вас уже есть дом", "дом покинуть")
        user:buy(price)

        db(
            "INSERT INTO `houses` VALUES(NULL, %i, %i, %i, %i, '%s', %i, 2, %i)",
            city.id, street_id, number, user.vkid, structure_name, structure_variant_id, os.time()
        )

        user:set("home", db.select_one("id", "houses", "owner=%i", user.vkid).id)
        user:unlockAchiv('myhome')

        rmsg:lines(
            { "🆕 Вы успешно приобрели участок №%i!", user.home },
            { "🏘 Адрес >> г. %s ул. %s %i", city.name, cities.streets[city.id][street_id], number },
            { "🏣 Постройка >> %s", structure[1] }
        )

        rmsg.attachment = homes.get_structure_image(msg.peer_id, structure_name, structure_variant_id)
    end

    rmsg:lines(
        { "🏙 Участок в городе <<%s>>", city.name },
        { "🏘 Адрес >> ул. %s %i", cities.streets[city.id][street_id], number },
        { "🏣 Постройка >> %s", structure[1] },
        { "💰 Цена >> %s бит", comma_value(price) }
    )

    rmsg.attachment = homes.get_structure_image(msg.peer_id, structure_name, structure_variant_id)

    numcmd.lmenu_funcs(rmsg, user, {
            {
                { 1, "Следующий", command.sub["искать"][3], "primary" },
                { 2, "Купить", buy, "positive" }
            },
            {
                { 0, "Меню", botcmd.commands['меню'].exe }
            }
    }, city)
end)

function command.exe(msg, args, other, rmsg, user)
    rmsg:lnfunctable(cities.cities, "%i. %s", function(i, v)
        return i, v.name
    end, "🏙 Список городов", user, command, "искать", "C")
end

return command
