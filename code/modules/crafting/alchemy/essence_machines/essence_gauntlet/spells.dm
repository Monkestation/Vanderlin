// Motion + Air Combo Spells
/datum/action/cooldown/spell/essence/wind_step
	name = "Wind Step"
	desc = "Allows rapid movement by riding currents of air."
	button_icon_state = "wind_step"
	cast_range = 0
	point_cost = 6
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/aeromancy, /datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/wind_step/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] steps upon the wind itself."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/wind_walking, 30 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)

/datum/action/cooldown/spell/essence/aerial_dash
	name = "Aerial Dash"
	desc = "Provides a burst of speed through magical air currents."
	button_icon_state = "aerial_dash"
	cast_range = 0
	point_cost = 5
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/aeromancy, /datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/aerial_dash/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] is propelled by rushing air currents."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/aerial_speed, 15 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)

// Chaos + Void Combo Spells
/datum/action/cooldown/spell/essence/reality_shift
	name = "Reality Shift"
	desc = "Temporarily alters local reality in unpredictable ways."
	button_icon_state = "reality_shift"
	cast_range = 2
	point_cost = 8
	attunements = list(/datum/attunement/fire, /datum/attunement/fire)

/datum/action/cooldown/spell/essence/reality_shift/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] causes reality to shift and warp."))

	switch(rand(1, 6))
		if(1)
			target_turf.visible_message(span_warning("Gravity briefly reverses!"))
		if(2)
			target_turf.visible_message(span_notice("Colors shift and change!"))
		if(3)
			target_turf.visible_message(span_warning("Time seems to skip a beat!"))
		if(4)
			new /obj/effect/temp_visual/reality_crack(target_turf)
		if(5)
			playsound(target_turf, 'sound/magic/ethereal_exit.ogg', 50, TRUE)
		if(6)
			target_turf.visible_message(span_danger("Reality tears briefly!"))

/datum/action/cooldown/spell/essence/probability_warp
	name = "Probability Warp"
	desc = "Alters the likelihood of minor events occurring."
	button_icon_state = "probability_warp"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/fire, /datum/attunement/fire)

/datum/action/cooldown/spell/essence/probability_warp/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] warps probability in the local area."))

	for(var/mob/living/M in range(2, target_turf))
		M.apply_status_effect(/datum/status_effect/buff/probability_flux, 60 SECONDS)


// Magic + Crystal Combo Spells
/datum/action/cooldown/spell/essence/spell_crystal
	name = "Spell Crystal"
	desc = "Creates a crystal that can store and later release a spell."
	button_icon_state = "spell_crystal"
	cast_range = 1
	point_cost = 9
	attunements = list(/datum/attunement/light, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/spell_crystal/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a crystal capable of storing magical energy."))

	new /obj/item/spell_crystal(target_turf)

/datum/action/cooldown/spell/essence/arcane_focus
	name = "Arcane Focus"
	desc = "Creates a crystal focus that enhances magical abilities."
	button_icon_state = "arcane_focus"
	cast_range = 0
	point_cost = 8
	attunements = list(/datum/attunement/light, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/arcane_focus/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] creates an arcane focusing crystal."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/arcane_focus, 600 SECONDS)

// Energia + Motion Combo Spells
/datum/action/cooldown/spell/essence/kinetic_burst
	name = "Kinetic Burst"
	desc = "Releases stored energy as a burst of kinetic force."
	button_icon_state = "kinetic_burst"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/light, /datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/kinetic_burst/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] releases a burst of kinetic energy."))

	for(var/obj/item/I in range(1, target_turf))
		if(I.w_class <= WEIGHT_CLASS_NORMAL)
			var/distfromcaster = get_dist(owner, I)
			var/throwtarget = get_edge_target_turf(owner, get_dir(owner, get_step_away(I, owner)))
			I.safe_throw_at(throwtarget, ((CLAMP((5 - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, 5))), 1,owner, force = 5)


	var/obj/effect/temp_visual/kinetic_burst/burst = new(target_turf)
	QDEL_IN(burst, 5 SECONDS)

/datum/action/cooldown/spell/essence/momentum_transfer
	name = "Momentum Transfer"
	desc = "Transfers kinetic energy between objects or creatures."
	button_icon_state = "momentum_transfer"
	cast_range = 2
	point_cost = 6
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/light, /datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/momentum_transfer/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	owner.visible_message(span_notice("[owner] transfers momentum to [target]."))

	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/buff/momentum_boost, 30 SECONDS)
		new /obj/effect/temp_visual/snake/swarm(null, M)

