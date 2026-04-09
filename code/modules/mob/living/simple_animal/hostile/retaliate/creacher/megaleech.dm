/mob/living/simple_animal/hostile/retaliate/megaleech
	icon = 'icons/roguetown/mob/monster/megaleech.dmi'
	name = "dire leech"
	desc = ""
	icon_state = "megaleech"
	icon_living = "megaleech"
	icon_dead = "megaleech_dead"

	animal_species = /mob/living/simple_animal/hostile/retaliate/megaleech
	faction = list(FACTION_SEA)
	gender = FEMALE
	footstep_type = FOOTSTEP_MOB_SLIME
	emote_see = list("looks around.", "slobbers a little.")
	move_to_delay = 8

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1,
						/obj/item/natural/hide = 1,
						/obj/item/alch/waterdust = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 2,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/alch/waterdust = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3,
						/obj/item/alch/waterdust = 3,
						/obj/item/natural/worms/leech/parasite = 1)

	health = 100
	maxHealth = 100

	food_max = BLOOD_VOLUME_OKAY // this is absurdly high compared to most mobs but it's used for bloodfeeding

	food_type = list(/obj/item/reagent_containers/food/snacks/blood_dough)
	tame_chance = 25
	bonus_tame_chance = 15

	base_intents = list(/datum/intent/simple/bite)
	possible_rmb_intents = list(/datum/rmb_intent/simple/blood_leech)
	//attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	melee_damage_lower = 8
	melee_damage_upper = 12
	retreat_distance = 10
	minimum_distance = 10
	base_speed = 8
	base_constitution = 12
	base_strength = 9
	base_endurance = 12
	can_buckle = TRUE
	buckle_lying = FALSE
	can_saddle = TRUE
	aggressive = TRUE

	ai_controller = /datum/ai_controller/megaleech

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/attack/leech_blood,
		/datum/pet_command/attack/give_blood,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/megaleech/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	RegisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(on_pre_attack))
	AddElement(/datum/element/ai_retaliate)

	var/datum/component/generic_mob_hunger/hunger = GetComponent(/datum/component/generic_mob_hunger)
	if(hunger)
		hunger.hunger_drain = 4

	ADD_TRAIT(src, TRAIT_GOOD_SWIM, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/retaliate/megaleech/Destroy()
	UnregisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET)
	return ..()

//do our rmb intent out of combat. Scuffed? Absolutely. Alternatives? A pain in the ass.
/mob/living/simple_animal/hostile/retaliate/megaleech/proc/on_pre_attack(datum/source, atom/target)
	if(!cmode && rmb_intent)
		rmb_intent.special_attack(src, target)
		return COMPONENT_HOSTILE_NO_PREATTACK

/mob/living/simple_animal/hostile/retaliate/megaleech/AttackingTarget(mob/living/passed_target)
	. = ..()
	var/mob/living/L = target
	if(. && istype(target) && L.blood_volume > 0 && SEND_SIGNAL(src, COMSIG_MOB_RETURN_HUNGER) < 100)
		var/blood_taken = drinksomeblood(L, L.get_bodypart(zone_selected), 30, FALSE)
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
				return
			drinksomeblood(C, zone_selected)
		else
			L.blood_volume -= blood_taken
			L.handle_blood()
			playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
		SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, blood_taken) // chance of minor overflow but it's negligible

/mob/living/simple_animal/hostile/retaliate/megaleech/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "megaleech_saddle_above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "megaleech_saddle")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "megaleech_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/megaleech/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	if(can_buckle)
		AddComponent(/datum/component/riding/megaleech)

/mob/living/simple_animal/hostile/retaliate/megaleech/get_sound(input)
	switch(input)
		if("idle")
			return pick('sound/vo/mobs/megaleech/bigsuck1.ogg','sound/vo/mobs/megaleech/bigsuck2.ogg', 'sound/vo/mobs/megaleech/bigsuck3.ogg')
		if("cidle")
			return pick('sound/vo/mobs/megaleech/bigsuck1.ogg','sound/vo/mobs/megaleech/bigsuck2.ogg', 'sound/vo/mobs/megaleech/bigsuck3.ogg')

/mob/living/simple_animal/hostile/retaliate/megaleech/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "mouth"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "mouth"
		if(BODY_ZONE_PRECISE_EARS)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "belly"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"

	return ..()

/mob/living/simple_animal/hostile/retaliate/megaleech/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/megaleech/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)
