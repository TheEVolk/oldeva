local command = botcmd.new("банк", "банковская система", {dev=1})

bank_bans = {}

local function get_course()
	local bdg = tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)
	local all = db.select_one("SUM(count)", "bank_contributions")["SUM(count)"]
	return math.max(10, math.floor(bdg/all))
end

local function write_history()
	local course = get_course()
	if db('SELECT value FROM bankhistory ORDER BY id DESC LIMIT 1')[1]['value'] ~= course then
		db('INSERT INTO `bankhistory` VALUES (NULL, %i)', course)
	end
end

local function crv(value)
	local result = ''
	while value >= 1000 do
		result = result .. 'к'
		value = value / 1000
	end

	return string.format('%.2f%s', value, result)
end

command:addmsub("купить", "<кол-во>", "i", function(msg, args, other, rmsg, user, count)
	local course = math.floor(get_course())
	local yariks = db.select_one("*", "bank_contributions", "`owner`=%i", user.vkid);
	if yariks == nil then yariks = 0 else yariks = yariks.count end
	local sum = count + yariks
	ca(count > 0, "кол-во должно быть положительным")
	if (user:getValue('bankstatus') == 'full') and (sum > 600000) then
		return "ваш тип счёта не позволяет такую большую транзакцию"
	elseif (user:getValue('bankstatus') == 'sim') and (sum > 60000) then
		return "ваш тип счёта не позволяет такую большую транзакцию"
	elseif (user:getValue('bankstatus') == 'lim') and (sum > 15000) then
		return "ваш тип счёта не позволяет такую большую транзакцию"
	end
	user:buy(count * course)
	db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value) + math.floor(count * course))

	if db.select_one("*", "bank_contributions", "owner=%i", user.vkid) then
		db("UPDATE `bank_contributions` SET `count`=`count`+%i WHERE `owner`=%i", count, user.vkid)
	else
		db("INSERT INTO `bank_contributions`(`owner`, `count`) VALUES (%i, %i)", user.vkid, count)
	end

	local user_contribution = db.select_one("*", "bank_contributions", "owner=%i", user.vkid)



	rmsg:line("💻 Счет: %s яриков.", comma_value(user_contribution.count))

	if count > 1000 then user:unlockAchiv('yariknegazuy', rmsg) end

	write_history()
end)

command:addmsub("продать", "<кол-во>", "i", function(msg, args, other, rmsg, user, count)
	local course = get_course()

	local user_contribution = ca(db.select_one("*", "bank_contributions", "owner=%i", user.vkid), "у вас нет яриков", "банк")

	ca(count > 0, "кол-во должно быть положительным")
	ca(count <= user_contribution.count, "у вас нет столько яриков")
	ca(count * course <= tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value), "в банке нет столько бит")

	user:addMoneys(math.floor(count * course * 0.95))
	db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value) - math.floor(count * course * 0.9))

	user_contribution.count = user_contribution.count - count
	if user_contribution.count == 0 then
		db("DELETE FROM `bank_contributions` WHERE `owner`=%i", user.vkid)
	else
		db("UPDATE `bank_contributions` SET `count`=`count`-%i WHERE `owner`=%i", count, user.vkid)
	end

	rmsg:lines(user_contribution.count~=0 and { "💻 Счет: %s яриков.", comma_value(user_contribution.count) } or "💻 Ваш счет обнулён.")

	write_history()
end)

user_pop = user_pop or {}

