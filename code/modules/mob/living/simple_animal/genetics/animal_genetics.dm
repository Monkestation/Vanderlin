GLOBAL_LIST_INIT(all_animal_genes_weighted, generate_animaL_genes())
/proc/generate_animaL_genes()
	. = list()
	for(var/datum/animal_gene/gene as anything in subtypesof(/datum/animal_gene))
		if(IS_ABSTRACT(gene))
			continue
		.[gene] = initial(gene.rarity)
	return .

/datum/animal_genetics
	var/datum/weakref/owner_ref = null
	var/list/datum/animal_gene/genes = list()
	var/list/guaranteed_genes = list()  // list of gene TYPES that always roll on creation, e.g. list(/datum/animal_gene/coat_color/brown)

/datum/animal_genetics/New(mob/living/simple_animal/owner)
	owner_ref = WEAKREF(owner)

/datum/animal_genetics/Destroy()
	for(var/datum/animal_gene/G in genes)
		qdel(G)
	genes = list()
	owner_ref = null
	return ..()

/datum/animal_genetics/proc/roll_guaranteed_genes()
	var/list/true_genes = list()
	for(var/datum/animal_gene/gene_type as anything in guaranteed_genes)
		if(IS_ABSTRACT(gene_type))
			var/list/picked = list()
			for(var/datum/animal_gene/gene as anything in subtypesof(gene_type))
				if((gene.gene_flags & GENE_FLAG_EXLUDE_WILD) || (gene.gene_flags & GENE_FLAG_EMERGENCE))
					continue
				picked[gene] = initial(gene.rarity)
			true_genes |= pickweight(picked)
			continue
		true_genes |= gene_type

	for(var/gene_type in true_genes)
		var/datum/animal_gene/G = new gene_type()
		if(!_insert_gene(G))
			qdel(G)
	refresh()

/datum/animal_genetics/proc/should_express(datum/animal_gene/G)
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	if(!owner || !G.allowed_for(owner))
		return FALSE
	if(G.dominant)
		return TRUE
	return G.recessive_state == RECESSIVE_EXPRESSED

/datum/animal_genetics/proc/_insert_gene(datum/animal_gene/new_gene)
	if(!((new_gene.gene_flags & GENE_FLAG_INTRINSIC) || (new_gene.gene_flags & GENE_FLAG_UNCOUNTED)))
		if(get_gene_count() >= GENETICS_MAX_GENES)
			return FALSE
	if(new_gene.exclusion_group)
		for(var/datum/animal_gene/existing in genes)
			if(existing.exclusion_group == new_gene.exclusion_group)
				genes -= existing
				qdel(existing)
				break
	genes += new_gene
	return TRUE

/datum/animal_genetics/proc/refresh()
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	if(!owner)
		return
	for(var/datum/animal_gene/G in genes)
		if(should_express(G))
			owner.remove_gene(G)
			owner.apply_gene(G)

/datum/animal_genetics/proc/add_gene(datum/animal_gene/new_gene)
	if(!_insert_gene(new_gene))
		return FALSE
	refresh()
	return TRUE

/datum/animal_genetics/proc/remove_gene(datum/animal_gene/target_gene)
	if(!(target_gene in genes))
		return FALSE
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	genes -= target_gene
	owner.remove_gene(target_gene)
	qdel(target_gene)
	refresh()
	return TRUE

/datum/animal_genetics/proc/get_natural_armor_for_type(type_str)
	var/total = 0
	for(var/datum/animal_gene/hide/H in genes)
		if(should_express(H) && (type_str in H.armor_covered))
			total += round(H.intensity)
	return total

/datum/animal_genetics/proc/get_gene_count()
	var/count = 0
	for(var/datum/animal_gene/G in genes)
		if(!((G.gene_flags & GENE_FLAG_INTRINSIC) || (G.gene_flags & GENE_FLAG_UNCOUNTED)))
			count++
	return count

