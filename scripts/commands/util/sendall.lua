local command = botcmd.mnew("рассылка", "Рассылка сообщений пользователям бота", "<сообщение>", "d", {dev=1, right='distrib'})

function command.exe (msg, args, other, rmsg, user, data)
    db("UPDATE `accounts` SET `balance` = `balance` + 5000 WHERE `notifications` = '1'")

    local message_to_send = {
        message = data.."<br><br>🔕 Чтобы отключить рассылку, используйте » Уведомления\n💵 Вы получили 5'000 бит за уведомление.",
    }

    if msg.attachments[1] and msg.attachments[1].type == "wall" then
        message_to_send.attachment = "photo-134466548_456276989,wall"..msg.attachments[1].wall.from_id.."_"..msg.attachments[1].wall.id
    end

    local start_time = os.time()

    -- Получим все беседы
    --[[local con_count = 0
    local offset = 0
    local to_send_chats = { }
    repeat
        local group_list = VK.messages.getConversations({ count = 200, offset = offset }).response
        offset = offset + 200
        for i,v in ipairs(group_list.items) do
            print(v.conversation.peer.type)
            if v.conversation.peer.type == "chat" then
                print(v.conversation.peer.type)
                table.insert(to_send_chats, v.conversation.peer.id)
            end
        end

    until #group_list.items == 0

    console.log("SENDALL", "Найдено %i чатов.", #to_send_chats)
    local sended_count = 1

    while sended_count < #to_send do
        local ids = {}
        for j = 1,100 do
            if sended_count >= #to_send then break end
            table.insert(ids, to_send[sended_count].vkid)
            sended_count = sended_count + 1
        end
        message_to_send.user_ids = table.concat(ids, ',')
        vk.send("messages.send", message_to_send)
        console.log("SENDALL", "%i%%", math.floor(sended_count/#to_send*100))
    end
]]
    local to_send = db("SELECT `vkid` FROM `accounts` WHERE `notifications` = '1'")
    local sended_count = 1

    while sended_count < #to_send do
        local ids = {}
        for j = 1,100 do
            if sended_count >= #to_send then break end
            table.insert(ids, to_send[sended_count].vkid)
            sended_count = sended_count + 1
        end
        message_to_send.user_ids = table.concat(ids, ',')
        vk.send("messages.send", message_to_send)
        console.log("SENDALL", "%i%%", math.floor(sended_count/#to_send*100))
    end

    rmsg:lines(
        { "✔ Рассылка сообщений игрокам завершена за %i сек.", os.time()-start_time },
        { "🙆‍♂ Примерно отправлено » %i", #to_send }
    )
end

return command
