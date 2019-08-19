local action = {
    exe = function (msg, data, other, rmsg, user)
        if true then return "err:вы не можете отправлять биты" end

        local targeturl = data.parameters.target;
        local count = data.parameters.count;
        local target = ca (db.get_user_from_url(targeturl), "а я не знаю, кто это 0_о");

        ca(target.vkid ~= user.vkid, "вы не можете отправить биты самому себе");
        ca(count > 1, "ты жадный");
        user:checkMoneys(count);

        target:addMoneys(count, "Биты от vk.com/id"..user.vkid);
    	user:addMoneys(-count, "Отправка бит на vk.com/id"..target.vkid);
    	target:ls("%s отправил вам %i бит", user:r(), count);

    	rmsg:line ("вы отправили биты на счет "..target:r());
    end
};
return action;
