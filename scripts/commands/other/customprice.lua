local command = botcmd.new("кд", "сниженный донат", {dev=1})

function command.exe (msg, args, other, rmsg, user)
    local cd = ca(
        db.select_one("*", "custom_prices", "owner=%i", user.vkid),
        "похоже у вас нет уценённых донатов"
    )

    local item = ca(
        VK.market.getById { item_ids = "-"..cvars.get'vk_groupid'.."_"..cd.market, access_token = evatoken }.response.items[1],
        "данный товар похоже больше не существует :("
    )

    local url = string.format(
        "https://qiwi.com/payment/form/99?amountInteger=%i&amountFraction=0&extra['account']=%s&extra['comment']=%s&blocked[1]=account&blocked[2]=comment&blocked[3]=sum",
        cd.price,
        "79505928053",
        "ed_"..user.vkid.."_"..item.id.."_"..cd.id
    )

    rmsg:lines(
        {"📓 Уценённый товар <<%s>>", item.title},
        {"➤ Данный товар стоит всего %s руб. (экономия - %s руб.)", comma_value(cd.price), comma_value(item.price.amount/100 - cd.price) },
        "",
        {"💵 Купить >> %s", VK.utils.getShortLink{ url = url }.response.short_url },
        {"💳 Другие способы >> vk.me/crfthr" }
    )
    rmsg.dont_parse_links = 1

    --rmsg.attachment = upload.get("photo_messages", msg.peer_id, item.thumb_photo)
end


function command.print_item(msg, num, other, rmsg, user, item)
    local url = string.format(
        "https://qiwi.com/payment/form/99?amountInteger=%i&amountFraction=0&extra['account']=%s&extra['comment']=%s&blocked[1]=account&blocked[2]=comment&blocked[3]=sum",
        math.floor(item.price.amount / 100), "79505928053", "ed_"..user.vkid.."_"..item.id
    )

    rmsg:lines(
        {"📓 %s", item.title},
        item.description,
        "",
        {"💵 Цена >> %s", item.price.text },
        "",
        {"Купить >> %s", VK.utils.getShortLink{ url = url }.response.short_url },
        {"Другие способы >> vk.me/crfthr" },
		"PS. НЕ ИЗМЕНЯЙТЕ НИКАКИЕ ДАННЫЕ ВО ВРЕМЯ ПЛАТЕЖА!!!"
    )

    rmsg.attachment = upload.get("photo_messages", msg.peer_id, item.thumb_photo)
end

return command
