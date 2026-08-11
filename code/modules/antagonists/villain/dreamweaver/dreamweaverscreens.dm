
/atom/movable/screen/fullscreen/dreamweaver
	icon = 'icons/roguetown/maniac/hatman.dmi'
	icon_state = "hall0"
	alpha = 0

/atom/movable/screen/fullscreen/dreamweaver/proc/dwjumpscare(mob/living/scared, silent = FALSE, fade_in = 0.5 SECONDS, duration = 1 SECONDS, fade_out = 2 SECONDS)
	if(!silent)
		var/static/list/dreamweaverspookies = list(
			'sound/villain/hat1.ogg',
			'sound/villain/hat2.ogg',
			'sound/villain/hat3.ogg',
		)
		scared.playsound_local(scared, pick(dreamweaverspookies), vol = 50, vary = FALSE)
	icon_state = "hall[rand(1, 7)]"
	if(prob(1))
		icon_state = "oatmealjumpscare"
	if(prob(0.1))
		icon_state = "gary"
		to_chat(scared, span_warning("Noc..?"))
	animate(src, alpha = 125, time = fade_in, easing = BOUNCE_EASING | EASE_IN | EASE_OUT)
	animate(time = duration, easing = BOUNCE_EASING | EASE_IN | EASE_OUT)
	animate(alpha = 0, time = fade_out, easing = LINEAR_EASING)

//=====	Stress Event

/datum/stress_event/phantasm/on_apply(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/scared = user
		scared.add_curse(/datum/curse/dreamweaved)

/datum/stress_event/phantasm/on_remove(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/scared = user
		scared.remove_curse(/datum/curse/dreamweaved)


/proc/handle_dreamweaver_visions(mob/living/target, atom/movable/screen/fullscreen/dreamweaver/hallucinations)
	if(prob(10)) //Short-lived. Adjust here if too annoying.
		hallucinations.dwjumpscare(target)


//=====	Handling the Curse itself

/datum/curse/dreamweaved //Zizo curse. I REALLY wish and or hope that there's an option to have the curse be silent!!! AAGGGHHH!!!
	name = "Dreamweaved"
	description = "I have no head to retreat to, no castle to call my own. This is a nightmare to which I cannot wake."
	trait = TRAIT_DREAMWEAVERPHANTASM
	var/hallucination_prob = 80 // Another adjustment knob
	var/atom/movable/screen/fullscreen/dreamweaver/hallucinations

/datum/curse/dreamweaved/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(prob(hallucination_prob))
		handle_dreamweaver_visions(owner, hallucinations)

/datum/curse/dreamweaved/on_gain(mob/living/carbon/human/owner)
	. = ..()
	hallucinations = owner.overlay_fullscreen("dreamweaver", /atom/movable/screen/fullscreen/dreamweaver)

/datum/curse/dreamweaved/on_loss(mob/living/carbon/human/owner)
	. = ..()
	hallucinations = null

/datum/curse/dreamweaved/on_life(mob/living/carbon/human/owner)
	. = ..()
	if(prob(1))
		INVOKE_ASYNC(owner, GLOBAL_PROC_REF(handle_dreamweaver_visions), owner, hallucinations)

//=====	This jumbled up fuckshit is heavily tied into the Phantasm spell. Also all of this shit is literally just Maniac hallucination code
