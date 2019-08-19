timers.create(60000, 0, function()
    if os.time() % 86400 > 60 then return end

    db("TRUNCATE TABLE `handouts`")

    local donatkey = math.random(1000, 9999)
    db("UPDATE `db_eva`.`keyvalue` SET `value`='"..donatkey.."' WHERE `id`=2")

    console.log("FM", vk.send("wall.post", {
        message = "💰 Ежедневная раздача на 10'000 БИТ.\n✉ Напиши <<деньги "..donatkey..">> в лс бота, чтобы получить приз! (vk.me/evarobotgroup).\n💸 Приз получат только первые 100 игроков!",
        access_token = evatoken,
        attachments = "photo-134466548_456279283",
        owner_id = -178117342
    }))
end)
