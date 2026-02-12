//the way this file is organized is also cursed! Enjoy
/datum/curse
	var/name = "Debug Curse"
	/// Whats shown to the player upon being cursed
	var/description = "This is a debug curse."
	/// Trait given by this curse
	var/trait

/datum/curse/proc/on_life()
	return
/datum/curse/proc/on_death()
	return

/datum/curse/proc/on_gain(mob/living/carbon/human/owner, silent = FALSE)
	ADD_TRAIT(owner, trait, TRAIT_CURSE)
	if(!silent)
		to_chat(owner, span_userdanger("Something is wrong... I feel cursed."))
		to_chat(owner, span_danger(description))
	owner.playsound_local(get_turf(owner), 'sound/misc/cursed.ogg', 80, FALSE, pressure_affected = FALSE)
	return

/datum/curse/proc/on_loss(mob/living/carbon/human/owner)
	REMOVE_TRAIT(owner, trait, TRAIT_CURSE)
	to_chat(owner, span_userdanger("Something has changed... I feel relieved."))
	owner.playsound_local(get_turf(owner), 'sound/misc/curse_lifted.ogg', 80, FALSE, pressure_affected = FALSE)
	qdel(src)
	return

/mob/living/carbon/human/proc/handle_curses()
	for(var/datum/curse/C as anything in curses)
		C.on_life(src)

/mob/living/carbon/human/proc/add_curse(datum/curse/C, silent = FALSE)
	if(is_cursed(C))
		return FALSE
	C = new C()
	curses += C
	C.on_gain(src, silent)
	return TRUE

/mob/living/carbon/human/proc/remove_curse(datum/curse/C)
	if(!is_cursed(C))
		return FALSE

	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			curse.on_loss(src)
			curses -= curse
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_cursed(datum/curse/C)
	if(!C)
		return FALSE
	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			return TRUE

	return FALSE

//////////////////////
/// SPECIAL CURSES ///
//////////////////////
/datum/curse/atheism
	name = "Curse of Atheism"
	description = "I cannot stand any mention of the divine, and I refuse to believe either the gods or miracles are real."
	trait = TRAIT_ATHEISM_CURSE
	var/datum/patron/old_patron

//////////////////////
///   TEN CURSES   ///
//////////////////////
/datum/curse/astrata
	name = "Astrata's Curse"
	description = "I am forsaken by the Sun. Healing miracles have no effect on me."
	trait = TRAIT_ASTRATA_CURSE

/datum/curse/noc
	name = "Noc's Curse"
	description = "Magical knowledge is now beyond my grasp."
	trait = TRAIT_NOC_CURSE

/datum/curse/ravox
	name = "Ravox's Curse"
	description = "Violence disgusts me. I struggle to bring myself to wield any kind of weapon."
	trait = TRAIT_RAVOX_CURSE

/datum/curse/necra
	name = "Necra's Curse"
	description = "Necra has claimed my soul. No one will bring me back from the dead."
	trait = TRAIT_NECRA_CURSE

/datum/curse/xylix
	name = "Xylix's Curse"
	description = "Fortune is no longer on my side."
	trait = TRAIT_XYLIX_CURSE

/datum/curse/pestra
	name = "Pestra's Curse"
	description = "I feel sick to my stomach, and my skin is slowly starting to rot."
	trait = TRAIT_PESTRA_CURSE

/datum/curse/eora
	name = "Eora's Curse"
	description = "I am unable to show any kind of affection or love, whether intimate or platonic."
	trait = TRAIT_EORA_CURSE

//////////////////////
/// INHUMEN CURSES ///
//////////////////////
/datum/curse/zizo
	name = "Zizo's Curse"
	description = "I can no longer distinguish reality from delusion."
	trait = TRAIT_ZIZO_CURSE
	/// Chance to call hallucination handle procs on life
	var/hallucination_prob = 100
	var/atom/movable/screen/fullscreen/maniac/hallucinations

/datum/curse/zizo/minor
	name = "Zizo's Minor Curse"
	description = "I struggle to distinguish reality from delusion."
	hallucination_prob = 10

/datum/curse/schizophrenic //zizo curse but without the jumpscares and meta hallucinations
	name = "Schizophrenic"
	description = "I can see and hear things others cannot."
	trait = TRAIT_SCHIZO_FLAW

/datum/curse/graggar
	name = "Graggar's Curse"
	description = "I am engulfed by unspeakable rage. I cannot stop myself from harming others. When that's not an option, my rage is directed inward."
	trait = TRAIT_GRAGGAR_CURSE

/datum/curse/matthios
	name = "Matthios' Curse"
	description = "I hate the sight of wealth, and I struggle to do anything with mammons."
	trait = TRAIT_MATTHIOS_CURSE

