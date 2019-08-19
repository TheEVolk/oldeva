local command = botcmd.mnew("отправить", "отправить биты пользователю", "<получатель> <кол-во>", "U", {dev=1})

function command.exe(msg, args, other, rmsg, user, target)
--ca(false, 'упс, похоже слот роняет экономику. Скоро исправим <3')
local count = toint(args[3])
    ca(count > 0, "вы не можете воровать биты")
    ca(user.vkid ~= target.vkid, "вы не можете отправлять биты самому себе")
    if true then return target.allow_balance end
	user:checkMoneys(count)
	rmsg:line("💳 Отправлено » %s.", target:r())
user:addMoneys(-count, "Отправка бит пользователю id%s", target.vkid)
target:addMoneys(count, "Биты от id%s", user.vkid)
target:ls("💳 %s отправил вам %s бит.", user:r(), comma_value(count))
end

return command
