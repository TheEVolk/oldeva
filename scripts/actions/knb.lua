local codes = { ['камень'] = 1, ['ножницы'] = 2, ['бумага'] = 3 };

local action = {
    exe = function (msg, data, other, rmsg, user)
        return "используй команду кнб"
    end
};
return action;
