local command = botcmd.new("информация", "информация о боте", {dev=1})

local function get_course()
	local bdg = tonumber(db.select_one("value", "keyvalue", "`key`='bank'").value)
	local all = db.select_one("SUM(count)", "bank_contributions")["SUM(count)"]
	return math.max(10, math.floor(bdg/all))
end

function command.exe(msg, args, other, rmsg, user)
    local accounts_count = db.get_count("accounts")
    local notifications_count = db.get_count("accounts", "notifications=1")
    local online_count = online.get_count()
    local married_count = db.get_count("accounts", "married>0")
    local bankvalue = get_course()

    rmsg:lines(
        { "🌹 Ева Цифрова - многофункциональный бот." },
        { "⚙ Движок >> EBotPlatform V%s", _VERSION },
        { "⏱ Аптайм >> %s", get_parsed_time(uptime()) },
        { "👥 Пользователей >> %i чел.", accounts_count },
        { " ➤ Онлайн >> %i чел. (%.2f%%)", online_count, online_count/accounts_count*100 },
        { " ➤ С рассылкой >> %i чел. (%i%%)", notifications_count, math.floor(notifications_count/accounts_count*100) },
        { "💍 В браке >> %i чел.", married_count },
        { "💷 Цена 1 ярика >> %i руб.", math.floor((bankvalue/200000)*15) }
    )
end

return command
