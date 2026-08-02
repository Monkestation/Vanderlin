//VANDERLIN TODO: Make taming AI better to allow for tame commands.
/mob/living/simple_animal/hostile/retaliate/wolf/familiar
	icon = 'icons/roguetown/mob/monster/vol.dmi'
	name = "familiar"
	desc = "A spectral volf familiar created by arcyne magicks."
	icon_state = "spiritw"
	icon_living = "spiritw"
	icon_dead = null
	base_intents = list(/datum/intent/simple/bite)
	faction = list("summoned")
	mob_biotypes = MOB_BEAST
	health = 120
	maxHealth = 120
	melee_damage_lower = 10
	melee_damage_upper = 20
	food_type = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/bodypart, /obj/item/organ)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	retreat_health = 0.1
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	remains_type = null
	botched_butcher_results = null
	butcher_results = null
	perfect_butcher_results = null
	head_butcher = null
	del_on_death = TRUE
	dendor_taming_chance = DENDOR_TAME_PROB_NONE

	ai_controller = /datum/ai_controller/summon
