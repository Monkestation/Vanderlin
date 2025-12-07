/datum/job/jester
	title = "Jester"
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
		/datum/action/cooldown/spell/vicious_mockery,
	)
	give_bank_account = TRUE

/datum/outfit/jester/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/jester
	pants = /obj/item/clothing/pants/tights
	armor = /obj/item/clothing/shirt/jester
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/keyring/jester
	beltl = /obj/item/storage/belt/pouch
	head = /obj/item/clothing/head/jester
	neck = /obj/item/clothing/neck/coif
	H.adjust_skillrank(/datum/skill/combat/knives, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/craft/bombs, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, pick(1,2,3), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(4,5), TRUE) // Pirouette, but falling and hurting yourself IS pretty funny.
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(4,4,4,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, pick(1,2,3,4,5,6), TRUE)
	H.adjust_skillrank(/datum/skill/combat/firearms, pick(1,2,3,4,5,6), TRUE)

	H.base_intelligence = rand(1, 20)
	H.base_fortune = rand(1, 20)
	H.base_strength = rand(1, 20)
	H.base_constitution = rand(1, 20)
	H.base_perception = rand(1, 20)
	H.base_speed = rand(1, 20)
	H.base_endurance = rand(1, 20)

	H.recalculate_stats(FALSE)

	if(H.base_strength > 16) //all natural, baby
		H.cmode_music = 'sound/music/cmode/nobility/CombatJesterSTR.ogg'
	else
		H.cmode_music = pick('sound/music/cmode/nobility/CombatJester1.ogg', 'sound/music/cmode/nobility/CombatJester2.ogg')

	H.verbs |= /mob/living/carbon/human/proc/ventriloquate
	H.verbs |= /mob/living/carbon/human/proc/ear_trick
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SHAKY_SPEECH, TRAIT_GENERIC)

//Ventriloquism! Make things speak!

/mob/living/carbon/human/proc/ventriloquate()
	set name = "Ventriloquism"
	set category = "Japes"

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
	set category = "Japes"

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
		/obj/item/natural/dirtclod,
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
