function slivpin_write(text)
    VK.messages.send {
        message = table.concat({ "🌐 Подсказка к банку:", "↳ "..text.."." }, '\n'),
        peer_id = 2000000002
    }
end

function slivpin_bm()
    local bankpin = tonumber(db.select_one('value', 'keyvalue', "id=3").value)
    local random_value = math.random(899) + 100
    if random_value == bankpin then return end
    slivpin_write("Код банка "..(random_value > bankpin and "меньше" or "больше")..", чем "..random_value)
end

function slivpin_chet()
    local bankpin = tonumber(db.select_one('value', 'keyvalue', "id=3").value)
    slivpin_write("Код банка является "..(bankpin%2==0 and "чётным" or "нечётным").." числом")
end

function slivpin_odna()
    local bankpin = tonumber(db.select_one('value', 'keyvalue', "id=3").value)
    local bankstr = ""..bankpin
    local random_symb = math.random(#bankstr)
    slivpin_write("Код банка содержит цифру "..(bankstr:sub(random_symb,random_symb)))
end

timers.create(60000, 0, function()
    if math.random(100) < 95 then return end
    trand({ slivpin_bm, slivpin_chet, slivpin_odna })()
end)