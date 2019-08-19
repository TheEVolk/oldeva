local module = { }

function module.check_install()
    check_module 'db'
    db.check_table ('homes', 'houses', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`city` int(11) NOT NULL,
			`street` int(11) NOT NULL,
			`number` int(11) NOT NULL,
			`owner` int(11) NOT NULL,
			`structure` TEXT NOT NULL,
			`structure_variant` int(11) NOT NULL,
			`slots` int(11) NOT NULL,
			`last_payment_utilities` int(11) NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);

    db.check_column('homes', db.acctable, 'home', 'INT NOT NULL')
end

function module.start()
    botcmd.add_argtype('h', "house", function(args, arg, offset, user)
        ca(toint(arg), "это не ид")
        return ca(db.select_one("*", "houses", "id=%i", toint(arg)), "участок или дом не найден")
    end)
end

function module.get_random_pos(city_id)
    local street_id = math.random(#cities.streets[city_id])
    local houses = db.select("*", "houses", "city=%i AND street=%i", city_id, street_id)
    local fh = function(number) for i,h in ipairs(houses) do if h.number == number then return true end end end

    local number = 1
    while fh(number) do
        number = number + 1
    end

    return street_id, number
end

function module.get_structure_image(peer_id, structure_name, structure_variant_id)
    local filename = root.."/images/homes/"..structure_name.."/"..structure_variant_id..".jpg"

    local server = VK.photos.getMessagesUploadServer{peer_id=peer_id}.response
    local loaded_file = net.jSend(server.upload_url, { ['@file'] = filename }, "multipart/form-data")
    local saved = VK.photos.saveMessagesPhoto(loaded_file).response[1]
    return "photo"..saved.owner_id.."_"..saved.id
end

return module
