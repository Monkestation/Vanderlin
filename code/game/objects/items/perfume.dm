/obj/item/perfume
	name = "perfume bottle"
	desc = "A bottle of pleasantly smelling fragrance."
	icon = 'icons/roguetown/items/perfume.dmi'
	icon_state = "perfume-bottle-empty"
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	/// What fragrance is the perfume
	var/datum/pollutant/fragrance/fragrance_type
	/// How many uses remaining has it got
	var/uses_remaining = 10

/obj/item/perfume/Initialize()
	. = ..()
	if(!fragrance_type)
		uses_remaining = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/item/perfume/pickup()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/perfume/update_overlays()
	. = ..()
	if(!uses_remaining)
		return
	var/mutable_appearance/perfume_overlay = mutable_appearance(icon, "perfume-bottle-overlay")
	perfume_overlay.color = fragrance_type.color
	. += perfume_overlay

/obj/item/perfume/examine(mob/user)
	. = ..()
	if(uses_remaining)
		. += "It has [uses_remaining] use\s left."
	else
		. += "It is empty."

/obj/item/perfume/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	. = ..()
	if(.)
		return

	if(!uses_remaining)
		to_chat(user, span_warning("\The [src] is empty!"))
		update_appearance(UPDATE_OVERLAYS)
		return

	uses_remaining--
	update_appearance(UPDATE_OVERLAYS)
	user.changeNext_move(CLICK_CD_RANGE * 2)
	playsound(user, 'sound/items/perfume.ogg', 100, TRUE)

	if(proximity_flag)
		// Direct application at close range
		apply_perfume(target, user)
	else
		// Spawn perfume cloud projectile
		spawn_perfume_cloud(target, user)

/obj/item/perfume/proc/apply_perfume(atom/target, mob/user)
	if(!ismovable(target))
		return

	if(target == user)
		user.visible_message(span_notice("[user] sprays [user.p_them()]self with \the [src]."), span_notice("You spray yourself with \the [src]."))
	else
		user?.visible_message(span_notice("[user] sprays [target] with \the [src]."), span_notice("You spray [target] with \the [src]."))

	var/turf/my_turf = get_turf(target)
	my_turf.pollute_turf(fragrance_type, 20)

	if(ismob(target))
		var/mob/living/hygiene_target = target
		hygiene_target.adjust_hygiene(10)

	target.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)

/obj/item/perfume/proc/spawn_perfume_cloud(atom/target, mob/user)
	user.visible_message(span_notice("[user] sprays \the [src] toward [target]."), span_notice("You spray \the [src] toward [target]."))

	var/obj/projectile/perfume_cloud/cloud = new(get_turf(user))
	cloud.fragrance_type = fragrance_type
	cloud.perfume_source = src
	cloud.preparePixelProjectile(target, user)
	cloud.fire()

// Perfume cloud projectile
/obj/projectile/perfume_cloud
	name = "perfume cloud"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke" // You may want to create a custom sprite cause smoke is fucked
	pass_flags = PASSTABLE | PASSGRILLE
	damage = 0
	damage_type = BRUTE
	nodamage = TRUE
	speed = 0.8
	/// The fragrance type this cloud carries
	var/datum/pollutant/fragrance/fragrance_type
	/// Reference to the perfume bottle
	var/obj/item/perfume/perfume_source

/obj/projectile/perfume_cloud/Initialize()
	. = ..()
	if(fragrance_type)
		color = fragrance_type.color

/obj/projectile/perfume_cloud/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(perfume_source && fragrance_type)
		perfume_source.apply_perfume(target, firer)
	qdel(src)

/obj/projectile/perfume_cloud/Bump(atom/A)
	if(isturf(A))
		var/turf/T = A
		if(T.density)
			// Hit a wall, dissipate
			if(fragrance_type)
				T.pollute_turf(fragrance_type, 10)
			qdel(src)
			return
	return ..()

/obj/item/perfume/random
	icon_state = MAP_SWITCH("perfume-bottle-empty", "random-perfume")

/obj/item/perfume/random/Initialize()
	fragrance_type = pick(subtypesof(/datum/pollutant/fragrance))
	name = fragrance_type.name + " perfume"
	. = ..()

/obj/item/perfume/lavender
	name = "lavender perfume"
	fragrance_type = /datum/pollutant/fragrance/lavender

/obj/item/perfume/cherry
	name = "cherry perfume"
	fragrance_type = /datum/pollutant/fragrance/cherry

/obj/item/perfume/rose
	name = "rose perfume"
	fragrance_type = /datum/pollutant/fragrance/rose

/obj/item/perfume/jasmine
	name = "jasmine perfume"
	fragrance_type = /datum/pollutant/fragrance/jasmine

/obj/item/perfume/mint
	name = "mint perfume"
	fragrance_type = /datum/pollutant/fragrance/mint

/obj/item/perfume/vanilla
	name = "vanilla perfume"
	fragrance_type = /datum/pollutant/fragrance/vanilla

/obj/item/perfume/pear
	name = "pear perfume"
	fragrance_type = /datum/pollutant/fragrance/pear

/obj/item/perfume/strawberry
	name = "strawberry perfume"
	fragrance_type = /datum/pollutant/fragrance/strawberry
