local module = { commands = { }, pre_list = { }, post_list = { }, cmd_count = 0 }
module.arg_types = {}

function module.start()
	module.add_argtype('i', "integer", function(args, arg, offset) return toint(arg) end)
	module.add_argtype('f', "float"  , function(args, arg, offset) return tonumber(arg) end)
	module.add_argtype('s', "string" , function(args, arg, offset) return arg end)
	module.add_argtype('d', "alldata", function(args, arg, offset) return cmd.data(args, offset + 1) end)

	module.load_commands()
	console.log('botcmd', "Загружено %i команд.", module.cmd_count)
end

--[[ ЗАГРУЗКА КОМАНД ]]
function module.load_commands(dir)
	dir = dir or ''
	local files = fs.dir_list("scripts/commands"..dir)
	for i,file in ipairs(files) do
		if file:ends '.lua' then
			module.load_command(root.."/scripts/commands/"..dir.."/"..file, dir:sub(2))
		else
			module.load_commands(dir.."/"..file)
		end
	end
end

function module.load_command(file, type)
	local command = dofile(file)
	assert(command, file.." is not loaded.")

	command.file = file
	command.type = type
	module.commands[command[1]] = command
	module.cmd_count = module.cmd_count + 1

	return command
end

function module.get(command_name)
	assert_argument(command_name, "string")
	return module.commands[command_name:lower()]
end

--[[ СОЗДАНИЕ КОМАНД ]]
function module.new(name, desc, params)
	assert_types({name, "string"}, {desc, "string"}, {params, "table", true})

	local command = params or { }
	command[1] = name
	command[2] = desc

	setmetatable(command, { __index = {
		addsub = function (self, name, func)
			if not self.sub then self.sub = {} end
			self.sub[name] = func
		end,

		addmsub = function (self, name, help, args, func)
			self:addsub(name, { help, args, func })
		end
	}})

	return command
end

function module.mnew(name, desc, use, args, params)
	assert_types({name, "string"}, {desc, "string"}, {use, "string"}, {args, "string"}, {params, "table", true})

	local command = params or { }
	command.args, command.use = args, use
	return module.new(name, desc, command)
end

--[[ ВЫПОЛНЕНИЕ ]]
function module.handler(msg, other, rmsg, user)
	if not msg.text or msg.text == '' then return end
	local args = cmd.parse(msg.text, ' ')

	local command = module.get(args[1])
	if not command then return end

	if not hooks.do_action("botcmd_check", msg, args, other, command, user) then return end
	if command.dev==1 and user.vkid == admin then command = module.load_command(command.file, command.type) end

	local exported
	local cmd_func = args[2] and command.sub and (command.sub[args[2]:lower()] or command.help) or command.exe

	if cmd_func == command.exe then
		exported = command.args and module.export_arguments(command, args, command.args, user)
	elseif type(cmd_func) == 'table' then
		exported = module.export_sub_arguments(command[1]..' '..args[2]:lower()..' '..cmd_func[1], args, cmd_func[2], user)
		cmd_func = cmd_func[3]
	end

 	local result = cmd_func(msg, args, other, rmsg, user, table.unpack(exported or {}))
	if not hooks.do_action("botcmd_post", msg, args, other, command, user) then return end
	return true, result
end

--[[ ПАРСИНГ АРГУМЕНТОВ ]]
function module.export_arguments(com, args, params, user, offset)
	offset = offset or 0
	ca(#params < #args, module.useerr(com))

	local resp = {}
	for i,c in params:ipairs() do
		local d = module.arg_types[c][2](args, args[1 + i + offset], offset + i, user)
		ca(d, module.useerr(com))
		table.insert(resp, d)
	end
	return resp
end

function module.export_sub_arguments(use, args, params, user)
	return module.export_arguments(use, args, params, user, 1)
end

function module.useerr(com)
	local use = type(com) == "string" and com or (com[1]..' '..(com.use or ''))
	return "используйте: "..use
end

function module.add_argtype(char, desc, f)
	assert_types({char, "string"}, {desc, "string"}, {f, "function"})

	if module.arg_types[char] then
		error("arg_types['"..char.."'] уже существует. ("..module.arg_types[char][1]..")")
	end

	module.arg_types[char] = { desc, f }
end

--[[ ВСПОМОГАТЕЛЬНЫЕ ]]
function module.cmd_error(str, ...)
	error('err:'..string.format(str, ...), 0)
end

function ca(object, error_message)
	if not object then module.cmd_error(error_message) end
	return object
end

function tca(t, error_message)
	return ca(t and #t ~= 0 and t, error_message)
end

return module
