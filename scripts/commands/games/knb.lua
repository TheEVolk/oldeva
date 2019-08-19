local command = botcmd.mnew("кнб", "Камень, ножницы, бумага", "<камень/ножницы/бумага> [ставка = 500]", "s")
local codes = { ['камень'] = 1, ['ножницы'] = 2, ['бумага'] = 3 }

function command.exe(msg, args, other, rmsg, user, user_state)
    local rate = tonumber(args[3]) or 500

    ca(rate >= 0, "я не играю на такие ставки")
    ca(rate < user:getValue 'maxgame', "я не играю на такие ставки")
    user:checkMoneys(rate)

    local ucode = ca(codes[user_state], "такого предмета нет в игре")
    local bcode = math.random(100) > 50 and randomorg.get_int(1, 3) or ({ 3, 1, 2 })[ucode]

    ca(ucode ~= bcode, "каша")
    local uwin = ({ 2, 3, 1 })[ucode] == bcode
    user:addMoneys(uwin and rate or -rate)

    rmsg:line ("&#127920; %s", uwin and "Победа" or "Поражение")
    rmsg:line ("&#128083; Я выбрала %s", ({ 'камень', 'ножницы', 'бумагу' })[bcode])
    oneb(rmsg, "кнб %s", trand{ 'камень', 'ножницы', 'бумага' })
end

return command
