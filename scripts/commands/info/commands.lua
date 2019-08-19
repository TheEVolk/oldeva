--[[
    Вывод списка команд.
    botcmd.new("команда", "описание", "смайл"[, { ... }])
]]
local command = botcmd.new("команды", "список команд бота", {dev=1})

command.categories = {
    -- { "смайл", "имя", "ярлык" }
    { "💡", "Основные", "main" },
    { "🎮", "Миниигры", "games" },
    { "🔮", "RolePlay", "roleplay" },
    { "😀", "Развлекательные", "fun" },
    { "🏬", "Игровой магазин", "shop" },
    { "⚙", "Настройки", "settings" },
    { "📜", "Информация", "info" },
    { "🔨", "Утилиты", "util" },
    { "⬛", "Прочее", "other" },
}

function command.exe (msg, args, other, rmsg, user)
    if tonumber(args[2]) then return command.print_category(msg, tonumber(args[2]), other, rmsg, user) end

    numcmd.linst(user, command.print_category)

    rmsg:line("🗃 Доступные категории команд:")
    for i,cat in ipairs(command.categories) do rmsg:line("► %s %i. %s", cat[1], i, cat[2]) end
    rmsg:line("\n💡 Используй цифры для получения варианта меню.")
end

function command.print_category(msg, num, other, rmsg, user)
    local cat = ca(command.categories[num], "категория не найдена", "команды")

    rmsg:line("%s Категория <<%s>>", cat[1], cat[2])
    for key,com in pairs(botcmd.commands) do
        if com.type == cat[3] and (not com.right or user:isRight(com.right)) then
            rmsg:line("► %s %s \n↳ %s", com[1], com.use or '', com[2])
        end
    end

    if msg.peer_id > 2000000000 then
        user:ls(rmsg.message)
        rmsg.message = "👓 Отправила список команд в твои личные сообщения, чтобе не загрязнять чат <3"
    end
end

return command
