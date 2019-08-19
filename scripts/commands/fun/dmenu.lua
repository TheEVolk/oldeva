local command = botcmd.new("дменю", "донатное меню бота", {dev=1})

function command.exe(msg, args, other, rmsg, user)
    local level = levels.levels[user.level]

    rmsg:lines(
        { "💳 Ваш донат баланс >> %s бит.", user:getMoneys() },
        { "💎 Ваш донат уровень >> %s • %i/%i", level.name, user.score, level.maxscore }
    )

    numcmd.menu_funcs(rmsg, user, {
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
        {
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
            { 1, "💵 Донат", botcmd.commands['донат'].exe, "positive" },
        },
    })
end

return command
