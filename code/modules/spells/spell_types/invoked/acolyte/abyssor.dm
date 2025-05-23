//////////////////////
//# ABYSSOR'S RAGE #//
//////////////////////
/obj/effect/proc_holder/spell/invoked/projectile/swordfish
	name = "Abyssor's Rage"
	overlay_state = "curse2"
	releasedrain = 50
	chargetime = 20
	range = 10
	projectile_type = /obj/projectile/magic/swordfish
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokegen
	req_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)
	sound = 'sound/magic/whiteflame.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	miracle = TRUE
	recharge_time = 15 SECONDS
	devotion_cost = 40

/obj/item/reagent_containers/food/snacks/fish/swordfish
	name = "swordfish"
	desc = "But one enactor of Abyssor's rage."
	icon = 'icons/roguetown/misc/fish.dmi'
	icon_state = "swordfishcom"
	force = DAMAGE_DAGGER
	dropshrink = 0.8
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/food)

//esssentially a magic throwing knife
/obj/projectile/magic/swordfish
	name = "swordfish"
	desc = "But one enactor of Abyssor's rage."
	damage = DAMAGE_DAGGER * 2
	nodamage = FALSE
	damage_type = BRUTE
	icon = 'icons/roguetown/misc/fish.dmi'
	icon_state = "swordfish_proj"
	range = 10
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 15
	armor_penetration = 10
	woundclass = BCLASS_STAB
	flag = "piercing"
	speed = 0.4
	impact_effect_type = null

/obj/projectile/magic/swordfish/on_hit(atom/target, blocked)
	. = ..()
	if(ismob(target))
		var/mob/hit = target
		if(hit.anti_magic_check())
			hit.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
	if(!dropped)
		dropped = new /obj/item/reagent_containers/food/snacks/fish/swordfish()

/obj/effect/proc_holder/spell/self/summon_trident
	name = "Summon Trident"
	overlay_state = "lightning"
	recharge_time = 1 MINUTES
	req_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)
	invocation = "Let Abyssor's wrath be known."
	invocation_type = "shout"
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 45

	var/obj/marked_item

/obj/effect/proc_holder/spell/self/summon_trident/cast(list/targets,mob/living/user = usr)
	if(!QDELETED(marked_item))
		qdel(marked_item)
	var/obj/item/item = new /obj/item/fishingrod/abyssor_trident
	user.put_in_hands(item)
	marked_item = item
	return ..()

/obj/item/fishingrod/abyssor_trident
	name = "trident of the depths"
	desc = "An instrument of Abyssor's wrath to claim his bounties and punish the ignorant."
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR+2
	throwforce = DAMAGE_SPEAR_WIELD
	possible_item_intents = list(SPEAR_THRUST, ROD_AUTO, ROD_CAST)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, POLEARM_BASH)
	icon = 'icons/roguetown/weapons/64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	icon_state = "tridentgold"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE

	sharpness = IS_SHARP
	wlength = WLENGTH_GREAT
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	wdefense = GREAT_PARRY
	blade_dulling = DULLING_BASHCHOP

	max_blade_int = 50
	max_integrity = INTEGRITY_WORST/2 // not meant for long-term combat
	minstr = 7
	dropshrink = 0.9
	thrown_bclass = BCLASS_STAB

	throw_speed = 3
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 5, "embedded_ignore_throwspeed_threshold" = 1)

	associated_skill = /datum/skill/combat/polearms

	obj_flags = CAN_BE_HIT
	resistance_flags = FIRE_PROOF
	experimental_onback = TRUE
	armor_penetration = 5
	can_parry = TRUE
	has_inspect_verb = TRUE

/obj/item/fishingrod/abyssor_trident/Initialize()
	. = ..()
	reel = new /obj/item/fishing/reel/abytrident(src)
	hook = new /obj/item/fishing/hook/abytrident(src)
	line = new /obj/item/fishing/line/no_line(src)
	baited = new /obj/item/fishing/bait/no_bait(src)
	AddComponent(/datum/component/walking_stick)

