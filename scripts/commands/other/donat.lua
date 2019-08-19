local command = botcmd.new("донат", "список донат товаров", {dev=1})

command.categories = {
    { "💳", "Игровая валюта", "moneys", "2" },
    { "💎", "VIP пользователь", "vip", "1" },
    { "💡", "Единицы опыта", "score", "4" },
    { "🗃", "Кейсы", "cases", "5" },
}

function command.exe (msg, args, other, rmsg, user)
    numcmd.linst(user, command.print_category)

    rmsg:line("💶 Категории товаров:")
    for i,cat in ipairs(command.categories) do rmsg:line("► %i. %s.", i, cat[2]) end
    rmsg:line("\n💡 Используй числа для выбора категории.")
end

function command.print_category(msg, num, other, rmsg, user)
    local cat = ca(command.categories[num], "категория не найдена", "донат")
    local market_album = VK.market.get{ owner_id = -cvars.get'vk_groupid', album_id = cat[4], access_token = evatoken }.response

    numcmd.linst(user, function(msg, num, other, rmsg, user)
        local item = ca(market_album.items[num], "товар не найден", "донат")
        command.print_item(msg, num, other, rmsg, user, item)
    end)

    rmsg:line("%s Товары <<%s>>:", cat[1], cat[2])
    for i,item in ipairs(market_album.items) do rmsg:line("► %i. %s за %s", i, item.title, item.price.text) end
    rmsg:line("\n💡 Используй числа для выбора категории.")
end

function command.print_item(msg, num, other, rmsg, user, item)
    local url = string.format(
        "https://qiwi.com/payment/form/99?amountInteger=%i&amountFraction=0&extra['account']=%s&extra['comment']=%s&blocked[1]=account&blocked[2]=comment&blocked[3]=sum",
        math.floor(item.price.amount / 100), "79505928053", "ed_"..user.vkid.."_"..item.id
    )

    rmsg:lines(
        {"📓 %s за %s", item.title, item.price.text},
        item.description,
        "",
        {"💶 Купить: %s", VK.utils.getShortLink{ url = url }.response.short_url },
        {"⚙ Другие способы: @crfthr (%s)", "ed_"..user.vkid.."_"..item.id }
    )
end

return command
