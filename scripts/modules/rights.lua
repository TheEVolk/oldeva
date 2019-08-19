local module = {}

function module.check_install ()
    check_module 'db'
    db.check_column('role', db.acctable, 'role', 'TEXT NOT NULL')
end

function module.start ()
    function db.oop:isRight (right) return module.is_right(self.role, right) end
    function db.oop:getValue (value) return module.get_value(self.role, value) end
    function db.oop:getRole () return module.get_type(self.role) end
    function db.oop:getRoleName () return self:getRole().screenname end

    module.roles = dofile(root .. '/settings/roles.lua')

    hooks.add_action("botcmd_check", function(msg, args, other, command, user)
        if not command.right or user:isRight(command.right) then return end

        local viperror = module.is_right('vip', command.right) and "похоже у тебя нет прав.\n💶 Исправь это прямо сейчас!\nvk.com/@evarobotgroup-vip"
        ca(false, command.rerror or viperror or 'у вас нет доступа к данной команде. ⛔')
    end)
end

function module.get_type (typename)
    return module.roles[typename == '' and 'default' or typename]
end

function module.is_right (typename, right)
    local type = module.get_type(typename)
    return type['full'] or type['right.'..right] or (type['include'] and module.is_right(type["include"], right))
end

function module.get_value (typename, val)
    local type = module.get_type(typename)
    return type['value.'..val] or (type['include'] and module.get_value(type["include"], val))
end

return module