/datum/animal_genetics/proc/get_gene_names()
	var/list/names = list()
	for(var/datum/animal_gene/G in genes)
		names += should_express(G) ? "[G.name] [round(((G.intensity * 10) / G.intensity_max) * 100)]%" : "[G.name] [round(((G.intensity * 10) / G.intensity_max) * 100)]% (recessive)"
	return names

/datum/animal_genetics/proc/get_gene_by_exclusion_group(group)
    for(var/datum/animal_gene/G in genes)
        if(G.exclusion_group == group)
            return G
    return null

/// Build this parent's contribution for an inheritance pass.
/// Returns an associative list of exclusion_group (or type path for ungrouped) -> gene datum.
/// Whether a gene is offered at all depends on dominant/recessive pass chances.
/// Dominant genes are more reliably passed; recessives need selection pressure from both sides.
/datum/animal_genetics/proc/_build_allele_pool()
	var/list/pool = list()
	for(var/datum/animal_gene/G in genes)
		if((G.gene_flags & GENE_FLAG_INTRINSIC))
			var/key = G.exclusion_group ? G.exclusion_group : "[G.type]"
			pool[key] = G
			continue
		var/pass_chance = G.dominant ? GENETICS_DOMINANT_PASS_CHANCE : GENETICS_RECESSIVE_PASS_CHANCE
		if(!prob(pass_chance))
			continue
		var/key = G.exclusion_group ? G.exclusion_group : "[G.type]"
		if(pool[key])
			var/datum/animal_gene/existing = pool[key]
			if(G.intensity > existing.intensity)
				pool[key] = G
		else
			pool[key] = G
	return pool

/// Merge two allele pools (mother and father) into bred offspring genes.
/// Where both parents offer the same trait, breed_with() averages intensities biased upward.
/// Where only one parent offers a trait, it passes through unpaired with minor noise.
/datum/animal_genetics/proc/_breed_pools(list/mother_pool, list/father_pool, mob/living/simple_animal/mother, mob/living/simple_animal/father)
	// Check if either parent carries an expressed dominant lineage gene
	var/lineage_weight = 0.5  // default: equal chance from either side
	var/datum/animal_gene/dominant_lineage/lineage_gene = null

	for(var/datum/animal_gene/dominant_lineage/G in genes)  // mother's genes
		if(should_express(G))
			lineage_gene = G
			break
	if(!lineage_gene && father?.genetics)
		for(var/datum/animal_gene/dominant_lineage/G in father.genetics.genes)
			if(father.genetics.should_express(G))
				lineage_gene = G
				break

	if(lineage_gene)
		// intensity 0.1–1.0 maps to a skew of 0.05–0.5 away from center
		// at max intensity: 100% from favored side (weight = 0 or 1)
		// at min intensity: 55/45 split
		var/skew = lineage_gene.intensity * 0.5
		lineage_weight = (lineage_gene.favored_side == LINEAGE_MOTHER) ? (0.5 + skew) : (0.5 - skew)

	var/list/datum/animal_gene/result = list()
	var/list/all_keys = list()
	for(var/key in mother_pool)
		all_keys |= key
	for(var/key in father_pool)
		all_keys |= key

	for(var/key in all_keys)
		var/datum/animal_gene/MG = mother_pool[key]
		var/datum/animal_gene/FG = father_pool[key]
		var/datum/animal_gene/offspring

		if(MG && FG)
			// Both parents have this trait, use lineage weight to pick whose
			// intensity anchors the breed_with call, rather than always averaging evenly
			if(prob(lineage_weight * 100))
				offspring = MG.breed_with(FG)
			else
				offspring = FG.breed_with(MG)
			if(!offspring.dominant)
				offspring.recessive_state = RECESSIVE_EXPRESSED
		else
			var/datum/animal_gene/source = MG ? MG : FG
			// If the unpaired gene is from the non-favored side, it has a chance to be dropped
			// entirely, making the favored lineage even more dominant at high intensity
			if(lineage_gene)
				var/is_mothers = MG != null
				var/favors_mother = lineage_gene.favored_side == LINEAGE_MOTHER
				var/from_favored = (is_mothers == favors_mother)
				if(!from_favored && !prob(lineage_weight * 100))
					continue  // discard this gene entirely, the favored bloodline crowds it out
			offspring = source.breed_with(null)
			if(!offspring.dominant)
				offspring.recessive_state = RECESSIVE_CARRIED
		result += offspring
	return result

