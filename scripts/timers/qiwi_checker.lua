local markets = {
    -- Биты
    ["2944595"] = { type = "moneys", count = 1000000  },  -- 1KK
    ["2944607"] = { type = "moneys", count = 5000000 },   -- 5KK
    ["2944608"] = { type = "moneys", count = 10000000 },  -- 10KK
    ["2944599"] = { type = "moneys", count = 50000000 },  -- 50KK
    ["2944605"] = { type = "moneys", count = 100000000 }, -- 100KK
    ["2944611"] = { type = "moneys", count = 500000000 }, -- 200KK
    ["2944613"] = { type = "moneys", count = 400000000 }, -- 400KK
    ["2944614"] = { type = "moneys", count = 500000000 }, -- 500KK
    -- Вип
    ["1965902"] = { type = "vip", time = 86400 * 30 * 1, price = 29  },
    ["1996092"] = { type = "vip", time = 86400 * 30 * 6, price = 89 },
    ["1996101"] = { type = "vip", time = 86400 * 365   , price = 149 },
    ["2894244"] = { type = "vip", time = 0             , price = 199 },
    -- Опыт
    ["2762084"] = { type = "score", count = 100, price = 5 },
    ["2762086"] = { type = "score", count = 500, price = 9 },
    ["2762087"] = { type = "score", count = 1000, price = 15 },
    ["2762089"] = { type = "score", count = 5000, price = 24 },
    ["2762090"] = { type = "score", count = 10000, price = 39 },
    ["2762094"] = { type = "score", count = 50000, price = 69 },
    ["2762095"] = { type = "score", count = 100000, price = 100 },
    ["2762096"] = { type = "score", count = 1000000, price = 299 },
    -- Вкойны
    ["2806356"] = { type = "vcoins", count = 1000000, price = 29 },
    -- Кейсы
    ["2939833"] = { type = "case", ctype = "hube", name = "Бомж кейс", price = 5 },
    ["2939507"] = { type = "case", ctype = "bronze", name = "Бронзовый кейс", price = 19 },
    ["2939587"] = { type = "case", ctype = "silver", name = "Серебрянный кейс", price = 39 },
    ["2939603"] = { type = "case", ctype = "gold", name = "Золотой кейс", price = 69 },
    ["2939612"] = { type = "case", ctype = "black", name = "Black кейс", price = 100 },
    ["2943082"] = { type = "case", ctype = "flex", name = "Флекс кейс", price = 50 },
}

local str = ''
for k,v in pairs(markets) do
    str = str .. '-' .. cvars.get'vk_groupid' .. '_' .. k .. ','
end

local markets_vk = VK.market.getById{ item_ids = str, access_token = evatoken }.response
for i,v in ipairs(markets_vk.items) do
    markets[v.id..""].price = math.floor(v.price.amount / 100)
    markets[v.id..""].vk_title = v.title
    console.log(v.id, v.title .. ' - ' .. markets[v.id..""].price)
end

function get_donat_markets()
    return markets
end

function do_donatline(line, amount, txnId)
    local info = line:split('_')
    local user = db.get_user(tonumber(info[2]))

    if process_market(amount, info, user, txnId) == false then
        user:ls("💸 Произошла неизвестная ошибка. Администрация свяжется с вами в ближайшее время.")
        VK.messages.send({
            user_id = admin,
            message = "💸 "..user:r().." вызвал ошибку. ("..info[3].." "..amount.."руб.)",
            attachment = "market-"..cvars.get'vk_groupid'.."_"..info[3]
        })
    end
end

local donat_combo = {}

