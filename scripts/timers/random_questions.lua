local qudatabase = {
    {
        q = "В какую из этих игр играют не клюшкой?",
        variants = "Хоккей, Гольф, Поло",
        right = "Бильярд"
    }, {
        q = "В каком городе не работал великий композитор 18-го века Кристоф Виллибальд Глюк?",
        variants = "Милан, Вена, Париж",
        right = "Берлин"
    }, {
        q = "Кто первым доказал периодичность появления комет?",
        variants = "Галилей, Коперник, Кеплер",
        right = "Галлей"
    }, {
        q = "Про какую летнюю погоду говорят \"Вёдро\" ?",
        variants = "Теплая дождливая, Прохладная дождливая, Длительные заморозки",
        right = "Сухая ясная"
    }, --[[{
        q = "С какой из этих стран Чехия не граничит?",
        variants = "Германия, Австрия, Польша",
        right = "Венгрия"
    },]] {
        q = "Где в основном проживают таты?",
        variants = "Татарстан, Башкортостан, Туркменистан",
        right = "Дагестан"
    }, {
        q = "Как, в переводе на русский язык, звучало бы название фильма 'Мимино'?",
        variants = "Медведь, Гора, Любовь",
        right = "Сокол"
    }, {
        q = "Как называется курс парусного судна, совпадающий с направлением ветра?",
        variants = "Бейдевинд, Галфинд, Бакштаг",
        right = "Фордевинд"
    }, {
        q = "На вершине какой горы расположена сорокаметровая статуя Христа, являющаяся символом Рио-де-Жанейро?",
        variants = "Тупунгато, Уаскаран, Ильимани",
        right = "Корковадо"
    }, {
        q = "Какое брюхо, согласно спорной русской пословице, глухо к ученью?",
        variants = "Толстое, Тощее, Пустое",
        right = "Сытое"
    }
}
questions_bans={}
hooks.add_action("bot_check", function(msg)
	if msg.peer_id ~= 2000000002 then return end
	if not tonumber(msg.text or '') then return end
    local gq = global_question
    if not gq then return end
    if questions_bans[msg.from_id] then return end
    if gq[1] ~= tonumber(msg.text) then
        VK.messages.send {
            message = string.format("⭕ Ответ неверный.\n🚫 Вы больше не сможете ответить на этот вопрос."),
            peer_id = 2000000002
        }
        questions_bans[msg.from_id] = true
        return
    end

    local user = db.get_user(msg.from_id)
    user:addMoneys(gq[2])
    user:addScore(math.random(10, 80))

    VK.messages.send {
        message = string.format("✔ %s правильно ответил на вопрос и получил %s бит!", user:r(), comma_value(gq[2])),
        peer_id = 2000000002
    }

    questions_bans = {}

    global_question = nil
end, 1000)

function create_q(text, right, variants)
    global_question = { right, math.random(5000) }

    local variants_text = "";
    if variants then
        variants_text = "\n🔢 Варианты ответа:"
        for i,v in ipairs(variants) do
            variants_text = variants_text .. "\n" .. i .. " ➤ " .. v
        end
        variants_text = variants_text .. "\n"
    end

    VK.messages.send {
        message = table.concat({
            "💰 Ответь на вопрос первым и получи биты!",
            "❔ >> "..text,
            variants_text,
            "❕ Ответ должен быть числом."
        }, '\n'),
        peer_id = 2000000002
    }
end

function q_createmath()
    local obj = math.random(100);
    local operation = trand { '+', '-' }
    obj = math.random (100) > 50 and obj..' '..operation..' '..math.random(100) or math.random(100)..' '..operation..' '..obj

    create_q("Сколько будет "..obj, load("return "..obj)())
end

function q_createansw()
    local a = trand(qudatabase)
    local variants = string.split(a.variants, ', ')
    table.insert(variants, a.right)
    table.sort(variants, function(_,_2) return math.random(2) == 1 end)
    local right_num = 0
    for i,v in ipairs(variants) do if v == a.right then right_num = i end end
    create_q(a.q, right_num, variants)
end

timers.create(60000, 0, function()
    if math.random(100) < 95 then return end
    trand({ q_createmath, q_createansw })()
end)
