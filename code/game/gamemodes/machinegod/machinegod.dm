
/*/proc/isclockcult(mob/living/M as mob)  NOT IMPLEMENTED YET -velardamakar
	return istype(M) && M.mind && ticker && ticker.mode && (M.mind in ticker.mode.machinegod)*/

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
	var/const/min_cultists_to_start = 2
	var/const/max_cultists_to_start = 4
	var/enlightened_survived = 0

	var/const/conversion_percent = 45