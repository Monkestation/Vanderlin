// HOW GRAVE SPAWNER WORKS
// Works in Tiers, the higher the tier, the better the grave will be decorated and loot (body and other things), later determined by decor_quality
// T1: chance for Headstone, chance for gravefence. LOOT: Corpse of a beggar or other lowborn
// T2: Headstone and chance for gravefence, both higher quality. LOOT: Corpse of someone who actually matters in life, such as a craftsman or member of a Garrison
// T3: Best Headstones and gravefence. LOOT: Corpse of a Noble or Merchant, or other person of privledge.

/// Determines loot and gravedecor spawned on a `obj/structure/closet/dirthole/closed`.
/obj/effect/mapping_helpers/structure/grave_spawner
	name = "grave spawner"
	icon_state = "grave_spawner"

	/// `obj/structure/closet/dirthole/closed` that is used by this marker. Set on `payload()`
	var/obj/structure/closet/dirthole/closed/grave

	/// If `spawn_headstone` or `spawn_gravefence` is set to TRUE, quality of decor will not surpass this number
	var/decor_quality = 1
	/// Decor with patrons supported NOT in list, is skipped. If empty, only general headstones are allowed. General headstones can STILL be picked regardless
	var/list/patrons_allowed = list()

	/// If TRUE, the grave will always be 'blessed', otherwise will only be blessed in areas with `burial_ground` = TRUE
	var/force_consecrate = FALSE

	/// If set to TRUE, picks a random Headstone, factors to affect this done in `payload()`. If FALSE, `payload()` will roll a random chance if a headstone is spawned or not
	var/spawn_headstone = FALSE
	/// If set to TRUE, picks a random Gravefence, factors to affect this done in `payload()`. If FALSE, `payload()` will roll random chance to spawn one anyways if `decor_quality` is 2 or above.
	var/spawn_gravefence = FALSE

	/// The body that will be spawned, set by `generate_body()`, used to make inscription on a headstone if there is one.
	var/mob/living/carbon/human/to_be_interred

/obj/effect/mapping_helpers/structure/grave_spawner/LateInitialize()
	var/turf/open/floor/dirt/T = loc
	if(!istype(T))
		log_mapping("[src] at [AREACOORD(src)] was not placed on a turf/open/floor/dirt or it's subtypes, and instead placed on a [T.type] this will cause any dirtholes to be deleted on init!")
		return
	var/obj/structure/closet/dirthole/closed/target = locate() in loc
	if(target)
		payload(target)
		qdel(src)
		return
	log_mapping("[src] failed to find target at [AREACOORD(src)]")
	qdel(src)

/obj/effect/mapping_helpers/structure/grave_spawner/payload(obj/structure/payload)
	if(QDELETED(payload))
		return
	if(!istype(payload, /obj/structure/closet/dirthole/closed))
		log_mapping("[src] at [AREACOORD(src)] was not placed on a dirthole/closed.")
		return
	grave = payload

	// T1 still has chance to spawn headstone, 50%
	if(!spawn_headstone && prob(50))
		spawn_headstone = TRUE

	// Spawn a headstone.
	if(spawn_headstone)
		var/list/headstone_spawn_list = list()
		for(var/obj/item/gravedecor/headstone/potential_head as anything in typesof(/obj/item/gravedecor/headstone))
			// Spawn a temp headstone, we qdel() it at end
			potential_head = new potential_head.type()

			// If matches the patrons we want, we let be an option, otherwise if generic must match quality.
			if(length(potential_head.patrons))
				if(!length(patrons_allowed)) // Generic only
					qdel(potential_head)
					continue
				var/success = FALSE
				for(var/P in patrons_allowed)
					if(P in potential_head.patrons)
						success = TRUE
						break
				// If it supports the patrons we want, and is NOT higher quality than what we desire, add to list.
				if(success && potential_head.decorationquality <= decor_quality)
					headstone_spawn_list += potential_head

				qdel(potential_head)
				continue

			// Generic headstones, must match the quality we want
			if(potential_head.decorationquality == decor_quality)
				headstone_spawn_list += potential_head

			qdel(potential_head)

		if(length(headstone_spawn_list))
			var/obj/item/gravedecor/headstone/new_headstone = pick(headstone_spawn_list)
			grave.headstone = new new_headstone.type
		else
			log_mapping("[src] at [AREACOORD(src)] was unable to determine a headstone object to spawn, given a decor_quality of [decor_quality].")

	// T1 and T2 still have chance to spawn fence
	if(!spawn_gravefence)
		if(decor_quality == 1)
			if(prob(10))
				spawn_gravefence = TRUE
		else if(prob(50))
			spawn_gravefence = TRUE

	if(spawn_gravefence)
		var/list/gravefence_spawn_list = list()
		for(var/obj/item/gravedecor/gravefence/potential_fence as anything in typesof(/obj/item/gravedecor/gravefence))
			// Spawn a temp gravefence, we qdel() it at end
			potential_fence = new potential_fence.type()

			// If matches the patron we want, we let be an option, otherwise if generic must match quality.
			if(length(potential_fence.patrons))
				if(!length(patrons_allowed)) // Generic only
					qdel(potential_fence)
					continue
				var/success = FALSE
				for(var/P in patrons_allowed)
					if(P in potential_fence.patrons)
						success = TRUE
						break
				// If it supports the patrons we want, and is NOT higher quality than what we desire, add to list.
				if(success && potential_fence.decorationquality <= decor_quality)
					gravefence_spawn_list += potential_fence

				qdel(potential_fence)
				continue

			// Generic headstones, must match the quality we want
			if(potential_fence.decorationquality == decor_quality)
				gravefence_spawn_list += potential_fence

			qdel(potential_fence)

		if(length(gravefence_spawn_list))
			var/obj/item/gravedecor/gravefence/new_gravefence = pick(gravefence_spawn_list)
			grave.gravefence = new new_gravefence.type()
		else
			log_mapping("[src] at [AREACOORD(src)] was unable to determine a gravefence object to spawn, given a decor_quality of [decor_quality].")

	grave.contents = generate_loot()

	// Generate inscription
	if(to_be_interred && grave.headstone)
		var/custom_messages = file2list("strings/grave_messages.txt")
		grave.headstone.inscription = "<span class='big'>Here lies </span><span class='big bold'>[to_be_interred.real_name]</span>\
		<br>\
		<br>\
		<span class='italics'>[pick(custom_messages)]</span>"

	//Update Grave
	grave.no_devotion = TRUE // No devotion from these graves
	grave.update_quality()

	// Check if area is fit for burials
	var/area/A = get_area(grave)
	if(A.burial_grounds || force_consecrate)
		grave.is_consecrated = TRUE

	grave.update_appearance(UPDATE_ICON)

