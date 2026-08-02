/datum/action/cooldown/spell/undirected/shapeshift/frog
	name = "Frog Form"
	desc = "Transform into a frog. Damage is not inherited between forms."

	attunements = list(
		/datum/attunement/dark = 0.4,
		/datum/attunement/polymorph = 0.5,
		/datum/attunement/aeromancy = 0.3,
	)

	charge_required = FALSE
	cooldown_time = 50 SECONDS

	possible_shapes = list(/mob/living/simple_animal/hostile/retaliate/frog)
	die_with_shapeshifted_form = FALSE
	convert_damage = FALSE

/datum/action/cooldown/spell/undirected/shapeshift/frog/can_cast_spell(feedback)
	if(HAS_TRAIT(owner, TRAIT_COVEN_BANE))
		return FALSE
	. = ..()

/datum/action/cooldown/spell/undirected/shapeshift/frog/do_shapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return
	var/mob/living/new_shape = .
	new_shape.adjust_stat_modifier("[REF(src)]", list(STAT_SPEED = -5))
