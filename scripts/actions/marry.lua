braks = braks or {};

local accept = function (_, target, source, rmsg)
    ca (target.married == 0 and source.married, "ни один из возлюбленных не должен быть в браке");

    local bid = math.random(9000) + 999;
    braks[bid] = { source, target }

	rmsg:line ("&#127872; %s &#128158; %s", source:r(), target:r());
	rmsg:line ("&#128141; Работник ЗАГСа должен подтвердить ваш брак.");
	rmsg:line ("&#128150; Ева, подтверди брак %i", bid);
end

return {
    exe = function (msg, data, other, rmsg, user)
        local target = ca (DbData.S(data.parameters.target), "а я не знаю его 0_о");
        ca (target.vkid ~= user.vkid, "жениться на самом себе нельзя :)");
        user:checkMoneys(250000);
        user:addMoneys(-250000, "свадьба");

    	local qid = Invites.Invite(user, target, accept);
    	rmsg:line("вы хотите брак с %s", target:r());
    	rmsg:line("&#9899; %s должен принять запрос командой:", target:r());
    	rmsg:line("&#10145; принять " .. qid);
    end
};
