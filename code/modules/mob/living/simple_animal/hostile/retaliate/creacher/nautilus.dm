/mob/living/simple_animal/hostile/retaliate/nautilus
	icon = 'icons/roguetown/mob/monster/nautilus.dmi'
	name = "nautilus"
	desc = "A massive mollusk with razor sharp tentacles."
	icon_state = "nautilus"
	icon_living = "nautilus"
	icon_dead = "nautilus_dead"
	var/icon_hiding = "nautilus_hide"
	SET_BASE_PIXEL(-16, -8)

	faction = list(FACTION_SEA)
	speak_emote = list("gurgles", "bubbles")
	emote_see = list("writhes its tentacles")
	emote_hear = list("gurgles wetly", "makes bubbling sounds")
	move_to_delay = 5
	vision_range = 5
	see_in_dark = 5
	aggro_vision_range = 5


	// a pretty hefty haul, well worth the hunt if you can actually butcher it properly
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/crab = 2,
						/obj/item/carvedgem/shell/rawshell = 2,
						/obj/item/gem/pearl = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/crab = 3,
						/obj/item/carvedgem/shell/rawshell = 2,
						/obj/item/gem/pearl = 1,
						/obj/item/gem/pearl_blue = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/crab = 4,
						/obj/item/carvedgem/shell/rawshell = 3,
						/obj/item/gem/pearl = 2,
						/obj/item/gem/pearl_blue = 1)


	gender = PLURAL
	health = 800
	maxHealth = 800
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/reagent_containers/food/snacks/fish,
					/obj/item/organ,
					/obj/item/bodypart)

	base_intents = list(/datum/intent/simple/nautilus_lash, /datum/intent/simple/headbutt)
	attack_sound = list('sound/combat/wooshes/whip_crack1.ogg','sound/combat/wooshes/whip_crack2.ogg','sound/combat/wooshes/whip_crack3.ogg')
	melee_damage_lower = 20
	melee_damage_upper = 30
	melee_attack_cooldown = 2.4 SECONDS

	base_constitution = 14
	base_strength = 12
	base_speed = 6
	force_threshold = 15
	armor = new(blunt = 50, slash = 50, stab = 50, piercing = 50, fire = 0, acid = 30, magic = 0)

	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	d_intent = INTENT_PARRY
	deflect_sound = list('sound/combat/hits/blunt/shovel_hit.ogg')
	defprob = 25
	defdrain = 10
	del_on_deaggro = 999 SECONDS
	retreat_health = 0

	dodgetime = 50
	aggressive = 1
	stat_attack = UNCONSCIOUS
	body_eater = TRUE
	limb_destroyer = TRUE
	slowed_by_drag = FALSE

	ai_controller = /datum/ai_controller/nautilus
	dendor_taming_chance = DENDOR_TAME_PROB_NONE

	var/hiding = FALSE

/mob/living/simple_animal/hostile/retaliate/nautilus/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)
	ADD_TRAIT(src, TRAIT_NOHANDGRABS, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_STRONG_GRABBER, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_GOOD_SWIM, INNATE_TRAIT)
	//ai's not gonna use this so it doesnt need controller keys
	var/datum/action/cooldown/mob_cooldown/nautilus_hide/hide = new()
	hide.Grant(src)
	clamped_adjust_skill_level(/datum/attribute/skill/combat/wrestling, 25, 30, TRUE)

/mob/living/simple_animal/hostile/retaliate/nautilus/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/nautilus/update_icon_state()
	. = ..()
	if(stat == DEAD)
		icon_state = icon_dead
		return
	if(hiding)
		icon_state = icon_hiding
	else
		icon_state = icon_living


/mob/living/simple_animal/hostile/retaliate/nautilus/hide()
	force_threshold = 80
	hiding = TRUE
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, "hiding!")
	update_appearance(UPDATE_ICON_STATE)

/mob/living/simple_animal/hostile/retaliate/nautilus/ambush()
	force_threshold = 15
	hiding = FALSE
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, "hiding!")
	update_appearance(UPDATE_ICON_STATE)

/mob/living/simple_animal/hostile/retaliate/nautilus/Move()
	. = ..()
	if(. && hiding)
		ambush()

