local action = {
    exe = function (msg, data, other, rmsg, user)
        local ev = data.parameters.ev;

        local block = { 'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'if',
    			'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until',
    			'while', '=' };
    	for i = 1, #block do ev = ev:gsub(block[i], '') end

    	local res = load([[
    			_ENV = { abs = math.abs, acos = math.acos, asin = math.asin,
    		  atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos,
    		  cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor,
    		  fmod = math.fmod, frexp = math.frexp, huge = math.huge,
    		  ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max,
    		  min = math.min, modf = math.modf, pi = math.pi, pow = math.pow,
    		  rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh,
    		  sqrt = math.sqrt, tan = math.tan, tanh = math.tanh };
    			return ]]..ev);

    	status, err = pcall(res);
    	ca (status, "странное у вас выражение. Я не могу его посчитать.");
        ca (type(err) == "number", "мне кажется, что вы хотите не число");

        return "и так, " .. ev .. " = " .. err;
    end
};
return action;
