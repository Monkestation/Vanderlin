/datum/antagonist/overlord
	name = "Overlord"
	roundend_category = "Overlord"
	antagpanel_category = "Overlord"
	job_rank = ROLE_LICH
	antag_hud_type = ANTAG_HUD_NECROMANCY
	antag_hud_name = "overlord"
	confess_lines = list(
		"MY DOMAIN SHALL EXPAND!",
		"THE PHYLACTERIES SUSTAIN ME!",
		"YOU CANNOT STOP MY EMPIRE!",
	)

	var/mob/camera/strategy_controller/overlord_controller/overlord_controller
	var/list/enchanted_doors = list()
	var/area/overlord_lair/lair_area
	var/list/built_phylacteries = list()
	var/controlling_rts = FALSE
	/// weak reference to the body so we can revive even if decapitated
	var/datum/weakref/overlord_body_ref

	innate_traits = list(
		TRAIT_NOSTAMINA,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_INHUMENCAMP,
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SEEPRICES,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_CABAL,
		TRAIT_DEATHSIGHT,
	)

	var/list/spells = list(
		/datum/action/cooldown/spell/projectile/fireball,
		/datum/action/cooldown/spell/projectile/blood_bolt,
		/datum/action/cooldown/spell/projectile/sickness,
		/datum/action/cooldown/spell/projectile/fetch,
		/datum/action/cooldown/spell/undirected/arcyne_eye,
		/datum/action/cooldown/spell/undirected/command_undead,
		/datum/action/cooldown/spell/strengthen_undead,
		/datum/action/cooldown/spell/raise_undead,
		/datum/action/cooldown/spell/diagnose,
		/datum/action/cooldown/spell/eyebite,
	)

/datum/antagonist/overlord/on_gain()
	lair_area = get_areas(/area/overlord_lair)[1]
	if(GLOB.lair_portal)
		var/obj/structure/overlord_portal/portal = GLOB.lair_portal
		portal.overlords |= src
		overlord_controller = new(get_turf(GLOB.lair_portal))
		overlord_controller.linked_overlord = src
	SSmapping.retainer.overlords |= owner
	owner.current?.purge_combat_knowledge() // purge all their combat skills first
	. = ..()
	if(iscarbon(owner.current))
		overlord_body_ref = WEAKREF(owner.current)
		RegisterSignal(owner.current, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	for(var/datum/action/spell as anything in spells)
		owner.current.add_spell(spell, source = src)

	owner.current.add_spell(/datum/action/cooldown/spell/enchant_door, source = src)
	owner.current.add_spell(/datum/action/cooldown/spell/undirected/enter_overseer_mode, source = src)
	owner.current.add_spell(/datum/action/cooldown/spell/remove_enchantment, source = src)
	owner.current.add_spell(/datum/action/cooldown/spell/undirected/summon_worker, source = src)

	owner.special_role = name
	move_to_spawnpoint()
	remove_job()
	owner.current?.roll_mob_stats()
	overlord_look()
	equip_overlord()

/datum/antagonist/overlord/on_removal()
	var/mob/living/overlord_mob = owner.current
	overlord_mob.remove_spells(source = src)
	UnregisterSignal(overlord_mob, COMSIG_LIVING_DEATH)
	if(overlord_controller)
		qdel(overlord_controller)

/datum/antagonist/overlord/greet()
	. = ..()
	to_chat(owner.current, span_userdanger("The power of dominion flows through you! Build your phylactery empire and rule from the shadows."))
	owner.announce_objectives()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/lichintro.ogg', 80, FALSE, pressure_affected = FALSE)

/datum/antagonist/overlord/move_to_spawnpoint()
	return

/datum/antagonist/overlord/proc/overlord_look()
	var/mob/living/carbon/human/L = owner.current
	L.skeletonize(FALSE)
	L.skele_look()

/datum/antagonist/overlord/proc/equip_overlord()
	owner.forget_and_be_forgotten()
	var/mob/living/carbon/human/L = owner.current

	L.mana_pool.intrinsic_recharge_sources &= ~MANA_ALL_LEYLINES
	L.mana_pool.set_intrinsic_recharge(MANA_SOULS)
	L.mana_pool.ethereal_recharge_rate += 0.2

	L.cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	if(prob(10))
		L.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'
	L.faction = list(FACTION_UNDEAD)
	if(length(L.quirks))
		L.clear_quirks()
	L.mob_biotypes |= MOB_UNDEAD
	L.dna.species.species_traits |= NOBLOOD
	L.grant_undead_eyes()
	L.skeletonize(FALSE)
	L.equipOutfit(/datum/outfit/overlord)
	L.set_patron(/datum/patron/inhumen/zizo)

/datum/antagonist/overlord/proc/on_death(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_resurrection)) // this proc sleeps

/datum/antagonist/overlord/proc/on_fail()
	to_chat(owner, span_userdanger("No, NO! My empire crumbles!"))
	owner.current.gib()

/datum/antagonist/overlord/proc/attempt_resurrection(timer = 10 SECONDS)
	var/mob/overlord_mob = overlord_body_ref.resolve()
	overlord_mob?.visible_message(span_warning("[overlord_mob]'s body begins to shake violently!"))

	if(!length(built_phylacteries))
		on_fail()
		return FALSE

	to_chat(owner, span_userdanger("Death is not the end for me. My phylacteries call me back..."))

	for(var/obj/structure/overlord_phylactery/built_phylactery in built_phylacteries)
		playsound(src, 'sound/magic/antimagic.ogg', 100, FALSE)
		built_phylactery.visible_message(span_danger("[built_phylactery] begins to crack and pulse!"))

		sleep(timer)

		if(!QDELETED(built_phylactery))
			if(rise_anew())
				owner.current.forceMove(get_turf(built_phylactery))
				return TRUE

		to_chat(owner, span_userdanger("That phylactery was destroyed! Seeking another..."))

	on_fail()
	return FALSE

/datum/antagonist/overlord/proc/rise_anew(location)
	var/mob/living/carbon/human/overlord_mob = owner.current
	if(isbrain(overlord_mob))
		overlord_mob = overlord_body_ref.resolve()
		if(isnull(overlord_mob))
			return FALSE
		var/obj/item/bodypart/head/overlord_head = owner.current.loc.loc
		if(!istype(overlord_head))
			return FALSE
		overlord_head.attach_limb(overlord_mob)
	else
		if(ishuman(owner.current))
			overlord_mob = owner.current

	overlord_mob.revive(ADMIN_HEAL_ALL)
	owner.transfer_to(overlord_mob, TRUE)

	overlord_mob.skeletonize(FALSE)
	overlord_mob.faction = list(FACTION_UNDEAD, "overlord")
	if(length(overlord_mob.quirks))
		overlord_mob.clear_quirks()
	overlord_mob.mob_biotypes |= MOB_UNDEAD
	overlord_mob.grant_undead_eyes()
	return TRUE

