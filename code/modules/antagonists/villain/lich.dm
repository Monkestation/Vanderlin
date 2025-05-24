/datum/antagonist/lich
	name = "Lich"
	roundend_category = "Lich"
	antagpanel_category = "Lich"
	job_rank = ROLE_LICH
	antag_hud_type = ANTAG_HUD_NECROMANCY
	antag_hud_name = "necromancer"
	confess_lines = list(
		"I WILL LIVE ETERNAL!",
		"I AM BEHIND SEVEN PHYLACTERIES!",
		"YOU CANNOT KILL ME!",
	)
	var/list/phylacteries = list()
	/// weak reference to the body so we can revive even if decapitated
	var/datum/weakref/lich_body_ref

	innate_traits = list(
		TRAIT_NOSTAMINA,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
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

/mob/living/carbon/human
	/// List of minions that this mob has control over. Used for things like the Lich's "Command Undead" spell.
	var/list/mob/minions = list()

/datum/antagonist/lich/on_gain()
	SSmapping.retainer.liches |= owner
	. = ..()
	if(iscarbon(owner.current))
		lich_body_ref = WEAKREF(owner.current)
		RegisterSignal(owner.current, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	owner.special_role = name
	move_to_spawnpoint()
	remove_job()
	owner.current?.roll_mob_stats()
	skele_look()
	equip_lich()
	return ..()

/datum/antagonist/lich/on_removal()
	var/mob/lich_mob = lich_body_ref.resolve()
	UnregisterSignal(lich_mob, COMSIG_LIVING_DEATH)

/datum/antagonist/lich/greet()
	. = ..()
	to_chat(owner.current, span_userdanger("The secret of immortality is mine, but this is not enough. A thousand lichdoms have risen and fallen over the eras. Mine will be the one to last."))
	owner.announce_objectives()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/lichintro.ogg', 80, FALSE, pressure_affected = FALSE)

/datum/antagonist/lich/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.lich_starts))

/datum/antagonist/lich/proc/skele_look()
	var/mob/living/carbon/human/L = owner.current
	L.skeletonize(FALSE)
	L.skele_look()

/datum/antagonist/lich/proc/equip_lich()
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	var/mob/living/carbon/human/L = owner.current

	L.mana_pool.intrinsic_recharge_sources &= ~MANA_ALL_LEYLINES
	L.mana_pool.set_intrinsic_recharge(MANA_SOULS)
	L.mana_pool.ethereal_recharge_rate += 0.2

	L.cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	if(prob(10))
		L.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'
	L.faction = list(FACTION_UNDEAD)
	if(L.charflaw)
		QDEL_NULL(L.charflaw)
	L.mob_biotypes |= MOB_UNDEAD
	L.dna.species.species_traits |= NOBLOOD
	L.grant_undead_eyes()
	L.skeletonize(FALSE)
	L.equipOutfit(/datum/outfit/job/lich)
	L.set_patron(/datum/patron/inhumen/zizo)

/datum/outfit/job/lich/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/skullcap/cult
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/shirt/robe/necromancer
	shirt = /obj/item/clothing/shirt/tunic/ucolored
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/reagent_containers/glass/bottle/manapot
	beltl = /obj/item/weapon/knife/dagger/steel
	r_hand = /obj/item/weapon/polearm/woodstaff

	H.mind.purge_combat_knowledge(TRUE) // purge all their combat skills first
	H.set_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.set_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
	H.set_skillrank(/datum/skill/magic/arcane, 5, TRUE)
	H.set_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.set_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.set_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.set_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.set_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.set_skillrank(/datum/skill/combat/knives, 5, TRUE)
	H.set_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 4, TRUE)

	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 5)
	H.change_stat(STATKEY_CON, 5)
	H.change_stat(STATKEY_END, -1)
	H.change_stat(STATKEY_SPD, -1)

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/command_undead)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/strengthen_undead)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/bloodlightning)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/eyebite)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/sickness)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/arcyne_eye)
	H.dna.species.soundpack_m = new /datum/voicepack/lich()
	H.ambushable = FALSE

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "LICH"), 5 SECONDS)