/// Proc that generates a body and/or loot for grave, and returns a list
/// HEAVILY effected by `decor_quality` to determine tier of 'loot'
/obj/effect/mapping_helpers/structure/grave_spawner/proc/generate_loot()
	// This will be (maybe) expanded in future, for now we will just generate a john doe with different clothes depending on tier (decor_quality)
	generate_body()

	return list(to_be_interred)

/// Called by `generate_loot()`, handles spawning and clothing a mob to update `to_be_interred`
/obj/effect/mapping_helpers/structure/grave_spawner/proc/generate_body()
	// This will (maybe) be expanded to have different species. For now we will just spawn a human and an outfit.
	var/mob/living/carbon/human/body = new /mob/living/carbon/human/species/human/northern(loc)
	body.death()
	ADD_TRAIT(body, TRAIT_STASIS, "Necra") // Body is dead and frozen, it was buried after all...

	// Pick outfit
	// List of available outfits for tier, unweighted and needs processed.
	var/list/unprocessed_outfits
	if(decor_quality == 1)
		unprocessed_outfits = subtypesof(/datum/outfit/grave/t1)
	else if(decor_quality == 2)
		unprocessed_outfits = subtypesof(/datum/outfit/grave/t2)
	else
		unprocessed_outfits = subtypesof(/datum/outfit/grave/t3)

	// Weighted list that will be created and used to pick an outfit
	var/list/outfit_choices = list()
	for(var/datum/outfit/grave/possible_outfit as anything in unprocessed_outfits)
		outfit_choices[possible_outfit] += possible_outfit.weight

	body.equipOutfit(pickweight(outfit_choices))

	to_be_interred = body

// Subtypes for grave_spawner
// If we want specific dieties, make new helpers!

/obj/effect/mapping_helpers/structure/grave_spawner/t2
	name = "grave spawner (T2)"
	icon_state = "grave_spawner_t2"
	decor_quality = 2
	spawn_headstone = TRUE

/obj/effect/mapping_helpers/structure/grave_spawner/t3
	name = "grave spawner (T3)"
	icon_state = "grave_spawner_t3"
	decor_quality = 3
	spawn_headstone = TRUE
	spawn_gravefence = TRUE

// TENNITE
/obj/effect/mapping_helpers/structure/grave_spawner/_tennite
	patrons_allowed = UNDIVIDED_TEMPLE_PATRONS

/obj/effect/mapping_helpers/structure/grave_spawner/t2/_tennite
	patrons_allowed = UNDIVIDED_TEMPLE_PATRONS

/obj/effect/mapping_helpers/structure/grave_spawner/t3/_tennite
	patrons_allowed = UNDIVIDED_TEMPLE_PATRONS

// PSYDON
/obj/effect/mapping_helpers/structure/grave_spawner/psydon
	patrons_allowed = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

/obj/effect/mapping_helpers/structure/grave_spawner/t2/psydon
	patrons_allowed = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

/obj/effect/mapping_helpers/structure/grave_spawner/t3/psydon
	patrons_allowed = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

// GREAT HUNT
/obj/effect/mapping_helpers/structure/grave_spawner/great_hunt
	spawn_headstone = TRUE // great_hunt has a t1 headstone, so they SHOULD always have it
	patrons_allowed = list(/datum/patron/alternate/great_hunt, /datum/patron/alternate/great_hunt/proven)

/obj/effect/mapping_helpers/structure/grave_spawner/t2/great_hunt
	patrons_allowed = list(/datum/patron/alternate/great_hunt, /datum/patron/alternate/great_hunt/proven)

/obj/effect/mapping_helpers/structure/grave_spawner/t3/great_hunt
	patrons_allowed = list(/datum/patron/alternate/great_hunt, /datum/patron/alternate/great_hunt/proven)
