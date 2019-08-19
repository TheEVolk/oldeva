local command = botcmd.mnew("кусь", "Укусить мяягонько ^-^", "<цель>", "U")


function command.exe(msg, args, other, rmsg, user, target)
    rmsg:line ("&#128573; %s кусьнул %s %s", user:r(), target:r(), trand{'сзади', 'спереди', 'слева', 'справа', 'снизу', 'сверху'})
end

return command;
