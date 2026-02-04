//┌─────────────── INHUMEN PANTHEON WEAPONS BELOW ───────────────┐

// god weapons should have 720 durability, and can reach 0 and become unusable but do not break and can be repaired

#define GOREFEAST_UNWORTHY list(\
	span_danger("Unworthy..."),\
	span_danger("You are far too weak to be wielding me."),\
	span_danger("How did you get your hands on me?"),\
	span_danger("Find the nearest orc, and hand me to them."),\
	span_danger("You are not prepared."),\
)

#define GOREFEAST_WORTHY list(\
	span_danger("A worthy one!"),\
	span_danger("Bathe me in their blood."),\
	span_danger("You can smell their fear can't you?"),\
	span_danger("Unleash your fury, soak the soil in their blood."),\
	span_danger("Feast on their organs."),\
	span_danger("Cull the world of the weak!"),\
	span_danger("Fools to challenge us, warlord."),\
)

//┌─────────────── GOREFEAST ───────────────┐//
/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast
	name = "gorefeast"
	desc = "It is said that with this axe alone, Graggar slew a thousand men. With you, it will slay a thousand more."
	icon = 'icons/roguetown/weapons/64/godweapons.dmi'
	icon_state = "gorefeast"
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	force = DAMAGE_HEAVYAXE_WIELD
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 5
	wdefense = GOOD_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_GRTCHOP, SWORD_STRIKE)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONGEST + 220
	minstr = 12
	resistance_flags = FIRE_PROOF
	sellprice = 550

/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/divine_intervention, /datum/patron/inhumen/graggar, PUNISHMENT_STRESS, /datum/stress_event/divine_punishment, TRUE)

/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast/pickup(mob/user)
	. = ..()
	var/message
	if(!HAS_TRAIT(user, TRAIT_ORGAN_EATER))
		to_chat(user, span_danger("The beating heart of the blade seems to slow down at the sight of you... disinterested."))
		user.playsound_local(user, pick('sound/misc/godweapons/gorefeast1.ogg', 'sound/misc/godweapons/gorefeast2.ogg', 'sound/misc/godweapons/gorefeast3.ogg'), 70)
		message = pick(GOREFEAST_UNWORTHY)
	else
		to_chat(user, span_danger("Gorefeast begins to thump ecstatically upon your touch on the boney shaft."))
		user.playsound_local(user, pick('sound/misc/godweapons/gorefeast4.ogg', 'sound/misc/godweapons/gorefeast5.ogg', 'sound/misc/godweapons/gorefeast6.ogg'), 70)
		message = pick(GOREFEAST_WORTHY)
	addtimer(CALLBACK(src, PROC_REF(do_message), message), 2 SECONDS)

/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast/proc/do_message(message)
	audible_message("Gorefeast speaks, \"[message]\"", hearing_distance = 5)

/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(user, TRAIT_ORGAN_EATER))
		force = 13
		force_wielded = 23
	return ..()

/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	if(!ishuman(target))
		return
	if(check_zone(user.zone_selected) != BODY_ZONE_CHEST)
		return
	var/mob/living/carbon/human/H = target
	var/heart_crit = H.has_wound(/datum/wound/artery/chest)
	var/dead = H.stat == DEAD
	if((H.health < H.crit_threshold) || heart_crit || dead)
		var/fast = heart_crit || dead
		var/obj/item/organ/heart/heart = H.getorganslot(ORGAN_SLOT_HEART)
		if(!heart)
			to_chat(user, span_warning("Only a hollow chest remains!"))
			return FALSE
		to_chat(user, span_notice("I begin to pull the heart from [H]..."))
		if(do_after(user, fast ? 5 SECONDS : 10 SECONDS, H))
			heart.Remove(H)
			heart.forceMove(H.drop_location())

			H.add_splatter_floor()
			H.adjustBruteLoss(20)
			to_chat(user, span_notice("I finish pulling the heart from [H]!"))
	. = ..()

#undef GOREFEAST_UNWORTHY
#undef GOREFEAST_WORTHY

//┌─────────────── NEANT ───────────────┐//
/obj/item/weapon/polearm/neant
	name = "neant"
	desc = "A dark scythe with a long chain, used to cut the life essence from people, or whip them into shape. The blade is an ominous purple."
	icon_state = "neant"
	icon = 'icons/roguetown/weapons/64/godweapons.dmi'
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	force = DAMAGE_SPEARPLUS + 2
	force_wielded = DAMAGE_SPEAR_WIELD
	throwforce = DAMAGE_SPEAR_WIELD
	possible_item_intents = list(SPEAR_CUT)
	gripped_intents = list(POLEARM_CHOP, WHIP_STRIKE, NEANT_SHOOT)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONGEST + 220
	minstr = 10
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	dropshrink = 0.75
	thrown_bclass = BCLASS_CUT
	sellprice = 550

	COOLDOWN_DECLARE(fire_projectile)

/obj/item/weapon/polearm/neant/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/divine_intervention, /datum/patron/inhumen/zizo, PUNISHMENT_BURN, /datum/stress_event/divine_punishment, TRUE)

