#define HEAL_BASHING_LETHAL 3
#define HEAL_AGGRAVATED 2

/datum/coven/bloodheal
	name = "Bloodheal"
	desc = "Use the power of your Vitae to slowly regenerate your flesh."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/bloodheal
	max_level = 10
	experience_multiplier = 1.25

/datum/coven_power/bloodheal
	name = "Bloodheal power name"
	desc = "Bloodheal power description"

	level = 1
	check_flags = COVEN_CHECK_TORPORED
	vitae_cost = 10
	toggled = TRUE
	cooldown_length = 30 SECONDS
	duration_length = 3 SECONDS

	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/coven_power/bloodheal/one,
		/datum/coven_power/bloodheal/two,
		/datum/coven_power/bloodheal/three,
		/datum/coven_power/bloodheal/four,
		/datum/coven_power/bloodheal/five,
		/datum/coven_power/bloodheal/six,
		/datum/coven_power/bloodheal/seven,
		/datum/coven_power/bloodheal/eight,
		/datum/coven_power/bloodheal/nine,
		/datum/coven_power/bloodheal/ten
	)

/datum/coven_power/bloodheal/activate()
	. = ..()
	if(!.)
		return

	trigger_healing()

/datum/coven_power/bloodheal/on_refresh()
	trigger_healing()

/datum/coven_power/bloodheal/proc/trigger_healing()
	// Calculate healing amounts based on level
	var/bashing_lethal_heal = HEAL_BASHING_LETHAL * level
	var/aggravated_heal = HEAL_AGGRAVATED * level

	// Heal different damage types
	owner.heal_overall_damage(bashing_lethal_heal, aggravated_heal)

	// Heal wounds (only at higher levels)
	if(length(owner.get_wounds()) && level >= 3)
		var/wounds_to_heal = min(1, length(owner.get_wounds()))
		for(var/i in 1 to wounds_to_heal)
			var/datum/wound/wound = owner.get_wounds()[i]
			wound.heal_wound(500 * level)

	// Brain damage healing (only at higher levels)
	if(level >= 4)
		var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
		if(brain)
			brain.applyOrganDamage(-HEAL_BASHING_LETHAL * (level * 0.5))

	// Eye damage healing (only at higher levels)
	if(level >= 5)
		var/obj/item/organ/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			eyes.applyOrganDamage(-HEAL_BASHING_LETHAL * (level * 0.5))
			owner.adjust_temp_blindness(-HEAL_AGGRAVATED * (level) SECONDS)
			owner.adjust_eye_blur(-HEAL_AGGRAVATED * (level) SECONDS)

	// Masquerade violation check
	if(level >= 3)
		violates_masquerade = TRUE
		if(prob(20)) // 20% chance per pulse to show visible healing
			owner.visible_message(
				span_warning("[owner]'s wounds slowly knit themselves back together!"),
				span_warning("Your flesh slowly regenerates!")
			)
			owner.vampire_undisguise()
	else
		violates_masquerade = FALSE

	owner.update_damage_overlays()
	owner.update_health_hud()


//BLOODHEAL 1
/datum/coven_power/bloodheal/one
	name = "Minor Bloodheal"
	desc = "Slowly regenerate minor wounds using your vitae."
	level = 1
	vitae_cost = 5
	duration_length = 4 SECONDS
	violates_masquerade = FALSE

//BLOODHEAL 2
/datum/coven_power/bloodheal/two
	name = "Bloodheal"
	desc = "Regenerate wounds at a steady pace."
	level = 2
	vitae_cost = 8
	duration_length = 3.5 SECONDS
	violates_masquerade = FALSE

//BLOODHEAL 3
/datum/coven_power/bloodheal/three
	name = "Quick Bloodheal"
	desc = "Regenerate wounds with visible speed."
	level = 3
	vitae_cost = 12
	duration_length = 3 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 4
/datum/coven_power/bloodheal/four
	name = "Major Bloodheal"
	desc = "Rapidly regenerate even serious injuries."
	level = 4
	vitae_cost = 15
	duration_length = 2.5 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 5
/datum/coven_power/bloodheal/five
	name = "Greater Bloodheal"
	desc = "Regenerate injuries and restore damaged organs."
	level = 5
	vitae_cost = 18
	duration_length = 2 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 6
/datum/coven_power/bloodheal/six
	name = "Grand Bloodheal"
	desc = "Rapidly restore your body to perfect condition."
	level = 6
	vitae_cost = 22
	duration_length = 1.8 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 7
/datum/coven_power/bloodheal/seven
	name = "Grand Bloodheal"
	desc = "Reconstruct your form from grievous damage."
	level = 7
	vitae_cost = 25
	duration_length = 1.5 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 8
/datum/coven_power/bloodheal/eight
	name = "Godlike Bloodheal"
	desc = "Regenerate from near-death with supernatural speed."
	level = 8
	vitae_cost = 28
	duration_length = 1.2 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 9
/datum/coven_power/bloodheal/nine
	name = "Surpassing Bloodheal"
	desc = "Restore your physical form almost instantaneously."
	level = 9
	vitae_cost = 32
	duration_length = 1 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 10
/datum/coven_power/bloodheal/ten
	name = "Ascended Bloodheal"
	desc = "Achieve near-immortality through constant regeneration."
	level = 10
	vitae_cost = 35
	duration_length = 0.8 SECONDS
	violates_masquerade = TRUE

#undef HEAL_BASHING_LETHAL
#undef HEAL_AGGRAVATED
