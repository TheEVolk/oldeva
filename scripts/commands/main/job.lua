local command = botcmd.new("работа", "система работ", {dev=1, sub={}})

command.help = function (msg,args,other,rmsg)
	rmsg:lines (
        "💼 Система работ.",
        "➤ Работа газета - объявления о работе;",
        "➤ Работа инфо <имя работы> - информация о работе;",
        "➤ Работа устроиться <имя работы> - устроиться на работу;",
        "➤ Работа уволиться - уволиться с работы;",
		"➡ работа - моя работа."
    )
end

command.sub['уволиться'] = function (msg, args, other, rmsg, user, job_name)
	ca(user.job ~= 0, "вы уже безработный", 'работа газета')
	user:set('job', 0)
	rmsg:line("✳ Теперь вы безработный!")
	rmsg:tip("работа газета")
end

command.sub['устроиться'] = { '<имя работы>', 'd', function (msg, args, other, rmsg, user, job_name)
	local job = ca(db.select_one("*", "jobs", "name='%s'", job_name), 'работа не найдена', 'работа газета')

	ca(user.level >= job.minlevel, "вам нужен уровень выше, чтобы здесь работать");
	ca(job.vip ~= 1 or user:isRight 'vipjobs', "для этой работы нужен VIP")
	ca(user.job == 0, "у вас уже есть работа", 'работа уволиться')
	if job.price > 0 then user:buy(job.price) end

	db("DELETE FROM `paydays` WHERE `vkid` = %i", user.vkid)
	db("INSERT INTO `paydays`(`last`, `vkid`) VALUES (%i, %i)", os.time(), user.vkid)

	user:set('job', job.id)
	rmsg:line ("✳ Теперь вы %s! Ближайшую зп вы сможете получить только через 24 часа, а пока получите бонус :)", job.name)
	rmsg:tip("бонус")
end}

command.sub['инфо'] = { '<имя работы>', 'd', function (msg, args, other, rmsg, user, job_name)
	local job = ca(db.select_one("*", "jobs", "name='%s'", job_name), 'работа не найдена', 'работа инфо Дворник')

	rmsg:lines (
        { "💼 %s [%i чел.]", job.name, db.get_count("accounts", "`job`=%i", job.id) },
        { "📋 %s", job.desc },
        { "💰 Зарплата >> %s бит в сутки", comma_value(jobs.get_real_payday(job)) },
        { "💳 Цена » %s бит.", comma_value(job.price) },
        { "⭐ Уровень » %s", levels.levels[job.minlevel].name }
    )

	if job.vip==1 then rmsg:line("👑 Только для VIP") end
	rmsg:tip("работа устроиться %s", job.name)
	oneb(rmsg, "работа устроиться %s", job.name)

	return rmsg
end }

command.sub["газета"] = function (msg, args, other, rmsg, user)
	local where = string.format('`price` <= %i AND `minlevel` <= %i %s', toint(user.balance), user.level,
		user:isRight 'vipjobs' and '' or 'AND `vip` = 0'
	);
	local joblist = db.select("*", "jobs", where .. " ORDER BY RAND() LIMIT 5")

	rmsg:line("📰 Объявления по работе:")
	for i,v in ipairs(joblist) do
		rmsg:line("► %i. %s\n↳ %s бит в сутки.", i, v.name, comma_value(jobs.get_real_payday(v)))
	end
	rmsg:line("\n💡 Используй числа для выбора варианта меню.")

	numcmd.linst(user, function (msg, num, other, rmsg, user)
        return joblist[num] and command.sub['инфо'][3](msg, nil, other, rmsg, user, joblist[num].name) or false
    end)
end

function command.exe(msg, args, other, rmsg, user)
	local job = db.select_one("*", "jobs", "id=%i", user.job)

	if not job then
        rmsg:lines("💼 У вас пока нет работы.", "📑 Самое время устроиться!")
        --numcmd.onef(rmsg, user, "Найти работу", "работа газета")
		oneb(rmsg, "работа газета")
        return
    end

	rmsg:lines (
		{ "💼 %s [%i чел.]", job.name, db.get_count('accounts', 'job = %i', job.id) },
		{ "📋 %s", job.desc },
		{ "💰 %i бит в сутки.", jobs.get_real_payday(job) },
		"", "ℹ Чтобы уволиться напишите <<Ева, работа уволиться>>."
	)
end

return command