/obj/item/weapon/polearm/neant/attack(mob/living/M, mob/living/user, list/modifiers)
	if(user.used_intent.tranged)
		return
	return ..()

/obj/item/weapon/polearm/neant/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_CABAL) || !istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(user.used_intent?.tranged)
		handle_magick(user, target)
		return
	if(!ishuman(target))
		return
	if(check_zone(user.zone_selected) != BODY_ZONE_CHEST)
		return
	var/mob/living/carbon/human/H = target
	if(H.get_lux_status() != LUX_HAS_LUX)
		return
	var/dead = H.stat == DEAD
	if((H.health < H.crit_threshold) || dead)
		var/speed = dead ? 3 SECONDS : 7 SECONDS
		visible_message(user, span_notice("Neant lights up and begins to tear at [target]..."))
		if(!do_after(user, speed, H))
			return
		var/obj/item/bodypart/chest/C = H.get_bodypart(BODY_ZONE_CHEST)
		if(!C)
			return
		playsound(user, 'sound/surgery/scalpel2.ogg', 70)
		if(do_after(user, 0.5 SECONDS, target))
			C.add_wound(/datum/wound/slash/incision)

		playsound(user, 'sound/surgery/organ2.ogg', 70)
		if(do_after(user, 0.5 SECONDS, target))
			C.add_wound(/datum/wound/fracture/chest)

		new /obj/item/reagent_containers/lux(get_turf(target))

		H.apply_status_effect(/datum/status_effect/debuff/lux_drained)
		SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
		record_featured_stat(FEATURED_STATS_CRIMINALS, user)
		record_round_statistic(STATS_LUX_HARVESTED)

		H.add_splatter_floor()
		H.adjustBruteLoss(20)
		visible_message(user, span_notice("Neant's blade draws the lux from [target]!"))

/obj/item/weapon/polearm/neant/proc/handle_magick(mob/living/user, atom/target)
	if(!COOLDOWN_FINISHED(src, fire_projectile))
		return
	var/client/client = user.client
	if(!client?.chargedprog)
		return

	var/startloc = get_turf(src)
	var/obj/projectile/bullet/neant/PJ = new(startloc)
	PJ.starting = startloc
	PJ.firer = user
	PJ.fired_from = src
	PJ.original = target
	playsound(user,'sound/effects/neantspecial.ogg', 70)

	if(user.STAPER > 8)
		PJ.accuracy += (user.STAPER - 8) * 2 //each point of perception above 8 increases standard accuracy by 2.
		PJ.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.

	if(user.STAINT > 10) // Every point over 10 INT adds 10% damage
		PJ.damage = PJ.damage * (user.STAINT / 10)
		PJ.accuracy += (user.STAINT - 10) * 3

	new /obj/effect/temp_visual/dir_setting/firing_effect/neant(get_step(user, user.dir), user.dir)
	PJ.preparePixelProjectile(target, user)
	PJ.fire()
	user.changeNext_move(CLICK_CD_RANGE)
	COOLDOWN_START(src, fire_projectile, 4 SECONDS)

/obj/projectile/bullet/neant
	name = "Profane Evisceration"
	icon = 'icons/effects/effects.dmi'
	icon_state = "neantprojectile"
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	range = 8
	damage = 20
	armor_penetration = 30
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	flag =  "piercing"
	speed = 1
	accuracy = 80

/obj/effect/temp_visual/dir_setting/firing_effect/neant
	icon = 'icons/effects/effects.dmi'
	icon_state = "neantspecial"
	duration = 4

/datum/intent/shoot/neant
	name = "shoot"
	icon_state = "inshoot"
	warnie = "aimwarn"
	item_damage_type = "stab"
	tranged = TRUE
	chargetime = 2 SECONDS
	no_early_release = TRUE
	noaa = TRUE
	charging_slowdown = 2

/datum/intent/shoot/neant/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

