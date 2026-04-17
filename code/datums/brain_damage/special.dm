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

/datum/brain_trauma/special/existential_crisis
	name = "Existential Crisis"
	desc = "Patient's hold on reality becomes faint, causing occasional bouts of non-existence."
	gain_text = span_warning("You feel less real.")
	lose_text = span_notice("You feel more substantial again.")
	var/obj/effect/abstract/sync_holder/veil/veil
	/// A cooldown to prevent constantly erratic dolphining through the fabric of reality
	COOLDOWN_DECLARE(crisis_cooldown)

/datum/brain_trauma/special/existential_crisis/on_life(seconds_per_tick)
	. = ..()
	if(veil || !COOLDOWN_FINISHED(src, crisis_cooldown))
		return

	if(!isturf(owner.loc))
		return

	if(prob(3))
		fade_out()

/datum/brain_trauma/special/existential_crisis/proc/fade_out()
	if(veil)
		return

	var/duration = rand(5 SECONDS, 45 SECONDS)

	veil = new(get_turf(owner))

	to_chat(owner, span_warning("[pick(list(
			"Do you even exist?",
			"To be or not to be...",
			"Why exist?",
			"You simply fade away.",
			"You stop keeping it real.",
			"You stop thinking for a moment. Therefore you are not.",
		))]"))

	owner.forceMove(veil)
	COOLDOWN_START(src, crisis_cooldown, duration + 30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(fade_in)), duration)

/datum/brain_trauma/special/existential_crisis/proc/fade_in()
	QDEL_NULL(veil)
	to_chat(owner, span_notice("You fade back into reality."))
	COOLDOWN_START(src, crisis_cooldown, 4 MINUTES)


/obj/effect/abstract/sync_holder
	name = "desyncronized pocket"
	desc = "A pocket in spacetime, keeping the user a fraction of a second in the future."
	icon = null
	icon_state = null
	alpha = 0
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/effect/abstract/sync_holder/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SECLUDED_LOCATION, INNATE_TRAIT)

/obj/effect/abstract/sync_holder/relaymove(mob/living/user, direction)
	// While faded out of spacetime, no, you cannot move.
	return

/obj/effect/abstract/sync_holder/Destroy()
	for(var/atom/movable/AM as anything in contents)
		AM.forceMove(drop_location())
	return ..()

/obj/effect/abstract/sync_holder/AllowDrop()
	return TRUE //no dropping spaghetti out of your spacetime pocket

/obj/effect/abstract/sync_holder/veil
	name = "non-existence"
	desc = "Existence is just a state of mind."
