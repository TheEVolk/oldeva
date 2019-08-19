local module = {}
module.handlers = {}
module.executes = {} -- Тут обходим функции, пока не получим RMSG.

function module.process_message(msg)
    local user = db.get_user(msg.from_id)
    local other = { clock = os.clock() }

    console.log(ischat(msg) and (msg.peer_id - 2000000000)..'|'..msg.from_id or msg.from_id, msg.text or '-')

    if not hooks.do_action("bot_pre", msg, other, user) then return end
    -- Современный поиск
    local rmsg = rmsgclass.get()

	local success, result, data = pcall(function(msg, other, rmsg, user)
        for i,handler in ipairs(module.handlers) do
            local result, data = handler(msg, other, rmsg, user)
            if result == true then return true, data end
            if result == false then return false end
        end
	end, msg, other, rmsg, user)

    if result == false then return end

    -- Отлов "err:" ошибок
    if not success then data = result end
    if data and type(data) == "string" and data:starts 'err:' then
        rmsg.message = string.sub(data, 5)
        if rmsg.message:find("`") then
            rmsg.message = rmsg.message:split("`")[1]
        end
    	other.sendname = true
    else
        if not success then error(data, 0) end
        rmsg = data and rmsgclass.get(type(data) == "table" and data or { message = data }) or rmsg
        hooks.do_action("bot_success", msg, other, rmsg, user)
    end

    if not hooks.do_action("bot_post", msg, other, user, rmsg) then return end

    -- Шлем сообщение
    rmsg.peer_id = msg.peer_id
    rmsg.random_id = math.random(9 ^ 9 * 10000000000)
    rmsg.disable_mentions = rmsg.disable_mentions or 1
    rmsg.v = "5.90"
    local result = VK.messages.send(rmsg)
    local time = math.floor(1000*(os.clock()-other.clock))
    --[[console.log(
        string.format("I: %s; T: %i ms.",result.response or 'E' .. result.error.error_code, time),
        rmsg.message and (rmsg.message:find '\n' and rmsg.message:split('\n')[1]..'...' or rmsg.message) or '-'
    )]]

    if not hooks.do_action("bot_post_send", msg, other, user) then return end
end

vk_events['message_new'] = function (msg)
    if msg.from_id < 0 then return end -- На группы не отвечаем, мы не умеем с ними работать.

    if not hooks.do_action("bot_check", msg) then return end

    status, result = pcall(module.process_message, msg)
	if not status then
        console.error("BOT", result)
        local text = string.format(
            "⚠ %s вызвал ошибку. (%s)\n🖊 %s\n\n%s",
            db.get_user(msg.from_id):r(),
            msg.peer_id,
            msg.text or "-",
            result
        )

        VK.messages.send { peer_id = admin, message = text }
        resp(msg, "⚠ Произошла ошибка. Разработчик уже знает об этом!")
    end
end

return module
