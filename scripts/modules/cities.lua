local module = { }

function module.start()
    botcmd.add_argtype('C', "city", function(args, arg, offset, user)
        return ca(toint(arg) and module.cities[toint(arg)] or module.get_city_by_name(arg), "город не найден")
    end)

    module.cities, module.streets, module.structure_names, module.structures = dofile(root .. '/settings/cities.lua')
end

function module.get_city_by_name(city_name)
    assert_argument(city_name, "string")

    for i,city in ipairs(module.cities) do
        if city.name:lower() == city_name:lower() then
            return city
        end
    end
end

return module
