local action = {
    exe = function (msg, data, other, rmsg, user)
        local name = data.parameters.name;
        local root = data.parameters.root or data.outputContexts[1].parameters.root;

        local obj = ca (DbData.mc("SELECT * FROM `world_objects` WHERE `name` = '%s'", name)[1], "а что такое "..name.."?");

        local fo = DbData.mc("SELECT * FROM `world` WHERE `name` = '%s'", name)[1];
        ca (not fo, "а этот предмет уже лежит в "..(fo and fo.root or ''));

        if #root > 0 then
            local fo = DbData.mc("SELECT * FROM `world` WHERE `name` = '%s'", root)[1];
            ca (fo, "а "..root.." не существует. Положи его.");
        end

        DbData.mc("INSERT INTO `world`(`name`, `root`, `owner`) VALUES ('%s', '%s', %i)",
            name, root, user.vkid
        );


        return "положила " .. name .. " в " .. root;
    end
};
return action;
