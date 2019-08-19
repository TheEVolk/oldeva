viperr = "Доступно только для VIP. <br>( Получить VIP: eva.elektro-volk.ru )";
biterr = "недостаточно бит. [%i бит]"
economyerr = "🚫 Упс! Кажется, это рушит экономику."

function menu_button(user, rmsg, msg)
	if msg.peer_id > 2000000000 then return end
	numcmd.menu_funcs(rmsg, user, {{{ 1, "Главное меню", botcmd.commands['меню'].exe, "positive" }}})
end
