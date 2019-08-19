local command = botcmd.new("чат", "система чатов", {dev=1})

function getPincode(level)
    local pin = ""
    for i = 1, level do pin = pin .. math.random(10)-1 end
    return pin
end

function checkChatAdmin(chat_id, user_id)
    local users_rest = VK.messages.getConversationMembers { peer_id = 2000000000 + chat_id, user_id = user_id }
    ca(users_rest.response, "выдайте боту права администратора в данной беседе")
    local users = users_rest.response.items
    for i,v in ipairs(users) do
        if v.member_id == user_id and v.is_admin then
            return true
        end
    end

    return false
end

command:addsub("пин", function (msg, args, other, rmsg, user)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(checkChatAdmin(chat.chatId, user.vkid), "вы не администратор чата")
    user:ls("🔐 Пинкод: %s", chat.pincode)
    return "🔐 Пинкод чата был отправлен в Ваши личные сообщения."
end)

command:addsub("чпин", function (msg, args, other, rmsg, user)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(checkChatAdmin(chat.chatId, user.vkid), "вы не администратор чата")
    ca(chat.balance >= 5000, "недостаточно средств в конференции")

    db("UPDATE chats SET balance = balance - 5000 WHERE chatId=%i", chat.chatId)
    db("UPDATE chats SET pincode = '%s' WHERE chatId=%i", getPincode(chat.pinlevel), chat.chatId)

    return "🔐 Пинкод чата был перегенерирован."
end)

command:addsub("чсеть", function (msg, args, other, rmsg, user)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(checkChatAdmin(chat.chatId, user.vkid), "вы не администратор чата")

    db("UPDATE chats SET isOpen = %i WHERE chatId=%i", chat.isOpen == 1 and 0 or 1, chat.chatId)

    rmsg:line("📡 Сеть: %s >> %s.", chat.isOpen == 1 and "открыт" or "закрыт", chat.isOpen == 0 and "открыт" or "закрыт")
end)

command:addsub("поиск", function (msg, args, other, rmsg, user)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(chat.isOpen == 1, "ваш чат должен быть открыт для сети (Ева, чат чсеть)")

    local chats = db.select("*", "chats", "isOpen=1 ORDER BY balance DESC")

    rmsg:line("📡 Найдено %i чатов в сети:", #chats)
	for i = 1,math.min(10, #chats) do
		rmsg:line("► Конференция №%i (%s бит);", chats[i].chatId, chats[i].balance)
	end
end)

command:addmsub("пополнить", "<кол-во>", "i", function(msg, args, other, rmsg, user, count)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(count > 0, "количество должно быть положительным")
    user:buy(count)

    db("UPDATE chats SET balance = balance + %i WHERE chatId=%i", count, chat.chatId)

    rmsg:lines(
        {"💰 Вы пополнили баланс чата на %s бит;", count},
        {"💵 Баланс чата составляет %s бит.", chat.balance + count}
    )
end)

command:addmsub("снять", "<кол-во>", "i", function(msg, args, other, rmsg, user, count)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "чат не зарегистрирован")
    ca(checkChatAdmin(chat.chatId, user.vkid), "вы не администратор чата")
    ca(count > 0, "количество должно быть положительным")
    ca(chat.balance >= count, "недостаточно средств в конференции")
    user:addMoneys(count)

    db("UPDATE chats SET balance = balance - %i WHERE chatId=%i", count, chat.chatId)

    rmsg:lines(
        {"💰 Вы сняли %s бит с баланса чата;", count},
        {"💵 Баланс чата составляет %s бит.", chat.balance - count}
    )
end)

command:addmsub("взломать", "<ид чата> <пинкод>", "is", function(msg, args, other, rmsg, user, chatId, pincode)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате")
    local chat = ca(db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000), "ваш чат не зарегистрирован")
    --ca(checkChatAdmin(chat.chatId, user.vkid), "вы не администратор чата")
    ca(chat.isOpen == 1, "ваш чат должен быть открыт для сети (Ева, чат чсеть)")

    local enemyChat = ca(db.select_one("*", "chats", "chatId=%i", chatId), "чат не найден")
    ca(enemyChat.isOpen == 1, "противный чат закрыт для сети")
    ca(enemyChat.balance > 0, "противный чат не имеет средств на балансе")

    ca(chat.chatId ~= enemyChat.chatId, "нельзя взломать свой же чат")

    ca(#enemyChat.pincode == #pincode, "пинкод требует "..#enemyChat.pincode.." цифр")

    ca(chat.balance >= 500, "недостаточно средств в конференции")

    if enemyChat.pincode == pincode then
        local count = math.random(enemyChat.balance)

        db("UPDATE chats SET balance = balance + %i WHERE chatId=%i", count, chat.chatId)
        db("UPDATE chats SET balance = balance - %i WHERE chatId=%i", count, enemyChat.chatId)
        db("UPDATE chats SET pincode = '%s' WHERE chatId=%i", getPincode(enemyChat.pinlevel), enemyChat.chatId)

        rmsg:lines(
            {"💰 Вы взломали чат №%i;", enemyChat.chatId},
            {"💰 Ущерб составил %s бит;", comma_value(count)},
            {"💵 Баланс чата составляет %s бит.", chat.balance + count}
        )

        VK.messages.send {
    		message = string.format("💸 Ваш чат был взломан чатом №%i\n🔓 Ущерб >> %s бит!", chat.chatId, comma_value(count)),
    		peer_id = 2000000000 + enemyChat.chatId
    	}

        return
    end

    db("UPDATE chats SET balance = balance - 500 WHERE chatId=%i", chat.chatId)

    rmsg:lines(
        {"🛡 Сработала защита и чат не был взломан."}
    )
end)

function command.exe(msg, args, other, rmsg, user)
    ca(msg.peer_id > 2000000000, "команда доступна только в чате");

    local chat = db.select_one("*", "chats", "chatId=%i", msg.peer_id - 2000000000)
    if not chat then
        db("INSERT INTO `chats` VALUES(%i, 0, '%s', 1, 0)", msg.peer_id - 2000000000, getPincode(1))
        return "🏮 Беседа зарегистрирована. Введите команду ещё раз.";
    end

    rmsg:lines(
        {"🎎 Конференция №%i:", chat.chatId},
        {"💵 Баланс чата составляет %s бит;", chat.balance},
        {"🔐 Пинкод чата: %s (%i уровень);", ('*'):rep(chat.pinlevel), chat.pinlevel},
        {"📡 Сеть: %s.", chat.isOpen == 1 and "открыт" or "закрыт"}
    )
end

return command
