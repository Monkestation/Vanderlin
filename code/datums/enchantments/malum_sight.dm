/datum/enchantment/malum_sight
	enchantment_name = "Malum's Eye"
	examine_text = "Through this I can see the sparkle of gemstones and ores."
	essence_recipe = list(
		/datum/thaumaturgical_essence/earth = 50,
	)
	required_type = list(/obj/item/clothing/face)
	var/active_item

/datum/enchantment/malum_sight/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/malum_sight/proc/on_equip(obj/item/i, mob/living/user, slot)
	if(!(slot & ITEM_SLOT_MASK))
		if(active_item)
			active_item = FALSE
			user.set_oresight(FALSE)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		user.set_oresight(TRUE)
		to_chat(user, span_notice("My legs feel much stronger."))

/datum/enchantment/malum_sight/proc/on_drop(obj/item/i, mob/living/user)
	if(enchanted_item.loc == user)
		return
	if(active_item)
		active_item = FALSE
		user.set_oresight(FALSE)

/mob/living/proc/set_oresight(state)
	var/datum/component/ore_sight/COS = GetComponent(/datum/component/ore_sight)
	if(!COS)
		AddComponent(/datum/component/ore_sight)
	if(COS)
		COS.toggle(null, state)

/datum/status_effect/buff/oresight
	id = "oresight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/oresight
	duration = -1

/atom/movable/screen/alert/status_effect/buff/oresight
	name = "Oresight"
	desc = "I focus in every few moments and sense the stone around me."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "intelligence"

/datum/component/ore_sight
	var/last_pulse
	var/range = 3
	var/interval = 3 SECONDS
	var/is_active = FALSE

/datum/component/ore_sight/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/M = parent
	if(!M.client)
		return COMPONENT_INCOMPATIBLE

/datum/component/ore_sight/process()
	if(is_active)
		if(world.time > (last_pulse + interval))
			mine_pulse()

/datum/component/ore_sight/proc/mine_pulse()
	last_pulse = world.time
	var/turf/origin = get_turf(parent)
	for(var/turf/closed/mineral/T in RANGE_TURFS(range, origin))
		if(T)
			var/obj/effect/temp_visual/fxtype
			switch(T.type)
				if(/turf/closed/mineral/random/med, /turf/closed/mineral/copper, /turf/closed/mineral/tin, /turf/closed/mineral/coal)
					fxtype = /obj/effect/temp_visual/medqualityore
				if(/turf/closed/mineral/random/high, /turf/closed/mineral/cinnabar, /turf/closed/mineral/iron, /turf/closed/mineral/gold, /turf/closed/mineral/silver)
					fxtype = /obj/effect/temp_visual/highqualityore
				if(/turf/closed/mineral/gemeralds)
					fxtype = /obj/effect/temp_visual/gemqualityore
				if(/turf/closed/mineral/bedrock)
					fxtype = /obj/effect/temp_visual/bedrockore
			if(fxtype)
				new fxtype(get_turf(T))
	for(var/obj/item/natural/rock/boulder in get_hear(range, origin))	// We detect boulders and their contents, too.
		if(boulder)
			var/obj/effect/temp_visual/fxtype
			switch(boulder.type)
				if(/obj/item/natural/rock/copper, /obj/item/natural/rock/tin, /obj/item/natural/rock/coal)
					fxtype = /obj/effect/temp_visual/medqualityore
				if(/obj/item/natural/rock/cinnabar, /obj/item/natural/rock/iron)
					fxtype = /obj/effect/temp_visual/highqualityore
				if(/obj/item/natural/rock/gold, /obj/item/natural/rock/silver, /obj/item/natural/rock/gemerald)
					fxtype = /obj/effect/temp_visual/gemqualityore
			if(fxtype)
				new fxtype(get_turf(boulder))

/datum/component/ore_sight/proc/toggle(state)
	if(state && state == is_active)
		is_active = state
	else
		is_active = !is_active
	var/msg = span_notice("Toggling Ore Sight [is_active ? "ON" : "OFF"].")
	var/mob/living/L = parent
	to_chat(L, msg)
	if(is_active)
		L.apply_status_effect(/datum/status_effect/buff/oresight)
		START_PROCESSING(SSdcs, src)
	else
		L.remove_status_effect(/datum/status_effect/buff/oresight)
		STOP_PROCESSING(SSdcs, src)

/obj/effect/temp_visual/medqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	dir = NORTH
	name = "useful ore"
	desc = "The stone here must contain something handy."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/highqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	dir = NORTH
	name = "valuable ore"
	desc = "The stone here must contain something pricy!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/gemqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	dir = NORTH
	name = "glittering ore"
	desc = "GEMS! I'M RICH!!!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/bedrockore
	icon = 'icons/effects/effects.dmi'
	icon_state = "purplesparkles"
	dir = NORTH
	name = "bedrock"
	desc = "The stone here's too hard to break."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18
