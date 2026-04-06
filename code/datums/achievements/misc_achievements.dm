/datum/award/achievement/misc
	category = "Misc"

/datum/award/achievement/misc/meteor_examine
	name = "Your Life Before Your Eyes"
	desc = ""
	database_id= MEDAL_METEOR

/datum/award/achievement/misc/pulse
	name = "Jackpot"
	desc = ""
	database_id= MEDAL_PULSE

/datum/award/achievement/misc/time_waste
	name = "Time waster"
	desc = ""
	database_id= MEDAL_TIMEWASTE

/datum/award/achievement/misc/feat_of_strength
	name = "Feat of Strength"
	desc = ""
	database_id= MEDAL_RODSUPLEX

/datum/award/achievement/misc/round_and_full
	name = "Round and Full"
	desc = ""
	database_id= MEDAL_CLOWNCARKING

/datum/award/achievement/misc/the_best_driver
	name = "The Best Driver"
	desc = ""
	database_id= MEDAL_THANKSALOT

/datum/award/achievement/misc/helbitaljanken
	name = "Helbitaljanken"
	desc = ""
	database_id= MEDAL_HELBITALJANKEN

/datum/award/achievement/misc/getting_an_upgrade
	name = "Getting an upgrade"
	desc = ""
	database_id= MEDAL_MATERIALCRAFT

/datum/award/achievement/misc/borbop_made_an_oopsie
	name = "Borbop Broke Something!"
	desc = "You were in a round where Borbop tm'd something that broke"
	icon = "oopsie"
	database_id = "oopsie_borbop"
	award_flags = AWARD_FLAG_REWARD
	triumph_reward = 10

/client/proc/borbop_oopsie()
	set category = "Debug.Core"
	set name = "The Borbop Fuck Up Award"
	set desc = "Gives connected people an award."

	if(key != "Dwasint")
		return //lol lmao even

	for(var/client/C in GLOB.clients)
		C.give_award(/datum/award/achievement/misc/borbop_made_an_oopsie, C.mob)
