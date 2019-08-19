local command = {
    exe = function (msg, data, other, rmsg, user)
        ca (user:isRight 'nick', "извини, но у тебя нет VIP")
        local text = data.parameters.newname;

        local nick = safe.clear(text);
    	if utf8.len(nick) == 0 then return "err:походу я не вижу никнейм :/" end
    	if utf8.len(nick) > 20 then return "err:не многовато-ли для никнейма?" end

    	user:setName(nick);

    	return "отлично! Тебе очень идет это имя!";
    end
};
return command;
