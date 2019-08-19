function AchivCallback(uid)
	MoneySystem.Add(uid, 300);
	LevelSystem.AddScore(uid, 100);
	local referer = ReferalSystem.GetReferer(uid);
	if referer then
		MoneySystem.Add(referer, 20);
		LevelSystem.AddScore(referer, 5);
	end
end

Levels.callback = function (level, user)
	user:addMoneys(price, "Новый уровень");
	--[[local referer = ReferalSystem.GetReferer(uid);
	if referer then
		MoneySystem.Add(referer, level*500);
		LevelSystem.AddScore(referer, level*100);
	end]]
end

ReferalSystem.callback = function (user)
	local referer = user.referer;
	if referer == '-' then return end
	VK.messages.send { peer_id = referer, message = user:r().." теперь ваш новый реферал." };
	local target = DbData(referer);
	target:addMoneys(500, "За приглашение реферала.");
	target:addScore(100);
end
