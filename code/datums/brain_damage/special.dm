//Brain traumas that are rare and/or somewhat beneficial;
//they are the easiest to cure, which means that if you want
//to keep them, you can't cure your other traumas
/datum/brain_trauma/special

/datum/brain_trauma/special/tenacity
	name = "Tenacity"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='warning'>I suddenly stop feeling pain.</span>"
	lose_text = "<span class='warning'>I realize you can feel pain again.</span>"

/datum/brain_trauma/special/tenacity/on_gain()
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAUMA_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/tenacity/on_lose()
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAUMA_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/death_whispers
	name = "Functional Cerebral Necrosis"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='warning'>I feel dead inside.</span>"
	lose_text = "<span class='notice'>I feel alive again.</span>"
	var/active = FALSE

/datum/brain_trauma/special/death_whispers/on_life()
	..()
	if(!active && prob(2))
		whispering()

/datum/brain_trauma/special/death_whispers/on_lose()
	if(active)
		cease_whispering()
	..()

/datum/brain_trauma/special/death_whispers/proc/whispering()
	ADD_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(cease_whispering)), rand(50, 300))

/datum/brain_trauma/special/death_whispers/proc/cease_whispering()
	REMOVE_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = FALSE

// /datum/brain_trauma/special/existential_crisis
// 	name = "Existential Crisis"
// 	desc = ""
// 	scan_desc = ""
// 	gain_text = "<span class='notice'>I feel less real.</span>"
// 	lose_text = "<span class='warning'>I feel more substantial again.</span>"
// 	var/obj/effect/abstract/sync_holder/veil/veil
// 	var/next_crisis = 0

// /datum/brain_trauma/special/existential_crisis/on_life()
// 	..()
// 	if(!veil && world.time > next_crisis && prob(3))
// 		if(isturf(owner.loc))
// 			fade_out()

// /datum/brain_trauma/special/existential_crisis/on_lose()
// 	if(veil)
// 		fade_in()
// 	..()

// /datum/brain_trauma/special/existential_crisis/proc/fade_out()
// 	if(veil)
// 		return
// 	var/duration = rand(50, 450)
// 	veil = new(owner.drop_location())
// 	to_chat(owner, "<span class='warning'>[pick("You stop thinking for a moment. Therefore you are not.",\
// 												"To be or not to be...",\
// 												"Why exist?",\
// 												"You stop keeping it real.",\
// 												"Your grip on existence slips.",\
// 												"Do you even exist?",\
// 												"You simply fade away.")]</span>")
// 	owner.forceMove(veil)
// 	SEND_SIGNAL(owner, COMSIG_MOVABLE_SECLUDED_LOCATION)
// 	for(var/atom/movable/AM as anything in owner)
// 		SEND_SIGNAL(AM, COMSIG_MOVABLE_SECLUDED_LOCATION)
// 	next_crisis = world.time + 600
// 	addtimer(CALLBACK(src, PROC_REF(fade_in)), duration)

// /datum/brain_trauma/special/existential_crisis/proc/fade_in()
// 	QDEL_NULL(veil)
// 	to_chat(owner, "<span class='notice'>I fade back into reality.</span>")
// 	next_crisis = world.time + 600

// //base sync holder is in desynchronizer.dm
// /obj/effect/abstract/sync_holder/veil
// 	name = "non-existence"
// 	desc = ""
