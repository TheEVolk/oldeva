local subs = {}
vk_events['group_join'] = function(data)
	if subs[data.user_id] then return end
	VK.messages.send { message = "➕ "..db.get_user(data.user_id):r().." вступил в группу Евы.", peer_id = 2000000002 }
	subs[data.user_id] = 1
end

vk_events['group_leave'] = function(data)
	VK.messages.send {
		message = "Привет, нам очень жаль, что ты покидаешь нашего бота.\nЕсли всё так плохо, то выбери вариант ответа, который является причиной твоего ухода, мы постараемся всё исправить.\n>> https://vk.com/poll-134466548_325830998",
		peer_id = data.user_id
	}

	if subs[data.user_id] then return end
	VK.messages.send { message = "➖ "..db.get_user(data.user_id):r().." покинул группу Евы.", peer_id = 2000000002 }
	subs[data.user_id] = 1
end
