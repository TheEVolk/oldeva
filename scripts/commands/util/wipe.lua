local command = botcmd.new("вайп", "ура-а-а-а!!", {dev=1, right='wipe'})

function command.exe(msg, args, other, rmsg, user)
db("TRUNCATE `unlocked_achivs`; TRUNCATE `bank_contributions`; INSERT INTO `bank_contributions` (`owner`, `count`) VALUES (1, 10000);")
db("TRUNCATE `bankhistory`; TRUNCATE `chats`; TRUNCATE `clans`; TRUNCATE `cases`; TRUNCATE `clanwars`; TRUNCATE `custom_prices`;")
db("TRUNCATE `daily_bonus`; TRUNCATE `daily_case`; TRUNCATE `houses`; TRUNCATE `p_pets`; TRUNCATE `paydays`; TRUNCATE `tr_obj`; TRUNCATE `tr_transportations`;")
db("UPDATE `accounts` SET `nickname`=`first_name`, `balance`=0, `ban`=0, `smile`='🙂', `job`=0, `clan`=0, `score`=0, `level`=1, `married`=0, `notifications`=0, `force`=0;")
db("UPDATE `keyvalue` SET `value`=1000000 WHERE `key`='bank'; UPDATE `keyvalue` SET `value`=0 WHERE `key`='lastdonater'; UPDATE `keyvalue` SET `value`=0 WHERE `key`='lastcase';")
db("DELETE FROM `accounts` WHERE role='';")
return("Вайп был успешно проведён! Обнулены ВСЕ данные, кроме ролей пользователей.\n😉 Check this out!")
end

return command