/obj/item/fishingrod/abyssor_trident/examine(mob/user)
	. = ..()
	. = list("[get_examine_string(user, TRUE)].[get_inspect_button()]", span_info("[desc]")) // to hide fishing rod examine text

/obj/item/fishingrod/abyssor_trident/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/fishingrod/abyssor_trident/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!is_embedded)
		src.visible_message(span_warning("[src] dissipates into a splash of water!"), vision_distance = COMBAT_MESSAGE_RANGE)
		qdel(src)

/obj/item/fishingrod/abyssor_trident/unembedded()
	if(!QDELETED(src))
		src.visible_message(span_warning("[src] dissipates into a splash of water!"), vision_distance = COMBAT_MESSAGE_RANGE)
		qdel(src)
		return TRUE

/obj/item/fishingrod/abyssor_trident/attack_right(mob/user)
	return

/obj/item/fishingrod/abyssor_trident/afterattack(obj/target, mob/user, proximity, params)
	. = ..()
	baited = new /obj/item/fishing/bait/no_bait(src)

/obj/item/fishing/reel/abytrident
	name = "trident shaft"
	linehealth = 14
	difficultymod = 1

/obj/item/fishing/hook/abytrident
	name = "trident prong"
	deepfishingweight = -2
	sizemod = list("tiny" = -3, "small" = -2, "normal" = -1, "large" = 1, "prize" = 1)

/obj/item/fishing/line/no_line
	name = "lack of attachment"

/obj/item/fishing/bait/no_bait
	name = "lack of bait"
	baitpenalty = 10
	sizemod = list("tiny" = -2, "small" = -2, "normal" = -1, "large" = 1, "prize" = 1)
	fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/carp = 1,
					/obj/item/reagent_containers/food/snacks/fish/eel = 1,
					/obj/item/reagent_containers/food/snacks/fish/shrimp = 1)
	deeplist = list(/obj/item/reagent_containers/food/snacks/fish/angler = 1,
					/obj/item/reagent_containers/food/snacks/fish/clownfish = 1)

/obj/effect/proc_holder/spell/invoked/ocean_embrace
	name = "Ocean's Embrace"
	overlay_state = "astrata"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	req_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)
	sound = 'sound/foley/jumpland/waterland.wav'
	invocation = "Embrace the waters of Abyssor's domain."
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	healing_miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/invoked/ocean_embrace/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_ATHEISM_CURSE))
			target.visible_message(span_danger("[target] recoils in disgust!"), span_userdanger("These fools are trying to cure me with religion!!"))
			target.cursed_freak_out()
			return FALSE

		if(target.mob_biotypes & MOB_UNDEAD) //blasts with debuffs rather than direct damage
			target.visible_message(span_danger("[target] is drowned by turbulent tides!"), span_userdanger("I'm being drowned by turbulent tides!"))
			target.safe_throw_at(get_step(target, get_dir(user, target)), 1, 1, user, spin = TRUE, force = target.move_force)
			var/already_dead = target.stat == DEAD ? TRUE : FALSE
			target.adjustOxyLoss(80)
			target.Knockdown(5)
			target.Slowdown(60)
			target.Dizzy(10)
			target.blur_eyes(20)
			target.emote("drown")
			if(!already_dead)
				if(target.stat == DEAD && target.client)
					GLOB.vanderlin_round_stats[STATS_PEOPLE_DROWNED]++
			return ..()

		target.visible_message(span_info("A wave of replenishing water passes through [target]!"), span_notice("I'm engulfed in a wave of replenishing water!"))
		target.wash(CLEAN_WASH)
		var/situational_bonus = 1
		var/list/water = typesof(/turf/open/water) - typesof(/turf/open/water/acid)
		// the more water around us, the more we heal, up to times two
		for (var/turf/O in oview(3, user))
			if(O.type in water)
				situational_bonus = min(situational_bonus + 0.1, 2)
		if(situational_bonus != 1)
			to_chat(user, "Channeling Abyssor's power is easier in these conditions!")
		if(target.blood_volume > 0)
			target.blood_volume += BLOOD_VOLUME_OKAY * situational_bonus
		return ..()
	return FALSE
