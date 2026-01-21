#define ORISON_FILL /datum/intent/orison/fill
#define ORISON_TOUCH /datum/intent/orison/touch
#define ORISON_LIGHT /datum/intent/orison/light

/datum/intent/orison
	noaa = TRUE
	misscost = 0
	releasedrain = 0
	candodge = FALSE
	canparry = FALSE

/datum/intent/orison/fill
	reach = 1
	name = "fill"
	icon_state = "infill"

/datum/intent/orison/touch
	reach = 7
	name = "touch"
	icon_state = "intouch"

/datum/intent/orison/light
	reach = 1
	name = "use"
	icon_state = "inuse"

/datum/action/cooldown/spell/undirected/touch/orison
	name = "Orison"
	desc = "The basic precept of holy magic orients around the power of prayer and soliciting a Divine Patron for a tiny sliver of Their might."
	button_icon_state = "thaumaturgy"
	can_cast_on_self = TRUE

	spell_type = SPELL_MIRACLE
	associated_skill = /datum/skill/magic/holy
	school = SCHOOL_TRANSMUTATION

	cooldown_time = 3 MINUTES

	hand_path = /obj/item/melee/touch_attack/orison
	draw_message = "I calm my mind and prepare to draw upon an orison."
	drop_message = "I return my mind to the now."
	charges = 6

/datum/action/cooldown/spell/undirected/touch/orison/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!ishuman(owner))
		return FALSE

/datum/action/cooldown/spell/undirected/touch/orison/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	switch(caster.used_intent.type)
		if(ORISON_FILL)
			create_water(victim, caster)
		if(ORISON_TOUCH)
			thaumaturgy(victim, caster)
		if(ORISON_LIGHT)
			cast_light(victim, caster)
	return FALSE

/datum/action/cooldown/spell/undirected/touch/orison/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	if(isliving(victim))
		var/mob/living/blessed_mob = victim
		if(blessed_mob.has_status_effect(/datum/status_effect/light_buff))
			blessed_mob.remove_status_effect(/datum/status_effect/light_buff)
			caster.visible_message(span_notice("[caster] issues a reserved gesture towards [victim], and the holy light leaves [victim.p_them()]."),\
			span_notice("I gesture towards [victim], and [victim.p_their()] blessing of light recedes."))

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/melee/touch_attack/orison
	name = "\improper lesser prayer"
	desc = "The fundamental teachings of theology return to you:\n \
		<b>Fill</b>: Beseech your Divine to create a small quantity of holy water in a container that you touch for some devotion.\n \
		<b>Touch</b>: Direct a sliver of divine thaumaturgy into your being, causing your voice to become LOUD when you next speak. Can be used on light sources at range, and it will cause them flicker.\n \
		<b>Use</b>: Issue a prayer for illumination, causing you or another living creature to begin glowing with light for five minutes - this stacks each time you cast it, with no upper limit. Blessings can be removed with RMB."
	possible_item_intents = list(ORISON_FILL, ORISON_TOUCH, ORISON_LIGHT)

/datum/action/cooldown/spell/undirected/touch/orison/proc/create_water(atom/victim, mob/living/carbon/human/user)
	if(victim.is_refillable())
		if(victim.reagents.holder_full())
			to_chat(user, span_warning("[victim] is full."))
			return FALSE

		user.visible_message(
			span_info("[user] closes [user.p_their()] eyes in prayer and extends a hand over [victim] as water begins to stream from [user.p_their()] fingertips..."),
			span_notice("I utter forth a plea to [user.patron.name] for succour, and hold my hand out above [victim]...")
		)

		var/holy_skill = user.get_skill_level(associated_skill)
		var/drip_speed = 5.6 SECONDS - (holy_skill * 8)
		var/fatigue_spent = 0
		var/fatigue_used = max(3, holy_skill)
		while(do_after(user, drip_speed, victim))
			if(victim.reagents.holder_full() || (user.cleric.devotion - fatigue_used <= 0))
				break

			var/water_qty = max(1, holy_skill) + 1
			var/list/water_contents = list(/datum/reagent/water/blessed = water_qty)
			if(user.patron.type == /datum/patron/inhumen/zizo)
				water_contents = list(/datum/reagent/water/cursed = water_qty)

			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(victim, reagents_to_add.total_volume, transfered_by = user, method = INGEST)

			fatigue_spent += fatigue_used
			user.adjust_stamina(fatigue_used)
			user.cleric?.update_devotion(-1)

			if(prob(80))
				playsound(user, 'sound/items/fillcup.ogg', 55, TRUE)

		handle_xp(user, fatigue_spent)
		return TRUE

