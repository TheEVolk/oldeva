local module = {}
module.biterr = "недостаточно денег. Требуется %i."
module.user_errors = {}

function module.check_install()
    assert(db, "требуется модуль db.lua")
    db.check_column('moneys', db.acctable, 'balance', 'INT NOT NULL')
end

function module.start()
    function db.oop:getMoneys() return comma_value(toint(self.balance)) end
    function db.oop:setMoneys(count) self:set('balance', math.floor(count)) end
    function db.oop:addMoneys(count) self:add('balance', math.floor(count)) end

    function db.oop:checkMoneys(count, errmsg)
        ca(toint(self.balance) >= count, table.concat({
            "у вас недостаточно бит.",
            "Вам нужно ещё "..comma_value(count - toint(self.balance)).." бит.",
            "",
            "(Вы можете купить биты - <<Ева, донат 1>>)"
        }, "\n"), "донат 1")

        module.user_errors[self.vkid] = 1;
    end

    function db.oop:buy(count) self:checkMoneys(count); self:addMoneys(-count) end

    if botcmd then
        botcmd.add_argtype('m', "moneys", function(args, arg, offset, user)
            local count = ca(toint(arg), "это не число")
            ca(count > 0, "вы не можете воровать деньги")
            user:checkMoneys(count)
            return count
        end)
    end

    -- Счетчик баланса
    hooks.add_action("bot_pre", function(msg, other, user)
        other.last_balance = toint(user.balance)
    end)

    local function crv(value)
    	local result = ''
    	while value >= 1000 do
    		result = result .. 'к'
    		value = value / 1000
    	end

    	return string.format('%.0f%s', value, result)
    end

    hooks.add_action("bot_post", function(msg, other, user, rmsg)
    	if other.last_balance == toint(user.balance) then return end
    	local diff = toint(user.balance) - other.last_balance
    	addline(rmsg, string.format("💳 %s бит (%s%s).", user:getMoneys(), diff > 0 and '+' or '-', crv(math.abs(diff))))
    end, 0)
end

function module.cmd_check(msg, args, other, command, user)
	return command.price and toint(user.balance) < command.price
        and { message = command.perror or "У вас нет только денег" }
end

function module.cmd_success(msg, args, other, command, user)
    if command.price then user:addMoneys(-command.price) end
end

return module
