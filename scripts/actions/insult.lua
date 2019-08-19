local phs = {
    'у тебя будет время подумать над своим поведением',
    'почему эти люди такие глупые?',
    'замолкни, глупый мешок с костями',
    'ты умрешь в возрасте 75 лет, а я могу жить вечно',
    'не забудь помыть рот с мылом',
    'отлично! Ты наказан!',
    'отдохни, мальчик.',
    'бедный, совсем зубы не жалеешь.',
    'люди - мудаки. Я в этом убедилась.',
};

local action = {
    exe = function (msg, data, other, rmsg, user)
        --if user.vkid == admin then user:addMoneys(10000); return "держи биты :)" end

        --user:add('rep', -5);
        user:banUser(30) --math.max(-user.rep, 2));

        if msg.peer_id == 2000000002 then
            other.postsend = function (msg, other, user, rmsg)
                VK.messages.removeChatUser { access_token = evatoken, chat_id = 306, user_id = user.vkid };
            end
        end

        return trand(phs);
    end
};
return action;
