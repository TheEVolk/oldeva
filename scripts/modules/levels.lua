local module = {}
module.message = "🎉 Вы получили новый уровень! Теперь вы >> :name:"

function module.check_install()
    check_module 'db'
    db.check_column('levels', db.acctable, 'score', 'INT NOT NULL')
    db.check_column('levels', db.acctable, 'level', "INT NOT NULL DEFAULT 1")
end

function module.start()
    function db.oop:addScore (count) self:add('score', math.floor(count)) end

    module.levels = db.select("*", "levels")
    hooks.add_action("bot_post", module.post)
end

function module.post(msg, other, user, rmsg)
    local old_level = module.levels[user.level]
    if user.score > old_level.maxscore then
        user:add('level', 1)
        user:set('score', user.score - old_level.maxscore)
        local new_level = module.levels[user.level]
        if module.message then addline(rmsg, module.message:gsub(':name:', new_level.name)) end
    end
end

return module
