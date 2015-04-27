
/datum/game_mode
	var/list/datum/mind/clockcult = list()

/*/proc/iscultist(mob/living/M as mob)
	if(!M) return 0
	if(!ticker) return 0
	if(M.mind in ticker.mode.cult) return 1
	if(M.mind in ticker.mode.clockcult) return 2
	else return 0*///Found in cult.dm, displayed here for reference

/datum/game_mode/machinegod
	name = "machinegod"
	config_tag = "machinegod"
	restricted_jobs = list("Chaplain","AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Internal Affairs Agent", "Mobile MMI")
	protected_jobs = list()
	required_players = 15
	required_players_secret = 20
	required_enemies = 3
	recommended_enemies = 4

	uplink_welcome = "Ratvar Uplink Console:"
	uplink_uses = 10

	var/datum/mind/harvest_target = null
	var/finished = 0
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	var/list/objectives = list()

	var/arkconstruct = 1 //for the summon god objective

	var/const/enlightened_needed = 5 //for the survive objective
	var/const/min_cultists_to_start = 3
	var/const/max_cultists_to_start = 4
	var/enlightened_survived = 0

	var/const/conversion_percent = 45

/datum/game_mode/machinegod/announce()
	world << "<B>The current game mode is - Machinegod!</B>"
	world << "<B>Some crewmembers are attempting to start a cult!<BR>\nCultists - complete your objectives. Convert crewmembers to your cause by using Geis or a submission sigil. Remember - there is no you, there is only the cult.<BR>\nPersonnel - Do not let the cult succeed in its mission. Brainwashing them with the chaplain's bible reverts them to whatever CentCom-allowed faith they had.</B>"

/datum/game_mode/machinegod/pre_setup()
	if(istype(ticker.mode, /datum/game_mode/mixed))
		mixed = 1

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/cultists_possible = get_players_for_role(ROLE_CLOCKCULT)
	for(var/datum/mind/player in cultists_possible)
		for(var/job in restricted_jobs)//Removing heads and such from the list
			if(player.assigned_role == job)
				cultists_possible -= player

	for(var/cultists_number = 1 to max_cultists_to_start)
		if(!cultists_possible.len)
			break
		var/datum/mind/cultist = pick(cultists_possible)
		cultists_possible -= cultist
		clockcult += cultist

	return (clockcult.len > 0)