/datum/animal_genetics/proc/_check_emergence_requirements(datum/animal_gene/candidate, list/mother_pool, list/father_pool)
	if(!candidate.required_parent_genes || !length(candidate.required_parent_genes))
		return TRUE
	// Check mother's pool for at least one match
	var/mother_match = FALSE
	for(var/key in mother_pool)
		var/datum/animal_gene/G = mother_pool[key]
		if(is_type_in_list(G, candidate.required_parent_genes))
			mother_match = TRUE
			break
	if(!mother_match)
		return FALSE
	// Check father's pool for at least one match
	var/father_match = FALSE
	for(var/key in father_pool)
		var/datum/animal_gene/G = father_pool[key]
		if(is_type_in_list(G, candidate.required_parent_genes))
			father_match = TRUE
			break
	return father_match

/datum/animal_genetics/proc/inherit_to(mob/living/simple_animal/baby, mob/living/simple_animal/father)
	if(!istype(baby.genetics))
		baby.genetics = new /datum/animal_genetics(baby)
	var/list/mother_pool = _build_allele_pool()
	var/list/father_pool = istype(father?.genetics) ? father.genetics._build_allele_pool() : list()
	var/list/datum/animal_gene/candidates = _breed_pools(mother_pool, father_pool)
	// Shuffle so no ordering bias when inserting up to the gene cap
	candidates = shuffle(candidates)
	for(var/datum/animal_gene/G in candidates)
		if(!baby.genetics._insert_gene(G))
			qdel(G)
	// Mutation pass on remaining open slots for a chance at +1
	var/open_slots = GENETICS_MAX_GENES - baby.genetics.get_gene_count()
	if(open_slots)
		if(prob(GENETICS_MUTATION_CHANCE))
			var/datum/animal_gene/mutant = genetics_roll_mutation(baby, FALSE, mother_pool, father_pool)
			if(mutant && !baby.genetics._insert_gene(mutant))
				qdel(mutant)

	var/list/emergence_candidates = list()
	for(var/gene_type in GLOB.all_animal_genes_weighted)
		var/datum/animal_gene/tmp = new gene_type()
		if(!(tmp.gene_flags & GENE_FLAG_EMERGENCE))
			qdel(tmp)
			continue
		if(!tmp.allowed_for(baby))
			qdel(tmp)
			continue
		if(_check_emergence_requirements(tmp, mother_pool, father_pool))
			emergence_candidates[gene_type] = GLOB.all_animal_genes_weighted[gene_type]
		qdel(tmp)

	if(length(emergence_candidates) && prob(GENETICS_EMERGENCE_CHANCE))
		var/datum/animal_gene/path = pickweight(emergence_candidates)
		var/datum/animal_gene/emergent = new path()
		if(!baby.genetics._insert_gene(emergent))
			qdel(emergent)

	baby.genetics.refresh()
	var/list/expressed = list()
	for(var/datum/animal_gene/G in baby.genetics.genes)
		if(baby.genetics.should_express(G))
			expressed += G.name
	if(length(expressed))
		baby.visible_message(span_notice("[baby] is born showing distinct traits: [english_list(expressed)]."))

/datum/animal_genetics/proc/copy_to(mob/living/simple_animal/target)
	if(!target.genetics)
		target.genetics = new /datum/animal_genetics(target)
	else
		for(var/datum/animal_gene/G in target.genetics.genes)
			G.remove_from(target)
			qdel(G)
		target.genetics.genes = list()

	for(var/datum/animal_gene/G in genes)
		var/datum/animal_gene/copy = new G.type()
		copy.dominant = G.dominant
		copy.intensity = G.intensity
		copy.recessive_state = G.recessive_state
		copy.gene_flags = G.gene_flags
		if(!target.genetics._insert_gene(copy))
			qdel(copy)
	target.genetics.refresh()

