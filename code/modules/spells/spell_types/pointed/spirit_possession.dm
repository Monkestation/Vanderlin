/datum/action/cooldown/spell/conjure_projection
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	button_icon_state = "spirit_projection"
	name = "Spirit Projection"
	desc = "Cast your spirit into one of your conjured servants and control it directly, leaving your true body behind. A line links your body to the vessel. If the vessel strays too far, changes Z level, your abandoned body is struck, or the vessel is slain, your spirit is torn home at once. Use Return to Body to withdraw."
	sound = 'sound/magic/soulsteal.ogg'

	click_to_activate = TRUE
	cast_range = 12
	self_cast_possible = FALSE

	spell_cost = 20

	required_form = FORM_DEATH
	required_technique = TECHNIQUE_SUMMONING

	invocation_type = INVOCATION_SHOUT
	invocation = "In te ligabo, servus - spiritus meus intret!"

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_MIND

	var/projecting = FALSE
	var/datum/weakref/body_ref
	var/datum/weakref/vessel_ref
	var/datum/action/cooldown/spell/spirit_return/return_action
	var/datum/action/cooldown/spell/pilot_action
	var/body_base_pixel_x = 0
	var/body_base_pixel_y = 0
	var/leash_range = 21
	var/datum/beam/tether_beam

/datum/action/cooldown/spell/conjure_projection/Destroy()
	if(projecting)
		return_to_body("caster_gone")
	return ..()

/datum/action/cooldown/spell/conjure_projection/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	var/mob/living/caster = owner
	if(!isliving(caster))
		return FALSE
	if(!isliving(cast_on))
		caster.balloon_alert(caster, "not a servant!")
		return FALSE
	var/mob/living/vessel = cast_on
	if(!HAS_TRAIT(vessel, TRAIT_CONJURED_SUMMON) || !(vessel in caster.summoned_minions))
		caster.balloon_alert(caster, "not my servant!")
		return FALSE
	if(vessel.stat == DEAD)
		caster.balloon_alert(caster, "it is slain!")
		return FALSE
	if(vessel.ckey)
		caster.balloon_alert(caster, "already inhabited!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/conjure_projection/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	return . | SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/conjure_projection/cast(atom/cast_on)
	. = ..()
	var/mob/living/body = owner
	if(!istype(body) || projecting)
		return FALSE
	if(!body.key)
		return FALSE
	var/mob/living/vessel = cast_on
	if(!istype(vessel))
		return FALSE
	begin_projection(body, vessel)
	return TRUE

/datum/action/cooldown/spell/conjure_projection/proc/begin_projection(mob/living/body, mob/living/vessel)
	projecting = TRUE
	body_ref = WEAKREF(body)
	vessel_ref = WEAKREF(vessel)

	ADD_TRAIT(body, TRAIT_SLEEPIMMUNE, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOBREATH, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOHUNGER, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOMOOD, "spirit_projection")

	apply_projection_visuals(body)

	RegisterSignal(vessel, COMSIG_LIVING_DEATH, PROC_REF(on_vessel_lost))
	RegisterSignal(vessel, COMSIG_PREQDELETED, PROC_REF(on_vessel_qdel))
	RegisterSignal(vessel, COMSIG_MOVABLE_MOVED, PROC_REF(on_tether_moved))
	RegisterSignal(body, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_body_harmed))
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_body_death))
	RegisterSignal(body, COMSIG_MOVABLE_MOVED, PROC_REF(on_tether_moved))

	tether_beam = body.Beam(vessel, icon_state = "b_beam", time = INFINITY, max_distance = leash_range + 3, beam_type = /obj/effect/ebeam/spirit_tether)
	START_PROCESSING(SSprocessing, src)

	return_action = new /datum/action/cooldown/spell/spirit_return()
	return_action.origin = src
	return_action.Grant(vessel)

	var/pilot_ability_type = vessel.get_pilot_ability()
	if(pilot_ability_type)
		pilot_action = new pilot_ability_type()
		pilot_action.Grant(vessel)

	vessel.ai_controller?.set_ai_status(AI_STATUS_OFF)
	vessel.key = body.key

	body.visible_message(span_warning("[body] stiffens, then stands vacant, eyes glazed and empty, a faint blue aura shivering about their trembling frame."))
	to_chat(vessel, span_notice("My spirit surges into [vessel.real_name] - I see through its eyes and move as it moves."))
	playsound(body, 'sound/magic/soulsteal.ogg', 60, TRUE)

