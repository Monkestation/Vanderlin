/datum/job/mercenary
	title = JOB_MERCENARY
	tutorial = "Blood stained hands, do you even see it when they line your palms with golden treasures?\
	\n\n\
	You are a paid killer, redeemable only by fact that your loyalty can be bought,  \
	gold is the great hypocritical lubricant in life, founding empires, driving brothers to kill one another. \
	\n\n\
	You care not. Another day, another mammon."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MERCENARY
	factions = list(FACTION_TOWN)
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = null
	outfit_female = null
	give_bank_account = 3
	knows_the_town = TRUE
	known_by_the_town = TRUE
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)

/datum/job/mercenary/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(SSmapping.config?.map_name != "Voyage")
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/job/mercenary, set_availability), spawned), 0)
		if(player_client?.prefs)
			var/datum/preferences/prefs = player_client.prefs
			spawned.mercdesc = prefs.read_preference(/datum/preference/list_type/role_setting/mercenary_description)
			return

/datum/job/mercenary/proc/set_availability(mob/living/carbon/human/spawned)
	if(!spawned || QDELETED(spawned) || !spawned.client)
		return
	if(tgui_alert(spawned, "Do you want to join the available mercenaries list for the mercenary statue?", "MERCENARY", DEFAULT_INPUT_CHOICES, 30 SECONDS) == CHOICE_YES)
		GLOB.available_mercenaries += spawned
		to_chat(spawned, "<span class='notice'>You have been added to the available mercenaries list.</span>")
		var/obj/item/mercenary_ring/mercring = new /obj/item/mercenary_ring(spawned.loc)
		spawned.put_in_hands(mercring)
		mercring.add_mercenary(spawned)
		if(spawned.mercdesc && (spawned.mercdesc != ""))
			return
		spawned.mercdesc = stripped_input(spawned, "Write a description which will be shown to potential employers.", "Description", "", 300)

/datum/job/advclass/mercenary
	department_flag = OUTSIDERS
	abstract_type = /datum/job/advclass/mercenary
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_DWARF_SUBTERRAN)
	category_tags = list(CTAG_MERCENARY)
	exp_types_granted = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT)
	factions = list(FACTION_TOWN)
