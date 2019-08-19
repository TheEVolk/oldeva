local command = botcmd.new("такси", "система такси", {dev=1})

command:addsub("взять", function (msg, args, other, rmsg, user)
    local taxi_tr = ca(
        db.select_one('id, trid, cityid, route', 'taxi_tr', 'vkid = %i', user.vkid),
        "введи 'такси сет <гос номер>', чтобы начать таксовать"
    )

    local car = db.select_one('model', 'tr_obj', 'id = %i', taxi_tr.trid)--transport.get(taxi_tr.trid)
    local model = transport.models[car.model]

    ca(taxi_tr.route == '', "вы не можете взять заявку пока везёте пассажира")
    local passanger = ca(
        taxi_get_passangers()[taxi_tr.cityid],
        "в вашем городе нет заявок. Ждите."
    )

    if passanger.is_comfort then
        ca(
            model.brand == 'Ches' or model.brand == 'Mod' or model.brand == 'Top',
            "ваш транспорт не соответствует комфорт классу"
        )
    end

    taxi_get_passangers()[taxi_tr.cityid] = nil
    passanger.endtime = os.time() + math.max(math.floor(passanger.distance/model.speed*5), 10)
    passanger.starttime = os.time()

    db("UPDATE taxi_tr SET `route` = '%s' WHERE id = %i", json.encode(passanger), taxi_tr.id)

    local rmsg_sa = rmsgclass.get()
    rmsg_sa:line("🚖 %s взял заявку.", user:r() )

    local to_send = {}
    for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i", taxi_tr.cityid) do table.insert(to_send, v.vkid) end
    send_all(rmsg_sa, to_send)

    return command.exe(msg, args, other, rmsg, user)
end)

command:addmsub("сет", "<гос номер>", "s", function (msg, args, other, rmsg, user, number)
    ca(user.job == 7, "данная команда доступна только игрокам с работой <<таксист>>")
    local car = ca(db.select_one("*", "tr_obj", "`gosnum`='%s'", number), "транспорт с таким номером не найден")

    ca(car.pos > 0, "автомобиль не в городе")
    ca(car.owner == user.vkid, "вы должны быть владельцем автомобиля")
    ca(
        not db.select_one('id', 'taxi_tr', 'vkid = %i', user.vkid)
            or db.select_one('route', 'taxi_tr', 'vkid = %i', user.vkid).route == '',
        "дождитесь окончания текущей поездки"
    )

    db("DELETE FROM `taxi_tr` WHERE vkid = %i", user.vkid)
    db("INSERT INTO `taxi_tr` VALUES(NULL, %i, %i, %i, NULL, 0)", user.vkid, car.id, car.pos)

    local rmsg_sa = rmsgclass.get()
    rmsg_sa:lines({"🚖 %s вошел в сеанс.", user:r()}, { "🚘 %s [%s]", transport.full_name(car), car.gosnum } )

    local to_send = {}
    for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i", car.pos) do table.insert(to_send, v.vkid) end
    send_all(rmsg_sa, to_send)

    return command.exe(msg, args, other, rmsg, user)
end)

command:addsub("стоп", function (msg, args, other, rmsg, user)
    local taxi_tr = ca(
        db.select_one('id, trid, cityid, route, pay', 'taxi_tr', 'vkid = %i', user.vkid),
        "сеанс такси не запущен"
    )

    ca(taxi_tr.route == '', "вы не можете остановить сеанс пока везёте пассажира")
    db("DELETE FROM `taxi_tr` WHERE vkid = %i", user.vkid)

    local rmsg_sa = rmsgclass.get()
    rmsg_sa:line("🚖 %s покинул сеанс.", user:r() )

    local to_send = {}
    for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i", taxi_tr.cityid) do table.insert(to_send, v.vkid) end
    send_all(rmsg_sa, to_send)

    if taxi_tr.pay > 0 then user:addMoneys(taxi_tr.pay) end

    return "🚖 Сеанс такси закрыт!"
end)

command:addmsub("рация", "<текст>", "d", function (msg, args, other, rmsg, user, text)
    ca(#text > 0, "текст отсутствует")
    ca(user.job == 7, "данная команда доступна только игрокам с работой <<таксист>>")
    local taxi_tr = ca(
        db.select_one('trid, cityid, route', 'taxi_tr', 'vkid = %i', user.vkid),
        "введи 'такси сет <гос номер>', чтобы начать таксовать"
    )

    local rmsg_sa = rmsgclass.get()
    rmsg_sa:line("📻 %s >> %s", user:r(), safe.clear(text) )
    --rmsg_sa:line("\n📝 Если игрок нарушил правила, то сообщите в *evabottp(тех. поддержку).")
    --rmsg_sa:line("💡 Вы можете сказать что-то командой `такси рация`.")


    local to_send = {}
    for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i", taxi_tr.cityid) do table.insert(to_send, v.vkid) end
    send_all(rmsg_sa, to_send)

    return nil--"🎙 Отправлено!"
end)

command:addmsub("лист", "<город>", "d", function (msg, args, other, rmsg, user, city_name)
    local city = ca(transport.find_city(city_name), "город не найден.", "тр")
    local taxi_tr = ca(db.select_one('trid, cityid, route', 'taxi_tr', 'vkid = %i', user.vkid), "вы не таксист")

    rmsg:line("🛰 Таксисты <<%s>>", city.name)
    for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i AND route IS NULL", city.id) do
        rmsg:line("► %s.", db.get_user(v.vkid):r())
    end

    rmsg:line("\n🚖 Всего в игре: %i т.", db.get_count('taxi_tr'))
end)

function command.exe(msg, args, other, rmsg, user)
    ca(user.job == 7, "данная команда доступна только игрокам с работой <<таксист>>")
    local taxi_tr = ca(
        db.select_one('trid, cityid, route, pay', 'taxi_tr', 'vkid = %i', user.vkid),
        "введи 'такси сет <гос номер>', чтобы начать таксовать"
    )

    local car = db.select_one('gosnum', 'tr_obj', 'id = %i', taxi_tr.trid)--transport.get(taxi_tr.trid)
    --console.log("lol", taxi_tr.route)
    local route = taxi_tr.route ~= '' and json.decode(taxi_tr.route)
    local pexit = false
    if route and route.endtime <= os.time() then
        route = nil
        pexit = true
    end

    rmsg:lines(
        { "🚖 Вы используете %s", car.gosnum },
        { "🛰 В городе %i такси.", db.get_count('taxi_tr', 'cityid = %i', taxi_tr.cityid )},
        { "💰 За сеанс: %s бит.", reduce_value(taxi_tr.pay) },

        route and "",
        route and { "🗻 До цели: %s м.", comma_value(math.floor((1 - (os.time()-route.starttime) / (route.endtime-route.starttime)) * route.distance)) },
        route and { "⏲ Осталось: %s", moment.get_time(route.endtime - os.time()) },
        route and { "💷 Платят: %s бит.", comma_value(route.pay) },
        route and { "🛋 Класс: %s.", route.is_comfort and "комфорт" or "эконом" },
        pexit and { "🚶 Пассажир выходит..." },

        not route and { "\n💡 Вы можете завершить сеанс такси командой `такси стоп`." },
        route and { "\n💡 Вы можете сказать что-то в рацию командой `рц <текст>`." }
    )
end

return command
