--[[
    Принудительная смена никнейма.
    botcmd.mnew("команда", "описание", "инструкция", "аргументы", "смайл"[, { ... }])
]]
local command = botcmd.mnew("сетник", "изменить никнейм пользователя", "<цель> <ник>", "Ud", {right="nick.other"})

function command.exe(msg, args, other, rmsg, user, target, nick)
    nick = nick:gsub('\n', ' ')
    ca(utf8.len(nick) ~= 0, "походу я не вижу никнейм :/")
    ca(utf8.len(nick) <= 20, "не многовато-ли для никнейма?")
	target:setName(nick)
    rmsg:line("🎩 Никнейм изменён для %s", target:r())
end

return command
