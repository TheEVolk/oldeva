return {
    exe = function (msg, data, other, rmsg, user)
        other.sendname = false;
        rmsg:line "&#128527; Игровой бот - Ева Цифрова";
    	rmsg:line("&#127801; Сделано с любовью");
    	--rmsg:line("&#128024; У меня %i пользователей", #DbData.mc("SELECT id FROM accounts"));
    	--rmsg:line("&#128572; Я знаю %i фраз", #DbData.mc("SELECT id FROM baza"));

    	rmsg:line("🔧 Этот бот работает на [ebotp|EBotPlatform] V".._VERSION);
    	rmsg.attachment = "photo-131358170_456239058";
        other.sendname = false;
    end
};
--  ⃣


--[[
function genUl()
	local url = "https://www.random.org/integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new";
	local params = { name_case = 'gen' };
	local user;

	repeat
		params.user_id = tonumber(net.send(url));
		user = VK.users.get(params).response[1]
	until not user.deactivated

	local num = math.random(200);
	local symbol = trand {"а","б","в","г","д"};

	local path = string.format("ул. %s %i%s", user.last_name, num, symbol);

	if #DbData.mc("SELECT * FROM `homes` WHERE `path`='%s'", path) > 0 then return genUl() end

	return path;
end
]]
