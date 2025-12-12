/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/proc/remove_bite()
	remove_overlay(BITE_LAYER)


/mob/living/proc/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed, drink_amt = 10)
	if(world.time <= next_move)
		return
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return
	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("Sigh. No blood."))
		return
	if(victim.blood_volume <= 0)
		to_chat(src, span_warning("Sigh. No blood."))
		return
	var/mob/living/carbon/human/human_victim
	if(ishuman(victim))
		human_victim = victim
		human_victim.add_bite_animation()

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	var/datum/antagonist/vampire/VDrinker = mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)

	if(VDrinker)
		for(var/I in victim.contents)
			if(SSenchantment.has_enchantment(I, /datum/enchantment/silver))
				to_chat(src, span_userdanger("THEY ARE WEARING MY BANE! HISSS!!!"))
				Paralyze(1)
				return

	// You need the blooddrinker trait. otherwise, you'll throw up. A side effect of this is compatibility with non-human vampires
	// They also can't have the foulblood trait unless you also do. This includes the inability to drink Nosferatu, even if they prefer kin blood.
	if((!HAS_TRAIT(src, TRAIT_BLOODDRINKER)) || (HAS_TRAIT(victim, TRAIT_FOULBLOOD) && !HAS_TRAIT(src, TRAIT_FOULBLOOD)))
		to_chat(src, span_warning("I'm going to puke..."))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
	else if(VDrinker)
		if(!victim.mind) // We're drinking from an NPC or a person who disconnected from the game
			if(victim.bloodpool >= 250)
				src.adjust_bloodpool(250, 250)
			else
				to_chat(src, span_warning("And yet, not enough vitae can be extracted from them... Tsk."))
		else
			if(VVictim)
				to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))
			var/blood_handle
			if(victim.stat == DEAD)
				blood_handle |= BLOOD_PREFERENCE_DEAD
			else
				blood_handle |= BLOOD_PREFERENCE_LIVING

			if(victim.job in list("Priest", "Priestess", "Cleric", "Acolyte", "Templar", "Churchling", "Crusader", "Inquisitor"))
				blood_handle |= BLOOD_PREFERENCE_HOLY
			if(VVictim)
				blood_handle |= BLOOD_PREFERENCE_KIN
				blood_handle  &= ~BLOOD_PREFERENCE_LIVING

			if(HAS_TRAIT(victim, TRAIT_SILVER_BLESSED))
				blood_handle |= BLOOD_PREFERENCE_FANCY
				blood_handle |= BLOOD_PREFERENCE_EUPHORIC

			if(victim.bloodpool > 0)
				if(human_victim)
					var/used_vitae = 150
					if(victim.bloodpool < used_vitae)
						used_vitae = victim.bloodpool // We assume they're left with 250 vitae or less, so we take it all
						to_chat(src, "<span class='warning'>...But alas, only leftovers...</span>")
					src.adjust_bloodpool(used_vitae)
					src.adjust_hydration(used_vitae * 0.1)
					if(VVictim)
						victim.adjust_bloodpool(-used_vitae) //twice the loss
					victim.adjust_bloodpool(-used_vitae)
				clan.handle_bloodsuck(src, blood_handle)
			else
				if(human_victim && victim.clan && clan)
					AdjustMasquerade(-1)
					message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
					log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
					to_chat(src, span_danger("I have... Consumed my kindred!"))
					victim.death()
					victim.adjustBruteLoss(-50, TRUE)
					victim.adjustFireLoss(-50, TRUE)
					return
				if(victim.stat != DEAD && !HAS_TRAIT(victim, TRAIT_BLOODLOSS_IMMUNE))
					victim.SetUnconscious(50 SECONDS)
					to_chat(src, "<span class='warning'>Your victim faints from the excessive draining.</span>")

			if(human_victim && !victim.clan && clan_position?.can_assign_positions && victim.bloodpool <= 150 && !HAS_TRAIT(victim, TRAIT_BLOODLOSS_IMMUNE))
				if(browser_alert(src, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", list("MAKE IT SO", "I RESCIND")) != "MAKE IT SO")
					to_chat(src, span_warning("I decide [victim] is unworthy."))
				else
					INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

	victim.blood_volume = max(victim.blood_volume-drink_amt, 0)
	victim.handle_blood()

	playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	victim.visible_message(span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")

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
