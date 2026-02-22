/**
 * AOE intents for weapons
 */
/datum/special_intent
	abstract_type = /datum/special_intent
	var/name = "special intent"
	var/desc = "bad coders"
	var/icon = 'icons/effects/effects.dmi'

	/// State to show before the attack
	var/pre_icon_state = "blip"
	/// Sound to play before the attack
	var/pre_sound = null
	/// State to show after the attack
	var/post_icon_state = "strike"
	/// Sound to play after the attack
	var/post_sound = null

	/// Stamina cost of the special
	var/stamina_cost = 0
	/// Max range of this special
	var/range = 0

	/// Delay before the attack happens
	var/attack_delay = 1 SECONDS
	/// Time the post effect lasts for
	var/fade_delay = 0.5 SECONDS

	/// Base cooldown time of the special, success OR failure
	var/cooldown = 30 SECONDS

	/// The main place where we can draw out the pattern. Every tile entry is a list with two numbers.
	/// The origin (0,0) is one step forward from the dir the owner is facing.
	/// This can be modified, though it's best be done before [build_affected_turfs].
	var/list/tile_coordinates = null

	/// Whether to have the howner pass through a doafter for the delay rather than it being on every turf.
	/// Default code here does not allow for dir switching during the do after.
	var/use_doafter = FALSE

	/// Whether the special uses the target atom that was clicked on. Generally best reserved to be a turf.
	/// This WILL change how the grid is drawn, as the 'origin' will become the clicked-on turf.
	var/use_clickloc = FALSE

	/// Whether the grid pattern will rotate with the howner's dir. Set to FALSE if you want to keep the grid
	/// In a static, consistent pattern regardless of how / where it's deployed.
	var/respect_dir = TRUE

	///Whether we'll check if our howner is adjacent to any of the tiles post-delay.
	///This is to prevent drop-and-run effect as if it was a spell.
	///If the datum is using multi-timed turfs, only the FIRST one's adjacency is checked ONCE.
	var/respect_adjacency = TRUE

	/// The only reference we will hold, and only if [respect_adjacency] is TRUE
	/// If the users loc isn't this when we end, they moved.
	var/turf/starting_loc = null

/datum/special_intent/Destroy(force, ...)
	starting_loc = null
	return ..()

// **** EXTERNAL PROCS

// these are called by other things

/// Get a nice examine string for this special
/datum/special_intent/proc/get_examine()
	var/str = "<details><summary><b>SPECIAL:</b> [span_tooltip("This ability can be used by right clicking while in STRONG stance.", name)]</summary>"
	str += "[desc]"
	if(range)
		str += "\nMax Range: ["\Roman [range]"]"
	if(stamina_cost)
		str += "\nStamina Drain: [stamina_cost]"
	return str

/**
 * Start the special attack
 *
 * Called via special_attack on strong intent
 */
/datum/special_intent/proc/deploy(mob/living/user, obj/item/parent, atom/target)
	if(!isliving(user) && !isitem(parent))
		stack_trace("Special intent [type] called without living user and item parent.")
		return FALSE

	if(use_clickloc)
		if(!isturf(target))
			target = get_turf(target)
		if(!target)
			stack_trace("Special intent [type] with clickloc called on something that has no valid turf.")
			return FALSE
	else
		target = null

	if(respect_adjacency)
		starting_loc = get_turf(user)

	if(range && !user.Adjacent(target)) // We got called from resolveRangedClick
		if(get_dist(user, target) > range)
			return FALSE

	process_attack(user, parent, target)

	return TRUE

/// Apply the stamina cost of the special
/datum/special_intent/proc/apply_cost(mob/living/user)
	var/cost = (stamina_cost < 1) ? (user.maximum_stamina * stamina_cost) : stamina_cost
	return user.adjust_stamina(cost)

// **** EXTERNAL END

///Main pipeline. Note that _delay() calls post_delay() after a timer.
/datum/special_intent/proc/process_attack(mob/living/user, obj/item/parent, turf/target)
	SHOULD_CALL_PARENT(TRUE)

	if(user.ckey)
		user.log_message(span_danger("Used the Special [name] on [key_name(target)]."), LOG_ATTACK)

	pre_creation(user, parent, target)

	var/list/turf/affected = build_affected_turfs(user, target)

	after_creation(user, parent, affected)

	start_attack(user, parent, affected)

	start_cooldown(user)

/// Do stuff before creating the grid
/datum/special_intent/proc/pre_creation(mob/living/user, obj/item/parent, turf/target)
	return

