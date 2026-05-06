
/**
 * Stardew Valley-style qualities that modify visuals of an item.
 * Attaches a star to the item when picked up and shiny particles if high enough quality.
 * Quality defines can be found in qualities.dm
*/
/datum/element/visual_quality
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Determines which star overlay and whether sparkles are applied
	var/quality
	/// Overlay to apply to the item when picked
	var/mutable_appearance/quality_overlay

/datum/element/visual_quality/Attach(datum/target, quality)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	var/obj/item/target_item = target
	src.quality = quality

	var/list/quality_icons = list(
		null, // CROP_QUALITY_REGULAR has no overlay
		"silver", // CROP_QUALITY_SILVER
		"gold", // CROP_QUALITY_GOLD
		"diamond", // CROP_QUALITY_DIAMOND
	)
	if(quality && quality <= length(quality_icons) && quality_icons[quality])
		quality_overlay = mutable_appearance('icons/effects/crop_quality.dmi', quality_icons[quality])
		RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(update_overlay_on_signal))
		target_item.update_appearance(UPDATE_OVERLAYS)

	if(quality >= CROP_QUALITY_DIAMOND) // I'd rather be shiny
		target_item.AddComponent(/datum/component/particle_spewer/sparkle/turf_only)

/datum/element/visual_quality/Detach(datum/source, ...)
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_OVERLAYS)
	qdel(source.GetComponent(/datum/component/particle_spewer/sparkle/turf_only))
	. = ..()

/datum/element/visual_quality/proc/update_overlay_on_signal(obj/item/source, list/overlays)
	SIGNAL_HANDLER

	if(!quality_overlay || !ismob(source.loc))
		return

	overlays += quality_overlay
