///LAVA

/turf/open/lava
	name = "lava"
	icon = 'icons/turf/floors.dmi'
	icon_state = "lava"
	gender = PLURAL //"That's some lava."
	baseturfs = /turf/open/lava //lava all the way down
	slowdown = 2

	light_outer_range =  4
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	bullet_bounce_sound = 'sound/blank.ogg'

	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_FLOOR_LIQUID
	smoothing_list = SMOOTH_GROUP_OPEN_FLOOR
	neighborlay_self = "lavedge"
	turf_flags = NONE
	var/flow = FALSE
	/// How much fire damage we deal to living mobs stepping on us
	var/lava_damage = 50
	/// How many firestacks we add to living mobs stepping on us
	var/lava_firestacks = 10
	/// How much temperature we expose objects with
	var/temperature_damage = 10000
	/// mobs with this trait won't burn.
	var/immunity_trait = TRAIT_LAVA_IMMUNE
	/// objects with these flags won't burn.
	var/immunity_resistance_flags = LAVA_PROOF

/turf/open/lava/flow
	icon_state = "flowing-lava"
	flow = TRUE

/turf/open/lava/Initialize()
	. = ..()
	if(flow)
		return
	dir = pick(GLOB.cardinals)

/turf/open/lava/ex_act(severity, target)
	contents_explosion(severity, target)

/turf/open/lava/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/lava/Melt()
	to_be_destroyed = FALSE
	return src

/turf/open/lava/acid_act(acidpwr, acid_volume)
	return

/turf/open/lava/MakeDry(wet_setting = TURF_WET_WATER)
	return

/turf/open/lava/Entered(atom/movable/AM)
	. = ..()
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)
		if(ishuman(AM))
			playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)

/turf/open/lava/Exited(atom/movable/Obj, atom/newloc)
	. = ..()
	if(isliving(Obj))
		var/mob/living/L = Obj
		if(!islava(newloc) && !L.on_fire)
			L.update_fire()

/turf/open/lava/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)

/turf/open/lava/process()
	if(!burn_stuff(null))
		STOP_PROCESSING(SSobj, src)

/turf/open/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/stone_tile))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)

///Generic return value of the can_burn_stuff() proc. Does nothing.
#define LAVA_BE_IGNORING 0
/// Another. Won't burn the target but will make the turf start processing.
#define LAVA_BE_PROCESSING 1
/// Burns the target and makes the turf process (depending on the return value of do_burn()).
#define LAVA_BE_BURNING 2

/turf/open/lava/can_traverse_safely(atom/movable/traveler)
	return ..() && !can_burn_stuff(traveler) // can traverse safely if you won't burn in it

///Proc that sets on fire something or everything on the turf that's not immune to lava. Returns TRUE to make the turf start processing.
/turf/open/lava/proc/burn_stuff(atom/movable/to_burn)
	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (to_burn)
		thing_to_check = list(to_burn)
	for(var/atom/movable/burn_target as anything in thing_to_check)
		switch(can_burn_stuff(burn_target))
			if(LAVA_BE_IGNORING)
				continue
			if(LAVA_BE_BURNING)
				if(!do_burn(burn_target))
					continue
		. = TRUE

