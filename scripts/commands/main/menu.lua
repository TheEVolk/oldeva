local command = botcmd.new("меню", "главное меню бота", {dev=1})

command:addsub("прочее", function(msg, args, other, rmsg, user)
    local level = levels.levels[user.level]

    rmsg:lines(
        { "💳 Ваш баланс: %s бит.", user:getMoneys() },
        { "💎 Ваш уровень: %s (%i/%i)", level.name, user.score, level.maxscore }
    )

    numcmd.menu_funcs(rmsg, user, {
        { { 1, "💵 Донат", botcmd.commands['донат'].exe } },
        { { 2, "📰 Информация", botcmd.commands['информация'].exe } },
        { { 3, "Назад", botcmd.commands['меню'].exe } },
    })
end)

local function alert(cond, smile) return cond and smile or '❗' end

function command.exe(msg, args, other, rmsg, user)
    local level = levels.levels[user.level]

    rmsg:lines(
        { "💳 %s бит.", user:getMoneys() },
        { "💎 %s.", level.name },
        { "✨ Опыт: %i/%i.", user.score, level.maxscore }
    )

    numcmd.menu_funcs(rmsg, user, { {
            { 1, "👤 Я", botcmd.commands['профиль'].exe },
            { 2, alert(user.job ~= 0, '💰') .. " Работа", botcmd.commands['работа'].exe },
            { 3, alert(db.select_one('id', 'tr_obj', 'owner=%i', user.vkid), '🚘') .. " Авто", botcmd.commands['тр'].exe },
        }, {
            { 4, alert(db.select_one('id', 'p_pets', 'owner=%i', user.vkid), '🐱') .. " Питы", botcmd.commands['пит'].exe },
            { 5, alert(user.clan ~= 0, '👥') .. " Клан", botcmd.commands['клан'].exe },
            { 6, alert(user.home ~= 0, '🏘') .. " Дом", botcmd.commands['дом'].exe },
        }, {
            { 7, "💷 Банк", botcmd.commands['банк'].exe },
            { 8, "🖲 Помощь", botcmd.commands['помощь'].exe },
        }, {
            { 9, "💖 Достижения", botcmd.commands['ачивки'].exe },
            { 10, "⬜ Прочее", botcmd.commands['меню'].sub['прочее'] },
        },
        {
             { 11, "💵 Купите донат", botcmd.commands['донат'].exe },
             { 12, "🗃  Кейсы", botcmd.commands['кейс'].exe },
         }
    })
end

return command
