/obj/item/gem_device
	name = "rontz"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "Its facets shine so brightly..."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	var/usage_prompt
	resistance_flags = FIRE_PROOF

/obj/item/gem_device/attack_self(mob/living/user, list/modifiers)
	var/alert = alert(user, "Do I want to use this? \n[usage_prompt]", "Enchanted Gem", "Yes", "No")
	if(alert != "Yes")
		return
	if(!on_use(user))
		to_chat(user, span_warning("\The [src] glows, then fizzles out!"))
		return
	to_chat(user, span_warning("With a bright spark \the [src] disappears!"))
	qdel(src)

/obj/item/gem_device/proc/on_use(mob/living/user)
	return FALSE

/obj/item/gem_device/goldface
	name = "gemerald"
	icon_state = "emerald_cut"
	desc = "Glints with verdant brilliance."
	usage_prompt = "Summon GOLDFACE"

/obj/item/gem_device/goldface/on_use(mob/living/user)
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	do_sparks(3, TRUE, step_turf)
	new /obj/structure/fake_machine/merchantvend(step_turf)
	to_chat(user, span_notice("With a bright flash, a GOLDFACE appears in front of you!"))
	return TRUE
