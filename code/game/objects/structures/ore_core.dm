/datum/hover_data/ore_core

/datum/hover_data/ore_core/proc/build_image(atom/source)
	var/obj/structure/ore_core/core = source
	if(!core.current_ore_type)
		return null

	var/image/hover_image = image(icon = initial(core.current_ore_type.icon), icon_state = initial(core.current_ore_type.icon_state), loc = source, layer = ABOVE_HUD_PLANE)
	hover_image.plane = GAME_PLANE_UPPER
	hover_image.pixel_y = 34

	var/bar_progress = round(core.progress, 5)
	var/image/progress_overlay = image(icon = 'icons/effects/progressbar.dmi', icon_state = "prog_bar_[bar_progress]")
	progress_overlay.pixel_y = 32
	hover_image.overlays += progress_overlay

	return hover_image

/datum/hover_data/ore_core/setup_data(atom/source, mob/enterer)
	if(!enterer.client)
		return
	var/image/hover_image = build_image(source)
	if(!hover_image)
		return
	add_client_image(hover_image, enterer.client)

/obj/structure/ore_core
	name = "ore core"
	desc = "A dense knot of mineral-rich rock. Something's clearly still growing inside it."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "screaming3"
	density = TRUE
	anchored = TRUE
	max_integrity = 250

	SET_BASE_PIXEL(-12, 0)

	///weighted list of ores
	var/list/ore_pool = list(
		/obj/item/ore/iron = 30,
		/obj/item/ore/coal = 25,
		/obj/item/ore/copper = 20,
		/obj/item/ore/tin = 15,
		/obj/item/ore/silver = 6,
		/obj/item/ore/gold = 3,
		/obj/item/ore/cinnabar = 2,
		/obj/item/mana_battery/mana_crystal/standard = 1.5,
		/obj/item/gem = 1,
		/obj/item/ore/bloodstone = 0.5,
	)
	/// How many separate ore "batches" are left in this core before it's spent and needs to recharge.
	var/ore_amount = 5
	///how much ore we have as a cap
	var/ore_cap = 10
	/// Progress toward finishing the current ore, out of max_progress.
	var/progress = 0
	var/max_progress = 100
	/// Ore type currently being worked. rerolled each time one finishes.
	var/atom/current_ore_type
	///how long each ore takes to recharge
	var/ore_timer = 5 MINUTES

/obj/structure/ore_core/Initialize(mapload, ...)
	. = ..()
	roll_next_ore()
	AddComponent(/datum/component/hovering_information, /datum/hover_data/ore_core) // VERIFY: swap/remove the trait gate as needed
	addtimer(CALLBACK(src, PROC_REF(give_ore)), ore_timer, TIMER_LOOP)

/obj/structure/ore_core/proc/give_ore()
	ore_amount = min(ore_cap, ore_amount++)

/obj/structure/ore_core/proc/roll_next_ore()
	current_ore_type = pickweight(ore_pool)

/// Called by a drill facing this tile. Returns TRUE if it did something.
/obj/structure/ore_core/proc/drill_on_core(obj/structure/drill/source, power)
	if(!ore_amount)
		return FALSE

	if(!current_ore_type)
		roll_next_ore()

	progress = min(progress + power, max_progress)
	if(progress < max_progress)
		return TRUE

	progress = 0
	ore_amount--

	var/obj/item/mined_ore = new current_ore_type(get_turf(src))
	if(source)
		source.try_insert_ore(mined_ore)
	else
		mined_ore.forceMove(get_turf(src))

	if(ore_amount > 0)
		roll_next_ore()

	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

	return TRUE
