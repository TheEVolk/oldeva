local command = botcmd.new("кейс", "мои кейсы", {dev=1})

local case_types = {
    ['hube'] = {
        name = "Бомж кейс",
        items = {
            { 'bits', 10000 }, { 'bits', 1000 }, { 'bits', 50000 }, { 'bits', 100 },
            { 'bits', 10000 }, { 'bits', 20000 }, { 'score', 1000 }, { 'bits', 100000 },
            { 'case', 'hube' }, { 'case', 'bronze' }
         }
    },

    ['bronze'] = {
        name = "Бронзовый кейс",
        items = {
            { 'bits', 80000 }, { 'bits', 100000 }, { 'bits', 500000 }, { 'bits', 1000000 },
            { 'bits', 80000 }, { 'bits', 100000 }, { 'score', 10000 }, { 'bits', 5000000 },
            { 'case', 'hube' }, { 'case', 'silver' }
         }
    },

    ['silver'] = {
        name = "Серебрянный кейс",
        items = {
            { 'bits', 1000000 }, { 'bits', 1000000 }, { 'score', 30000 }, { 'bits', 1000000 },
            { 'bits', 10000000 }, { 'bits', 5000000 }, { 'bits', 3000000 }, { 'bits', 500000 },
            { 'case', 'gold' }, { 'case', 'bronze' }
         }
    },

    ['gold'] = {
        name = "Золотой кейс",
        items = {
            { 'bits', 20000000 }, { 'bits', 5000000 }, { 'score', 60000 }, { 'bits', 1000000 },
            { 'bits', 10000000 }, { 'bits', 5000000 }, { 'bits', 3000000 }, { 'bits', 500000 },
            { 'case', 'hube' }, { 'case', 'bronze' }, { 'case', 'gold' }, { 'case', 'black' }
         }
    },

    ['black'] = {
        name = "Black кейс",
        items = {
            { 'bits', 50000000 }, { 'bits', 5000000 }, { 'score', 1000000 }, { 'bits', 1000000 },
            { 'bits', 100000000 }, { 'bits', 5000000 }, { 'bits', 3000000 }, { 'bits', 500000 },
            { 'bits', 300000000 }, { 'bits', 500000000 }, { 'score', 150000 }, { 'case', 'flex' },
         }
    },

    ['casecase'] = {
        name = "Кейсовый кейс",
        items = {
            { 'case', 'hube' }, { 'case', 'bronze' }, { 'case', 'silver' }, { 'case', 'gold' }, { 'case', 'black' }, { 'case', 'hube' }
         }
    },

    ['hc'] = {
        name = "Хуёвый кейс",
        items = {
            { 'case', 'hc' }, { 'bits', 0 }
         }
    },

    ['ohy'] = {
        name = "Охуевший кейс",
        items = {
            { 'case', 'hc' }, { 'bits', - 1000000 }, { 'case', 'hube'}
         }
    },

    ['flex'] = {
        name = "Флекс кейс",
        items = {
            { 'bits', 50000000 }, { 'bits', 5000000 }, { 'score', 100000 }, { 'bits', 1000000 },
            { 'bits', 13370000 }, { 'bits', 5000000 }, { 'bits', 3000000 }, { 'bits', 500000 },
            { 'case', 'gold' }, { 'bits', 2281337 }, { 'case', 'hube'}, { 'case', 'flex' },
            { 'case', 'gold' }, { 'bits', 1337228 }, { 'case', 'black'}, { 'case', 'casecase' },
         }
    },

    ['max'] = {
        name = "Макс кейс",
        items = {
            { 'ban', 3600 }, { 'ban', 43200 }, { 'ban', 86400 }, { 'bits', 1000000 },
            { 'bits', 13370000 }, { 'ban', 600 }, { 'ban', 1600 }, { 'bits', 500000 },
            { 'case', 'gold' }, { 'bits', 2281337 }, { 'case', 'hube'}, { 'case', 'max' },
            { 'case', 'hube' }, { 'bits', 1337228 }, { 'case', 'hube'}, { 'case', 'casecase' },
         }
    }
}

function get_case_types()
    return case_types
end

local function get_case_open_image(typeslug, typename, wintext, uptext, downtext)
    local function draw_box(img, x, y, sx, sy)
        img:composite(magick.open_pseudo(math.floor(sx), math.floor(sy), "canvas:rgba(0, 0, 0, 0.5)"), math.floor(x), math.floor(y))
    end

    local img = magick.open(root.."/images/citata_backs/"..math.random(18)..".jpg")
    img:blur(10, 20)

    -- Boxes
    draw_box(img, 25, 25, 482, 512 - 50)
    draw_box(img, 517, 25, 482, 512 - 50)

    -- Icon
    local img_icon = magick.open(root.."/images/cases/"..typeslug..".png")
    img_icon:resize((1024 - 50 - 80) / 2, math.floor((1024 - 50 - 80) / 2 * (836 / 1200)))
    img:composite(img_icon, 25 + 20, 45)

    img:set_font_align(2)
    img:set_font(root.."/res/segoeuilight.ttf")

    img:set_font_size(900 / utf8.len(typename))
    img:annotate("rgb(255,255,255)", typename, 25 + 20 + (1024 - 50 - 80) / 4, 512 - 55, 0)

    -- 517
    img:set_font_size(80)
    img:annotate("rgb(255,255,255)", "Вам выпало:", 517 + 482/2, 100, 0)

    img:set_font_size(900 / utf8.len(wintext))
    img:annotate("rgb(255,255,255)", wintext, 517 + 482/2, 512 / 2 + 50, 0)

    img:set_font_align(1)

    img:set_font_size(50)
    img:annotate("rgb(150,150,150)", uptext, 517 + 40, 512 / 2 - 50, 0)

    img:set_font_size(50)
    img:annotate("rgb(150,150,150)", downtext, 517 + 40, 512 / 2 + 150, 0)

    -- Upload
    local temp_path = temp.get_path("png")
    img:write(temp_path)
    return temp_path
