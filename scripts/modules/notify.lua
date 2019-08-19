local module = { }

function module.start()
    db.oop.ls = module.ls
end

function module.ls(user, text, ...)
  local uid = tonumber(user) and user or user.vkid;
  VK.messages.send { message = string.format(text, ...), user_id = uid };
end

function module.log(tid, text, ...)
  VK.board.createComment { message = string.format(text, ...), group_id = loggroup, topic_id = tid, access_token = evatoken }
end

return module
