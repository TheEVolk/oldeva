local command = botcmd.new("профиль", "информация о вашем профиле", {use="[профиль]", dev=1})

local profile_setting = function(msg, args, other, rmsg, user)
	if user.allow_profile == 1 then
		db("UPDATE `accounts` SET `allow_profile`=0 WHERE `vkid`=%i", tonumber(user.vkid))
		rmsg:line("✔️ Вы разрешили просмотр Вашего профиля.")
	elseif user.allow_profile == 0 then
			db("UPDATE `accounts` SET `allow_profile`=1 WHERE `vkid`=%i", tonumber(user.vkid))
			rmsg:line("❌ Вы запретили просмотр Вашего профиля.")
	end
end

local balance_setting = function(msg, args, other, rmsg, user)
	if user.allow_balance == 1 then
		db("UPDATE `accounts` SET `allow_balance`=0 WHERE `vkid`=%i", tonumber(user.vkid))
		rmsg:line("✔️ Вы разрешили перевод бит на Ваш аккаунт.")
	elseif user.allow_balance == 0 then
			db("UPDATE `accounts` SET `allow_balance`=1 WHERE `vkid`=%i", tonumber(user.vkid))
			rmsg:line("❌ Вы запретили перевод бит на Ваш аккаунт.")
	end
end

command:addsub("настройки", function (msg, args, other, rmsg, user)
if not user:isRight'profile_settings' then return viperr end
if args[3] == 'изменить' then return
	numcmd.lmenu_funcs(rmsg, user, {{
		{ 1, "Профиль", profile_setting, "default" },
		{ 2, "Перевод бит", balance_setting, "default" }
	}})
end
rmsg:lines(
{ "⚙️ Настройки профиля <<%s>>", user.nickname },
user.allow_profile==0 and { "👁️‍🗨️ Просмотр профиля >> ✔️" },
user.allow_profile==1 and { "👁️‍🗨️ Просмотр профиля >> ❌" },
user.allow_balance==0 and { "💳 Перевод бит >> ✔️" },
user.allow_balance==1 and { "💳 Перевод бит >> ❌" }
)
rmsg:tip("профиль настройки изменить")
end)

function command.exe(msg, args, other, rmsg, user)
	local target = args[2] and db.get_user_from_url(args[2]) or user

	local level = levels.levels[target.level]
	ca(target.vkid==user.vkid or target.allow_profile==0, "пользователь запретил просмотр своего профиля")
	rmsg:lines (
		{ "%s Профиль <<%s>>", target.smile, target:getName() },
		(target.role~='' and target.vkid~=523585763) and { "🔑 Роль: %s;", target:getRoleName() },
		(target.vkid==523585763) and { "🔑 Роль: Самая уёбищная роль;" },
		target.married~=0 and { "💍 В браке с %s;", db.get_user(target.married):r() },
		{ "💳 Баланс: %s бит;", target:getMoneys() },
		{ "💼 Работа: %s", target:getJobName() },
		{ "💪🏻 Сила: %s ед.", comma_value(target.force) },
		{ "💎 %s;", level.name },
		{ "✨ Опыт: %i/%i;", target.score, level.maxscore },
		target:checkBan() and { "\n⏰ До разбана %s", moment.get_time(target.ban == -1 and 1e999 or (target.ban - os.time())) }
	)
	if (user.vkid==target.vkid and target:isRight'profile_settings') then rmsg:tip("профиль настройки") end
end

return command