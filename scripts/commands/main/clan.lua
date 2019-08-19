local command = botcmd.new("клан", "система кланов", {dev=1})

command:addmsub("выгнать", "<профиль>", "U", function(msg, args, other, rmsg, user, target)
--[[local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE owner=%i', user.vkid)[1], "вы не владелец клана");
ca (target.vkid ~= user.vkid, "вы не можете выгнать себя.");
DbData.mc('UPDATE `%s` SET `clan`=0 WHERE `vkid`=%i', DbData.acctable, target.vkid);
target:ls ("&#127939; Вас выгнали из клана.");
rmsg:line ("&#11093; Вы выгнали %s из клана.", target:r());]]
    local clan = ca(db.select_one("id", "clans", "id=%i", user.clan), "вы не состоите в клане")
    ca(target.vkid~=user.vkid, "самого себя выгнать нельзя")
    ca(user.vkid==clan.owner, "вы не являетесь владельцем клана")
    ca(target.clan==user.clan, "пользователь не состоит в вашем клане")
end)

command:addmsub("создать", "<имя клана>", "d", function(msg, args, other, rmsg, user, clanname)
    ca(user.clan == 0, "вы уже состоите в клане\nПокинуть клан >> клан покинуть")
    ca(utf8.len(clanname) < 20, "имя клана должно быть меньше 20 символов")
    user:buy(100000)

    db("INSERT INTO clans (`owner`, `name`) VALUES (%i, '%s')", user.vkid, clanname)
    user:set('clan', db.select_one("id", "clans", "owner=%i", user.vkid).id)

    rmsg:lines(
        "📋 Вы успешно создали свой клан!",
        "❕ Чтобы клан отображался в топе и мог участвовать в боях, вам нужно набрать 5 участников."
    )
end)

command:addmsub("вступить", "<ид клана>", "i", function(msg, args, other, rmsg, user, clan)
    ca(user.clan == 0, "вы уже состоите в клане\nПокинуть клан >> клан покинуть")
    if type(clan) == "number" then clan = ca(db.select_one("*", "clans", "id=%i", clan), "клан с таким ид не найден") end
    local target = db.get_user(clan.owner)

    local accepttoclan = function(target, source, rmsg)
        local clan = ca(db.select_one("*", "clans", "owner=%i", target.vkid), "у вас нет клана")

        ca(10 + clan.slots > db.get_count("accounts", "clan=%i", clan.id), "в вашем клане нет мест")

        source:set("clan", clan.id)

        source:ls("✅ Вас приняли в клан <<%s>>.", clan.name)
        rmsg:line("✅ Вы успешно приняли %s в клан.", source:r())
    end

    local qid = inv.create(user, target, accepttoclan)
	rmsg:line("✳ Вы успешно подали заявку в клан <<%s>>", clan.name)
	inv.lines(rmsg, qid, target)
end)

command:addmsub("дашка", "<кол-во>", "i", function(msg, args, other, rmsg, user, count)
    local clan = ca(db.select_one("id,balance", "clans", "id=%i", user.clan), "вы не состоите в клане")
    ca(count > 0, "вы не воровать у клана")
    user:buy(count * 1000)

    db("UPDATE `clans` SET `balance`=`balance` + %i WHERE id=%i", count, clan.id)

    rmsg:lines(
        { "💳 Вы успешно купили дашки" },
        { "💠 Баланс >> %i дашек.", clan.balance + count }
    )
end)

command:addsub("покинуть", function(msg, args, other, rmsg, user)
    local clan = ca(db.select_one("id,balance", "clans", "id=%i", user.clan), "вы не состоите в клане")
    ca(clan.owner ~= user.vkid, "вы не можете покинуть свой же клан")

    user:set("clan", 0)
    return "⭕ Вы только что покинули свой клан"
end)

