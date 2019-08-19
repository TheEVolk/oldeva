local accept = function (_, target, source, rmsg)
	local active = math.random(100) > 50 and source or target;

	rmsg:line("&#128286; %s &#128158; %s", source:r(), target:r());
	rmsg:line("&#128069; Актив: " .. active:r());
	local results = { 'Ничего не вышло', 'Лучше бы не получилось', 'Получилось ужасно', 'Получилось не очень', 'Получилось как обычно', 'Получилось хорошо', 'Получилось отлично', 'Вам очень понравилось', 'Вы были на седьмом небе', 'Это был самый лучший', 'АААААААААААААА' };
	local ok = math.random(#results);
	rmsg:line("&#128068; " .. results[ok]);
	local v = math.random(100);
	local vv = 1;
	if v > 80 then vv = 2 end
	if v <= 80 and v > 55 then vv = 3 end
	rmsg:line("&#127826; Вид: " .. ({ 'первый', 'второй', 'третий' })[vv]);
end

local action = {
    exe = function (msg, data, other, rmsg, user)
		return 'недоступно :)'
    end
};
return action;
