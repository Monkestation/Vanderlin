/datum/antagonist/werewolf/on_life(mob/user)
	if(!user) return
	var/mob/living/carbon/human/human_user = user
	if(human_user.stat == DEAD) return
	if(human_user.advsetup) return
	if(GLOB.tod == "night")
		var/turf/user_loc = human_user.loc
		if(isturf(user_loc))
			if(user_loc.can_see_sky())
				if(!transformed)
					if(COOLDOWN_FINISHED(src, message_cooldown))
						to_chat(human_user, span_userdanger("The moonlight scorns me, inflaming my rage!"))
						COOLDOWN_START(src, message_cooldown, 5 SECONDS)
				human_user.rage_datum.update_rage(10)

	if(transformed && !HAS_TRAIT(human_user, TRAIT_PARALYSIS))
		if(human_user.rage_datum.check_rage(text2num(WW_RAGE_MEDIUM)))
			if(human_user.blood_volume > BLOOD_VOLUME_SURVIVE)
				for(var/datum/wound/wound as anything in human_user.get_wounds())
					wound.heal_wound(1.2)

/datum/antagonist/werewolf/proc/try_transform_checks()
	if(QDELETED(src))
		return FALSE
	var/mob/living/carbon/human/human_user = owner.current
	if(QDELETED(human_user) || human_user.stat >= UNCONSCIOUS || !human_user.mind)
		return FALSE
	if(HAS_TRAIT(human_user, TRAIT_NO_TRANSFORM))
		return FALSE
	if(HAS_TRAIT(human_user, TRAIT_SILVER_BLESSED))
		return FALSE
	if(transformed)
		return FALSE
	return TRUE

/datum/antagonist/werewolf/proc/begin_transform()
	set waitfor = 0

	if(!try_transform_checks()) return

	var/mob/living/carbon/human/human_user = owner.current
	ADD_TRAIT(human_user, TRAIT_NO_TRANSFORM, REF(src))
	human_user.flash_fullscreen("redflash3")
	human_user.emote("agony", forced = TRUE)
	to_chat(human_user, span_userdanger("UNIMAGINABLE PAIN!"))
	human_user.Stun(5.1 SECONDS, ignore_canstun = TRUE)
	human_user.Knockdown(5.1 SECONDS, ignore_canstun = TRUE)
	sleep(2.5 SECONDS)
	human_user.emote("agony", forced = TRUE)
	sleep(2.5 SECONDS)
	REMOVE_TRAIT(human_user, TRAIT_NO_TRANSFORM, REF(src))

	if(!try_transform_checks()) return

	werewolf_transform()

/datum/antagonist/werewolf/proc/werewolf_transform()
	if(!try_transform_checks()) return

	var/mob/living/carbon/human/human_user = owner.current

	if(human_user.cmode)
		human_user.toggle_cmode()

	pre_transformation()

	// Actual transformation step
	var/mob/living/carbon/human/species/werewolf/new_werewolf = generate_werewolf(human_user)
	new_werewolf.apply_status_effect(/datum/status_effect/shapechange_mob/die_with_form, human_user, FALSE)
	new_werewolf.dna?.species.after_creation(new_werewolf) // funny accented werewolf
	new_werewolf.set_patron(human_user.patron)
	human_user.rage_datum.grant_to_secondary(new_werewolf)
	human_user.rage_datum.rage_change_on_life -= transformed_rage_decay

	new_werewolf.adjustBruteLoss(human_user.getBruteLoss() / 2)
	new_werewolf.adjustFireLoss(human_user.getFireLoss() / 2)
	new_werewolf.adjustToxLoss(human_user.getToxLoss() / 2)
	new_werewolf.adjustOxyLoss(human_user.getOxyLoss() / 2)
	new_werewolf.adjustCloneLoss(human_user.getCloneLoss() / 2)
	new_werewolf.blood_volume = human_user.blood_volume
	human_user.fully_heal(HEAL_DAMAGE|HEAL_BLOOD|HEAL_WOUNDS|HEAL_RESTRAINTS)

	playsound(new_werewolf, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	new_werewolf.playsound_local(get_turf(new_werewolf), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	to_chat(new_werewolf, span_userdanger("I transform into a horrible beast!"))
	new_werewolf.emote("rage")
	new_werewolf.spawn_gibs(FALSE)

	transformed = TRUE
	RegisterSignal(new_werewolf, COMSIG_LIVING_UNSHAPESHIFTED, PROC_REF(werewolf_untransform))

/datum/antagonist/werewolf/proc/pre_transformation()
	var/mob/living/carbon/human/human_user = owner.current
	for(var/obj/item/item as anything in human_user.get_equipped_items(FALSE))
		if(istype(item, /obj/item/clothing) || istype(item, /obj/item/storage/belt))
			item.take_damage(damage_amount = item.max_integrity * 0.15, sound_effect = FALSE)
		else
			human_user.dropItemToGround(item, silent = TRUE)

/datum/antagonist/werewolf/proc/generate_werewolf(mob/living/carbon/human/user)
	var/mob/living/carbon/human/species/werewolf/new_werewolf = new (get_turf(user))
	new_werewolf.age = user.age
	new_werewolf.real_name = wolfname
	new_werewolf.name = wolfname
	new_werewolf.skin_armor = new /obj/item/clothing/armor/regenerating/skin/werewolf_skin(new_werewolf)

	new_werewolf.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	new_werewolf.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	new_werewolf.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

	for(var/datum/action/werewolf_power as anything in werewolf_form_powers)
		new_werewolf.add_spell(werewolf_power)

	return new_werewolf

/// Helper to remove werewolf transformation effect from owner.current
/datum/antagonist/werewolf/proc/remove_werewolf(forced)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/werewolf_user = owner.current
	if(!transformed)
		return
	if(!forced && HAS_TRAIT(werewolf_user, TRAIT_NO_TRANSFORM))
		return
	werewolf_user.remove_status_effect(/datum/status_effect/shapechange_mob/die_with_form)

/// Called with COMSIG_LIVING_UNSHAPESHIFTED signal
/datum/antagonist/werewolf/proc/werewolf_untransform(mob/living/status_owner, mob/living/status_caster_mob)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/werewolf_user = status_owner
	for(var/obj/item/dropped_item in werewolf_user)
		werewolf_user.dropItemToGround(dropped_item, silent = TRUE)
	var/mob/living/carbon/human/caster_mob = status_caster_mob
	INVOKE_ASYNC(werewolf_user, TYPE_PROC_REF(/mob, emote), "scream")

	to_chat(caster_mob, span_userdanger("The beast within returns to slumber."))
	playsound(caster_mob, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	caster_mob.Knockdown(30)
	caster_mob.Stun(30)
	caster_mob.rage_datum.remove_secondary()
	caster_mob.rage_datum.rage_change_on_life += transformed_rage_decay

	caster_mob.adjustBruteLoss(werewolf_user.getBruteLoss() / 2)
	caster_mob.adjustFireLoss(werewolf_user.getFireLoss() / 2)
	caster_mob.adjustToxLoss(werewolf_user.getToxLoss() / 2)
	caster_mob.adjustOxyLoss(werewolf_user.getOxyLoss() / 2)
	caster_mob.adjustCloneLoss(werewolf_user.getCloneLoss() / 2)
	// caster_mob.blood_volume = werewolf_user.blood_volume

	UnregisterSignal(werewolf_user, COMSIG_LIVING_UNSHAPESHIFTED)
	transformed = FALSE
