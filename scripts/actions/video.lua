local action = {
    exe = function (msg, data, other, rmsg, user)
        local response = VK.video.search { q = data.parameters.q, count = 10, access_token = evatoken }.response;
		local count = response.count;

        ca (count > 0, "я не нашла видео по твоему запросу :(");

		local data = "";
		for i = 1, math.min(count, 10) do
			local item = response.items[i];
			if item then data = data.."video"..item.owner_id.."_"..item.id.."," end
		end

		return { message = "лови видео для тебя! &#127909;", attachment = data, forward_messages = msg.id };
    end
};
return action;
