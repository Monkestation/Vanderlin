/*  * * * * * * * * * * * * * * * * * * * * * * * * *
 *													*		Animal that can locate hidden truffles in bog area dirt turf
 *					TRUFFLE PIG						*		Dig them up with a shovel, pig will demand truffles eventually or stop working
 *					 								*		Meant to help locate some extra food in the wilderness
 *													*
 * * * * * * * * * * * * * * * * * * * * * * * * * * */


//	........   Dirt changes   ................
/turf/open/floor/dirt //truffles, var needed for the sniffing function
	var/hidden_truffles
	var/hidden_toxicshrooms

/turf/open/floor/dirt/Initialize()
	. = ..()
	if(istype(loc, /area/outdoors/bog))
		if(!((locate(/obj/structure) in src) || (locate(/obj/machinery) in src)))
			if(prob(4))
				hidden_truffles = TRUE
			else if(prob(1))
				hidden_toxicshrooms = FALSE
			return

/turf/open/floor/dirt/attackby(obj/item/W, mob/user, list/modifiers)
	if(hidden_truffles)
		if(istype(W, /obj/item/weapon/shovel))
			if(user.used_intent.type == /datum/intent/shovelscoop)
				playsound(src,'sound/items/dig_shovel.ogg', 70, TRUE)
				if(do_after(user, 3 SECONDS, src))
					new /obj/item/reagent_containers/food/snacks/truffles(get_turf(src))
					hidden_truffles = FALSE
				return TRUE
	if(hidden_toxicshrooms)
		if(istype(W, /obj/item/weapon/shovel))
			if(user.used_intent.type == /datum/intent/shovelscoop)
				playsound(src,'sound/items/dig_shovel.ogg', 70, TRUE)
				if(do_after(user, 3 SECONDS, src))
					new /obj/item/reagent_containers/food/snacks/toxicshrooms(get_turf(src))
					hidden_toxicshrooms = FALSE
				return TRUE
	return ..()

//	........   Truffles   ................
/obj/item/reagent_containers/food/snacks/truffles
	name = "truffles"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "mushroom1_full"
	base_icon_state = "mushroom1_full"
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	color = "#ab7d6f"
	tastes = list("mushroom" = 1)
	sellprice = 30
	rotprocess = null
	biting = TRUE

/obj/item/reagent_containers/food/snacks/cooked/truffle
	name = "cooked truffles"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "mushroom1_full"
	base_icon_state = "mushroom1_full"
	eat_effect = /datum/status_effect/buff/foodbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	color = "#835b4f"
	tastes = list("delicious truffles" = 2)
	biting = TRUE

/obj/item/reagent_containers/food/snacks/toxicshrooms
	name = "truffles"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "mushroom1_full"
	base_icon_state = "mushroom1_full"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 5)
	color = "#ab7d6f"
	tastes = list("mushroom" = 1)
	biting = TRUE

/obj/item/reagent_containers/food/snacks/cooked/truffle_toxic
	name = "cooked truffles"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "mushroom1_full"
	base_icon_state = "mushroom1_full"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 6)
	color = "#835b4f"
	tastes = list("off-putting" = 2)
	biting = TRUE

/mob/living/simple_animal/hostile/retaliate/trufflepig/female
	gender = FEMALE
	random_gender = FALSE

/mob/living/simple_animal/hostile/retaliate/trufflepig/male
	gender = MALE
	random_gender = FALSE

/mob/living/simple_animal/hostile/retaliate/trufflepig/male/Initialize()
	. = ..()


	AddComponent(\
		/datum/component/breed,\
		can_breed_with = list(/mob/living/simple_animal/hostile/retaliate/trufflepig, /mob/living/simple_animal/hostile/retaliate/trufflepig/male, /mob/living/simple_animal/hostile/retaliate/trufflepig/female),\
		breed_timer = 2 MINUTES \
	)

//	........   Truffle Pig   ................
/mob/living/simple_animal/hostile/retaliate/trufflepig
	icon = 'icons/roguetown/mob/monster/piggie.dmi'
	name = "truffle pig"
	desc = "A hairy pig, bred for finding truffles in the bog."
	icon_state = "piggie_m"
	icon_living = "piggie_m"
	icon_dead = "piggie_dead"
	icon_gib = "piggie_dead"

	animal_species = /mob/living/simple_animal/hostile/retaliate/trufflepig
	faction = list("goats")
	footstep_type = FOOTSTEP_MOB_SHOE
	emote_see = list("eyes the surroundings.", "flicks its ears.")
	deathsound = 'sound/vo/mobs/pig/hangry.ogg'

	response_help_continuous = "pets"
	response_help_simple = "give the signal to the"

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/fatty = 3,
									/obj/item/reagent_containers/food/snacks/fat = 1,
									/obj/item/natural/hide = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/fatty = 4,
							/obj/item/reagent_containers/food/snacks/fat = 2,
							/obj/item/natural/hide = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/fatty = 5,
							/obj/item/reagent_containers/food/snacks/fat = 3,
							/obj/item/natural/hide = 3)

	health = FEMALE_GOTE_HEALTH
	maxHealth = FEMALE_GOTE_HEALTH
	food_type = list(
		/obj/item/reagent_containers/food/snacks/truffles,
		/obj/item/trash/applecore,
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/produce,
		)
	pooptype = /obj/item/natural/poo/horse
	remains_type = /obj/effect/decal/remains/pig
	tame = TRUE

	base_intents = list(/datum/intent/simple/headbutt)
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	melee_damage_lower = 8
	melee_damage_upper = 14
	minimum_distance = 1
	base_speed = 2
	base_constitution = 8
	base_strength = 12
	can_buckle = TRUE
	buckle_lying = FALSE
	can_saddle = TRUE

	ai_controller = /datum/ai_controller/pig



	var/static/list/pet_commands = list(
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
			/datum/pet_command/truffle_sniff,
		)

	happy_funtime_mob = TRUE
	var/hangry_meter = 0
	var/random_gender = TRUE
	var/can_breed = TRUE


