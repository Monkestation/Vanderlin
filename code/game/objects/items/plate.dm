/obj/item/plate
	name = "platter"
	desc = "A wood plate that holds food. A powerful tool for morale when you're not eating your meal off a table."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "platter"
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	possible_item_intents = list(/datum/intent/use, /datum/intent/food)
	w_class = WEIGHT_CLASS_NORMAL
	///How many things fit on this plate?
	var/max_items = 2
	///The offset from side to side the food items can have on the plate
	var/max_x_offset = 4
	///The max height offset the food can reach on the plate
	var/max_height_offset = 5
	///Offset of where the click is calculated from, due to how food is positioned in their DMIs.
	var/placement_offset = -15
	grid_width = 32
	grid_height = 32
	var/max_fork_usages = 5
	var/fork_usages = 0
	var/dirty = FALSE
	var/cleaned = FALSE
	var/start_dirty = FALSE

/obj/item/plate/dirty
	dirty = TRUE

/obj/item/plate/Initialize(mapload, ...)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/plate/attackby(obj/item/I, mob/user, list/modifiers)
	if(!length(contents) && istype(I, /obj/item/natural/cloth) && user?.used_intent?.type == INTENT_USE)
		if(dirty)
			var/obj/item/natural/cloth/cloth_check = I
			if(cloth_check.reagents.total_volume < 0.1)
				to_chat(user, span_warning("[cloth_check] is too dry to clean with!"))
				return
			var/dirtyWater = cloth_check.reagents.get_reagent_amount(/datum/reagent/water/gross)
			if(dirtyWater)
				to_chat(user, span_warning("[cloth_check] water is too dirty to clean anything with it!"))
				return
			to_chat(user, ("You start cleaning the [src] with the [cloth_check]"))
			if(do_after(user, 2 SECONDS, src))
				cloth_check.reagents.remove_all(1)
				dirty = FALSE
				update_appearance(UPDATE_OVERLAYS)
				AddComponent(/datum/component/particle_spewer/sparkle)
				user.nobles_seen_servant_work()
				fork_usages = 0
				cleaned = TRUE
				to_chat(user, ("You cleaned the [src]"))
				return
		else
			to_chat(user, span_notice("This platter is already clean."))
			return
	if(length(contents) && istype(I, /obj/item/natural/cloth) && user?.used_intent?.type == INTENT_USE)
		to_chat(user, span_warning("You can't clean the [src] while it has food on it!."))
		return
	if(item_flags & IN_STORAGE)
		to_chat(user, span_warning("I cannot reach [src]."))
		return
	if(!istype(I, /obj/item/reagent_containers/food) && !istype(I, /obj/item/reagent_containers/glass/cup) && !istype(I, /obj/item/reagent_containers/glass/bowl))
		to_chat(user, span_notice("[src] isn't made to carry that!"))
		return
	if(contents.len >= max_items)
		to_chat(user, span_notice("[src] can't fit more items!"))
		return

	//Center the icon where the user clicked.
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return

	if(user.transferItemToLoc(I, src, silent = FALSE))
		I.pixel_x = I.base_pixel_x + clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -max_x_offset, max_x_offset)
		I.pixel_y = I.base_pixel_x + min(text2num(LAZYACCESS(modifiers, ICON_Y)) + placement_offset, max_height_offset)
		to_chat(user, span_notice("You place [I] on [src]."))
		AddToPlate(I, user)
	else
		return ..()

/obj/item/plate/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!iscarbon(A))
		return
	if(!contents.len)
		return
	if(user.used_intent.type != /datum/intent/food)
		return
	var/obj/item/object_to_eat = contents[1]
	A.attackby(object_to_eat, user)
	return TRUE //No normal attack

