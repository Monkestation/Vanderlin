/datum/attribute_modifier/zombie
	id = "Zombification"
	attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = -9,
		STAT_PERCEPTION = -5,
		STAT_INTELLIGENCE = -9,
		STAT_CONSTITUTION = 5,
		STAT_ENDURANCE = 5
	)

/datum/antagonist/zombie
	name = "Zombie"	// Deadite plague of Zizo
	roundend_category = "Deadites"
	antagpanel_category = "Zombie"
	antag_hud_type = ANTAG_HUD_HIDDEN
	antag_hud_name = "zombie"
	show_name_in_check_antagonists = TRUE
	show_in_roundend = FALSE
	antag_flags = FLAG_FAKE_ANTAG

	innate_traits = list(
		TRAIT_NOENERGY,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_STABLEHEART,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_NOSLEEP,
		TRAIT_SHOCKIMMUNE,
		TRAIT_SPELLBLOCK,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_CABAL,
		TRAIT_BLOODDRINKER,
		TRAIT_NASTY_EATER,
		TRAIT_NOMETABOLISM,
		TRAIT_NOAMBUSH,
		TRAIT_NO_SKILLS,
		TRAIT_NO_EXPERIENCE,
		TRAIT_UNDODGING,
		TRAIT_UNPARRYING
	)

	COOLDOWN_DECLARE(next_idle_sound)

	// CACHE VARIABLES SO ZOMBIFICATION CAN BE CURED
	var/was_i_undead
	var/old_special_role
	var/soundpack_m
	var/soundpack_f
	var/old_cmode_music
	var/list/base_intents
	var/datum/language_holder/prev_language
	var/datum/patron/patron
	var/old_bloodpool

	/// SET TO FALSE IF WE DON'T TURN INTO ROTMEN WHEN REMOVED
	var/become_rotman = FALSE
	/// Traits applied to the owner when we are cured and turn into just "rotmen"
	var/static/list/traits_rotman = list(
		TRAIT_EASYDISMEMBER,
		TRAIT_CRITICAL_WEAKNESS,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_NASTY_EATER,
	)
	var/mutable_appearance/rotflies

/datum/antagonist/zombie/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
			return span_boldnotice("Not food, not right..")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite. My ally.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another kind of deadite.")

/datum/antagonist/zombie/on_gain()
	. = ..()
	var/mob/living/carbon/human/zombie = owner.current
	if(!istype(zombie))
		qdel(src)
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		qdel(src)
		return

	cache_variables()
	if(zombie.stat >= DEAD)
		wake_zombie()
	transform_zombie()

/datum/antagonist/zombie/greet()
	to_chat(owner.current, span_userdanger("Death is not the end..."))
	return ..()

/datum/antagonist/zombie/on_life(mob/user)
	if(!user)
		return
	if(user.stat == DEAD)
		return
	var/mob/living/carbon/human/zombie = user
	if(COOLDOWN_FINISHED(src, next_idle_sound))
		zombie.emote("zmoan")
		COOLDOWN_START(src, next_idle_sound, rand(20 SECONDS, 40 SECONDS))

/datum/antagonist/zombie/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current_mob = mob_override || owner.current
	add_verb(current_mob, /mob/living/carbon/human/proc/zombie_seek)

/datum/antagonist/zombie/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current_mob = mob_override || owner.current
	remove_verb(current_mob, /mob/living/carbon/human/proc/zombie_seek)

/datum/antagonist/zombie/proc/cache_variables(mob/living/mob_override)
	var/mob/living/carbon/human/zombie = mob_override || owner.current
	was_i_undead = zombie.mob_biotypes & MOB_UNDEAD
	old_special_role = zombie.mind.special_role
	base_intents = zombie.base_intents
	old_cmode_music = zombie.cmode_music
	patron = zombie.patron
	old_bloodpool = zombie.bloodpool

	var/datum/language_holder/mob_language = zombie.get_language_holder()
	prev_language = mob_language?.copy()

	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f

