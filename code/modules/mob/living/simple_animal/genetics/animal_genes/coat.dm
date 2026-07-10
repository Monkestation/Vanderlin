/datum/animal_gene/coat_color
	name = "Coat Color"
	exclusion_group = GENE_GROUP_COAT_COLOR
	dominant = TRUE
	rarity = 10
	abstract_type = /datum/animal_gene/coat_color
	gene_flags = GENE_FLAG_INTRINSIC
	type_whitelist = list(
		/mob/living/simple_animal/hostile/retaliate/honse,
		/mob/living/simple_animal/hostile/retaliate/saiga,
		/mob/living/simple_animal/hostile/retaliate/saigabuck,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid,
		/mob/living/simple_animal/hostile/retaliate/saiga/saigakid/boy,
		)

/datum/animal_gene/coat_color/breed_with(datum/animal_gene/other)
	if(!other)
		return new type()
	// 50/50 which parent's coat the foal inherits
	if(prob(50))
		return new type()
	return new other.type()

/datum/animal_gene/coat_color/proc/get_color()
	return COLOR_WHITE

/datum/animal_gene/coat_color/apply_to(mob/living/simple_animal/target)
	. = ..()
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/saiga) || istype(target, /mob/living/simple_animal/hostile/retaliate/saigabuck))
		return
	target.color = get_color()

/datum/animal_gene/coat_color/remove_from(mob/living/simple_animal/target)
	. = ..()
	target.color = null

/datum/animal_gene/coat_color/white
	name = "White Coat"
/datum/animal_gene/coat_color/white/get_color()
	return COLOR_WHITE

/datum/animal_gene/coat_color/gray
	name = "Gray Coat"
/datum/animal_gene/coat_color/gray/get_color()
	return COLOR_GRAY

/datum/animal_gene/coat_color/black
	name = "Black Coat"
/datum/animal_gene/coat_color/black/get_color()
	return COLOR_ALMOST_BLACK

/datum/animal_gene/coat_color/brown
	name = "Brown Coat"
/datum/animal_gene/coat_color/brown/get_color()
	return COLOR_DARK_BROWN

/datum/animal_gene/coat_color/chestnut
	name = "Chestnut Coat"
/datum/animal_gene/coat_color/chestnut/get_color()
	return COLOR_DARK_ORANGE

/datum/animal_gene/coat_color/silver_dapple
	name = "Silver Dapple Coat"
	gene_flags = GENE_FLAG_INTRINSIC | GENE_FLAG_EMERGENCE
	required_parent_genes = list(
		/datum/animal_gene/coat_color/black,
		/datum/animal_gene/coat_color/chestnut
	)

/datum/animal_gene/coat_color/silver_dapple/get_color()
	return COLOR_SILVER
