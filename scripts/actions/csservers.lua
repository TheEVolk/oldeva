local servers = {
    { '&#9724;', '27015', 'Classic' }
};

return {
    exe = function (msg, data, other, rmsg, user)
        rmsg:line "&#128163; CS 1.6 сервера EFlex:"
        for i = 1, #servers do
            local info = net.jSend ("http://eserv.elektro-volk.ru/api/cs_info.php?ip=185.58.204.18", { port = servers[i][2] });
            local status = info.status=="online" and (info.server.online.."/"..info.server.max) or "Offline";
            rmsg:line ("%s 185.58.204.18:%s - %s ["..status.."]", table.unpack(servers[i]));
        end
        other.sendname = false;
    end
};
