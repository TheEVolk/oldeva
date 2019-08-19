local command = botcmd.mnew("разбан", "разбанить пользователя", "<профиль>", "U", {right="ban"})

function command.exe(msg, args, other, rmsg, user, target)
    target:banUser(0)
    rmsg:line("☮ %s был разбанен.", target:r())
end

return command
