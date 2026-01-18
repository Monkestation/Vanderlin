/datum/round_event/vines/start()
	var/list/turfs = list() //list of all the empty floor turfs in the hallway areas

	for(var/area/outdoors/town/A in GLOB.areas)
		for(var/turf/open/F as anything in A.get_turfs_from_all_zlevels())
			if(F.density || isopenspace(F))
				continue
			turfs += F

	var/maxi = 7

	if(length(turfs))
		for(var/i in 1 to rand(5, maxi))
			var/turf/T = pick_n_take(turfs)
			message_admins("VINES at [ADMIN_VERBOSEJMP(T)]")
			new /datum/vine_controller(T, event = src) //spawn a controller at turf

/datum/vine_mutation
	var/name = ""
	var/severity = 1
	var/hue
	var/quality

/datum/vine_mutation/proc/add_mutation_to_vinepiece(obj/structure/vine/holder)
	holder.mutations |= src
	holder.add_atom_colour(hue, FIXED_COLOUR_PRIORITY)

/datum/vine_mutation/proc/process_mutation(obj/structure/vine/holder)
	return

/datum/vine_mutation/proc/process_temperature(obj/structure/vine/holder, temp, volume)
	return

/datum/vine_mutation/proc/on_birth(obj/structure/vine/holder)
	return

/datum/vine_mutation/proc/on_grow(obj/structure/vine/holder)
	return

/datum/vine_mutation/proc/on_death(obj/structure/vine/holder)
	return

/datum/vine_mutation/proc/on_hit(obj/structure/vine/holder, mob/hitter, obj/item/I, expected_damage)
	. = expected_damage

/datum/vine_mutation/proc/on_cross(obj/structure/vine/holder, mob/crosser)
	return

/datum/vine_mutation/proc/on_chem(obj/structure/vine/holder, datum/reagent/R)
	return

/datum/vine_mutation/proc/on_eat(obj/structure/vine/holder, mob/living/eater)
	return

/datum/vine_mutation/proc/on_spread(obj/structure/vine/holder, turf/target)
	return

/datum/vine_mutation/proc/on_buckle(obj/structure/vine/holder, mob/living/buckled)
	return

/datum/vine_mutation/proc/on_explosion(severity, target, obj/structure/vine/holder)
	return


/datum/vine_mutation/light
	name = "light"
	hue = "#ffff00"
	quality = POSITIVE
	severity = 4

/datum/vine_mutation/light/on_grow(obj/structure/vine/holder)
	if(holder.energy)
		holder.set_light(severity, severity, 0.3)

/datum/vine_mutation/healing
	name = "healing"
	hue = "#b551e4"
	quality = POSITIVE
	severity = 50

/datum/vine_mutation/healing/on_cross(obj/structure/vine/holder, mob/living/crosser)
	if(prob(severity) && istype(crosser) && !isvineimmune(crosser))
		to_chat(crosser, "<span class='alert'>I accidentally touch the vine and feel a strange sensation.</span>")
		crosser.adjustBruteLoss(-2, updating_health = FALSE)
		crosser.adjustFireLoss(-2, updating_health = FALSE)

/datum/vine_mutation/toxicity
	name = "toxic"
	hue = "#ff00ff"
	severity = 10
	quality = NEGATIVE

/datum/vine_mutation/toxicity/on_cross(obj/structure/vine/holder, mob/living/crosser)
	if(prob(severity) && istype(crosser) && !isvineimmune(crosser))
		to_chat(crosser, "<span class='alert'>I accidentally touch the vine and feel a strange sensation.</span>")
		crosser.adjustToxLoss(5)

/datum/vine_mutation/toxicity/on_eat(obj/structure/vine/holder, mob/living/eater)
	if(!isvineimmune(eater))
		eater.adjustToxLoss(5)

/datum/vine_mutation/explosive  //OH SHIT IT CAN CHAINREACT RUN!!!
	name = "explosive"
	hue = "#ff0000"
	quality = NEGATIVE
	severity = 2

/datum/vine_mutation/explosive/on_explosion(explosion_severity, target, obj/structure/vine/holder)
	if(explosion_severity < 3)
		qdel(holder)
	else
		. = 1
		QDEL_IN(holder, 5)

