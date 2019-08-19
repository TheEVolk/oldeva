local command = botcmd.new("приют", "Покупка питомцев", {dev=1, sub={}})

command.help = function (msg, args, other, rmsg)
	rmsg:lines (
        "🐾 Приют питомцев.",
        "🔹 Приют список <вид> - Список питомцев в приюте данного вида;",
        "🔹 Приют купить <ид питомца> - Купить питомца за 5000 бит;",
        "➡ пит список кот",
        "🔲 vk.com/@evarobotgroup-pet"
    )
end

command:addmsub("список", "<вид>", "d", function(msg, args, other, rmsg, user, type_name)
	local type = ca(
		db.select_one("*", "p_types", "mname='%s' OR wname='%s'", type_name, type_name),
		"данный тип питомцев не существует :~/"
	)

	local title = type.smile.." Питомцы типа "..type.mname
	local type_pets = db.select("*", "p_pets", "owner=0 AND type=%i", type.id)
	rmsg:draw_list(title, type_pets, ":id:. :name: :pets.ssm(v): :pets.status(v):", user, botcmd.get("пит"), "инфо", "p", true)
end)

command.sub['купить'] = { '<ид питомца>', 'p', function (msg, args, other, rmsg, user, pet)
    local type = pets.types[pet.type]

	ca(pet.owner == 0, "увы, но этого питомца уже кто-то забрал")
	ca(db.get_count("p_pets", "owner=%i", user.vkid) < 3, "вы не можете иметь больше 3-х питомцев")
	ca(user:isRight 'vippets' or type.vip==0, "этот питомец доступен только для VIP.")

	if pet.love < 10 then
		rmsg:lines (
			{ "🙀 %s боится людей и вас тоже.", pet.name },
			{ "➡ пит кормить %i - покормите питомца.", pet.id }
		)

		return rmsg
	end

	user:buy(5000)

	db("UPDATE `p_pets` SET love=love + 10, issleep=0, owner=%i WHERE id=%i", user.vkid, pet.id);

	local petcit = {
		"Питомец верит в вас и знает, что попал в лучшие руки!",
		"Он знает, что с вами ему будет весело!",
		"Любите его и он будет любить вас!",
		"Подарите ему любовь и ласку!",
		"Теперь вы - герой для него!",
		"Питомец светится от счасться!",
		"<<Ура! Наконец-то у меня есть хозяин!>> - кричал бы питомец, если бы мог говорить."
	}

	rmsg:lines (
		{ "✨ Вы только что стали хозяином для %s", pet.name },
		{ "☀️ %s", trand(petcit) }
	)
end }

function command.exe(msg, args, other, rmsg, user)
	local pettypes = db.select(
		"*,(SELECT COUNT(id) FROM p_pets WHERE type=p_types.id AND owner=0) AS count",
		"p_types",
		not user:isRight 'vippets' and 'vip=0'
	)

	rmsg:lines (
		"🐾 Доступные питомцы в приюте:",
		{ pettypes, ":v.smile: :i: >> :v.mname: (:v.count: шт.)" },
		"➡ приют список кот"
	)

	numcmd.linst(user, function (msg, num, other, rmsg, user)
		return pettypes[num] and command.sub['список'][3](msg, nil, other, rmsg, user, pettypes[num].mname) or false
    end)
end

return command;
