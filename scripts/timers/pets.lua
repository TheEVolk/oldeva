local pet_names = {
    man = {
        "Ешка", "Барсик", "Кузя", "Афиг-его-знает", "Сержант Пушистые Штаны",
        "Алекс", "Кекс", "Мурзик", "Персик", "Лаки", "Марсик", "Тишка", "Феликс",
        "Тимоша", "Боня", "Дымок", "Бакс", "Котэ", "Зефир", "Шаурма", "Каспер",
        "Локи", "Марс", "Сёмка", "Кексик", "Барс", "Жорик", "Кокс", "Дарт Вейдер",
        "Масик", "Лео", "Зевс", "Басик", "Альф", "Маркиз", "Симба", "Яшка", "Том",
        "Максимус Де Мяучиус Первый", "Саймон", "Томас", "Макс", "Гарфилд", "Оскар",
        "Сэм", "Тайсон", "Тима", "Гад Пушистый", "Тёма", "Снежок", "Абрикосик"
    },
    woman = {
        "Муся", "Ася", "Жужа", "Кудабля", "Багира", "Мурка", "Сима", "Мася", "Алиса",
        "Соня", "Боня", "Иди жрать", "Буся", "Таша", "Бусинка", "Нюша", "Манюня", "Василиса",
        "Маркиза", "Клеопатра", "Ника", "Адель", "Яся", "Клёпа", "Пуся", "Дуся", "Джессика",
        "Аська", "Афина", "Шанель", "Кесси", "Алиска", "Симка", "Джеси", "Ириска", "Анфиса",
        "Бася", "Ева", "Милка", "Муська", "Дымка", "Лаки", "Аврора", "Карамелька", "Персик",
        "Джесси", "Матильда", "Масяня", "Маруся"
    }
}

function every_hour()
    db("UPDATE `p_pets` SET `love`=`love`-1, `hunger`=`hunger`-1 WHERE `love` > 0 AND `owner`!=0 AND `died`=0")

    for i,v in db.iselect("*", "p_pets", "`owner`!=0 AND `died`=0") do
        if v.love <= 0 then
            db("UPDATE `p_pets` SET `owner`=0 WHERE `id`=%i", v.id)
            db.get_user(v.owner):ls("‼ %s №%i убежал от вас, так как вы не играли с ним.", v.name, v.id)
            return
        end

        if v.hunger <= 0 then
            db("UPDATE `p_pets` SET `died`=%i WHERE `id`=%i", os.time(), v.id)
            db.get_user(v.owner):ls("⬛ %s №%i умер от голода.", v.name, v.id)
            return
        end

        if v.hunger <= 10 then
            db.get_user(v.owner):ls("💢 Срочно покормите %s №%i, иначе он умрет!", v.name, v.id)
        end
    end
end

function every_minute()
    for i,v in db.iselect("*", "p_types") do
        local pets_count = db.get_count("p_pets", "`owner`=0 AND `type`=%i", v.id)
		if pets_count < 5 then
            local sex = randomorg.get_int(0, 100) > 50
    		local name = trand(sex and pet_names.woman or pet_names.man)
            db(
                "INSERT INTO `p_pets` (`name`, `sex`, `type`, `birthday`) VALUES ('%s', %i, %i, %i)",
                name, sex and 1 or 0, v.id, os.time()
            )
        end
    end

	db("UPDATE `p_pets` SET `issleep`=1 WHERE `energy` <= 15 AND `died`=0")
	db("UPDATE `p_pets` SET `issleep`=0 WHERE `energy` >= 100 AND `died`=0")

	db("UPDATE `p_pets` SET `energy` = `energy` + 2 WHERE `issleep`=1 AND `died`=0")
	db("UPDATE `p_pets` SET `energy` = `energy` - 1 WHERE `issleep`=0 AND `died`=0")

	db("UPDATE `p_pets` SET `hunger` = `hunger` - 1 WHERE `owner`=0 AND `hunger` > 10 AND `died`=0")
end

timers.create(60000, 0, function()
    if os.time() % 3600 <= 60 then every_hour() end
    every_minute()
end)
