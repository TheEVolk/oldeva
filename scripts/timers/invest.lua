timers.create(60000, 0, function()
    if os.time() % 3600 > 60 then return end
    if db.get_count("invest") == 0 then return end

    local medium = db.select_one("AVG(count)", "invest")["AVG(count)"]

    local temp, winner_vkid
	for i,rate in db.iselect("*", "invest") do
		if not temp or math.abs(rate.count - medium) < temp then
			temp = math.abs(rate.count - medium)
			winner_vkid = rate.vkid
		end
	end

    local winner = db.get_user(winner_vkid)
	local count = db.select_one("SUM(count)", "invest")["SUM(count)"]
    db("TRUNCATE invest")

    winner:unlockAchiv('invest')

	winner:addMoneys(count)
    winner:ls("🏆 Ты выиграл инвестиции.\n💰 Выигрыш >> %s бит.", comma_value(count))

    VK.messages.send {
        peer_id = 2000000002,
        message = string.format("🏆 %s выиграл инвестиции.\n💰 Выигрыш >> %s бит.", winner:r(), comma_value(count))
    }
end)
