#define PHALANX_FILTER "phalanx_glow"

/datum/action/cooldown/spell/arcane_phalanx
	name = "Arcyne Phalanx"
	desc = "Prime your next melee strike with arcyne force. On hit, the blow pierces through, \
		striking enemies in a line behind the target. Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 for a deeper, more damaging pierce."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "azurean_phalanx"
	sound = 'sound/magic/antimagic.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_cost = 15

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE

	invocation = "Phalanx Arcana!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 12 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/pierce_length = 3
	var/pierce_damage = 35
	var/empowered_pierce_length = 4
	var/empowered_pierce_damage = 50
	var/momentum_cost = 3

/datum/action/cooldown/spell/arcane_phalanx/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!H.arcyne_get_weapon())
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/phalanx_ready))
		to_chat(H, span_warning("My thrust is already primed!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered pierce primed!"))

	var/datum/status_effect/buff/phalanx_ready/effect = H.apply_status_effect(/datum/status_effect/buff/phalanx_ready)
	if(effect)
		effect.spell_ref = WEAKREF(src)
		effect.empowered = empowered

	H.visible_message(
		span_notice("[H] primes [H.p_their()] weapon with a surge of arcyne force."),
		span_notice("My thrust is primed - the next strike will pierce through."))
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)
	return TRUE

/datum/action/cooldown/spell/arcane_phalanx/proc/do_pierce(mob/living/carbon/human/user, mob/living/struck, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/obj/item/weapon = user.arcyne_get_weapon()
	if(!weapon)
		return

	var/turf/origin = get_turf(struck)
	if(!origin)
		return

	var/pierce_dir = get_dir(user, struck)
	if(!pierce_dir)
		pierce_dir = user.dir

	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? empowered_pierce_damage : pierce_damage
	var/length = empowered ? empowered_pierce_length : pierce_length

	var/list/pierce_turfs = list()
	var/turf/current = origin
	for(var/i in 1 to length)
		current = get_step(current, pierce_dir)
		if(!current || current.density)
			break
		var/struct_blocked = FALSE
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				struct_blocked = TRUE
				break
		if(struct_blocked)
			break
		pierce_turfs += current

	// Visuals on origin tile and all pierce tiles
	var/obj/effect/temp_visual/origin_burst = new /obj/effect/temp_visual/blade_stab(origin)
	origin_burst.dir = pierce_dir
	for(var/turf/T in pierce_turfs)
		var/obj/effect/temp_visual/V = new /obj/effect/temp_visual/blade_stab(T)
		V.dir = pierce_dir

	playsound(origin, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 70, TRUE)

	var/hit_count = 0
	var/list/already_hit = list()

	// Hit the original struck target with the arcyne strike (they already took the normal weapon hit)
	if(!QDELETED(struck) && struck.stat != DEAD)
		arcyne_strike(user, struck, weapon, damage, def_zone, BCLASS_STAB, spell_name = "Azurean Phalanx", skip_animation = TRUE)
		hit_count++
		already_hit += struck

	for(var/turf/T in pierce_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim == struck || victim.stat == DEAD || (victim in already_hit))
				continue
			arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_STAB, spell_name = "Azurean Phalanx", skip_animation = TRUE)
			hit_count++
			already_hit += victim

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M)
		M.add_stacks(1)

	if(hit_count)
		user.visible_message(span_danger("[user] drives [user.p_their()] [weapon.name] through [struck], piercing those behind!"))
		if(hit_count >= 2 && M)
			M.add_stacks(1)
			to_chat(user, span_notice("DOUBLE PIERCE! ARCYNE SURGE!"))
	else
		user.visible_message(span_notice("[user]'s strike pierces through [struck]."))

// --- Status effect ---

/atom/movable/screen/alert/status_effect/buff/phalanx_ready
	name = "Phalanx Primed"
	desc = "My next melee strike will pierce through the target."
	icon_state = "buff"

/datum/status_effect/buff/phalanx_ready
	id = "phalanx_ready"
	alert_type = /atom/movable/screen/alert/status_effect/buff/phalanx_ready
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/datum/weakref/spell_ref
	var/empowered = FALSE

/datum/status_effect/buff/phalanx_ready/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	owner.add_filter(PHALANX_FILTER, 2, list("type" = "outline", "color" = "#4488ff", "alpha" = 160, "size" = 2))

/datum/status_effect/buff/phalanx_ready/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	owner.remove_filter(PHALANX_FILTER)
	. = ..()

/datum/status_effect/buff/phalanx_ready/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return
	var/obj/item/bound = owner.arcyne_get_weapon()
	if(!bound || bound != weapon)
		return
	var/datum/action/cooldown/spell/arcane_phalanx/spell = spell_ref?.resolve()
	if(!spell)
		owner.remove_status_effect(/datum/status_effect/buff/phalanx_ready)
		return
	var/was_empowered = empowered
	owner.remove_status_effect(/datum/status_effect/buff/phalanx_ready)
	INVOKE_ASYNC(spell, TYPE_PROC_REF(/datum/action/cooldown/spell/arcane_phalanx, do_pierce), source, target, was_empowered)

/obj/effect/temp_visual/blade_stab
	icon = 'icons/effects/effects.dmi'
	icon_state = "stab"
	dir = NORTH
	name = "arcyne stab"
	randomdir = FALSE
	duration = 1 SECONDS

#undef PHALANX_FILTER
