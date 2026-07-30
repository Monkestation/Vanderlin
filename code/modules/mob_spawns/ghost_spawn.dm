///these mob spawn subtypes do not trigger until attacked by a ghost.
/obj/effect/mob_spawn/ghost_role
	abstract_type = /obj/effect/mob_spawn/ghost_role
	///a short, lowercase name for the mob used in possession prompt that pops up on ghost attacks. must be set.
	var/prompt_name = ""
	///if false, you won't prompt for this role. best used for replacing the prompt system with something else like a radial, or something.
	var/prompt_ghost = TRUE
	///how many times this spawner can be used (it won't delete unless it's out of uses)
	var/uses = 1
	/// Does the spawner delete itself when it runs out of uses?
	var/deletes_on_zero_uses_left = TRUE
	///bitflag that determines if players can spawn in as their statics
	var/allow_custom_character = NONE
	/// Can this spawner be used up
	var/infinite_use = FALSE

	////descriptions

	///This should be the declaration of what the ghost role is, and maybe a short blurb after if you want. Shown in the spawner menu and after spawning first.
	var/you_are_text = ""
	///This should be the actual instructions/description/context to the ghost role. This should be the really long explainy bit, basically.
	var/flavour_text = ""
	///This is critical non-policy information about the ghost role. Shown in the spawner menu and after spawning last.
	var/important_text = ""

	///Show these on spawn? Usually used for hardcoded special flavor
	var/show_flavor = TRUE

	/// Whether this offers a temporary body or not. Essentially, you'll be able to reenter your body after using this spawner.
	var/temp_body = FALSE

	////bans and policy

	///which role to check for a job ban (ROLE_MANIAC is the default ghost role ban)
	var/role_ban = ROLE_MANIAC
	/// Typepath indicating the kind of job datum this ghost role will have. PLEASE inherit this with a new job datum, it's not hard. jobs come with policy configs.
	var/spawner_job_path = null

/obj/effect/mob_spawn/ghost_role/Initialize(mapload)
	. = ..()
	GLOB.poi_list |= src
	LAZYADD(GLOB.mob_spawners[name], src)

/obj/effect/mob_spawn/Destroy()
	GLOB.poi_list -= src
	var/list/spawners = GLOB.mob_spawners[name]
	LAZYREMOVE(spawners, src)
	if(!LAZYLEN(spawners))
		GLOB.mob_spawners -= name
	return ..()

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/mob_spawn/ghost_role/attack_ghost(mob/dead/observer/user)
	if(!SSticker.HasRoundStarted() || isnull(loc) || QDELETED(src))
		return
	// Lazylist of the ckeys that currently are trying to access any spawner, so that they can't try to spawn more than once (in case there's sleeps).
	var/static/list/ckeys_trying_to_spawn
	if(locate(user.ckey) in ckeys_trying_to_spawn)
		return
	if(uses <= 0 && !infinite_use)
		to_chat(user, span_warning("This spawner is out of charges!"))
		return FALSE
	if(!can_ghost_take(user))
		return FALSE

	uses -= 1 // Remove a use EARLY to account for sleep / inputs
	var/user_ckey = user.ckey // Just in case shenanigans happen, we always want to remove it from the list.
	LAZYADD(ckeys_trying_to_spawn, user_ckey)

	var/prompt_fail = FALSE
	var/apply_prefs = FALSE
	if(prompt_ghost)
		var/prompt = "Become [prompt_name]?"
		if(!temp_body && user.can_reenter_corpse && user.mind)
			prompt += " (Warning, You can no longer be revived!)"
		prompt_fail = browser_alert(user, prompt, buttons = list("Yes", "No"), timeout = 10 SECONDS) != "Yes"

	var/species_pref = user.client.prefs.pref_species || /datum/species/human/northern
	if(!prompt_fail && user.started_as_observer && allow_custom_character)
		var/static_prompt = "Because you haven't taken a role so far, you may spawn in as \
			[((allow_custom_character & GHOSTROLE_TAKE_PREFS_SPECIES) || species_pref == /datum/species/human/northern) ? "" : "a human version of"] \
			your customized character with a random name. Would you like to?"
		apply_prefs = browser_alert(user, static_prompt, "Custom Character", list("Yes", "No"), 10 SECONDS) == "Yes"

	if(!prompt_fail && !pre_ghost_take(user))
		prompt_fail = TRUE

	if(prompt_fail || !can_ghost_take(user) || !create_from_ghost(user, apply_prefs, subtract_uses = FALSE))
		uses += 1

	LAZYREMOVE(ckeys_trying_to_spawn, user_ckey)

