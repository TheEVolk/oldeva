local command = botcmd.mnew("лотерея", "Старая, добрая лотерея на биты", "<ставка>", "i")

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

function command.exe(msg, args, other, rmsg, user, count)
	user:checkMoneys(count)
	ca(user:getValue 'maxlot' >= count, "вы не можете ставить так много бит")
	ca(count >= 10, "вы не можете ставить так мало бит")

	other.sendname = true
	if randomorg.get_int(0, 100) > user:getValue 'lostchance' then
		user:addMoneys(count, "Победа в лотерее");
		user:unlockAchivCondition('maxlot', count >= 1000000)
		return trand(command.win_messages);
	else
		user:addMoneys(-count, "Поражение в лотерее");
		db("UPDATE `keyvalue` SET `value`=`value`+%i WHERE `key`='bank';", count)
		return trand(command.lost_messages);
	end
end

return command;
