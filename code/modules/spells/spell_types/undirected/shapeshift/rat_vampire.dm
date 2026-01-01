/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire
	name = "Vampiric Rat Form"
	desc = "Transform into a small rat. Damage is not inherited between forms."

	attunements = list(
		/datum/attunement/dark = 0.4,
		/datum/attunement/polymorph = 0.5,
		/datum/attunement/aeromancy = 0.3,
	)

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	possible_shapes = list(/mob/living/simple_animal/hostile/retaliate/smallrat)
	die_with_shapeshifted_form = FALSE
	convert_damage = FALSE

/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire/can_cast_spell(feedback)
	if(HAS_TRAIT(owner, TRAIT_COVEN_BANE))
		return FALSE
	. = ..()

/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire/do_shapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return
	var/mob/living/new_shape = .
	new_shape.adjust_stat_modifier("[REF(src)]", STATKEY_SPD, 15 - new_shape.base_speed)
