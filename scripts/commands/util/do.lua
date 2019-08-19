--[[
    Песочница луа.
    botcmd.mnew("команда", "описание", "инструкция", "аргументы", "смайл"[, { ... }])
]]
local command = botcmd.mnew("do", "выполнить луа код", "<код>", "d", {right="do", dev=1})

function command.exe(msg, args, other, rmsg, user, code)
	local status, err = pcall(function(msg, args, other, rmsg, user, code)
		if code:find'token' then return "code wasn't executed out of the own safety" end
		if not (code:find'=' or code:find'return' or code:find'\n') then code = 'return ' .. code end
        local func, err = load("return function(msg, args, other, rmsg, user) " .. code .. " end")
        if not func and err then error(err, 0) end -- произошла ошибка
		return func()(msg, args, other, rmsg, user)
	end, msg, args, other, rmsg, user, code)
	if not status and err then return "⛔️ " .. err end -- произошла ошибка

	rmsg:line("🔧 %s", type(err) == "table" and json.encode(err) or tostring(err))
end

return command