/datum/curse/baotha
	name = "Baotha's Curse"
	description = "I'm in a constant state of ecstasy."
	trait = TRAIT_BAOTHA_CURSE

//////////////////////
/// ON GAIN / LOSS ///
//////////////////////
/datum/curse/atheism/on_gain(mob/living/carbon/human/owner)
	. = ..()
	old_patron = owner.patron
	owner.set_patron(/datum/patron/godless/godless)
	owner.gain_trauma(/datum/brain_trauma/mild/phobia/religion)

/datum/curse/atheism/on_loss(mob/living/carbon/human/owner)
	. = ..()
	owner.set_patron(old_patron)
	owner.cure_trauma_type(/datum/brain_trauma/mild/phobia/religion)

/datum/curse/zizo/on_gain(mob/living/carbon/human/owner)
	. = ..()
	hallucinations = owner.overlay_fullscreen("maniac", /atom/movable/screen/fullscreen/maniac)

/datum/curse/zizo/on_loss(mob/living/carbon/human/owner)
	. = ..()
	hallucinations = null

/datum/curse/xylix/on_gain(mob/living/carbon/human/owner)
	. = ..()
	owner.STALUC -= 10

/datum/curse/xylix/on_loss(mob/living/carbon/human/owner)
	. = ..()
	owner.STALUC += 10

//////////////////////
///    ON LIFE     ///
//////////////////////
/datum/curse/pestra/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(!MOBTIMER_FINISHED(owner, MT_CURSE_PESTRA, rand(120, 480) SECONDS)) //this isn't how mob timers work
		return

	MOBTIMER_SET(owner, MT_CURSE_PESTRA)

	var/effect = rand(1, 4)
	switch(effect)
		if(1)
			owner.vomit()
		if(2)
			owner.Unconscious(20)
		if(3)
			owner.set_eye_blur_if_lower(20 SECONDS)
		if(4)
			var/obj/item/bodypart/BP = pick(owner.bodyparts)
			BP.rotted = TRUE
			owner.playsound_local(get_turf(owner), 'sound/foley/butcher.ogg', 80, FALSE, pressure_affected = FALSE)
			owner.regenerate_icons()

/datum/curse/baotha/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(!MOBTIMER_FINISHED(owner, MT_CURSE_BAOTHA, rand(60, 420) SECONDS)) //this isn't how mob timers work
		return

	MOBTIMER_SET(owner, MT_CURSE_BAOTHA)

	owner.reagents.add_reagent(/datum/reagent/druqks, 3)

/datum/curse/graggar/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(!MOBTIMER_FINISHED(owner, MT_CURSE_GRAGGAR, rand(180, 480) SECONDS)) //this isn't how mob timers work
		return

	MOBTIMER_SET(owner, MT_CURSE_GRAGGAR)
	for(var/mob/living/carbon/human in view(1, owner))
		owner.emote("rage")
		human.attacked_by(owner.get_active_held_item(), owner)
		owner.cursed_freak_out()
		break

// Currently calls maniac hallucinations
/datum/curse/zizo/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(prob(hallucination_prob))
		handle_maniac_visions(owner, hallucinations)
		handle_maniac_hallucinations(owner)
		//handle_maniac_floors(owner)
		handle_maniac_walls(owner)

/datum/curse/schizophrenic/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(prob(0.5))
		INVOKE_ASYNC(owner, GLOBAL_PROC_REF(handle_maniac_mob_hallucination), owner)
	else if(prob(2))
		INVOKE_ASYNC(owner, GLOBAL_PROC_REF(handle_maniac_object_hallucination), owner)

// cursed_freak_out() is freak_out() without stress adjustments
// bandaid deserves a second look
/mob/living/proc/cursed_freak_out()
	return

/mob/proc/do_cursed_freakout_scream()
	emote("scream", forced=TRUE)

/mob/living/carbon/cursed_freak_out()
	if(!MOBTIMER_FINISHED(src, MT_FREAKOUT, 10 SECONDS))
		flash_fullscreen("stressflash")
		return

	MOBTIMER_SET(src, MT_FREAKOUT)
	shake_camera(src, 1, 3)
	flash_fullscreen("stressflash")
	changeNext_move(CLICK_CD_EXHAUSTED)
	emote("fatigue", forced = TRUE)
	if(get_stress_amount() > 15)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, do_freakout_scream)), rand(30,50))
	if(hud_used)
		var/matrix/skew = matrix()
		skew.Scale(2)
		var/matrix/newmatrix = skew
		for(var/C in hud_used.plane_masters)
			var/atom/movable/screen/plane_master/whole_screen = hud_used.plane_masters[C]
			if(whole_screen.plane == HUD_PLANE)
				continue
			animate(whole_screen, transform = newmatrix, time = 1, easing = QUAD_EASING)
			animate(transform = -newmatrix, time = 30, easing = QUAD_EASING)
