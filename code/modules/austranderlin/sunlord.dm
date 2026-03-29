/obj/effect/landmark/start/sunlord
	name = "Sunlord"
	icon_state = "arrow"


/datum/attribute_holder/sheet/job/sunlord
	raw_attribute_list = list(
		STAT_FORTUNE = 5, //You live a blessed existence
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/job/sunlord
	title = "Sunlord"
	tutorial = "The morning sun shines upon you as you wake, \
	glorious subjects await your orders, those blessed to live with you in the basking sunlight. \
	The cave-dwellers from below envy your paradise, drool over the thoughts of using your precious sunlight for their own means. \
	Rule with pride and power, you are not someone to be trifled with."
	department_flag = OUTSIDERS
	display_order = JDO_SUNLORD
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_SHOW_IN_CREDITS | JOB_SHOW_IN_ACTOR_LIST)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	banned_leprosy = FALSE
	honorary = "God-Lord"
	honorary_suffix = "The Everbright"

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/sunlord
	can_random = FALSE
	can_have_apprentices = TRUE
	apprentice_name = "Sunpeasant"

	exp_type = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_LEADERSHIP = 600,
		EXP_TYPE_LEADERSHIP = 600
	)

	cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sunlord

	spells = list(
		/datum/action/cooldown/spell/projectile/fireball/greater/sunlord,
		/datum/action/cooldown/spell/undirected/list_target/convert_role,
		/datum/action/cooldown/spell/undirected/fart
		)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_STINKY,
		TRAIT_DUALWIELDER,
		TRAIT_LEECHIMMUNE,
		TRAIT_NASTY_EATER,
		TRAIT_NOSEGRAB,
		TRAIT_ZJUMP,
		TRAIT_NOMOOD,
		TRAIT_CRITICAL_RESISTANCE
	)

/datum/job/sunlord/New()
	. = ..()
	peopleknowme = list()

/datum/job/sunlord/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.LoadComponent(/datum/component/theme_music)
	spawned.set_hygiene(HYGIENE_LEVEL_DISGUSTING)

	if(!(spawned.patron == /datum/patron/godless/autotheist))
		spawned.set_patron(/datum/patron/godless/autotheist, TRUE)

	spawned.set_hair_style(/datum/sprite_accessory/hair/head/nimrod, TRUE)
	add_verb(spawned, /mob/living/carbon/human/proc/sunlordannouncement)

/datum/outfit/sunlord
	name = "Sunlord"
	cloak = /obj/item/clothing/cloak/heartfelt/shit
	ring = /obj/item/clothing/ring/dragon_ring
	neck = /obj/item/clothing/neck/amberamulet
	head = /obj/item/clothing/head/priesthat/sunlord
	armor = /obj/item/clothing/armor/regenerating/skin/disciple/sunlord
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/weapon/sword/stone
	beltr = /obj/item/weapon/sword/stone

/mob/living/carbon/human/proc/sunlordannouncement()
	set name = "Sunlord Announcement"
	set category = "RoleUnique.Sunlord"
	if(stat)
		return

	var/static/last_announcement_time = 0

	if(world.time < last_announcement_time + 30 SECONDS)
		var/time_left = round((last_announcement_time + 30 SECONDS - world.time) / 10)
		to_chat(src, span_warning("You must wait [time_left] more seconds before making another announcement."))
		return

	var/inputty = input("Make an announcement", "VANDERLIN") as text|null
	if(inputty)
		if(!is_type_in_list(get_area(src), list(/area/outdoors/exposed/under/basement, /area/outdoors/exposed/under/sewer)))
			to_chat(src, span_warning("I must speak DOWN upon them."))
			return FALSE
		priority_announce("[inputty]", title = "[src.real_name], The Sunlord Speaks", sound = 'sound/misc/foghorn.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Sunlord announcement")

		last_announcement_time = world.time


/datum/action/cooldown/spell/projectile/fireball/greater/sunlord
	name = "Sunlord's Fireball"
	desc = "Shoot out an immense ball of fire that explodes on impact."
	invocation = "LIGHTNING BOLT!!!"
	spell_cost = 0

	associated_skill = null
