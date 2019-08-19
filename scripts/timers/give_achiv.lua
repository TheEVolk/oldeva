-- Выдаем ачивку за оценку в сервисе

timers.ecreate(60000, 0, function()
    local users = net.jSend('https://bots-api.sproject.space/method/ratings.getAll?bid=22&access_key=26c6499aec1d23bf58d4cb7d').response
    for i = 1, #users do
        for k,v in pairs(online.users) do
            if k == users[i] then
                if not db.select_one('id', 'unlocked_achivs', "vkid=%i AND slug='rate'", k) then
                    db.get_user(k):unlockAchiv('rate')
                end
            end
        end
    end
end)
