/datum/action/cooldown/meatvine/personal/ranged/spread/lethal
	name = "Spit Acid Spread"
	desc = "Spits a spread of acid at someone, burning them."
	acid_projectile = null
	acid_casing = /obj/item/ammo_casing/xenospit/spread/lethal
	button_icon_state = "acidspit_0"
	projectile_name = "acid"
	button_base_icon = "acidspit"

/datum/action/cooldown/meatvine/personal/ranged/spread/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target || QDELETED(target))
		return 0

	var/dist = get_dist(mob, target)

	// Spread is good at medium range with multiple enemies
	if(dist < 2 || dist > 8)
		return 0

	// Count nearby enemies
	var/nearby_enemies = 0
	for(var/mob/living/L in range(3, target))
		if(L == mob || L.stat == DEAD)
			continue
		if(mob.faction_check_mob(L))
			continue
		nearby_enemies++

	// Score higher with multiple targets
	if(nearby_enemies >= 2)
		return 90
	else if(nearby_enemies == 1)
		return 50

	return 0

/obj/item/ammo_casing/xenospit/spread/lethal
	name = "big glob of acid"
	projectile_type = /obj/projectile/neurotoxin/acid/spitter_spread
	pellets = 4
	variance = 30

/obj/projectile/neurotoxin/acid/spitter_spread
	name = "acid spit"
	icon_state = "toxin"
	damage = 15
	damage_type = BURN
