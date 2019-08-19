local action = {
    exe = function (msg, data, other, rmsg, user)
        ca (user:isRight 'ban', "а тебе нельзя никого разбанивать)");
        local targeturl = data.parameters.target;
        ca (#targeturl ~= 0, "ты кого собрался разбанить?")
        local target = ca (DbData.S(targeturl), "а я не знаю, кто это 0_о");

        if target.rep <= -20 then
            user:add('rep', -1);
            if user.rep < 0 then
                user:banUser(300);
                if msg.peer_id == 2000000002 then
                    other.postsend = function (msg, other, user, rmsg)
                        VK.messages.removeChatUser { access_token = evatoken, chat_id = 306, user_id = user.vkid };
                    end
                end
                return "все, ты меня задолбал!"
            end
            return "я не хочу его разбанивать. Он меня бесит.";
        end

        target:unban();
        Notify.Log(37639194, user:r().." разбанил "..target:r());

        if target.rep < 0 then return "разбанила этого [id"..target.vkid.."|придурка]." end

        return target:r() .. " разбанен :)";
    end
};
return action;
