/datum/job/mercenary
	title = "Mercenary"
	tutorial = "Blood stained hands, do you even see it when they line your palms with golden treasures?\
	\n\n\
	You are a paid killer, redeemable only by fact that your loyalty can be bought,  \
	gold is the great hypocritical lubricant in life, founding empires, driving brothers to kill one another. \
	\n\n\
	You care not. Another day, another mammon."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MERCENARY
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	min_pq = 5
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = null
	outfit_female = null
	give_bank_account = 3
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)
	is_foreigner = TRUE
	is_recognized = TRUE

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted  = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)


/datum/job/mercenary/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><br><font color='#855b14'><span class='bold'>The Gaffer, who feeds and houses you may have work for you todae, go see him at the office outside your lodgings.</span></font><br><br>")

/datum/job/advclass/mercenary
	abstract_type = /datum/job/advclass/mercenary
	blacklisted_species = list(SPEC_ID_HALFLING)
	category_tags = list(CTAG_MERCENARY)
	exp_types_granted  = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT)
