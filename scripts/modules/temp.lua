local module = {}

local temp_paths = {}

function module.start()
    -- Clear temp directory
    local files = fs.dir_list("temp")
	for i,file in ipairs(files) do
		os.remove(root.."/temp/"..file)
	end
end

function module.get_path(format)
    local i = 0
    while true do
        local file_path = root.."/temp/"..i.."."..format
        if not temp_paths[file_path] then
            temp_paths[file_path] = true
            return file_path
        end

        i = i + 1
    end
end

function module.free_path(file_path)
    temp_paths[file_path] = nil
end

return module
