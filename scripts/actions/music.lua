return {
    exe = function (msg, data, other, rmsg, user)
    	local response = net.jSend('http://api.xn--41a.ws/api.php?key=e93ec31933eeffbaea550d404c03af1c&method=search&offset=5', { q = data.parameters.q });
        ca (response.totalCount > 0, "я ничего не нашла :(");

    	local data = "";
    	local items = response.list;
    	for i = 1, math.min(response.totalCount, 5) do data = data.."audio"..items[i][2].."_"..items[i][1].."," end
    	return  { attachment = data, message = "музыка для тебя &#127926;" };
    end
};