// Cycle + Life Combo Spells
/datum/action/cooldown/spell/essence/regeneration_cycle
	name = "Regeneration Cycle"
	desc = "Establishes a cycle of continuous healing over time."
	button_icon_state = "regeneration_cycle"
	cast_range = 1
	point_cost = 8
	attunements = list(/datum/attunement/light, /datum/attunement/life)

/datum/action/cooldown/spell/essence/regeneration_cycle/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] begins a cycle of natural regeneration."))
	target.apply_status_effect(/datum/status_effect/buff/regeneration_cycle, 300 SECONDS)
	new /obj/effect/temp_visual/snake/twin_up(null, target)

/datum/action/cooldown/spell/essence/growth_acceleration
	name = "Growth Acceleration"
	desc = "Dramatically speeds up natural growth processes."
	button_icon_state = "growth_acceleration"
	cast_range = 2
	point_cost = 7
	attunements = list(/datum/attunement/light, /datum/attunement/life)

/datum/action/cooldown/spell/essence/growth_acceleration/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] accelerates natural growth in the area."))

	for(var/obj/structure/soil/plant in range(1, target_turf))
		plant.accellerated_growth = world.time + 600 SECONDS
		new /obj/effect/temp_visual/bless_swirl(get_turf(plant))

// RACIAL COMBO SPELLS

// Dwarf Racial Spells
/datum/action/cooldown/spell/essence/create_beer
	name = "Create Beer"
	desc = "A dwarven secret - transforms water and grain into fine ale."
	button_icon_state = "create_beer"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/earth, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/create_beer/cast(atom/cast_on)
	. = ..()
	var/atom/movable/target = cast_on
	owner.visible_message(span_notice("[owner] works dwarven brewing magic."))

	if(isopenturf(target))
		var/turf/open/open = target
		if(open.liquids)
			var/water_amount = open.liquids.liquid_group.reagents.get_reagent_amount(/datum/reagent/water)
			if(water_amount)
				open.liquids.liquid_group.remove_specific(open.liquids, water_amount, /datum/reagent/water)
				open.liquids.liquid_group.add_reagent(open.liquids, /datum/reagent/consumable/ethanol/beer, water_amount)
			else
				open.liquids.liquid_group.add_reagent(open.liquids, /datum/reagent/consumable/ethanol/beer, 20)
		else
			open.add_liquid(/datum/reagent/consumable/ethanol/beer, 20)
	else if(istype(target, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/glass = target
		glass.reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 20)

/datum/action/cooldown/spell/essence/master_forge
	name = "Master Forge"
	desc = "Creates a temporary forge of legendary dwarven quality."
	button_icon_state = "master_forge"
	cast_range = 2
	point_cost = 8
	attunements = list(/datum/attunement/fire, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/master_forge/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a forge worthy of the greatest dwarven smiths."))

	var/obj/machinery/light/fueled/forge/arcane/forge = new(target_turf)
	QDEL_IN(forge, 1800 SECONDS)

/datum/action/cooldown/spell/essence/ancestral_smithing
	name = "Ancestral Smithing"
	desc = "Channels the spirits of ancient dwarven smiths to guide crafting."
	button_icon_state = "ancestral_smithing"
	cast_range = 0
	point_cost = 7
	attunements = list(/datum/attunement/fire, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/ancestral_smithing/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] calls upon the wisdom of ancient dwarven smiths."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/ancestral_smithing, 600 SECONDS)

// Elf Racial Spells
/datum/action/cooldown/spell/essence/elven_grace
	name = "Elven Grace"
	desc = "Grants the ethereal grace and agility of the ancient elves."
	button_icon_state = "elven_grace"
	cast_range = 0
	point_cost = 6
	attunements = list(/datum/attunement/life, /datum/attunement/light)

/datum/action/cooldown/spell/essence/elven_grace/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] moves with the grace of the ancient elves."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/elven_grace, 300 SECONDS)

// Human Racial Spells
/datum/action/cooldown/spell/essence/balanced_mind
	name = "Balanced Mind"
	desc = "Achieves perfect mental balance between order and chaos."
	button_icon_state = "balanced_mind"
	cast_range = 0
	point_cost = 6
	attunements = list(/datum/attunement/earth, /datum/attunement/fire)

/datum/action/cooldown/spell/essence/balanced_mind/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] achieves perfect mental equilibrium."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/balanced_mind, 450 SECONDS)

// Supporting structures and items for the new spells
/obj/effect/temp_visual/brilliant_flame
	name = "brilliant flame"
	desc = "A flame that burns with intense light and heat."
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	duration = 120 SECONDS

/obj/effect/temp_visual/brilliant_flame/Initialize()
	. = ..()
	propagate_temp_change(30, 8, 0.6, 3) // Moderate heat, good cast_range

/obj/effect/temp_visual/brilliant_flame/Destroy()
	remove_temp_effect()
	return ..()

