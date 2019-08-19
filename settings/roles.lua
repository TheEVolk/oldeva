return {
    creator = {
        screenname = 'Создатель',
        full = true,
        ["value.slotadd"] = 80,
        include = 'owner'
    },

    owner = {
        screenname = 'Президент',
        full = true,
        include = 'mainadmin'
    },

    mainadmin = {
        screenname = 'Главадмин',
        ["right.ban.admin"] = true,
		["right.setright.admin"] = true,
		include = 'admin'
    },

    admin = {
        screenname = 'Админ',
        ["value.maxbantime"] = -1,
        ["right.ban.moderator"] = true,
        ["right.setright"] = true,
        ["right.setright.moderator"] = true,
        ["right.setright.donat_moderator"] = true,
        ["right.setright.vip"] = true,
        ["right.setright."] = true,
        include = 'moderator'
    },

    donat_moderator = {
        screenname = 'Стажер ТПБ',
        ["right.ban.donat_moderator"] = false,
        ["right.can_see_closed_profile"] = false,
        include = 'moderator'
    },

    moderator = {
        screenname = 'Модер',
        ["value.bankstatus"] = 'full',
        ["right.kick"] = true,
		["right.nick.other"] = true,
		["right.otherinfo"] = true,
        ["right.can_see_closed_profile"] = true,
		["right.ban"] = true,
		["right.ban."] = true,
		["right.ban.default"] = true,
		["right.ban.vip"] = true,
		["right.ban.donat_moderator"] = true,
		["right.razban"] = true,
		["right.cbaza"] = true,
    ["value.maxgame"] = 10000000000,
		["value.maxbantime"] = 86400,
        include = 'vip'
    },

    vip = {
        screenname = "ВИП",
        ["value.bankstatus"] = 'sim',
		["right.nick"] = true,
		["right.create_clan"] = true,
		["right.p"] = true,
		["right.vipjobs"] = true,
		["right.changepath"] = true,
		["right.changepname"] = true,
		["right.smile"] = true,
		["right.bget"] = true,
		["right.vipt"] = true,
		["value.tslots"] = 15,
		["right.vipchat"] = true,
		["right.vippets"] = true,
		["value.maxlot"] = 10000000,
		["value.maxknb"] = 1000000,
		["value.maxgame"] = 1000000,
		["value.lostchance"] = 65,
		["value.slotadd"] = 20,
    ["right.profile_settings"] = true,
		include = 'default'
    },

eca = {
screenname = 'ECA',
["right.photo"] = true,
include = 'default'
},

    default = {
        screenname = 'Юзер',
        ["value.bankstatus"] = 'lim',
        ["value.maxknb"] = 10000,
        ["value.maxlot"] = 1000000,
        ["value.maxgame"] = 10000,
		["value.lostchance"] = 75,
		["value.slotadd"] = 10,
		["value.tslots"] = 5,
    },
};
