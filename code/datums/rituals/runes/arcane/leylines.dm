/obj/effect/decal/cleanable/ritual_rune/arcyne/leylines
	name = "leyline attunement matrix"
	desc = "Geometric shapes and lines on the ground resonate with power..."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "empowerment"
	runesize = 1
	tier = 2
	SET_BASE_PIXEL(-32, -32)
	pixel_z = 0
	invocation = "Thal'miren vek'laris un'vethar!"
	color = "#a70808ce"
	scribe_damage = 10
	can_be_scribed = TRUE
	associated_ritual = /datum/runerituals/leyattunement

/obj/effect/decal/cleanable/ritual_rune/arcyne/leylines/invoke(list/invokers, datum/runerituals/runeritual)
	runeritual = associated_ritual
	if(!..())
		return
	var/mob/living/user = usr
	if(user.mana_pool.intrinsic_recharge_sources & MANA_SOULS)
		to_chat(user, span_warning("I cannot attune to leylines now."))
	else if(user.mana_pool.intrinsic_recharge_sources & MANA_ALL_LEYLINES)
		to_chat(user, span_warning("Already attuned to leylines!"))
	else
		user.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)
		playsound(user, 'sound/magic/blink.ogg', 80, FALSE)
		to_chat(user, span_warning("Leylines fill me with power!"))
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)

/datum/runerituals/leyattunement
	name = "leyline attunement"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 2,
		/obj/item/natural/leyline = 1
	)

/datum/runerituals/leyattunement/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE
