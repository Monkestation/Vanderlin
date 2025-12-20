/datum/coven/demonic
	name = "Demonic"
	desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/coven_power/demonic

/datum/coven_power/demonic
	name = "Daimonion power name"
	desc = "Daimonion power description"


//SENSE THE SIN
/datum/coven_power/demonic/sense_the_sin
	name = "Sense the Sin"
	desc = "Become supernaturally resistant to fire."

	level = 1

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 10 SECONDS

/datum/coven_power/demonic/sense_the_sin/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, VAMPIRE_TRAIT)
	owner.color = "#884200"

/datum/coven_power/demonic/sense_the_sin/deactivate()
	. = ..()
	owner.color = initial(owner.color)
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, VAMPIRE_TRAIT)

//FEAR OF THE VOID BELOW
/mob/living/carbon/human/proc/give_demon_flight()
	var/obj/item/organ/wings/old_wings = getorganslot(ORGAN_SLOT_WINGS)
	if(old_wings)
		return

	var/obj/item/organ/wings/flight/night_kin/demon_wings = new(get_turf(src))
	demon_wings.Insert(src)
	update_body()
	update_body_parts(TRUE)

/mob/living/carbon/human/proc/remove_demon_flight()
	var/obj/item/organ/wings/flight/night_kin/old_wings = getorganslot(ORGAN_SLOT_WINGS)
	if(!istype(old_wings))
		return
	old_wings.Remove(src)
	qdel(old_wings)
	update_body()
	update_body_parts(TRUE)

/datum/coven_power/demonic/fear_of_the_void_below
	name = "Fear of the Void Below"
	desc = "Sprout wings and become able to fly."

	level = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 20 SECONDS

/datum/coven_power/demonic/fear_of_the_void_below/activate()
	. = ..()
	owner.give_demon_flight()

/datum/coven_power/demonic/fear_of_the_void_below/deactivate()
	. = ..()
	owner.remove_demon_flight()

//CONFLAGRATION
/datum/coven_power/demonic/conflagration
	name = "Conflagration"
	desc = "Turn your hands into deadly claws."

	level = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 10 SECONDS

/datum/coven_power/demonic/conflagration/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/weapon/arms/gangrel(owner))
	owner.put_in_l_hand(new /obj/item/weapon/arms/gangrel(owner))

/datum/coven_power/demonic/conflagration/deactivate()
	. = ..()
	for(var/obj/item/weapon/arms/gangrel/claws in owner)
		qdel(claws)

/datum/coven_power/demonic/conflagration/post_gain()
	. = ..()
	owner.add_spell(/datum/action/cooldown/spell/projectile/fireball/baali, source = src)

//PSYCHOMACHIA
/datum/coven_power/demonic/psychomachia
	name = "Psychomachia"
	desc = "Bring forth the target's greatest fear."

	level = 4
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

	violates_masquerade = TRUE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 100

	cooldown_length = 60 SECONDS

/datum/coven_power/demonic/psychomachia/activate(mob/living/target)
	. = ..()
	to_chat(target, span_boldwarning("You hear an infernal laugh!"))
	handle_maniac_hallucinations(target)
	handle_maniac_walls(target)
	return TRUE

//CONDEMNTATION
/datum/coven_power/demonic/condemnation
	name = "Condemnation"
	desc = "Condemn a soul and their bloodline to suffering."
	level = 5
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 250
	cooldown_length = 120 SECONDS
	violates_masquerade = TRUE
	var/initialized_curses = FALSE
	var/list/curse_names = list()
	var/list/curses = list()

/datum/coven_power/demonic/condemnation/activate(mob/living/target)
	. = ..()
	if(!initialized_curses)
		for(var/i in subtypesof(/datum/family_curse/demonic))
			var/datum/family_curse/demonic/demonic_curse = new i
			curses += demonic_curse
			curse_names += initial(demonic_curse.name)
		initialized_curses = TRUE

	to_chat(owner, span_userdanger("The greatest of curses come with the greatest of costs. Are you willing to condemn an entire bloodline?"))
	var/chosencurse = browser_input_list(owner, "Pick a curse to bestow upon their family:", "Demonic Condemnation", curse_names)
	if(!chosencurse)
		return

	for(var/datum/family_curse/demonic/C in curses)
		if(C.name == chosencurse)
			// Get or create heritage for the target
			var/datum/heritage/target_heritage = get_or_create_heritage(target)
			if(!target_heritage)
				to_chat(owner, span_warning("Something prevents you from cursing their bloodline!"))
				return

			// Apply the family curse
			target_heritage.AddFamilyCurse(C.type, C.severity, owner)

			// Reduce caster's blood pool based on curse severity
			var/blood_cost = C.severity * 50 // Scale cost with severity
			owner.maxbloodpool -= blood_cost
			if(owner.bloodpool > owner.maxbloodpool)
				owner.set_bloodpool(owner.maxbloodpool)

			to_chat(owner, span_userdanger("You have condemned [target]'s entire bloodline with [C.name]!"))
			to_chat(target, span_userdanger("A terrible curse settles upon your family line! You feel the weight of [C.name]!"))

			return TRUE

/datum/coven_power/demonic/condemnation/proc/get_or_create_heritage(mob/living/carbon/human/target)
	if(!istype(target))
		return null

	// Check if target already has a heritage
	if(target.family_datum)
		return target.family_datum

	// Create new heritage if none exists
	var/datum/heritage/new_heritage = new /datum/heritage(target, "Cursed Bloodline")
	target.family_datum = new_heritage
	return new_heritage
