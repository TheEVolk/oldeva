local command = botcmd.new("dstat", "donatstats", {dev=1, right='dstats'})

command:addmsub("inf", "<user>", "U", function(msg, args, other, rmsg, user, target)
	rmsg:lines(
		{ 'Total: %s r', comma_value(db.select_one('SUM(price)', 'donats', 'vkid=%i', target.vkid)['SUM(price)'] or 0) },
		{ 'Count: %i', db.get_count('donats', 'vkid=%i', target.vkid) }
	)
end)

command:addsub("top", function(msg, args, other, rmsg, user)
	rmsg:line "Donat top:"

	for i,v in db.iselect("vkid,nickname,balance", "accounts", "score > 10 ORDER BY (SELECT SUM(price) FROM donats WHERE vkid=accounts.vkid) DESC LIMIT 5") do
		rmsg:line("► %i. %s\n↳ %s rub", i, names.dbr(v), comma_value(db.select_one('SUM(price)', 'donats', 'vkid=%i', v.vkid)['SUM(price)']))
	end
end)

command.exe = function (msg, args, other, rmsg, user)
	rmsg:lines(
		{ 'Total: %s rub', comma_value(db.select_one('SUM(price)', 'donats')['SUM(price)'] or 0) },
		{ 'Count: %i', db.get_count('donats') },
		"",
		{ 'Day: %s rub', comma_value(db.select_one('SUM(price)', 'donats', '%i - buy_time < 86400', os.time())['SUM(price)'] or 0) },
		{ 'Week: %s rub', comma_value(db.select_one('SUM(price)', 'donats', '%i - buy_time < 86400 * 7', os.time())['SUM(price)'] or 0) },
		{ 'Month: %s rub', comma_value(db.select_one('SUM(price)', 'donats', '%i - buy_time < 86400 * 30', os.time())['SUM(price)'] or 0) }
	)
end

return command
