local command = botcmd.mnew("лизнуть", "лизнуть пользователя", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    rmsg:line("👅 %s лизнул %s", user:r(), target:r())
    target:ls("👅 %s лизнул вас", user:r())
end

return command
