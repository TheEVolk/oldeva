local command = botcmd.new("vkid", "ид пользователя ВКонтакте", {use="[профиль]", dev=1})

function command.exe(msg, args, other, rmsg, user)
	local target = args[2] and db.get_user_from_url(args[2]) or user
    return target.smile .. " >> " .. target.vkid
end

return command
