local cities = db.select("*", "cities")

local taxi_passangers = {}

function taxi_get_passangers()
    return taxi_passangers
end

timers.create(10000, 0, function()
    console.log("TAXI", "update")
    -- Появление новых пассажиров
    for i,v in ipairs(cities) do
        if taxi_passangers[v.id] and math.random(100) > 60 then
            local rmsg = rmsgclass.get()
            rmsg:line("🚖 Заявка исчезла.")
            taxi_passangers[v.id] = nil

            local to_send = {}
            for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i AND route IS NULL", v.id) do table.insert(to_send, v.vkid) end
            send_all(rmsg, to_send)
        end

        if taxi_passangers[v.id] == nil and math.random(100) > 50 then
            local new_passanger = { distance = math.random(100, 10000), is_comfort = math.random(100) > 80 }
            new_passanger.pay = 92 + math.floor(new_passanger.distance * (new_passanger.is_comfort and 3.3 or 1.7))
            taxi_passangers[v.id] = new_passanger

            -- Рассылка
            local rmsg = rmsgclass.get()
            rmsg:lines(
                { "🚖 Новая заявка!" },
                { "🗻 Дистанция: %s м.", new_passanger.distance },
                { "💷 Платят: %s бит.", comma_value(new_passanger.pay) },
                { "🛋 Класс: %s.", new_passanger.is_comfort and "комфорт" or "эконом" },
                { "\n💡 Возьмите заявку быстрее остальных командой `такси взять`." }
            )

            local to_send = {}
            for i,v in db.iselect("vkid", "taxi_tr", "cityid = %i AND route IS NULL", v.id) do table.insert(to_send, v.vkid) end
            send_all(rmsg, to_send)
        end
    end

    console.log("TAXI", "exit")
    -- Отгрузка новых пассажиров
    for i,v in db.iselect("id, vkid, route, pay", "taxi_tr", "route IS NOT NULL") do
        local route = json.decode(v.route)
        if os.time() >= route.endtime then
            db("UPDATE taxi_tr SET `route`= NULL WHERE id = %i", v.id)

            local user = db.get_user(v.vkid)

            user:addScore(math.random(2000))

            local nopay = math.random(100) > 95
            if not nopay then db("UPDATE taxi_tr SET `pay`=`pay`+%i WHERE id = %i", route.pay, v.id) end

            local rmsg = rmsgclass.get()
            rmsg:lines(
                { "🚖 Заявка завершена!" },
                not nopay and { "💰 %s бит (+%s).", comma_value(v.pay + route.pay), reduce_value(route.pay) },
                nopay and "🏃 Пассажир сбежал без денег."
            )

            rmsg.user_id = v.vkid
            vk.send("messages.send", rmsg)
        end
    end

    if uptime() > 300 then

        console.log("TAXI", "offline")
        -- Отключение оффлайн юзеров
        for i,v in db.iselect("vkid, pay", "taxi_tr", "route IS NULL") do
            if not online.is_online(v.vkid) then
                db("DELETE FROM `taxi_tr` WHERE vkid = %i", v.vkid)

                if v.pay > 0 then user:addMoneys(v.pay) end
                local rmsg = rmsgclass.get()
                rmsg:lines(
                    { "🚖 Сеанс такси закрыт!" },
                    v.pay > 0 and { "💳 %s бит (+%s).", user:getMoneys(), reduce_value(v.pay) }
                )

                rmsg.user_id = v.vkid
                vk.send("messages.send", rmsg)
            end
        end
    end
end)
