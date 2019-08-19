--[[
	Функции:
		db.find_table(table_name) -- возвращает её имя или nil, если таблица не найдена
		db.find_column(table_name, column_name) -- вернет колонку или nil, если колонка не найдена
		db.check_column (module_name, table_name, column_name, args) -- создает колонку, если она не найдена
		db.check_table (module_name, table_name, command) -- создает таблицу, если она не найдена
		db.connect(ip, username, password, database) -- подключиться к БД
		db.get_user_safe(vkid) -- ищет пользователя в БД или nil, если он не найден
		db.get_user_from_url(url) -- ищет пользователя по url или nil, если ссылка некорретна
		db.get_user(vkid) -- найдет или создаст пользователя в БД
]]
local module = {}
module.acctable = "accounts"
module.oop = {}

function module.check_install ()
	assert(module.connection, "MySql подключение не существует")

	module.check_table ('db', module.acctable, [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`vkid` int(11) NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);
end

function module.start()
	-- OOP
	function module.oop:set (field, value)
		self[field] = value
		module("UPDATE `%s` SET `%s`='%s' WHERE `vkid`=%i", module.acctable, field, value, self.vkid)
	end

	function module.oop:add (field, value)
		assert_types({ field, "string" }, { value, "number" })
		self[field] = self[field] + value
		module("UPDATE `%s` SET `%s`=`%s`+%i WHERE `vkid`=%i", module.acctable, field, field, value, self.vkid)
	end

	-- Modules tools
	botcmd.add_argtype('U', "user", function(args, arg, offset)
		if arg:find("%[(.-)|.-%]") then arg = arg:gsub("%[(.-)|.-%]", "%1") end
		return ca(module.get_user(getId(arg)), "пользователь не найден")
	end)
end

function module.find_table (table_name)
	local index = "Tables_in_"..db.settings.database
	local tables = module("SHOW TABLES")
	for i = 1,#tables do
		if tables[i][index] == table_name then
			return tables[i][index]
		end
	end
end

function module.find_column (table_name, column_name)
	local columns = module("SHOW COLUMNS FROM `%s`", table_name)
	for i = 1, #columns do
		if columns[i].Field == column_name then
			return columns[i]
		end
	end
end

function module.check_column (module_name, table_name, column_name, args)
	if module.find_column(table_name, column_name) then return true end
	console.log(module_name, "Создаю поле %s в %s...", column_name, table_name)
	module("ALTER TABLE `%s` ADD `%s` %s", table_name, column_name, args)
	console.log(module_name, "Поле %s в было успешно создано.", column_name)
end

function module.check_table (module_name, table_name, command)
	if module.find_table(table_name) then return true end
	console.log(module_name, "Таблица %s не найдена.", table_name)
	console.log(module_name, "Создание таблицы %s...", table_name)
	module("CREATE TABLE `%s` " .. command, table_name)
	console.log(module_name, "Таблица %s успешно создана!", table_name)
	relua()
end

function module.connect(ip, username, password, database)
	module.connection = mysql(ip, username, password, database)
	module("SET NAMES utf8mb4")
	module("SET @@GLOBAL.sql_mode= ''");
	module("SET @@SESSION.sql_mode= ''");
	module.settings = { ip = ip, username = username, password = password, database = database }
end

function module.get_user_safe(vkid)
	if not vkid then return end
	local user = module('SELECT * FROM `%s` WHERE vkid=%i', module.acctable, vkid)[1]
	if not user then return false end
	setmetatable(user, { __index = module.oop })
	return user
end

function module.get_user_from_url(url)
	if not url then return end
	if tonumber(url) then url = 'id'..url end
	if url:find("%[(.-)|.-%]") then url = url:gsub("%[(.-)|.-%]", "%1") end
	return url and module.get_user_safe(getId(url))
end

function module.get_user(vkid)
	if not vkid then return end
	local user = module.get_user_safe(vkid)
	if not user then
		module("INSERT INTO `%s` (`vkid`) VALUES (%i)", module.acctable, vkid)
		user = module.get_user_safe(vkid)
	end
	return user;
end

function module.call(errlvl, query, ...)
	local status, result = pcall(module.connection, query, ...)
	if not status then
		error(result, errlvl or 2)
	end

	return result
end

function module.select(what, table, where, ...)
	return module.call(3, "SELECT %s FROM `%s` " .. (where and "WHERE "..where or ''), what, table, ...)
end

function module.select_one(what, table, where, ...)
	return module.call(3, "SELECT %s FROM `%s` " .. (where and "WHERE "..where or ''), what, table, ...)[1]
end

function module.get_count(table, where, ...)
	local aname = table=="accounts" and "vkid" or "id"
	return tonumber(module.call(3, "SELECT COUNT("..aname..") FROM `%s` " .. (where and "WHERE "..where or ''), table, ...)[1]['COUNT('..aname..')']) or 0
end

function module.iselect(what, table, where, ...)
	local collection = module.select(what, table, where, ...)

	local index = 0
	local count = #collection

   	return function ()
      	index = index + 1
      	if index <= count then return index,collection[index] end
   end
end

setmetatable(module, { __call = function (_, query, ...) print(string.format(query, ...)); return module.call(3, query, ...) end })
return module