function process_market(amount, info, user, txnId)
    db("INSERT INTO `donats` VALUES(NULL, %i, %i, '%s', %i, %i)", user.vkid, os.time(), txnId, info[3], amount)
    if not markets[info[3]] then return false end

    if info[4] then -- Уценённые товары
        local cd = db.select_one("*", "custom_prices", "owner=%i AND id=%i", user.vkid, info[4])
        if not cd then return false end
        if amount < cd.price then
            return false
        end

        db("DELETE FROM `custom_prices` WHERE `id`=%i", cd.id)
        user:ls("🛍 Вы успешно приобрели уценённый товар.")
    elseif amount < markets[info[3]].price then
        return false
    end

    give_market(user, info[3])

    -- Бонус
    local bonus = { 'silver', 'gold', 'casecase', 'flex', 'black', 'black', 'casecase', 'max', 'flex', 'flex', 'gold', 'black', 'black', 'casecase', 'max', 'flex', 'flex', 'gold', 'black', 'max' }

    local dbonus = donat_combo[user.vkid] or { db.get_count('donats', 'vkid=%i AND %i - buy_time <= 300', user.vkid, os.time()), os.time() }
    if dbonus[2] + 300 < os.time() then dbonus = { 1, os.time() } end
    local dcount = dbonus[1]

    donat_combo[user.vkid] = { dcount + 1, os.time() }

    if dcount > 1 then
        db("INSERT INTO `cases` VALUES(NULL, %i, '%s')", user.vkid, bonus[math.min(dcount - 1, #bonus)])

        user:ls(
            "🛎 Бонус >> %s",
            get_case_types()[bonus[math.min(dcount - 1, #bonus)]].name
        )
    end

    user:ls(
        "💶 Купи еще донат в течение 5 минут и получи <<%s>> абсолютно бесплатно!",
        get_case_types()[bonus[math.min(dcount, #bonus)]].name
    )

    VK.messages.send({
        user_id = admin,
        message = "💶 "..user:r().." приобрёл товар за "..comma_value(amount).."₽",
        attachment = "market-"..cvars.get'vk_groupid'.."_"..info[3]
    })

    db("UPDATE `keyvalue` SET value = '%i' WHERE id=4", user.vkid)
end

function give_market(user, market_id)
    local market = markets[market_id]
    console.log("DONAT", json.encode(market))
    if market.type == "moneys" then
        user:addMoneys(market.count)
        user:ls("💳 Автодонат >> Вам зачислено %s бит!", comma_value(market.count))
        if math.random(100) >= 90 then
            user:addMoneys(50 * 1e6)
            user:ls("🛎 Вам повезло! Бонус 50 000 000 бит!")
        end

        if market.price >= 40 and math.random(100) >= 95 then
            local old_role = user.role
            user:set('role', 'vip')
            db("INSERT INTO `donat_times` VALUES(NULL, %i, '%s', %i)", user.vkid, old_role, os.time() + 86400 * 30 * 1)
            user:ls("🛎 Вам повезло! Бонус VIP на месяц!")
        end
        return
    end

    if market.type == "score" then
        user:add('score', market.count)
        user:ls("💡 Автодонат >> Вам зачислено %s ед. опыта!", comma_value(market.count))
        return
    end

    if market.type == "case" then
        db("INSERT INTO `cases` VALUES(NULL, %i, '%s')", user.vkid, market.ctype)
        user:ls("🗃 Автодонат >> Вам зачислен <<%s>>!", market.name)
        return
    end

    if market.type == "vcoins" then
        local params = json.encode({ merchantId = admin, key = "u4[U6SRsiJD-PpIIZMywkxToEfLAytpWO-n9lH-5RCI,fe68Ow", toId = user.vkid, amount = market.count * 1000 })
        ca(json.decode(net.send("https://coin-without-bugs.vkforms.ru/merchant/send/", params, "application/json")).response, "произошла ошибка");
        user:ls("🔮 Автодонат >> %s VCoins уже на вашем балансе!", comma_value(market.count))
        return
    end

    if market.type == "vip" then
        local old_role = user.role
        user:set('role', 'vip')
        user:ls("💎 Автодонат >> Теперь вы VIP на %s!", get_parsed_time(market.time))
        if market.time ~= 0 then
            db("INSERT INTO `donat_times` VALUES(NULL, %i, '%s', %i)", user.vkid, old_role, os.time() + market.time)
        end
        return
    end
end


timers.create(60000, 0, function()
    local history = json.decode(net.send("злом", { number = 'неудовися', token = qiwi_token }))
    for i,v in ipairs(history.data) do
        if v.status == "SUCCESS" and v.comment and v.comment:starts("ed_") then
            if not db.select_one('id', 'donats', "txnId = '%s'", v.txnId) then
                do_donatline(v.comment, v.sum.amount, v.txnId)
            end
        end
    end
end)

timers.create(10000, 0, function()
    local new_pays = db.select("*", "site_donat")
    for i,v in ipairs(new_pays) do
        do_donatline(v.payload, v.amount, "site_" .. os.time() .. "_" .. i)
        db("DELETE FROM site_donat WHERE id=%i", v.id)
    end
end)
