/datum/action/cooldown/spell/circumdatum
	button_icon = 'icons/mob/actions/spells/mage_telomancy.dmi'
	name = "Circumdatum"
	desc = "Surrounds an ally with warding orbs instantly. Each reduce an incoming blow's integrity damage by 25% before disintegrating."
	button_icon_state = "circumdatum"
	sound = 'sound/magic/vlightning.ogg'

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 7

	spell_color = 12
	required_form = FORM_ARCANE

	invocation = "Circumdatum!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 15 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/orb_count = 5

/datum/action/cooldown/spell/circumdatum/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		to_chat(owner, span_warning("I can only ward another person!"))
		return FALSE
	var/mob/living/carbon/human/target = cast_on
	target.apply_status_effect(/datum/status_effect/buff/circumdatum, null, orb_count)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/circumdatum
	name = "Circumdatum"
	desc = "Arcyne orbs circle me,ready to blunt a blow before it lands."
	icon_state = "buff"

/datum/status_effect/buff/circumdatum
	id = "circumdatum"
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/circumdatum
	var/orbs = 5
	var/list/orb_visuals
	var/last_struck_time = 0

/datum/status_effect/buff/circumdatum/on_creation(mob/living/new_owner, duration_override, count = 5)
	orbs = count
	return ..()

/datum/status_effect/buff/circumdatum/on_apply()
	. = ..()
	if(!.)
		return
	orb_visuals = list()
	owner.apply_status_effect(/datum/status_effect/buff/iron_skin, duration)
	RegisterSignals(owner, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED), PROC_REF(on_struck))
	for(var/i in 1 to orbs)
		var/obj/effect/circumdatum_orb/orb = new()
		orb_visuals += orb
		owner.vis_contents += orb
		spin_orb(orb, (i - 1) * (360 / orbs))
	owner.balloon_alert_to_viewers("<font color='[GLOB.form_colors[FORM_ARCANE]]'>warded!</font>")

/datum/status_effect/buff/circumdatum/proc/spin_orb(obj/effect/orb, phase)
	orb.orbit(owner, 16, TRUE, 40, 36, starting_rotation = phase)

/datum/status_effect/buff/circumdatum/proc/on_struck(datum/source, mob/living/struck, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER
	if(world.time == last_struck_time)
		return
	last_struck_time = world.time
	deplete_orb()

/datum/status_effect/buff/circumdatum/proc/deplete_orb()
	orbs = max(0, orbs - 1)
	if(length(orb_visuals))
		var/obj/effect/spent = orb_visuals[length(orb_visuals)]
		orb_visuals -= spent
		if(owner)
			owner.vis_contents -= spent
		if(!QDELETED(spent))
			qdel(spent)
	if(orbs <= 0)
		owner.remove_status_effect(/datum/status_effect/buff/circumdatum)

/datum/status_effect/buff/circumdatum/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED))
	owner.remove_status_effect(/datum/status_effect/buff/iron_skin)
	for(var/obj/effect/orb in orb_visuals)
		if(owner)
			owner.vis_contents -= orb
		if(!QDELETED(orb))
			qdel(orb)
	orb_visuals = null
	. = ..()

/obj/effect/circumdatum_orb
	name = "arcyne orb"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "seeker_orb"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	vis_flags = VIS_INHERIT_PLANE