/datum/outfit/job/lich/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/antagonist/lich/lichman = H.mind.has_antag_datum(/datum/antagonist/lich)
	for(var/i in 1 to 3)
		var/obj/item/phylactery/new_phylactery = new(H.loc)
		lichman.phylacteries += new_phylactery
		new_phylactery.possessor = lichman
		H.equip_to_slot_or_del(new_phylactery,SLOT_IN_BACKPACK, TRUE)

/// called via COMSIG_LIVING_DEATH
/datum/antagonist/lich/proc/on_death(/datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_resurrection)) // this proc sleeps

/datum/antagonist/lich/proc/on_fail()
	to_chat(owner, span_userdanger("No, NO! This cannot be!"))
	owner.current.gib()

/// Checks if the lich has a phylactery to resurrect to and returns TRUE if successfully resurrected, else returns FALSE.
/datum/antagonist/lich/proc/attempt_resurrection(timer = 10 SECONDS)
	var/mob/lich_mob = lich_body_ref.resolve()
	lich_mob?.visible_message(span_warning("[lich_mob]'s body begins to shake violently!"))

	if(!length(phylacteries)) // it's over.
		on_fail()
		return FALSE

	to_chat(owner, span_userdanger("Death is not the end for me. I begin to rise again."))

	for(var/obj/item/phylactery/to_be_consumed in phylacteries) // cycle through all phylacteries until there is none left
		playsound(src, 'sound/magic/antimagic.ogg', 100, FALSE)
		phylacteries -= to_be_consumed

		to_be_consumed.start_shaking()

		sleep(timer) // we sleep so we can later check the other phylacteries in the loop

		if(!QDELETED(to_be_consumed)) // check if the phylactery got destroyed while we were resurrecting.
			if(!to_be_consumed.possessor.rise_anew()) // it's over.
				on_fail()
				return FALSE
			to_be_consumed.possessor.owner.current.forceMove(get_turf(to_be_consumed))
			qdel(to_be_consumed)
			return TRUE // resurrection successful

		to_chat(owner, span_userdanger("That phylactery didn't work.. TRY ANOTHER!"))

	on_fail()
	return FALSE // it's over.

/// Try to revive the lich, if we couldn't revive - call on_death() and return false
/datum/antagonist/lich/proc/rise_anew(location)
	var/mob/living/carbon/human/lich_mob = owner.current // who cares about type safety anyways?
	if(isbrain(lich_mob)) // we have been decapitated, let's reattach to our old body.
		lich_mob = lich_body_ref.resolve() // current body isn't a human mob, let's use the reference to our old body.
		if(isnull(lich_mob))
			return FALSE // the old body no longer exists, it's over.
		var/obj/item/bodypart/head/lich_head = owner.current.loc.loc // we are a brain, let's check if we are inside a head. (the first loc is the brain object, the second loc is the head object)
		if(!istype(lich_head))
			return FALSE // we are not inside a head, it's over.
		lich_head.attach_limb(lich_mob) // reattach the head
	else
		if(ishuman(owner.current))
			lich_mob = owner.current // current body is a human mob.

	lich_mob.revive(TRUE, TRUE) // we live, yay.
	owner.transfer_to(lich_mob, TRUE) // move the player back into the lich body.

	lich_mob.skeletonize(FALSE)

	lich_mob.faction = list(FACTION_UNDEAD)
	if(lich_mob.charflaw)
		QDEL_NULL(lich_mob.charflaw)
	lich_mob.mob_biotypes |= MOB_UNDEAD
	lich_mob.grant_undead_eyes()
	return TRUE

/obj/item/phylactery
	name = "phylactery"
	desc = "Looks like it is filled with some intense power."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	w_class = WEIGHT_CLASS_TINY
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_color = "#003300"
	var/datum/antagonist/lich/possessor

	var/resurrections = 0
	var/datum/mind/mind
	var/respawn_time = 3 MINUTES // unused

	var/static/active_phylacteries = 0

/obj/item/phylactery/Initialize(mapload, datum/mind/newmind)
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/phylactery/proc/start_shaking()
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))
