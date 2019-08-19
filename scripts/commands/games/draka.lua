local command = botcmd.mnew("драка", "Сразитесь силами", "<профиль>", "U")

function command.exe(msg, args, other, rmsg, user, target)
	ca (user.vkid ~= target.vkid, "вы избили сами себя")

	local qid = inv.create(user, target, command.accept)
	rmsg:line("🐃 %s 🆚 %s", user:r(), target:r());
	inv.lines(rmsg, qid, target)
end

command.accept = function (target, source, rmsg)
	--[[local players = { ClanSystem.Force(source), ClanSystem.Force(target) };

	players[1].defend = players[1].defend - players[2].power * math.random() * 10;
	players[2].defend = players[2].defend - players[1].power * math.random() * 10;

	local winner = players[1].defend > players[2].defend and players[1] or players[2];]]
	local winner = source.force > target.force + math.random(-10, 10) and source or target

	winner:addScore(math.random(20))
	rmsg:line("&#128003; %s &#127386; %s", source:r(), target:r());
	rmsg:line("&#10035; Победитель: " .. winner:r());
end
return command;
