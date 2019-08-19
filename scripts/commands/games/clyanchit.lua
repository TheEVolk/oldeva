local command = botcmd.new("искать", "искать биты")

local markets = {}
local qm = get_donat_markets()
for k,v in pairs(qm) do table.insert(markets, { id = k, price = v.price }) end

function command.exe (msg, args, other, rmsg, user)
    if randomorg.get_int(0, 100) > 60 then
        user:addMoneys(math.random(5000))
        rmsg:line "💰 Вы нашли немного бит"
        rmsg:tip("искать")
    elseif randomorg.get_int(0, 100) > 80 then
        local cd = trand(markets)
        local item = VK.market.getById { item_ids = "-"..cvars.get'vk_groupid'.."_"..cd.id, access_token = evatoken }.response.items[1]
        local new_price = cd.price - math.random(math.floor(cd.price * 0.5))
        user:unlockAchivCondition('skidka', item.price.amount/100 - new_price >= 15)
        rmsg:line("🛍 Вы нашли %s за %s₽ (экономия - %s₽)", item.title, comma_value(new_price), comma_value(item.price.amount/100 - new_price))
        --srmsg:line("🛍 Вы нашли %s за %s)", item.title, comma_value(new_price))
        rmsg:line("Введите `кд` чтобы купить товар.")
        rmsg:tip("кд")
        db("DELETE FROM `custom_prices` WHERE owner=%i", user.vkid)
        db("INSERT INTO `custom_prices` VALUES(NULL, %i, %i, %i, %i)", new_price, user.vkid, cd.id, os.time())
    else
        rmsg:line "🕳 Вы ничего не нашли."
        rmsg:tip("искать")
    end

    user:unlockAchiv('sishik')
end

return command
