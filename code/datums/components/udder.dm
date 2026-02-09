/**
 * Udder component; for farm animals to generate milk.
 *
 * Used for cows, goats, gutlunches. neat!
 */
/datum/component/udder
	///abstract item for managing reagents (further down in this file)
	var/obj/item/udder/udder
	///optional proc to callback to when the udder is milked
	var/datum/callback/on_milk_callback

//udder_type and reagent_produced_typepath are typepaths, not reference
/datum/component/udder/Initialize(udder_type = /obj/item/udder, datum/callback/on_milk_callback, datum/callback/on_generate_callback, reagent_produced_typepath = /datum/reagent/consumable/milk)
	if(!isliving(parent)) //technically is possible to drop this on carbons... but you wouldn't do that to me, would you?
		return COMPONENT_INCOMPATIBLE
	udder = new udder_type(null)
	udder.add_features(parent, on_generate_callback, reagent_produced_typepath)
	src.on_milk_callback = on_milk_callback

/datum/component/udder/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))

/datum/component/udder/UnregisterFromParent()
	QDEL_NULL(udder)
	on_milk_callback = null
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_ATOM_ATTACKBY))

///signal called on parent being examined
/datum/component/udder/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/mob/living/milked = parent
	if(milked.stat != CONSCIOUS)
		return //come on now

	var/udder_filled_percentage = PERCENT(udder.reagents.total_volume / udder.reagents.maximum_volume)
	switch(udder_filled_percentage)
		if(0 to 10)
			examine_list += span_notice("[parent]'s [udder.name] is dry.")
		if(11 to 99)
			examine_list += span_notice("[parent]'s [udder.name] can be milked.")
		if(100)
			examine_list += span_notice("[parent]'s [udder.name] is round and full.")

///signal called on parent being attacked with an item
/datum/component/udder/proc/on_attackby(datum/source, obj/item/milking_tool, mob/user, list/modifiers)
	SIGNAL_HANDLER

	var/mob/living/milked = parent
	if(milked.stat == CONSCIOUS && istype(milking_tool, /obj/item/reagent_containers/glass) && user.used_intent?.type == INTENT_FILL)
		udder.milk(milking_tool, user)
		if(on_milk_callback)
			on_milk_callback.InvokeAsync(udder.reagents.total_volume, udder.reagents.maximum_volume)
		return COMPONENT_NO_AFTERATTACK

//................. UDDER .......................//
/**
 * # udder item
 *
 * Abstract item that is held in nullspace and manages reagents. Created by udder component.
 * While perhaps reagents created by udder component COULD be managed in the mob, it would be somewhat finnicky and I actually like the abstract udders.
 */
/obj/item/udder
	name = "udder"
	///typepath of reagent produced by the udder
	var/reagent_produced_typepath = /datum/reagent/consumable/milk
	///how much the udder holds
	var/size = 100
	///mob that has the udder component
	var/mob/living/udder_mob
	///optional proc to callback to when the udder generates milk
	var/datum/callback/on_generate_callback
	///do we require some food to generate milk?
	var/require_consume_type
	///how long does each food consumption allow us to make milk
	var/require_consume_timer = 2 MINUTES
	COOLDOWN_DECLARE(require_consume_cooldown)

/obj/item/udder/proc/add_features(parent, callback, reagent = /datum/reagent/consumable/milk)
	udder_mob = parent
	on_generate_callback = callback
	create_reagents(size)
	reagent_produced_typepath = reagent
	initial_conditions()
	if(isnull(require_consume_type))
		return
	RegisterSignal(udder_mob, COMSIG_HOSTILE_ATTACKINGTARGET, PROC_REF(on_mob_consume))
	RegisterSignal(udder_mob, COMSIG_ATOM_ATTACKBY, PROC_REF(on_mob_feed))

/obj/item/udder/proc/on_mob_consume(datum/source, atom/feed)
	SIGNAL_HANDLER

	if(!istype(feed, require_consume_type))
		return
	INVOKE_ASYNC(src, PROC_REF(handle_consumption), feed)
	return

/obj/item/udder/proc/on_mob_feed(datum/source, atom/used_item, mob/living/user)
	SIGNAL_HANDLER

	if(!istype(used_item, require_consume_type))
		return
	INVOKE_ASYNC(src, PROC_REF(handle_consumption), used_item, user)
	return COMPONENT_NO_AFTERATTACK

/obj/item/udder/proc/handle_consumption(atom/movable/food, mob/user)
	COOLDOWN_START(src, require_consume_cooldown, require_consume_timer)

/obj/item/udder/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)
	UnregisterSignal(udder_mob, list(COMSIG_HOSTILE_ATTACKINGTARGET, COMSIG_ATOM_ATTACKBY))
	udder_mob = null
	on_generate_callback = null

/obj/item/udder/process()
	if(isanimal(udder_mob))
		var/mob/living/simple_animal/simple_animal = udder_mob
		if(SEND_SIGNAL(simple_animal, COMSIG_MOB_RETURN_HUNGER) <= 0)
			return
	if(udder_mob.stat != DEAD)
		generate() //callback is on generate() itself as sometimes generate does not add new reagents, or is not called via process

/**
 * Proc called on creation separate from the reagent datum creation to allow for signalled milk generation instead of processing milk generation
 * also useful for changing initial amounts in reagent holder (cows start with milk, gutlunches start empty)
 */
/obj/item/udder/proc/initial_conditions()
	reagents.add_reagent(reagent_produced_typepath, rand(0,20))
	START_PROCESSING(SSobj, src)

/**
 * Proc called every 2 seconds from SSMobs to add whatever reagent the udder is generating.
 */
/obj/item/udder/proc/generate()
	if(!isnull(require_consume_type) && COOLDOWN_FINISHED(src, require_consume_cooldown))
		return
	// if(prob(95))
	// 	return
	// reagents.add_reagent(reagent_produced_typepath, rand(5, 10))
	reagents.add_reagent(reagent_produced_typepath, 1)
	if(on_generate_callback)
		on_generate_callback.Invoke(reagents.total_volume, reagents.maximum_volume)

/**
 * Proc called from attacking the component parent with the correct item, moves reagents into the glass basically.
 *
 * Arguments:
 * * obj/item/reagent_containers/cup/milk_holder - what we are trying to transfer the reagents to
 * * mob/user - who is trying to do this
 */
/obj/item/udder/proc/milk(obj/item/reagent_containers/milk_holder, mob/user)
	if(milk_holder.reagents.total_volume >= milk_holder.volume)
		to_chat(user, span_warning("[milk_holder] is full."))
		return
	var/transfered = reagents.trans_to(milk_holder, rand(5,10))
	if(transfered)
		user.visible_message(span_notice("[user] milks [src] using \the [milk_holder]."), span_notice("You milk [src] using \the [milk_holder]."))
		playsound(udder_mob, pick('sound/vo/mobs/cow/milking (1).ogg', 'sound/vo/mobs/cow/milking (2).ogg'), 33, TRUE, -1)
		udder_mob.Immobilize(1 SECONDS)
		if(isliving(user))
			var/mob/living/living = user
			living.Immobilize(0.9 SECONDS)
	else
		to_chat(user, span_warning("The udder is dry. Wait a bit longer..."))
	user.changeNext_move(1 SECONDS)
