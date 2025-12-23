/obj/structure
	icon = 'icons/obj/structures.dmi'
	max_integrity = 300
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	pass_flags_self = PASSSTRUCTURE
	var/climb_time = 20
	var/climb_stun = 0
	var/climb_sound = 'sound/foley/woodclimb.ogg'
	var/climbable = FALSE
	var/w_class = WEIGHT_CLASS_NORMAL
	var/climb_offset = 0 //offset up when climbed
	var/mob/living/structureclimber

	var/last_redstone_state = 0
	var/bonus_pressure = 0
//	move_resist = MOVE_FORCE_STRONG

/obj/structure/Initialize()
	if (!armor)
		armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = 50, "acid" = 50)
	. = ..()
	if(smoothing_flags & (SMOOTH_BITMASK|SMOOTH_BITMASK_CARDINALS))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	if(uses_lord_coloring)
		if(GLOB.lordprimary && GLOB.lordsecondary)
			lordcolor()
		else
			RegisterSignal(SSdcs, COMSIG_LORD_COLORS_SET, TYPE_PROC_REF(/obj/structure, lordcolor))
	if(redstone_id)
		GLOB.redstone_objs += src
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/Bumped(atom/movable/AM)
	..()
	if(density)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.dir == get_dir(H,src) && H.m_intent == MOVE_INTENT_RUN && H.body_position != LYING_DOWN)
				H.Immobilize(10)
				H.apply_damage(15, BRUTE, "chest", H.run_armor_check("chest", "blunt", damage = 15))
				H.toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
				playsound(src, "genblunt", 100, TRUE)
				H.visible_message("<span class='warning'>[H] runs into [src]!</span>", "<span class='warning'>I run into [src]!</span>")
				addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Knockdown), 10), 10)

/obj/structure/Destroy()
	if(isturf(loc))
		for(var/mob/living/user in loc)
			if(climb_offset)
				user.reset_offsets("structure_climb")
	if(redstone_id)
		for(var/obj/structure/O in redstone_attached)
			O.redstone_attached -= src
			redstone_attached -= O
		GLOB.redstone_objs -= src
	return ..()

/obj/structure/proc/trigger_wire_network(mob/user)
	last_redstone_state = !last_redstone_state
	var/power = last_redstone_state ? 15 : 0

	for(var/direction in GLOB.cardinals)
		var/turf/target_turf = get_step(src, direction)
		trigger_redstone_at(target_turf, power, user)

/obj/structure/pre_lock_interact(mob/living/user)
	if(obj_broken)
		to_chat(user, span_notice("[src] is broken, I cannot do this."))
		return FALSE
	return ..()

/obj/structure/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.set_mob_offsets("structure_climb", _x = 0, _y = climb_offset)

/obj/structure/Uncrossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.reset_offsets("structure_climb")

/obj/structure/ui_act(action, params)
	..()
	add_fingerprint(usr)

/obj/structure/MouseDrop_T(atom/movable/O, mob/user)
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

/obj/structure/proc/do_climb(atom/movable/A)
	if(climbable)
		density = FALSE
		. = step(A,get_dir(A,src.loc))
		density = TRUE

/obj/structure/proc/climb_structure(mob/living/user)
	src.add_fingerprint(user)
	var/adjusted_climb_time = climb_time
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)) //climbing takes twice as long when restrained.
		adjusted_climb_time *= 2
	if(!ishuman(user))
		adjusted_climb_time = 0 //simple mobs instantly climb
	adjusted_climb_time -= user.STASPD * 2
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

/obj/structure/examine(mob/user)
	. = ..()
	if(!(resistance_flags & INDESTRUCTIBLE))
		var/examine_status = examine_status(user)
		if(examine_status)
			. += examine_status

/obj/structure/proc/examine_status(mob/user) //An overridable proc, mostly for falsewalls.
	if(obj_broken)
		return "It appears to be broken."
	if(uses_integrity)
		var/healthpercent = (atom_integrity / max_integrity) * 100
		switch(healthpercent)
			if(50 to 99)
				return  "It looks slightly damaged."
			if(25 to 50)
				return  "It appears heavily damaged."
			if(1 to 25)
				return  "<span class='warning'>It's falling apart!</span>"
