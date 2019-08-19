local action = {
    exe = function (msg, data, other, rmsg, user)
        local count = VK.wall.get { owner_id = -129212910, count = 1, access_token = evatoken }.response.count;
        local posts = VK.wall.get { owner_id = -129212910, count = 1, offset = RandomOrg.GetInt(1, count - 1), access_token = evatoken }.response;


        rmsg.attachment = "wall-129212910_"..posts.items[1].id;
        rmsg:line "лови хардкор &#128128;";
    end
};
return action;
