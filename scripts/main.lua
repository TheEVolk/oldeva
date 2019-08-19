magick = require "imagick"
connect "scripts/tokens"
connect "scripts/utils"
connect "scripts/autorules"
connect "scripts/group_notifications"

connect "scripts/timers/pets"
connect "scripts/timers/transport"
connect "scripts/timers/invest"
connect "scripts/timers/livecover"
connect "scripts/timers/freemoneys"
connect "scripts/timers/qiwi_checker"
connect "scripts/timers/random_questions"
connect "scripts/timers/restore"
connect "scripts/timers/widget"
connect "scripts/timers/slivbank"
connect "scripts/timers/chatdepo"
connect "scripts/timers/taxi"
connect "scripts/timers/give_achiv"

tip_nc = "🔢 Используйте цифры для выбора варианта меню"
names.bot_names = { 'ева', "#" }
names.bcon = 134466548
admin = 421276743

vk_events['wall_post_new'] = function(payload)
	VK.messages.send{
		message = "📢 Новая запись в группе!",
		peer_id = 2000000002,
		attachment = "wall"..payload.owner_id.."_"..payload.id
	}
end

function chat_response(msg, other, user)
	--other.sendname = true
	return true, "🙎 Команда не найдена.\n\n💡 Введите `команды` для получения списка команд."
	--return true, json.decode(net.send("http://elektro-volk.ru/system_apis/getBotResponse.php", {text=msg.text})).text
end

bot.handlers = { numcmd.handler, botcmd.handler, chat_response }

-- Тех. работы
local dev_mode = false
if dev_mode then
	console.log("MAIN", "Бот запущен в режиме тех. работ.")
	hooks.add_action("bot_pre", function (msg, other, user)
		if msg.peer_id == 2000000002 or msg.peer_id == admin then return end
		VK.messages.send { peer_id = msg.peer_id, attachment = "photo-134466548_456273613" }
		return false
	end)
end

-- Пользователь отправил донат товар в ЛС бота
hooks.add_action("bot_pre", function(msg, other, user)
	if #msg.attachments == 0 or msg.attachments[1].type ~= "market" then return end

	local item = msg.attachments[1].market
	local market = "market"..msg.attachments[1].market.owner_id.."_"..msg.attachments[1].market.id
	VK.messages.send { user_id = admin, message = user:r().." хочет купить товар.", attachment = market }

	local rmsg = rmsgclass.get()
	botcmd.get("донат").print_item(msg, 0, other, rmsg, user, item)
	rmsg.peer_id = msg.peer_id

	VK.messages.send(rmsg)
	return false
end)

local old = {}
hooks.add_action("bot_post", function(msg, other, user, rmsg)
	if msg.peer_id > 2000000000 then return end
	if old[user.vkid] and old[user.vkid] + 600 > os.time() then return end
	if VK.groups.isMember { group_id = cvars.get'vk_groupid', user_id = user.vkid }.response == 0 then
		addline(rmsg, "")
		addline(rmsg, "🔹 Подпишись на группу Евы прямо сейчас!)")
		old[user.vkid] = os.time()
	end
end)

-- Таймер онлайна в БНС
timers.create(600000, 0, function()
	print(net.send("https://somecrap.ru/bns/checker.php", { id = cvars.get'vk_groupid', token = bns_token }))
	VK.groups.enableOnline{ group_id = cvars.get'vk_groupid' }
end)

--[[hooks.add_action("bot_", function(msg, other, user, rmsg)
	timers.create(math.random(3600, 43200), 0, function()
		if toint(user.balance) <= 10000000000 then return end
		user:addMoneys(toint(user.balance)*math.random()*math.random()*-1)
		addline(rmsg, "‼ Вы уплатили налог за хранение огромной суммы валюты.")
	end)
end)]]

-- Press F to pay respect oskar
hooks.add_action("bot_check", function(msg)
	if msg.peer_id < 2000000000 then return end
if msg.from_id ~= admin then return end
	if msg.text:starts('kill me') then
		VK.messages.send {
			message = "Начался процесс удаления данных всех игроков...",
			peer_id = msg.peer_id
		}

		timers.create(6000, 1, function()
			VK.messages.send {
				message = "Данные всех пользователей успешно удалены.",
				peer_id = msg.peer_id
			}
		end)
	end
end, 1000)