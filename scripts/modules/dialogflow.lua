local module = { users = {} }

function module.execute(msg, other, user)
	if not msg.text or #msg.text == 0 then msg.text = "привет" end
	if #msg.text > 256 then return { message = "какой большой текст 0_0" } end

	local data = net.jSend ("http://eva.elektro-volk.ru/api/getResp.php", {
		text = msg.text and #msg.text ~= 0 and msg.text or 'привет',
		user = msg.from_id
	});
	module.users[msg.from_id] = { last = data.text };
	other.sendname = true;

	local rmsg;
	if data.queryResult.fulfillmentText then
		rmsg = { message = data.queryResult.fulfillmentText };
	else
		local action = dofile(string.format("%s/scripts/actions/%s.lua", root, data.queryResult.action));

		rmsg = { line = function (self, ...) addline(self, string.format(...)) end };
		local success, result = pcall(action.exe, msg, data.queryResult, other, rmsg, user);

		if not success then if not result:starts 'err:' then error(result, 0) end
		else if result and type(result) == 'string' and result:starts 'err:' then success = false end end
		if not success then result = string.sub(result, 5); other.sendname = true end

		rmsg.line = nil;
		rmsg = result and (type(result) == "table" and result or { message = result }) or rmsg;
	end

	return rmsg;
end

return module;
