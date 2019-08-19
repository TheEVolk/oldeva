local command = botcmd.new("тр", "список вашего транспорта", {dev=1})

function get_number()
    local alltr = db.select("gosnum", "tr_obj")
    function check_number(num) for i = 1,#alltr do if alltr[i].gosnum == num then return true end end end
    local number
    repeat number = transport.generate_number() until not check_number(number)
    return number
end


command:addmsub("инфо", "<гос. номер>", "s", function(msg, args, other, rmsg, user, number)
    local obj = ca(db.select_one("*", "tr_obj", "`gosnum`='%s'", number), "транспорт с таким номером не найден")
    local model = transport.models[obj.model]

    rmsg:lines (
        { "🚘 %s [%s]", transport.full_name(obj), obj.gosnum },
        { "🎩 Владелец >> %s", db.get_user(obj.owner):r() },
        { "🌆 Позиция >> %s", transport.get_status(obj, true) },
        { "⛽ Топливо >> %s (%i л./100 км)", transport.fuel_types[model.fuel_type], model.consumption },
        { "⏲ Скорость >> %i км/ч", model.speed }
    )

    transport.get_obj_image(obj):write(root.."/temp/tr_"..msg.peer_id..".png")
    rmsg.attachment = upload.get("photo_messages", msg.peer_id, root.."/temp/tr_"..msg.peer_id..".png")

    if obj.owner == user.vkid then
        numcmd.menu_funcs(rmsg, user, {
            obj.pos > 0 and {{ 1, "📦 Перевозки", "перевозки "..cities.cities[obj.pos].name }},
            obj.pos > 0 and {{ 2, "🚕 Таксовать", "такси сет "..obj.gosnum }},
            {{ 3, "♻ Отправить на свалку", "тр свалка "..obj.gosnum }}
        })
    end
end)

command:addsub("топливо", function (msg, args, other, rmsg, user)
    local prices = net.jSend("https://www.cbr-xml-daily.ru/daily_json.js")
    rmsg:lines(
        "⛽ Цены на топливо:",
        { "➤ A92 - %i бит/литр;", math.floor(prices.Valute.AUD.Value) },
        { "➤ A95 - %i бит/литр;", math.floor(prices.Valute.CAD.Value) },
        { "➤ A98 - %i бит/литр;", math.floor(prices.Valute.KRW.Value) },
        { "➤ DT - %i бит/литр.", math.floor(prices.Valute.SGD.Value) }
    )
end)

command:addmsub("маршрут", "<гос. номер> <город>", "sd", function(msg, args, other, rmsg, user, gosnum, city_name)
    local obj = ca(db.select_one("*", "tr_obj", "`gosnum`='%s'", gosnum), "транспорт с таким номером не найден")
    local to = ca(transport.find_city(city_name), "город не найден")
    local model = transport.models[obj.model]

    ca(not db.select_one('id', 'taxi_tr', "trid = %i", obj.id), "транспорт в сеансе такси")
    ca(obj.pos > 0, "транспорт уже в дороге")

    local from = transport.cities[obj.pos]
    local distance = math.sqrt(math.pow(to.x - from.x, 2), math.pow(to.y - from.y, 2))
    ca(distance ~= 0, "транспорт уже находится там")
    local fuel = math.floor(distance/100*model.consumption)

    rmsg:lines(
        { "🚘 %s • %s", obj.gosnum, transport.full_name(obj) },
        { "🛤 %s - %s", from.name, to.name },
        { "↔ Дистанция %i км.", distance },
        { "⛽ %i литров топлива.", fuel },
        { "⌚ %s", os.date("!%H часов %M минут", math.floor(distance/model.speed*240)) },
        { "➤ 1. Отправиться в маршрут" }
    )

    rmsg.keyboard = [[{
        "one_time": true,
        "buttons": [
            [{"action": {"type": "text","label": "Отправиться в маршрут", "payload": "1"},"color": "primary"}]
        ]
    }]]

    numcmd.linst(user, function(msg, num, other, rmsg, user)
        if num==1 then
            user:buy(transport.get_fuel_price(fuel, model.fuel_type))

            db(
                "INSERT INTO `routes`(`from`, `to`, `start`, `end`, `tid`) VALUES ('%i','%i','%i','%i','%i')",
                from.id, to.id, os.time(), os.time() + math.floor(distance/model.speed*240), obj.id
            )

            db("UPDATE `tr_obj` SET `pos` = %i WHERE `id` = %i", -db.select_one("id", "routes", "tid=%i", obj.id).id, obj.id)
            rmsg:line ("&#10035; Вы успешно отправили транспорт в маршрут.")
            oneb(rmsg, "тр")
        end
    end)
end)

command:addmsub("свалка", "<гос. номер>", "s", function(msg, args, other, rmsg, user, gosnum)
    local obj = ca(db.select_one("*", "tr_obj", "`gosnum`='%s'", gosnum), "транспорт с таким номером не найден")
    ca(obj.owner == user.vkid, "это не ваш транспорт")
    ca(obj.pos > 0, "транспорт в пути")
    ca(not db.select_one('id', 'taxi_tr', "trid = %i", obj.id), "транспорт в сеансе такси")

    local yes = function(msg, args, other, rmsg, user)
  		if obj.owner == user.vkid then
        local tr_price = tonumber(db.select_one('price', 'tr_models', 'id=%i', obj.model).price)
        rmsg:line("🚩 %s [%s] выброшен.", transport.full_name(obj), gosnum)
        user:addMoneys(math.random(tr_price))
        db("DELETE FROM `tr_obj` WHERE id=%i", obj.id)
        numcmd.linst(user, nil)
  		end
  	end

  	rmsg:line("Вы точно хотите выбросить свой транспорт?")
  	numcmd.lmenu_funcs(rmsg, user, {{
  		{ 1, "Нет", command.exe, "positive" },
  		{ 2, "Да", yes, "negative" }
  	}})
end)

function command.exe(msg, args, other, rmsg, user)
    local transports = db.select("*", "tr_obj", "owner = %i", user.vkid)

    if #transports == 0 then
        rmsg:lines("🚘 У вас пока нет транспорта.", "🛤 Самое время его приобрести!")
        numcmd.onef(rmsg, user, "Приобрести транспорт", "ткуп")
        return
    end

	rmsg:line("🚘 Ваш транспорт >> %i шт.", #transports)
	for i,obj in ipairs(transports) do
		--rmsg:line("➤ %i. %s • %s >> %s", i, obj.gosnum, transport.short_name(obj), transport.get_status(obj))
		rmsg:line("➤ %i. %s [%s]", i, transport.full_name(obj), transport.get_status(obj))
	end
    rmsg:line(tip_nc)

    numcmd.linst_list(user, function(msg, obj, other, rmsg, user)
        return command.sub["инфо"][3](msg, {}, other, rmsg, user, obj.gosnum)
    end, transports)
end

return command
