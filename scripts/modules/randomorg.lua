local module = {}

function module.get_int(min, max)
    local base = 'https://www.random.org/integers/'
    local params = string.format("?num=1&min=%i&max=%i&col=1&base=10&format=plain&rnd=new", min, max)
    return tonumber(net.send(base..params))
end

return module
