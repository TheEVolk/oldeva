local command = botcmd.new("пит", "система питомцев", {dev=1})

command:addmsub("инфо", "<ид питомца>", "p", function (msg, args, other, rmsg, user, pet)
    rmsg:lines (
        { "%s Питомец %s%s (№%i)", pets.types[pet.type].smile, pet.name, pets.ssm(pet), pet.id },
        { "➤ 🍌 Сыт на %i%%", pet.hunger },
        { "➤ ❤ Счастлив на %i%%", pet.love },
        { "➤ ⚡ Бодр на %i%%", pet.energy },
        --{ "➤ 🖼 День рождения: %s", os.date("%d.%m.%Y", pet.birthday) },
        { "➤ 🕴 Хозяин: %s", pet.owner == 0 and 'безхозный.' or db.get_user(pet.owner):r() }
    )

    numcmd.menu_funcs(rmsg, user, {
        {{ 1, "🍄 Покормить", command.sub['кормить'][3] }, { 2, "🐾 Поиграть", command.sub['играть'][3] }},
        pet.owner == 0 and {{ 3, "🖊 Купить питомца", botcmd.commands['приют'].sub['купить'][3], 'primary' }}
    }, pet)
end)

command:addmsub("кормить", "<ид питомца>", "p", function (msg, args, other, rmsg, user, pet)
    ca(pet.owner==user.vkid or pet.owner==0, "вы не можете кормить чужих питомцев")
    ca(pet.hunger < 100, "питомец не голоден")
    ca(pet.issleep == 0, "питомец спит")
    user:buy(100)

    pet.hunger = pet.hunger + 25
    pet.energy = pet.energy - 8
    pet.love = pet.love + 25

    db("UPDATE p_pets SET hunger=%i, energy=%i, love=%i WHERE id=%i", pet.hunger, pet.energy, pet.love, pet.id)

    rmsg:line("🍄 Вы успешно покормили питомца <<%s>>", pet.name)
    numcmd.menu_funcs(rmsg, user, {{{ 1, "Назад", botcmd.get('пит').sub['инфо'][3], "positive" }}}, pet)

    if pet.hunger > 100 then user:unlockAchiv('feedppet', rmsg) end
end)

command:addmsub("играть", "<ид питомца>", "p", function (msg, args, other, rmsg, user, pet)
    ca(pet.owner==user.vkid or pet.owner==0, "вы не можете кормить чужих питомцев")
    ca(pet.hunger > 20, "питомец голоден", "пит кормить " .. pet.id)
    ca(pet.energy > 10, "питомец очень устал")
    ca(pet.issleep == 0, "питомец спит")

    pet.hunger = pet.hunger - math.random(2, math.random(2, 20))
    pet.energy = pet.energy - math.random(7, 20)
    pet.love = math.min(100, pet.love + math.random(50))

    user:addScore(math.random(1, math.random(1, 50)));

    db("UPDATE p_pets SET hunger=%i, energy=%i, love=%i WHERE id=%i", pet.hunger, pet.energy, pet.love, pet.id)

    rmsg:line("💫 Вы успешно поиграли с питомцем <<%s>>", pet.name)
    numcmd.menu_funcs(rmsg, user, {{{ 1, "Назад", botcmd.get('пит').sub['инфо'][3], "positive" }}}, pet)
end)

command:addmsub("разбудить", "<ид питомца>", "p", function (msg, args, other, rmsg, user, pet)
    ca(pet.owner==user.vkid, "вы не можете будить чужих питомцев")
    ca(pet.energy > 5, "питомец очень устал и не просыпается")
    ca(pet.issleep == 1, "питомец не спит")

    pet.love = math.max(0, pet.love - math.random(math.random(math.random(100-pet.energy))))

    user:addScore(math.random(1, math.random(1, 50)));

    db("UPDATE p_pets SET issleep=0, love=%i WHERE id=%i", pet.love, pet.id)

    rmsg:line("💫 Вы успешно разбудили %s #%i", pet.name, pet.id)
    numcmd.menu_funcs(rmsg, user, {{{ 1, "Назад", botcmd.get('пит').sub['инфо'][3], "positive" }}}, pet)
end)

command:addmsub("сдать", "<ид питомца>", "p", function (msg, args, other, rmsg, user, pet)
    ca(pet.owner==user.vkid, "вы не можете сдавать чужих питомцев")
    ca(pet.died==0, "питомец мёртв")

    db("UPDATE p_pets SET issleep=0, love=0, owner=0 WHERE id=%i", pet.id)

    local messages = {
        "Уходя, вы заметили слёзы на глазах %s.",
        "Это был худший день для %s..",
        "%s теперь чувствует себя брошенным.. Хотя так оно и есть.",
        "%s будет долго плакать и скучать по Вам..",
        "Вы избавились от %s, но он будет помнить Вас до конца своих дней.",
        "%s, похоже, теперь в депрессии...",
        "%s выглядит самым грустным в приюте..",
        "Даже слёзы %s Вас не остановили..."
    }

    rmsg:lines(
        {"💔 Вы сдали питомца в приют. "..trand(messages), pet.name}
    )
end)

function command.exe(msg, args, other, rmsg, user)
    local mypets = db.select("*", "p_pets", "owner = %i", user.vkid)

    if #mypets == 0 then
        rmsg:lines("🐣 У вас пока нет питомца.", "🦊 Самое время его завести!")
        numcmd.onef(rmsg, user, "Завести питомца", "приют")
        return
    end

    rmsg:lnfunctable(mypets, "%s %i. %s %s\n↳ С: %i%%; Сч: %i%%; Э: %i%%", function(i, v)
        return pets.types[v.type].smile, v.id, v.name, pets.ssm(v), v.hunger, v.love, v.energy
    end, "🐱 Ваши питомцы", user, command, "инфо", "p", true)
end

return command
