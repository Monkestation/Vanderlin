/datum/action/cooldown/spell/undirected/shapeshift/troll_form
	name = "Troll Form"
	desc = "Transform into a troll."
	button_icon_state = "trollshape"

	spell_type = SPELL_MIRACLE
	charge_required = FALSE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/dendor)

	possible_shapes = list(/mob/living/simple_animal/hostile/retaliate/troll)

	die_with_shapeshifted_form = TRUE

	invocation = "DENDOR GRANT ME THE FORM OF A MIGHTY TROLL!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 8 SECONDS
	charge_slowdown = 3
	cooldown_time = 7 MINUTES
	spell_cost = 100
	keep_name = TRUE

	sound = 'sound/vo/mobs/troll/aggro2.ogg'

	keep_skills = FALSE

/datum/action/cooldown/spell/undirected/shapeshift/troll_form/do_shapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return
	var/mob/living/new_shape = .
	new_shape.set_patron(caster.patron)
	required_items = list() // so the troll can transform back
	spell_cost = 0
	spell_type = NONE

/datum/action/cooldown/spell/undirected/shapeshift/troll_form/do_unshapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/dendor)
	spell_cost = 100
	spell_type = SPELL_MIRACLE