/// You should probably not call this before cache_variables, just saying.
/datum/antagonist/zombie/proc/restore_variables(mob/living/mob_override)
	var/mob/living/carbon/human/zombie = mob_override || owner.current
	if(!was_i_undead)
		zombie.mob_biotypes &= ~MOB_UNDEAD
	zombie.mind.special_role = old_special_role
	zombie.base_intents = base_intents
	zombie.update_a_intents()
	zombie.cmode_music = old_cmode_music
	zombie.set_patron(patron)
	patron = null
	zombie.bloodpool = old_bloodpool

	zombie.copy_known_languages_from(prev_language, replace = TRUE)
	prev_language = null

	if(zombie.dna?.species)
		zombie.dna.species.soundpack_m = soundpack_m
		zombie.dna.species.soundpack_f = soundpack_f

/// Called when giving antag datum to dead people
/datum/antagonist/zombie/proc/wake_zombie(mob/living/mob_override)
	var/mob/living/carbon/human/zombie = mob_override || owner.current
	zombie.fully_heal(HEAL_TRAUMAS|HEAL_BLOOD|HEAL_BRUTE|HEAL_BURN|HEAL_WOUNDS)
	// Don't call carbon.regenerate_organs() so we don't spawn new organs
	for(var/obj/item/organ/organ as anything in zombie.internal_organs)
		organ.regenerate_organ()
	zombie.status_flags &= ~BLEEDOUT
	zombie.set_heartattack(FALSE)
	zombie.set_stat(UNCONSCIOUS) //Start unconscious
	zombie.updatehealth() //then we check if the mob should wake up
	zombie.reload_fullscreen()

	record_round_statistic(STATS_DEADITES_WOKEN_UP)
	zombie.ghostize()

/datum/antagonist/zombie/proc/transform_zombie(mob/living/mob_override)
	var/mob/living/carbon/human/zombie = mob_override || owner.current
	zombie.bloodpool = 0  // Deadites have no vitae to drain from
	zombie.cmode_music = 'sound/music/cmode/combat_weird.ogg'
	zombie.set_patron(/datum/patron/inhumen/zizo)
	zombie.mob_biotypes |= MOB_UNDEAD
	zombie.add_faction(FACTION_UNDEAD)
	zombie.remove_faction(list(FACTION_TOWN, FACTION_NEUTRAL))
	zombie.mind.special_role = name

	zombie.base_intents = list(INTENT_DISARM, INTENT_GRAB, INTENT_HARM, /datum/intent/unarmed/claw)
	zombie.update_a_intents()

	zombie.remove_all_languages()
	zombie.grant_language(/datum/language/undead)
	if(zombie.dna?.species)
		zombie.dna.species.native_language = "Zizo Chant"
		zombie.dna.species.accent_language = zombie.dna.species.get_accent(zombie.dna.species.native_language)
		zombie.dna.species.soundpack_m = new /datum/voicepack/zombie/m()
		zombie.dna.species.soundpack_f = new /datum/voicepack/zombie/f()

	zombie.fully_heal(HEAL_OXY|HEAL_TOX) //zombles dont breathe and are immune to poison
	for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts)
		if(!HAS_TRAIT(zombie_part, TRAIT_ROTTEN) && !zombie_part.skeletonized)
			zombie_part.kill_limb()
		if(zombie_part.can_be_disabled)
			zombie_part.update_disabled()
	zombie.update_body()
	zombie.grant_undead_eyes()

	zombie.add_client_colour(/datum/client_colour/monochrome)
	zombie.ai_controller = new /datum/ai_controller/zombie(zombie)
	zombie.AddComponent(/datum/component/ai_aggro_system)
	zombie.attributes?.add_attribute_modifier(/datum/attribute_modifier/zombie)

	rotflies = mutable_appearance('icons/roguetown/mob/rotten.dmi', "deadite[pick(1,2)]")
	zombie.add_overlay(rotflies)