/// Use our [tile_coordinates] to return a list of affected turfs
/datum/special_intent/proc/build_affected_turfs(mob/living/user, turf/start_override)
	var/turf/origin = start_override ? start_override : get_step(user, user.dir)

	var/list/turf/affected_turfs = list()
	for(var/list/coords in tile_coordinates)
		var/coord_x = coords[1]
		var/coord_y = coords[2]

		if(respect_dir)
			switch(user.dir)
				if(SOUTH)
					coord_x = -coord_x
					coord_y = -coord_y
				if(WEST)
					var/temp = coord_x
					coord_x = -coord_y
					coord_y = temp
				if(EAST)
					var/temp = coord_x
					coord_x = coord_y
					coord_y = -temp

		var/turf/affected = locate(origin.x + coord_x, origin.y + coord_y, origin.z)
		if(affected && !affected.is_blocked_turf(TRUE))
			affected_turfs += affected

	return affected_turfs

/// Called after the affected turfs are processed.
/datum/special_intent/proc/after_creation(mob/living/user, obj/item/parent, list/turfs)
	return

/// Start the attack, executing it after the delay
/datum/special_intent/proc/start_attack(mob/living/user, obj/item/parent, list/turfs)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!length(turfs))
		return

	pre_delay(user, parent, turfs)

	if(!use_doafter)
		addtimer(CALLBACK(src, PROC_REF(post_delay), user, parent, turfs), attack_delay)
	else if(do_after(user, attack_delay))
		post_delay(user, parent, turfs)

/// After drawing the pre icons but before starting the timers
/datum/special_intent/proc/pre_delay(mob/living/user, obj/item/parent, list/turfs)
	SHOULD_CALL_PARENT(TRUE)

	for(var/turf/affected as anything in turfs)
		var/obj/effect/temp_visual/duration_setting/effect = new(affected, attack_delay)
		effect.icon = icon
		effect.icon_state = pre_icon_state
		effect.plane = GAME_PLANE_FOV_HIDDEN

	if(pre_sound)
		playsound(user, pre_sound, 100, TRUE)

/// This is called immediately after the delay of the intent.
/// It performs any needed adjacency checks and will try to draw the "post" visuals on any valid turfs.
/// It calls apply_hit() after where most of the logic for any on-hit effects should go.
/datum/special_intent/proc/post_delay(mob/living/user, obj/item/parent, list/turfs)
	SHOULD_CALL_PARENT(TRUE)

	if(QDELETED(user) || QDELETED(parent))
		return

	if(parent.loc != user)
		user.balloon_alert(user, "dropped weapon!")
		return

	if(starting_loc && get_turf(user) != starting_loc)
		starting_loc = null
		user.balloon_alert(user, "moved!")
		return

	for(var/turf/affected as anything in turfs)
		if(post_icon_state)
			var/obj/effect/temp_visual/duration_setting/effect = new(affected, fade_delay)
			effect.icon = icon
			effect.icon_state = post_icon_state
			effect.plane = GAME_PLANE_FOV_HIDDEN

		apply_hit(user, parent, affected)

	if(post_sound)
		playsound(user, post_sound, 100, TRUE)

/// Main proc where stuff should happen. This is called immediately after the post_delay of the intent.
/datum/special_intent/proc/apply_hit(mob/living/user, obj/item/parent, turf/target)
	SHOULD_CALL_PARENT(FALSE)

	CRASH("Special intent [type] does not override apply_hit behaviour.")

/// Apply the cooldown status effect to the mob, this is global for all specials
/datum/special_intent/proc/start_cooldown(mob/living/user, override_time)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/used_cooldown = isnum(override_time) ? override_time : cooldown

	user.apply_status_effect(/datum/status_effect/debuff/specialcd, used_cooldown)

/// So we have this ranged/area attack, so we can't just attack something.
/// We might also want to do things differently to our weapon...
/// Can not crit but can pen armour.
/datum/special_intent/proc/apply_generic_weapon_damage(
	mob/living/user,
	obj/item/weapon,
	mob/living/victim,
	damage,
	damage_type,
	damage_zone,
	damage_class,
)
	var/message = "[victim] is struck by [name]!"
	if(!ishuman(victim))
		victim.attacked_by(weapon, user)
	else
		var/mob/living/carbon/human/human_victim = victim
		var/obj/item/bodypart/affecting = human_victim.get_bodypart(damage_zone)
		var/armor_block = human_victim.run_armor_check(damage_zone, damage_type, damage = damage)
		if(human_victim.apply_damage(damage, damage_type, affecting, armor_block))
			affecting?.bodypart_attacked_by(damage_class, damage, user, crit_message = TRUE, reduce_crit = 100)
			message += "<b> It pierces through to their flesh!</b>"
			playsound(human_victim, weapon.hitsound, 80, TRUE)

	victim.visible_message(
		span_warning(message),
		span_userdanger("I'm struck by [name]!"),
	)
