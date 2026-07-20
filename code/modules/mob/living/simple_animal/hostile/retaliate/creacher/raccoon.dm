//Raccoons are a faster, still hostile, version of a wolf and bobcat, but the weakest of the three.
/mob/living/simple_animal/hostile/retaliate/raccoon
	name = "rakun"
	desc = "An adorable albeit dangerous creacher of Vanderlin's northern coast, known to steal food from bins or eat small game."
	icon = 'icons/roguetown/mob/monster/raccoon.dmi'
	icon_state = "raccoon"
	icon_living = "raccoon"
	icon_dead = "raccoon_dead"

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, /obj/item/alch/viscera = 1)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 2,
		/obj/item/natural/hide = 1,
		/obj/item/alch/sinew = 1,
		/obj/item/alch/bone = 1,
		/obj/item/alch/viscera = 1,
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 2,
		/obj/item/natural/hide = 2,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 1,
		/obj/item/alch/viscera = 1,
		/obj/item/natural/fur/raccoon = 1,
	)
	remains_type = /obj/effect/decal/remains/raccoon

	health = 85
	maxHealth = 85	//Wolf is 120

	simple_detect_bonus = 30	//Good at detecting stealthed people, but not as well as Bobcats.

	melee_damage_lower = 10
	melee_damage_upper = 15

	base_constitution = 4
	base_strength = 4
	base_speed = 18	//A little faster than bobcats.

	see_in_dark = 9
	move_to_delay = 2

	defprob = 35
	defdrain = 5

	dodgetime = 17

	ai_controller = /datum/ai_controller/raccoon
	tame_chance = 25

	var/static/list/pet_commands = list(
		/datum/pet_command/fish,
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/raccoon/Initialize()
	. = ..()
	AddComponent(/datum/component/obeys_commands, pet_commands)

/obj/effect/decal/remains/raccoon
	desc = "Whether through unlucky circumstance or other means, this raccoon has passed."
	icon = 'icons/roguetown/mob/monster/raccoon.dmi'
	icon_state = "bones"