/proc/genetics_roll_mutation(mob/living/simple_animal/hostile/target, wild = FALSE, list/mother_pool = null, list/father_pool = null)
	var/list/valid = list()
	for(var/gene_type in GLOB.all_animal_genes_weighted)
		var/datum/animal_gene/tmp = new gene_type()
		if(wild && (tmp.gene_flags & GENE_FLAG_EXLUDE_WILD))
			qdel(tmp)
			continue
		// Emergence-flagged genes are never rolled in the wild
		if(wild && (tmp.gene_flags & GENE_FLAG_EMERGENCE))
			qdel(tmp)
			continue
		// If emergence is required during breeding, check parent pools
		if((tmp.gene_flags & GENE_FLAG_EMERGENCE) && (mother_pool || father_pool))
			if(!_check_emergence_requirements(tmp, mother_pool || list(), father_pool || list()))
				qdel(tmp)
				continue
			if(tmp.emergence_chance && !prob(tmp.emergence_chance))
				qdel(tmp)
				continue
		if(tmp.allowed_for(target))
			valid[gene_type] = GLOB.all_animal_genes_weighted[gene_type]
		qdel(tmp)
	if(!length(valid))
		return null
	var/datum/animal_gene/new_gene = pickweight(valid)
	return new new_gene()

/proc/_check_emergence_requirements(datum/animal_gene/candidate, list/mother_pool, list/father_pool)
	if(!candidate.required_parent_genes || !length(candidate.required_parent_genes))
		return TRUE

	var/list/remaining = candidate.required_parent_genes.Copy()

	for(var/key in mother_pool)
		var/datum/animal_gene/G = mother_pool[key]
		for(var/req_type in remaining)
			if(istype(G, req_type))
				remaining -= req_type
				break

	for(var/key in father_pool)
		var/datum/animal_gene/G = father_pool[key]
		for(var/req_type in remaining)
			if(istype(G, req_type))
				remaining -= req_type
				break

	return !length(remaining)

/mob/living/simple_animal/proc/roll_initial_genetics(max_genes = 2, intensity_bound_cap = 0.4, recessive_bias = 30)
	if(!genetics || ispath(genetics))
		genetics = new /datum/animal_genetics(src)

	var/attempts = 0
	while(genetics.get_gene_count() < max_genes && attempts < max_genes * 4)
		attempts++

		var/datum/animal_gene/G = genetics_roll_mutation(src, TRUE)
		if(!G)
			continue

		G.intensity = rand(G.intensity_min, round(G.intensity_max * intensity_bound_cap, 1)) * 0.1

		if(prob(recessive_bias))
			G.dominant = FALSE

		if(!G.dominant)
			G.recessive_state = RECESSIVE_CARRIED

		if(!genetics._insert_gene(G))
			qdel(G)

	genetics.refresh()

/mob/living/simple_animal/proc/debug_apply_max_genetics()
	if(!genetics || ispath(genetics))
		genetics = new /datum/animal_genetics(src)

	var/datum/animal_gene/swift/swift = new()
	swift.intensity = initial(swift.intensity_max) * 0.1
	if(!genetics._insert_gene(swift))
		qdel(swift)

	var/datum/animal_gene/lean/lean = new()
	lean.intensity = initial(lean.intensity_max) * 0.1
	if(!genetics._insert_gene(lean))
		qdel(lean)

	var/datum/animal_gene/hardy/hardy = new()
	hardy.dominant = TRUE
	hardy.intensity = initial(hardy.intensity_max) * 0.1

	if(!genetics._insert_gene(hardy))
		qdel(hardy)

	var/datum/animal_gene/hide/ironhide/ironhide = new()
	ironhide.dominant = TRUE
	ironhide.intensity = initial(ironhide.intensity_max) * 0.1
	if(!genetics._insert_gene(ironhide))
		qdel(ironhide)

	genetics.refresh()

/mob/living/simple_animal/proc/debug_breed_with(mob/living/simple_animal/father)
    var/mob/living/simple_animal/baby = new type(loc)
    baby.name = "Debug [name]"
    if(genetics)
        genetics.inherit_to(baby, father)
    return baby
