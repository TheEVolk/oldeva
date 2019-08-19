local command = botcmd.new("тру", "выполнить действие")


function command.exe(msg, args, other, rmsg, user)
    return math.random(100) > 50 and "успех" or "неудача"
end

return command;
