local action = {
    exe = function (msg, data, other, rmsg, user)
        local targeturl = data.parameters.target;
        local text = data.parameters.text;

        --if true then return "Я НАСТОЛЬКО ТУПАЯ, ЧТО НЕ ЗНАЮ "..targeturl end

        ca (#targeturl ~= 0, "ты кого собрался кикать?")
        ca (#text ~= 0, "а за что ты его кикаешь?")
        local target = ca (targeturl == 'меня' and user or DbData.S(targeturl), "а я не знаю, кто это 0_о");

        ca (user:isRight 'kick' or targeturl == 'меня', "а тебе нельзя никого кикать)");
        ca (ischat(msg), "только в беседе");
        --ca (msg.peer_id == 2000000002, "только в EVA COOL");
--msg.peer_id - 2000000000
    	local resp = VK.messages.removeChatUser { access_token = evatoken, chat_id = msg.peer_id - 2000000000, user_id = target.vkid, group_id = cvars.get 'vk_groupid' };
    	ca (not resp.error, "Он не в беседе");

        target:ls ("&#128094; Вас исключили по причине: <<%s>><br>&#128003; Исключил: %s", text, user:r());

        return "я только что исключила " .. target:r() .. " из беседы.<br>&#128094; "..text;
    end
};
return action;
