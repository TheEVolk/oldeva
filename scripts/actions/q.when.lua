local command = {
    exe = function (msg, data, other, rmsg, user)
        local text = data.parameters.q;
        local kogda = {};
        local f = io.open(root..'/settings/kogda.txt',"r+");
        for line in f:lines() do table.insert(kogda, tostring(line)) end

        return text .. " " .. kogda[math.random(#kogda)];
    end
};
return command;
