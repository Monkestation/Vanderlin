/mob/living/simple_animal/hostile/retaliate/spider/robotic
	name = "clockwork spider"
	desc = "A metallic creature made to instill a sense of fear onto trespassers. It's fangs producing a shocking strike."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_clock"
	icon_living = "drone_clock"
	icon_dead = "drone_clock_dead"

	mob_biotypes = MOB_ROBOTIC

	botched_butcher_results = list(/obj/item/gear/metal/bronze = 1)
	butcher_results = list(/obj/item/gear/metal/bronze = 1, /obj/item/natural/silk = 1)
	perfect_butcher_results = list(/obj/item/gear/metal/bronze = 2, /obj/item/natural/silk = 3)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/misc/elec (1).ogg')

	head_butcher = null

	ai_controller = /datum/ai_controller/volf // Laziness, we really need a generic hostile controller

	has_glowy_eyes = FALSE

/mob/living/simple_animal/hostile/retaliate/spider/robotic/Initialize(mapload, ...)
	. = ..()
	gender = NEUTER