/obj/effect/temp_visual/mist_veil
	name = "concealing mist"
	desc = "A veil of mist that provides concealment."
	icon = 'icons/effects/effects.dmi'
	icon_state = "mist"
	duration = 60 SECONDS

/obj/effect/temp_visual/reality_crack
	name = "reality crack"
	desc = "A brief tear in the fabric of reality."
	icon = 'icons/effects/effects.dmi'
	icon_state = "reality_crack"
	duration = 10 SECONDS

/obj/effect/temp_visual/kinetic_burst
	name = "kinetic burst"
	desc = "A burst of pure kinetic energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "kinetic_wave"
	duration = 5 SECONDS

// Additional supporting items and structures
/obj/item/reagent_containers/glass/bottle/antidote
	name = "universal antidote"
	desc = "A potent brew that counters multiple types of poison."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle_green"

/obj/item/reagent_containers/glass/bottle/antidote/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/antidote, 50)

/obj/item/spell_crystal
	name = "spell storage crystal"
	desc = "A crystal capable of storing magical energy for later use."
	icon_state = "crystal_blue"
	w_class = WEIGHT_CLASS_SMALL
	var/stored_spell = null
	var/stored_charges = 0

// Status effects for the spell buffs
/datum/status_effect/buff/wind_walking
	id = "wind_walking"
	alert_type = /atom/movable/screen/alert/status_effect/wind_walking
	duration = 30 SECONDS

/datum/status_effect/buff/wind_walking/on_apply()
	. = ..()
	owner.add_movespeed_modifier("wind_walking", multiplicative_slowdown = -0.3)
	to_chat(owner, span_notice("You step upon the wind itself!"))

/datum/status_effect/buff/wind_walking/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("wind_walking")

/datum/status_effect/buff/aerial_speed
	id = "aerial_speed"
	alert_type = /atom/movable/screen/alert/status_effect/aerial_speed
	duration = 15 SECONDS

/datum/status_effect/buff/aerial_speed/on_apply()
	. = ..()
	owner.add_movespeed_modifier("aerial_speed", multiplicative_slowdown = -0.5)
	to_chat(owner, span_notice("Air currents propel you forward!"))

/datum/status_effect/buff/aerial_speed/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("aerial_speed")

/datum/status_effect/buff/probability_flux
	id = "probability_flux"
	alert_type = /atom/movable/screen/alert/status_effect/probability_flux
	duration = 60 SECONDS
	effectedstats = list(STATKEY_LCK = 2)

/datum/status_effect/buff/arcane_focus
	id = "arcane_focus"
	alert_type = /atom/movable/screen/alert/status_effect/arcane_focus
	duration = 600 SECONDS

/datum/status_effect/buff/arcane_focus/on_apply()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		for(var/datum/action/cooldown/spell/spell in L.actions)
			spell.charge_required = FALSE
		to_chat(owner, span_notice("Your magical focus intensifies!"))

/datum/status_effect/buff/arcane_focus/on_remove()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		for(var/datum/action/cooldown/spell/spell in L.actions)
			spell.charge_required = initial(spell.charge_required)
		to_chat(owner, span_notice("Your magical focus returns to normal!"))

/datum/status_effect/buff/momentum_boost
	id = "momentum_boost"
	alert_type = /atom/movable/screen/alert/status_effect/momentum_boost
	duration = 30 SECONDS

/datum/status_effect/buff/momentum_boost/on_apply()
	. = ..()
	owner.add_movespeed_modifier("momentum", multiplicative_slowdown = -0.4)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("Kinetic energy surges through you!"))

/datum/status_effect/buff/momentum_boost/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("momentum")
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/regeneration_cycle
	id = "regeneration_cycle"
	alert_type = /atom/movable/screen/alert/status_effect/regeneration_cycle
	duration = 300 SECONDS
	tick_interval = 10 SECONDS

/datum/status_effect/buff/regeneration_cycle/tick()
	if(owner.health < owner.maxHealth)
		owner.adjustBruteLoss(-1)
		owner.adjustFireLoss(-1)

/datum/status_effect/buff/ancestral_smithing
	id = "ancestral_smithing"
	alert_type = /atom/movable/screen/alert/status_effect/ancestral_smithing
	duration = 600 SECONDS

/datum/status_effect/buff/elven_grace
	id = "elven_grace"
	alert_type = /atom/movable/screen/alert/status_effect/elven_grace
	duration = 300 SECONDS

/datum/status_effect/buff/elven_grace/on_apply()
	. = ..()
	owner.add_movespeed_modifier("elven_grace", multiplicative_slowdown = -0.2)

/datum/status_effect/buff/elven_grace/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("elven_grace")

