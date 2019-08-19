local command = botcmd.mnew("деньги", "получить деньги с раздачи", "<код>", "s")

command.max = 100 -- Кол-во единиц в раздаче
command.pay = 10000 -- Кол-во бит за раздачу

function command.exe(msg, args, other, rmsg, user, code)
    ca(db.select_one("value", "keyvalue", "`key`='donatkey'").value == code, "вы ввели неверный код раздачи")

    ca(not db.select_one('id', 'handouts', 'vkid=%i', user.vkid), "вы уже получили эту раздачу.")
    ca(db.get_count('handouts') < command.max, "к сожалению, вы не успели на эту раздачу. Приходите в следующий раз.")

    db("INSERT INTO `handouts` VALUES(NULL, %i)", user.vkid)
    user:addMoneys(command.pay)

    rmsg:line("💰 Вы только что получили %s бит с раздачи!", comma_value(command.pay))
    user:unlockAchiv('halava')
end

return command