/datum/action/cooldown/spell/undirected/touch/orison/proc/thaumaturgy(atom/victim, mob/living/carbon/human/user)
	var/holy_skill = user.get_skill_level(associated_skill)

	if(victim == user)
		if(user.has_status_effect(/datum/status_effect/thaumaturgy))
			user.remove_status_effect((/datum/status_effect/thaumaturgy))
			to_chat(user, span_notice("The feeling in my throat wanes, I will speak normally."))
			return FALSE
		// give us a buff that makes our next spoken victim really loud and also cause any linked, un-muted scom to shriek out the phrase at a 15% chance
		var/cast_time = 50 - (holy_skill * 5)
		user.visible_message(span_notice("[user] lowers [user.p_their()] head solemnly, whispered prayers spilling from [user.p_their()] lips..."))
		user.audible_message(span_silver("O holy [user.patron.name], share unto me a sliver of your power..."), runechat_message = TRUE)

		if(!do_after(user, cast_time, user))
			return FALSE

		user.apply_status_effect(/datum/status_effect/thaumaturgy)
		user.visible_message(
			span_notice("[user] throws open [user.p_their()] eyes, suddenly emboldened!"),
			span_notice("A feeling of power wells up in my throat: speak, and many will hear!"),
		)
		handle_xp(user, 10)
		return TRUE

	if(isturf(victim) || istype(victim, /obj/machinery/light))
		var/did_flicker = FALSE
		for(var/obj/machinery/light/other_lights in view(3 + holy_skill, get_turf(victim)))
			other_lights.flicker(holy_skill * 5)
			user.cleric?.update_devotion(-1)
			did_flicker = TRUE

		if(did_flicker)
			to_chat(user, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))
			handle_xp(user, 10)

		return TRUE

/datum/action/cooldown/spell/undirected/touch/orison/proc/cast_light(atom/victim, mob/living/carbon/human/user)
	if(isliving(victim))
		var/mob/living/blessed_mob = victim
		var/holy_skill = user.get_skill_level(associated_skill)
		var/cast_time = 35 - (holy_skill * 3)

		if (victim != user)
			user.visible_message(span_notice("[user] reaches gently towards [victim], beads of light glimmering at [user.p_their()] fingertips..."), span_silver("Blessed [user.patron.name], I ask but for a light to guide the way..."))
		else
			user.visible_message(span_notice("[user] closes [user.p_their()] eyes and places a glowing hand upon [user.p_their()] chest..."), span_silver("Blessed [user.patron.name], I ask but for a light to guide the way..."))

		if(do_after(user, cast_time, victim))
			var/light_power = clamp(4 + (holy_skill - 3), 4, 7)

			var/datum/status_effect/light_buff/light_buff_status = /datum/status_effect/light_buff
			if (blessed_mob.has_status_effect(light_buff_status))
				user.visible_message(span_notice("The holy light emanating from [blessed_mob] becomes brighter!"), span_notice("I feed further devotion into [blessed_mob]'s blessing of light."))
			else
				user.visible_message(span_notice("A gentle illumination suddenly blossoms into being around [blessed_mob]!"), span_notice("I grant [blessed_mob] a blessing of light."))

			blessed_mob.apply_status_effect(light_buff_status, initial(light_buff_status.duration), light_power)
			handle_xp(user, 5)

		return TRUE

/datum/action/cooldown/spell/undirected/touch/orison/proc/handle_xp(mob/living/carbon/human/user, base_xp)
	if(user && associated_skill)
		var/skill_level = user.get_skill_level(associated_skill)
		if(skill_level <= SKILL_LEVEL_EXPERT)
			adjust_experience(user, associated_skill, base_xp)

/datum/action/cooldown/spell/undirected/touch/orison/lesser
	name = "Lesser Orison"

	hand_path = /obj/item/melee/touch_attack/orison/lesser
	charges = 3

/datum/action/cooldown/spell/undirected/touch/orison/lesser/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	return SECONDARY_ATTACK_CALL_NORMAL

