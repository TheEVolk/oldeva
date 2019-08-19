local words = fs.read_lines 'settings/ph_words.txt';
local lines = fs.read_lines 'settings/ph_lines.txt';
for i = 1,#lines do
    lines[i] = lines[i]:split '-'
    lines[i] = { tonumber(lines[i][1]), tonumber(lines[i][2]), tonumber(lines[i][3]), tonumber(lines[i][4]) }
end

local function make_array(ok_id)
    local res = { }
    for i = 1, #words do res[i] = i == ok_id and 1 or 0 end
    return res
end

function swap(array, index1, index2)
    array[index1], array[index2] = array[index2], array[index1]
end

function shuffle(array)
    local counter = #array
    while counter > 1 do
        local index = math.random(counter)
        swap(array, index, counter)
        counter = counter - 1
    end
end

shuffle(lines)

local function ph_get_word(word_id)
    return words[word_id] or '[NOWORD]'
end

local function ph_get_id(word)
    if not word then return 1 end

    for i = 1,#words do
        if words[i] == word then return i end
    end

    return math.random(#words)
end

local function ph_get_next(old)
    for i = 1,#lines do
        local line = lines[i]
        --print(line[1] ..' == ' ..old[2].. ' and ' ..line[2] ..' == ' ..old[3] ..' and ' ..line[3] ..' == ' ..old[4])
        if line[1] == old[2] and line[2] == old[3] and line[3] == old[4] then
            return line;
        end
    end

    for i = 1,#lines do
        local line = lines[i]
        if line[2] == old[3] and line[3] == old[4] then
            return line;
        end
    end

    for i = 1,#lines do
        local line = lines[i]
        if line[3] == old[4] and line[4] ~= 1 then
            return line;
        end
    end
    --local output = line_network:forewardPropagate (old[2] / #words, old[3] / #words, old[4] / #words)
    --print("COUNT ", #output)
    --local this, this_percent = 1, 0
    --[[for i = 2,#output do
        --print("a ", output[i]);
        if output[i] > this_percent then

             this, this_percent = i, output[i] end end--]]
    --return { old[2], old[3], old[4], line--math.floor(output[1] * #words) }
    return { old[2], old[3], old[4], math.random(#words) }--math.floor(output[1] * #words) }
end

local action = {
    exe = function (msg, data, other, rmsg, user)
        --[[return net.jSend('http://botomaker.ru/api/get_answer.php', {
            MaleBot = '1',
            DisableMat = 'true',
            Message = msg.text:lower(),
            Correction = {
                NeedName = user:r(),
                Age = 16,
                City = "Улан-Удэ"
            }
        }).Message]]
        return 'хм'
    end
};
return action;
