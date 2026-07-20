/datum/animal_gene
	var/name = "Unknown Gene"
	var/desc = "An unknown genetic trait."
	var/rarity = 10
	var/exclusion_group = null
	var/dominant = TRUE
	var/recessive_state = RECESSIVE_NONE
	///if set this is the odds of emergence actually working (useful for non requirement emergence parts)
	var/emergence_chance
	var/intensity = 1.0
	var/intensity_min = 10
	var/intensity_max = 10
	var/applied = FALSE
	var/gene_flags = NONE
	var/list/type_whitelist = null
	/// List of gene types, each parent must contribute at least one matching gene
	/// for this gene to be eligible during breeding. Only checked when GENE_FLAG_EMERGENCE is set.
	var/list/required_parent_genes = null

/datum/animal_gene/New()
	if(intensity_min != intensity_max)
		intensity = rand(intensity_min, intensity_max) * 0.1
	else
		intensity = intensity_min * 0.1

/datum/animal_gene/proc/allowed_for(mob/living/simple_animal/hostile/target)
	if(!type_whitelist)
		return TRUE
	return is_type_in_list(target, type_whitelist)

/datum/animal_gene/proc/apply_to(mob/living/simple_animal/hostile/target)
	SHOULD_CALL_PARENT(TRUE)
	var/old_apply = applied
	applied = TRUE
	return old_apply

/datum/animal_gene/proc/remove_from(mob/living/simple_animal/hostile/target)
	SHOULD_CALL_PARENT(TRUE)
	var/old_apply = applied
	applied = FALSE
	return old_apply

/// Produce an offspring gene from this gene and an optional matching gene from the other parent.
/// If other is null (unpaired), intensity is preserved with minor noise.
/// If paired, intensity trends toward the higher of the two, selective breeding accumulates.
/datum/animal_gene/proc/breed_with(datum/animal_gene/other)
	var/datum/animal_gene/offspring = new type()
	offspring.dominant = dominant
	if(!offspring.dominant)
		// Expression state is determined by _breed_pools based on whether both parents contributed
		// Always start as CARRIED here; _breed_pools will upgrade to EXPRESSED if warranted
		offspring.recessive_state = RECESSIVE_CARRIED
	if(!other)
		// Unpaired: pass with minor noise, floored at GENETICS_INTENSITY_FLOOR of intensity_min
		var/noise = (rand(-GENETICS_INTENSITY_NOISE, GENETICS_INTENSITY_NOISE) * 0.1) * intensity
		offspring.intensity = clamp(intensity + noise, (intensity_min * 0.1) * GENETICS_INTENSITY_FLOOR, (intensity_max * 0.1))
		return offspring
	// Paired: average biased toward the higher value (stronger gene wins more often),
	// plus noise. This means two fat parents consistently produce fatter offspring.
	var/lo = min(intensity, other.intensity)
	var/hi = max(intensity, other.intensity)
	// Bias: pick in the upper 60% of the lo-hi range, then add noise
	var/base = lo + (rand(4, 10)  * 0.1) * (hi - lo)
	var/noise = (rand(-GENETICS_INTENSITY_NOISE, GENETICS_INTENSITY_NOISE) * 0.1) * hi
	offspring.intensity = clamp(base + noise, (intensity_min * GENETICS_INTENSITY_FLOOR) * 0.1, intensity_max * 0.1)
	return offspring
