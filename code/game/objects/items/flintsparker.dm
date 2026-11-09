/obj/item/flint
	name = "flint"
	desc = "A jagged piece of flint, witness to the dances of fire and stone."
	icon_state = "flint"
	gripped_intents = null
	//dropshrink = 0.75
	force = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/roguetown/items/lighting.dmi'

	grid_height = 32
	grid_width = 32

	COOLDOWN_DECLARE(flintcd)

	item_weight = 50 GRAMS
	var/sound_to_play = 'sound/items/flint.ogg'
	var/self_prob = 80
	var/target_prob = 50

/obj/item/flint/attack_self(mob/living/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, flintcd))
		return NONE

	COOLDOWN_START(src, flintcd, 1 SECONDS)

	playsound(user, sound_to_play, 100, FALSE)
	flick("flintstrike", src)

	if(prob(self_prob))
		user.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user,user.dir)
		S.set_up(1, 1, front)
		S.start()

/obj/item/flint/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, flintcd))
		return NONE

	COOLDOWN_START(src, flintcd, 1 SECONDS)

	playsound(user, sound_to_play, 100, FALSE)
	flick("flintstrike", src)

	if(prob(target_prob))
		interacting_with.spark_act()
		user.flash_fullscreen("whiteflash")

	return ITEM_INTERACT_SUCCESS

/obj/item/flint/abaddon_hand
	name = "\improper sparking touch"
	desc = "Conjure forth a spark of hellfire, in Abaddons name."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#7a1e1e"
	drop_sound = null
	item_flags = NEEDS_PERMIT | ABSTRACT
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	slot_flags = NONE

	sound_to_play = 'sound/foley/finger-snap.ogg'
	self_prob = 100
	target_prob = 100

/obj/item/flint/abaddon_hand/dropped(mob/user, silent)
	. = ..()
	qdel(src)
