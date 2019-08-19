local command = botcmd.new("анек", "анекдот категории Б+", {dev=1})

function command.exe(msg, args, other, rmsg)
    local count = VK.wall.get { owner_id = -149279263, count = 1, access_token = evatoken }.response.count;
    local items = VK.wall.get { owner_id = -149279263, count = 1, offset = randomorg.get_int(1, count - 1), access_token = evatoken }.response;


    rmsg:line ("Лови анекдот из группы [public149279263|Анекдоты категории Б+] &#128163;");
    rmsg:line ("");
    rmsg:line (items.items[1].text);
    --rmsg.attachment = 'wall-149279263_' .. items.items[1].id;
end

return command
