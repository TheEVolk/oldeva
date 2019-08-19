local command = botcmd.new("чистка", "чистка беседы EVA COOL от неактивных участников", {right="clear",dev=1})

function command.exe(msg, args, other, rmsg)
	local users = VK.messages.getChat { chat_id = 306, access_token = evatoken }.response.users

	local count = 0;
	for i = 1, #users do
		local user_id = users[i]
		--if user ~= 311346896 and user ~= admin then
		if user_id ~= 311346896 and not db.select_one("id", "eca", "vkid=%i AND %i-`date` <= 86400", user_id, os.time()) then
			--rmsg:line(user_id)
			local resp = VK.messages.removeChatUser {
		        access_token = evatoken,
		        chat_id = 2,
		        user_id = user_id,
		        group_id = cvars.get 'vk_groupid'
		    }
			if resp.error then
				os.execute 'sleep 3'
				i = i - 1
				console.log("Clear", "repeat")
			else
				count = count + 1
			end
		end
	end
	rmsg:lines(
		"✔ Беседа успешно очищена от неактивных участников",
		{ "⚪ Удалено %i пользователей :)", count }
	)
end

return command;
