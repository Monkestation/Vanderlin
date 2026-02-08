/obj/item/fishingrod
	force = 12
	possible_item_intents = list(ROD_AUTO, ROD_CAST, POLEARM_BASH)
	name = "fishing rod"
	desc = ""
	icon_state = "rod1"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	wlength = 33
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY

	grid_height = 96
	grid_width = 32

	///the bait we have on the hook
	var/obj/item/baited = null

	//attachments for the fishing rod
	var/obj/item/fishing/reel/reel
	var/obj/item/fishing/hook/hook
	var/obj/item/fishing/line/line //this last one isnt needed to fish

	/// How far can you cast this
	var/cast_range = 7
	/// Fishing minigame difficulty modifier (additive)
	var/difficulty_modifier = 0
	/// Explaination of rod functionality shown in the ui and the autowiki
	var/ui_description = "A classic fishing rod, with no special qualities."
	/// More explaination shown in the wiki after ui_description
	var/wiki_description = ""
	/// Is this fishing rod shown in the wiki
	var/show_in_wiki = TRUE

	/// Currently hooked item for item reeling
	var/atom/movable/currently_hooked

	/// Fishing line visual for the hooked item
	var/datum/beam/fishing_line/fishing_line

	/// Are we currently casting
	var/casting = FALSE

	/// The default color for the reel overlay if no line is equipped.
	var/default_line_color = "gray"

	/// Is this currently being used by the profound fisher component?
	var/internal = FALSE

	/// The name of the icon state of the reel overlay
	var/reel_overlay = "reel_overlay"

	/// Icon state of the frame overlay this rod uses for the minigame
	var/frame_state = "frame_wood"

	/**
	 * A list with two keys delimiting the spinning interval in which a mouse click has to be pressed while fishing.
	 * Inherited from baits, passed down to the minigame lure.
	 */
	var/list/spin_frequency

	///Prevents spamming the line casting, without affecting the player's click cooldown.
	COOLDOWN_DECLARE(casting_cd)

	///The chance of catching fish made of the same material of the fishing rod (if MATERIAL_EFFECTS is enabled)
	var/material_fish_chance = 10
	///The multiplier of how much experience is gained when fishing with this rod.
	var/experience_multiplier = 1
	///The multiplier of the completion gain during the minigame
	var/completion_speed_mult = 1
	///The multiplier of the speed of the bobber/bait during the minigame
	var/bait_speed_mult = 1
	///The multiplier of the decelaration during the minigame
	var/deceleration_mult = 1
	///The multiplier of the bounciness of the bobber/bait upon hitting the edges of the minigame area
	var/bounciness_mult = 1
	/// The multiplier of negative velocity that pulls the bait/bobber down when not holding the click
	var/gravity_mult = 1
	/**
	 * The multiplier of the bait height. Influenced by the strength_modifier of a material,
	 * unlike the other variables, lest we add too many vars to materials.
	 * Also materials with a strength_modifier lower than 1 don't do anything, since
	 * they're already likely to be quite bad
	 */
	var/bait_height_mult = 1

/datum/intent/cast
	name = "cast"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "cast"
	no_attack = TRUE

/datum/intent/auto
	name = "auto reel"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "auto"
	no_attack = TRUE

/obj/item/fishingrod/attack_self(mob/user, list/modifiers)
	if(user.doing())
		user.stop_all_doing()
	else
		..()

/obj/item/fishingrod/attackby(obj/item/I, mob/user, list/modifiers)
	if(baited && reel && hook && line)
		return ..()

	if(istype(I, /obj/item/fishing/lure) || istype(I, /obj/item/natural/worms) || istype(I, /obj/item/natural/bundle/worms) || istype(I, /obj/item/fishing/lure) || istype(I, /obj/item/reagent_containers/food/snacks))
		if(istype(I, /obj/item/fishing/lure) || istype(I, /obj/item/natural/worms) || istype(I, /obj/item/fishing/lure))
			if(!baited)
				I.forceMove(src)
				baited = I
				user.visible_message("<span class='notice'>[user] hooks something to [src].</span>", "<span class='notice'>I hook [I] to [src].</span>")
				playsound(src, 'sound/foley/pierce.ogg', 50, FALSE)
		else if(istype(I, /obj/item/natural/bundle/worms))
			if(!baited)
				var/obj/item/natural/bundle/worms/W = I
				baited = new W.stacktype(src)
				W.amount--
				if(W.amount == 1)
					new W.stacktype(get_turf(user))
					qdel(W)
				user.visible_message("<span class='notice'>[user] hooks something to [src].</span>", "<span class='notice'>I hook [W.stacktype] to [src].</span>")
				playsound(src, 'sound/foley/pierce.ogg', 50, FALSE)
		else
			if(!baited)
				I.forceMove(src)
				baited = I
				user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [I] to my line.</span>")
				playsound(src, 'sound/foley/pierce.ogg', 50, FALSE)

	else if(istype(I, /obj/item/fishing)) //bait has a null attachtype and is accounted for in the previous check so i don't have to worry about it
		var/obj/item/fishing/T = I
		switch(T.attachtype)
			if("line")
				if(!line)
					I.forceMove(src)
					line = I
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("hook")
				if(!hook)
					I.forceMove(src)
					hook = I
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("reel")
				if(!reel)
					I.forceMove(src)
					reel = I
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
	update_appearance(UPDATE_OVERLAYS)