command:addmsub("инфо", "<ид клана>", "i", function(msg, args, other, rmsg, user, clan)
    if type(clan) == "number" then clan = ca(db.select_one("*", "clans", "id=%i", clan), "клан с таким ид не найден") end

    local war_count = db.get_count("clanwars", "winner=%i OR looser=%i", clan.id, clan.id)
    local win_count = db.get_count("clanwars", "winner=%i", clan.id)

    rmsg:lines(
        { "🏷 Клан <<%s>> №%i", clan.name, clan.id },
        { "👤 Владелец: %s", db.get_user(clan.owner):r() },
        { "💠 Баланс: %i дашек.", clan.balance },
        { "👥 Участников: %i/%i чел.", db.get_count("accounts", "clan=%i", clan.id), 10 + clan.slots },
        war_count >= 5 and { "💎 Рейтинг: %i%% (%i/%i)", math.floor(win_count/war_count*100), win_count, war_count } or "💎 Наберите 5 боёв для определения рейтинга."
    )
end)

command:addmsub("участники", "<ид клана>", "i", function(msg, args, other, rmsg, user, clan)
    if type(clan) == "number" then clan = ca(db.select_one("*", "clans", "id=%i", clan), "клан с таким ид не найден") end

    rmsg:line("🏷 Участники клана <<%s>> #%i", clan.name, clan.id)
    local members = db.select("vkid,nickname", "accounts", "clan=%i", clan.id)
    for k,v in ipairs(members) do rmsg:line("➤ %i. %s", k, names.dbr(v)) end
end)

command:addmsub("бой", "<ид клана>", "i", function(msg, args, other, rmsg, user, e_clan)
    if type(e_clan) == "number" then e_clan = ca(db.select_one("*", "clans", "id=%i", e_clan), "клан с таким ид не найден") end
    local m_clan = ca(db.select_one("*", "clans", "id=%i", user.clan), "вы не состоите в клане")

    ca(m_clan ~= e_clan, "вы решили напасть сами на себя?")
    ca(m_clan.balance >= 10, "в вашем клане должно быть минимум 10 дашек")

    ca(db.get_count("accounts", "clan=%i", m_clan.id) >= 5, "в вашем клане нет 5 участников")
    ca(db.get_count("accounts", "clan=%i", e_clan.id) >= 5, "в противном клане нет 5 участников")

    db("UPDATE `clans` SET `balance`=`balance` - 10 WHERE id=%i", m_clan.id)

    local m_members = db.select("vkid,nickname,`force`", "accounts", "clan=%i ORDER BY rand() LIMIT 3", m_clan.id)
    local e_members = db.select("vkid,nickname,`force`", "accounts", "clan=%i ORDER BY rand() LIMIT 3", e_clan.id)

    local function check_died(m)
        for k,v in ipairs(m) do if not v.died then return false end end
        return true
    end

    local function get_lived(m)
        for k,v in ipairs(m) do if not v.died then return v end end
    end

    local winner
    while not winner do
        local first  = get_lived(m_members)
        local second = get_lived(e_members)

        if first.force > second.force + math.random(-5, 5) then
            second.died = true
        else
            first.died = true
        end

        if check_died(m_members) then winner = 2 end
        if check_died(e_members) then winner = 1 end
    end

    -- Лень обновлять
    rmsg:line("⚔️ %s VS %s", m_clan.name, e_clan.name);
    rmsg:line("&#127942; Победитель >> %s", ({ m_clan, e_clan })[winner].name);
    rmsg:line("&#11035; Состав %s:", m_clan.name);
    for k,v in ipairs(m_members) do rmsg:line("➤ %i. %s %s", k, names.dbr(v), v.died and "†" or "") end
    rmsg:line("&#11035; Состав %s:", e_clan.name);
    for k,v in ipairs(e_members) do rmsg:line("➤ %i. %s %s", k, names.dbr(v), v.died and "†" or "") end

    db("INSERT INTO `clanwars` VALUES(NULL, %i, %i)", ({ m_clan, e_clan })[winner].id, ({ e_clan, m_clan })[winner].id)
end)