end

local case_print_item = {
    ['bits'] = function(v) return comma_value(v[2]) .. " бит" end,
    ['score'] = function(v) return comma_value(v[2]) .. " ед. опыта" end,
    ['ban'] = function(v) return "Бан на " .. moment.get_time(v[2]) end,
    ['case'] = function(v) return case_types[v[2]].name end,
}

command:addsub("бонус", function(msg, args, other, rmsg, user)
    local case = trand{ 'hube', 'bronze', 'silver', 'gold', 'black', 'casecase', 'flex', 'max'}
    db("INSERT INTO `cases` VALUES(NULL, %i, '%s')", user.vkid, case)
	rmsg:line ("🎁 Вы получили <<%s>> абсолютно бесплатно!", case_types[case].name)
end)

command:addmsub("give", "<игрок> <тег кейса>", "Us", function(msg, args, other, rmsg, user, target, case_tag)
    ca(user:isRight("givecase"), "у вас нет доступа к данной команде ⛔")
    local case_type = ca(case_types[case_tag], "кейс с таким тегом не найден")

    db("INSERT INTO cases VALUES(NULL, %i, '%s')", target.vkid, case_tag)
    target:ls("🎁 Вы получили <<%s>>.", case_type.name)
    rmsg:line'ok'

    numcmd.menu_funcs(rmsg, user, {
        {{ 1, "Назад", "кейс" }}
    })
end)

command:addmsub("инфо", "<ид кейса>", "i", function(msg, args, other, rmsg, user, case_id)
    local case = ca(db.select_one("*", "cases", "id=%i", case_id), "кейс с таким номером не найден")
    local case_type = case_types[case.type]

    rmsg:lines (
        { "🗃 %s (№%i)", case_type.name, case.id },
        { "🎩 Владелец: %s", db.get_user(case.owner):r() },
        case.owner == user.vkid and {"\n💡 Введи `кейс открыть %i` для открытия этого кейса.", case.id}
    )

    rmsg.attachment = upload.get("photo_messages", msg.peer_id, root.."/images/cases/"..case.type..".png")

    numcmd.menu_funcs(rmsg, user, {
        case.owner == user.vkid and {{ 1, "📤 Открыть кейс", "кейс открыть "..case.id }},
        {{ 2, "📜 Список предметов", "кейс предметы "..case.type }}
    })
end)

command:addmsub("предметы", "<тег кейса>", "s", function(msg, args, other, rmsg, user, case_tag)
    local case_type = ca(case_types[case_tag], "кейс с таким тегом не найден")

    rmsg:line("🗃 %s", case_type.name )
    for i,v in ipairs(case_type.items) do rmsg:line("► %s.", case_print_item[v[1]](v)) end

    numcmd.menu_funcs(rmsg, user, {
        {{ 1, "Назад", "кейс" }}
    })
end)

command:addmsub("открыть", "<ид кейса>", "i", function(msg, args, other, rmsg, user, case_id)
    local case = ca(db.select_one("*", "cases", "id=%i", case_id), "кейс с таким номером не найден")
    ca(case.owner == user.vkid, "только владелец кейса может открыть свой кейс")
    local case_type = case_types[case.type]

    local win = trand(case_type.items)
    local upwin = trand(case_type.items)
    local downwin = trand(case_type.items)

    -- Засчитаем
    local case_add_win = {
        ['bits'] = function(user, v) user:addMoneys(v[2]) end,
        ['score'] = function(user, v) user:addScore(v[2]) end,
        ['ban'] = function(user, v) user:banUser(v[2]) end,
        ['case'] = function(user, v) db("INSERT INTO cases VALUES(NULL, %i, '%s')", user.vkid, v[2]) end,
    }

    case_add_win[win[1]](user, win)
    user:unlockAchiv('caseman')
    db("UPDATE `keyvalue` SET value = '%i' WHERE id=5", user.vkid)

    db("DELETE FROM `cases` WHERE id=%i", case.id)

    local temp_path = get_case_open_image(
        case.type,
        case_type.name,
        "► " .. case_print_item[win[1]](win),
        case_print_item[upwin[1]](upwin),
        case_print_item[downwin[1]](downwin)
    )

    rmsg.attachment = upload.get("photo_messages", msg.peer_id, temp_path)
    temp.free_path(temp_path)

    numcmd.menu_funcs(rmsg, user, {
        {{ 1, "К кейсам", "кейс" }}
    })
end)

function command.exe(msg, args, other, rmsg, user)
    local cases = db.select("*", "cases", "owner = %i", user.vkid)

    if #cases == 0 then
        rmsg:lines("🗃 У вас ещё нет кейсов.", "✨ Приобрети их прямо сейчас!")
        numcmd.menu_funcs(rmsg, user, {
            {{ 1, "🗃 Приобрести кейсы", "донат" }},
            {{ 2, "🔮 Бесплатный кейс", "кейс бонус" }}
        })
        return
    end

	rmsg:line("🗃 Ваши кейсы (%i шт.)", #cases)
	for i,v in ipairs(cases) do rmsg:line("► %i. %s.", i, case_types[v.type].name) end
    rmsg:line("\n💡 Используй числа для выбора варианта меню.")

    numcmd.linst_list(user, function(msg, obj, other, rmsg, user)
        return command.sub["инфо"][3](msg, {}, other, rmsg, user, obj.id)
    end, cases)
end

return command
