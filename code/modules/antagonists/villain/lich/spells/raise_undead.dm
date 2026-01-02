/datum/action/cooldown/spell/raise_undead
	name = "Raise Undead"
	desc = "Raise a new skeleton from the fallen."
	button_icon_state = "raiseskele"
	sound = 'sound/magic/magnet.ogg'

	attunements = list(
		/datum/attunement/dark = 0.4,
		/datum/attunement/death = 1,
	)

	charge_time = 6 SECONDS
	charge_drain = 1
	charge_slowdown = 0.3
	cooldown_time = 30 SECONDS
	spell_cost = 40

/datum/action/cooldown/spell/raise_undead/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on) && !istype(cast_on, /mob/living/carbon/human/species/goblin)

/datum/action/cooldown/spell/raise_undead/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.stat != DEAD)
		to_chat(owner, span_warning("I cannot raise the living."))
		return . | SPELL_CANCEL_CAST

	var/obj/item/bodypart/cast_on_head = cast_on.get_bodypart(BODY_ZONE_HEAD)
	if(!cast_on_head)
		to_chat(owner, span_warning("This corpse is headless."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/raise_undead/cast(mob/living/carbon/human/cast_on)
	. = ..()
	owner.say("Hgf'ant'kthar!")

	cast_on.visible_message(span_warning("[cast_on.real_name]'s body is engulfed by dark energy..."), runechat_message = TRUE)

	if(cast_on.ckey) //player still inside body
		var/offer = browser_alert(cast_on, "Do you wish to be reanimated as a minion?", "RAISED BY NECROMANCER", DEFAULT_INPUT_CHOICES, 5 SECONDS)

		if(offer == CHOICE_YES)
			to_chat(cast_on, span_danger("You rise as a minion."))
			cast_on.turn_to_minion(owner, cast_on.ckey)
			cast_on.visible_message(span_warning("[cast_on.real_name]'s eyes light up with an evil glow."), runechat_message = TRUE)
			return
		else
			to_chat(cast_on, span_danger("Another soul will take over."))

	var/list/candidates = pollCandidatesForMob("Do you want to play as a Necromancer's minion?", null, null, null, 100, cast_on, POLL_IGNORE_NECROMANCER_SKELETON)
	if(length(candidates))
		var/mob/C = pick(candidates)
		cast_on.turn_to_minion(owner, C.ckey)
		cast_on.visible_message(span_warning("[cast_on.real_name]'s eyes light up with an eerie glow."), runechat_message = TRUE)
	else
		cast_on.turn_to_minion(owner)
		cast_on.visible_message(span_warning("[cast_on.real_name]'s eyes light up with a weak glow."), runechat_message = TRUE)

/mob/living/carbon/human/proc/turn_to_minion(mob/living/carbon/human/master, ckey)
	if(!master)
		return FALSE

	revive(TRUE, TRUE)

	if(ckey) //player
		ckey = ckey
	else //npc
		ai_controller = new /datum/ai_controller/human_npc(src)
		AddComponent(/datum/component/ai_aggro_system)
		wander = TRUE

	clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)
	clamped_adjust_skillrank(/datum/skill/combat/crossbows, 2, 3, TRUE)
	clamped_adjust_skillrank(/datum/skill/combat/wrestling, 1, 3, TRUE)
	clamped_adjust_skillrank(/datum/skill/combat/unarmed, 1, 3, TRUE)
	clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 3, TRUE)

	mind.current.job = null

	dna.species.species_traits |= NOBLOOD
	dna.species.soundpack_m = new /datum/voicepack/skeleton()
	dna.species.soundpack_f = new /datum/voicepack/skeleton()

	base_strength = 9
	base_perception = 11
	base_endurance = 9
	base_constitution = 8
	base_intelligence = 8
	base_speed = 11
	base_fortune = 9
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

	set_patron(master.patron)
	copy_known_languages_from(master, TRUE)
	mob_biotypes = MOB_UNDEAD
	faction = list(FACTION_UNDEAD)
	ambushable = FALSE
	candodge = FALSE

	skeletonize(FALSE)
	skele_look()
	grant_undead_eyes()

	if(charflaw)
		QDEL_NULL(charflaw)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOENERGY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

	update_body()

	to_chat(src, span_userdanger("My master is [master.real_name]."))

	master.minions += src

	return TRUE
