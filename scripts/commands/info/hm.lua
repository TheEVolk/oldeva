local command = botcmd.new("хм", "HostMotion сервера", {right='dev'})
--[[
command.categories = {
    -- { "смайл", "имя", "ярлык" }
    { "📰", "Minecraft", "info" },
    { "📍", "Counter Strike", "roleplay" }
}

function command.exe (msg, args, other, rmsg, user)
    if tonumber(args[2]) then return command.print_category(msg, tonumber(args[2]), other, rmsg, user) end

    rmsg:line("🗃 Доступные категории команд:")
    for i,cat in ipairs(command.categories) do
        rmsg:line("➤ %s %i. %s", cat[1], i, cat[2])
    end

    rmsg:stip("команды <номер категории>", "получить список команд")
    numcmd.linst(user, command.print_category)
end

function command.print_category(msg, num, other, rmsg, user)
    local cat = ca(command.categories[num], "категория не найдена", "команды")

    rmsg:line("%s Категория <<%s>>", cat[1], cat[2])
    for key,com in pairs(botcmd.commands) do
        if com.type == cat[3] then
            rmsg:line("➤ %s %s %s - %s", com.smile or '', com[1], com.use or '', com[2])
        end
    end
end
]]
return command
