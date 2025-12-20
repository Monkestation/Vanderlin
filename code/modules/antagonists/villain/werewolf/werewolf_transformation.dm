/datum/antagonist/werewolf/on_life(mob/user)
	if(!user) return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD) return
	if(H.advsetup) return
	// Werewolf transforms at night AND under the sky
	if(!HAS_TRAIT(user, TRAIT_WEREWOLF_RAGE))
		if(GLOB.tod == "night")
			if(isturf(H.loc))
				var/turf/loc = H.loc
				if(loc.can_see_sky())
					var/mob/living/carbon/human/human = user
					if(!is_species(H, /datum/species/werewolf))
						if(human.rage_datum?.rage > human.rage_datum.max_rage - 20)
							to_chat(H, span_userdanger("The moonlight scorns me... It is too late."))
					human.rage_datum?.update_rage(10)


/mob/living/carbon/human/species/werewolf/death(gibbed, nocutscene = FALSE)
	werewolf_untransform(null, TRUE, gibbed)

/mob/living/carbon/human/proc/werewolf_transform()
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		return
	if(HAS_TRAIT(src, TRAIT_WEREWOLF_RAGE))
		return
	if(mind?.has_antag_datum(/datum/antagonist/zombie))
		return
	if(is_species(src, /datum/species/werewolf))
		return

	ADD_TRAIT(src, TRAIT_WEREWOLF_RAGE, INNATE_TRAIT)

	var/brute_transfer = getBruteLoss()
	var/burn_transfer = getFireLoss()
	var/tox_transfer = getToxLoss()
	var/oxy_transfer = getOxyLoss()
	var/clone_transfer = getCloneLoss()

	flash_fullscreen("redflash3")
	emote("agony", forced = TRUE)
	to_chat(src, span_userdanger("UNIMAGINABLE PAIN!"))
	Stun(5 SECONDS)
	Knockdown(5 SECONDS)

	sleep(5 SECONDS)
	playsound_local(get_turf(src), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	rage_datum.rage_decay_rate += 5
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
//	stop_cmusic()

	fully_heal(FALSE)

	var/ww_path
	if(gender == MALE)
		ww_path = /mob/living/carbon/human/species/werewolf/male
	else
		ww_path = /mob/living/carbon/human/species/werewolf/female

	var/mob/living/carbon/human/species/werewolf/W = new ww_path(loc)

	W.set_patron(src.patron)
	W.gender = gender
	W.rage_datum = rage_datum
	W.regenerate_icons()
	W.stored_mob = src
	W.limb_destroyer = TRUE
	W.ambushable = FALSE
	W.skin_armor = new /obj/item/clothing/armor/regenerating/skin/werewolf_skin(W)
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	src.forceMove(W)

	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	mind.transfer_to(W)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/beast)

	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	to_chat(W, span_userdanger("I transform into a horrible beast!"))
	W.emote("rage")

	W.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	W.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	W.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

	W.base_constitution = 10 //werewolf.dm in the species has their ACTUAL stats, don't edit these, they'll make them stack ontop of each other.
	W.base_strength = 10
	W.base_endurance = 10
	W.recalculate_stats()

	W.add_spell(/datum/action/cooldown/spell/undirected/howl)
	W.add_spell(/datum/action/cooldown/spell/undirected/claws)
	W.add_spell(/datum/action/cooldown/spell/aoe/repulse/howl)
	W.add_spell(/datum/action/cooldown/spell/woundlick)
	W.add_spell(/datum/action/cooldown/spell/lunge)
	W.add_spell(/datum/action/cooldown/spell/throw_target)

	W.rage_datum.grant_to_secondary(W)


	W.adjustBruteLoss(brute_transfer)
	W.adjustFireLoss(burn_transfer)
	W.adjustToxLoss(tox_transfer)
	W.adjustOxyLoss(oxy_transfer)
	W.adjustCloneLoss(clone_transfer)

	invisibility = oldinv

/mob/living/carbon/human/proc/werewolf_untransform(mob/bleh, dead,gibbed)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!stored_mob)
		var/mob/living/carbon/human/species/werewolf/wolf = loc
		if(istype(wolf))
			wolf.werewolf_untransform(null, dead, gibbed)
		return
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null
	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_GENERIC)
	if(dead)
		W.death(gibbed)

	W.forceMove(get_turf(src))

	var/brute_transfer = getBruteLoss()
	var/burn_transfer = getFireLoss()
	var/tox_transfer = getToxLoss()
	var/oxy_transfer = getOxyLoss()
	var/clone_transfer = getCloneLoss()

	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_GENERIC)

	mind.transfer_to(W)

	var/mob/living/carbon/human/species/werewolf/WA = src
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()

	W.remove_spell(/datum/action/cooldown/spell/undirected/howl)
	W.remove_spell(/datum/action/cooldown/spell/undirected/claws)
	W.remove_spell(/datum/action/cooldown/spell/aoe/repulse/howl)
	W.remove_spell(/datum/action/cooldown/spell/woundlick)
	W.remove_spell(/datum/action/cooldown/spell/lunge)
	W.remove_spell(/datum/action/cooldown/spell/throw_target)
	W.rage_datum.remove_secondary()
	W.regenerate_icons()

	REMOVE_TRAIT(W, TRAIT_WEREWOLF_RAGE, INNATE_TRAIT)
	W.rage_datum.rage_decay_rate -= 5

	to_chat(W, span_userdanger("I return to my facade."))
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	W.Knockdown(30)
	W.Stun(30)

	W.adjustBruteLoss(brute_transfer)
	W.adjustFireLoss(burn_transfer)
	W.adjustToxLoss(tox_transfer)
	W.adjustOxyLoss(oxy_transfer)
	W.adjustCloneLoss(clone_transfer)

	qdel(src)
