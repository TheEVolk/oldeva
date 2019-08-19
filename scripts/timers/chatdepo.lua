timers.ecreate(60000, 0, function()
    db("UPDATE chats SET balance = balance * 1.0001 + RAND() WHERE isOpen = 1")
end)