/obj/item/fishingrod/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/attacheditems = list()
	if(baited)
		attacheditems += baited
	if(reel)
		attacheditems += reel
	if(hook)
		attacheditems += hook
	if(line)
		attacheditems += line

	if(!length(attacheditems))
		to_chat(user, "<span class='notice'>There's nothing to remove on [src]!</span>")

		return
	else
		var/obj/totake = input(user, "What will you take off?", "[src.name]") as obj in attacheditems
		if(!totake)
			return
		if(totake == baited)
			baited = null
		else if(totake == reel)
			reel = null
		else if(totake == hook)
			hook = null
		else if(totake == line)
			line = null
		user.put_in_hands(totake)
		to_chat(user, "<span class='notice'>I take [totake] off of [src].</span>")
		update_appearance(UPDATE_OVERLAYS)

/obj/item/fishingrod/examine(mob/user)
	. = ..()
	if(baited)
		. += "<span class='info'>There's a [baited.name] stuck on here.</span>"

	if(reel)
		. += "<span class='info'>There's a [reel.name] strung on [src].</span>"
	else
		. += "<span class='warning'>It's missing a fishing line.</span>"

	if(hook)
		. += "<span class='info'>There's a [hook.name] on [src].</span>"
	else
		. += "<span class='warning'>It's missing a hook.</span>"

	if(line)
		. += "<span class='info'>There's a [line.name] on [src].</span>"

/obj/item/fishingrod/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -13,"sy" = 3,"nx" = 14,"ny" = 3,"wx" = -12,"wy" = 4,"ex" = 6,"ey" = 5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

#define FISHRARITYWEIGHTS list("com" = 70, "rare" = 20, "ultra" = 9, "gold" = 1)
#define FISHSIZEWEIGHTS list("tiny" = 4, "small" = 4, "normal" = 4, "large" = 2, "prize" = 1)


/obj/item/fishingrod/proc/reason_we_cant_fish(datum/fish_source/target_fish_source)
	return hook?.reason_we_cant_fish(target_fish_source)

///Called at the end of on_challenge_completed() once the reward has been spawned
/obj/item/fishingrod/proc/on_reward_caught(atom/movable/reward, mob/user)
	if(isnull(reward))
		return
	var/isfish = isfish(reward)
	// catching things that aren't fish or alive mobs doesn't consume baits.
	if(isnull(baited) || HAS_TRAIT(baited, TRAIT_BAIT_UNCONSUMABLE))
		return
	if(isliving(reward))
		var/mob/living/caught_mob = reward
		if(caught_mob.stat == DEAD)
			return
	else
		if(!isfish)
			return
		SEND_SIGNAL(user, COMSIG_FISH_CAUGHT)
		record_featured_stat(STATS_FISH_CAUGHT, user)
		var/obj/item/reagent_containers/food/snacks/fish/fish = reward
		if(HAS_TRAIT(baited, TRAIT_POISONOUS_BAIT) && !HAS_TRAIT(fish, TRAIT_FISH_TOXIN_IMMUNE))
			var/kill_fish = TRUE
			for(var/bait_identifer in fish.favorite_bait)
				if(is_matching_bait(baited, bait_identifer))
					kill_fish = FALSE
					break
			if(kill_fish)
				fish.set_status(FISH_DEAD, silent = TRUE)
		record_round_statistic(STATS_FISH_CAUGHT)
		record_featured_stat(FEATURED_STATS_FISHERS, user)

	qdel(baited)
	baited = null
	update_appearance()


/obj/item/fishingrod/interact(mob/user)
	if(currently_hooked)
		reel(user)

