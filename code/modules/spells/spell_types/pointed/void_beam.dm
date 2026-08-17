#define VOID_BEAM_SLOWDOWN_ID "void_beam_windup"

/datum/action/cooldown/spell/void_beam
	button_icon = 'icons/mob/actions/spells/mage_telomancy.dmi'
	name = "Void Beam"
	desc = "Fire a lance of raw arcyne force that exposes your foe. It is well telegraphed and does a decent amount of damaage."
	button_icon_state = "void_beam"
	sound = 'sound/magic/soulshot.ogg'

	click_to_activate = TRUE
	cast_range = 8

	spell_cost = 40
	cooldown_time = 20 SECONDS

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_DESTRUCTION

	invocation = "Scintilla Magistra!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/beam_range = 8
	var/beam_delay = 1.5 SECONDS
	var/beam_damage = 100
	var/push_dist = 1
	var/expose_duration = 6 SECONDS
	var/beam_slowdown = 2

/datum/action/cooldown/spell/void_beam/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || !get_turf(H))
		return FALSE

	H.add_movespeed_modifier(VOID_BEAM_SLOWDOWN_ID, update = TRUE, priority = 100, multiplicative_slowdown = beam_slowdown, movetypes = GROUND)
	playsound(H, 'sound/magic/charging.ogg', 60, TRUE, channel = CHANNEL_CHARGED_SPELL)
	INVOKE_ASYNC(src, PROC_REF(windup_and_fire), H, cast_on)
	return TRUE

/datum/action/cooldown/spell/void_beam/proc/windup_and_fire(mob/living/carbon/human/H, atom/target)
	H.apply_status_effect(/datum/status_effect/swingdelay/penalty, beam_delay + 2)
	var/list/warnings = list()
	var/last_dir = null
	var/turf/last_origin = null
	var/list/turf/line = list()
	var/elapsed = 0
	while(elapsed < beam_delay)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			finish_windup(H, warnings)
			return
		var/turf/origin = get_turf(H)
		var/turf/tt = get_turf(target)
		var/beam_dir = cardinal_toward(origin, tt) || nearest_cardinal(H.dir)
		if(beam_dir != last_dir || origin != last_origin)
			last_dir = beam_dir
			last_origin = origin
			line = build_beam_line(origin, beam_dir)
			redraw_warnings(line, warnings)
		sleep(2)
		elapsed += 2

	finish_windup(H, warnings)
	if(QDELETED(H) || isnull(last_dir))
		return
	var/turf/origin = get_turf(H)
	line = build_beam_line(origin, last_dir)
	void_beam_detonate(line, H, origin, last_dir, beam_damage, push_dist, expose_duration, src, name)

/datum/action/cooldown/spell/void_beam/proc/build_beam_line(turf/origin, beam_dir)
	var/list/turf/line = list()
	var/turf/current = origin
	for(var/i in 1 to beam_range)
		var/turf/next = get_step(current, beam_dir)
		if(!next || next.density)
			break
		line += next
		current = next
	return line

/datum/action/cooldown/spell/void_beam/proc/cardinal_toward(turf/origin, turf/tt)
	if(!origin || !tt || tt == origin)
		return null
	var/dx = tt.x - origin.x
	var/dy = tt.y - origin.y
	if(abs(dx) >= abs(dy))
		return (dx > 0) ? EAST : WEST
	return (dy > 0) ? NORTH : SOUTH

/datum/action/cooldown/spell/void_beam/proc/nearest_cardinal(dir)
	if(dir & NORTH)
		return NORTH
	if(dir & SOUTH)
		return SOUTH
	if(dir & EAST)
		return EAST
	if(dir & WEST)
		return WEST
	return SOUTH

/datum/action/cooldown/spell/void_beam/proc/redraw_warnings(list/turf/line, list/warnings)
	for(var/obj/effect/old in warnings)
		qdel(old)
	warnings.Cut()
	for(var/turf/T in line)
		warnings += new /obj/effect/temp_visual/trap/telomancy(T)

/datum/action/cooldown/spell/void_beam/proc/finish_windup(mob/living/carbon/human/H, list/warnings)
	for(var/obj/effect/old in warnings)
		qdel(old)
	warnings.Cut()
	if(H && !QDELETED(H))
		H.remove_movespeed_modifier(VOID_BEAM_SLOWDOWN_ID)
		H.stop_sound_channel(CHANNEL_CHARGED_SPELL)

/proc/void_beam_detonate(list/turf/line, mob/living/carbon/human/caster, turf/origin, beam_dir, damage = 35, push_dist = 1, expose_dur = 6 SECONDS, datum/action/cooldown/spell/guard_source, spell_name = "Void Beam")
	if(caster)
		caster.remove_movespeed_modifier(VOID_BEAM_SLOWDOWN_ID)
	if(!length(line))
		return

	playsound(origin, 'sound/magic/soulshot.ogg', 90, TRUE, 4)
	var/index = 0
	var/last_index = length(line)
	var/list/struck = list()

	for(var/turf/T in line)
		index++
		var/obj/effect/temp_visual/void_beam/seg = new(T)
		seg.setDir(beam_dir)
		if(index == 1)
			seg.icon_state = "obeliskbeam_start"
		else if(index == last_index)
			seg.icon_state = "obeliskbeam_end"

		for(var/obj/structure/S in T)
			S.take_damage(damage, BRUTE, "blunt", FALSE)

		for(var/mob/living/L in T.contents)
			if(L in struck)
				continue
			struck += L
			if(L.can_block_magic())
				L.visible_message(span_warning("The beam splinters against [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(istype(caster) && !QDELETED(caster) && ishuman(L))
				arcyne_strike(caster, L, null, damage, caster.zone_selected, \
					BCLASS_PIERCE, spell_name = spell_name, \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.adjustBruteLoss(damage)
				SEND_SIGNAL(L, COMSIG_ATOM_WAS_ATTACKED, caster, damage)
			L.apply_status_effect(/datum/status_effect/debuff/exposed, expose_dur)
			var/push_dir = get_dir(origin, L) || beam_dir
			L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOB.form_colors[FORM_ARCANE], SPELL_IMPACT_MEDIUM)

/obj/effect/temp_visual/void_beam
	name = "void beam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "obeliskbeam_mid"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_color = "#9400D3"
	light_power = 4
	light_outer_range = 3
	duration = 6

#undef VOID_BEAM_SLOWDOWN_ID
