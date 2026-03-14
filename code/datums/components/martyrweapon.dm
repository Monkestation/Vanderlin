#define STATE_SAFE 0
#define STATE_MARTYR 1
#define STATE_MARTYR_ULT 2

/datum/component/martyr_weapon
	/// Areas in which activation is allowed
	var/list/allowed_areas = list(/area/indoors/town/church/chapel)
	/// Patrons which are allowed to hold
	var/list/allowed_patrons = list(/datum/patron/divine/ravox)
	/// Jobs which are allowed to hold
	var/list/allowed_jobs = list(/datum/job/gmtemplar)

	/// Prob to ignite the user on use
	var/ignite_chance = 2

	/// Allow anyone to use this (Limited to STATE_SAFE)
	var/allow_all = FALSE

	/// Active intents
	var/list/active_intents = list()
	var/list/active_intents_wielded = list()
	// Cache because no initial for lists
	var/list/inactive_intents = list()
	var/list/inactive_intents_wielded = list()

	/// Base active damage
	var/active_safe_damage
	var/active_safe_damage_wielded

	var/static/alist/durations = alist(
		STATE_SAFE = 9 MINUTES,
		STATE_MARTYR = 6 MINUTES,
		STATE_MARTYR_ULT = 2 MINUTES,
	)

	COOLDOWN_DECLARE(weapon_activate)

	/// Guy currently using us
	var/mob/living/bound_user = null
	/// Cached cmode music so we don't override in the end
	var/cmode_music_cache = null

	/// Item is currently active
	var/is_active = FALSE
	/// Current state of activation
	var/current_state = STATE_SAFE
	/// All stat bonus to apply when state > STATE_SAFE
	var/stat_bonus_martyr = 3
	/// Traits to apply when active
	var/traits_applied = list(TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_LONGSTRIDER)

	/// Timer ID of the active timer
	var/active_timer = null

/datum/component/martyr_weapon/New()
	. = ..()
	allowed_areas = typecacheof(allowed_areas)
	allowed_patrons = typecacheof(allowed_patrons)
	allowed_jobs = typecacheof(allowed_jobs)

/datum/component/martyr_weapon/Initialize(list/intents, list/intents_w, active_damage, active_damage_wielded)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(length(intents))
		active_intents = intents.Copy()
	if(length(intents_w))
		active_intents_wielded = intents_w.Copy()

	if(active_damage)
		active_safe_damage = active_damage
	if(active_damage_wielded)
		active_safe_damage_wielded = active_damage_wielded

	var/obj/item/I = parent
	inactive_intents = I.possible_item_intents.Copy()
	inactive_intents_wielded = I.gripped_intents.Copy()

/datum/component/martyr_weapon/Destroy(force)
	if(active_timer)
		deltimer(active_timer)
	deactivate(bound_user)
	bound_user = null
	STOP_PROCESSING(SSdcs, src)
	return ..()

/datum/component/martyr_weapon/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF_SECONDARY, PROC_REF(try_activate))

/datum/component/martyr_weapon/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_AFTERATTACK, COMSIG_ITEM_ATTACK_SELF_SECONDARY, COMSIG_PARENT_EXAMINE))

/datum/component/martyr_weapon/process()
	if(!is_active || !bound_user)
		return PROCESS_KILL

	var/time_left = round(timeleft(active_timer), 10)
	if(time_left <= 0)
		return PROCESS_KILL

	if(current_state != STATE_SAFE && time_left <= 10 SECONDS)
		if((time_left % 100) == 0)
			bound_user.balloon_alert(bound_user, "<font color='#e32323'>my time is nigh! 10 seconds!</font>")
			return

		bound_user.balloon_alert(bound_user, "<font color='#e32323'>[time2text(round(time_left), "ss", 0)]!</font>")
		return

	if((time_left % 300) != 0)
		return

	bound_user.balloon_alert(bound_user, "[time2text(time_left, "mm:ss", 0)] remains")

