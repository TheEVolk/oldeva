local command = botcmd.new("спортзал", "сходить в спортзал", {use="[кол-во]"})

function command.exe(msg, args, other, rmsg, user)
    local count = toint(args[2]) or 1
    ca(count > 0, "кол-во должно быть положительным")
    ca(count <= 3500, "слишком большое количество тренировок")

    local user_contribution = db.select_one("*", "bank_contributions", "owner=%i", user.vkid)
    ca(user_contribution and user_contribution.count >= count, "недостаточно яриков для посещения спортзала", "банк")

    if user_contribution.count == count then
		db("DELETE FROM `bank_contributions` WHERE `owner`=%i", user.vkid)
	else
		db("UPDATE `bank_contributions` SET `count`=`count`-%i WHERE `owner`=%i", count, user.vkid)
	end

    user:add("force", math.random(1, 5)*count)
    rmsg:line("🏋🏽‍ Вы успешно потренировались!")
    user:unlockAchivCondition('sport', user.force >= 100)
    user:unlockAchivCondition('slabak', user.force >= 100000)
end

return command
