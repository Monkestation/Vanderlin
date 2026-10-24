/datum/action/cooldown/spell/forest_bind
	name = "Forest Bind"
	desc = "The woods arise to grasp the target."
	button_icon_state = "entangle"
	sound = "plantcross"
	self_cast_possible = FALSE

	cast_range = 7
	spell_type = SPELL_DIVINE_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/druidic
	required_items = list(/obj/item/clothing/neck/psycross/great_hunt)

	invocation = "Forest bind them..."
	invocation_type = INVOCATION_WHISPER

	charge_time = 2 SECONDS
	cooldown_time = 30 SECONDS
	spell_cost = 35
	/// Min strength to resist spell.
	var/strength_level_greater = 13
	var/strength_level_mid = 8

/datum/action/cooldown/spell/forest_bind/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/forest_bind/cast(mob/living/cast_on)
	. = ..()
	new /obj/effect/temp_visual/forest_bind(get_turf(cast_on))
	if(GET_MOB_ATTRIBUTE_VALUE(cast_on, STAT_STRENGTH) >= strength_level_greater)
		cast_on.OffBalance(5 SECONDS)
		to_chat(cast_on, span_userdanger("Vines arise and attempt to restrain you, but your strength resists!"))
	else if(GET_MOB_ATTRIBUTE_VALUE(cast_on, STAT_STRENGTH) >= strength_level_mid)
		cast_on.Knockdown(3 SECONDS, prevent_drop = TRUE)
		to_chat(cast_on, span_userdanger("Vines arise and pull you down!"))
		cast_on.adjustBruteLoss(15, damage_type = BCLASS_BLUNT)
	else
		cast_on.Knockdown(3 SECONDS)
		cast_on.Immobilize(3 SECONDS)
		cast_on.adjustBruteLoss(20, damage_type = BCLASS_BLUNT)
		to_chat(cast_on, span_userdanger("Vines arise and rip you to the ground, disarming you!"))

/obj/effect/temp_visual/forest_bind
	name = "forest binding"
	icon = 'icons/effects/effects.dmi'
	icon_state = "dna_swirl"
	randomdir = FALSE
	duration = 3 SECONDS
	light_power = 1
	light_outer_range = 2
	light_color = COLOR_PALE_GREEN_GRAY
