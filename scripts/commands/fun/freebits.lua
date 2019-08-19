local command = botcmd.mnew("биты", "бесплатные биты", "<кол-во>", "i")

function command.exe(msg, args, other, rmsg, user, count)
	ca(count <= 2000000000, "Ева не умеет хранить столько бит")
	ca(count >= 0, "увы, но забирать нельзя")

	other.sendname = true
  user:addMoneys(count, "Победа в лотерее");
  
  return "бери :D"
end

return command;
