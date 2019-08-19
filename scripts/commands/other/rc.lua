local command = botcmd.mnew("рц", "рация в такси", "<текст>", "d", {dev=1})
command.exe = botcmd.commands['такси'].sub['рация'][3]

return command
