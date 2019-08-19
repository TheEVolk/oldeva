timers.create(10000, 0, function()
    local unreaded_dialog_response = VK.messages.getConversations { filter = 'unread' }.response
    if not unreaded_dialog_response or not unreaded_dialog_response.items or not unreaded_dialog_response.items[1] then return end

    local dialog = unreaded_dialog_response.items[#unreaded_dialog_response.items]
    if os.time() - dialog.last_message.date < 300 then return end

    --print(json.encode(dialog))

    if not db.get_user(dialog.conversation.peer.id):checkBan() and dialog.conversation.can_write.allowed then
        VK.messages.send {
            message = "Привет, похоже ты писал мне, а я тебе не ответила. Сейчас я работаю, можешь написать мне :)",
            peer_id = dialog.conversation.peer.id
        }
    else
        VK.messages.markAsRead {
            peer_id = dialog.conversation.peer.id
        }
    end
end)