/obj/item/fishingrod/proc/reel(mob/user)
	if(DOING_INTERACTION_WITH_TARGET(user, currently_hooked))
		return

	playsound(src, SFX_REEL, 50, vary = FALSE)
	var/time = (0.8 - round(user.get_skill_level(/datum/skill/labor/fishing, TRUE) * 0.04, 0.1)) SECONDS * bait_speed_mult
	if(!do_after(user, time, currently_hooked, timed_action_flags = IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE, extra_checks = CALLBACK(src, PROC_REF(fishing_line_check))))
		return
	// nothing after this point should sleep (fingers crossed)

	if(currently_hooked.anchored || currently_hooked.move_resist >= MOVE_FORCE_STRONG)
		balloon_alert(user, "[currently_hooked.p_they()] won't budge!")
		return

	//About thirty minutes of non-stop reeling to get from zero to master... not worth it but hey, you do what you do.
	user.mind?.add_sleep_experience(/datum/skill/labor/fishing, time * 0.13 * experience_multiplier)

	//Try to move it 'till it's under the user's feet, then try to pick it up
	var/requires_vertical = (loc.z > currently_hooked.z)
	var/turf/our_turf = get_turf(src) // this probably shouldn't change during this proc... probably.
	if(isitem(currently_hooked))
		var/obj/item/item = currently_hooked
		var/turf/old_loc = get_turf(currently_hooked)
		step_towards(item, our_turf)
		if((old_loc == get_turf(currently_hooked)) && requires_vertical)
			ADD_TRAIT(currently_hooked, "hooked", type)
			currently_hooked.forceMove(GET_TURF_ABOVE(old_loc))
			addtimer(CALLBACK(src, PROC_REF(remove_hooked), currently_hooked), 1 SECONDS)
		if(item.loc == user.loc && (item.interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))
			user.put_in_inactive_hand(item)
			QDEL_NULL(fishing_line)
	//Not an item, so just delete the line if it's adjacent to the user.
	else if(get_dist(currently_hooked,our_turf) > 1)
		var/turf/old_loc = get_turf(currently_hooked)
		step_towards(currently_hooked, our_turf)
		if((old_loc == get_turf(currently_hooked)) && requires_vertical)
			ADD_TRAIT(currently_hooked, "hooked", type)
			currently_hooked.forceMove(GET_TURF_ABOVE(old_loc))
			addtimer(CALLBACK(src, PROC_REF(remove_hooked), currently_hooked), 1 SECONDS)
		if(get_dist(currently_hooked,our_turf) <= 1)
			QDEL_NULL(fishing_line)
	else
		QDEL_NULL(fishing_line)

/obj/item/fishingrod/proc/fishing_line_check()
	return !QDELETED(fishing_line)

/obj/item/fishingrod/proc/remove_hooked(atom/movable/hooked)
	REMOVE_TRAIT(hooked, "hooked", type)

/// Generates the fishing line visual from the current user to the target and updates inhands
/obj/item/fishingrod/proc/create_fishing_line(atom/movable/target, mob/living/firer, target_py = null)
	if(internal)
		return null
	if(fishing_line)
		QDEL_NULL(fishing_line)
	var/beam_color = line?.line_color || default_line_color
	fishing_line = new(firer, target, icon_state = "fishing_line", beam_color = beam_color, emissive = FALSE, override_target_pixel_y = target_py, time = INFINITY, render_on_z_levels = TRUE)
	fishing_line.lefthand = !(firer.get_held_index_of_item(src) % 2)
	RegisterSignal(fishing_line, COMSIG_BEAM_BEFORE_DRAW, PROC_REF(check_los))
	RegisterSignal(fishing_line, COMSIG_PARENT_QDELETING, PROC_REF(clear_line))
	INVOKE_ASYNC(fishing_line, TYPE_PROC_REF(/datum/beam/, Start))
	if(QDELETED(fishing_line))
		return null
	return fishing_line

/obj/item/fishingrod/proc/clear_line(datum/source)
	SIGNAL_HANDLER
	fishing_line = null
	currently_hooked = null

/obj/item/fishingrod/proc/get_cast_range(mob/living/user)
	. = max(cast_range, 1)
	user = user || loc
	if (!isliving(user) || !user.mind || !user.is_holding(src))
		return
	. += round(user.get_skill_level(/datum/skill/labor/fishing) * 0.3)
	return max(., 1)

/obj/item/fishingrod/dropped(mob/user, silent)
	. = ..()
	QDEL_NULL(fishing_line)