/mob/living/simple_animal/hostile/retaliate/trufflepig/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()

	if(can_breed)
		AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/hostile/retaliate/trufflepig, /mob/living/simple_animal/hostile/retaliate/trufflepig/male, /mob/living/simple_animal/hostile/retaliate/trufflepig/female),\
			3 MINUTES, \
			list(/mob/living/simple_animal/hostile/retaliate/trufflepig/piglet = 90, /mob/living/simple_animal/hostile/retaliate/trufflepig/piglet/boy = 10),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)

/mob/living/simple_animal/hostile/retaliate/trufflepig/proc/after_birth(mob/living/simple_animal/hostile/retaliate/cow/cowlet/baby, mob/living/partner)
	return


/mob/living/simple_animal/hostile/retaliate/trufflepig/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/pig/hangry.ogg')
		if("pain")
			return pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg')
		if("death")
			return pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg')

/mob/living/simple_animal/hostile/retaliate/trufflepig/taunted(mob/user)
	emote("aggro")
	return

/obj/effect/decal/remains/pig
	name = "remains"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/cow.dmi'

/mob/living/simple_animal/hostile/retaliate/trufflepig/tamed(mob/user)
	..()
	deaggroprob = 20
	if(can_buckle)
		AddComponent(/datum/component/riding/pig)


/mob/living/simple_animal/hostile/retaliate/trufflepig/Life()
	. = ..()
	if((src.loc) && isturf(src.loc))
		for(var/obj/item/reagent_containers/food/snacks/truffles/M in view(1,src))
			if(Adjacent(M))
				walk_towards(src, M, 1)
				sleep(3)
				visible_message("<span class='notice'>The pig devours the vulnerable truffles!</span>")
				hangry_meter = 0
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				qdel(M)
				break

/mob/living/simple_animal/hostile/retaliate/trufflepig/attack_hand(mob/living/carbon/human/M)
	. = ..()
	hangry_meter += 1
	if(hangry_meter > 9)
		to_chat(M, "<span class='notice'>The pig squeals in anger. It's sulking and refusing to work until it gets delicious truffles.</span>")
		playsound(src, 'sound/vo/mobs/pig/hangry.ogg', 120, TRUE, -1)
		return
	if(M.used_intent.type == INTENT_HELP)
		playsound(src, pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg'), 100, TRUE, -1)
		dir = pick(GLOB.cardinals)
		step(src, dir)
		playsound(src, 'sound/items/sniff.ogg', 60, FALSE)
		sleep(10)
		dir = pick(GLOB.cardinals)
		step(src, dir)
		playsound(src, 'sound/items/sniff.ogg', 60, FALSE)
		sleep(10)
		dir = pick(GLOB.cardinals)
		playsound(src, pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg'), 100, TRUE, -1)
		var/turf/t = get_turf(src)
		trufflesearch(t, 5)

/mob/living/simple_animal/hostile/retaliate/trufflepig/attackby(obj/item/O, mob/user, list/modifiers)
	if(istype(O, /obj/item/reagent_containers/food/snacks/truffles))
		visible_message("<span class='notice'>The pig munches the truffles, looking happy.</span>")
		hangry_meter = 0
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(O)

	if(istype(O, /obj/item/reagent_containers/food/snacks/toxicshrooms))
		visible_message("<span class='notice'>The pig munches the truffles reluctantly.</span>")
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(O)
		playsound(src, 'sound/vo/mobs/pig/hangry.ogg', 100, TRUE, -1)
		sleep(20)
		playsound(src, 'sound/vo/mobs/pig/hangry.ogg', 100, TRUE, -1)
		visible_message("<span class='notice'>The pig shivers.</span>")
		sleep(10)
		death()
	else
		return ..()


//	........   Truffle Search   ................
/mob/living/simple_animal/hostile/retaliate/trufflepig/proc/trufflesearch(turf/T, range = world.view)
	var/list/found_stuff = list()
	for(var/turf/open/floor/dirt/M in range(range, T))
		if(M.hidden_truffles)
			found_stuff += M
	if(LAZYLEN(found_stuff))
		for(var/turf/open/floor/dirt/M in found_stuff)
			var/obj/effect/temp_visual/truffle_overlay/oldC = locate(/obj/effect/temp_visual/truffle_overlay) in M
			if(oldC)
				qdel(oldC)
			new /obj/effect/temp_visual/truffle_overlay(M)

/obj/effect/temp_visual/truffle_overlay
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/roguetown/mob/trufflesniff.dmi'
	icon_state = "foundsome"
	appearance_flags = 0 //to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 3.5 SECONDS
	SET_BASE_PIXEL(-224, -224)

/mob/living/simple_animal/hostile/retaliate/trufflepig/piglet
	gender = FEMALE
	name = "truffle piglet"
	adult_growth = /mob/living/simple_animal/hostile/retaliate/trufflepig/female
	can_breed = FALSE

/mob/living/simple_animal/hostile/retaliate/trufflepig/piglet/Initialize()
	. = ..()
	var/matrix/matrix = matrix()
	matrix.Scale(0.75, 0.75)
	transform = matrix

/mob/living/simple_animal/hostile/retaliate/trufflepig/piglet/boy
	adult_growth = /mob/living/simple_animal/hostile/retaliate/trufflepig/male
	gender = MALE
