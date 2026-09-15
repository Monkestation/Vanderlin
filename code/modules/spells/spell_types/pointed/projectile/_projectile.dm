/*
 * Usually this would be a /datum/action/cooldown/spell/pointed and we would have that subtype,
 * but our spells are almost all pointed so we put it on the base.
 */

/**
 * ### Pointed projectile spells
 *
 * Pointed spells that, instead of casting a spell directly on the target that's clicked,
 * will instead fire a projectile pointed at the target's direction.
 *
 * These REQUIRE click_to_activate to be true
 */
/datum/action/cooldown/spell/projectile
	abstract_type = /datum/action/cooldown/spell/projectile
	self_cast_possible = FALSE
	experience_modifier = 0.3 // More earned when hitting a target

	/// What projectile we create when we shoot our spell.
	var/obj/projectile/magic/projectile_type = /obj/projectile/magic/teleport
	///if we are in arc mode what projectile to use
	var/obj/projectile/magic/projectile_type_arc
	/// How many projectiles we can fire per cast. Not all at once, per click, kinda like charges
	var/projectile_amount = 1
	/// How many projectiles we have yet to fire, based on projectile_amount
	var/current_amount = 0
	/// How many projectiles we fire every fire_projectile() call.
	/// Unwise to change without overriding or extending ready_projectile.
	var/projectiles_per_fire = 1
	/// Whether this spell is currently set to fire in arc mode.
	var/arc_mode = FALSE

/datum/action/cooldown/spell/projectile/New(Target)
	. = ..()
	if(!click_to_activate)
		stack_trace("Projectile spell [type] created without having (click_to_activate = TRUE), this won't work.")
		qdel(src)
		return
	if(projectile_amount > 1)
		unset_after_click = FALSE

/datum/action/cooldown/spell/projectile/on_activation(mob/on_who)
	. = ..()
	if(!.)
		return

	current_amount = projectile_amount

/datum/action/cooldown/spell/projectile/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(projectile_amount > 1 && current_amount)
		StartCooldown(cooldown_time * ((projectile_amount - current_amount) / projectile_amount))
		current_amount = 0

// cast_on is a turf, or atom target, that we clicked on to fire at.
/datum/action/cooldown/spell/projectile/cast(atom/cast_on)
	. = ..()
	if(!isturf(owner.loc))
		return FALSE

	fire_projectile(cast_on)
	if(current_amount <= 0)
		unset_click_ability(owner, refund_cooldown = FALSE)

	return TRUE

/datum/action/cooldown/spell/projectile/after_cast(atom/cast_on)
	. = ..()
	if(current_amount > 0)
		// We still have projectiles to cast!
		// Reset our cooldown and let them fire away
		reset_spell_cooldown()

/// Fire the projectile(s) at the target.
/datum/action/cooldown/spell/projectile/proc/fire_projectile(atom/target)
	current_amount--
	for(var/i in 1 to projectiles_per_fire)
		var/active_type = (arc_mode && projectile_type_arc) ? projectile_type_arc : projectile_type
		var/obj/projectile/to_fire = new active_type(owner.loc)
		ready_projectile(to_fire, target, owner, i)
		to_fire.fire()
	return TRUE

/datum/action/cooldown/spell/projectile/proc/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	to_fire.firer = owner
	to_fire.fired_from = get_turf(owner)
	to_fire.scale = clamp(spell_magnitude_modifier, 0.5, 1.5)
	to_fire.preparePixelProjectile(target, owner)

	RegisterSignal(to_fire, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_cast_hit))

	if(istype(to_fire, /obj/projectile/magic))
		var/obj/projectile/magic/magic_to_fire = to_fire
		magic_to_fire.antimagic_flags = antimagic_flags
		magic_to_fire.spell_impact_intensity = spell_impact_intensity
		magic_to_fire.spell_impact_color = spell_impact_color

/// Signal proc for whenever the projectile we fire hits someone.
/// Pretty much relays to the spell when the projectile actually hits something.
/datum/action/cooldown/spell/projectile/proc/on_cast_hit(atom/source, mob/firer, atom/hit, angle)
	SIGNAL_HANDLER

	SEND_SIGNAL(src, COMSIG_SPELL_PROJECTILE_HIT, hit, firer, source)

	if(QDELETED(owner))
		return

	if(!ismob(hit))
		return

	var/mob/victim = hit
	if(victim.stat == DEAD)
		return

	handle_exp(get_adjusted_cost() / 4)

/// Toggle arc mode on this spell. Only works if projectile_type_arc is set.
/datum/action/cooldown/spell/projectile/proc/toggle_arc_mode(mob/user)
	if(!projectile_type_arc)
		to_chat(user, span_warning("[name] cannot be arced."))
		return
	arc_mode = !arc_mode
	if(arc_mode)
		to_chat(user, span_notice("[name] arc mode enabled - aim above or below to lob the shot across elevations."))
	else
		to_chat(user, span_notice("[name] arc mode disabled."))
	update_arc_maptext()

/// Updates the ARC maptext indicator on the spell's action button.
/datum/action/cooldown/spell/projectile/proc/update_arc_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/arc_holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			arc_holder = existing
			break
		if(!arc_holder)
			arc_holder = new(B)
			B.vis_contents.Add(arc_holder)
		if(arc_mode)
			arc_holder.maptext = MAPTEXT("ARC")
			arc_holder.color = "#00ccff"
		else
			arc_holder.maptext = null
