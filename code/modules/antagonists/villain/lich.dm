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
	var/datum/weakref/lich_body
	var/out_of_lives = FALSE

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

/datum/antagonist/lich/on_gain()
	SSmapping.retainer.liches |= owner
	. = ..()
	if(iscarbon(owner.current))
		lich_body = WEAKREF(owner.current)
	owner.special_role = name
	move_to_spawnpoint()
	remove_job()
	owner.current?.roll_mob_stats()
	skele_look()
	equip_lich()
	return ..()

/datum/antagonist/lich/greet()
	to_chat(owner.current, span_userdanger("The secret of immortality is mine, but this is not enough. A thousand lichdoms have risen and fallen over the eras. Mine will be the one to last."))
	owner.announce_objectives()
	..()
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
	L.unequip_everything()
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
	//H.set_skillrank(/datum/skill/misc/treatment, 4, TRUE)

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

/datum/antagonist/lich/proc/consume_phylactery(timer = 10 SECONDS)
	for(var/obj/item/phylactery/phyl in phylacteries)
		phyl.be_consumed(timer)
		phylacteries -= phyl
		return TRUE

/datum/antagonist/lich/proc/rise_anew(location)
	var/mob/living/carbon/human/lich_mob
	if(isbrain(owner.current)) // we have been decapitated, let's reattach to our old body.
		lich_mob = lich_body.resolve() // current body isn't a human mob, let's use the reference to our old body.
		if(isnull(lich_mob))
			return // the old body no longer exists, it's over.
		var/mob/living/brain/lich_brain = owner.current
		if(!istype(lich_brain.loc.loc, /obj/item/bodypart/head))
			return // we have no head, it's over.
		var/obj/item/bodypart/head/lich_head = lich_brain.loc.loc
		lich_head.attach_limb(lich_mob)
	else
		if(ishuman(owner.current))
			lich_mob = owner.current // current body is a human mob.

	lich_mob.revive(TRUE, TRUE) // we live, yay.
	lich_mob.ckey = owner.current.client.ckey

	lich_mob.skeletonize(FALSE)

	lich_mob.faction = list(FACTION_UNDEAD)
	if(lich_mob.charflaw)
		QDEL_NULL(lich_mob.charflaw)
	lich_mob.mob_biotypes |= MOB_UNDEAD
	lich_mob.grant_undead_eyes()

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
	var/respawn_time = 1800

	var/static/active_phylacteries = 0

/obj/item/phylactery/Initialize(mapload, datum/mind/newmind)
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/phylactery/proc/be_consumed(timer)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))
	spawn(timer)
		possessor.rise_anew()
		possessor.owner.current.forceMove(get_turf(src))
		qdel(src)