/datum/action/cooldown/spell/conjure_projection/proc/apply_projection_visuals(mob/living/body)
	body_base_pixel_x = body.pixel_x
	body_base_pixel_y = body.pixel_y
	body.add_filter("spirit_projection_aura", 2, list("type" = "outline", "size" = 1, "color" = "#4d90e0"))
	animate(body, pixel_x = body_base_pixel_x + 1, time = 2, loop = -1)
	animate(pixel_x = body_base_pixel_x - 1, time = 2)

/datum/action/cooldown/spell/conjure_projection/proc/clear_projection_visuals(mob/living/body)
	body.remove_filter("spirit_projection_aura")
	animate(body, pixel_x = body_base_pixel_x, pixel_y = body_base_pixel_y, time = 1)

/datum/action/cooldown/spell/conjure_projection/proc/on_vessel_lost(mob/living/source, gibbed)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "vessel_slain")

/datum/action/cooldown/spell/conjure_projection/proc/on_vessel_qdel(datum/source)
	SIGNAL_HANDLER
	return_to_body("vessel_gone")

/datum/action/cooldown/spell/conjure_projection/proc/on_body_harmed(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage <= 0)
		return
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "body_struck")

/datum/action/cooldown/spell/conjure_projection/proc/on_body_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "body_slain")

/datum/action/cooldown/spell/conjure_projection/proc/on_tether_moved(datum/source)
	SIGNAL_HANDLER
	evaluate_tether()

/datum/action/cooldown/spell/conjure_projection/process(seconds_per_tick)
	evaluate_tether()

/datum/action/cooldown/spell/conjure_projection/proc/evaluate_tether()
	if(!projecting)
		return
	var/mob/living/body = body_ref?.resolve()
	var/mob/living/vessel = vessel_ref?.resolve()
	if(!body || !vessel)
		return
	if(body.z != vessel.z || get_dist(body, vessel) > leash_range)
		INVOKE_ASYNC(src, PROC_REF(return_to_body), "out_of_range")

/datum/action/cooldown/spell/conjure_projection/proc/return_to_body(reason)
	if(!projecting)
		return
	projecting = FALSE

	var/mob/living/body = body_ref?.resolve()
	var/mob/living/vessel = vessel_ref?.resolve()
	body_ref = null
	vessel_ref = null

	STOP_PROCESSING(SSprocessing, src)
	if(tether_beam)
		if(!QDELETED(tether_beam))
			qdel(tether_beam)
		tether_beam = null

	if(return_action)
		if(!QDELETED(return_action))
			qdel(return_action)
		return_action = null
	if(pilot_action)
		if(!QDELETED(pilot_action))
			qdel(pilot_action)
		pilot_action = null

	if(vessel)
		UnregisterSignal(vessel, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	if(body)
		UnregisterSignal(body, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
		REMOVE_TRAIT(body, TRAIT_SLEEPIMMUNE, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOBREATH, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOHUNGER, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOMOOD, "spirit_projection")
		clear_projection_visuals(body)

	if(body && vessel && vessel.key)
		body.key = vessel.key
		vessel.ai_controller?.reset_ai_status()

	if(body)
		switch(reason)
			if("vessel_slain")
				to_chat(body, span_userdanger("My vessel is cut down - my spirit is flung violently back into my flesh!"))
			if("vessel_gone")
				to_chat(body, span_warning("The vessel unravels beneath me and my spirit rushes home."))
			if("body_struck")
				to_chat(body, span_userdanger("Pain wracks my true body - my spirit is snapped back in an instant!"))
			if("body_slain")
				to_chat(body, span_userdanger("My true body falls - I am dragged down into it as it dies!"))
			if("out_of_range")
				to_chat(body, span_userdanger("My vessel strays too far - the tether snaps and my spirit recoils home!"))
			else
				to_chat(body, span_notice("I draw my spirit back and settle once more into my own flesh."))
		playsound(body, 'sound/magic/soulsteal.ogg', 50, TRUE)

	if(!QDELETED(src))
		StartCooldown()

/datum/action/cooldown/spell/spirit_return
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	button_icon_state = "spirit_projection"
	name = "Return to Body"
	desc = "Withdraw your projected spirit and awaken once more in your own flesh."
	sound = null

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	spell_type = NONE

	cooldown_time = 0
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = NONE
	check_flags = NONE

	var/datum/action/cooldown/spell/conjure_projection/origin

/datum/action/cooldown/spell/spirit_return/can_cast_spell(feedback = TRUE)
	return !isnull(owner) && !isnull(origin)

/datum/action/cooldown/spell/spirit_return/cast(atom/cast_on)
	. = ..()
	origin?.return_to_body("voluntary")
	return TRUE

/mob/living/proc/get_pilot_ability()
	return null

/obj/effect/ebeam/spirit_tether
	color = "#4d90e0"
	alpha = 180
	layer = ABOVE_MOB_LAYER
