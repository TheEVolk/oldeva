local command = botcmd.new("левелтоп", "топ пользователей по уровню и опыту", {dev=1})

function command.exe (msg, args, other, rmsg)
	rmsg:line "📊 Топ пользователей по уровню и опыту:"
	for i,v in db.iselect("vkid,nickname,level,score", "accounts", "1 ORDER BY `level` DESC, `score` DESC LIMIT 10") do
		local level = levels.levels[v.level]
		rmsg:line("➤ %i. %s - %s (%i/%i)", i, names.dbr(v), level.name, v.score, level.maxscore)
	end
end

return command
