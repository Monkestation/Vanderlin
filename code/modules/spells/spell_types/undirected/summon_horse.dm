GLOBAL_VAR_INIT(nya_catmodder_go, FALSE)

/client/proc/nya()
	set category = "GameMaster.Fun"
	set name = "Equestria Crossover"
	set desc = ":3."

	GLOB.nya_catmodder_go = !GLOB.nya_catmodder_go
	message_admins("///＞︿＜/// Nya~ Catmodder mode is [GLOB.nya_catmodder_go ? "on" : "off"] ≽^-⩊-^≼")


/datum/job/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats)
	. = ..()
	if(GLOB.nya_catmodder_go)
		spawned.add_spell(/datum/action/cooldown/spell/undirected/choose_riding_virtue_mount)

/datum/component/riding/equestria/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 0, OBJ_LAYER),
		TEXT_SOUTH = list(0, 4, ABOVE_MOB_LAYER),
		TEXT_EAST = list(0, 4, OBJ_LAYER),
		TEXT_WEST = list(0, 4, OBJ_LAYER)
	)

/mob/living/simple_animal/hostile/retaliate/honse/equestria
	generate_genetics = FALSE
	icon = 'icons/mrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrowmrow.dmi'
	tame = TRUE
	indexed = FALSE
	can_buckle = FALSE
	pixel_x = 0


/mob/living/simple_animal/hostile/retaliate/honse/equestria/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/honse/equestria/tamed()
	..()
	deaggroprob = 20
	can_buckle = TRUE
	if(can_buckle)
		AddComponent(/datum/component/riding/equestria)

/datum/status_effect/buff/healing/saddleborn
	healing_on_tick = 0.25
	duration = 5 MINUTES
	examine_text = "They look well-rested!"
	outline_colour = "#f5c2c2"

/datum/stress_event/precious_mob_died
	timer = INFINITY
	stress_change = 10
	desc = span_red("There will never be another creature like them. They are lost, and so am I.")

/datum/component/precious_creature
	// Who does this creature belong to?
	var/datum/weakref/owner

/datum/component/precious_creature/Initialize(mob/living/the_owner)
	if (!the_owner || !isliving(the_owner))
		return COMPONENT_INCOMPATIBLE

	owner = WEAKREF(the_owner)
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(precious_died))

/datum/component/precious_creature/proc/precious_died()
	var/mob/living/our_owner = owner.resolve()
	if(!our_owner || QDELETED(our_owner))
		return
	to_chat(our_owner, span_boldwarning("A quavering pang of loneliness streaks through your chest like cold lightning, sinking to the pit of your stomach. THEY ARE GONE!"))
	our_owner.add_stress(/datum/stress_event/precious_mob_died)

/mob/living/carbon/human
	/// Weakref to our bespoke Saddleborn mount (added by the virtue)
	var/datum/weakref/saddleborn_mount

/datum/action/cooldown/spell/undirected/saddleborn
	spell_type = NONE
	charge_required = FALSE
	has_visual_effects = FALSE
	sound = null

