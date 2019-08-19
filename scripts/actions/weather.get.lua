local action = {
    exe = function (msg, data, other, rmsg, user)
        local city = data.parameters.city or '';
        if #city == 0 then return "а где?" end

        local url = 'http://api.openweathermap.org/data/2.5/weather?appid=0a6f33916897bb0dfde4b7d004ce94ee';
        local weather = net.jSend(url..'&lang=Russian+-+ru&units=metric&q='..city);

        if not weather.name then return 'а я не нашла такого города, как ' .. city end

        rmsg:line ("погода в городе %s:", city);
    	rmsg:line ("🌲 Состояние: "..weather["weather"][1]["main"]);
    	rmsg:line ("🌲 Температура: "..weather["main"]["temp"].." °C");
    	rmsg:line ("🌲 Давление: "..weather["main"]["pressure"].." hPa");
    	rmsg:line ("🌲 Влажность: "..weather["main"]["humidity"].."%%");
    	rmsg:line ("🌲 Ветер: "..math.floor(weather["wind"]["speed"]).." m/s");
    	rmsg:line ("🌲 Облачность: "..weather["clouds"]["all"].."%%");
    end
};
return action;
