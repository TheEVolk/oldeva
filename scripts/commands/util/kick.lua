local command = botcmd.mnew("кик", "исключить пользователя из беседы", "<ссылка> <причина>", "Ud", {right='kick', dev=1})

function command.exe(msg, args, other, rmsg, user, target, reason)
    local resp = VK.messages.removeChatUser {
        --access_token = evatoken,
        chat_id = msg.peer_id - 2000000000,
        user_id = target.vkid,
        --group_id = cvars.get 'vk_groupid'
    }
    ca (not resp.error, "пользователь не в беседе")

    target:ls ("&#128094; Вы были исключены из беседы.<br>📄 Причина >> %s<br>&#128003; Исключил >> %s", reason, user:r())
    rmsg:line("👞 %s был исключен из беседы.", target:r())
    rmsg:line("📄 %s", reason)
end

return command
