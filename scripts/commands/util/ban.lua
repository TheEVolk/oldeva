local command = botcmd.mnew("бан", "забанить пользователя", "<профиль> [время в секундах] <причина>", "Ud", {dev=1, right="ban"})

function command.exe(msg, args, other, rmsg, user, target, bantime, reason)
    ca(user:isRight('ban.'..target.role), "ты не можешь его забанить")
	local limit = user:getValue 'maxbantime'
    bantime = tonumber(args[3]) or 1e999

    ca(limit == -1 or bantime <= limit, "максимальный лимит бана "..limit.." секунд.")
	target:banUser(bantime)
    rmsg:lines(
        { "🚷 %s был забанен по причине >> %s.", target:r(), reason },
        { "⏲ Время >> %s", get_parsed_time(bantime) }
    )
  db.get_user(admin):ls("🚷 %s был забанен %s по причине >> %s.<br>⏲ Время >> %s", target:r(), user:r(), reason, get_parsed_time(bantime))
  target:ls("🚷 Вы были забанены %s по причине >> %s.<br>⏲ Время >> %s", user:r(), reason, get_parsed_time(bantime))
end

return command