local cities = db.select("*", "cities")
local types = {
    {'яблоки', 125}, {'колбаса', 225}, {'сыр', 140}, {'мёд', 180}, {'компьютера', 500}, {'телефоны', 300},
    {'чай', 120}, {'одежда', 200}, {'сахар', 40}, {'яйца', 20}, {'гречка', 170}, {'хлеб', 30}
}

timers.create(60000, 0, function()
    -- Маршруты транспорта
    local routes = db.select("*", "routes")
    for k,route in ipairs(routes) do
        local percent = (os.time() - route.start) / (route['end'] - route.start)
        local from, to = cities[route.from], cities[route.to]
        if percent > 1 then
            local vehicle = db.select_one("id,owner,gosnum", "tr_obj", "id=%i", route.tid)
            local rmsg = rmsgclass.get()
            rmsg:line("🛣 %s завершил маршрут.\n↳ %s - %s.", vehicle.gosnum, from.name, to.name)

            local user = db.get_user(vehicle.owner)
            local ts = db.select("*", "tr_transportations", "`tid`=%i AND `to`=%i", route.tid, route.to)
            for _,t in ipairs(ts) do
                user:addMoneys(t.bonus)
                user:addScore(t.bonus/20000)
                rmsg:line("➤ +%s бит за <<%s>> из %s.", comma_value(t.bonus), t.name, from.name)
                db("DELETE FROM `tr_transportations` WHERE `id`=%i", t.id)
            end

            rmsg.user_id = vehicle.owner
            vk.send("messages.send", rmsg)
            db("UPDATE `tr_obj` SET `pos`=%i WHERE `id`=%i", to.id, vehicle.id)
            db("DELETE FROM `routes` WHERE id=%i", route.id)
            console.log("TRANSPORT", "Маршрут %s (%s - %s) завершён. [%i перевозок]", vehicle.gosnum, from.name, to.name, #ts)
        end
    end

    -- Добавление новых перевозок
    for _,c in ipairs(cities) do
        local t_count = db.get_count("tr_transportations", "`from`=%i", c.id)

        for i = t_count, 10 do
            local type, to = trand(types), trand(cities)
            while to.id == c.id do to = trand(cities) end -- Перевозки из точки в ту же точку
            local distance = math.floor(math.sqrt(math.pow(c.x - to.x, 2), math.pow(c.y - to.y, 2)))
            db(
                "INSERT INTO `tr_transportations` (`name`, `bonus`, `from`, `to`, `timeout`) VALUES ('%s', %i, %i, %i, %i)",
                type[1], type[2] * (math.random(100, 200) + distance / 10), c.id, to.id, math.floor(distance / 10 * math.random(65, 120))
            )
            console.log("TRANSPORT", "Добавлена перевозка %s. [%s - %s]", type[1], c.name, to.name)
        end
    end

    local ts = db.select("*", "tr_transportations", "`owner`!=0 AND `endtime`<%i", os.time())
    for _,t in ipairs(ts) do
        VK.messages.send{
            user_id = t.owner,
            message = table.concat({
                string.format("⌚ Вы не успели доставить %s в %s.", t.name, cities[t.to].name),
                "🗑 Перевозка больше не ожидается."
            }, "\n")
        }

        db("DELETE FROM `tr_transportations` WHERE `id`=%i", t.id)
        console.log("TRANSPORT", "Перевозка %s удалена.", t.name)
    end
end)
