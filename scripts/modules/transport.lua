local module = { }
module.fuel_types = { 'АИ-92', 'АИ-95', 'АИ-98', 'ДТ' }
module.symbs = { "E", "T", "Y", "O", "P", "A", "H", "K", "X", "C", "B", "M" }
module.regions = {
	102, 103, 113, 116, 121, 116, 121, 123, 124, 125, 126, 134, 136, 138, 142, 150, 190,
	750, 152, 154, 159, 161, 163, 164, 196, 173, 174, 177, 197, 199, 777, 799, 178, 186
}

function module.check_install()
    check_module 'db'
    check_module 'cities'
    db.check_table ('transport', 'tr_models', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`brand` TEXT NOT NULL,
			`name` TEXT NOT NULL,
			`speed` int(11) NOT NULL,
			`fuel_type` int(11) NOT NULL,
			`consumption` int(11) NOT NULL,
			`price` int(11) NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);

    db.check_table ('transport', 'tr_obj', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`model` int(11) NOT NULL,
			`owner` int(11) NOT NULL,
			`buy_data` int(11) NOT NULL,
			`gosnum` VARCHAR(6) NOT NULL,
			`pos` int(11) NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);

    db.check_table ('transport', 'cities', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`name` TEXT NOT NULL,
			`x` int(11) NOT NULL,
			`y` int(11) NOT NULL
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);
end

function module.start()
    module.models = db.select('*', 'tr_models')
    module.cities = db.select('*', 'cities')

	module._models, module.number_places = dofile(root .. '/settings/transport.lua')
end

function module.find_city(city_name)
    for i = 1,#module.cities do
        if module.cities[i].name:lower() == city_name:lower() then
            return module.cities[i]
        end
    end
end

function module.generate_number()
	local str = trand(module.symbs)
	str = str..randomorg.get_int(1, 9)
	str = str..randomorg.get_int(1, 9)
	str = str..randomorg.get_int(1, 9)
	str = str..trand(module.symbs)
	str = str..trand(module.symbs)
	local region = randomorg.get_int(1, 100)>70 and trand(module.regions) or randomorg.get_int(1, 95)
	str = str..(region < 10 and '0' or '')..region

	return str
end

function module.get_gosnumber(n)
    local ret = string.char(65 + math.floor(n / 25 / 25 / 9 / 9 / 9) % 25)
    ret = ret .. math.floor(n / 25 / 25 / 9 / 9) % 9
    ret = ret .. math.floor(n / 25 / 25 / 9) % 9
    ret = ret .. math.floor(n / 25 / 25) % 9
    ret = ret .. string.char(65 + math.floor(n / 25) % 25)
    ret = ret .. string.char(65 + n % 25)
    return ret
end

function module.short_name(obj)
    return module.models[obj.model].name
end

function module.full_name(obj)
    local m = module.models[obj.model]
    return m.brand .. ' ' .. m.name
end

function module.get_status(obj, full)
    if obj.pos > 0 then
        return module.cities[obj.pos].name
    else
        if full then
            local route = db.select_one("*", "routes", "tid=%i", obj.id)
            return module.cities[route.from].name..' - '..module.cities[route.to].name..' • '..os.date("!%H часов %M минут", route['end']-os.time())
        else
            return "в пути."
        end
    end
end

function module.get_fuel_price(count, type)
    local prices = net.jSend("https://www.cbr-xml-daily.ru/daily_json.js")
    local tt = { prices.Valute.AUD.Value, prices.Valute.CAD.Value, prices.Valute.KRW.Value, prices.Valute.SGD.Value }

    return math.floor(tt[type]) * count
end

function module.get_vk_image(model)
    --if model.image=='' then return '' end
    --if model.vk_image=='' then
    --    local url = string.format("http://eva.elektro-volk.ru/images/transport/%s/%s.png", model.brand:lower(), model.name:lower())
    --    model.vk_image = 'photo'..net.send('system.elektro-volk.ru/copy.php', { url = url, access_token = cvars.get'vk_token' })
    --    db("UPDATE tr_models SET vk_image='%s' WHERE id=%i", model.vk_image, model.id)
    --    module.models = db.select('*', 'tr_models')
    --end

    return model.vk_image
    --return 'doc'..net.send('system.elektro-volk.ru/copy_gr.php', { url = model.image, access_token = cvars.get'vk_token', peer = peer_id })
end

function module.get_number_image(number)
	local img = assert(magick.open(root.."/images/number_place.png"))

    img:set_font_size(330)
    img:set_font(root.."/res/RoadNumbers2_0.ttf")
    img:annotate("rgb(0,0,0)", number:match("%a%d%d%d%a%a"), 135, 260, 0)
    img:set_font_align(2)
    img:set_font_size(220)
    img:annotate("rgb(0,0,0)", number:match("%d+$") or "00", 1265, 175, 0)

	return img
end

--[[local distort_points = {
	0,0, 0,number_img:height()*number_pos[3]/2, -- top left
	number_img:width(),0, number_img:width(),0, -- top right
	number_img:width(),number_img:height(), number_img:width(),number_img:height(), -- bottom right
	0,number_img:height(), 0,number_img:height()-number_img:height()*number_pos[3]/2 -- bottum left
}
number_img:distort(magick.distort_method["PerspectiveDistortion"], distort_points, false)]]

function module.get_obj_image(obj)
	return module.get_transport_image(obj.model, obj.gosnum)
end

function module.get_transport_image(model, gosnum)
	model = type(model) == "number" and module.models[model] or model
	assert_argument(model, "table", 1)
	assert_argument(gosnum, "string", 2)

    local img = magick.open(root.."/images/transport/"..model.brand:lower().."/"..model.name:lower()..".png")

	local number_pos = transport.number_places[model.id]
	if number_pos then
		local number_img = transport.get_number_image(gosnum)
	    number_img:resize(math.floor(number_img:width() * number_pos[3]), math.floor(number_img:height() * number_pos[3]))
	    number_img:rotate("rgba(0,0,0,0)", number_pos[4])
	    img:composite(number_img, math.floor(number_pos[1]-number_img:width()/2), math.floor(number_pos[2]-number_img:height()/2))
	end

	return img
end

return module
