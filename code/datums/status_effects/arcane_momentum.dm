#define MOMENTUM_FILTER "momentum_glow"
#define MOMENTUM_DECAY_DELAY (8 SECONDS)
#define SECOND_PER_MOMENTUM (6 SECONDS) // Time between each stack lost during decay.
#define ARCANE_MIDDLE 3
#define ARCANE_SAFECAP 6

/atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	name = "Arcyne Momentum (0)"
	desc = "Melee strikes fuel arcyne power. Build momentum to unleash your power. Melee strikes grant 1 stack every 2 seconds. Certain abilities capable of striking multiple targets grant bonus momentum. Take care not to lose control."
	icon_state = "buff"

/datum/status_effect/buff/arcyne_momentum
	id = "arcyne_momentum"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	duration = -1
	tick_interval = 20
	status_type = STATUS_EFFECT_UNIQUE
	var/stacks = 0
	var/max_stacks = 10
	var/glow_colour = "#4a90d9"
	var/crackle_colour = "#7b5ea7"
	var/overcharge_threshold = 7
	var/overcharge_damage = 4
	var/is_overcharged = FALSE
	COOLDOWN_DECLARE(last_stack_time)
	COOLDOWN_DECLARE(last_decay_time)
	var/static/mutable_appearance/electricity_overlay
	var/obj/item/bound_weapon
	var/chant
	var/melee_gain_cooldown = 2 SECONDS
	COOLDOWN_DECLARE(last_melee_gain)

/datum/status_effect/buff/arcyne_momentum/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_stunned))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_knockdown))
	// Flag the mind so it persists through death/revival
	if(owner.mind)
		ADD_TRAIT(owner.mind, TRAIT_ARCYNE_MOMENTUM, "[type]")
	update_alert()

/datum/status_effect/buff/arcyne_momentum/on_remove()
	UnregisterSignal(owner, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN))
	if(chant == "unarmed")
		UnregisterSignal(owner, list(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK))
	if(is_overcharged)
		owner.cut_overlay(electricity_overlay)
	owner.remove_filter(MOMENTUM_FILTER)
	. = ..()

// Call this after setting chant to register the appropriate signals
/datum/status_effect/buff/arcyne_momentum/proc/set_chant(new_chant)
	// Unregister old unarmed signals if switching away
	if(chant == "unarmed" && new_chant != "unarmed")
		UnregisterSignal(owner, list(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK))
	chant = new_chant
	// Register unarmed signals if needed
	if(chant == "unarmed")
		RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
		RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_unarmed_item_attack))

/datum/status_effect/buff/arcyne_momentum/proc/on_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!isliving(target))
		return
	// Only punch intent builds momentum, not touch/shove/grab
	if(!istype(owner.used_intent, /datum/intent/unarmed/punch))
		return
	var/mob/living/victim = target
	if(victim == owner || victim.stat == DEAD)
		return
	if(COOLDOWN_FINISHED(src, last_melee_gain))
		return
	add_stacks(1)
	COOLDOWN_START(src, last_melee_gain, melee_gain_cooldown)

// Momentum from knuckle/katar hits — only if the weapon uses unarmed skill
/datum/status_effect/buff/arcyne_momentum/proc/on_unarmed_item_attack(mob/living/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return
	var/obj/item/weapon = user?.get_active_held_item()
	if(!weapon || !ispath(weapon.associated_skill, /datum/attribute/skill/combat/unarmed))
		return
	if(COOLDOWN_FINISHED(src, last_melee_gain))
		return
	add_stacks(1)
	COOLDOWN_START(src, last_melee_gain, melee_gain_cooldown)

/datum/status_effect/buff/arcyne_momentum/proc/on_stunned()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, UNLINT("M: 0/[max_stacks]"))
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("The shock breaks my concentration, all momentum lost!"))

/datum/status_effect/buff/arcyne_momentum/proc/on_knockdown()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, UNLINT("M: 0/[max_stacks]"))
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("I hit the ground, all momentum lost!"))

