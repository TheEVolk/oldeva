local command = botcmd.new("инфа", "вероятность")

function command.exe(msg, args, other, rmsg)
    rmsg:line("Вероятность события - %i%%", math.random(100))
end

return command
