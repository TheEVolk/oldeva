local command = botcmd.new("!", "do ebp console", {dev=1, right='do', _type='dev', use='<commandline>'})

function command.exe(msg, args, other, rmsg)
	return cmd.exe(cmd.data(args,2));
end

return command;