/mob/living/simple_animal/hostile/retaliate/nautilus/AttackingTarget(mob/living/passed_target)
	. = ..()
	if(target == src)
		return
	if(!(. && isliving(target)))
		return
	var/mob/living/L = target

	if(!pulling && prob(75) && start_pulling(L, suppress_message = TRUE, accurate = TRUE))
		L.visible_message(span_danger("[src] wraps their tentacles around [L]!"), \
			span_userdanger("[src] wraps their tentacles around me!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, src)
		return
	var/list/grabs = list()
	for(var/obj/item/grabbing/G in contents)
		for(var/obj/item/grabbing/PG in grabs)
			if(G.grabbed == PG.grabbed)
				qdel(G) // somehow we have two grabs on someone, dont know how this will happen though
				continue
		grabs += G
		if(!iscarbon(target) || prob(50)) //50% chance we won't make shit worse
			continue
		var/mob/living/carbon/C = G.grabbed
		if(G.grab_state < GRAB_AGGRESSIVE)
			C.grippedby(src)
			continue //anything past this point in the loop we're only gonna do if we have a good grip
		if(C.body_position == STANDING_UP)
			C.Knockdown(20)
			C.visible_message(span_danger("[src] tackles [C] to the ground!"), \
				span_userdanger("[src] tackles me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, src)
			continue
		var/choke = /datum/intent/grab/choke
		var/twist = /datum/intent/grab/twist
		var/smash = /datum/intent/grab/smash

		var/list/grabIntents = G.possible_item_intents & list(choke, twist, smash)
		if(!length(grabIntents))
			continue
		if(grabIntents.Find(choke) && get_location_accessible(C, BODY_ZONE_PRECISE_NECK))
			var/choke_damage = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)
			C.adjustOxyLoss(choke_damage)
			C.visible_message(span_danger("[src] [pick("chokes", "strangles")] [C][G.chokehold ? " with a chokehold" : ""]!"), \
					span_userdanger("[src] [pick("chokes", "strangles")] me[G.chokehold ? " with a chokehold" : ""]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, src)
		else
			pick(grabIntents) == twist ? G.twistlimb(src) : G.smashlimb((get_turf(C) || C), src)

/mob/living/simple_animal/hostile/retaliate/nautilus/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/nautilus/aggro1.ogg','sound/vo/mobs/nautilus/aggro1.ogg')
		if("death")
			return pick('sound/vo/mobs/nautilus/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/nautilus/idle1.ogg','sound/vo/mobs/nautilus/idle2.ogg')
		if("cidle")
			return pick('sound/vo/mobs/troll/cidle1.ogg','sound/vo/mobs/nautilus/idle2.ogg')

/mob/living/simple_animal/hostile/retaliate/nautilus/getarmor(def_zone, type, damage, armor_penetration, blade_dulling)
	. = ..()
	if(!.)
		return
	if(simple_limb_hit(def_zone) == "shell")
		. *= 2
	if(hiding)
		. *= 2


/mob/living/simple_animal/hostile/retaliate/nautilus/simple_limb_hit(zone)
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "eyestalk"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "eyestalk"
		if(BODY_ZONE_PRECISE_NOSE)
			return "beak"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "beak"
		if(BODY_ZONE_HEAD)
			return "beak"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "tentacles"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "tentacles"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tentacles"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tentacles"
		if(BODY_ZONE_R_LEG)
			return "tentacles"
		if(BODY_ZONE_L_LEG)
			return "tentacles"
		if(BODY_ZONE_R_ARM)
			return "tentacles"
		if(BODY_ZONE_L_ARM)
			return "tentacles"
		else
			return "shell"

/datum/intent/simple/nautilus_lash
	name = "tendril lash"
	icon_state = "inlash"
	attack_verb = list("lashes", "whips")
	animname = "slash"
	blade_class = BCLASS_LASHING
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 20
	canparry = FALSE
	item_damage_type = "slash"

// not used by ai because they naturally hide
/datum/action/cooldown/mob_cooldown/nautilus_hide
	name = "Hide"
	button_icon_state = "conjure_armor"
	desc = "Retreat into your shell, making you exceedingly difficult to hurt."
	cooldown_time = 10 SECONDS

/datum/action/cooldown/mob_cooldown/nautilus_hide/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/nautilus/nauti = owner
	if(!istype(nauti))
		to_chat(owner, span_warning("...you don't have a shell. How do you even have this??"))
		return FALSE

	if(nauti.hiding)
		nauti.visible_message(span_boldwarning("[nauti] bursts from within their shell!"))
		nauti.ambush()
	else
		for(var/obj/item/grabbing/G in nauti.contents)
			qdel(G)
		nauti.visible_message(span_boldwarning("[nauti] starts to retreat into their shell!"))
		if(do_after(nauti, 3 SECONDS))
			nauti.hide()
	StartCooldown()
	return TRUE
