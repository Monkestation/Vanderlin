/mob/living/simple_animal/hostile/retaliate/voiddragon/red/Initialize()
	. = ..()
	REMOVE_TRAIT(src, TRAIT_ANTIMAGIC, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/voiddragon/red	//subtype for dragon-kobold event, requested by Mario
	name = "red dragon"
	desc = "An ancient creature from a bygone age. Now would be a good time to run."
	health = 2500
	maxHealth = 2500
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/misc/demon_attack1.ogg'
	icon_state = "dragon_red"
	icon_living = "dragon_red"
	icon_dead = "dragon_red_dead_redemption"
	speak_emote = list("roars")
	emote_hear = null
	emote_see = null
	base_intents = list(/datum/intent/unarmed/dragonclaw)
	faction = list("kobold")
	melee_damage_lower = 40
	melee_damage_upper = 40
	retreat_distance = 0
	minimum_distance = 0
	base_strength = 20
	aggressive = 1
	speed = 5
	move_to_delay = 7
	ranged = TRUE
	SET_BASE_PIXEL(-32, -32)
	deathmessage = "collapses to the floor with a final roar, the impact rocking the ground."
	footstep_type = FOOTSTEP_MOB_HEAVY
	void_corruption = FALSE
	dendor_taming_chance = DENDOR_TAME_PROB_LOW

/mob/living/simple_animal/hostile/retaliate/voiddragon/red/tsere
	name = "Tsere the Insurmountable"
	desc = "Her scales shimmer in the blue light, her form is death, her gaze is wisdom, her wings cut all. This is Tsere... The Insurmountable."
	faction = list("aberrant")
	health = 4000
	maxHealth = 4000
