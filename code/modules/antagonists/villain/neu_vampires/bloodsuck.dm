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
	if(!force && world.time < last_drinkblood_use + 2 SECONDS)
		return 0
	if(victim.blood_volume <= 0 || HAS_TRAIT(victim, TRAIT_HUSK) || (victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits)))
		to_chat(src, span_warning("Sigh. No blood."))
		return 0
	var/datum/antagonist/vampire/VDrinker = mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)
	//VDrinkers get exception to this because they can still drink vitae
	if(!VDrinker && ingest && reagents.total_volume >= reagents.maximum_volume)
		to_chat(src, span_warning("Can't drink any more..."))
		return 0

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	var/mob/living/carbon/human/human_victim
	if(ishuman(victim))
		human_victim = victim
		human_victim.add_bite_animation()

	for(var/atom/I in victim.contents)
		var/datum/enchantment/silver/ench = SSenchantment.get_enchantment(I, /datum/enchantment/silver)
		if(ench?.on_bite(I, src))
			return 0

	var/datum/blood_type/victim_blood = victim.get_blood_type()
	var/list/blood_data = victim_blood?.get_blood_data(victim)
	var/used_vitae = 0 // sets blood data at the end of the proc

	if(VDrinker)
		if(!victim.mind) // We're drinking from an NPC
			if(victim.bloodpool >= 250)
				used_vitae = 250
			else
				to_chat(src, span_warning("And yet, not enough vitae can be extracted from them... Tsk."))
		else
			if(VVictim)
				to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))
			if(human_victim)
				if(victim.bloodpool > 0)
					used_vitae = 150
					if(victim.bloodpool < used_vitae)
						used_vitae = victim.bloodpool // We assume they're left with 250 vitae or less, so we take it all
						to_chat(src, "<span class='warning'>...But alas, only leftovers...</span>")
				else
					if(victim.clan && clan)
						AdjustMasquerade(-1)
						message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
						log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
						to_chat(src, span_danger("I have... Consumed my kindred!"))
						victim.death()
						victim.adjustBruteLoss(-50, TRUE)
						victim.adjustFireLoss(-50, TRUE)
						return 0
					if(victim.stat != DEAD && !HAS_TRAIT(victim, TRAIT_BLOODLOSS_IMMUNE))
						victim.SetUnconscious(50 SECONDS)
						to_chat(src, "<span class='warning'>Your victim faints from the excessive draining.</span>")
				if(victim.bloodpool <= 150 && clan_position?.can_assign_positions && !victim.clan && !HAS_TRAIT(victim, TRAIT_BLOODLOSS_IMMUNE))
					if(browser_alert(src, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", list("MAKE IT SO", "I RESCIND")) != "MAKE IT SO")
						to_chat(src, span_warning("I decide [victim] is unworthy."))
					else
						INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

	var/blood_purity = 1 // what % of the drink_amt are we actually drinking as blood?
	if(ingest && reagents.total_volume < reagents.maximum_volume)
		var/ingesting_volume = min(reagents.maximum_volume - reagents.total_volume, drink_amt)
		if(victim.reagents.total_volume)
			var/list/blacklisted_reagents = list(/datum/reagent/steam, /datum/reagent/water, /datum/reagent/blood, /datum/reagent/consumable/nutriment)
			var/trans_volume = victim.reagents.total_volume
			for(var/reagent_type in blacklisted_reagents)
				trans_volume -= victim.reagents.get_reagent_amount(reagent_type)
			if(trans_volume > 0)
				blood_purity = victim.blood_volume / (victim.blood_volume + trans_volume)
				victim.reagents.trans_to(src, ingesting_volume * (1 - blood_purity), 1, transfered_by=src, method=INGEST, ignored_reagents=blacklisted_reagents)
		var/blood_to_drink = min(victim.blood_volume, ingesting_volume * blood_purity)
		blood_data?["vitae"] = used_vitae / blood_to_drink
		var/datum/reagents/holder = new(maximum = blood_to_drink)
		// if someone adds kool aid as a blood type then blood_data here might need some work
		holder.add_reagent(victim_blood.reagent_type, blood_to_drink, blood_data, no_react = TRUE)
		holder.trans_to(src, holder.total_volume, transfered_by=src, method = INGEST)
	else
		if(used_vitae > 0)
			adjust_bloodpool(used_vitae)
			clan?.handle_bloodsuck(src, blood_data["preferences"])

	if(used_vitae > 0)
		victim.adjust_bloodpool(VVictim ? -used_vitae * 2 : -used_vitae) //twice the loss
	var/bloodloss =  min(victim.blood_volume, drink_amt * blood_purity)
	victim.blood_volume -= bloodloss
	victim.handle_blood()

	playsound(src, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	victim.visible_message(span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")
	return bloodloss

/mob/living/carbon/human/proc/vampire_conversion_prompt(mob/living/carbon/sire)
	if(HAS_TRAIT(src, "choosing"))
		return
	var/datum/antagonist/vampire/VDrinker = sire?.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!istype(VDrinker))
		return
	ADD_TRAIT(src, "choosing", INNATE_TRAIT)
	if(browser_alert(src, "Would you like to rise as a vampire spawn? Warning: you will die shall you reject.", "THE CURSE OF KAIN", list("MAKE IT SO", "I RESCIND")) != "MAKE IT SO")
		REMOVE_TRAIT(src, "choosing", INNATE_TRAIT)
		to_chat(sire, span_danger("Your victim twitches, yet the curse fails to take over. As if something otherworldly intervenes..."))
		death()
		return
	REMOVE_TRAIT(src, "choosing", INNATE_TRAIT)
	visible_message(span_danger("Some dark energy begins to flow from [sire] into [src]..."))
	visible_message(span_red("[src] rises as a new spawn!"))
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(sire.clan, TRUE)
	mind.add_antag_datum(new_antag)
	adjust_bloodpool(500)
	fully_heal()
