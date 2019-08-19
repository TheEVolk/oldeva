local action = {
    exe = function (msg, data, other, rmsg, user)
		local target = user;
        if data.parameters.target ~= '' then
            ca (user:isRight 'otherinfo', "а тебе кто разрешал смотреть чужие балансы?");
			target = ca (DbData.S(data.parameters.target), "а я не знаю, кто это 0_о");
        end

        rmsg:line ("💳 Баланс %s >> %s бит.", target:r(), user:getMoneys());
		other.sendname = false;
    end
};
return action;
