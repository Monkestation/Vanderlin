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
			new /obj/item/ash(loc)
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

	if(client)
		SSdroning.kill_droning(client)
		SSdroning.kill_loop(client)
		SSdroning.kill_rain(client)

	if(mind)
		if(!gibbed)
			var/datum/antagonist/vampire/VD = mind.has_antag_datum(/datum/antagonist/vampire)
			if(VD)
				dust(just_ash=TRUE,drop_items=TRUE)
				return

	if(client || mind)
		GLOB.vanderlin_round_stats[STATS_DEATHS]++
		var/area_of_death = lowertext(get_area_name(src))
		if(area_of_death == "wilderness")
			GLOB.vanderlin_round_stats[STATS_FOREST_DEATHS]++
		if(is_noble())
			GLOB.vanderlin_round_stats[STATS_NOBLE_DEATHS]++
		if(ishumannorthern(src))
			GLOB.vanderlin_round_stats[STATS_HUMEN_DEATHS]++
		if(mind)
			if(mind.assigned_role.title in GLOB.church_positions)
				GLOB.vanderlin_round_stats[STATS_CLERGY_DEATHS]++
			if(mind.has_antag_datum(/datum/antagonist/vampire))
				GLOB.vanderlin_round_stats[STATS_VAMPIRES_KILLED]++
			if(mind.has_antag_datum(/datum/antagonist/zombie) || mind.has_antag_datum(/datum/antagonist/skeleton) || mind.has_antag_datum(/datum/antagonist/lich))
				GLOB.vanderlin_round_stats[STATS_DEADITES_KILLED]++

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
		var/tris2take = 0
		if(istype(A, /area/rogue/indoors/town/cell))
			tris2take += -2
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
					tris2take += -2
				if(real_name in GLOB.outlawed_players)
					yeae = FALSE
		if(istype(src, /mob/living/carbon/human/species/skeleton/death_arena))
			tris2take = 0
		if(tris2take)
			adjust_triumphs(tris2take)
		else
			if(!istype(src, /mob/living/carbon/human/species/skeleton/death_arena) && get_triumphs() > 0)
				adjust_triumphs(-1)

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
				if(HU.RomanticPartner(src))
					HU.adjust_triumphs(-1)
				if(HU != src && !HAS_TRAIT(HU, TRAIT_BLIND))
					if(!HAS_TRAIT(HU, TRAIT_VILLAIN)) //temporary measure for npc skeletons
						if(HU.dna?.species && dna?.species)
							if(HU.dna.species.id == dna.species.id)
								var/mob/living/carbon/D = HU
								if(D.has_flaw(/datum/charflaw/addiction/maniac))
									D.add_stress(/datum/stressevent/viewdeathmaniac)
									D.sate_addiction()
								else
									D.add_stress(/datum/stressevent/viewdeath)

	. = ..()

	dizziness = 0
	jitteriness = 0
	dna.species.spec_death(gibbed, src)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()], CLONE: [src.getCloneLoss()])", LOG_ATTACK)

/mob/living/carbon/human/proc/zombie_check()
	if(!mind)
		return
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return mind.add_antag_datum(/datum/antagonist/zombie)

/mob/living/carbon/human/gib(no_brain, no_organs, no_bodyparts, safe_gib = FALSE)
	GLOB.vanderlin_round_stats[STATS_PEOPLE_GIBBED]++
	for(var/mob/living/carbon/human/CA in viewers(7, src))
		if(CA != src && !HAS_TRAIT(CA, TRAIT_BLIND))
			if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
				continue
			if(CA.RomanticPartner(src))
				CA.adjust_triumphs(-1)
			var/mob/living/carbon/V = CA
			if(V.has_flaw(/datum/charflaw/addiction/maniac))
				V.add_stress(/datum/stressevent/viewgibmaniac)
				V.sate_addiction()
				continue
			V.add_stress(/datum/stressevent/viewgib)
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
