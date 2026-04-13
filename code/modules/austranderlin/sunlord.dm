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
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/athletics = 40,
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
	faction = FACTION_RATS
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	banned_leprosy = FALSE
	honorary = "God-Lord"
	honorary_suffix = "the Sun"

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
		EXP_TYPE_CHURCH = 600
	)

	cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sunlord

	spells = list(
		/datum/action/cooldown/spell/projectile/fireball/greater/sunlord,
		/datum/action/cooldown/spell/undirected/list_target/convert_role/sundweller,
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
		TRAIT_CRITICAL_RESISTANCE,
	)

/datum/job/sunlord/New()
	. = ..()
	peopleknowme = list()

/datum/job/sunlord/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.add_curse(/datum/curse/zizo)
	spawned.LoadComponent(/datum/component/theme_music)
	spawned.set_hygiene(HYGIENE_LEVEL_DISGUSTING)

	spawned.set_patron(/datum/patron/godless/autotheist)

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


/datum/action/cooldown/spell/undirected/list_target/convert_role/sundweller
	name = "Recruit Sundweller"
	desc = "Recruit someone to your cause."
	button_icon_state = "recruit_bog"
	new_role = "Sundweller"
	recruitment_faction = "Sundwellers"
	recruitment_message = "Serve the Sunlord, %RECRUIT!"
	accept_message = "PRAISE THE SUN!"
	refuse_message = "FUCK YOU, SUNLORD!"

/datum/action/cooldown/spell/undirected/list_target/convert_role/sundweller/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.set_patron(/datum/patron/godless/sunlord)

/datum/patron/godless/sunlord
	name = "The Sunlord"
	desc = "I don't know what an Aristrata or any of that other shit is. There's only one god and it's the SUNLORD."
	boons = "You regain stamina faster in the presence of your Sunlord."
	domain = "The Surface, the Sun, the Sunlord, whatever the Sunlord wants, the Sunlord's will, the Sunlord's well-being, the S"
	flaws = "You are a fucking knave"
	worshippers = "Knaves"
	sins = "Underdwelling, lying to the Sunlord, failing the Sunlord, being better than the Sunlord at something, doubting the Sunlo"

	confess_lines = list(
		"I SERVE THE GLORY OF THE SUN!",
		"FUCK YOU",
		"PRAISE THE SUN!",
	)

/datum/patron/godless/sunlord/preference_accessible(datum/preferences/prefs)
	return FALSE
