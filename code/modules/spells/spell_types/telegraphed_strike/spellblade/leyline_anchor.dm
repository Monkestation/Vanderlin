/datum/action/cooldown/spell/leyline_anchor
	name = "Leyline Anchor"
	desc = "Anchor an arcyne tether to the leyline beneath your feet. Recast to recall. \
		The tether has 75 health and lasts 20 seconds. \
		7 tile maximum recall range. Same level only. \
		Cannot recall while grabbed, restrained, or buckled. \
		If the tether is destroyed or expires, the spell goes on full cooldown."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "leyline_anchor"
	sound = 'sound/misc/portalactivate.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_cost = 40

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE

	invocation = "Ancora Lineam!"
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/structure/leyline_anchor_tether/active_portal
	var/max_range = 7
	var/teleport_delay = 5

/datum/action/cooldown/spell/leyline_anchor/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/leyline_anchor/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Recast while tether active - recall
	if(active_portal && !QDELETED(active_portal))
		var/turf/portal_turf = get_turf(active_portal)
		if(!portal_turf)
			to_chat(H, span_warning("The leyline tether has been severed!"))
			clear_portal()
			return FALSE
		if(H.pulledby || HAS_TRAIT(H, TRAIT_RESTRAINED) || H.buckled)
			to_chat(H, span_warning("I can't recall while restrained!"))
			return FALSE
		var/turf/caster_turf = get_turf(H)
		if(caster_turf.z != portal_turf.z)
			to_chat(H, span_warning("The leyline tether is on a different level!"))
			return FALSE
		if(get_dist(caster_turf, portal_turf) > max_range)
			to_chat(H, span_warning("Too far from the leyline tether!"))
			return FALSE
		H.visible_message(span_warning("Arcyne energy crackles around [H]!"))
		playsound(get_turf(H), 'sound/magic/shadowstep_destination.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(do_recall), H), teleport_delay)
		return TRUE

	// First cast - anchor tether
	var/turf/T = get_turf(H)
	active_portal = new /obj/structure/leyline_anchor_tether(T, src)
	to_chat(H, span_notice("I anchor the leyline beneath my feet."))
	playsound(T, 'sound/misc/portalactivate.ogg', 50, TRUE)
	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/leyline_anchor/proc/do_recall(mob/living/carbon/human/user)
	if(QDELETED(user) || user.stat == DEAD)
		return
	if(!active_portal || QDELETED(active_portal))
		return
	var/turf/dest = get_turf(active_portal)
	if(!dest)
		return

	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	user.visible_message(
		span_warning("[user] is pulled back through the leyline!"),
		span_notice("The leyline pulls me back."))
	active_portal.parent_spell = null
	qdel(active_portal)
	active_portal = null
	StartCooldown()

/datum/action/cooldown/spell/leyline_anchor/proc/clear_portal()
	active_portal = null
	StartCooldown()
	build_all_button_icons()

/obj/structure/leyline_anchor_tether
	name = "leyline tether"
	desc = "An arcyne tether anchored to the leyline. Destroy it to sever the connection."
	icon = 'icons/effects/effects.dmi'
	icon_state = "leylinerupture"
	max_integrity = 75
	anchored = TRUE
	density = FALSE
	opacity = 0
	light_outer_range = 1
	break_sound = 'sound/magic/magic_nulled.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg')
	var/datum/action/cooldown/spell/leyline_anchor/parent_spell

/obj/structure/leyline_anchor_tether/Initialize(mapload, datum/action/cooldown/spell/leyline_anchor/spell)
	. = ..()
	parent_spell = spell
	QDEL_IN(src, 20 SECONDS)

/obj/structure/leyline_anchor_tether/Destroy()
	if(parent_spell)
		INVOKE_ASYNC(parent_spell, TYPE_PROC_REF(/datum/action/cooldown/spell/leyline_anchor, clear_portal))
		parent_spell = null
	return ..()
