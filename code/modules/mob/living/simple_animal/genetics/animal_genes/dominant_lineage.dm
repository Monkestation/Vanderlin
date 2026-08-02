/datum/animal_gene/dominant_lineage
	name = "Dominant Lineage"
	desc = "A powerful hereditary force that pulls offspring traits strongly toward one bloodline."
	rarity = 3  // quite rare, strong selective effect
	exclusion_group = GENE_GROUP_PROGENY
	intensity_min = 1
	intensity_max = 10
	/// which parent this gene favors, set at creation, persists through inheritance
	var/favored_side = LINEAGE_MOTHER

/datum/animal_gene/dominant_lineage/New()
	..()
	favored_side = pick(LINEAGE_MOTHER, LINEAGE_FATHER)

/datum/animal_gene/dominant_lineage/breed_with(datum/animal_gene/other)
	. = ..()
	// Preserve the favored side through inheritance rather than re-rolling it
	var/datum/animal_gene/dominant_lineage/offspring = .
	offspring.favored_side = favored_side
	return offspring
