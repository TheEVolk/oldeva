local command = botcmd.mnew("ответ", "ответить на вопрос в EVA COOL", "<ваш ответ>", "i")

function command.exe(msg, args, other, rmsg, user, resp)
    ca(msg.peer_id == 2000000002, "доступно только в EVA COOL")
    ca(global_question, "вопросов пока нет")
    if user_bans[msg.from_id] then return end
    if global_question[1] ~= resp then
    user_bans[msg.from_id] = true
 return ("⭕ Ответ неверный.\n🚫 Вы больше не сможете ответить на этот вопрос.")
end
    user:addMoneys(global_question[2])
    user:addScore(math.random(10, 80))
    rmsg:line("✔ %s правильно ответил на вопрос и получил %s бит!", user:r(), comma_value(global_question[2]))
    global_question = nil
end

return command;
