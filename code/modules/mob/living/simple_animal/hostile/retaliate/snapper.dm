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
	return ..()
