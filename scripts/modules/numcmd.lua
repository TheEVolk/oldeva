local module = { }
module.linsters = {}

function module.handler(msg, other, rmsg, user)
	if not msg.payload then
		if not msg.text then return end
		if not toint(msg.text) then return end
	else
		if tonumber(msg.payload) then
			msg.text = msg.payload
		else
			if json.decode(msg.payload).k == nil then return end
			msg.text = tostring(json.decode(msg.payload).k)
		end
	end

	local user_linst = module.linsters[user.vkid]
    if not user_linst then return end
	return true, user_linst(msg, toint(msg.text), other, rmsg, user)
end

function module.linst(user, func)
	module.linsters[user.vkid] = func
end

function module.linst_list (user, func, objects)
	module.linsters[user.vkid] = function(msg, num, other, rmsg, user)
		if not objects[num] then return false end
		return func(msg, objects[num], other, rmsg, user)
	end
end

function module.linst_listsub(user, command, subcmd, objects, sendobj, ignoretable)
	module.linsters[user.vkid] = function(msg, num, other, rmsg, user)
		if not objects[num] and not ignoretable then return false end
		local sendedobj = sendobj and objects[num] or num
		if type(sendobj) == "string" then sendedobj = botcmd.arg_types[sendobj][2]({num}, num, 1, user) end
		return command.sub[subcmd][3](msg, {num}, other, rmsg, user, sendedobj)
	end
end

function module.linst_funcs(user, funcs, otherdata)
	module.linsters[user.vkid] = function(msg, num, other, rmsg, user)
		if not funcs[num] then return false end
		if type(funcs[num]) == "string" then
			msg.text = funcs[num]
			local _, res = botcmd.handler(msg, other, rmsg, user)
			return res
		end
		return funcs[num](msg, {num}, other, rmsg, user, otherdata)
	end
end

function module.menu_funcs(rmsg, user, data, otherdata)
	local buttons = {}
	local funcs = {}

	for i,r in ipairs(data) do
		if r then
			local row = {}
			for j,b in ipairs(r) do
				funcs[b[1]] = b[3]
				table.insert(row, {
					action = { type = "text", label = b[2], payload = json.encode({k=b[1]}) },
					color = b[4] or "default"
				})
			end
			table.insert(buttons, row)
		end
	end

	rmsg.keyboard = json.encode({one_time = true, buttons = buttons})
	module.linst_funcs(user, funcs, otherdata)
end

function module.lmenu_funcs(rmsg, user, data, otherdata)
	rmsg:line("")
	module.menu_funcs(rmsg, user, data, otherdata)
	for i,r in ipairs(data) do
		for j,b in ipairs(r) do
			if b[1] == 0 and #data ~= 1 then rmsg:line("") end
			rmsg:line("%i. %s", b[1], b.text or b[2])
		end
	end
end

function module.one(rmsg, user, text, func, color)
	numcmd.menu_funcs(rmsg, user, {{{ 1, text, func, color or "positive" }}})
end

function module.onef(rmsg, user, text, command, color)
	module.one(rmsg, user, text, botcmd.commands[command].exe, color)
end

function module.onetext(rmsg, user, text, cmdtext, color)
	module.linst(user, function(msg, num, other, rmsg, user)
		if num ~= 1 then return false end
		msg.text = cmdtext
		return false
	end)

	rmsg.keyboard = json.encode({one_time = true, buttons = {
		{{
			action = { type = "text", label = text, payload = json.encode({k=1}) },
			color = color or "positive"
		}}
	}})
end

return module
