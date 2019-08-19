local command = botcmd.mnew("погода", "текущая погода в городе", "<город>", "d", {right='dev', dev=1})

function command.exe(msg, args, other, rmsg, user, city_name)
    local url = 'https://api.openweathermap.org/data/2.5/weather?appid=0a6f33916897bb0dfde4b7d004ce94ee'
    local weather = ca(json.decode(net.send('http://api.openweathermap.org/data/2.5/weather?appid=0a6f33916897bb0dfde4b7d004ce94ee&lang=ru&units=metric&q='..city_name, "charset=utf-8")), "город не найден")

    rmsg:line ("Погода в городе %s (%s):", weather.name, weather.sys.country);
    rmsg:line ("🌲 Состояние: "..weather["weather"][1]["description"]);
    rmsg:line ("🌲 Температура: "..weather["main"]["temp"].." °C");
    rmsg:line ("🌲 Давление: "..math.floor((tonumber(weather["main"]["pressure"])/1.33322)).." мм рт. ст.");
    rmsg:line ("🌲 Влажность: "..weather["main"]["humidity"].."%");
    rmsg:line ("🌲 Ветер: "..math.floor(weather["wind"]["speed"]).." м/с");
    rmsg:line ("🌲 Облачность: "..weather["clouds"]["all"].."%");
end

return command
