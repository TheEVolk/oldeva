local command = botcmd.new("виджет", "виджет для android", {dev=1})

function command.exe(msg, args, other, rmsg, user)
    rmsg:lines(
        { "🌹 Наш виджет позволяет увидеть основную информацию в реальном времени." },
        "",
        { "📲 Установка:" },
        { "➤ 1. Скачать и установить приложение AnyBalance:" },
        { "https://anybalance.ru/promocode/G@3G4EKGD/?from=ab+"},
        { "➤ 2. Скачать наш провайдер для интеграции с Евой:" },
        { "https://yadi.sk/d/UUVRVWfWwZPBPw"},
        { "3. Добавить аккаунт и в настройках указать ваш ID ВКонтакте." },
        { "4. Добавить виджет на рабочий стол." },
        "",
        { "Приложение отображает ваш баланс, опыт, уровень, состояние питомцев и многое другое..." },
        { "По всем вопросам >> vk.me/evabottp" }
    )

    rmsg.attachment = "photo-134466548_456282980"
    rmsg.dont_parse_links = 1
end

return command