/datum/vine_mutation/explosive/on_death(obj/structure/vine/holder, mob/hitter, obj/item/I)
	explosion(holder.loc, 0, 0, severity, 0, 0)

/datum/vine_mutation/fire_proof
	name = "fire proof"
	hue = "#ff8888"
	quality = MINOR_NEGATIVE

/datum/vine_mutation/fire_proof/process_temperature(obj/structure/vine/holder, temp, volume)
	return 1

/datum/vine_mutation/fire_proof/on_hit(obj/structure/vine/holder, mob/hitter, obj/item/I, expected_damage)
	if(I && I.damtype == "fire")
		. = 0
	else
		. = expected_damage

/datum/vine_mutation/vine_eating
	name = "vine eating"
	hue = "#ff7700"
	quality = MINOR_NEGATIVE

/datum/vine_mutation/vine_eating/on_spread(obj/structure/vine/holder, turf/target)
	var/obj/structure/vine/prey = locate() in target
	if(prey && !prey.mutations.Find(src))  //Eat all vines that are not of the same origin
		qdel(prey)

/datum/vine_mutation/aggressive_spread  //very OP, but im out of other ideas currently
	name = "aggressive spreading"
	hue = "#333333"
	severity = 3
	quality = NEGATIVE

/datum/vine_mutation/aggressive_spread/on_spread(obj/structure/vine/holder, turf/target)
	target.ex_act(severity, null, src) // vine immunity handled at /mob/ex_act

/datum/vine_mutation/aggressive_spread/on_buckle(obj/structure/vine/holder, mob/living/buckled)
	buckled.ex_act(severity, null, src)

/datum/vine_mutation/transparency
	name = "transparent"
	hue = ""
	quality = POSITIVE

/datum/vine_mutation/transparency/on_grow(obj/structure/vine/holder)
	holder.set_opacity(0)
	holder.alpha = 125

/datum/vine_mutation/thorns
	name = "thorny"
	hue = "#666666"
	severity = 10
	quality = NEGATIVE

/datum/vine_mutation/thorns/on_cross(obj/structure/vine/holder, mob/living/crosser)
	if(prob(severity) && istype(crosser) && !isvineimmune(holder))
		var/mob/living/M = crosser
		M.adjustBruteLoss(5)
		to_chat(M, "<span class='alert'>I cut myself on the thorny vines.</span>")

/datum/vine_mutation/thorns/on_hit(obj/structure/vine/holder, mob/living/hitter, obj/item/I, expected_damage)
	if(prob(severity) && istype(hitter) && !isvineimmune(holder))
		var/mob/living/M = hitter
		M.adjustBruteLoss(5)
		to_chat(M, "<span class='alert'>I cut myself on the thorny vines.</span>")
	. =	expected_damage

/datum/vine_mutation/woodening
	name = "hardened"
	hue = "#997700"
	quality = NEGATIVE

/datum/vine_mutation/woodening/on_grow(obj/structure/vine/holder)
	if(holder.energy)
		holder.density = TRUE
	holder.modify_max_integrity(100)
	holder.update_integrity(100)

/datum/vine_mutation/woodening/on_hit(obj/structure/vine/holder, mob/living/hitter, obj/item/I, expected_damage)
	if(I.get_sharpness())
		. = expected_damage * 0.5
	else
		. = expected_damage

// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/structure/vine
	name = "weepvine"
	desc = ""
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = TRUE
	density = FALSE
	layer = SPACEVINE_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE //Clicking anywhere on the turf is good enough
	pass_flags_self = PASSTABLE | PASSGRILLE
	max_integrity = 5
	resistance_flags = FLAMMABLE
	damage_deflection = 5
	blade_dulling = DULLING_CUT
	var/energy = 0
	var/datum/vine_controller/master = null
	var/list/mutations = list()
	break_sound = "plantcross"
	destroy_sound = null
	attacked_sound = 'sound/misc/woodhit.ogg'

/obj/structure/vine/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "Light[rand(1,2)]"
	add_atom_colour("#ffffff", FIXED_COLOUR_PRIORITY)