/datum/status_effect/buff/arcyne_momentum/proc/add_stacks(amount)
	var/old_stacks = stacks
	stacks = min(stacks + amount, max_stacks)
	COOLDOWN_START(src, last_stack_time, MOMENTUM_DECAY_DELAY)
	last_stack_time = world.time
	if(stacks == old_stacks)
		return
	owner.balloon_alert(owner, UNLINT("M: [stacks]/[max_stacks]"))
	update_visuals()
	update_alert()
	update_spell_buttons()
	if(old_stacks < ARCANE_MIDDLE && stacks >= ARCANE_MIDDLE)
		to_chat(owner, span_notice("Arcyne force gathers within me!"))
		playsound(get_turf(owner), 'sound/magic/charging.ogg', 30, TRUE)
	if(old_stacks < ARCANE_SAFECAP && stacks >= ARCANE_SAFECAP)
		to_chat(owner, span_warning("Release! I must ACT NOW!"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 50, TRUE)
	if(old_stacks < overcharge_threshold && stacks >= overcharge_threshold)
		to_chat(owner, span_boldwarning("POWER! POWER! POWER! UNLEASH! UNLEASH! UNLEASH!"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 70, TRUE)

/datum/status_effect/buff/arcyne_momentum/proc/consume_stacks(amount)
	var/consumed = min(stacks, amount)
	stacks = max(stacks - amount, 0)
	owner.balloon_alert(owner, UNLINT("M: [stacks]/[max_stacks]"))
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/consume_all_stacks()
	var/consumed = stacks
	stacks = 0
	owner.balloon_alert(owner, UNLINT("M: 0/[max_stacks]"))
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/update_visuals()
	owner.remove_filter(MOMENTUM_FILTER)
	if(stacks >= overcharge_threshold)
		owner.add_filter(MOMENTUM_FILTER, 2, outline_filter(2, crackle_colour))
	else if(stacks >= 6)
		owner.add_filter(MOMENTUM_FILTER, 2,outline_filter(2, crackle_colour))
	else if(stacks >= 3)
		owner.add_filter(MOMENTUM_FILTER, 2, outline_filter(1, glow_colour))
	if(stacks >= overcharge_threshold)
		if(!is_overcharged)
			enter_overcharge()
	else if(is_overcharged)
		exit_overcharge()

/datum/status_effect/buff/arcyne_momentum/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Arcyne Momentum ([stacks]/[max_stacks])"

/datum/status_effect/buff/arcyne_momentum/proc/update_spell_buttons()
	if(!owner?.mind)
		return
	for(var/datum/action/cooldown/spell/S in owner.actions)
		S.build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/status_effect/buff/arcyne_momentum/tick()
	if(stacks > 0 && COOLDOWN_FINISHED(src, last_stack_time))
		if(COOLDOWN_FINISHED(src, last_decay_time))
			COOLDOWN_START(src, last_decay_time, SECOND_PER_MOMENTUM)
			stacks = max(stacks - 1, 0)
			owner.balloon_alert(owner, UNLINT("M: [stacks]/[max_stacks]"))
			update_visuals()
			update_alert()
			update_spell_buttons()
	if(stacks >= overcharge_threshold)
		owner.apply_damage(overcharge_damage, BRUTE, BODY_ZONE_CHEST)
		owner.emote(pick("twitch", "strain"), forced = TRUE)

/datum/status_effect/buff/arcyne_momentum/proc/enter_overcharge()
	is_overcharged = TRUE
	if(!electricity_overlay)
		electricity_overlay = mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
		electricity_overlay.appearance_flags = RESET_COLOR
	owner.add_overlay(electricity_overlay)
	to_chat(owner, span_boldwarning("Electricity crackles across my body as arcyne energy overloads!"))

/datum/status_effect/buff/arcyne_momentum/proc/exit_overcharge()
	is_overcharged = FALSE
	owner.cut_overlay(electricity_overlay)

/mob/living/proc/get_arcyne_momentum()
	var/datum/status_effect/buff/arcyne_momentum/M = has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		return 0
	return M.stacks

#undef MOMENTUM_FILTER
#undef MOMENTUM_DECAY_DELAY
#undef SECOND_PER_MOMENTUM
#undef ARCANE_MIDDLE
#undef ARCANE_SAFECAP
