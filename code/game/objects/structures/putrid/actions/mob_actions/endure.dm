/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die
	name = "Endure"
	desc = "Imbue your body with unimaginable amounts of rage (and plasma) to allow yourself to ignore all pain for a short time."
	button_icon_state = "literally_too_angry"
	personal_resource_cost = 100
	var/endure_active = FALSE
	/// How long the endure ability should last when activated
	var/endure_duration = 20 SECONDS

/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die/Activate(atom/target)
	. = ..()
	if(endure_active)
		owner.balloon_alert(owner, "already enduring")
		return FALSE
	owner.balloon_alert(owner, "endure began")
	playsound(owner, 'sound/alien/alien_roar1.ogg', 100, TRUE, 8, 0.9)
	to_chat(owner, span_danger("We numb our ability to feel pain, allowing us to fight until the very last for the next [endure_duration/10] seconds."))
	addtimer(CALLBACK(src, PROC_REF(endure_deactivate)), endure_duration)
	owner.add_filter("ravager", 4, outline_filter(1, COLOR_RED_LIGHT))
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, "endure")
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, "endure")
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, "endure")
	var/mob/living/mob = owner
	mob.health *= 10
	mob.maxHealth *= 10
	endure_active = TRUE
	return TRUE

/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die/proc/endure_deactivate()
	endure_active = FALSE
	owner.balloon_alert(owner, "endure ended")
	owner.remove_filter("ravager")
	var/mob/living/mob = owner
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, "endure")
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, "endure")
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, "endure")
	mob.health *= 0.1
	mob.maxHealth *= 0.1


/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	if(endure_active)
		return 0

	// Use when critically wounded and in combat
	var/health_percent = mob.health / mob.maxHealth
	var/has_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] ? TRUE : FALSE

	if(health_percent <= 0.3 && has_target)
		return 95 // Very high priority when dying in combat

	// Also use when papameat is critical and we need to reach it
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		if(health_percent <= 0.5)
			return 90

	return 0

/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)
