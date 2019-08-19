local module = {}

function module.get_string(key)
    return db.select_one('value', 'keyvalue', "`key` = '%s'", key).value
end

function module.get_number(key)
    return tonumber(module.get_string(key))
end

function module.get_integer(key)
    return toint(module.get_string(key))
end

function module.set(key, value)
    return db("UPDATE `keyvalue` SET `value` = '%s' WHERE `key` = '%s'", value, key)
end

return module