/datum/action/cooldown/spell/undirected/saddleborn/proc/check_mount()
	var/mob/living/carbon/human/user = owner
	if (!ishuman(user))
		return FALSE

	if (!user.saddleborn_mount)
		to_chat(user, span_warning("You have no treasured mount to send away..."))
		qdel(src)
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	if (!honse || honse.stat == DEAD)
		to_chat(user, span_warning("Necra has them now..."))
		return FALSE

	if (honse.has_buckled_mobs())
		to_chat(user, span_warning("Your mount needs to have nobody riding on it first!"))
		return FALSE

	var/area/place = get_area(user.loc)
	if (!place || !place.outdoors)
		to_chat(user, span_warning("You need to be outside!"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/undirected/saddleborn/cast(atom/cast_on)
	. = ..()
	return check_mount()


// ---- Choose Mount (one-time spell given by the virtue) ----

/datum/action/cooldown/spell/undirected/choose_riding_virtue_mount
	name = "Choose Mount"
	desc = "Recall the form of your treasured Saddleborn mount."
	spell_type = NONE
	charge_required = FALSE
	has_visual_effects = FALSE
	sound = null
	cooldown_time = 0

/datum/action/cooldown/spell/undirected/choose_riding_virtue_mount/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner

	var/area/place = get_area(user.loc)
	if (!place || !place.outdoors)
		to_chat(user, span_warning("You need to be outside! How do you expect your trusty steed to hear you?"))
		return

	var/list/choices = list(
		"applejack",
		"clownie",
		"fleur",
		"fluttershy",
		"luna",
		"celestia",
		"lyra",
		"mac",
		"pinkie",
		"rainbow",
		"rarity",
		"celestia",
		"trixie",
		"twilight",
		"vinyl",
		"whooves",
	)

	var/horse_type = pick(choices)

	var/mob/living/simple_animal/the_real_honse = new /mob/living/simple_animal/hostile/retaliate/honse/equestria(user.loc)
	the_real_honse.AddComponent(/datum/component/precious_creature, user)
	user.saddleborn_mount = WEAKREF(the_real_honse)

	the_real_honse.name = horse_type
	the_real_honse.icon_state = horse_type

	user.visible_message(span_info("[user] whistles sharply, and [the_real_honse] pads up from afar to their side."), span_notice("With a trusty whistle, my treasured steed returns to my side."))
	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	if (!user.buckled)
		the_real_honse.buckle_mob(user, TRUE)
		playsound(the_real_honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)

	user.add_spell(/datum/action/cooldown/spell/undirected/saddleborn/sendaway)
	user.add_spell(/datum/action/cooldown/spell/undirected/saddleborn/whistle)
	qdel(src) // one-time use — consumed on successful mount selection


// ---- Send Away ----

/datum/action/cooldown/spell/undirected/saddleborn/sendaway
	name = "Mount: Send Away"
	desc = "While outside, send your beloved steed away to fend for itself for a time. May take longer in more hostile climates."
	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/undirected/saddleborn/sendaway/cast(atom/cast_on)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()

	if (!user.Adjacent(honse))
		to_chat(user, span_warning("You need to be next to your steed to send them away!"))
		return FALSE

	var/should_heal = TRUE

	user.visible_message(span_info("[user] starts fussing with [honse], preparing to send them away..."), span_notice("I start preparing to send [honse] away to roam freely and safely for a time..."))
	honse.Immobilize(11 SECONDS)
	honse.unbuckle_all_mobs(TRUE)

	if (do_after(user, 10 SECONDS, honse) && check_mount())
		honse.unbuckle_all_mobs(TRUE)
		if (!honse.has_buckled_mobs())
			honse.moveToNullspace()
		else
			honse.visible_message(span_warning("[honse] pads the floor irritably, looking over its shoulder at the rider on its back."))
			return FALSE

		user.visible_message(span_notice("Patting [honse] on the haunches, [user] sends them trotting away."), span_notice("With a brief pat on the haunches, I send [honse] away to fend for themselves."))
		if (should_heal)
			honse.apply_status_effect(/datum/status_effect/buff/healing/saddleborn)
			to_chat(user, span_info("In these surroundings, they should be able to rest and recouperate a little."))
		return TRUE
	else
		honse.SetImmobilized(0)
		return FALSE


// ---- Whistle ----

/datum/action/cooldown/spell/undirected/saddleborn/whistle
	name = "Mount: Whistle"
	desc = "Call for your trusty steed, summoning it back to your side after a delay. Only works outdoors. May take longer in more hostile climates."
	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/undirected/saddleborn/whistle/cast(atom/cast_on)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	var/back_from_the_void = (honse.loc == null)
	var/callback_time = back_from_the_void ? 20 SECONDS : 10 SECONDS
	var/dangerous_summon = FALSE

	if (get_dist(honse.loc, user.loc) <= world.view)
		to_chat(user, span_warning("Your trusty steed is nearby!"))
		return FALSE

	if (callback_time <= 0)
		callback_time = 1 SECONDS

	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	user.visible_message(span_danger("[user] places their fingers into their mouth and blows a sharp, shrill whistle!"), span_info("I whistle for my trusty steed, and await their return!"))

	var/honse_base_loc = honse.loc
	var/area/honse_place = get_area(honse.loc)
	honse.unbuckle_all_mobs(TRUE)

	if (!back_from_the_void && honse_place.outdoors)
		honse.visible_message(span_notice("[honse] perks its ears up in response to a distant whistle, and darts off..."))
		playsound(honse, 'sound/magic/saddleborn-call.ogg', 50, FALSE)
		honse.moveToNullspace()

	if (do_after(user, callback_time))
		if (!back_from_the_void && honse_place && !honse_place.outdoors)
			to_chat(user, span_warning("...but nothing comes. They musn't have heard your whistling."))
			return TRUE

		honse.forceMove(user.loc)
		if (!user.buckled)
			honse.buckle_mob(user, TRUE)
		playsound(honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)

		if (dangerous_summon)
			if (!user.goodluck(10))
				user.consider_ambush(ignore_cooldown = TRUE)
		return TRUE
	else
		honse.forceMove(honse_base_loc)
		honse.visible_message(span_notice("[honse] trundles back into sight with a confused expression, ears swivelling to catch some manner of sound..."))
		return FALSE
