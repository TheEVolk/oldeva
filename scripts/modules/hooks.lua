local module = {}
module.actions = {}

function module.add_action(tag, function_to_add, priority)
    priority = priority or 500

    assert_argument(tag, "string", 1)
    assert_argument(function_to_add, "function", 2)
    assert_argument(priority, "number", 3)

    if not module.actions[tag] then module.actions[tag] = {} end
    table.insert(module.actions[tag], { priority, function_to_add })

    table.sort(module.actions[tag], function(a, b) return a[1] > b[1] end)
end

function module.do_action(tag, ...)
    assert_argument(tag, "string")

    if not module.actions[tag] then return true end
    for k,v in ipairs(module.actions[tag]) do
        if v[2](...) == false then return false end
    end

    return true
end

return module
