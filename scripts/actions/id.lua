return {
    exe = function (msg, data, other, rmsg, user)
        local id = #data.parameters.target > 0 and getId(data.parameters.target) or user.vkid;

        other.sendname = false;
        return "&#127380; "..id;
    end
};
