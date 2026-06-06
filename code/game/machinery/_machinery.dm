/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	desc = ""
	verb_say = "beeps"
	verb_yell = "blares"
	max_integrity = 200
	layer = BELOW_OBJ_LAYER //keeps shit coming out of the machine from ending up underneath it.

	anchored = TRUE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT

	var/machine_stat = 0

	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.

	var/list/occupant_typecache //if set, turned into typecache in Initialize, other wise, defaults to mob/living typecache
	var/atom/movable/occupant = null
	var/speed_process = FALSE // Process as fast as possible?

	var/interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_SET_MACHINE
	var/fair_market_price = 69
	var/market_verb = "Customer"
	var/payment_department = ACCOUNT_ENG

	var/climb_time = 0
	var/climb_stun = 0
	var/climbable = FALSE
	var/climb_sound = 'sound/foley/woodclimb.ogg'
	var/climb_offset = 0 //offset up when climbed
	var/mob/living/structureclimber

/obj/machinery/Initialize(mapload, ...)
	if(!armor)
		armor = list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 10, "fire" = 50, "acid" = 70)
	. = ..()
	SSmachines.register_machine(src)

	if(!speed_process)
		START_PROCESSING(SSmachines, src)
	else
		START_PROCESSING(SSfastprocess, src)

	if(occupant_typecache)
		occupant_typecache = typecacheof(occupant_typecache)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/Destroy()
	SSmachines.unregister_machine(src)
	if(!speed_process)
		STOP_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSfastprocess, src)

	return ..()

/obj/machinery/process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/machinery/proc/can_be_occupant(atom/movable/am)
	return occupant_typecache ? is_type_in_typecache(am, occupant_typecache) : isliving(am)


/obj/machinery/proc/is_operational()
	return !(machine_stat & (NOPOWER|BROKEN|MAINT))

/obj/machinery/can_interact(mob/user)
	var/silicon = IsAdminGhost(user)
	if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
		return FALSE
	if(!(interaction_flags_machine & INTERACT_MACHINE_OPEN))
		if(!silicon || !(interaction_flags_machine & INTERACT_MACHINE_OPEN_SILICON))
			return FALSE

	if(silicon)
		if(!(interaction_flags_machine & INTERACT_MACHINE_ALLOW_SILICON))
			return FALSE
	else
		if(interaction_flags_machine & INTERACT_MACHINE_REQUIRES_SILICON)
			return FALSE
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////////

//Return a non FALSE value to interrupt attack_hand propagation to subtypes.
/obj/machinery/interact(mob/user, special_machine_state)
	if(interaction_flags_machine & INTERACT_MACHINE_SET_MACHINE)
		user.set_machine(src)
	. = ..()

/obj/machinery/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/machinery/Topic(href, href_list)
	..()
	if(!can_interact(usr))
		return 1
	if(!usr.can_perform_action(src, NEED_DEXTERITY))
		return 1
	add_fingerprint(usr)
	return 0

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_paw(mob/living/user)
	if(user.used_intent.type != INTENT_HARM)
		return attack_hand(user)
	else
		user.changeNext_move(CLICK_CD_MELEE)
//		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		user.visible_message("<span class='danger'>[user.name] smashes against \the [src.name] with its paws.</span>", null, null, COMBAT_MESSAGE_RANGE)
		take_damage(4, BRUTE, "blunt", 1)

/obj/machinery/_try_interact(mob/user)
	return ..()

/obj/machinery/CheckParts(list/parts_list)
	..()
	RefreshParts()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/handle_deconstruct(disassembled = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(obj_flags & NO_DEBRIS_AFTER_DECONSTRUCTION)
		dump_inventory_contents() //drop stuff we consider important
		return

	on_deconstruction()

	if(!LAZYLEN(component_parts))
		dump_contents() //drop everything inside us
		return //we don't have any parts.

	if(component_parts && component_parts.len)
		for(var/part in component_parts)
			var/obj/item/obj_part = part
			component_parts -= part
			obj_part.forceMove(loc)
	LAZYCLEARLIST(component_parts)

	//drop everything inside us. we do this last to give machines a chance
	//to handle their contents before we dump them
	dump_contents()

/obj/machinery/proc/set_occupant(atom/movable/new_occupant)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_MACHINERY_SET_OCCUPANT, new_occupant)
	occupant = new_occupant

