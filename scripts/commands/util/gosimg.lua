local command = botcmd.mnew("госк", "генератор изображения гос. номера", "<гос. номер>", "s", {dev=1})
local symbs = { ["Е"] = "E", ["Т"] = "T", ["У"] = "Y", ["О"] = "O", ["Р"] = "P",
    ["А"] = "A", ["Н"] = "H", ["К"] = "K", ["Х"] = "X", ["С"] = "C", ["В"] = "B",
    ["М"] = "M"
}

function command.exe(msg, args, other, rmsg, user, str)
    str = str:upper()
    for k,v in pairs(symbs) do str = str:gsub(k, v) end

    local img = assert(magick.open(root.."/images/number_place.png"))

    img:set_font_size(330)
    img:set_font(root.."/res/RoadNumbers2_0.ttf")
    img:annotate("rgb(0,0,0)", str:match("%a%d%d%d%a%a") or "O000OO", 135, 260, 0)
    img:set_font_align(2)
    img:set_font_size(220)
    img:annotate("rgb(0,0,0)", str:match("%d+$") or "00", 1265, 175, 0)

    --dxDrawText(string.match(text, "%a%d%d%d%a%a"), 15, 55, 15, 55, tocolor(0, 0, 0, 255), 0.8, font, "left", "bottom")
    --dxDrawText(string.match(text, "%d+$"), 220, 10, 220, 10, tocolor(0, 0, 0, 255), 0.45, font, "center")

    img:write(root.."/temp/number_place.png")
    local p = photo_messages(msg.from_id, root.."/temp/number_place.png")
    rmsg.attachment = "photo"..p.owner_id.."_"..p.id
end

function photo_messages(peer_id, filename)
    local server = VK.photos.getMessagesUploadServer{peer_id=peer_id}.response
    local loaded_file = net.jSend(server.upload_url, { ['@file'] = filename }, "multipart/form-data")
    local saved = VK.photos.saveMessagesPhoto(loaded_file)
    if not saved.response then
        console.log(saved.error.error_code, json.encode(loaded_file))
        os.execute("sleep 1")
        return module.photo_messages(peer_id, filename)
    end
    return saved.response[1]
end

return command
