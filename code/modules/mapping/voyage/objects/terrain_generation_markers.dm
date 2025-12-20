/obj/effect/landmark/terrain_generation_marker
	name = "terrain generation marker"
	desc = "Marks where terrain should be generated. Bottom-left corner including perimeter."
	icon = 'icons/effects/effects.dmi'
	icon_state = "x2"
	alpha = 128

	var/generate_on_init = TRUE
	var/datum/cave_biome/cave_biome_override = null
	var/datum/island_biome/island_biome_override = null

/obj/effect/landmark/terrain_generation_marker/Initialize(mapload)
	. = ..()
	if(!generate_on_init)
		// Make visible for deferred generation
		alpha = 255

/obj/effect/landmark/terrain_generation_marker/attack_hand(mob/user)
	. = ..()
	if(!generate_on_init)
		to_chat(user, span_notice("Triggering terrain generation..."))
		if(SSterrain_generation.trigger_deferred_generation(src))
			to_chat(user, span_notice("Generation queued!"))
		else
			to_chat(user, span_warning("Failed to queue generation."))

/obj/effect/landmark/terrain_generation_marker/deferred
	generate_on_init = FALSE
