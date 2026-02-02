/datum/action/cooldown/spell/essence/gem_detect
	name = "Gem Detect"
	desc = "Reveals the location of precious stones and crystals nearby."
	button_icon_state = "gem_detect"
	cast_range = 3
	point_cost = 4
	attunements = list(/datum/attunement/earth)

/datum/action/cooldown/spell/essence/gem_detect/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] searches for precious stones."))

	var/found_gems = FALSE
	for(var/obj/item/gem/G in range(2, target_turf))
		G.visible_message(span_notice("[G] sparkles briefly!"))
		new /obj/effect/temp_visual/sparkle(get_turf(G))
		found_gems = TRUE

	for(var/atom/movable/movable in range(2, target_turf))
		for(var/obj/item/gem/G in movable.contents)
			G.visible_message(span_notice("[G] sparkles briefly!"))
			new /obj/effect/temp_visual/sparkle(get_turf(G))
			found_gems = TRUE

		if(isliving(movable))
			for(var/obj/item/gem/G in movable:get_contents())
				G.visible_message(span_notice("[G] sparkles briefly!"))
				new /obj/effect/temp_visual/sparkle(get_turf(G))
				found_gems = TRUE

	for(var/turf/closed/mineral/mineral in view(6, target_turf))
		if(mineral.mineralType)
			mineral.visible_message(span_notice("[mineral] sparkles briefly!"))
			found_gems = TRUE
			new /obj/effect/temp_visual/sparkle(mineral)

	if(!found_gems)
		to_chat(owner, span_notice("No gems detected in the area."))