/datum/component/martyr_weapon/proc/on_equip(datum/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_HANDS))
		return

	if(bound_user)
		return

	if(allow_all)
		bind_mob(user)
		return

	if(user.mob_biotypes & (MOB_UNDEAD | MOB_BEAST))
		to_chat(user, span_warning("It burns and sizzles! It does not tolerate my pallid flesh!"))
		user.dropItemToGround(parent)
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/datum/job/J = SSjob.GetJob(H.job)
		if(!allowed_jobs[J.type])
			to_chat(H, span_warning("It slips from my grasp. I can't get a hold."))
			H.dropItemToGround(parent)
			return

		if(!allowed_patrons[H.patron.type])
			to_chat(H, span_warning("It slips from my grasp. I can't get a hold."))
			H.dropItemToGround(parent)
			return

	bind_mob(user)

/datum/component/martyr_weapon/proc/bind_mob(mob/living/bound)
	if(bound == bound_user)
		return

	if(bound_user)
		UnregisterSignal(bound_user, COMSIG_PARENT_QDELETING)
		deactivate(bound_user)

	bound_user = bound

	RegisterSignal(bound_user, COMSIG_PARENT_QDELETING, PROC_REF(bound_deleted))

	if(bound_user)
		to_chat(bound_user, SPAN_GOD_ASTRATA("The weapon binds to you."))

/datum/component/martyr_weapon/proc/bound_deleted()
	SIGNAL_HANDLER

	bind_mob(null)

/datum/component/martyr_weapon/proc/on_drop(datum/source, mob/living/user)
	SIGNAL_HANDLER

	bind_mob(null)

/datum/component/martyr_weapon/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(is_active)
		if(user == bound_user)
			examine_list += span_warningbig(span_bold("SLAY THE HERETICS! TAKE THEM WITH YOU!"))
		else
			examine_list += span_warningbig("It is lit aflame by godly energies!")
		return

	if(bound_user == user)
		examine_list += span_notice("It looks to be bound to you. Use in hand with right click to activate it.")

	if(!COOLDOWN_FINISHED(src, weapon_activate))
		examine_list += span_notice("The time remaining until it is prepared: [time2text(COOLDOWN_TIMELEFT(src, weapon_activate), "mm ss", 0)]")
	else
		examine_list += span_notice("It looks ready to be used again.")

/datum/component/martyr_weapon/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, list/modifiers)
	SIGNAL_HANDLER

	if(!is_active || !proximity_flag)
		return

	if(isobj(target))
		target.spark_act()
		target.fire_act(1, 3)

	if(prob(ignite_chance) && isliving(target) && current_state != STATE_SAFE)
		var/mob/living/M = target
		M.adjust_divine_fire_stacks(5)
		M.IgniteMob()

