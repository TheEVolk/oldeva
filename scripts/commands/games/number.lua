local command = botcmd.mnew("число", "Угадай число Евы и получи бонус", "<ставка> <1-10>", "ii", {dev=1})

command.lost_messages = {
	'лох', 'ты гора с дырой закрытой',
	'ну че сказать)', 'спасибо за биты',
	'о, дошик куплю', 'азартные игры не для тебя',
	'мдаа', 'ну а че ты хотел?', 'ваши биты скушал котик',
	'на ваши биты залез паук. Вы их сожгли.',
	'ну и че ты наделал?', 'могли бы лучше питомцев накормить',
	'урааа, ты проиграл!', 'лучше стало?', 'собаки покусали твои биты',
	'макс дал - макс взял', 'мне они будут нужнее... У меня дети...'
};

command.win_messages = {
	'выиграл', 'победа', 'маладца',
	'ваши биты срыгнул котик', 'от дяди Баира', 'да забери ты свои биты',
	'еще раз выиграешь и я банкрот', '[-_-]', 'мяу',
	'мурр', 'доволен?', 'это тебе.',
	'надеюсь, тебе стало лучше', 'поздравляю', 'удача на твоей стороне',
	'не трогай, это на новый год', 'вот бы с рублями так', 'зачем тебе биты?',
	'дернул за канат', 'макака поймала банан', 'евино три лотера',
	'читер', 'возьми', 'с вас 1000 рублей.',
};

function command.exe(msg, args, other, rmsg, user, count, user_number)
    ca (count > 10, "я не играю на всю зарплату админa");
    ca(user:getValue 'maxlot' >= count, "вы не можете ставить так много бит");
    ca (user_number >= 1 and user_number <= 100, "я загадываю числа от 1 до 10");
	user:checkMoneys(count);

	local bot_number = math.random(10);
	if bot_number == user_number then
		user:addMoneys(count, "Победа в число");
		rmsg:line('⚪ ' .. trand(command.win_messages));
	else
		user:addMoneys(-count, "Поражение в число");
		db("UPDATE `keyvalue` SET `value`=`value`+%i WHERE `key`='bank';", count)
		rmsg:line('⚪ ' .. trand(command.lost_messages));
	end
	rmsg:line("🤷 Я загадала %i", bot_number);
end

return command;
