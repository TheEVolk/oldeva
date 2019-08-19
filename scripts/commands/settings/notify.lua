local command = botcmd.new("уведомления", "вкл/выкл рассылка")

function command.exe (msg, args, other, rmsg, user)
	user:set("notifications", user.notifications==1 and 0 or 1)
	user:unlockAchiv('iknow')
    return "Вы успешно "..(user.notifications==1 and "включили" or "выключили").." рассылку"
end

return command