/**
 * Drop every movable atom in the machine's contents list, including any components and circuit.
 */
/obj/machinery/dump_contents()
	// Start by calling the dump_inventory_contents proc. Will allow machines with special contents
	// to handle their dropping.
	dump_inventory_contents()

	// Then we can clean up and drop everything else.
	var/turf/this_turf = get_turf(src)
	for(var/atom/movable/movable_atom in contents)
		movable_atom.forceMove(this_turf)

	// We'll have dropped the occupant, circuit and component parts as part of this.
	set_occupant(null)
	LAZYCLEARLIST(component_parts)

/*
 * Drop every movable atom in the machine's contents list that is not a component_part.
 *
 * Proc does not drop components and will skip over anything in the component_parts list.
 * Call dump_contents() to drop all contents including components.
 * Arguments:
 * * subset - If this is not null, only atoms that are also contained within the subset list will be dropped.
 */
/obj/machinery/proc/dump_inventory_contents(list/subset = null)
	var/turf/this_turf = get_turf(src)
	for(var/atom/movable/movable_atom in contents)
		if(subset && !(movable_atom in subset))
			continue

		if(movable_atom in component_parts)
			continue

		movable_atom.forceMove(this_turf)

		if(occupant == movable_atom)
			set_occupant(null)

/obj/machinery/atom_break(damage_flag, silent)
	. = ..()
	if(!(machine_stat & BROKEN))
		machine_stat |= BROKEN
		SEND_SIGNAL(src, COMSIG_MACHINERY_BROKEN, damage_flag)
		update_appearance(UPDATE_ICON)
		return TRUE

/obj/machinery/contents_explosion(severity, target)
	if(occupant)
		occupant.ex_act(severity, target)

/obj/machinery/handle_atom_del(atom/A)
	if(A == occupant)
		set_occupant(null)
		update_appearance(UPDATE_ICON)
		updateUsrDialog()

/obj/proc/can_be_unfasten_wrench(mob/user, silent) //if we can unwrench this object; returns SUCCESSFUL_UNFASTEN and FAILED_UNFASTEN, which are both TRUE, or CANT_UNFASTEN, which isn't.
	if(!(isfloorturf(loc)) && !anchored)
		to_chat(user, "<span class='warning'>[src] needs to be on the floor to be secured!</span>")
		return FAILED_UNFASTEN
	return SUCCESSFUL_UNFASTEN

/obj/proc/default_unfasten_wrench(mob/user, obj/item/I, time = 20) //try to unwrench an object in a WONDERFUL DYNAMIC WAY
	if(I.tool_behaviour == TOOL_WRENCH)
		var/can_be_unfasten = can_be_unfasten_wrench(user)
		if(!can_be_unfasten || can_be_unfasten == FAILED_UNFASTEN)
			return can_be_unfasten
		if(time)
			to_chat(user, "<span class='notice'>I begin [anchored ? "un" : ""]securing [src]...</span>")
		I.play_tool_sound(src, 50)
		var/prev_anchored = anchored
		//as long as we're the same anchored machine_state and we're either on a floor or are anchored, toggle our anchored machine_state
		if(I.use_tool(src, user, time, extra_checks = CALLBACK(src, PROC_REF(unfasten_wrench_check), prev_anchored, user)))
			to_chat(user, "<span class='notice'>I [anchored ? "un" : ""]secure [src].</span>")
			setAnchored(!anchored)
			playsound(src, 'sound/blank.ogg', 50, TRUE)
			SEND_SIGNAL(src, COMSIG_OBJ_DEFAULT_UNFASTEN_WRENCH, anchored)
			return SUCCESSFUL_UNFASTEN
		return FAILED_UNFASTEN
	return CANT_UNFASTEN

