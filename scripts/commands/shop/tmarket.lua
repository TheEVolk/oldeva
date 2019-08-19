local command = botcmd.new("ткуп", "магазин транспорта", {dev = 1})

function get_number()
    local alltr = db.select("gosnum", "tr_obj")
    function check_number(num) for i = 1,#alltr do if alltr[i].gosnum == num then return true end end end
    local number
    repeat number = transport.generate_number() until not check_number(number)
    return number
end

command:addsub("завод", function(msg, args, other, rmsg, user)
    local brands = db "SELECT DISTINCT brand FROM tr_models"
    rmsg:lines ("🚕 Список автомарок:", { brands, "➤ :i:. :v.brand:" }, tip_nc)
    numcmd.linst_list (user, function(msg, brand, other, rmsg, user)
        return command.sub["марка"][3](msg, {}, other, rmsg, user, brand.brand)
    end, brands)
end)

command:addmsub("марка", "<имя>", "d", function(msg, args, other, rmsg, user, brand_name)
    local models = tca(db.select("*", "tr_models", "`brand` = '%s'", brand_name), "марка не найдена")
    rmsg:lines ({ "🚕 Автомобили %s:", brand_name }, { models, "➤ :i:. :v.brand: :v.name: >> :comma_value(v.price):" }, tip_nc)
    numcmd.linst_list (user, function(msg, model, other, rmsg, user)
        return command.sub["инфо"][3](msg, {}, other, rmsg, user, brand_name.." "..model.name)
    end, models)
end)

command:addmsub("инфо", "<имя>", "d", function(msg, args, other, rmsg, user, name)
    local model = ca(db.select_one("*", "tr_models", "CONCAT(`brand`, ' ', `name`) = '%s'", name), "транспорт не найден")

    rmsg:lines (
        { "🚕 Автомобиль %s %s", model.brand, model.name },
        { "💰 Цена >> %s бит.", comma_value(model.price) },
        { "⛽ Топливо >> %s (%i л./100 км)", transport.fuel_types[model.fuel_type], model.consumption },
        { "⏲ Скорость >> %i км/ч", model.speed },
        "", {"ℹ Чтобы купить напишите <<ткуп купить %s %s>>.", model.brand, model.name}
    )

    oneb(rmsg, "ткуп купить %s %s", model.brand, model.name)
    transport.get_transport_image(model, transport.generate_number()):write(root.."/temp/tr_"..msg.peer_id..".png")
    rmsg.attachment = upload.get("photo_messages", msg.peer_id, root.."/temp/tr_"..msg.peer_id..".png")
end)

command:addmsub("купить", "<имя>", "d", function(msg, args, other, rmsg, user, name)
    local model = ca(db.select_one("*", "tr_models", "CONCAT(`brand`, ' ', `name`) = '%s'", name), "транспорт не найден")

    ca(user:getValue 'tslots' > db.get_count('tr_obj', "owner = %i", user.vkid), "в вашем гараже нет места")
    user:buy(model.price)

    local number = get_number()
    local city = math.random(db.get_count('cities'))

    db(
        "INSERT INTO `tr_obj`(`model`, `owner`, `buy_data`, `gosnum`, `pos`) VALUES (%i, %i, %i, '%s', %i)",
        model.id, user.vkid, os.time(), number, city
    )

    rmsg:lines(
        { "🆕 Вы успешно приобрели %s %s!", model.brand, model.name },
        { "🆔 Номер >> %s", number },
        { "🏙 Город >> %s", db.select_one('name', 'cities', 'id = %i', city).name }
    )
end)

command.sub['рынок'] = function (msg, args, other, rmsg, user)
    return "Рынок ещё пока строится..."
end

function command.exe(msg, args, other, rmsg, user, city_name)
    rmsg:lines("➤ 1. Транспорт с салона (Новый)", "➤ 2. Транспорт с рынка (Б/У)")

    rmsg.keyboard = [[{
        "one_time": true,
        "buttons": [
            [{"action": {"type": "text","label": "Салон", "payload": "1"},"color": "primary"},
             {"action": {"type": "text","label": "Рынок", "payload": "2"},"color": "default"}]
        ]
    }]]

    numcmd.linst(user, function(msg, num, other, rmsg, user)
        local funcs = { "завод", "рынок" }

        if not funcs[num] then return command.exe(msg, {num}, other, rmsg, user) end
        return command.sub[funcs[num]](msg, {num}, other, rmsg, user)
    end)
end

return command
