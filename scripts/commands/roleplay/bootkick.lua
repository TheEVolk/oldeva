local command = botcmd.mnew("пнуть", "пнуть пользователя", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    rmsg:line("👞 %s пнул %s", user:r(), target:r())
    target:ls("👞 %s пнул вас", user:r())
end

return command
