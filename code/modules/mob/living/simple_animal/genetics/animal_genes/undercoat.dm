/datum/animal_gene/undercoat
	name = "Undercoat"
	exclusion_group = GENE_GROUP_UNDERCOAT
	dominant = TRUE
	rarity = 10
	abstract_type = /datum/animal_gene/undercoat
	gene_flags = GENE_FLAG_INTRINSIC
	type_whitelist = list(
		/mob/living/simple_animal/hostile/retaliate/saiga,
		/mob/living/simple_animal/hostile/retaliate/saigabuck,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid/boy,
	)

/datum/animal_gene/undercoat/breed_with(datum/animal_gene/other)
	if(!other)
		return new type()
	if(prob(50))
		return new type()
	return new other.type()

/datum/animal_gene/undercoat/proc/get_color()
	return COLOR_WHITE

/datum/animal_gene/undercoat/white
	name = "White Undercoat"
/datum/animal_gene/undercoat/white/get_color()
	return COLOR_WHITE

/datum/animal_gene/undercoat/gray
	name = "Gray Undercoat"
/datum/animal_gene/undercoat/gray/get_color()
	return COLOR_GRAY

/datum/animal_gene/undercoat/black
	name = "Black Undercoat"
/datum/animal_gene/undercoat/black/get_color()
	return COLOR_ALMOST_BLACK

/datum/animal_gene/undercoat/brown
	name = "Brown Undercoat"
/datum/animal_gene/undercoat/brown/get_color()
	return COLOR_DARK_BROWN

/datum/animal_gene/undercoat/chestnut
	name = "Chestnut Undercoat"
/datum/animal_gene/undercoat/chestnut/get_color()
	return COLOR_DARK_ORANGE

/datum/animal_gene/undercoat/silver_dapple
	name = "Silver Dapple Undercoat"
	gene_flags = GENE_FLAG_INTRINSIC | GENE_FLAG_EMERGENCE
	required_parent_genes = list(
		/datum/animal_gene/undercoat/black,
		/datum/animal_gene/undercoat/chestnut
	)

/datum/animal_gene/undercoat/silver_dapple/get_color()
	return COLOR_SILVER
