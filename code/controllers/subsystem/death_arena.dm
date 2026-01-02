
SUBSYSTEM_DEF(death_arena)
	name = "Death Arena"
	wait = 2 SECONDS
	flags = SS_NO_INIT
	priority = 1

	var/turf/first_spawn
	var/turf/second_spawn
	var/list/waiting_fighters = list()
	///this is just so I can easily reference the head later
	var/list/fighters_heads = list()
	var/list/fighters = list()
	///we check if spirits here aswell
	var/list/tollless_clients = list()
	var/fighting = FALSE
	var/fight_force_end = null

/datum/controller/subsystem/death_arena/fire(resumed = 0)
	listclearnulls(waiting_fighters)
	listclearnulls(tollless_clients)

	for(var/client as anything in tollless_clients)
		if(world.time > tollless_clients[client])
			for(var/mob/living/carbon/spirit/spirit in waiting_fighters)
				if(!spirit?.client)
					remove_fighter(spirit)
					continue
				if(spirit?.client.key != client)
					continue
				spirit.give_patron_toll()
				remove_fighter(spirit)
				tollless_clients -= client

	if(fight_force_end)
		if(fight_force_end < world.time)
			force_end_fight()
	if(!first_spawn || !second_spawn)
		return
	if(fighting)
		return
	if(length(waiting_fighters) < 2)
		return
	start_fight()

/datum/controller/subsystem/death_arena/proc/add_fighter(mob/living/fighter,time_of_death = 0)
	if(!fighter.client)
		return
	waiting_fighters += fighter
	tollless_clients[fighter.client.key] = (world.time + 8 MINUTES) - (time_of_death == 0 ? 0 : (world.time - time_of_death))
	RegisterSignal(fighter, COMSIG_PARENT_QDELETING, PROC_REF(remove_fighter), fighter)

/datum/controller/subsystem/death_arena/proc/remove_fighter(mob/living/fighter)
	waiting_fighters -= fighter

/datum/controller/subsystem/death_arena/proc/start_fight()
	fighting = TRUE
	for(var/mob/living/carbon/spirit/spirit in waiting_fighters)
		if(!spirit?.client)
			remove_fighter(spirit)
			continue

	var/mob/living/carbon/spirit/first = pick(waiting_fighters)
	remove_fighter(first)
	var/mob/living/carbon/human/species/skeleton/first_skeleton = new /mob/living/carbon/human/species/skeleton/death_arena(get_turf(first_spawn))
	first_skeleton.name = first.livingname
	first_skeleton.ckey = first.ckey
	RegisterSignal(first_skeleton, COMSIG_LIVING_DEATH, PROC_REF(open_death_gate))

	var/mob/living/carbon/spirit/second = pick(waiting_fighters)
	remove_fighter(second)
	var/mob/living/carbon/human/species/skeleton/second_skeleton = new /mob/living/carbon/human/species/skeleton/death_arena(get_turf(second_spawn))
	second_skeleton.name = second.livingname
	second_skeleton.ckey = second.ckey
	RegisterSignal(second_skeleton, COMSIG_LIVING_DEATH, PROC_REF(open_death_gate))

	fighters = list(first_skeleton, second_skeleton)

	fighters_heads = list(first_skeleton.get_bodypart(BODY_ZONE_HEAD), second_skeleton.get_bodypart(BODY_ZONE_HEAD))

	first_skeleton.forceMove(get_turf(first_spawn))
	second_skeleton.forceMove(get_turf(second_spawn))
	var/necramessage = span_boldannounce("DECAPITATE YOUR OPPONENT AND BRING IT TO THE ALTAR ABOVE.")
	to_chat(first_skeleton,necramessage)
	to_chat(second_skeleton,necramessage)

	qdel(first)
	qdel(second)

	if(!first_skeleton.ckey && !second_skeleton.ckey)
		end_fight_no_client()

	fight_force_end = world.time + 10 MINUTES

/datum/controller/subsystem/death_arena/proc/try_end_fight(obj/item/bodypart/head/head, mob/living/carbon/user)
	if(!istype(head))
		return FALSE
	if(!(head in fighters_heads))
		return FALSE
	return TRUE

