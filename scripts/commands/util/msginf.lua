local command = botcmd.new("msginf", "message info", {use='[(FWD)]', dev=1, right='msginf', _type='dev'})

function command.exe(msg, args, other, rmsg)
	return vk.send('messages.getById', { message_ids = msg.id });
end

return command;
