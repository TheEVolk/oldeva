local command = botcmd.mnew("па", "Половой акт", "<партнер>", "U")

function command.accept (target, source, rmsg)
	local active = math.random(100) > 50 and source or target;

	rmsg:line("Грузин гасит свечку...");
	rmsg:line("");
	rmsg:line("&#128286; %s &#128158; %s", source:r(), target:r());
	rmsg:line("&#128069; Актив: " .. active:r());
	local results = { 'Ничего не вышло', 'Лучше бы не получилось', 'Получилось ужасно', 'Получилось не очень', 'Получилось как обычно', 'Получилось хорошо', 'Получилось отлично', 'Вам очень понравилось', 'Вы были на седьмом небе', 'Это был самый лучший', 'АААААААААААААА' };
	local ok = math.random(#results);
	rmsg:line("&#128068; " .. results[ok]);

	--source:addScore(ok);
	--target:addScore(ok);
	--active:addScore(ok);

	local v = math.random(100);
	local vv = 1;
	if v > 80 then vv = 2 end
	if v <= 80 and v > 55 then vv = 3 end

	rmsg:line("&#127826; Вид: " .. ({ 'первый', 'второй', 'третий' })[vv]);
end

function command.exe(msg, args, other, rmsg, user, target)
    if target.vkid == user.vkid then return "&#128560;&#128074;&#128166;" end
    if target.vkid == 311346896 then return command.accept(target, user, rmsg) end
    if user.vkid == 480272144 and target.married ~= 480272144 and target.married ~= 0 then
		user:banUser()
		return "вы получили перманентный бан за домогательство до женатых"
	 end
    --if target.vkid == admin     then return command.accept(target, user, rmsg) end

    local qid = inv.create(user, target, command.accept)
    rmsg:line("%s 💕 %s", user:r(), target:r())
    inv.lines(rmsg, qid, target)
end



return command;
