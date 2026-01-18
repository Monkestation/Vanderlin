/datum/action/cooldown/meatvine/personal/deafening_screech
	name = "Deafening Screech"
	desc = "Emit a horrifying screech that incapacitates those who can hear it."
	button_icon_state = "screech"
	cooldown_time = 5 MINUTES
	personal_resource_cost = 50
	/// Range of the screech
	var/screech_range = 7

/datum/action/cooldown/meatvine/personal/deafening_screech/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	playsound(consumed, 'sound/misc/terror.ogg', 100, FALSE, 8, 0.9)
	shake_camera(owner, 2, 2)

	for(var/mob/living/carbon/human/screech_target in get_hearers_in_view(screech_range, get_turf(consumed)))
		screech_target.soundbang_act(intensity = 5, stun_pwr = 50, damage_pwr = 10, deafen_pwr = 30)
		shake_camera(screech_target, 4, 3)
		to_chat(screech_target, span_userdanger("[consumed] lets out a deafening screech!"))

	return TRUE

/datum/action/cooldown/meatvine/personal/deafening_screech/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/nearby_enemies = 0

	for(var/mob/living/carbon/human/potential_target in get_hearers_in_view(screech_range, get_turf(consumed)))
		nearby_enemies++

	// Only use if multiple enemies nearby and it's been a while
	if(nearby_enemies >= 3)
		return 40

	return 0

/datum/action/cooldown/meatvine/personal/deafening_screech/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)
