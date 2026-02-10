
/obj/item/bait
	name = "bag of bait"
	desc = "Horrid smell to me, wonderful smell to big game."
	icon_state = "bait"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	var/check_counter = 0
	var/list/attracted_types = list(/mob/living/simple_animal/hostile/retaliate/bigrat = 10,
										/mob/living/simple_animal/hostile/retaliate/goat = 33,
									/mob/living/simple_animal/hostile/retaliate/goatmale = 33,
									/mob/living/simple_animal/pet/cat/cabbit = 33,
									/mob/living/simple_animal/hostile/retaliate/chicken = 55)
	var/attraction_chance = 100
	var/deployed = 0
	var/deploy_speed = 10 SECONDS
	resistance_flags = FLAMMABLE
	grid_height = 32
	grid_width = 32

/obj/item/bait/Initialize()
	. = ..()
	check_counter = world.time

/obj/item/bait/attack_self(mob/user, list/modifiers)
	. = ..()
	user.visible_message("<span class='notice'>[user] begins deploying the bait...</span>", \
						"<span class='notice'>I begin deploying the bait...</span>")
	if(do_after(user, deploy_speed * (1/(user.get_skill_level(/datum/skill/craft/traps, TRUE) + 1)), src)) //rogtodo hunting skill
		user.dropItemToGround(src, TRUE)
		START_PROCESSING(SSobj, src)
		name = "bait"
		icon_state = "[icon_state]1"
		deployed = 1

/obj/item/bait/attack_hand(mob/user)
	if(deployed)
		user.visible_message("<span class='notice'>[user] begins gathering up the bait...</span>", \
							"<span class='notice'>I begin gathering up the bait...</span>")
		if(do_after(user, deploy_speed * (1/(user.get_skill_level(/datum/skill/craft/traps, TRUE) + 1)), src)) //rogtodo hunting skill
			STOP_PROCESSING(SSobj, src)
			name = initial(name)
			deployed = 0
			icon_state = initial(icon_state)
			..()
	else
		..()

/obj/item/bait/process()
	if(deployed)
		if(world.time > check_counter + 10 SECONDS)
			check_counter = world.time
			var/area/A = get_area(src)
			if(A.outdoors)
				var/list/possible_targets = list()
				for(var/obj/item/bait/B in range(7, src))
					if(B == src)
						continue
					if(can_see(src, B, 7))
						possible_targets += B
				if(possible_targets.len)
					return
				possible_targets = list()
				var/list/objects = range(7, src)
				for(var/obj/structure/flora/tree/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/flora/grass/bush/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/flora/grass/bush_meagre/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/flora/grass/herb/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/wild_plant/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/chair/bench/ancientlog/RT in objects)
					if(can_see(src, RT, 7))
						possible_targets += RT
				if(!possible_targets.len)
					return
				var/cume = 0
				for(var/mob/living/carbon/human/L in viewers(src, 7))
					if(L.stat == CONSCIOUS)
						cume++
				if(!cume)
					if(prob(attraction_chance))
//						var/turf/T = get_turf(pick(possible_targets))
						var/turf/T = get_turf(src)
						if(T)
							var/mob/M = pickweight(attracted_types)
							new M(T)
							new /obj/item/natural/cloth(T)
							qdel(src)
					else
						qdel(src)
	..()

/obj/item/bait/sweet
	name = "bag of sweetbait"
	desc = "This bait doesn't smell as bad. I might even try a bite..."
	icon_state = "baitp"
	attracted_types = list(/mob/living/simple_animal/hostile/retaliate/goat = 33,
							/mob/living/simple_animal/hostile/retaliate/goatmale = 33,
							/mob/living/simple_animal/pet/cat/cabbit = 50, // Rabbits love sweet things
							/mob/living/simple_animal/hostile/retaliate/saiga = 20,
							/mob/living/simple_animal/hostile/retaliate/saigabuck = 20,
							/mob/living/simple_animal/hostile/retaliate/wolf = 10)


/obj/item/bait/bloody
	name = "bag of bloodbait"
	desc = "A deployable bag of bait used by hunters to attract predators within the wilds."
	icon_state = "baitb"
	attracted_types = list(/mob/living/simple_animal/hostile/retaliate/wolf = 33,
						/mob/living/simple_animal/hostile/retaliate/bigrat = 10,
						/mob/living/simple_animal/hostile/retaliate/mole = 15,
						/mob/living/simple_animal/hostile/retaliate/troll/axe = 5,
						/mob/living/simple_animal/hostile/retaliate/troll/bog = 5,
						/mob/living/simple_animal/hostile/retaliate/troll/caerbannog = 2.5)

/obj/item/bait/forestdelight
	name = "meat wrapped in strange herbs"
	desc = "A piece of rotten and rancid meat wrapped in several herbs. The aroma induces both vomit and a nice herbal odor."
	icon_state = "baitbriar"
	attracted_types = list (/mob/living/simple_animal/hostile/retaliate/mole/briars = 50,
						/mob/living/simple_animal/pet/cat/cabbit = 5) // cause get rabbited
