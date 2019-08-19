local module = {}

function module.check_install()
    check_module 'db'
    db.check_column('jobs', db.acctable, 'job', 'INT NOT NULL')
end

function module.start()
    module.jobs = db.select("*", "jobs")

    function db.oop:getJob () return module.jobs[self.job] end
    function db.oop:getJobName () local job = self:getJob(); return job and job.name or 'безработный' end

    hooks.add_action("bot_post", function(msg, other, user, rmsg)
        if user.job == 0 then return end

    	if db.select_one('last', 'paydays', "`vkid` = %i AND `last` + 86400 > %i", user.vkid, os.time()) then return end
    	local job = db.select_one("*", "jobs", "id=%i", user.job)

    	db("DELETE FROM `paydays` WHERE `vkid` = %i", user.vkid)
    	db("INSERT INTO `paydays`(`last`, `vkid`) VALUES (%i, %i)", os.time(), user.vkid)
    	user:addMoneys(jobs.get_real_payday(job))
    	addline(rmsg, "💰 Вы получили зарплату! Приходите за следующей через 24 часа!")
    end)
end

function module.get_real_payday(job)
	local employers_count = db.get_count(db.acctable, 'job != 0 AND level <= %i', job.minlevel)
	local job_employers_count = db.get_count(db.acctable, 'job=%i', job.id)
    if job_employers_count == 0 then return job.payday end
	return math.floor(math.min(employers_count / #module.jobs / job_employers_count, 2) * job.payday)

    --return job.payday
end

return module
