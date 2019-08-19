local command = botcmd.new("тест", "проверка бота")

function command.exe (msg, args, other, rmsg, user)
    return "✅ Бот работает."
end

return command