/datum/status_effect/buff/balanced_mind
	id = "balanced_mind"
	alert_type = /atom/movable/screen/alert/status_effect/balanced_mind
	duration = 450 SECONDS
	var/balance_value = 10 // What value to balance all stats to
	var/source_key

/datum/status_effect/buff/balanced_mind/on_apply()
	. = ..()
	if(!owner)
		return
	source_key = "balanced_mind_[ref(src)]"
	owner.set_stat_modifier(source_key, STATKEY_STR, balance_value - owner.STASTR)
	owner.set_stat_modifier(source_key, STATKEY_PER, balance_value - owner.STAPER)
	owner.set_stat_modifier(source_key, STATKEY_END, balance_value - owner.STAEND)
	owner.set_stat_modifier(source_key, STATKEY_CON, balance_value - owner.STACON)
	owner.set_stat_modifier(source_key, STATKEY_INT, balance_value - owner.STAINT)
	owner.set_stat_modifier(source_key, STATKEY_SPD, balance_value - owner.STASPD)
	owner.set_stat_modifier(source_key, STATKEY_LCK, balance_value - owner.STALUC)

/datum/status_effect/buff/balanced_mind/on_remove()
	. = ..()
	if(!owner || !source_key)
		return
	owner.set_stat_modifier(source_key, STATKEY_STR, 0)
	owner.set_stat_modifier(source_key, STATKEY_PER, 0)
	owner.set_stat_modifier(source_key, STATKEY_END, 0)
	owner.set_stat_modifier(source_key, STATKEY_CON, 0)
	owner.set_stat_modifier(source_key, STATKEY_INT, 0)
	owner.set_stat_modifier(source_key, STATKEY_SPD, 0)
	owner.set_stat_modifier(source_key, STATKEY_LCK, 0)

/atom/movable/screen/alert/status_effect/wind_walking
	name = "Wind Walking"
	desc = "You step upon the wind itself, moving with supernatural grace."
	icon_state = "wind_walking"

/atom/movable/screen/alert/status_effect/aerial_speed
	name = "Aerial Speed"
	desc = "Air currents propel you forward with incredible speed."
	icon_state = "aerial_speed"

/atom/movable/screen/alert/status_effect/probability_flux
	name = "Probability Flux"
	desc = "The odds seem to be in your favor... or against you."
	icon_state = "probability_flux"

/atom/movable/screen/alert/status_effect/arcane_focus
	name = "Arcane Focus"
	desc = "Your magical abilities are enhanced by arcane focus."
	icon_state = "arcane_focus"

/atom/movable/screen/alert/status_effect/momentum_boost
	name = "Momentum Boost"
	desc = "Kinetic energy flows through you, enhancing your movement."
	icon_state = "momentum_boost"

/atom/movable/screen/alert/status_effect/regeneration_cycle
	name = "Regeneration Cycle"
	desc = "Your body continuously heals itself through natural cycles."
	icon_state = "regeneration_cycle"

/atom/movable/screen/alert/status_effect/ancestral_smithing
	name = "Ancestral Smithing"
	desc = "The spirits of ancient dwarven smiths guide your craft."
	icon_state = "ancestral_smithing"

/atom/movable/screen/alert/status_effect/elven_grace
	name = "Elven Grace"
	desc = "You move with the ethereal grace of the ancient elves."
	icon_state = "elven_grace"

/atom/movable/screen/alert/status_effect/balanced_mind
	name = "Balanced Mind"
	desc = "Perfect mental equilibrium between order and chaos."
	icon_state = "balanced_mind"

/atom/movable/screen/alert/status_effect/wind_walking
	name = "Wind Walking"
	desc = "You move with supernatural speed on air currents."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/aerial_speed
	name = "Aerial Speed"
	desc = "Air currents propel you forward rapidly."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/probability_flux
	name = "Probability Flux"
	desc = "Reality bends around you in unpredictable ways."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/arcane_focus
	name = "Arcane Focus"
	desc = "Your magical abilities are enhanced."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/momentum_boost
	name = "Momentum Boost"
	desc = "Kinetic energy surges through you."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/regeneration_cycle
	name = "Regeneration Cycle"
	desc = "Your body heals itself continuously."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/accelerated_growth
	name = "Accelerated Growth"
	desc = "Growth processes are dramatically sped up."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/ancestral_smithing
	name = "Ancestral Smithing"
	desc = "The spirits of ancient smiths guide your hands."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/elven_grace
	name = "Elven Grace"
	desc = "You move with ethereal grace and agility."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/nature_communion
	name = "Nature Communion"
	desc = "You are deeply connected to the natural world."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/balanced_mind
	name = "Balanced Mind"
	desc = "Your mind is in perfect equilibrium."
	icon_state = "buff"
