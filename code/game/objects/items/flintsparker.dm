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
	var/flintcd = 0

/obj/item/flint/attack_self(mob/living/user, list/modifiers)
	if(world.time < flintcd + 10)
		return
	flintcd = world.time
	playsound(user, 'sound/items/flint.ogg', 100, FALSE)
	flick("flintstrike", src)
	if(prob(80))
		user.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user,user.dir)
		S.set_up(1, 1, front)
		S.start()

/obj/item/flint/afterattack(atom/movable/A, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return
	if(world.time < flintcd + 10)
		return
	flintcd = world.time
	playsound(user, 'sound/items/flint.ogg', 100, FALSE)
	flick("flintstrike", src)
	if(prob(50))
		A.spark_act()
		user.flash_fullscreen("whiteflash")