/obj/structure/vine/Destroy()
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_death(src)
	if(master)
		master.VineDestroyed(src)
	mutations = list()
	set_opacity(0)
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	return ..()

/obj/structure/vine/proc/on_chem_effect(datum/reagent/R)
	var/override = 0
	for(var/datum/vine_mutation/SM in mutations)
		override += SM.on_chem(src, R)

/obj/structure/vine/proc/eat(mob/eater)
	var/override = 0
	for(var/datum/vine_mutation/SM in mutations)
		override += SM.on_eat(src, eater)
	if(!override)
		qdel(src)

/obj/structure/vine/attacked_by(obj/item/I, mob/living/user)
	..()
//	var/damage_dealt = I.force
//	if(I.get_sharpness())
//		damage_dealt *= 4
//	if(I.damtype == BURN)
//		damage_dealt *= 4

//	for(var/datum/vine_mutation/SM in mutations)
//		damage_dealt = SM.on_hit(src, user, I, damage_dealt) //on_hit now takes override damage as arg and returns new value for other mutations to permutate further
//	take_damage(damage_dealt, I.damtype, "melee", 1)

/obj/structure/vine/Crossed(mob/crosser)
	if(isliving(crosser))
		for(var/datum/vine_mutation/SM in mutations)
			SM.on_cross(src, crosser)
	if(prob(23) && istype(crosser) && !isvineimmune(crosser))
		var/mob/living/M = crosser
		M.adjustBruteLoss(5)
		to_chat(M, "<span class='warning'>I nick myself on the thorny vines.</span>")

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/vine/attack_hand(mob/user)
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_hit(src, user)
	. = ..()

/obj/structure/vine/attack_paw(mob/living/user)
	return attack_hand(user)

/datum/vine_controller
	var/list/obj/structure/vine/vines
	var/obj/structure/flora/tree/evil/tree
	var/list/growth_queue
	var/spread_multiplier = 1
	var/spread_cap = 4
	var/list/vine_mutations_list
	var/mutativeness = 1

/datum/vine_controller/New(turf/location, list/muts, potency, production, datum/round_event/event = null)
	vines = list()
	growth_queue = list()
	var/obj/structure/vine/SV = spawn_spacevine_piece(location, null, muts)
	if (event)
		event.announce_to_ghosts(SV)
	START_PROCESSING(SSobj, src)
	vine_mutations_list = list()
	init_subtypes(/datum/vine_mutation/, vine_mutations_list)
	if(potency != null)
		mutativeness = potency / 10
//	if(production != null)
//		spread_cap *= production / 5
//		spread_multiplier /= production / 5
	tree = new /obj/structure/flora/tree/evil(location)
	tree.controller = src

/datum/vine_controller/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_SPACEVINE_PURGE, "Delete Vines")

/datum/vine_controller/vv_do_topic(href_list)
	. = ..()
	if(href_list[VV_HK_SPACEVINE_PURGE])
		if(alert(usr, "Are you sure you want to delete this spacevine cluster?", "Delete Vines", "Yes", "No") == "Yes")
			DeleteVines()

/datum/vine_controller/proc/DeleteVines()	//this is kill
	QDEL_LIST(vines)	//this will also qdel us

/datum/vine_controller/Destroy()
	STOP_PROCESSING(SSobj, src)
	tree = null
	vines = null
	return ..()

/datum/vine_controller/proc/spawn_spacevine_piece(turf/location, obj/structure/vine/parent, list/muts)
	var/obj/structure/vine/SV = new(location)
	growth_queue += SV
	vines += SV
	SV.master = src
	if(muts && muts.len)
		for(var/datum/vine_mutation/M in muts)
			M.add_mutation_to_vinepiece(SV)
		return
	if(parent)
		SV.mutations |= parent.mutations
		var/parentcolor = parent.atom_colours[FIXED_COLOUR_PRIORITY]
		SV.add_atom_colour(parentcolor, FIXED_COLOUR_PRIORITY)
