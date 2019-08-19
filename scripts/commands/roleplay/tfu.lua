local command = botcmd.mnew("тьфу", "Плевака комнатный", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    rmsg:line ("&#128538;&#128166; %s тьфукнул на %s!", user:r(), target:r());
end

return command;
