local action = {
    exe = function (msg, data, other, rmsg, user)
        local name = data.parameters.name;
        local desc = data.parameters.desc;

        local fo = DbData.mc("SELECT * FROM `world_objects` WHERE `name` = '%s'", name)[1];
        ca (not fo, "я так то знаю, что это "..(fo and fo.desc or ''));

        DbData.mc("INSERT INTO `world_objects`(`name`, `desc`, `owner`) VALUES ('%s', '%s', %i)",
            name, desc, user.vkid
        );

        return "буду знать :)";
    end
};
return action;
