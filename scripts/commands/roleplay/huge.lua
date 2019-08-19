local command = botcmd.mnew("обнять", "обнять пользователя", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    local point = trand{'сзади', 'спереди', 'слева', 'справа', 'снизу', 'сверху'}
    if args[3] and args[3] == "сильно" then point = point .. " сильно" end

    rmsg:line("💛 %s обнял %s %s", user:r(), target:r(), point)
    target:ls("💛 %s обнял вас %s", user:r(), point)
end

return command;
