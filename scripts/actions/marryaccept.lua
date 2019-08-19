braks = braks or {};

return {
    exe = function (msg, data, other, rmsg, user)
        ca (user.job == 38, "вы не Работник ЗАГСа")
        local brak = ca (braks[tonumber(data.parameters.bid)], "мы не нашли брака с таким ID");

        braks[tonumber(data.parameters.bid)] = nil;
        brak[1]:set('married', brak[2].vkid);
        brak[2]:set('married', brak[1].vkid);

        user:addMoneys(20000, "свадьба");

        rmsg:line ("&#128107; %s и %s теперь состоят в браке!", brak[1]:r(), brak[2]:r());
        rmsg:line ("&#128145; Можете поцеловаться!");
        other.sendname = false;
    end
};