command:addsub("топ", function(msg, args, other, rmsg, user)
    rmsg:line "&#10549; Топ кланов Евы:";
    local top = db([[
        SELECT * FROM `clans`
        WHERE (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5
        AND (SELECT COUNT(`id`) FROM `clanwars` WHERE `winner`=`clans`.`id` OR `looser`=`clans`.`id`) > 0
        ORDER BY ((SELECT COUNT(`id`) FROM `clanwars` WHERE `winner`=`clans`.`id`)/(SELECT COUNT(`id`) FROM `clanwars` WHERE `winner`=`clans`.`id` OR `looser`=`clans`.`id`)) DESC
        ]]);

    for i = 1,math.min(#top, 5) do
        local clan = top[i];
        local war_count = db.get_count("clanwars", "winner=%i OR looser=%i", clan.id, clan.id)
        local win_count = db.get_count("clanwars", "winner=%i", clan.id)
        rmsg:line("➤ %i. %s №%i - %i%% (%i/%i);", i, clan.name, clan.id, math.floor(win_count/war_count*100), win_count, war_count);
    end

    --[[local m_clan = DbData.mc('SELECT * FROM `clans` WHERE id=%i AND (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5 AND `wars` > 0', user.clan)[1];
    if m_clan then
        local toppos = DbData.mc("SELECT COUNT(`id`) FROM `clans` WHERE (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5 AND `wars` > 0 AND (`wins`/`wars`) >= " .. (m_clan.wins/m_clan.wars))[1]['COUNT(`id`)'];
        rmsg:line("&#10145; Ваш клан %s имеет место №%i в топе.", m_clan.name, toppos + 1);
    end]]
end)

function command.exe(msg, args, other, rmsg, user)
    return command.sub['инфо'][3](msg, args, other, rmsg, user, ca(
        db.select_one("*", "clans", "id=%i", user.clan),
        "вы не состоите в клане.\nВступить в клан >> клан вступить <ид клана>\nИли создать свой >> клан создать <имя клана>"
    ))
end

return command
--[[
command.sub = {
    ['команды'] = function (msg, args, other, rmsg, user)
		rmsg:line "&#127915; Команды кланов:";
		rmsg:line "&#128313; Создать <название> - создать клан (VIP);";
		rmsg:line "&#128313; Инфо <ИД Клана> - информация;";
		rmsg:line "&#128313; Вступить <ИД Клана> - вступить в клан;";
		rmsg:line "&#128313; Бой <ИД Клана> - устроить бой с кланом;";
		rmsg:line "&#128313; Нн <новое имя> - изменить имя клана;";
		rmsg:line "&#128313; Покинуть - покинуть клан;";
		rmsg:line "&#128313; Выгнать <профиль> - выгнать пользователя из клана;";
		rmsg:line "&#128313; Дашка <кол-во> - купить дашки в клан;";
		rmsg:line "&#128313; Топ - топ кланов по рейтингу;";
		rmsg:line "&#128313; Участники - список участников клана;";
	end,

    ['нн'] = { '<новое имя>', 'd', function (msg, args, other, rmsg, user, newname)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE owner=%i', user.vkid)[1], "вы не владелец клана");
        DbData.mc("UPDATE `clans` SET `name`='%s' WHERE id=%i", newname, clan.id);
        rmsg:line ("&#10004; Ваш клан теперь называется %s!", newname);
    end },

    ['распустить'] = function (msg, args, other, rmsg, user)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE owner=%i', user.vkid)[1], "вы не владелец клана");
        DbData.mc('UPDATE `%s` SET `clan`=0 WHERE `clan`=%i', DbData.acctable, clan.id);
        DbData.mc('DELETE FROM `clans` WHERE `id`=%i', clan.id);
        rmsg:line ("&#11093; Вы распустили свой клан.");
    end,

    ['покинуть'] = function (msg, args, other, rmsg, user)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE id=%i', user.clan)[1], "вы не состоите в клане");
        ca (clan.owner ~= user.vkid, "вы не можете покинуть свой клан");
        DbData.mc('UPDATE `%s` SET `clan`=0 WHERE `vkid`=%i', DbData.acctable, user.vkid);
        DbData(clan.owner):ls ("&#127939; %s покинул клан.", user:r());
        rmsg:line ("&#11093; Вы покинули клан.");
    end,

	['выгнать'] = { '<профиль>', 'U', function (msg, args, other, rmsg, user, target)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE owner=%i', user.vkid)[1], "вы не владелец клана");
        ca (target.vkid ~= user.vkid, "вы не можете выгнать себя.");
        DbData.mc('UPDATE `%s` SET `clan`=0 WHERE `vkid`=%i', DbData.acctable, target.vkid);
        target:ls ("&#127939; Вас выгнали из клана.");
        rmsg:line ("&#11093; Вы выгнали %s из клана.", target:r());
    end },

	['дашка'] = { '<кол-во>', 'i', function (msg, args, other, rmsg, user, count)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE id=%i', user.clan)[1], "вы не состоите в клане");
        ca (count > 0, "вы не воровать у клана");
		user:buy(count * 1000, "дашки для клана");
		DbData.mc("UPDATE `clans` SET `balance`=`balance` + %i WHERE id=%i", count, clan.id);
        rmsg:line ("&#128179; Вы успешно купили дашки");
        rmsg:line ("&#128192; Количество >> %i", count);
		rmsg:line ("&#128205; Баланс >> %i д.", clan.balance + count);
    end },

	['топ'] = function (msg, args, other, rmsg, user)
        rmsg:line "&#10549; Топ 5 кланов Евы:";
		local top = DbData.mc("SELECT * FROM `clans` WHERE (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5 AND `wars` > 0 ORDER BY (`wins`/`wars`) DESC");
		for i = 1,5 do
			local clan = top[i];
			rmsg:line("%s&#8419; %s №%i - %i%%", i, clan.name, clan.id, math.floor(clan.wins/clan.wars * 100));
		end

		local m_clan = DbData.mc('SELECT * FROM `clans` WHERE id=%i AND (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5 AND `wars` > 0', user.clan)[1];
		if m_clan then
			local toppos = DbData.mc("SELECT COUNT(`id`) FROM `clans` WHERE (SELECT COUNT(`id`) FROM `accounts` WHERE `clan` = `clans`.`id`) >= 5 AND `wars` > 0 AND (`wins`/`wars`) >= " .. (m_clan.wins/m_clan.wars))[1]['COUNT(`id`)'];
			rmsg:line("&#10145; Ваш клан %s имеет место №%i в топе.", m_clan.name, toppos + 1);
		end
    end,

	['участники'] = function (msg, args, other, rmsg, user)
        local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE id=%i', user.clan)[1], "вы не состоите в клане");
		rmsg:line ("&#127915; %s №%i", clan.name, clan.id);

		local members = DbData.mc("SELECT * FROM `accounts` WHERE `clan` = %i", clan.id);
        rmsg:line ("&#128221; Участников >> %i чел.", #members);
		for i = 1, #members do
			rmsg:line("%s %s", members[i].smile, DbData(members[i].vkid):r());
		end
    end
};

function command.accept (_, target, source, rmsg)
	local clan = ca(DbData.mc('SELECT * FROM `clans` WHERE owner=%i', target.vkid)[1], "у вас нет клана");

	local nMembers = #DbData.mc('SELECT * FROM `accounts` WHERE `clan`=%i', clan.id);
	local maxMembers = 10 + clan.slots;
    ca (maxMembers > nMembers, "в вашем клане нет мест.");

	source:set('clan', clan.id);
	source:ls "Вас приняли в клан!";

	rmsg:line("&#10035; Вы успешно приняли %s в клан!", source:r());
end

function command.exe(msg, args, other, rmsg, user)
    ca(false, "скоро...")
    return command.sub['инфо'][3](msg, args, other, rmsg, user, ca (
        DbData.mc("SELECT * FROM `clans` WHERE `id` = %i", user.clan)[1],
        "вы не состоите в клане.<br>&#10145; Клан вступить <ИД Клана><br>&#11088; Клан создать <Имя клана>",
        "клан вступить 1"
    ));
end

return command;
]]
