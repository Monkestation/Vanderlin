/mob/living/carbon/monkey
	name = "monkey"
	verb_say = "chimpers"
	initial_language_holder = /datum/language_holder/monkey
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey1"
	gender = NEUTER
	pass_flags = PASSTABLE
	ventcrawler = VENTCRAWLER_NUDE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 5)
	type_of_meat = /obj/item/reagent_containers/food/snacks/meat/steak
	gib_type = /obj/effect/decal/cleanable/blood/gibs
	unique_name = TRUE
	bodyparts = list(/obj/item/bodypart/chest/monkey, /obj/item/bodypart/head/monkey, /obj/item/bodypart/l_arm/monkey,
					/obj/item/bodypart/r_arm/monkey, /obj/item/bodypart/r_leg/monkey, /obj/item/bodypart/l_leg/monkey)
	hud_type = /datum/hud/human

/mob/living/carbon/monkey/Initialize(mapload, cubespawned=FALSE, mob/spawner)
	// add_verb(src, /mob/living/proc/mob_sleep)
	add_verb(src, /mob/living/proc/lay_down)

	if(unique_name) //used to exclude pun pun
		gender = pick(MALE, FEMALE)
	real_name = name

	//initialize limbs
	create_bodyparts()
	create_internal_organs()

	. = ..()

	if (cubespawned)
		var/cap = CONFIG_GET(number/monkeycap)
		if (LAZYLEN(SSmobs.cubemonkeys) > cap)
			if (spawner)
				to_chat(spawner, "<span class='warning'>Bluespace harmonics prevent the spawning of more than [cap] monkeys on the station at one time!</span>")
			return INITIALIZE_HINT_QDEL
		SSmobs.cubemonkeys += src

	create_dna(src)
	dna.initialize_dna()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_BAREFOOT, 1, -6)

/mob/living/carbon/monkey/Destroy()
	SSmobs.cubemonkeys -= src
	return ..()

/mob/living/carbon/monkey/create_internal_organs()
	internal_organs += new /obj/item/organ/lungs
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain
	internal_organs += new /obj/item/organ/tongue
	internal_organs += new /obj/item/organ/eyes
	internal_organs += new /obj/item/organ/ears
	internal_organs += new /obj/item/organ/liver
	internal_organs += new /obj/item/organ/stomach
	..()

/mob/living/carbon/monkey/on_reagent_change()
	. = ..()
	remove_movespeed_modifier(MOVESPEED_ID_MONKEY_REAGENT_SPEEDMOD, TRUE)
	var/amount
	if(amount)
		add_movespeed_modifier(MOVESPEED_ID_MONKEY_REAGENT_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = amount)

/mob/living/carbon/monkey/updatehealth(amount)
	. = ..()
	var/slow = 0
	if(!HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		var/health_deficiency = (maxHealth - health)
		if(health_deficiency >= 45)
			slow += (health_deficiency / 25)
	add_movespeed_modifier(MOVESPEED_ID_MONKEY_HEALTH_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = slow)

/mob/living/carbon/monkey/adjust_bodytemperature(amount)
	. = ..()
	var/slow = 0
	if (bodytemperature < 283.222)
		slow += ((283.222 - bodytemperature) / 10) * 1.75
	add_movespeed_modifier(MOVESPEED_ID_MONKEY_TEMPERATURE_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = slow)

/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys can't use advanced tools
	if(mind)
		return TRUE
	return FALSE

/mob/living/carbon/monkey/can_use_guns(obj/item/G)
	if(G.trigger_guard == TRIGGER_GUARD_NONE)
		to_chat(src, "<span class='warning'>I am unable to fire this!</span>")
		return FALSE
	return TRUE

/mob/living/carbon/monkey/reagent_check(datum/reagent/R) //can metabolize all reagents
	return FALSE

/mob/living/carbon/monkey/canBeHandcuffed()
	if(num_hands < 2)
		return FALSE
	return TRUE

/mob/living/carbon/monkey/IsVocal()
	if(!getorganslot(ORGAN_SLOT_LUNGS))
		return 0
	return 1

/mob/living/carbon/monkey/angry
	aggressive = TRUE
