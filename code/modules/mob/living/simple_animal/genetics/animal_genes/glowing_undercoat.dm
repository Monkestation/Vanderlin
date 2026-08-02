/datum/animal_gene/glowing_undercoat
	name = "Glowing Undercoat"
	exclusion_group = GENE_GROUP_EMISSIVE
	dominant = TRUE
	emergence_chance = 5
	rarity = 1
	gene_flags = GENE_FLAG_INTRINSIC | GENE_FLAG_EMERGENCE
	type_whitelist = list(
		/mob/living/simple_animal/hostile/retaliate/saiga,
		/mob/living/simple_animal/hostile/retaliate/saigabuck,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid/boy,
	)
