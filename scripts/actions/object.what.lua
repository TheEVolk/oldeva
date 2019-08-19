local action = {
    exe = function (msg, data, other, rmsg, user)
        local name = data.parameters.name;

        local obj = ca (DbData.mc("SELECT * FROM `world` WHERE `name` = '%s'", name)[1], "а его нигде нет");
        local childs = DbData.mc("SELECT * FROM `world` WHERE `root` = '%s'", name);


        rmsg:line("%s лежит %s", name, #obj.root > 0 and "в "..obj.root or '');
        rmsg:line("Владелец: %s", NameSystem.GetR(obj.owner));
        if #childs > 0 then
            local content = 'Содержимое: ';
            for i = 1, #childs do content = content .. childs[i].name .. '; ' end
            rmsg:line (content);
        end
    end
};
return action;