///This proc adds the food to viscontents and makes sure it can deregister if this changes.
/obj/item/plate/proc/AddToPlate(obj/item/item_to_plate)
	vis_contents += item_to_plate
	item_to_plate.flags_1 |= IS_ONTOP_1
	item_to_plate.vis_flags |= (VIS_INHERIT_PLANE | VIS_INHERIT_LAYER)
	RegisterSignal(item_to_plate, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_plate, COMSIG_PARENT_QDELETING, PROC_REF(ItemMoved))
	// We gotta offset ourselves via pixel_w/z, so we don't end up z fighting with the plane
	item_to_plate.pixel_w = item_to_plate.pixel_x
	item_to_plate.pixel_z = item_to_plate.pixel_y
	item_to_plate.pixel_x = 0
	item_to_plate.pixel_y = 0
	if(istype(item_to_plate, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = item_to_plate
		S.rotprocess += 1 MINUTES
	w_class = contents.len ? WEIGHT_CLASS_BULKY : WEIGHT_CLASS_NORMAL

///This proc cleans up any signals on the item when it is removed from a plate, and ensures it has the correct state again.
/obj/item/plate/proc/ItemRemovedFromPlate(obj/item/removed_item)
	removed_item.flags_1 &= ~IS_ONTOP_1
	removed_item.vis_flags &= ~VIS_INHERIT_PLANE
	removed_item.vis_flags &= ~VIS_INHERIT_LAYER
	vis_contents -= removed_item
	UnregisterSignal(removed_item, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	// Resettt
	removed_item.pixel_x = removed_item.pixel_w
	removed_item.pixel_y = removed_item.pixel_z
	removed_item.pixel_w = 0
	removed_item.pixel_z = 0
	removed_item.update_transform()
	if(istype(removed_item, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = removed_item
		S.rotprocess -= 1 MINUTES
	w_class = contents.len ? WEIGHT_CLASS_BULKY : WEIGHT_CLASS_NORMAL

///This proc is called by signals that remove the food from the plate.
/obj/item/plate/proc/ItemMoved(obj/item/moved_item, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromPlate(moved_item)

/obj/item/plate/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	var/generator/scatter_gen = generator(GEN_CIRCLE, 0, 48, NORMAL_RAND)
	var/scatter_turf = get_turf(hit_atom)

	for(var/obj/item/scattered_item as anything in contents)
		ItemRemovedFromPlate(scattered_item)
		scattered_item.forceMove(scatter_turf)
		var/list/scatter_vector = scatter_gen.Rand()
		scattered_item.pixel_x = scattered_item.base_pixel_x + scatter_vector[1]
		scattered_item.pixel_y = scattered_item.base_pixel_y + scatter_vector[2]
		scattered_item.throw_impact(hit_atom, throwingdatum)

/obj/item/plate/attack_self(mob/user, list/modifiers)
	. = ..()
	if(contents.len) // If the tray isn't empty
		for(var/obj/item/scattered_item as anything in contents)
			scattered_item.forceMove(drop_location())
		user.visible_message(span_notice("[user] empties [src] on the floor."))

/obj/item/plate/examine(mob/user)
	. = ..()
	desc = initial(desc)
	if(dirty)
		desc += span_boldwarning("\nThis platter is filthy... absolutely disgusting.")
	else if(cleaned)
		desc += span_notice("\nThis platter was cleaned recently!")
	else
		desc += "\nThis platter looks properly stored and clean enough."

/obj/item/plate/clay
	name = "clay platter"
	desc = "A fragile platter made from fired clay. Probably shouldn't throw it."
	icon_state = "platter_clay"
	drop_sound = 'sound/foley/dropsound/brick_drop.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/plate/clay/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay platter"

/obj/item/plate/clay/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	new /obj/effect/decal/cleanable/shreds/clay(get_turf(src))
	playsound(src, 'sound/foley/break_clay.ogg', 90, TRUE)
	qdel(src)

/obj/item/plate/copper
	name = "copper platter"
	desc = "A platter made from a sheet of copper. Known to impart a metallic taste when eating certain foods."
	icon_state = "platter_copper"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_fork_usages = 7

/obj/item/plate/pewter
	name = "pewter platter"
	desc = "A tin plate that contains just a tinge of lead."
	icon_state = "platter_tin"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_fork_usages = 7

/obj/item/plate/silver
	name = "silver platter"
	desc = "A fancy silver plate often used by the nobility as a symbol of class."
	icon_state = "platter_silver"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 12
	smeltresult = /obj/item/ingot/silver
	max_fork_usages = 9

/obj/item/plate/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/plate/gold
	name = "gold platter"
	desc = "A fancy gold plate often used by the nobility as a symbol of class."
	icon_state = "platter_gold"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 20
	smeltresult = /obj/item/ingot/gold
	max_fork_usages = 11

/obj/item/plate/jade
	name = "joapstone platter"
	desc = "A fancy platter carved out of joapstone."
	icon_state = "platter_jade"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 60
	max_fork_usages = 11

/obj/item/plate/onyxa
	name = "onyxa platter"
	desc = "A fancy platter carved out of onyxa."
	icon_state = "platter_onyxa"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 40
	max_fork_usages = 11

/obj/item/plate/shell
	name = "shell platter"
	desc = "A fancy platter carved out of shell."
	icon_state = "platter_shell"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 20
	max_fork_usages = 11

/obj/item/plate/rose
	name = "rosellusk platter"
	desc = "A fancy platter carved out of rosellusk."
	icon_state = "platter_rose"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 25
	max_fork_usages = 11

/obj/item/plate/amber
	name = "petriamber platter"
	desc = "A fancy platter carved out of petriamber."
	icon_state = "platter_amber"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 60
	max_fork_usages = 11

/obj/item/plate/opal
	name = "opaloise platter"
	desc = "A fancy platter carved out of opaloise."
	icon_state = "platter_opal"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 90
	max_fork_usages = 11

/obj/item/plate/coral
	name = "aoetal platter"
	desc = "A fancy platter carved out of aoetal."
	icon_state = "platter_coral"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 70
	max_fork_usages = 11

/obj/item/plate/turq
	name = "ceruleabaster platter"
	desc = "A fancy platter carved out of ceruleabaster."
	icon_state = "platter_turq"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 85
	max_fork_usages = 11

/obj/item/tray
	name = "tray"
	desc = "Best used when hosting for banquets or drunken taverns."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray"
	force = 5
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_BULKY

/obj/item/tray/psy
	name = "tray"
	icon_state = "tray_psy"

/obj/item/tray/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/tray)

/obj/item/tray/attack(mob/living/M, mob/living/user, list/modifiers)
	..()
	// Drop all the things. All of them.
	var/list/obj/item/oldContents = contents.Copy()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY)

	// Make each item scatter a bit
	for(var/obj/item/I in oldContents)
		if(I)
			do_scatter(I)

	if(prob(10))
		M.Paralyze(4 SECONDS)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/tray/proc/do_scatter(obj/item/I)
	if(I)
		for(var/i in 1 to rand(1, 2))
			var/xOffset = rand(-16, 16)  // Adjust the range as needed
			var/yOffset = rand(-16, 16)  // Adjust the range as needed
			I.x = xOffset
			I.y = yOffset

			sleep(rand(2, 4))

/obj/item/plate/update_overlays()
	. = ..()
	if(dirty)
		. += mutable_appearance(icon, "dirty_platter")
