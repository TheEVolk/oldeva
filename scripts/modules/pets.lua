local module = { }

function module.check_install()
    check_module 'db'
    db.check_table ('pets', 'p_types', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`mname` TEXT NOT NULL,
			`wname` TEXT NOT NULL,
			`isVip` int(11) NOT NULL,
			`smile` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);

    db.check_table ('pets', 'p_pets', [[(
			`id` int(11) NOT NULL AUTO_INCREMENT,
            `name` text NOT NULL,
            `owner` int(11) NOT NULL,
            `hunger` int(11) NOT NULL,
            `love` int(11) NOT NULL,
            `energy` int(11) NOT NULL,
            `issleep` int(11) NOT NULL,
            `birthday` int(11) NOT NULL,
            `died` int(11) NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
	);
end

function module.start()
    module.types = db.select('*', 'p_types')

    -- p - pet
    botcmd.add_argtype('p', "pet", function (args, arg, offset, user)
        print(arg)
        return toint(arg) and ca(db.select_one("*", "p_pets", "id=%i", toint(arg)), "питомец не найден")
    end)
end

function module.ssm(pet)
    return pet.issleep==1 and '💤' or ''
end

function module.full_name(pet)
    local type = module.types[pet.type]
    return pet.sex == 0 and type.mname or type.wname.." "..pet.name
end

function module.status(pet)
    return string.format("(г. %i%% • л. %i%% • э. %i%%)", pet.hunger, pet.love, pet.energy)
end

return module
