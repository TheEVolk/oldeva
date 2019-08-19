local command = botcmd.mnew("ударить", "Когда на словах непонятно", "<цель>", "U")

function command.exe(msg, args, other, rmsg, user, target)
    rmsg:line ("&#128074; %s ударил %s!", user:r(), target:r());
end

return command;