//┌─────────────── TURBULENTA ───────────────┐//

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta
	name = "turbulenta"
	desc = "Rarely does she even care about combat, but when she does... Baotha was quite the markswoman."
	icon = 'icons/roguetown/weapons/64/godweapons.dmi'
	icon_state = "turbulenta"
	base_icon = "turbulenta"
	slot_flags = ITEM_SLOT_BACK
	SET_BASE_PIXEL(-16, -16)
	bigboy = TRUE
	dropshrink = 0.75
	fire_sound = 'sound/combat/Ranged/turbulentafire.ogg'
	possible_item_intents = list(/datum/intent/shoot/bow/turbulenta, /datum/intent/arc/bow/turbulenta)
	force = 12
	damfactor = 1.1
	var/obj/item/instrument/harp/turbulenta/FUCK

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/divine_intervention, /datum/patron/inhumen/baotha, PUNISHMENT_STRESS, /datum/stress_event/divine_punishment, TRUE)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -3,
					"sy" = -1,
					"nx" = 2,
					"ny" = 1,
					"wx" = -3,
					"wy" = 0,
					"ex" = -2,
					"ey" = -2,
					"nturn" = 99,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 100,
					"nflip" = NONE,
					"sflip" = EAST,
					"wflip" = EAST,
					"eflip" = NONE,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = FALSE,
				)
			if("onback")
				return list(
					"shrink" = 0.55,
					"sx" = 1,
					"sy" = -1,
					"nx" = 1,
					"ny" = -1,
					"wx" = 2,
					"wy" = -1,
					"ex" = -2,
					"ey" = -1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = NONE,
					"sflip" = EAST,
					"wflip" = EAST,
					"eflip" = NONE,
					"northabove" = TRUE,
					"southabove" = FALSE,
					"eastabove" = FALSE,
					"westabove" = FALSE,
				)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/Initialize(mapload, ...)
	. = ..()
	FUCK = new(src)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/Destroy(force)
	QDEL_NULL(FUCK)
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/attack_self(mob/living/user, list/modifiers)
	if(chambered || !HAS_TRAIT(user, TRAIT_CRACKHEAD))
		return ..()
	FUCK.attack_self(user, modifiers)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/dropped(mob/user, silent)
	if(FUCK.playing)
		FUCK.terminate_playing(user)
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(FUCK.playing)
		FUCK.terminate_playing(user)
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta/before_firing(atom/target, mob/user)
	if(!HAS_TRAIT(user, TRAIT_CRACKHEAD))
		return
	var/obj/projectile/arrow = chambered?.BB
	var/old_dam
	var/old_pen
	if(arrow)
		old_dam = arrow.damage
		old_pen = arrow.armor_penetration
		qdel(arrow)
	arrow = new /obj/projectile/bullet/reusable/arrow/spiced
	arrow.damage = old_dam || arrow.damage
	arrow.armor_penetration = old_pen || arrow.armor_penetration
	chambered.BB = arrow

/obj/projectile/bullet/reusable/arrow/spiced
	name = "spiced arrow"
	desc = "A profane arrow infused with spice."
	icon_state = "arrowspice_proj"
	ammo_type = /obj/item/ammo_casing/caseless/arrow

/obj/projectile/bullet/reusable/arrow/spiced/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/druqks, 20)

/datum/intent/shoot/bow/turbulenta
	chargetime = 1
	chargedrain = 1.5
	charging_slowdown = 2.5

/datum/intent/arc/bow/turbulenta
	chargetime = 1
	chargedrain = 1.5
	charging_slowdown = 2.5

//┌─────────────── PLEONEXIA ───────────────┐//
/obj/item/weapon/sword/long/pleonexia
	icon_state = "pleonexia"
	icon = 'icons/roguetown/weapons/64/godweapons.dmi'
	name = "pleonexia"
	desc = "A sword of legend. If they are true, then this is the blade of Matthios himself. Rumor has it, it steals space and time."
	possible_item_intents = list(SWORD_STRIKE, SWORD_CUT)
	gripped_intents = list(SWORD_STRIKE, SWORD_CHOP, SWORD_THRUST, PLEX_BLINK)
	max_integrity = INTEGRITY_STRONGEST + 220
	sellprice = 550

	COOLDOWN_DECLARE(pleonexia_blink)

/obj/item/weapon/sword/long/pleonexia/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/divine_intervention, /datum/patron/inhumen/matthios, PUNISHMENT_STRESS, /datum/stress_event/divine_punishment, TRUE)

/obj/item/weapon/sword/long/pleonexia/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!istype(user.used_intent, /datum/intent/plex_dash) || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return ..()
	. = TRUE
	if(!isturf(user.loc))
		to_chat(user, span_notice("I cannot do this from inside of [user.loc]!"))
		return
	if(!COOLDOWN_FINISHED(src, pleonexia_blink))
		to_chat(user, span_notice("Pleonexia is not ready to blink again! [COOLDOWN_TIMELEFT(src, pleonexia_blink)/10] Seconds."))
		return
	var/turf/target = get_turf(A)
	if(target.is_blocked_turf(TRUE, user))
		target = get_step(target, get_dir(target, user))
	var/turf/starting = get_turf(user)
	var/list/affected_turfs = get_line(starting, target) - starting
	if(!LAZYLEN(affected_turfs))
		to_chat(user, span_notice("There is nothing to cut through!"))
		return
	user.visible_message(span_warning("[user] blinks through space!"),
		span_notice("I tear through space with Pleonexia."))
	playsound(starting, "pleonexiaphase", 70, TRUE, -1)
	new /obj/effect/temp_visual/cut(starting)
	for(var/turf/affected_turf in affected_turfs)
		for(var/mob/living/L in affected_turf)
			if(L == user)
				continue
			L.Knockdown(1 SECONDS)
			L.Stun(1 SECONDS)
	user.forceMove(target)
	new /obj/effect/temp_visual/stab(target)
	COOLDOWN_START(src, pleonexia_blink, 10 SECONDS)

/obj/effect/temp_visual/cut
	icon_state = "pcut"
	duration = 3 DECISECONDS

/obj/effect/temp_visual/stab
	icon_state = "pstab"
	duration = 3 DECISECONDS

/datum/intent/plex_dash
	name = "blink"
	desc = "Blink two tiles ahead, stunning those in your path."
	icon_state = "peculate"
	hitsound = null
	noaa = TRUE
	reach = 3
