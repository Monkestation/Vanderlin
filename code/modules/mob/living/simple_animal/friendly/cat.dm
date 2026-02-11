//Cat
/mob/living/simple_animal/pet/cat
	name = "parent roguecat"
	desc = "If you're seeing this, someone forgot to set a mob desc or it spawned the parent mob. Report to the Creators."
	icon = 'icons/roguetown/mob/monster/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_SMALL
	density = FALSE // moveblocking cat is annoying as hell
	pass_flags = PASSMOB
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	animal_species = /mob/living/simple_animal/pet/cat
	base_intents = list(/datum/intent/simple/claw)

	food_type = list(
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/fish,
	)

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
							/obj/item/alch/sinew = 2,
							/obj/item/alch/bone = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	base_strength = 3
	base_endurance = 4
	base_speed = 3
	base_constitution = 3
	gold_core_spawnable = FRIENDLY_SPAWN
	tame_chance = 25

	footstep_type = FOOTSTEP_MOB_CLAW

	ai_controller = /datum/ai_controller/cat

	var/obj/item/held_item

/mob/living/simple_animal/pet/cat/Initialize()
	. = ..()
	if(prob(50))
		gender = FEMALE
	AddElement(/datum/element/ai_retaliate)
	add_verb(src, /mob/living/proc/lay_down)
	AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/pet/cat),\
			3 MINUTES,\
			list(/mob/living/simple_animal/pet/cat/kitten = 100),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)

/mob/living/simple_animal/pet/cat/proc/drop_held_item()
	held_item.forceMove(get_turf(src))
	held_item = null

/mob/living/simple_animal/pet/cat/Crossed(atom/movable/AM) // Gato Basado - makes it leave when people step too close
	. = ..()
	if(isliving(AM))
		if(health > 1)
			icon_state = "[icon_living]"
			set_resting(FALSE, instant = TRUE)
			if(isturf(loc))
				dir = pick(GLOB.cardinals)
				step(src, dir)
			if(!stat && resting && !buckled)
				return

/mob/living/simple_animal/proc/personal_space()
	if(locate(/mob/living/carbon) in get_turf(src))
		sleep(1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()
	else
		return


/mob/living/simple_animal/pet/cat/inn
	name = "inn cat"
	desc = "This old, fat cat keeps the inn free of rats... allegedly. It seems like he mostly lazes about in the sun and asks for treats."

/mob/living/simple_animal/pet/cat/cabbit
	name = "cabbit"
	desc = "A cabbit, a particular favorite of Enigma's fauna, as pets and meals. It has been exported to Vanderlin." // Do NOT eat the cabbit!!!!!!
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit"
	icon_living = "cabbit"
	icon_dead = "cabbit_dead"
	remains_type = /obj/effect/decal/remains/cabbit
	speak = list("Meow!", "Chk!", "Purr!", "Chrr!")
	speak_emote = list("chirrups", "meows")
	emote_hear = list("meows.", "clucks.")
	emote_see = list("brings their ears alert.", "scratches their ear with a hindleg.")
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
							/obj/item/alch/sinew = 2,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/cabbit = 1)

/mob/living/simple_animal/pet/cat/black
	name = "black cat"
	desc = "Possessed of lamplike eyes and a meow that sounds like the rattle of bones. Black cats are sacred to Necra, said to bring wandering spirits to the Carriageman."
	gender = FEMALE
	icon = 'icons/roguetown/topadd/takyon/Cat.dmi'
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"

/mob/living/simple_animal/pet/cat/black/Initialize()
	. = ..()
	ai_controller?.blackboard[BB_CAT_RACISM] = FALSE

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = ""
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = ""
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	adult_growth = /mob/living/simple_animal/pet/cat

	ai_controller = /datum/ai_controller/kitten

/mob/living/simple_animal/pet/cat/kitten/Initialize()
	. = ..()
	var/matrix/matrix = matrix()
	matrix.Scale(0.5, 0.5)
	transform = matrix

/mob/living/simple_animal/pet/cat/proc/after_birth(mob/living/simple_animal/pet/cat/kitten/baby, mob/living/partner)
	return

/mob/living/simple_animal/pet/cat/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD)
				new /obj/effect/temp_visual/heart(loc)
				emote("me", 1, "purrs!")
				if(flags_1 & HOLOGRAM_1)
					return
				M.add_stress(/datum/stress_event/pet_animal)
		else
			if(M && stat != DEAD)
				emote("me", 1, "hisses!")

/mob/living/simple_animal/pet/cat/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(stat != DEAD)
		// Handle racist reaction if enabled
		if(ai_controller.blackboard[BB_CAT_RACISM])
			if((isdarkelf(M)) || ishalforc(M) || istiefling(M) || (M.mind && M.mind.has_antag_datum(/datum/antagonist/vampire)))
				// visible_message("<span class='notice'>\The [src] hisses at [M] and recoils in disgust.</span>")
				icon_state = "[icon_living]"
				set_resting(FALSE)
				playsound(src, 'sound/vo/mobs/cat/cathiss.ogg', 80, TRUE, -1)
				dir = pick(GLOB.alldirs)
				step(src, dir)
				personal_space()
				return

		// Handle normal petting - trigger the wuv proc
		wuv(1, M)
