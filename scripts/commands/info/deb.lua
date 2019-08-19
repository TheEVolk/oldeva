local command = botcmd.new("деб", "техническая информация по нагрузке", {dev=1})

function command.exe(msg, args, other, rmsg, user)
    local accounts_count = db.get_count("accounts")
    local online_count = online.get_count()

    local mysql_status = db("show status where variable_name = 'threads_connected'")[1]
    local pool = poolinfo();
    local pool_str = {}

    for i = 1, #pool do
        table.insert(pool_str, pool[i] and '▫' or '▪')
    end

    local start_time = os.clock()
    db("SELECT * FROM accounts")
    local end_time = os.clock() - start_time

    rmsg:lines(
        { "⚙ Техническая информация" },
        { "➤ Движок >> EBotPlatform V%s", _VERSION },
        { "➤ Аптайм >> %s", get_parsed_time(uptime()) },
        { "➤ Онлайн >> %i чел. (%.2f%%)", online_count, online_count/accounts_count*100 },
        { "➤ Потоки >> %i", #pool },
        { "➤ Время БД запроса >> %s мс.", end_time * 1000 },
        --{ "➤ Кол-во клиентов БД >> %s", mysql_status['Threads_connected'] },
        { "➤ Потоки: %s", table.concat(pool_str, '') }
    )
end

return command
