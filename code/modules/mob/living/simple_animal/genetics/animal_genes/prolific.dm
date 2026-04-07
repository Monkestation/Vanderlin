/datum/animal_gene/prolific
	name = "Prolific"
	desc = "Grants a chance to birth multiple offspring in a single litter."
	rarity = 4
	exclusion_group = GENE_GROUP_PROGENY
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/prolific/apply_to(mob/living/simple_animal/target)
	. = ..()
	if(.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	// Override the birth callback to inject our multi-birth logic
	var/datum/callback/old_override = breed_component.override_baby
	breed_component.override_baby = CALLBACK(src, PROC_REF(prolific_birth), target, breed_component, old_override)

/datum/animal_gene/prolific/remove_from(mob/living/simple_animal/target)
	. = ..()
	if(!.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	// Clear our override; if there was a prior override we stored it, but restoring
	// arbitrary callback chains cleanly is complex,  nulling is safest here.
	// If your codebase commonly stacks overrides, consider a callback list instead.
	breed_component.override_baby = null

/// Handles the actual multi-birth. Spawns between 1 and max_litter babies,
/// weighted toward smaller litters, then fires post_birth for each.
/datum/animal_gene/prolific/proc/prolific_birth(mob/living/simple_animal/mother, datum/component/breed/breed_comp, datum/callback/old_override)
	// At intensity 1.0 (max): ~60% chance of extra kids, up to 4 total
	// At intensity 0.1 (min): ~6% chance of even one extra, max 2 total
	var/extra_chance = intensity * 60        // 6%–60%
	var/max_litter = max(1, round(intensity * 4))  // 1–4 extras on top of the base baby

	var/extras = 0
	for(var/i in 1 to max_litter)
		if(prob(extra_chance))
			extras++
		else
			break

	var/total = 1 + extras
	var/turf/loc = get_turf(mother)

	if(old_override)
		// Respect any existing override for the base baby
		old_override.Invoke()
	else
		// Spawn the base baby normally
		var/picked = pickweight(breed_comp.baby_path)
		var/mob/living/base_baby = new picked(loc)
		SEND_SIGNAL(mother, COMSIG_FRIENDSHIP_PASS_FRIENDSHIP, base_baby)
		SEND_SIGNAL(mother, COMSIG_HAPPINESS_PASS_HAPPINESS, base_baby)
		breed_comp.post_birth?.Invoke(base_baby, null)

	// Spawn any extras
	for(var/i in 1 to extras)
		var/picked = pickweight(breed_comp.baby_path)
		var/mob/living/extra_baby = new picked(loc)
		SEND_SIGNAL(mother, COMSIG_FRIENDSHIP_PASS_FRIENDSHIP, extra_baby)
		SEND_SIGNAL(mother, COMSIG_HAPPINESS_PASS_HAPPINESS, extra_baby)
		breed_comp.post_birth?.Invoke(extra_baby, null)

	if(total > 1)
		mother.visible_message(span_notice("[mother] gives birth to a litter of [total]!"))
