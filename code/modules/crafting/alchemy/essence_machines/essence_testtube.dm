
/obj/machinery/essence/test_tube
	name = "homunculus breeding tube"
	desc = "A large glass tank for cultivating gnome homunculi from life essence."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "essence_tank"
	network_priority = 5
	accepts_output = FALSE  // terminal sink

	var/gnome_progress = FALSE

/obj/machinery/essence/test_tube/Initialize(mapload)
	. = ..()
	storage.max_total = 1000
	storage.max_types = 1
	START_PROCESSING(SSobj, src)
	if(mapload)
		gnome_progress = 2  // Starter gnome waiting inside
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/test_tube/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/machinery/essence/test_tube/build_allowed_types()
	if(!GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/machines/gnomes))
		return list()
	var/room = storage.space()
	if(room <= 0)
		return list()
	return list(/datum/thaumaturgical_essence/life = room)

/obj/machinery/essence/test_tube/process()
	pull_from_linked(storage)

/obj/machinery/essence/test_tube/attack_hand(mob/living/user)
	if(gnome_progress == 2) // no research required :3
		gnome_progress = FALSE
		update_appearance(UPDATE_OVERLAYS)
		visible_message(span_notice("[src] opens and a gnome tumbles out!"))
		var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = new(get_turf(src))
		gnome.tamed(user)
		gnome.color = COLOR_PINK
		gnome.hat()
		animate(gnome, color = COLOR_WHITE, time = 45 SECONDS)
		to_chat(user, span_boldnotice("The gnome homunculus has been released and tamed to you!"))
		return
	if(!GLOB.thaumic_research?.has_research(/datum/thaumic_research_node/machines/gnomes))
		to_chat(user, span_warning("You have no idea how this works."))
		return
	var/required = 100 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)
	if(!storage.has(/datum/thaumaturgical_essence/life, required))
		to_chat(user, span_warning("Requires at least [required] units of life essence."))
		return
	if(gnome_progress)
		to_chat(user, span_notice("A gnome is already developing. Please wait."))
		return
	begin_gnome_growth(user)

/obj/machinery/essence/test_tube/proc/begin_gnome_growth(mob/living/user)
	gnome_progress = TRUE
	var/speed = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_speed)
	var/grow_time = 30 SECONDS * speed
	to_chat(user, span_info("You activate the breeding process."))
	addtimer(CALLBACK(src, PROC_REF(growth_feedback)), grow_time * 0.33)
	addtimer(CALLBACK(src, PROC_REF(growth_feedback)), grow_time * 0.66)
	addtimer(CALLBACK(src, PROC_REF(create_gnome), user), grow_time)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/test_tube/proc/growth_feedback()
	if(gnome_progress)
		visible_message(span_notice("[src] bubbles and churns as the homunculus develops."))

/obj/machinery/essence/test_tube/proc/create_gnome(mob/living/user)
	var/required = 100 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)
	gnome_progress = FALSE
	update_appearance(UPDATE_OVERLAYS)
	if(!storage.has(/datum/thaumaturgical_essence/life, required))
		to_chat(user, span_warning("Insufficient life essence, the process fails!"))
		return
	storage.remove(/datum/thaumaturgical_essence/life, required)
	visible_message(span_info("[src] glows brilliantly as the homunculus reaches maturity!"))
	var/hat_chance = 1 - GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_hat_chance)
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = new(get_turf(src))
	gnome.tamed(user)
	gnome.color = COLOR_PINK
	if(hat_chance) gnome.hat()
	animate(gnome, color = COLOR_WHITE, time = 45 SECONDS)
	to_chat(user, span_boldnotice("Your gnome homunculus has been created!"))

/obj/machinery/essence/test_tube/get_mechanics_examine(mob/user)
	. = ..()
	var/required = 100 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/gnome_efficency)
	. += span_notice("Breeding requirement: [required] life essence")
	if(gnome_progress)
		. += span_boldnotice("A gnome homunculus is currently developing!")
	else if(storage.has(/datum/thaumaturgical_essence/life, required))
		. += span_info("Ready to begin breeding.")
	else
		. += span_warning("Insufficient life essence to breed.")

/obj/machinery/essence/test_tube/update_overlays()
	. = ..()
	if(gnome_progress)
		var/image/gnome_img = image('icons/mob/gnome2.dmi', "gnome-tube")
		gnome_img.pixel_y = 6
		gnome_img.layer = layer - 0.1
		. += gnome_img
	var/pct = storage.total() / 100
	if(!pct) return
	var/level = clamp(CEILING(pct * 4, 1), 1, 4)
	. += mutable_appearance(icon, "tank_[level]", color = calc_fill_color())
	. += emissive_appearance(icon, "tank_[level]", alpha = src.alpha)

/obj/machinery/essence/test_tube/proc/calc_fill_color()
	if(!storage.contents.len) return "#4A90E2"
	var/total_w = 0; var/r = 0; var/g = 0; var/b = 0
	for(var/etype in storage.contents)
		var/datum/thaumaturgical_essence/e = new etype
		var/w = storage.contents[etype] * (e.tier + 1)
		total_w += w
		r += hex2num(copytext(e.color, 2, 4)) * w
		g += hex2num(copytext(e.color, 4, 6)) * w
		b += hex2num(copytext(e.color, 6, 8)) * w
		qdel(e)
	if(!total_w) return "#4A90E2"
	return rgb(FLOOR(r/total_w,1), FLOOR(g/total_w,1), FLOOR(b/total_w,1))