//		if(prob(mutativeness))
//			var/datum/vine_mutation/randmut = pick(vine_mutations_list - SV.mutations)
//			randmut.add_mutation_to_vinepiece(SV)

	for(var/datum/vine_mutation/SM in SV.mutations)
		SM.on_birth(SV)
	location.Entered(SV)
	return SV

/datum/vine_controller/proc/endvines()
	for(var/obj/structure/vine/V as anything in vines)
		V.dieepic()
	qdel(src)

/datum/vine_controller/proc/VineDestroyed(obj/structure/vine/S)
	S.master = null
	vines -= S
	growth_queue -= S
	if(!vines.len)
		qdel(src)

/datum/vine_controller/process()
	if(!LAZYLEN(vines))
		if(!tree)
			qdel(src) //space vines exterminated. Remove the controller
			return
		else
			spawn_spacevine_piece(tree.loc, null)
	if(!growth_queue)
		qdel(src) //Sanity check
		return

	var/length = 0

//	length = min( spread_cap , max( 1 , vines.len / spread_multiplier ) )
	length = 20
	var/i = 0
	var/list/obj/structure/vine/queue_end = list()

	for(var/obj/structure/vine/SV in growth_queue)
		if(QDELETED(SV))
			continue
		i++
		queue_end += SV
		growth_queue -= SV
		for(var/datum/vine_mutation/SM in SV.mutations)
			SM.process_mutation(SV)
		if(SV.energy < 2) //If tile isn't fully grown
			if(prob(20))
				SV.grow()
		else //If tile is fully grown
			SV.entangle_mob()
		if(vines.len > 25)
			break
		SV.spread()
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end

/obj/structure/vine/proc/dieepic()
	icon_state = "[icon_state]d"
	modify_max_integrity(1, can_break = FALSE)
	update_integrity(1)
	destroy_sound = 'sound/foley/breaksound.ogg'

/obj/structure/vine/proc/grow()
	if(!energy)
		src.icon_state = pick("Med1", "Med2")
		energy = 1
		set_opacity(1)
	else
		src.icon_state = pick("Hvy1", "Hvy2")
		energy = 2
//		density = TRUE

	for(var/datum/vine_mutation/SM in mutations)
		SM.on_grow(src)

/obj/structure/vine/proc/entangle_mob()
	if(!has_buckled_mobs() && prob(25))
		for(var/mob/living/V in src.loc)
			entangle(V)
			if(has_buckled_mobs())
				break //only capture one mob at a time


/obj/structure/vine/proc/entangle(mob/living/V)
	if(!V || isvineimmune(V))
		return
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_buckle(src, V)
	if((V.stat != DEAD) && (V.buckled != src)) //not dead or captured
		to_chat(V, "<span class='danger'>The vines [pick("wind", "tangle", "tighten")] around me!</span>")
		buckle_mob(V, 1)
	V.adjustOxyLoss(10)

/obj/structure/vine/proc/spread()
	var/direction = pick(GLOB.cardinals)
	var/turf/stepturf = get_step(src,direction)
	if (stepturf.Enter(src))
		for(var/datum/vine_mutation/SM in mutations)
			SM.on_spread(src, stepturf)
			stepturf = get_step(src,direction) //in case turf changes, to make sure no runtimes happen
		if(!locate(/obj/structure/vine, stepturf))
			if(master)
				master.spawn_spacevine_piece(stepturf, src)

/obj/structure/vine/ex_act(severity, target)
	if(istype(target, type)) //if its agressive spread vine dont do anything
		return
	var/i
	for(var/datum/vine_mutation/SM in mutations)
		i += SM.on_explosion(severity, target, src)
	if(!i)
		qdel(src)

/obj/structure/vine/temperature_expose(temp, volume)
	var/override = 0
	for(var/datum/vine_mutation/SM in mutations)
		override += SM.process_temperature(src, temp, volume)
	if(!override)
		qdel(src)

/obj/structure/vine/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(isvineimmune(mover))
		return TRUE

/proc/isvineimmune(atom/A)
	. = FALSE
	if(isliving(A))
		var/mob/living/M = A
		if((FACTION_VINES in M.faction) || (FACTION_PLANTS in M.faction))
			. = TRUE
