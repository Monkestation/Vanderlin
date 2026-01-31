/datum/action/cooldown/meatvine/personal/healing_aura
	name = "Regenerative Aura"
	desc = "Emit regenerative pheromones that heal nearby putrid entities."
	button_icon_state = "healaura"
	cooldown_time = 90 SECONDS
	personal_resource_cost = 30
	/// Is the aura currently active
	var/aura_active = FALSE
	/// How long the aura lasts
	var/aura_duration = 30 SECONDS
	/// Aura range
	var/aura_range = 5
	/// Healing per tick
	var/aura_healing_amount = 5
	/// Healing color
	var/aura_healing_color = COLOR_GREEN
	/// The aura component
	var/datum/component/aura_healing/aura_healing_component

/datum/action/cooldown/meatvine/personal/healing_aura/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(aura_active)
		owner.balloon_alert(owner, "already healing")
		return FALSE

	owner.balloon_alert(owner, "healing aura started")
	to_chat(owner, span_notice("You emit regenerative pheromones, encouraging rapid healing in nearby putrid flesh."))
	addtimer(CALLBACK(src, PROC_REF(aura_deactivate)), aura_duration)
	aura_active = TRUE
	aura_healing_component = owner.AddComponent(/datum/component/aura_healing, range = aura_range, requires_visibility = TRUE, brute_heal = aura_healing_amount, burn_heal = aura_healing_amount, limit_to_trait = TRAIT_PUTRID, healing_color = aura_healing_color)

	return TRUE

/datum/action/cooldown/meatvine/personal/healing_aura/proc/aura_deactivate()
	if(!aura_active)
		return
	aura_active = FALSE
	QDEL_NULL(aura_healing_component)
	owner.balloon_alert(owner, "healing aura ended")

/datum/action/cooldown/meatvine/personal/healing_aura/evaluate_ai_score(datum/ai_controller/controller)
	if(aura_active)
		return 0

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/injured_allies = 0
	var/total_missing_health = 0

	for(var/mob/living/ally in range(aura_range, consumed))
		if(!istype(ally, /mob/living/simple_animal/hostile/retaliate/meatvine))
			continue
		if(ally.health < ally.maxHealth)
			injured_allies++
			total_missing_health += (ally.maxHealth - ally.health)

	// Higher score if multiple injured allies
	if(injured_allies >= 2 && total_missing_health > 50)
		return 35

	return 0

/datum/action/cooldown/meatvine/personal/healing_aura/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)
