--[[
    Наипростейшая команда, которая всегда выводит одно и то же.
    botcmd.new("команда", "описание", "смайл"[, { ... }])
]]
local command = botcmd.new("relua", "перезагрузить lua скрипты", {right="relua"})

function command.exe (msg, args, other, rmsg, user)
	relua()
    return "🔄 Бот был успешно перезагружен."
end

return command