command:addmsub("взломать", "<10-999>", "i", function(msg, args, other, rmsg, user, code)
	if msg.peer_id == 2000000002 then return "🚫 Эта команда запрещена в этой беседе." end
	if bank_bans[user.vkid] then return "🚫 Вы не можете взломать текущий код, Вас ищет полиция." end
	ca(code >= 10 and code < 1000, "🚫 Пин-код содержит только три цифры.")
	local price = 10000 + math.random(10000)
	if user_pop[user.vkid] then price = price + user_pop[user.vkid] end

	user:checkMoneys(price)

	user_pop[user.vkid] = math.floor(user_pop[user.vkid] and user_pop[user.vkid] * 1.3 or 1000)

	if code ~= tonumber(db.select_one('value', 'keyvalue', "id=3").value) then
		if user.banktries>1 then
		user:addMoneys(-price)
		db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "id=1").value) + price)
		write_history()
		db("UPDATE `accounts` SET `banktries`=`banktries`-1 WHERE `vkid`=%i", tonumber(user.vkid))
		return rmsg:line("🛡 Сработала защита.\n🚫 У Вас осталось попыток до приезда полиции: %s.", user.banktries-1); --"\n#⃣  Попробуйте получить подсказку командой `банк подсказка`."
	else
		user:addMoneys(-price)
		db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "id=1").value) + price)
		write_history()
		db("UPDATE `accounts` SET `banktries`=`banktries`-1 WHERE `vkid`=%i", user.vkid)
		bank_bans[user.vkid] = true
		return "🛡 Вас вычислили!\n🚫 Вам пришлось убежать."
	end
	end

	user_pop = {}

	local count = math.random(math.random(math.min(10000000, tonumber(db.select_one('value', 'keyvalue', "id=1").value))))
	db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "id=1").value) - count)
	db("UPDATE `keyvalue` SET `value`='%s' WHERE id=3", math.random(899) + 100)
	user:addMoneys(count)
	VK.messages.send {
		message = string.format("💸 %s взломал банк!\n🔓 Ущерб: %s бит!", user:r(), crv(count)),
		peer_id = 2000000002
	}

	bank_bans = {}
	db("UPDATE `accounts` SET `banktries`=10")

	rmsg:lines(
		{ "💸 Вы украли %s бит!", crv(count) }
	)

	user:unlockAchiv('hacker', rmsg)

	write_history()
end)

--[[
command:addsub("подсказка", function(msg, args, other, rmsg, user)
	ca(msg.peer_id == 2000000002, "эта команда доступна только в EVA COOL")
	user:buy(15000000)
	db("UPDATE `keyvalue` SET `value`='%s' WHERE id=1", tonumber(db.select_one("value", "keyvalue", "id=1").value) + 15000000)
	trand({ slivpin_bm, slivpin_chet, slivpin_odna })()
	write_history()
	return
end)
]]


function command.exe(msg, args, other, rmsg, user)
	local user_contribution = db.select_one("*", "bank_contributions", "owner=%i", user.vkid)
	local course = get_course()

	local bdg = tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)
	local all = db.select_one("SUM(count)", "bank_contributions")["SUM(count)"]
	local p = math.floor(bdg/all*100)

	rmsg:lines(
		{ "💷 Бюджет: %s бит.", crv(tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)) },
		user:getValue('bankstatus') == 'lim' and { "⭐ Тип счёта: ограниченный" },
		user:getValue('bankstatus') == 'sim' and { "⭐ Тип счёта: базовый" },
		user:getValue('bankstatus') == 'full' and { "⭐ Тип счёта: полный" },
		{ "💹 Курс ярика: %i бит.", math.floor(course) },
		(user_contribution and user:getValue'bankstatus'=='lim') and { "💻 Счет:\n↳ %s/15'000 ярик.", comma_value(user_contribution.count) },
		(user_contribution and user:getValue'bankstatus'=='sim') and { "💻 Счет:\n↳ %s/60'000 ярик.", comma_value(user_contribution.count) },
		(user_contribution and user:getValue'bankstatus'=='full') and { "💻 Счет:\n↳ %s/600'000 ярик.", comma_value(user_contribution.count) },

		user_contribution and "\n💡 Введите `банк продать`, чтобы продать ярики.",
		not user_contribution and "\n💡 Введите `банк купить`, чтобы купить ярики."
	)

	--[[local url = "https://elektro-volk.ru/cpyi.php?cht=lc&chs=700x200&chd=t:"
	for i,v in db.iselect("value", "bankhistory", "1 LIMIT 100") do
		url = url .. v.value .. ','
	end
	net.send(url)
]]
	--rmsg.attachment = upload.get("photo_messages", msg.peer_id, "/var/www/img.png")
end

return command