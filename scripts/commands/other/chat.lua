local command = botcmd.new("беседа", "Попасть в чат Евы")

command.exe = function (msg, args, other, rmsg, user)
    --ca (user.rep > -5, "не хочу я тебя добавлять, я на тебя обиделась!");

    VK.friends.add { access_token = evatoken,  user_id = user.vkid };
    local response = VK.friends.areFriends { access_token = evatoken, user_ids = user.vkid }.response[1];
	ca (response.friend_status == 3, "добавьте @evarobot в друзья. Это требуется для того, чтобы добавить вас в беседу от её имени. После этого из друзей её можно будет удалить.", "беседа");

    VK.messages.addChatUser { chat_id = 306, user_id = user.vkid, access_token = evatoken };

    if db.select_one("id", "eca", "vkid=%i", msg.from_id) then
		db("UPDATE eca SET date=%i WHERE vkid=%i", os.time() - 432000 + 1200, msg.from_id)
	else
		db("INSERT INTO eca VALUES(NULL, %i, %i)", msg.from_id, os.time() - 432000 + 1200)
	end

    return "🍭 Правила » https://vk.com/@evarobotgroup-evacool-rules";
end

return command;