/// Allows for modifications before the ghost is turned into a mob.
/// You can put sleeps or inputs in here, sanity checking is done for you after this proc returns.
/// Returning FALSE will cancel the spawn process.
/obj/effect/mob_spawn/ghost_role/proc/pre_ghost_take(mob/dead/observer/user)
	return TRUE

/// Checks if a ghost can take this ghost role.
/obj/effect/mob_spawn/ghost_role/proc/can_ghost_take(mob/dead/observer/user)
	if(is_banned_from(user.ckey, role_ban))
		to_chat(user, span_warning("You are banned from this role!"))
		return FALL_STOP_INTERCEPTING

	if(QDELETED(src) || QDELETED(user))
		return FALSE

	if(!allow_spawn(user, silent = FALSE))
		return FALSE

	return TRUE

/**
 * Uses a use and creates a mob from a passed ghost
 *
 * Does NOT validate that the spawn is possible or valid - assumes this has been done already!
 *
 * If you are manually forcing a player into this mob spawn,
 * you should be using this and not directly calling [proc/create].
 *
 * * * user - The ghost/mob that is possessing this mob
 * * * apply_prefs - Whether we should apply the possessor's preferences to the mob
 * * * subtract_uses - Whether to subtract a use from the spawner.
 * Set to FALSE if you want to handle uses manually elsewhere.
 */
/obj/effect/mob_spawn/ghost_role/proc/create_from_ghost(mob/dead/observer/user, apply_prefs, subtract_uses = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	ASSERT(istype(user))

	user.log_message("became a [prompt_name].", LOG_GAME)
	if(!temp_body)
		user.mind = null // dissassociate mind, don't let it follow us to the next life

	var/mob/created = create(user, apply_prefs = apply_prefs)
	if(ismob(created))
		SEND_SIGNAL(src, COMSIG_GHOSTROLE_SPAWNED, created)
		if(subtract_uses)
			uses -= 1
		check_uses()
	else if(isnull(created)) // null instead of explicit CANCEL_SPAWN means something went wrong
		CRASH("An instance of [type] didn't return anything when creating a mob, this might be broken!")

	return created

/obj/effect/mob_spawn/ghost_role/create(mob/mob_possessor, newname, apply_prefs)
	if(!mob_possessor.key) // This is in the scenario that the server is somehow lagging, or someone fucked up their code, and we try to spawn the same person in twice. We'll simply not spawn anything and CRASH(), so that we report what happened.
		CRASH("Attempted to create an instance of [type] with a mob that had no ckey attached to it, which isn't supported by ghost role spawners!")

	return ..()

/obj/effect/mob_spawn/ghost_role/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	if(mob_possessor)
		if(mob_possessor.client && apply_prefs && allow_custom_character && ishuman(spawned_mob))
			var/mob/living/carbon/human/spawned_human = spawned_mob
			if(allow_custom_character & GHOSTROLE_TAKE_PREFS_APPEARANCE)
				mob_possessor.client.prefs.apply_prefs_to(spawned_human, icon_updates = TRUE)
				if(mob_species) // :(((
					spawned_human.set_species(mob_species)
			if(allow_custom_character & GHOSTROLE_TAKE_PREFS_SPECIES)
				spawned_human.set_species(mob_possessor.client.prefs.pref_species)
				spawned_human.fully_replace_character_name(spawned_human.real_name, spawned_human.dna.species.random_name())
		if(mob_possessor.mind)
			mob_possessor.mind.transfer_to(spawned_mob, force_key_move = TRUE)
		else
			spawned_mob.PossessByPlayer(mob_possessor.key)

	var/datum/mind/spawned_mind = spawned_mob.mind
	if(spawned_mind)
		spawned_mob.mind.set_assigned_role(SSjob.GetJobType(spawner_job_path))
		spawned_mind.name = spawned_mob.real_name

	if(show_flavor)
		var/output_message = "<span class='big bold'>[you_are_text]</span>"
		if(flavour_text != "")
			output_message += "\n<span class='info'><b>[flavour_text]</b></span>"
		if(important_text != "")
			output_message += "\n[span_userdanger("[important_text]")]"
		to_chat(spawned_mob, output_message)

/// Checks if the spawner has zero uses left, if so, delete yourself... NOW!
/obj/effect/mob_spawn/ghost_role/proc/check_uses()
	if(!uses && deletes_on_zero_uses_left)
		qdel(src)

///override this to add special spawn conditions to a ghost role
/obj/effect/mob_spawn/ghost_role/proc/allow_spawn(mob/user, silent = FALSE)
	return TRUE

//almost all mob spawns in this game, dead or living, are human. so voila

/obj/effect/mob_spawn/ghost_role/human
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost_yellow"
	mob_type = /mob/living/carbon/human/species/human/northern
