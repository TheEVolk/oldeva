local action = {
    exe = function (msg, data, other, rmsg, user)
        local resp = net.jSend(
            "https://ru.wikipedia.org/w/api.php?action=opensearch&prop=info&format=json&inprop=url&limit=1",
            { search = data.parameters.name }
        );

        return ca (resp[3][1], 'я не знаю :(');
    end
};
return action;
