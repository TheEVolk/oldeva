local lang_codes = {
    ['арабский'] = 'ar',
    ['английский'] = 'en',
    ['испанский'] = 'es',
    ['китайский'] = 'zh',
    ['казахский'] = 'kk',
    ['корейский'] = 'ko',
    ['немецкий'] = 'de',
    ['польский'] = 'pl',
    ['португальский' ] = 'pt',
    ['русский'] = 'ru',
    ['турецкий'] = 'tr',
    ['украинский'] = 'uk',
    ['фарси'] = 'fa',
    ['персидский'] = 'fa',
    ['французский'] = 'fr',
    ['хинди'] = 'hi',
    ['японский'] = 'ja'
};

local action = {
    exe = function (msg, data, other, rmsg, user)
        --local fromlang = data.parameters['lang-from'] or (data.parameters and data.parameters['lang-to'] == 'русский' and 'английский' or 'русский');
        local tolang = #data.parameters['lang-to'] ~= 0 and data.parameters['lang-to'] or (data.parameters['lang-from'] and data.parameters['lang-from'] == 'английский' and 'русский' or 'английский');
        local text = data.parameters.text;

        --local from_code = ca (lang_codes[fromlang], "а что это за язык?");
        local to_code = ca (lang_codes[tolang], "а что это за язык?");

        local response = net.jSend ('https://api.multillect.com/translate/json/1.0/747?method=translate/api/translate', {
            to = to_code, text = text, sig = '833a3083305ea3ed000bf54b046f0bc8'
        });

        return "«"..response.result.translated.."» ["..response.result.language.code.."» " .. to_code .. "]";
    end
};
return action;
