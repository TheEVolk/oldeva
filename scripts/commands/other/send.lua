local command = botcmd.mnew("отправить", "отправить биты", "<получатель> <кол-во>", "Um")

function command.exe(msg, args, other, rmsg, user, target, count)
	ca(target.vkid ~= user.vkid, "вы не можете отправить биты самому себе")

    target:addMoneys(count)
	user:addMoneys(-count)
	target:ls("💳 %s отправил вам %s бит.", user:r(), comma_value(count))

	rmsg:line ("💳 Отправлено >> %s.", target:r())
end

return command
