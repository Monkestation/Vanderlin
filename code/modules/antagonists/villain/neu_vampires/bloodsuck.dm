/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/proc/remove_bite()
	remove_overlay(BITE_LAYER)

/// Returns the amount of blood drank
/// ingest - results in blood reagents/impurities being transferred to the mob.
/// force - ignores the cooldown for drinking again.
/mob/living/proc/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed, drink_amt = 10, ingest=TRUE, force = FALSE)
	if(world.time <= next_move)
		return 0
	if(!force && !COOLDOWN_FINISHED(src, drinkblood_use))
		return 0
	if(HAS_TRAIT(victim, TRAIT_HUSK) || (NOBLOOD in victim.dna?.species?.species_traits) || victim.blood_volume <= 0)
		to_chat(src, span_warning("Sigh. No blood."))
		return 0
	var/datum/antagonist/vampire/VDrinker = mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(ingest && reagents.total_volume >= reagents.maximum_volume)
		to_chat(src, span_warning("Can't drink any more..."))
		return 0

	COOLDOWN_START(src, drinkblood_use, 1 SECONDS)
	changeNext_move(CLICK_CD_MELEE)

	var/mob/living/carbon/human/human_victim
	if(ishuman(victim))
		human_victim = victim
		human_victim.add_bite_animation()

	for(var/atom/I in victim.get_equipped_items())
		var/datum/enchantment/silver/ench = SSenchantment.get_enchantment(I, /datum/enchantment/silver)
		if(ench?.on_bite(I, src))
			return 0

	var/used_vitae = 0
	if(VDrinker)
		if(length(CheckEyewitness(victim)))
			vampire_detected(1)
		if(VVictim)
			if(victim.bloodpool <= 0 && clan)
				message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
				log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
				to_chat(src, span_danger("I have consumed my kindred!"))
				victim.death()
				return 0
			else
				to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))
				used_vitae = min(250, victim.bloodpool)

	drink_amt = min(victim.blood_volume, drink_amt)
	if(ingest)
		drink_amt = victim.transfer_blood_impurities(reagents, drink_amt, 1.5, src)
	if(used_vitae > 0)
		var/datum/blood_type/victim_blood = victim.get_blood_type()
		var/list/blood_data = victim_blood?.get_blood_data(victim)
		// if you added taste pref mults here kin could just suck each other off so dont
		// also no erp
		clan?.handle_bloodsuck(src, blood_data?["preferences"])
		adjust_bloodpool(used_vitae)
		victim.adjust_bloodpool(-used_vitae)
	victim.blood_volume = max(victim.blood_volume - drink_amt, 0)

	playsound(src, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	victim.visible_message(span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")
	return drink_amt

/mob/living/carbon/human/proc/vampire_conversion_prompt(mob/living/carbon/sire)
	if(HAS_TRAIT(src, "offered_vampirism"))
		return // my testing allowed to double up the prompts, so just incase
	if(!istype(sire?.mind?.has_antag_datum(/datum/antagonist/vampire), /datum/antagonist/vampire) || !sire.clan)
		return
	//we've confirmed a sire by this point
	var/mob/client_victim = src
	if(!client_victim.client)
		client_victim = get_ghost(FALSE, TRUE)
		if(!client_victim?.client)
			client_victim = get_spirit()
			if(!client_victim?.client)
				to_chat(sire, span_warning("[src]'s soul is beyond your grasp."))
				return

	var/datum/clan/C = sire.clan
	ADD_TRAIT(src, "offered_vampirism", INNATE_TRAIT)
	var/choice = browser_alert(client_victim, "You have been offered the immortal blessing. Take it, or perish.", "THE CURSE OF KAIN", list("I ACCEPT", "TO NECRA"), timeout = 15 SECONDS)
	if(QDELETED(src))
		return
	if(choice != "I ACCEPT")
		to_chat(client_victim, span_bloody("So be it."))
		var/obj/item/organ/brain/B = getorgan(/obj/item/organ/brain)
		B?.brain_death = TRUE
		death()
		if(!QDELETED(sire)) // sire coulda gibbed or some shit
			to_chat(sire, span_warning("[src] has refused your blessing."))
		return
	grab_ghost(TRUE, TRUE)
	revive((HEAL_DAMAGE|HEAL_AFFLICTIONS|HEAL_LIMBS|HEAL_WOUNDS), 500, TRUE)
	mind.add_antag_datum(new /datum/antagonist/vampire(C, TRUE))
	set_bloodpool(500)
	visible_message(span_danger("Some dark energy begins to flow into [src]..."))
	visible_message(span_red("[src] rises as a new spawn!"))