/datum/controller/subsystem/death_arena/proc/process_fight_end(obj/item/bodypart/head/head, mob/living/carbon/user)
	if(!try_end_fight(head, user))
		return

	fighters_heads = list()
	tollless_clients -= user?.client?.key

	for(var/mob/living/carbon/carbon as anything in fighters)
		fighters -= carbon
		if(carbon != user)
			var/turf/spawn_loc = pick(GLOB.underworldspiritspawns)
			var/mob/living/carbon/spirit/O = new /mob/living/carbon/spirit(spawn_loc)
			O.livingname = carbon.name
			O.ckey = carbon.ckey
			ADD_TRAIT(O, TRAIT_PACIFISM, TRAIT_GENERIC)
			add_fighter(O)
			qdel(carbon)
		else
			carbon.returntolobby()
			qdel(carbon)
	fighters = list()

	fighting = FALSE
	close_death_gate()
	fight_force_end = null

/datum/controller/subsystem/death_arena/proc/admin_reset()
	log_admin("[key_name(usr)] cleared death arena.")
	message_admins("[key_name_admin(usr)] cleared death arena.")
	if(!force_end_fight())
		message_admins("ERROR: Clearing Death Arena failed.")
		fighters = list()
		fighting = FALSE
		fight_force_end = null



/datum/controller/subsystem/death_arena/proc/force_end_fight()
	fighters_heads = list()
	for(var/mob/living/carbon/carbon in fighters)
		fighters -= carbon
		carbon.returntolobby()
		qdel(carbon)
	fight_force_end = null
	fighting = FALSE
	return TRUE

/datum/controller/subsystem/death_arena/proc/end_fight_no_client()
	fighters_heads = list()
	for(var/mob/living/carbon/carbon in fighters)
		fighters -= carbon
		qdel(carbon)
	fight_force_end = null
	fighting = FALSE

/datum/controller/subsystem/death_arena/proc/open_death_gate()
	for(var/obj/structure/gate/G in GLOB.biggates)
		if(G.gid != "death")
			continue
		G.open()

/datum/controller/subsystem/death_arena/proc/close_death_gate()
	for(var/obj/structure/gate/G in GLOB.biggates)
		if(G.gid != "death")
			continue
		G.close()

/datum/controller/subsystem/death_arena/proc/assign_death_spawn(atom/movable/movable)
	if(!first_spawn)
		first_spawn = get_turf(movable)
		return
	if(!second_spawn)
		second_spawn = get_turf(movable)
		return

/datum/outfit/arena_skeleton/pre_equip(mob/living/carbon/human/H, visuals_only)
	..()

	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)

	r_hand = /obj/item/weapon/mace/steel
	l_hand = /obj/item/weapon/shield/wood
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/axe/iron


/obj/structure/table/wood/fine/altar
	name = "Ravox's sacrifical altar"
	desc = "It awaits an offering of your triumphs"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "ravox_altar"
	max_integrity = 1000000000

/obj/structure/table/wood/fine/altar/after_added_effects(obj/item/item, mob/user)
	if(!istype(item, /obj/item/bodypart/head))
		return
	add_abstract_elastic_data(ELASCAT_COMBAT, ELASDATA_FIGHT_REVIVES, 1)
	record_round_statistic(STATS_UNDERWORLD_DUELS)
	SSdeath_arena.process_fight_end(item, user)

/obj/structure/underworld/ravox
	name = "Ravox"
	desc = "Ravox, God of Warfare, Justice, and Bravery. He finds solace in his friendship with Necra and his retreat to the Underworld. Upon your gaze, he gives you a respectful nod. Damn, he's cool.."
	icon = 'icons/roguetown/underworld/ravox.dmi'
	icon_state = "ravox"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE
	max_integrity = 1000000000
	resistance_flags = INDESTRUCTIBLE


/obj/structure/underworld/necra
	name = "Necra"
	desc = "The Undermaiden herself, in her true form. The most ancient of living gods. She observes your battles gleefully, gratitude in her eyes to be relieved from the arduousness of eternity. Her close friend and confidant, Ravox, sits by her side. The two must have worked hard to restructure the underworld like this. They seem pleased with their work."
	icon = 'icons/roguetown/underworld/necra.dmi'
	icon_state = "necra"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE
	max_integrity = 1000000000
	resistance_flags = INDESTRUCTIBLE

/obj/structure/underworld/necra/Initialize()
	. = ..()
	set_light(5, 4, 30, l_color = LIGHT_COLOR_BLUE)