/obj/item/melee/touch_attack/orison/lesser
	name = "\improper lesser prayer"
	desc = "The fundamental teachings of theology return to you:\n \
		<b>Fill</b>: Beseech your Divine to create a small quantity of holy water in a container that you touch for some devotion."
	possible_item_intents = list(ORISON_FILL)

/datum/reagent/water/blessed
	name = "blessed water"
	description = "A gift of Devotion. Very slightly heals wounds."

/datum/reagent/water/blessed/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_UNDEAD)
		M.adjustFireLoss(0.5*REM)
	else
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/blessed/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if (!istype(M))
		return ..()

	if (method & TOUCH)
		if (M.mob_biotypes & MOB_UNDEAD)
			M.adjustFireLoss(2*reac_volume, 0)
			M.visible_message(span_warning("[M] erupts into angry fizzling and hissing!"), span_warning("BLESSED WATER!!! IT BURNS!!!"))
			M.emote("scream")

	return ..()

/datum/reagent/water/cursed
	name = "cursed water"
	description = "A gift of Devotion. Very slightly heals wounds of the dead and the enlightened."

/datum/reagent/water/cursed/on_mob_life(mob/living/carbon/M)
	. = ..()
	if((M.mob_biotypes & MOB_UNDEAD))
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
	else
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
		M.adjust_stamina(0.5*REM)

/atom/movable/screen/alert/status_effect/thaumaturgy
	name = "Thaumaturgical Voice"
	desc = "The power of my god will make the next thing I say much louder!"
	icon_state = "stressvg"

/datum/status_effect/thaumaturgy
	id = "thaumaturgy"
	alert_type = /atom/movable/screen/alert/status_effect/thaumaturgy
	duration = 30 SECONDS

/datum/status_effect/thaumaturgy/on_creation(mob/living/new_owner, duration_override, ...)
	. = ..()
	RegisterSignal(new_owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/status_effect/thaumaturgy/on_remove(mob/living/new_owner)
	. = ..()
	UnregisterSignal(new_owner, COMSIG_MOB_SAY)

/datum/status_effect/thaumaturgy/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	speech_args[SPEECH_SPANS] |= list(SPAN_REALLYBIG)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	owner.remove_status_effect(/datum/status_effect/thaumaturgy)
	playsound(owner, 'sound/magic/invoke_general.ogg', 33, TRUE)

/atom/movable/screen/alert/status_effect/light_buff
	name = "Miraculous Light"
	desc = "A blessing of light wards off the darkness surrounding me."
	icon_state = "stressvg"

/datum/status_effect/light_buff
	id = "orison_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	var/potency = 1
	var/outline_colour = "#f5edda"
	var/list/mobs_affected

/datum/status_effect/light_buff/on_creation(mob/living/new_owner, duration_override, light_power)
	potency = light_power
	return ..()

/datum/status_effect/light_buff/on_apply()
	. = ..()
	to_chat(owner, span_notice("Light blossoms into being around me!"))
	var/filter = owner.get_filter("blessing_of_light")
	if (!filter)
		owner.add_filter("blessing_of_light", 2, outline_filter(1, outline_colour))

	add_light(owner)
	return TRUE

/datum/status_effect/light_buff/get_examine_text()
	return "SUBJECTPRONOUN is surrounded by an aura of gentle light."

/datum/status_effect/light_buff/proc/add_light(mob/living/source)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = source.mob_light(_power = potency)
	LAZYSET(mobs_affected, source, mob_light_obj)
	RegisterSignal(source, COMSIG_PARENT_QDELETING, PROC_REF(on_living_holder_deletion))

/datum/status_effect/light_buff/proc/remove_light(mob/living/source)
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = LAZYACCESS(mobs_affected, source)
	LAZYREMOVE(mobs_affected, source)
	if(mob_light_obj)
		qdel(mob_light_obj)

/datum/status_effect/light_buff/proc/on_living_holder_deletion(mob/living/M)
	remove_light(M)

/datum/status_effect/light_buff/on_remove()
	. = ..()
	to_chat(owner, span_notice("The miraculous light surrounding me has fled..."))
	owner.remove_filter("blessing_of_light")
	remove_light(owner)

#undef ORISON_FILL
#undef ORISON_TOUCH
#undef ORISON_LIGHT
