/datum/action/cooldown/spell/undirected/shapeshift/fox
	name = "Venard Form"
	desc = "Transform into a venard. Damage is not inherited between forms."

	charge_required = FALSE
	cooldown_time = 50 SECONDS

	possible_shapes = list(/mob/living/simple_animal/hostile/retaliate/fox)
	die_with_shapeshifted_form = FALSE

/datum/action/cooldown/spell/undirected/shapeshift/fox/can_cast_spell(feedback)
	if(HAS_TRAIT(owner, TRAIT_COVEN_BANE))
		return FALSE
	. = ..()
