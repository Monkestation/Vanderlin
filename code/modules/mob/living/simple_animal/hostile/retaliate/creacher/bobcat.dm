//Bobcats are a faster, still hostile, version of a wolf.
/mob/living/simple_animal/hostile/retaliate/bobcat
	name = "lynx"
	desc = "An adorable, albeit hated creacher of Vanderlin's northern coast. hunting livestock and vulnerable people alike.."
	icon = 'icons/roguetown/mob/monster/bobcat.dmi'
	icon_state = "bobcat"
	icon_living = "bobcat"
	icon_dead = "bobcat_dead"

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
		/obj/item/natural/fur/bobcat = 1,
	)
	remains_type = /obj/effect/decal/remains/bobcat

	health = 100
	maxHealth = 100	//Wolf is 120

	simple_detect_bonus = 40	//VERY good at detecting stealthed people

	melee_damage_lower = 15
	melee_damage_upper = 25

	base_constitution = 6
	base_strength = 6
	base_speed = 15	//Fast as fuck, boy

	see_in_dark = 9
	move_to_delay = 2

	defprob = 35
	defdrain = 5

	dodgetime = 17

	ai_controller = /datum/ai_controller/volf

/obj/effect/decal/remains/bobcat
	icon = 'icons/roguetown/mob/monster/bobcat.dmi'
	icon_state = "bones"