/datum/antagonist/zombie/on_removal()
	var/mob/living/carbon/human/zombie = owner.current
	if (!istype(zombie))
		return

	restore_variables()
	zombie.remove_faction(FACTION_UNDEAD)
	zombie.add_faction(list(FACTION_TOWN, FACTION_NEUTRAL))

	zombie.cut_overlay(rotflies)
	zombie.attributes?.remove_attribute_modifier(/datum/attribute_modifier/zombie)
	zombie.remove_client_colour(/datum/client_colour/monochrome)

	for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts)
		zombie_part.revive_limb()
		zombie_part.set_germ_level(0)
		if(zombie_part.can_be_disabled)
			zombie_part.update_disabled()
		zombie_part.update_limb()
	zombie.update_body()

	var/datum/organ_dna/eyes/eye_dna = zombie.dna?.organ_dna[ORGAN_SLOT_EYES]
	if(eye_dna)
		for(var/obj/item/organ/old_eye in zombie.getorganslotlist(ORGAN_SLOT_EYES))
			old_eye.Remove(zombie, TRUE)
		var/obj/item/organ/eyes/eyes_one = eye_dna.create_organ(species = zombie.dna.species)
		eyes_one.Insert(zombie, TRUE)
		var/obj/item/organ/eyes/eyes_two = eye_dna.create_organ(species = zombie.dna.species)
		eyes_two.switch_side(eyes_two.side == RIGHT_SIDE ? LEFT_SIDE : RIGHT_SIDE)
		eyes_two.Insert(zombie, TRUE)

	// Bandaid to fix the zombie ghostizing not allowing you to re-enter
	var/mob/dead/observer/ghost = zombie.get_ghost(TRUE)
	if(ghost)
		ghost.can_reenter_corpse = TRUE

	if(become_rotman)
		zombie.set_stat_modifier(TRAIT_ROTMAN, STAT_CONSTITUTION, -5)
		zombie.set_stat_modifier(TRAIT_ROTMAN, STAT_SPEED, -5)
		zombie.set_stat_modifier(TRAIT_ROTMAN, STAT_INTELLIGENCE, -3)
		for(var/trait in traits_rotman)
			ADD_TRAIT(zombie, trait, TRAIT_ROTMAN)
		to_chat(zombie, span_green("I no longer crave flesh... <i>But I still feel ill.</i>"))
	else
		to_chat(zombie, span_green("I no longer crave flesh..."))

	return ..()

/mob/living/carbon/human/proc/zombie_seek()
	set name = "Seek Brains"
	set category = "RoleUnique.Zizo"

	if(!IS_DEADITE(src))
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	var/closest_dist
	var/the_dir
	for(var/mob/living/carbon/human/humie as anything in GLOB.human_list)
		if(humie == src)
			continue
		if(humie.mob_biotypes & MOB_UNDEAD)
			continue
		if(humie.stat >= DEAD)
			continue
		var/total_distance = get_dist(src, humie)
		if(!closest_dist)
			closest_dist = total_distance
			the_dir = get_dir(src, humie)
		else
			if(total_distance < closest_dist)
				closest_dist = total_distance
				the_dir = get_dir(src, humie)
	if(!closest_dist)
		to_chat(src, "<span class='warning'>I failed to smell anything...</span>")
		return FALSE
	to_chat(src, "<span class='warning'>[closest_dist] meters away, [dir2text(the_dir)]...</span>")
	return TRUE

/**
 * This occurs when one zombie infects a living human, going into instadeath from here is kind of shit and confusing
 * We instead just transform at the end
 */
/mob/living/carbon/human/proc/zombie_infect_attempt()
	if(!prob(7))
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return
	to_chat(src, "<span class='danger'>I feel horrible... REALLY horrible after that...</span>")
	if(get_blood_volume())
		MOBTIMER_SET(src, MT_PUKE)
		vomit(1, blood = TRUE, stun = FALSE)
	addtimer(CALLBACK(src, PROC_REF(wake_zombie)), 1 MINUTES)
	return TRUE

/mob/living/carbon/human/proc/wake_zombie()
	flash_fullscreen("redflash3")
	to_chat(src, "<span class='danger'>It hurts... Is this really the end for me?</span>")
	emote("scream") // heres your warning to others bro
	Knockdown(1)
	return zombie_check()
