local groups = {
        { 'Cringe', -154306815 },
        { 'МЕМЫ', -75214966 },
        { 'MEMES', -92879038 },
};

return {
    exe = function (msg, data, other, rmsg, user)
        local group = trand(groups);

        local memcount = VK.wall.get { owner_id = group[2], count = 1, access_token = evatoken }.response.count;
        local memes = VK.wall.get { owner_id = group[2], count = 1, offset = RandomOrg.GetInt(1, memcount - 1), access_token = evatoken }.response;

        rmsg.attachment = 'photo' .. group[2] .. '_' .. memes.items[1].attachments[1].photo.id;
        rmsg:line ("лови мемчик из группы [public%i|%s] &#128163;", -group[2], group[1]);
    end
};
