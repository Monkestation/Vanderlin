/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-h")

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, "dust-h")

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(with_bodyparts)
		new /obj/effect/gibspawner/human(drop_location(), src)
	else
		new /obj/effect/gibspawner/human/bodypartless(drop_location(), src)

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		for(var/i in 1 to 5)
			new /obj/item/fertilizer/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/proc/rogueviewers(range, object)
	. = list(viewers(range, object))
	if(isliving(object))
		var/mob/living/LI = object
		for(var/mob/living/L in .)
			if(!L.can_see_cone(LI))
				. -= L
			if(HAS_TRAIT(L, TRAIT_BLIND))
				. -= L

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return

	var/area/A = get_area(src)

	if(mind)
		if(!gibbed)
			var/datum/antagonist/vampire/VD = mind.has_antag_datum(/datum/antagonist/vampire)
			if(VD)
				dust(just_ash=TRUE,drop_items=TRUE)
				return

	if(client || mind)
		record_round_statistic(STATS_DEATHS)
		var/area_of_death = lowertext(get_area_name(src))
		if(area_of_death == "wilderness")
			record_round_statistic(STATS_FOREST_DEATHS)
		if(is_noble())
			record_round_statistic(STATS_NOBLE_DEATHS)
		if(ishumannorthern(src))
			record_round_statistic(STATS_HUMEN_DEATHS)
		if(mind)
			if((mind.assigned_role.title in GLOB.church_positions) || (mind.assigned_role.title in GLOB.inquisition_positions))
				record_round_statistic(STATS_CLERGY_DEATHS)
			if(mind.has_antag_datum(/datum/antagonist/vampire))
				record_round_statistic(STATS_VAMPIRES_KILLED)
			if(mind.has_antag_datum(/datum/antagonist/zombie) || mind.has_antag_datum(/datum/antagonist/skeleton) || mind.has_antag_datum(/datum/antagonist/lich))
				record_round_statistic(STATS_DEADITES_KILLED)

	if(!gibbed)
		if(!has_world_trait(/datum/world_trait/necra_requiem))
			if(!is_in_roguetown(src) || has_world_trait(/datum/world_trait/zizo_defilement))
				zombie_check()

	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(H)
		H.beat = BEAT_NONE

	if(!MOBTIMER_EXISTS(src, MT_DEATHDIED))
		MOBTIMER_SET(src, MT_DEATHDIED)
		if(H in SStreasury.bank_accounts)
			for(var/obj/structure/fake_machine/camera/C in view(7, src))
				var/area_name = A.name
				var/texty = "<CENTER><B>Death of a Living Being</B><br>---<br></CENTER>"
				texty += "[real_name] perished in front of face #[C.number] ([area_name]) at [station_time_timestamp("hh:mm")]."
				SSroguemachine.death_queue += texty
				break

		var/yeae = TRUE //! TRUE if we were killed on a cross and socially rejected
		if(buckled)
			if(istype(buckled, /obj/structure/fluff/psycross) || istype(buckled, /obj/machinery/light/fueled/campfire/pyre))
				if((real_name in GLOB.excommunicated_players) || (real_name in GLOB.heretical_players))
					yeae = FALSE
				if(real_name in GLOB.outlawed_players)
					yeae = FALSE

		if(mind && yeae)
			// Omens are handled here
			if((is_lord_job(mind.assigned_role)))
				addomen(OMEN_NOLORD)
				for(var/mob/living/carbon/human/HU in GLOB.player_list)
					if(HU.stat <= CONSCIOUS && is_in_roguetown(HU))
						HU.playsound_local(get_turf(HU), 'sound/music/lorddeath.ogg', 80, FALSE, pressure_affected = FALSE)

			if(is_priest_job(mind.assigned_role))
				addomen(OMEN_NOPRIEST)

		if(!gibbed && yeae)
			for(var/mob/living/carbon/human/HU in viewers(7, src))
				if(HU != src && !HAS_TRAIT(HU, TRAIT_BLIND))
					if(!HAS_TRAIT(HU, TRAIT_VILLAIN)) //temporary measure for npc skeletons
						if(HU.dna?.species && dna?.species)
							if(HU.dna.species.id == dna.species.id)
								var/mob/living/carbon/D = HU
								if(D.has_quirk(/datum/quirk/vice/maniac))
									D.add_stress(/datum/stress_event/viewdeathmaniac)
									D.sate_addiction(/datum/quirk/vice/maniac)
								else
									D.add_stress(/datum/stress_event/viewdeath)

	dna.species.spec_death(gibbed, src) // parent call deletes dna

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()], CLONE: [src.getCloneLoss()])", LOG_ATTACK)

/mob/living/carbon/human/proc/zombie_check()
	if(!mind)
		return
	var/datum/antagonist/zombie = mind.has_antag_datum(/datum/antagonist/zombie)
	if(zombie)
		return zombie
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return mind.add_antag_datum(/datum/antagonist/zombie)

/mob/living/carbon/human/gib(no_brain, no_organs, no_bodyparts, safe_gib = FALSE)
	record_round_statistic(STATS_PEOPLE_GIBBED)
	for(var/mob/living/carbon/human/CA in viewers(7, src))
		if(CA != src && !HAS_TRAIT(CA, TRAIT_BLIND))
			if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
				continue
			var/mob/living/carbon/V = CA
			if(V.has_quirk(/datum/quirk/vice/maniac))
				V.add_stress(/datum/stress_event/viewgibmaniac)
				V.sate_addiction(/datum/quirk/vice/maniac)
				continue
			V.add_stress(/datum/stress_event/viewgib)
	. = ..()

/mob/living/carbon/human/revive(full_heal, admin_revive)
	. = ..()
	if(!.)
		return
	var/datum/job/human_job = SSjob.GetJob(job)
	if(human_job)
		switch(human_job.type)
			if(/datum/job/lord)
				removeomen(OMEN_NOLORD)
			if(/datum/job/priest)
				removeomen(OMEN_NOPRIEST)
