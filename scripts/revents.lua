RandomEvents.events = {
	{
		"К вам подошел бомж, сказал, что ему вас жалко и дал биты.", 70,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(60), "Биты от доброжелательного бомжа") end
	},
	{
		"Вы нашли биты.", 70,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(10), "Валялись под ногами") end
	},
	{
		"К вам подошел рэпер и дал четкий бит", 70,
		function (msg, other, rmsg) other.udata:addMoneys(1, "Четкий бит") end
	},
	{
		"Бомж играл на трубе и попросил бит", 70,
		function (msg, other, rmsg) other.udata:addMoneys(-1, "Четкий бит для бомжа") end
	},
	{
		"К вам подошел некрасивый мужик и попросил сделать ему грязную услугу за биты.", 50,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(300), "За услугу мужику.") end
	},
	{
		"К вам подошел некрасивый мужик и сказал, что сделает кое-что с вами грязное, если вы не дадите ему биты.", 50,
		function (msg, other, rmsg)  end
	},
	{
		"По дороге вы нарвались на гопников, которые одолжили у вас биты", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "На доброе дело") end
	},
	{
		"Незнакомая девушка попросила помочь донести сумки, вы по дороге купили ей розы, но оказалось, что у неё есть парень.", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "БЕЛЫЕ РОООЗЫ БЕЛЫЕ РОООЗЫ БЕЕЗЗАЩИТНЫ ШИПЫ!!") end
	},
	{
		"По дороге мужик попросил сигарету, но вы закричали: \"ТОЛЬКО НЕ БЕЙТЕ!\" и дали ему биты", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "Мужику") end
	},
	{
		"Мужик попросил телефон, чтобы позвонить маме и позвонил в Африку", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "Звонок в Африку") end
	},
	{
		"Модный мужик с последним айфоном попросил биты на маршрутку", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(10), "На маршрутку") end
	},
	{
		"Тетенька из бухгалтерии чето нажала и биты исчезли", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "Упс") end
	},
	{
		"Мужик рассказал вам анегдот, а потом потребовал биты", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(100), "Платный анегдот") end
	},
	{
		"Вы заплатили налог на воздух", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(200), "Налог") end
	},
	{
		"Вы заплатили налог на налог", 50,
		function (msg, other, rmsg) other.udata:addMoneys(-math.random(200), "Налог") end
	},
	{
		"К вам подошел админ и дал биты. Он прошептал: \"Тебе никто не поверит\"", 5,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(5000)) end
	},
	{
		"Зайчик принес вам биты", 50,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(500), "От зайчика") end
	},
	{
		"Житель из майнкрафта дал вам пузырек опыта", 50,
		function (msg, other, rmsg) other.udata:addScore(math.random(500)) end
	},
	{
		"Вы случайно ограбили магазин", 5,
		function (msg, other, rmsg) other.udata:addMoneys(math.random(5000), "С магазина") end
	}
};