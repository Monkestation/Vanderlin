/mob/living/simple_animal/hostile/retaliate/shark
	name = "shark"
	desc = "Tales of Abyssor speak of beasts that grow much larger than this one..."
	icon = 'icons/mob/broadMobs.dmi'
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"

	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/fish = 2, /obj/item/alch/sinew = 2, /obj/item/alch/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/fish = 2, /obj/item/alch/sinew = 2, /obj/item/alch/bone = 1)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1, /obj/item/alch/bone = 1)

	health = 150
	maxHealth = 150

	move_to_delay = 11
	dodgetime = 3 SECONDS

	base_intents = list(/datum/intent/simple/bite)
	melee_damage_lower = 18
	melee_damage_upper = 24

	ai_controller = /datum/ai_controller/volf // Laziness

/mob/living/simple_animal/hostile/retaliate/shark/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)

/mob/living/simple_animal/hostile/retaliate/shark/simple_limb_hit(zone)
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
			return "gills"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "fins"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "fins"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"
		if(BODY_ZONE_R_ARM)
			return "fins"
		if(BODY_ZONE_L_ARM)
			return "fins"
	return ..()
