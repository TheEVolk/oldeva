local command = botcmd.new("мат", "математические примеры")
command.games = {}

function command.exe(msg, args, other, rmsg, user)
    local profile = command.games[user.vkid] or { level = 1 };
    if profile.response and toint(args[2]) then
        if profile.response == toint(args[2]) then
            --rmsg:line "✔ Молодец, давай дальше.";
            profile.level = math.min(profile.level + 1, 100);
            user:addMoneys(50 + math.random(50) + profile.level * math.random(10));
            --user:addScore(2);
        else
            rmsg:line ("✖ Нет. Правильный ответ: %i", profile.response);
            profile.level = 1;
        end
    end

    user:buy(50);
    local complexity = 1 + math.floor(profile.level / 10);
    local obj = math.random(100);
    for i = 1, complexity do
        if math.random(100) > 90 then obj = '('..obj..')' end
        local operation = trand { '+', '-' }
        obj = math.random (100) > 50 and obj..' '..operation..' '..math.random(100) or math.random(100)..' '..operation..' '..obj;
    end

    profile.response = load("return "..obj)();
    local success_button = math.random(4);
    local function getn (num) return success_button == num and profile.response or profile.response + math.random(20) - 10 end
    rmsg.keyboard = [[{
        "one_time": true,
        "buttons": [
            [{"action": {"type": "text","label": "мат ]] .. getn(1) .. [["},"color": "default"},
            {"action": {"type": "text","label": "мат ]] .. getn(2) .. [["},"color": "default"},
            {"action": {"type": "text","label": "мат ]] .. getn(3) .. [["},"color": "default"},
            {"action": {"type": "text","label": "мат ]] .. getn(4) .. [["},"color": "default"}]
        ]
    }]];

    rmsg:line ("◻ Сколько будет %s?", obj);
    rmsg:line ("💎 Ваш уровень >> %i", profile.level);
    rmsg:line "➡ мат <ответ>";

    command.games[user.vkid] = profile;
end
--[[
rmsg.keyboard = [[{
    "one_time": true,
    "buttons": [
        [{"action": {"type": "text","label": "помощь 1 - Профиль"},"color": "default"}],
        [{"action": {"type": "text","label": "помощь 2 - Игровые"},"color": "default"}],
        [{"action": {"type": "text","label": "помощь 3 - Информация"},"color": "default"}],
        [{"action": {"type": "text","label": "помощь 4 - RolePlay"},"color": "default"}],
        [{"action": {"type": "text","label": "помощь 5 - Технические"},"color": "default"}],
        [{"action": {"type": "text","label": "помощь 6 - Прочее"},"color": "default"}]
    ]
}]]
return command;
