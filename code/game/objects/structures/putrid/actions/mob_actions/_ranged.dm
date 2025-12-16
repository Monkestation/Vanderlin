/datum/action/cooldown/meatvine/personal/ranged
	name = "Spit Neurotoxin"
	desc = "Spits neurotoxin at someone, exhausting them."
	personal_resource_cost = 40
	/// A singular projectile? Use this one and leave acid_casing null
	var/acid_projectile = /obj/projectile/neurotoxin
	/// You want it to be more like a shotgun style attack? Use this one and make acid_projectile null
	var/acid_casing
	/// Used in to_chat messages to the owner
	var/projectile_name = "neurotoxin"
	/// The base icon for the ability, so a red box can be put on it using _0 or _1
	var/button_base_icon = "neurospit"
	/// The sound that should be played when the xeno actually spits
	var/spit_sound = 'sound/alien/alien_spitacid.ogg'
	shared_cooldown = MOB_SHARED_COOLDOWN_3
	cooldown_time = 5 SECONDS

/datum/action/cooldown/meatvine/personal/ranged/IsAvailable(feedback = FALSE)
	return ..() && isturf(owner.loc)

/datum/action/cooldown/meatvine/personal/ranged/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	to_chat(on_who, span_notice("You prepare your [projectile_name] gland. <B>Left-click to fire at a target!</B>"))

	button_icon_state = "[button_base_icon]_1"
	build_all_button_icons()
	on_who.update_icons()

/datum/action/cooldown/meatvine/personal/ranged/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		to_chat(on_who, span_notice("You empty your [projectile_name] gland."))

	button_icon_state = "[button_base_icon]_0"
	build_all_button_icons()
	on_who.update_icons()

/datum/action/cooldown/meatvine/personal/ranged/InterceptClickOn(mob/living/user, params, atom/target)
	. = ..()
	if(!.)
		unset_click_ability(user, refund_cooldown = FALSE)
		return FALSE

	var/turf/target_turf = get_step(user, target.dir)
	if(!isturf(target_turf))
		return FALSE

	var/modifiers = params2list(params)
	user.visible_message(
		span_danger("[user] spits [projectile_name]!"),
		span_alertalien("You spit [projectile_name]."),
	)

	if(acid_projectile)
		var/obj/projectile/spit_projectile = new acid_projectile(user.loc)
		spit_projectile.preparePixelProjectile(target, user, modifiers)
		spit_projectile.firer = user
		spit_projectile.fire()
		playsound(user, spit_sound, 100, TRUE, 5, 0.9)
		return TRUE

	if(acid_casing)
		var/obj/item/ammo_casing/casing = new acid_casing(user.loc)
		playsound(user, spit_sound, 100, TRUE, 5, 0.9)
		casing.fire_casing(target, user, null, null, null, ran_zone(), 0, user)
		return TRUE

	CRASH("Neither acid_projectile or acid_casing are set on [user]'s spit attack!")

/datum/action/cooldown/meatvine/personal/ranged/Activate(atom/target)
	return ..()


/datum/action/cooldown/meatvine/personal/ranged/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target || QDELETED(target))
		return 0

	var/dist = get_dist(mob, target)

	// Don't use if too close (melee is better) or too far
	if(dist < 3 || dist > 10)
		return 0

	if(!can_see(mob, target, 9))
		return 0

	// Score higher when at optimal range (5-7 tiles)
	if(dist >= 5 && dist <= 7)
		return 80

	return 40

/datum/action/cooldown/meatvine/personal/ranged/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target || QDELETED(target))
		return FALSE

	// Activate click ability
	if(!click_to_activate)
		return Activate(target)

	// Set up click ability and fire
	set_click_ability(mob)
	var/result = InterceptClickOn(mob, "[MIDDLE_CLICK]=1", target)
	unset_click_ability(mob, refund_cooldown = !result)
	return result
