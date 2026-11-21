/datum/action/cooldown/spell/undirected/shapeshift/cabbit
	name = "Cabbit Form"
	desc = "Transform into a cabbit. Damage is not inherited between forms."

	charge_required = FALSE
	cooldown_time = 50 SECONDS

	invocation = "Wah!"
	invocation_type = INVOCATION_SHOUT

	possible_shapes = list(/mob/living/simple_animal/pet/cat/cabbit)
	die_with_shapeshifted_form = FALSE
	keep_name = TRUE

/datum/action/cooldown/spell/undirected/shapeshift/cabbit/can_cast_spell(feedback)
	if(HAS_TRAIT(owner, TRAIT_COVEN_BANE))
		return FALSE
	. = ..()
