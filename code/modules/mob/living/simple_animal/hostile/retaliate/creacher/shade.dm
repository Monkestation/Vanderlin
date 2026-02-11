/*
* Shades are a experimental mob that
* - cannot apply wounds such as bleeding
* - immune to non magic projectiles
* - immune to physical damage
* These entities are the bane of
* warriors but are easily culled by wizards
* and weapons of silver.
* Icon was donated by 7sin on discord.
* -IP
*/

/mob/living/simple_animal/hostile/retaliate/shade
	icon = 'icons/roguetown/mob/monster/stonekeep_shade.dmi'
	name = "shade"
	desc = "An unquiet spirit of the dead, seeking to drag the living with them. Said to be those who could not pay their Toll to the Undermaiden's carriageman, or cursed servants of the Z-Not-To-Be-Named that are shackled to her even in death."
	icon_state = "shade_mob_a"
	icon_living = "shade_mob_a"
	icon_dead = null

	gender = PLURAL
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 2
	//Unique intent to avoid wounds.
	base_intents = list(/datum/intent/simple/touch)
	/*
	* Will not fight vampire lord or
	* other undead. Can be placed with
	* haunts for army composition.
	*/
	faction = list(FACTION_UNDEAD)
	mob_biotypes = MOB_UNDEAD|MOB_SPIRIT
	//Thats a ghost dude how would it leave a corpse?
	del_on_death = TRUE
	deathmessage = "collapses into ash"
	speak_emote = list("sighs")
	/*
	* Immunity to brute damage has
	* made them proud, remind them of
	* their forgotten humility.
	*/
	health = SHADE_HEALTH
	maxHealth = SHADE_HEALTH
	melee_damage_lower = 15
	melee_damage_upper = 20
	vision_range = 9
	aggro_vision_range = 9
	melee_damage_type = BRUTE
	// Makes thrown objects phase through them
	pass_flags_self = LETPASSTHROW
	/*
	* Extremely optional choice to make
	* them immune to all brute damage but
	* vulnerable to fire damage
	*/
	damage_coeff = list(BRUTE = 0, BURN = 1.3)
	retreat_distance = 0
	minimum_distance = 0
	//Why wander when you know your fate.
	wander = FALSE
	base_constitution = 6
	base_strength = 6
	base_speed = 6
	deaggroprob = 0
	// No they do not dodge.
	defprob = 0
	defdrain = 0
	dodgetime = 0
	blood_volume = 0
	del_on_deaggro = 999 SECONDS

	attack_sound = list('sound/magic/magic_nulled.ogg')
	aggressive = 1
	retreat_health = null
	remains_type = null



	ai_controller = /datum/ai_controller/shade

	/*
	* When a shade is defeated it collapses into
	* a large pile of ash.
	* Tell the servents to clean it up.
	*/
	loot = list(/obj/effect/decal/cleanable/undeadash)

/mob/living/simple_animal/hostile/retaliate/shade/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

/*
* Shades are supprisingly flammable
*/
/mob/living/simple_animal/hostile/retaliate/shade/attackby(obj/item/O, mob/user, list/modifiers)  //Marker -Agouri
	if(istype(O, /obj/item/flashlight/flare))
		fire_act(3,3)
		return
	return ..()

// Causes thrown objects to fly through shades.
/mob/living/simple_animal/hostile/retaliate/shade/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(mover.throwing)
		return TRUE

/mob/living/simple_animal/hostile/retaliate/shade/bullet_act(obj/projectile/P)
	//This is not a perfect solution for making shades vulnerable to magic but its something.
	if(P.flag == "magic")
		return ..()
	//Theres a issue with projectiles that are arcing reaching the end of their range and also dropping because on_hit was called.
	if(P.arcshot)
		return BULLET_ACT_BLOCK
	visible_message("<span class='notice'>[P] passes through [src].</span>")
	return BULLET_ACT_FORCE_PIERCE

//I hate this proc because its only used for flavor and is SO BIG.
/mob/living/simple_animal/hostile/retaliate/shade/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "head"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "face"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
	return ..()
