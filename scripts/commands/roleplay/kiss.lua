local command = botcmd.mnew("поцеловать", "поцеловать пользователя", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    local point = trand{
        'сзади', 'спереди', 'слева', 'справа', 'снизу', 'сверху',
        'в щеку', "в нос", "в лоб", "в губы", "в живот", "в шею"
    }

    rmsg:line("😚 %s поцеловал %s %s", user:r(), target:r(), point)
    target:ls("😚 %s поцеловал вас %s", user:r(), point)
end

return command
