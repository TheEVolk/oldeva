local module = { queries = {} }

function module.check_install()
	assert(db, "требуется модуль db.lua")
	assert(botcmd, "требуется модуль botcmd.lua")
end

function module.start()
	botcmd.cmd_count = botcmd.cmd_count + 1
	botcmd.commands["принять"] = {
		"принять",
		"Принять запрос",
		use = "<номер>",
		smile = '&#9989;',
		args = 'i',
		exe = module.accept,
		type = 'other'
	}
end

function module.create(user, target, callback, data, timer)
	-- Clear old user invites
	for k,v in pairs(module.queries) do
		if v.source_id == user.vkid then module.queries[k] = nil end
	end

	local qid = math.random(8999) + 1000

	module.queries[qid] = {
		data = data,
		endtime = (timer or 300) + os.time(),
		target_id = target.vkid,
		source_id = user.vkid,
		callback = callback
	}

	return qid
end

function module.accept(msg, args, other, rmsg, user, qid)
	local query = ca(module.queries[qid], "запрос не найден")
	ca(query.target_id == user.vkid, "это не ваш запрос")
	module.queries[qid] = nil
	ca(query.endtime > os.time(), "время запроса истекло")

	return query.callback(user, db.get_user(query.source_id), rmsg, query.data)
end

function module.lines(rmsg, qid, target)
	rmsg:line("⚫ %s должен принять запрос командой:", target:r());
	rmsg:line("➡ принять %i", qid);
end

return module
