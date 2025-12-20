/mob/living/simple_animal/hostile/retaliate/snapper
	name = "snapper"
	desc = "A horrific metallic monster, its jaws bite like mantrap..."
	gender = NEUTER
	icon = 'icons/roguetown/mob/monster/pets.dmi'
	icon_state = "gg"
	icon_living = "gg"
	icon_dead = "gg_dead"

	botched_butcher_results = list(/obj/item/gear/metal/bronze = 1)
	butcher_results = list(/obj/item/gear/metal/bronze = 2)
	perfect_butcher_results = list(/obj/item/gear/metal/bronze = 3)

	attack_sound = 'sound/items/beartrap.ogg'

	health = 100
	maxHealth = 100

	move_to_delay = 5
	dodgetime = 2 SECONDS

	base_intents = list(/datum/intent/simple/bite)
	melee_damage_lower = 12
	melee_damage_upper = 16

	ai_controller = /datum/ai_controller/volf // Laziness

/mob/living/simple_animal/hostile/retaliate/snapper/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)

/mob/living/simple_animal/hostile/retaliate/snapper/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()