/// Hooks the item
/obj/item/fishingrod/proc/hook_item(mob/user, atom/target_atom)
	if(currently_hooked)
		return
	if(!hook.can_be_hooked(target_atom))
		return
	currently_hooked = target_atom
	create_fishing_line(target_atom, user)
	hook.hook_attached(target_atom, src)
	SEND_SIGNAL(src, COMSIG_FISHING_ROD_HOOKED_ITEM, target_atom, user)

// Checks fishing line for interruptions and range
/obj/item/fishingrod/proc/check_los(datum/beam/source)
	SIGNAL_HANDLER
	. = NONE

	var/atom/target = source.target
	if(source.target != loc.z)
		target = locate(target.x, target.y, loc.z)
	if(get_dist(target, loc) > get_cast_range())
		qdel(source)
		return BEAM_CANCEL_DRAW

/obj/item/fishingrod/afterattack(obj/target, mob/user, proximity_flag, list/modifiers)
	if(!check_allowed_items(target,target_self=1) \
	|| (user.used_intent.type != ROD_CAST && user.used_intent.type != ROD_AUTO) \
	|| user.doing() \
	|| !isliving(user) \
	|| !user.loc
	)
		return

	if(!hook)
		balloon_alert(user, "install a hook first!")
		return ..()

	// Reel in if able
	if(currently_hooked)
		reel(user)
		return ..()

	cast_line(target, user)

/// If the line to whatever that is is clear and we're not already busy, try fishing in it
/obj/item/fishingrod/proc/cast_line(atom/target, mob/user)
	if(casting || currently_hooked)
		return
	if(!hook)
		balloon_alert(user, "install a hook first!")
		return
	if(!COOLDOWN_FINISHED(src, casting_cd))
		return
	// Inside of storages, or camera weirdness
	if(target.z != user.z || !(target in view(user.client?.view || world.view, user)))
		return
	COOLDOWN_START(src, casting_cd, 1 SECONDS)
	// skip firing a projectile if the target is adjacent and can be reached (no order windows in the way),
	// otherwise it may end up hitting other things on its turf, which is problematic
	// especially for entities with the profound fisher component, which should only work on
	// proper fishing spots.
	if(target.Adjacent(user, null, null, 0))
		hook_hit(target, user)
		return
	casting = TRUE
	var/obj/projectile/fishing_cast/cast_projectile = new(get_turf(src))
	cast_projectile.range = get_cast_range()
	cast_projectile.owner = src
	cast_projectile.original = target
	cast_projectile.fired_from = src
	cast_projectile.firer = user
	cast_projectile.impacted = list(WEAKREF(user) = TRUE)
	cast_projectile.preparePixelProjectile(target, user)
	cast_projectile.fire()

/// Called by hook projectile when hitting things
/obj/item/fishingrod/proc/hook_hit(atom/atom_hit_by_hook_projectile, mob/user)
	if(!hook)
		return
	var/dropped = FALSE
	if(isopenspace(atom_hit_by_hook_projectile))
		dropped = TRUE
		while(isopenspace(atom_hit_by_hook_projectile))
			atom_hit_by_hook_projectile = GET_TURF_BELOW(atom_hit_by_hook_projectile) // we know this will always be a turf so no need for get_turf

	if(dropped)
		for(var/mob/living/mob in atom_hit_by_hook_projectile.contents)
			atom_hit_by_hook_projectile = mob
			dropped = FALSE
			break
	if(dropped)
		for(var/obj/item/mob in atom_hit_by_hook_projectile.contents)
			atom_hit_by_hook_projectile = mob
			dropped = FALSE
			break
	var/automated = (user.used_intent.type == ROD_AUTO)
	if(SEND_SIGNAL(atom_hit_by_hook_projectile, COMSIG_FISHING_ROD_CAST, src, user, automated) & FISHING_ROD_CAST_HANDLED)
		return
	/// If you can't fish in it, try hooking it
	hook_item(user, atom_hit_by_hook_projectile)


/obj/item/fishingrod/update_overlays()
	. = ..()
	. += get_fishing_overlays()

