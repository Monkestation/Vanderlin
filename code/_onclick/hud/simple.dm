/// Hud for all simple animals without another
/datum/hud/simple/New(mob/owner)
	. = ..()
	owner.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/see_through_darkness)

	backhudl = new /atom/movable/screen/backhudl/empty_border(null, src)
	static_inventory += backhudl

	// Todo cut apart human UI for targeting + intents etc
