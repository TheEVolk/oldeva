local module = { class = {} }

function module.get(t)
    local rmsg = t or {}
    setmetatable(rmsg, { __index = module.class })
    return rmsg
end

-- Class --
function module.class:line(...)
    addline(self, #({...})==1 and ... or string.format(...))
end

function module.class:lines(...)
    local lines = { ... }
    for i = 1,#lines do
    local line = lines[i]
        if line then
            if type(line) == 'string' then self:line(line) else
                if type(line[1]) == 'table' then
                    self:ltable(table.unpack(line))
                else
                    self:line(table.unpack(line))
                end
            end
        end
    end
end

function module.class:ltable(t, str, count)
    --for s in line:gmatch(':[^ ]+:') do line = line:gsub(s, t[i][s:sub(2, #s - 1)]) end
    for s in str:gmatch(':.-:') do
        if s:find("%.") or s == ":i:" then
            str = str:gsub(s:gsub("(%W)","%%%1"), "\".."..s:sub(2, #s-1).."..\"")
        else
            str = str:gsub(s, "\"..v."..s:sub(2, #s-1).."..\"")
        end
    end

    local str_function = load("return function(i, v) return \""..str.."\" end")()
    for i = 1,math.min(count or #t) do
        self:line(str_function(i, t[i]))
    end
end

function module.class:functable(t, str, func, count)
    for i = 1,(count or #t) do
        self:line(str, func(i, t[i]))
    end
end

function module.class:lfunctable(t, str, func, title)
    self:line(title.." (%i шт.):", #t)
    self:functable(t, "► "..str, func)
    self:line("\n💡 Используй числа для выбора варианта меню.")
end

function module.class:lnfunctable(t, str, func, title, user, command, subcmd, sendobj, ignoretable)
    self:lfunctable(t, str, func, title)
    numcmd.linst_listsub(user, command, subcmd, t, sendobj, ignoretable)
end

function module.class:lfunctable(t, str, func, title)
    self:line(title.." (%i шт.):", #t)
    self:functable(t, "► "..str, func)
    self:line("\n💡 Используй числа для выбора варианта меню.")
end

function module.class:draw_list(title, t, str, user, command, subcmd, sendobj, ignoretable)
    assert_types(
        {title,"string"},
        {t,"table"},
        {str,"string"},
        {user,"table"},
        {command,"table"},
        {subcmd,"string"}
    )

    self:line(title.." (%i шт.):", #t)
    self:ltable(t, "➤ "..str)
    self:line(tip_nc)
    numcmd.linst_listsub(user, command, subcmd, t, sendobj, ignoretable)
end

function module.class:tip (...)
    if not string.format(...):find("[<>]") and self.keyboard == nil then oneb(self, ...) end
    self:line ('➡ ' .. string.format(...))
end

function module.class:stip (str, p)
    self:line (str .. " ➛ " .. p)
end

return module