/obj/item/fishingrod/proc/get_fishing_overlays()
	. = list()
	var/line_color = line?.line_color || default_line_color
	/// Line part by the rod.
	if(reel_overlay)
		var/mutable_appearance/reel_appearance = mutable_appearance(icon, reel_overlay, appearance_flags = RESET_COLOR|KEEP_APART)
		reel_appearance.color = line_color
		. += reel_appearance

	// Line & hook is also visible when only bait is equipped but it uses default appearances then
	if(hook || baited)
		var/mutable_appearance/line_overlay = mutable_appearance(icon, "line_overlay", appearance_flags = RESET_COLOR|KEEP_APART)
		line_overlay.color = line_color
		. += line_overlay
		. += hook?.rod_overlay_icon_state || "hook_overlay"

	if(!baited)
		return
	var/obj/item/I = baited
	I.pixel_x = I.base_pixel_x + 6
	I.pixel_y = I.base_pixel_y - 6
	var/mutable_appearance/M = new /mutable_appearance(I)
	M.pixel_x = 6
	M.pixel_y = -6
	. += M

/obj/item/fishingrod/proc/get_frame(datum/fishing_challenge/challenge)
	return mutable_appearance('icons/hud/fishing_hud.dmi', frame_state)

/obj/item/fishingrod/fisher

/obj/item/fishingrod/fisher/Initialize(mapload, ...)
	. = ..()
	icon_state = "rod[rand(1,3)]"
	reel = new /obj/item/fishing/reel/silk(src)
	hook = new /obj/item/fishing/hook/iron(src)
	line = new /obj/item/fishing/line/bobber(src)




/obj/projectile/fishing_cast
	name = "fishing hook"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "hook_projectile"
	damage = 0
	range = 5
	can_hit_turfs = TRUE

	var/obj/item/fishingrod/owner
	var/datum/beam/our_line

/obj/projectile/fishing_cast/fire(angle, atom/direct_target)
	if(owner.hook)
		icon_state = owner.hook.icon_state
	. = ..()
	if(!QDELETED(src))
		our_line = owner.create_fishing_line(src, firer)

/obj/projectile/fishing_cast/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(blocked < 100)
		QDEL_NULL(our_line) //we need to delete the old beam datum, otherwise it won't let you fish.
		owner.hook_hit(target, firer)

/obj/projectile/fishing_cast/Destroy()
	QDEL_NULL(our_line)
	owner?.casting = FALSE
	owner = null
	return ..()

/datum/beam/fishing_line
	// Is the fishing rod held in left side hand
	var/lefthand = FALSE

	// Make these inline with final sprites
	var/righthand_s_px = 25
	var/righthand_s_py = 13

	var/righthand_e_px = 25
	var/righthand_e_py = 13

	var/righthand_w_px = -16
	var/righthand_w_py = 13

	var/righthand_n_px = -14
	var/righthand_n_py = 13

	var/lefthand_s_px = -25
	var/lefthand_s_py = 13

	var/lefthand_e_px = 16
	var/lefthand_e_py = 12

	var/lefthand_w_px = -25
	var/lefthand_w_py = 16

	var/lefthand_n_px = 25
	var/lefthand_n_py = 13

/datum/beam/fishing_line/Start()
	update_offsets(origin.dir)
	. = ..()
	RegisterSignal(origin, COMSIG_ATOM_DIR_CHANGE, PROC_REF(handle_dir_change))

/datum/beam/fishing_line/Destroy()
	UnregisterSignal(origin, COMSIG_ATOM_DIR_CHANGE)
	. = ..()

/datum/beam/fishing_line/proc/handle_dir_change(atom/movable/source, olddir, newdir)
	SIGNAL_HANDLER
	update_offsets(newdir)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/beam/, redrawing))

/datum/beam/fishing_line/proc/update_offsets(user_dir)
	switch(user_dir)
		if(SOUTH)
			override_origin_pixel_x = lefthand ? lefthand_s_px : righthand_s_px
			override_origin_pixel_y = lefthand ? lefthand_s_py : righthand_s_py
		if(EAST)
			override_origin_pixel_x = lefthand ? lefthand_e_px : righthand_e_px
			override_origin_pixel_y = lefthand ? lefthand_e_py : righthand_e_py
		if(WEST)
			override_origin_pixel_x = lefthand ? lefthand_w_px : righthand_w_px
			override_origin_pixel_y = lefthand ? lefthand_w_py : righthand_w_py
		if(NORTH)
			override_origin_pixel_x = lefthand ? lefthand_n_px : righthand_n_px
			override_origin_pixel_y = lefthand ? lefthand_n_py : righthand_n_py

	override_origin_pixel_x += origin.pixel_x
	override_origin_pixel_y += origin.pixel_y

#undef FISHRARITYWEIGHTS
#undef FISHSIZEWEIGHTS
