local command = botcmd.mnew("ник", "изменить ваш никнейм", "<текст>", "d", {right="nick"})

function command.exe(msg, args, other, rmsg, user, nick)
    nick = safe.clear(nick:gsub('\n', ' '))
    ca(utf8.len(nick) ~= 0, "походу я не вижу никнейм :/")
    ca(utf8.len(nick) <= 20, "не многовато-ли для никнейма?")
	user:setName(nick)
    rmsg:line("🎩 Ваш никнейм изменён на %s", nick)
end

return command