/datum/component/martyr_weapon/proc/try_activate(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER

	. = COMPONENT_CANCEL_ATTACK_CHAIN

	if(user != bound_user)
		return

	if(user.get_active_held_item() != parent)
		to_chat(user, span_info("You must be holding the weapon in your active hand!"))
		return

	if(is_active || !COOLDOWN_FINISHED(src, weapon_activate))
		return

	if(allow_all)
		INVOKE_ASYNC(src, PROC_REF(activate), user, STATE_SAFE)
		return

	INVOKE_ASYNC(src, PROC_REF(take_oath), user)

/// Real activation because we have input
/datum/component/martyr_weapon/proc/take_oath(mob/living/user)
	var/area/A = get_area(user)
	if(!length(allowed_areas) || allowed_areas[A])
		var/string = "You are within holy grounds. Do you wish to call your god to aid in its defense? (You will live if the duration ends within the Church.)"
		if(tgui_alert(user, string, "OATH", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
			return
		activate(user, STATE_SAFE)
		return

	var/string = "You pray to your god. How many minutes will you ask for? (Shorter length means greater boons)"
	var/choice = tgui_alert(user, string, "OATH", list("Six", "Two", "It's not time"))
	if(!choice || QDELETED(src) || QDELETED(user))
		return

	switch(choice)
		if("Six")
			activate(user, STATE_MARTYR)
		if("Two")
			activate(user, STATE_MARTYR_ULT)

//This is called once all the checks are passed and the options are made by the player to commit.
/datum/component/martyr_weapon/proc/activate(mob/living/user, status_flag = STATE_SAFE)
	user.visible_message(
		span_notice("[user] begins invoking [user.p_their()] Oath!"),
		span_notice("You begin to invoke your oath."),
	)
	if(!do_after(user, 5 SECONDS, parent))
		return

	START_PROCESSING(SSdcs, src)
	COOLDOWN_START(src, weapon_activate, 30 MINUTES)

	is_active = TRUE

	current_state = status_flag

	//You're committed, now.
	flash_lightning(user)

	activate_weapon(parent, user)
	activate_holder(user)

	active_timer = addtimer(CALLBACK(src, PROC_REF(duration_ended), user), durations[current_state], flags = TIMER_STOPPABLE)

	if(current_state != STATE_MARTYR_ULT)
		return

	// We dying
	user.adjust_skill_level(/datum/attribute/skill/misc/athletics, 60)
	user.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
	user.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
	user.adjust_skill_level(/datum/attribute/skill/combat/polearms, 10)

/datum/component/martyr_weapon/proc/duration_ended(mob/living/user)
	if(QDELETED(parent))
		return

	deactivate(user)

	if(QDELETED(user))
		return

	if(current_state != STATE_SAFE)
		send_off(user)
		return

	if(!length(allowed_areas))
		return

	var/area/A = get_area(user)
	if(allowed_areas[A.type])
		to_chat(user, span_notice("The weapon fizzles out, its energies dissipating across the holy grounds."))
		return

	for(var/turf/T in view(world.view, user))
		if(allowed_areas[T.loc.type])
			to_chat(user, span_notice("The weapon fizzles out, its energies dissipating across the holy grounds."))
			return

	to_chat(user, span_notice("The weapon begins to fizzle out, but the energy has nowhere to go!"))
	send_off(user)

/datum/component/martyr_weapon/proc/send_off(mob/living/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.freak_out()

	if(user.cmode)
		user.toggle_cmode()
		user.refresh_looping_ambience()

	user.Stun(1 HOURS, TRUE)
	user.visible_message(
		span_warning("[user] falls to [user.p_their()] knees, planting [user.p_their()] weapon into the ground as holy energies pulse from [user.p_their()] body!"),
		span_warning("My oath is fulfilled. I hope I made it count. I have thirty seconds to make peace with the Gods and my Kin."),
	)
	user.playsound_local(user, 'sound/health/fastbeat.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(perish), user), 30 SECONDS)

/datum/component/martyr_weapon/proc/perish(mob/living/user)
	if(QDELETED(user) || QDELETED(parent))
		return

	user.playsound_local(user, 'sound/magic/ahh1.ogg', 100)
	user.visible_message(
		span_info("[user] fades away."),
		span_info("Your life led up to this moment. In the face of the decay of the world, you endured. Now you rest. You feel your soul shed from its mortal coils, and the embrace of [user.patron.name]")
	)

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.dust(drop_items = TRUE)
	else
		user.gib()

/datum/component/martyr_weapon/proc/deactivate(mob/living/user)
	if(!is_active)
		return

	STOP_PROCESSING(SSdcs, src)

	is_active = FALSE

	deactivate_weapon(parent, user)
	deactivate_holder(user)

/datum/component/martyr_weapon/proc/flash_lightning(mob/user)
	var/turf/T = get_step(get_step(user, NORTH), NORTH)
	T.Beam(user, icon_state = "lightning[rand(1, 12)]", time = 5)
	playsound(user, 'sound/magic/lightning.ogg', 100, FALSE)

/datum/component/martyr_weapon/proc/activate_weapon(obj/item/activating, mob/living/user)
	activating.possible_item_intents = active_intents
	activating.gripped_intents = active_intents_wielded
	user?.update_a_intents()

	activating.damtype = BURN
	activating.slot_flags = null

	activating.blade_int = activating.max_blade_int

	if(current_state != STATE_SAFE)
		activating.blade_int = INFINITY
		activating.toggle_state = "[initial(activating.icon_state)]_ulton"
	else
		activating.force = min(activating.force, active_safe_damage)
		activating.force_wielded = min(activating.force_wielded, active_safe_damage_wielded)
		activating.toggle_state = "[initial(activating.icon_state)]_on"

	ADD_TRAIT(activating, TRAIT_NODROP, MARTYR_TRAIT)

	if(user)
		var/datum/component/two_handed/two_handed = activating.GetComponent(/datum/component/two_handed)
		if(two_handed && !two_handed.wielded)
			two_handed.wield(user)
		else
			user.update_clothing(ITEM_SLOT_HANDS)

/datum/component/martyr_weapon/proc/deactivate_weapon(obj/item/activating, mob/living/user)
	activating.possible_item_intents = inactive_intents
	inactive_intents = null
	activating.gripped_intents = inactive_intents_wielded
	inactive_intents_wielded = null
	user?.update_a_intents()

	activating.force = activating::force
	activating.force_wielded = activating::force_wielded

	activating.damtype = activating::damtype
	activating.slot_flags = activating::slot_flags
	activating.blade_int = activating::blade_int

	activating.icon_state = activating::icon_state
	activating.item_state = activating::item_state
	activating.toggle_state = null

	REMOVE_TRAIT(activating, TRAIT_NODROP, MARTYR_TRAIT)

	if(user)
		var/datum/component/two_handed/two_handed = activating.GetComponent(/datum/component/two_handed)
		if(two_handed && two_handed.wielded)
			two_handed.unwield(user)
		else
			user.update_clothing(ITEM_SLOT_HANDS)

/datum/component/martyr_weapon/proc/activate_holder(mob/living/holder)
	if(QDELETED(holder))
		return

	holder.energy = holder.max_energy
	holder.stamina = 0

	for(var/trait in traits_applied)
		ADD_TRAIT(holder, trait, MARTYR_TRAIT)

	cmode_music_cache = holder.cmode_music

	var/list/stat_mods = list()

	switch(current_state)
		if(STATE_MARTYR)
			stat_mods = list(
				STAT_STRENGTH = stat_bonus_martyr,
				STAT_CONSTITUTION = stat_bonus_martyr,
				STAT_ENDURANCE = stat_bonus_martyr,
				STAT_INTELLIGENCE = stat_bonus_martyr,
				STAT_PERCEPTION = stat_bonus_martyr,
				STAT_FORTUNE = stat_bonus_martyr,
			)
			holder.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg' // Gets their normal music until pizza finishes his Great Work
		if(STATE_MARTYR_ULT)
			stat_mods = list(
				STAT_STRENGTH = 20,
				STAT_CONSTITUTION = 20,
				STAT_ENDURANCE = 20,
				STAT_PERCEPTION = 20,
			)
			holder.cmode_music = 'sound/music/cmode/church/CombatMartyrUlt.ogg'
			ADD_TRAIT(holder, TRAIT_NOSTAMINA, MARTYR_TRAIT)

	if(length(stat_mods))
		holder.set_stat_modifier(MARTYR_TRAIT, stat_mods)

	if(!holder.cmode)
		holder.toggle_cmode()

	holder.refresh_looping_ambience()

/datum/component/martyr_weapon/proc/deactivate_holder(mob/living/holder)
	if(QDELETED(holder))
		return

	for(var/trait in traits_applied)
		REMOVE_TRAIT(holder, trait, MARTYR_TRAIT)

	holder.remove_stat_modifier(MARTYR_TRAIT)

	holder.cmode_music = cmode_music_cache
	holder.refresh_looping_ambience()

#undef STATE_SAFE
#undef STATE_MARTYR
#undef STATE_MARTYR_ULT
