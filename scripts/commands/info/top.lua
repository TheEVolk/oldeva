local command = botcmd.new("топ", "топ пользователей по балансу", {dev=1})

command.exe = function (msg, args, other, rmsg, user)
	--if msg.peer_id == 2000000002 then return "эта команда запрещена в этой беседе" end
	rmsg:line "💰 Топ богатых игроков:"

	for i,v in db.iselect("vkid,nickname,balance", "accounts", "1 ORDER BY `balance` DESC LIMIT 5") do
		rmsg:line("► %i. %s\n↳ %s бит", i, names.dbr(v), comma_value(v.balance))
	end

	rmsg:line("\n🔷 Вы №%i в топе.", db.get_count("accounts", "balance>=%i", user.balance))
end

return command
