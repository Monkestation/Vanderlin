/datum/attribute_holder/sheet/job/jester
	attribute_variance = list(
		STAT_SPEED = list(-9, 10),
		STAT_CONSTITUTION = list(-9, 10),
		STAT_ENDURANCE = list(-9, 10),
		STAT_PERCEPTION = list(-9, 10),
		STAT_INTELLIGENCE = list(-9, 10),
		STAT_STRENGTH = list(-9, 10),
		STAT_FORTUNE = list(-9, 10),
		/datum/attribute/skill/combat/knives = list(-20, 50),
		/datum/attribute/skill/combat/unarmed = list(-20, 50),
		/datum/attribute/skill/misc/riding = list(-20, 50),
		/datum/attribute/skill/labor/fishing = list(-20, 50),
		/datum/attribute/skill/combat/wrestling = list(-20, 20),
		/datum/attribute/skill/misc/reading = list(-20, 50),
		/datum/attribute/skill/misc/sneaking = list(-20, 50),
		/datum/attribute/skill/misc/stealing = list(-20, 50),
		/datum/attribute/skill/misc/lockpicking = list(-20, 50),
		/datum/attribute/skill/misc/music = list(-20, 50),
		/datum/attribute/skill/craft/cooking = list(-20, 50),
		/datum/attribute/skill/combat/firearms = list(-20, 50),
		/datum/attribute/skill/craft/bombs = list(-20, 50),
		/datum/attribute/skill/misc/climbing = list(-10, 10),
		/datum/attribute/skill/misc/athletics = list(-20, 10),
	)

	raw_attribute_list = list(
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,

	)

/datum/job/jester
	title = JOB_JESTER
	tutorial = "The Grenzelhofts were known for their Jesters, wisemen with a tongue just as sharp as their wit. \
	You command a position of a fool, envious of the position your superiors have upon you. \
	Your cheap tricks and illusions of intelligence will only work for so long, \
	and someday you'll find yourself at the end of something sharper than you."
	department_flag = PEASANTS
	display_order = JDO_JESTER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/jester
	spells = list(
		/datum/action/cooldown/spell/undirected/joke,
		/datum/action/cooldown/spell/undirected/tragedy,
		/datum/action/cooldown/spell/undirected/fart,
		/datum/action/cooldown/spell/vicious_mockery
	)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/jester

	traits = list(
		TRAIT_EMPATH,
		TRAIT_NUTCRACKER,
		TRAIT_ZJUMP,
		TRAIT_SHAKY_SPEECH
	)
	verbs = list(
		/mob/living/carbon/human/proc/ventriloquate,
		/mob/living/carbon/human/proc/ear_trick,
	)


/datum/job/jester/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(GET_MOB_ATTRIBUTE_VALUE_RAW(spawned, STAT_STRENGTH) > 16)
		spawned.cmode_music = 'sound/music/cmode/nobility/CombatJesterSTR.ogg'
	else
		spawned.cmode_music = pick('sound/music/cmode/nobility/CombatJester1.ogg', 'sound/music/cmode/nobility/CombatJester2.ogg')

/datum/outfit/jester
	name = JOB_JESTER
	shoes = /obj/item/clothing/shoes/jester
	pants = /obj/item/clothing/pants/tights
	armor = /obj/item/clothing/shirt/jester
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/keyring/jester
	beltl = /obj/item/storage/belt/pouch
	head = /obj/item/clothing/head/jester
	neck = /obj/item/clothing/neck/coif

//Ventriloquism! Make things speak!

/mob/living/carbon/human/proc/ventriloquate()
	set name = "Ventriloquism"
	set category = "RoleUnique.Jester"

	var/obj/item/grabbing/I = get_active_held_item()
	if(!I)
		to_chat(src, "<span class='warning'>I need to be holding or grabbing something!</span>")
		return
	var/message = input(usr, "What do you want to ventriloquate?", "Ventriloquism!") as text | null
	if(!message)
		return
	I.say(message)
	log_admin("[key_name(usr)] ventriloquated [I] at [AREACOORD(I)] to say \"[message]\"")

// Ear Trick! Pull objects from behind someone's ear by the will of Xylix!

/mob/living/carbon/human/proc/ear_trick()
	set name = "Ear Trick"
	set category = "RoleUnique.Jester"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/japery_obj
	japery_obj = get_japery()
	var/obj/item/J = new japery_obj(get_turf(H))


	if(!istype(I) || !ishuman(I.grabbed))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, "<span class='warning'>I know what's behind my own ears!</span>")
		return
	if(!MOBTIMER_FINISHED(src, MT_LASTTRICK, 20 SECONDS))
		to_chat(src, "<span class='warning'>I need a moment before I can do another trick!</span>")
		return
	qdel(I)
	src.put_in_hands(J)
	src.visible_message("<span class='notice'>[src] reaches behind [H]'s ear with a grin, shaking their closed hand for a moment before revealing [J] held in it!</span>")
	MOBTIMER_SET(src, MT_LASTTRICK)

/mob/living/carbon/human/proc/get_japery()
	var/japery_list = list(
		/obj/item/coin/copper,
		/obj/item/natural/clod/dirt,
		/obj/item/natural/worms,
		/obj/item/natural/worms/leech,
		/obj/item/natural/thorn,
		/obj/item/natural/stone,
		/obj/item/natural/poo,
		/obj/item/natural/feather,
		/obj/item/reagent_containers/food/snacks/hardtack
		)

	var/japery = pick(japery_list)
	return japery
