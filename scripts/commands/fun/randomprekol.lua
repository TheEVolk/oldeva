local command = botcmd.new("прекол", "случайный ПрЕкОл", {dev=1})

function command.exe(msg, args, other, rmsg)
    return "прекол в том, шо его нет"
    --[[local count = VK.wall.get { owner_id = -152057624, count = 1, access_token = evatoken }.response.count;
    local items = VK.wall.get { owner_id = -152057624, count = 1, offset = randomorg.get_int(1, count - 1), access_token = evatoken }.response;


    rmsg:line ("Лови прекол из группы [public152057624|Комиксы и преколы] &#128163;")
    --rmsg:line ("");
    --rmsg:line (items.items[1].text);
    rmsg.attachment = 'photo-149279263_' .. items.items[1].attachments[1].id]]
end

return command
