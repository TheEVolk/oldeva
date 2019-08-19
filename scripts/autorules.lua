hooks.add_action("bot_check", function(msg)
	if msg.peer_id ~= 2000000002 then return end
	hooks.do_action("check_evacool", msg)

	-- ACTIVE
	if db.select_one("id", "eca", "vkid=%i", msg.from_id) then
		db("UPDATE eca SET date=%i WHERE vkid=%i", os.time(), msg.from_id)
	else
		db("INSERT INTO eca VALUES(NULL, %i, %i)", msg.from_id, os.time())
	end
end)

local function kick_violator(user_id, text)
	console.log("AUTORULES", "Kick vk.com/id%i [%s]", user_id, text)
	if text then VK.messages.send { message = "⚠ "..text, peer_id = 2000000002, math.random(9 ^ 9 * 10000000000) } end
	VK.messages.removeChatUser { chat_id = 2, user_id = user_id }
end

hooks.add_action("check_evacool", function(msg)
	if not msg.text or not msg.text:starts("VK CO FF EE") then return end
	kick_violator(msg.from_id, "В данной беседе запрещено шифровать сообщения. [флуд]")
end)

hooks.add_action("check_evacool", function(msg)
	if not msg.action or msg.action.type ~= "chat_kick_user" then return end
	kick_violator(msg.from_id)--"Пользователь исключен в целях безопасности.")
end)

timers.create(600000, 0, function()
	local to_kick = {}

	local users = VK.messages.getChat { chat_id = 306, access_token = evatoken }.response.users
	for i,user_id in ipairs(users) do
		if user_id ~= 311346896 and user_id > 0 and not db.select_one("id", "eca", "vkid=%i AND %i-`date` <= 432000", user_id, os.time()) then
			table.insert(to_kick, user_id)
		end
	end

	if #to_kick == 0 then return end

	local message = "⚠ "..#to_kick.." чел. будут исключены из-за отсутствия актива."
	if #to_kick == 1 then message = "⚠ Пользователь исключен из-за отсутствия актива." end
	--VK.messages.send { message = message, peer_id = 2000000002, math.random(9 ^ 9 * 10000000000) }

	for i,user_id in ipairs(to_kick) do
		console.log("AR", vk.send("messages.removeChatUser", {
			chat_id = 2,
			user_id = user_id
		}))
	end
end)
