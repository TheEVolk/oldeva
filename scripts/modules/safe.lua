local module = {}
module.blacklist = {
	'pornhub', 'накрутк', 'vk', 'com', 'ru', 'net', 'bot', 'porn', 'бот', '&', 'su', 'jp', 'us', 'de', 'co', 
};

function module.clear(text)
	for i = 1, #module.blacklist do text = text:gsub(module.blacklist[i], string.rep ('*', string.len(module.blacklist[i]))) end
	return text;
end

return module