/turf/open/lava/proc/can_burn_stuff(atom/movable/burn_target)
	if(burn_target.movement_type & (FLYING|FLOATING)) //you're flying over it.
		return LAVA_BE_IGNORING

	if(burn_target.throwing)
		return LAVA_BE_IGNORING

	if(burn_target.invisibility >= INVISIBILITY_LIGHTING)
		return LAVA_BE_IGNORING

	if(isobj(burn_target))
		var/obj/burn_obj = burn_target
		if((burn_obj.resistance_flags & immunity_resistance_flags))
			return LAVA_BE_PROCESSING
		return LAVA_BE_BURNING

	if(!isliving(burn_target))
		return LAVA_BE_IGNORING

	if(HAS_TRAIT(burn_target, immunity_trait))
		return LAVA_BE_PROCESSING
	var/mob/living/burn_living = burn_target
	var/atom/movable/burn_buckled = burn_living.buckled
	if(burn_buckled)
		if(burn_buckled.movement_type & (FLYING|FLOATING))
			return LAVA_BE_PROCESSING
		if(isobj(burn_buckled))
			var/obj/burn_buckled_obj = burn_buckled
			if(burn_buckled_obj.resistance_flags & immunity_resistance_flags)
				return LAVA_BE_PROCESSING
		else if(HAS_TRAIT(burn_buckled, immunity_trait))
			return LAVA_BE_PROCESSING

	if(iscarbon(burn_living))
		var/mob/living/carbon/burn_carbon = burn_living
		var/obj/item/clothing/burn_suit = burn_carbon.get_item_by_slot(ITEM_SLOT_ARMOR)
		var/obj/item/clothing/burn_helmet = burn_carbon.get_item_by_slot(ITEM_SLOT_HEAD)
		if(burn_suit?.clothing_flags & LAVAPROTECT && burn_helmet?.clothing_flags & LAVAPROTECT)
			return LAVA_BE_PROCESSING

	return LAVA_BE_BURNING

#undef LAVA_BE_IGNORING
#undef LAVA_BE_PROCESSING
#undef LAVA_BE_BURNING

/turf/open/lava/proc/do_burn(atom/movable/burn_target)
	if(QDELETED(burn_target))
		return FALSE

	if(isobj(burn_target))
		var/obj/burn_obj = burn_target
		if(burn_obj.resistance_flags & ON_FIRE) // already on fire; skip it.
			return TRUE
		if(!(burn_obj.resistance_flags & FLAMMABLE))
			burn_obj.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
		if(burn_obj.resistance_flags & FIRE_PROOF)
			burn_obj.resistance_flags &= ~FIRE_PROOF
		if(burn_obj.armor?.getRating("fire") > 50) //obj with 100% fire armor still get slowly burned away.
			burn_obj.armor.setRating(fire = 50)
		burn_obj.fire_act(temperature_damage, 1000)
		if(QDELETED(burn_obj))
			return FALSE
		burn_obj.take_damage(burn_obj.max_integrity * 0.1, BURN, "fire", 0) // fire_act damage is clamped
		if(istype(burn_obj, /obj/structure/closet))
			for(var/burn_content in burn_target)
				burn_stuff(burn_content)
		// qdel(O)
		return TRUE

	if(isliving(burn_target))
		var/mob/living/burn_living = burn_target
		burn_living.adjust_fire_stacks(lava_firestacks)
		burn_living.IgniteMob()
		burn_living.adjustFireLoss(lava_damage)
		if(burn_living.health <= 0)
			burn_living.dust(drop_items = TRUE)
		return TRUE

	return FALSE

/turf/open/lava/acid
	name = "acid"
	icon_state = "acid"
	light_outer_range =  4
	light_power = 1
	light_color = "#56ff0d"
	immunity_resistance_flags = ACID_PROOF
	immunity_trait = TRAIT_ACID_IMMUNE

/turf/open/lava/acid/do_burn(atom/movable/burn_target)
	if(QDELETED(burn_target))
		return FALSE

	if(isobj(burn_target))
		var/obj/burn_obj = burn_target
		burn_obj.take_damage(burn_obj.max_integrity * 0.25, BURN, "acid", 0)
		return TRUE

	if(isliving(burn_target))
		var/mob/living/burn_living = burn_target
		if(iscarbon(burn_target))
			var/mob/living/carbon/burn_carbon = burn_target
			//make this acid
			var/shouldupdate = FALSE
			for(var/obj/item/bodypart/B in burn_carbon.bodyparts)
				if(!B.skeletonized && B.is_organic_limb())
					B.skeletonize()
					shouldupdate = TRUE
			if(shouldupdate)
				if(ishuman(burn_carbon))
					var/mob/living/carbon/human/burn_human = burn_carbon
					burn_human.underwear = "Nude"
				burn_carbon.unequip_everything()
				burn_carbon.update_body()
			return FALSE // so we dont dust skeletons
		burn_living.dust(drop_items = TRUE)
		return TRUE

	return FALSE
