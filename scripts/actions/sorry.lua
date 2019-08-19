local action = {
    exe = function (msg, data, other, rmsg, user)
        ca (user.rep < 0, "я не злюсь на тебя");
        ca (user.rep > -20, "нет тебе прощения за такое!");

        user:add('rep', math.random(6));
        if user.rep < 0 then return "я еще подумаю" end

        return "ладно, так уж и быть.";
    end
};
return action;