/obj/proc/unfasten_wrench_check(prev_anchored, mob/user) //for the do_after, this checks if unfastening conditions are still valid
	if(anchored != prev_anchored)
		return FALSE
	if(can_be_unfasten_wrench(user, TRUE) != SUCCESSFUL_UNFASTEN) //if we aren't explicitly successful, cancel the fuck out
		return FALSE
	return TRUE

/obj/machinery/proc/display_parts(mob/user)
	. = list()
	. += "<span class='notice'>It contains the following parts:</span>"
	for(var/obj/item/C in component_parts)
		. += "<span class='notice'>[icon2html(C, user)] \A [C].</span>"
	. = jointext(., "")

/obj/machinery/examine(mob/user)
	. = ..()
	if(!(resistance_flags & INDESTRUCTIBLE))
		if(uses_integrity)
			var/healthpercent = (atom_integrity / max_integrity) * 100
			switch(healthpercent)
				if(50 to 99)
					. += "It looks slightly damaged."
				if(25 to 50)
					. += "It appears heavily damaged."
				if(0 to 25)
					. += "<span class='warning'>It's falling apart!</span>"
//	if(user.research_scanner && component_parts)
//		. += display_parts(user, TRUE)

//called on machinery construction (i.e from frame to machinery) but not on initialization
/obj/machinery/proc/on_construction()
	return

//called on deconstruction before the final deletion
/obj/machinery/proc/on_deconstruction()
	return

/obj/machinery/proc/can_be_overridden()
	. = 1

/obj/machinery/Exited(atom/movable/gone, direction)
	. = ..()
	if (gone == occupant)
		set_occupant(null)

/obj/machinery/proc/adjust_item_drop_location(atom/movable/AM)	// Adjust item drop location to a 3x3 grid inside the tile, returns slot id from 0 to 8
	var/md5 = md5(AM.name)										// Oh, and it's deterministic too. A specific item will always drop from the same slot.
	for (var/i in 1 to 32)
		. += hex2num(md5[i])
	. = . % 9
	AM.pixel_x = AM.base_pixel_x - 8 + ((.%3)*8)
	AM.pixel_y = AM.base_pixel_y - 8 + (round( . / 3)*8)

/obj/machinery/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.add_offsets("structure_climb", x_add = 0, y_add = climb_offset)

/obj/machinery/Uncrossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.remove_offsets("structure_climb")

/obj/machinery/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(!climbable)
		return
	if(user == O && isliving(O))
		var/mob/living/L = O
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if (!A.dextrous)
				return
		if(!HAS_TRAIT(L, TRAIT_IMMOBILIZED))
			climb_structure(user)
			return
	if(!istype(O, /obj/item) || user.get_active_held_item() != O)
		return
	if(!user.dropItemToGround(O))
		return
	if (O.loc != src.loc)
		step(O, get_dir(O, src))

/obj/machinery/proc/do_climb(atom/movable/A)
	if(climbable)
		density = FALSE
		. = step(A,get_dir(A,src.loc))
		density = TRUE

/obj/machinery/proc/climb_structure(mob/living/user)
	src.add_fingerprint(user)
	var/adjusted_climb_time = climb_time
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)) //climbing takes twice as long when restrained.
		adjusted_climb_time *= 2
	adjusted_climb_time -= GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) * 2
	adjusted_climb_time = max(adjusted_climb_time, 0)

	structureclimber = user
	if(do_after(user, adjusted_climb_time))
		if(src.loc) //Checking if structure has been destroyed
			if(do_climb(user))
				user.visible_message("<span class='warning'>[user] climbs onto [src].</span>", \
									"<span class='notice'>I climb onto [src].</span>")
				log_combat(user, src, "climbed onto")
				if(climb_stun)
					user.Stun(climb_stun)
				if(climb_sound)
					playsound(src, climb_sound, 100)
				. = 1
			else
				to_chat(user, "<span class='warning'>I fail to climb onto [src].</span>")
	structureclimber = null
