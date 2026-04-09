/obj/item/natural/clay
	name = "clay"
	icon_state = "stone1"
	main_material = /datum/material/clay

/obj/item/natural/clay/Initialize(mapload)
	main_material = pick(typesof(/datum/material/clay))
	. = ..()

/obj/item/natural/clay/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay lump"

/obj/structure/pottery_lathe
	name = "potter's lathe"
	icon = 'icons/obj/pottery_wheel.dmi'
	icon_state = "wheel"

	density = TRUE
	anchored = TRUE

	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP | CONN_DIR_LEFT | CONN_DIR_RIGHT

	var/obj/item/natural/clay/stored_clay
	var/datum/pottery_recipe/in_progress

	var/static/list/recipes = list()
	var/true_rotations = 1

/obj/structure/pottery_lathe/examine(mob/user)
	. = ..()
	. += span_info("The speed of [src] is set to [true_rotations] RPM.")

/obj/structure/pottery_lathe/update_overlays()
	. = ..()
	if(!stored_clay)
		return
	var/mutable_appearance/MA = mutable_appearance(icon, "wheel-clay")
	MA.color = initial(stored_clay.main_material.color)
	. += MA

/obj/structure/pottery_lathe/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(!stored_clay)
		if(istype(I, /obj/item/natural/clay))
			if(!choose_recipe(user))
				return
			stored_clay = I
			I.forceMove(src)
			start_spinning_pottery(user)
			return

	if(!in_progress?.next_step(I))
		return
	I.forceMove(src)
	start_spinning_pottery(user)

/obj/structure/pottery_lathe/attack_hand(mob/user)
	. = ..()
	start_spinning_pottery(user)

/obj/structure/pottery_lathe/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	var/choice = input(user, "Set the speed of the lathe.", src) as null|num
	if(!choice)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	true_rotations = min(abs(choice), max(1, rotations_per_minute))
	to_chat(user, span_info("You set the speed of [src] to [true_rotations] RPM."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/pottery_lathe/proc/start_spinning_pottery(mob/user)
	update_appearance(UPDATE_OVERLAYS)
	if(!stored_clay)
		return

	visible_message("[user] starts shaping some clay.", "You start shaping some clay.")
	if(!do_after(user, in_progress.get_delay(user, true_rotations), src))
		return

	if(in_progress.update_step(user, true_rotations))
		finish_item(user)

/obj/structure/pottery_lathe/proc/finish_item(mob/user)
	var/obj/obj = new in_progress.created_item (get_turf(src))
	obj.set_main_material(stored_clay.main_material)

	in_progress.finish(user)

	QDEL_NULL(in_progress)
	QDEL_NULL(stored_clay)

/obj/structure/pottery_lathe/proc/choose_recipe(mob/user)
	if(!length(recipes))
		for(var/datum/pottery_recipe/recipe as anything in typesof(/datum/pottery_recipe))
			if(IS_ABSTRACT(recipe))
				continue
			recipes |= new recipe

	var/datum/pottery_recipe/choice = input(user, "Choose a recipe to start", src) as anything in recipes
	if(!choice)
		return FALSE
	in_progress = new choice.type
	return TRUE

/obj/structure/pottery_lathe/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(16 * (speed / 8))

/obj/structure/pottery_lathe/update_animation_effect()
	if(!rotation_network || length(rotation_network) == 1)
		animate(src, icon_state = "wheel", time = 1)
		return
	animate(src, icon_state = "wheel1", time = 1)
