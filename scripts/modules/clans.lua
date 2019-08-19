local module = {}

function module.start()
    hooks.add_action("bot_post", function (msg, other, user, rmsg)
    	if not other.sendname or user.clan == 0 then return end
    	rmsg.message = '['..db.select_one("name", "clans", "id=%i", user.clan).name..'] '..rmsg.message
    end, 0)
end

return module
