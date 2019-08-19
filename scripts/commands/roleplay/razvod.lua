local command = botcmd.mnew("развод", "Расторжение брака", "<партнер>", "U")

function command.exe(msg, args, other, rmsg, user, target)
	ca (user.married ~= 0, "вы не состоите в браке");
	ca (target.vkid == user.married, "это не ваш партнер");

	user:set('married', 0);
	target:set('married', 0);

	target:ls("%s расторгнул брак", user:r());

	other.sendname = true;
	return "ваш брак был расторгнут.";
end

return command;
