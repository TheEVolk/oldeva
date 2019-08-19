local command = botcmd.mnew("дд", "выполнить донат строку", "<линия> <цена>", "si", {right="dodonat"})

function command.exe(msg, args, other, rmsg, user, line, price)
    do_donatline (line, price, 'm_'..math.random(100000))
    return "ok"
end

return command
