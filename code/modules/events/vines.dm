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
			var/obj/structure/flora/tree/evil/root = new(T)
			root.AddComponent(/datum/component/vine_controller, event = src) //spawn a controller component

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
		if(iscarbon(M))
			var/mob/living/carbon/H = M
			var/obj/item/bodypart/l_leg/left = H.get_bodypart(BODY_ZONE_L_LEG)
			var/obj/item/bodypart/r_leg/right = H.get_bodypart(BODY_ZONE_R_LEG)
			if(prob(50))
				left.bodypart_attacked_by(BCLASS_CUT, 6)
			else
				right.bodypart_attacked_by(BCLASS_CUT, 6)
		else
			M.adjustBruteLoss(5)
		to_chat(M, "<span class='alert'>I cut myself on the thorny vines.</span>")

/datum/vine_mutation/thorns/on_hit(obj/structure/vine/holder, mob/living/hitter, obj/item/I, expected_damage)
	if(prob(severity) && istype(hitter) && !isvineimmune(holder))
		var/mob/living/M = hitter
		if(iscarbon(M))
			var/mob/living/carbon/H = M
			var/obj/item/bodypart/arm = H.get_active_hand()
			arm.bodypart_attacked_by(BCLASS_CUT, 6)
		else
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
	base_icon_state = ""
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
	var/max_energy = 2
	var/list/mutations = list()
	break_sound = "plantcross"
	destroy_sound = null
	attacked_sound = 'sound/misc/woodhit.ogg'
	var/current_state = "Light"
	/// how many icon states does this have per growth level?
	var/variance = 2

/obj/structure/vine/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	add_atom_colour("#ffffff", FIXED_COLOUR_PRIORITY)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/vine/Destroy()
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_death(src)
	mutations = list()
	set_opacity(0)
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	return ..()

/obj/structure/vine/update_icon_state()
	. = ..()
	if(energy < 0)
		icon_state = "[current_state]d"
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		set_opacity(0)
		return
	var/num_state = max(1, rand(1, variance))
	switch(energy)
		if(0)
			current_state = "Light[num_state]"
			set_opacity(0)
		if(1)
			current_state = "Med[num_state]"
			set_opacity(0)
		else
			current_state = "Hvy[num_state]"
			set_opacity(1)
	icon_state = "[base_icon_state][current_state]"

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

/obj/structure/vine/Crossed(mob/crosser)
	. = ..()
	if(crosser.m_intent != MOVE_INTENT_SNEAK)
		playsound(src,'sound/items/seedextract.ogg', 80, TRUE, -1)
	if(isliving(crosser))
		for(var/datum/vine_mutation/SM in mutations)
			SM.on_cross(src, crosser)
	if(prob(23) && istype(crosser) && !isvineimmune(crosser))
		var/mob/living/M = crosser
		if(iscarbon(M))
			var/mob/living/carbon/H = M
			var/obj/item/bodypart/l_leg/left = H.get_bodypart(BODY_ZONE_L_LEG)
			var/obj/item/bodypart/r_leg/right = H.get_bodypart(BODY_ZONE_R_LEG)
			if(prob(50))
				left.bodypart_attacked_by(BCLASS_CUT, 6)
			else
				right.bodypart_attacked_by(BCLASS_CUT, 6)
		else
			M.adjustBruteLoss(5)
		to_chat(M, span_warning("I nick myself on the thorny vines."))

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/vine/attack_hand(mob/user)
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_hit(src, user)
	. = ..()

/obj/structure/vine/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/vine/proc/dieepic()
	energy = -1
	modify_max_integrity(1, can_break = FALSE)
	update_integrity(1)
	destroy_sound = 'sound/foley/breaksound.ogg'
	update_appearance(UPDATE_ICON_STATE)
	unbuckle_all_mobs(TRUE)

/obj/structure/vine/proc/grow()
	if(energy < 0)
		return
	energy = min(energy + 1, max_energy)
	update_appearance(UPDATE_ICON_STATE)
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_grow(src)

/obj/structure/vine/proc/entangle_mob()
	if(has_buckled_mobs() || prob(75))
		return
	for(var/mob/living/V in get_turf(src))
		entangle(V)
		if(has_buckled_mobs())
			break //only capture one mob at a time

/obj/structure/vine/proc/entangle(mob/living/V)
	if(!V || isvineimmune(V))
		return
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_buckle(src, V)
	if((V.stat != DEAD) && (V.buckled != src)) //not dead or captured
		to_chat(V, span_danger("The vines [pick("wind", "tangle", "tighten")] around me!"))
		buckle_mob(V, 1)
	V.adjustOxyLoss(10)

/obj/structure/vine/proc/find_spread()
	var/direction = pick(GLOB.cardinals)
	var/turf/stepturf = get_step(src,direction)
	if(!stepturf.Enter(src))
		return
	for(var/datum/vine_mutation/SM in mutations)
		SM.on_spread(src, stepturf)
		stepturf = get_step(src,direction) //in case turf changes, to make sure no runtimes happen
	if(!locate(/obj/structure/vine, stepturf))
		return stepturf

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

/obj/structure/vine/black_briar
	name = "\proper black briar"
	desc = span_briar("Some victories come at a horrible price.")
	icon_state = "BriarLight1"
	base_icon_state = "Briar"
	buckle_prevents_pull = TRUE
	buckle_lying = STANDING_UP
	var/permanent_buckle = FALSE
	variance = 1
	max_energy = 1

	max_integrity = 300
	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 15, "slash" = 15, "stab" = 15,  "piercing" = 15, "fire" = 15, "acid" = 0)
	attacked_sound = list('sound/combat/hits/armor/chain_slashed (1).ogg', 'sound/combat/hits/armor/chain_slashed (2).ogg', 'sound/combat/hits/armor/chain_slashed (3).ogg')

/obj/structure/vine/black_briar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursedrosa, TRUE, TRUE)

/obj/structure/vine/black_briar/unbuckle_mob(mob/living/buckled_mob, force, can_fall)
	if(!permanent_buckle || force)
		. = ..()

/obj/structure/vine/black_briar/dieepic()
	. = ..()
	var/comp = GetComponent(/datum/component/cursedrosa)
	if(comp)
		qdel(comp)

/proc/isvineimmune(atom/A)
	. = FALSE
	if(isliving(A))
		var/mob/living/M = A
		if((FACTION_VINES in M.faction) || (FACTION_PLANTS in M.faction) || HAS_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY))
			. = TRUE
