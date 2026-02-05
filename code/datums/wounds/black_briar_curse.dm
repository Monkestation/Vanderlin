// carbons only! this shit is mostly about limbs
/datum/wound/black_briar_curse
	abstract_type = (/datum/wound/black_briar_curse)

	category = "Disease"
	name = "umbrosal cordycepsis"
	desc = "Commonly referred to as the Black Briar curse."
	check_name = "<span class='briar'><B>BLACK BRIAR</B></span>"

	severity = WOUND_SEVERITY_BIOHAZARD
	sleep_healing = 0
	bleed_rate = null
	whp = null
	mob_overlay = null

	// the body zones this curse type targets
	var/list/body_zones
	// all of these instances of this in a body
	var/list/root_network

	var/max_infection = BBC_TIME_MAX_LIMB
	// this goes up every onlife. once the total reaches 30 MINUTES, you are dead. non-root infection contributes to the root, nasty.
	var/infection = 0
	var/infection_percent = 0
	// used to skip rebuilds when they're unnecessary
	var/can_rebuild = TRUE

	var/can_examine = FALSE
	var/infection_overlay = "briar"

/datum/wound/black_briar_curse/Destroy(force)
	. = ..()
	LAZYNULL(root_network)

/datum/wound/black_briar_curse/get_visible_name(mob/user)
	. = ..()
	if(isobserver(user))
		return
	if(!isliving(user))
		return
	if(infection_percent >= BBC_STAGE_DETECTABLE)
		return
	var/mob/living/L = user
	if(L.skills && L.get_skill_level(/datum/skill/misc/medicine) > 3)
		return
	. = null

/datum/wound/black_briar_curse/has_special_infection()
	return infection_percent >= BBC_STAGE_MID

/datum/wound/black_briar_curse/get_check_name(mob/user, advanced)
	if(isobserver(user))
		return ..()
	if(advanced || can_examine || infection_percent >= BBC_STAGE_DETECTABLE)
		return ..()

/datum/wound/black_briar_curse/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(!(affected.body_zone in body_zones))
		return FALSE
	if(affected.status != BODYPART_ORGANIC)
		return FALSE

/datum/wound/black_briar_curse/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!. || !iscarbon(affected))
		return FALSE
	var/mob/living/carbon/C = affected
	if(NOBLOOD in C.dna?.species?.species_traits)
		return FALSE
	if(is_species(C, /datum/species/werewolf) || C.mind?.has_antag_datum(/datum/antagonist/werewolf)) // Dendor protects
		return FALSE
	if(C.mind?.has_antag_datum(/datum/antagonist/vampire) || C.mind?.has_antag_datum(/datum/antagonist/zombie)) // weird/gross blood = cant live in it
		return FALSE
	if(HAS_TRAIT(affected, TRAIT_TOXIMMUNE))
		return FALSE
	return C.getorganslot(ORGAN_SLOT_LUNGS)

/datum/wound/black_briar_curse/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/black_briar_curse))
		if(!(src in GLOB.primordial_wounds)) //idk why someone would be using these this way but i'd prefer not to build up its infection
			var/datum/wound/black_briar_curse/O = other
			O.infection = min(O.infection + O.max_infection * 0.01, O.max_infection)
			remove_immunity(O.owner)
		return FALSE
	return TRUE

/datum/wound/black_briar_curse/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	infection = min(infection, max_infection * BBC_STAGE_DETECTABLE)
	infection_percent = min(infection_percent, BBC_STAGE_DETECTABLE)
	if(affected.owner && HAS_TRAIT(affected.owner, TRAIT_NO_BRIAR_DEATH))
		max_infection = 1
		infection = 1
		infection_percent = 1

/datum/wound/black_briar_curse/on_mob_gain(mob/living/affected)
	. = ..()
	// you'd think we would want this in bodypart_gain but this calls last in all the procs so it won't screw things up
	if(bodypart_owner?.body_zone != BODY_ZONE_CHEST)
		var/obj/item/bodypart/chest/chest = owner.get_bodypart()
		if(istype(chest) && !chest.has_wound(/datum/wound/black_briar_curse/chest)) // we just got added and there's no root? let's make a chest wound instead.
			can_rebuild = FALSE
			var/datum/wound/black_briar_curse/chest/wound = chest.add_wound(/datum/wound/black_briar_curse/chest, TRUE)
			wound?.infection = min(infection, wound.max_infection * BBC_STAGE_DETECTABLE)
			wound?.infection_percent = min(infection_percent, BBC_STAGE_DETECTABLE)
			qdel(src)
			return
		remove_immunity(affected) // if we're just a new wound, delete that shit
	can_rebuild = TRUE
	rebuild_root_network(affected)

/datum/wound/black_briar_curse/on_mob_loss(mob/living/affected)
	. = ..()
	rebuild_root_network(affected)

/datum/wound/black_briar_curse/on_life()
	//death comsig can fuck this all up
	if(QDELETED(owner) || QDELETED(bodypart_owner) || QDELETED(src))
		return FALSE
	. = ..()
	// No, this will not correlate to dungeon or island waits. But it's expensive to check, so we're gonna deal with asynced rate.
	infection = clamp(infection + (rand(20, 24) + length(root_network) - owner.STAEND) * (SSmobs.wait * 0.1) , 0, max_infection)
	if(length(root_network) < 2 && !HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH)) // we can't get worse without a limb being infected
		infection = min(infection, max_infection * BBC_STAGE_LATE - 1)
	infection_percent = min(infection / max_infection, 1)

	//basically what we're doing is forcing a multiplicative inverse function to actually land where we want it to on the max pain.
	//so we take the inverse of the function and run our pain against it, which is the second number, and that is our offset from 1
	//if someone ends up tweaking it for balance this will be very annoying to actually understand
	var/woundpain_inverse = (1 - BBC_STAGE_DETECTABLE) / (1 + 60)
	//the pain should roughly start just a little bit after the infection is no longer hidden
	//because we really don't wanna overshoot somehow and get an undefined number we're gonna give a .001 bump
	woundpain = max(0, (1 - BBC_STAGE_DETECTABLE) / (1.001 + woundpain_inverse - infection_percent) - 1)
	//to_chat(owner, "[bodypart_owner.body_zone] - [round(infection / 10)] sec - [round(infection_percent * 100)]%")
	if(infection_percent >= BBC_STAGE_DETECTABLE)
		can_examine = TRUE // Once it's been identified, we'll always know if we have it if it goes back below hidden
	update_appearance()

/datum/wound/black_briar_curse/heal_wound(heal_amount, datum/source, full_heal = FALSE)
	if(full_heal)
		return ..()
	if(infection_percent >= 1)
		return FALSE
	if(!istype(source, /datum/action/cooldown/spell/healing))
		return FALSE
	var/datum/action/cooldown/spell/healing/miracle = source
	if(!isliving(miracle.owner))
		return FALSE
	var/mob/living/caster = miracle.owner

	var/heal_percent = round(heal_amount * 0.01 / 2, 0.005)
	var/old_infection_percent = 0
	switch(caster.patron?.type)
		if(/datum/patron/divine/malum)
			infection_percent = min(1, infection_percent + heal_percent)
			if(can_examine)
				owner.visible_message(span_danger("The briar gets worse!"), span_briar("I feel thorns digging into me!")) //don't heal as malum, he likes this shit
			if(!HAS_TRAIT(owner, TRAIT_NOPAIN))
				if(infection_percent >= BBC_STAGE_LATE && prob(30))
					owner.emote("firescream")
				else if(infection_percent >= BBC_STAGE_MID && prob(50))
					owner.emote("agony")
				bodypart_owner.lingering_pain += 5
		if(/datum/patron/divine/dendor, /datum/patron/divine/pestra)
			var/infection_min = 0
			var/list/stages = list(BBC_STAGE_MID, BBC_STAGE_LATE, 1)
			for(var/i = length(stages), i > 0, i--)
				if(infection_percent - stages[i] >= 0)
					infection_min = stages[i]
					break
			infection_percent = max(infection_min, infection_percent - heal_percent)
			if(can_examine && (!infection_min || infection_percent - infection_min > heal_percent / 4))
				owner.visible_message(span_green("It seems to retract the briar!"), span_green("I feel the briar retracting!"))
		else
			return FALSE
	infection = infection_percent * max_infection
	if(infection <= 0)
		whp = 0
		..()
	return round(heal_amount * abs((old_infection_percent - infection_percent) / heal_percent), DAMAGE_PRECISION)


/datum/wound/black_briar_curse/proc/rebuild_root_network(mob/living/affected)
	if(!can_rebuild)
		return
	var/list/new_roots
	var/list/networked_tumors = list()
	for(var/datum/wound/black_briar_curse/tumor in affected.get_wounds())
		var/obj/item/bodypart/bp = tumor.bodypart_owner
		if(bp?.body_zone) // each tumor tries to grab its body zone
			var/datum/weakref/tumor_ref = LAZYACCESS(tumor.root_network, bp.body_zone)
			if(!tumor_ref?.resolve())
				tumor_ref = WEAKREF(tumor)
			LAZYSET(new_roots, tumor.bodypart_owner.body_zone, tumor_ref)
			networked_tumors += tumor
		LAZYNULL(tumor.root_network)
	for(var/datum/wound/black_briar_curse/tumor in networked_tumors)
		tumor.root_network = new_roots.Copy()

/// somehow you've triggered your immunity to get lost, like getting more stacks added to you
/datum/wound/black_briar_curse/proc/remove_immunity(mob/living/affected)
	var/list/was_immune = GET_TRAIT_SOURCES(affected, TRAIT_BLACK_BRIAR)
	if(was_immune)
		REMOVE_TRAIT(affected, TRAIT_BLACK_BRIAR, was_immune)

/datum/wound/black_briar_curse/proc/update_appearance()
	if(infection_percent >= BBC_STAGE_LATE)
		if(mob_overlay != infection_overlay)
			mob_overlay = infection_overlay
			bodypart_owner.bodypart_attacked_by(BCLASS_CUT, 50, null, bodypart_owner.body_zone, TRUE, FALSE, 1000)
			playsound(owner, pick('sound/gore/flesh_eat_01.ogg', 'sound/gore/flesh_eat_02.ogg'), 70, FALSE, -1)
			bodypart_owner.lingering_pain += 20
			owner.update_damage_overlays()
	else
		var/orig = initial(mob_overlay)
		if(mob_overlay != orig)
			mob_overlay = orig
			owner.update_damage_overlays()

/datum/wound/black_briar_curse/chest
	//show_in_book = FALSE
	body_zones = list(BODY_ZONE_CHEST)
	max_infection = BBC_TIME_MAX
	// when it can try and infect a limb again, world.time + BBC_SPREAD_COOLDOWN
	var/next_limb_infection = 0
	var/dying = FALSE

/datum/wound/black_briar_curse/chest/on_mob_gain(mob/living/affected)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/wound/black_briar_curse/chest/on_mob_loss(mob/living/affected)
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	can_rebuild = FALSE
	for(var/datum/wound/black_briar_curse/tumor in affected.get_wounds()) // killed it at the source, we can kill the others too
		if(tumor != src)
			tumor.can_rebuild = FALSE
			qdel(tumor)
	affected.remove_status_effect(/datum/status_effect/debuff/black_briar1)
	affected.remove_status_effect(/datum/status_effect/debuff/black_briar2)

/datum/wound/black_briar_curse/chest/on_life()
	. = ..()
	if(!.)
		return
	if(!HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH))
		owner.adjust_energy((owner.STAEND - 20) * (SSmobs.wait * 0.1) * infection_percent)
	if(infection_percent >= 1 && !HAS_TRAIT(owner, TRAIT_NODEATH) && !HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH))
		if(!HAS_TRAIT(owner, TRAIT_NOPAIN))
			to_chat(owner, span_briar("IT HURTS! IT HURTS!"))
			if(prob(80))
				owner.emote(pick("agony", "firescream"))
		if(prob(10))
			owner.death()
		owner.Paralyze(3 SECONDS, TRUE)
		return
	if(infection_percent >= BBC_STAGE_LATE)
		owner.apply_status_effect(/datum/status_effect/debuff/black_briar2)
	else
		owner.remove_status_effect(/datum/status_effect/debuff/black_briar2)
	if(infection_percent >= BBC_STAGE_MID)
		owner.apply_status_effect(/datum/status_effect/debuff/black_briar1)
		if(!HAS_TRAIT(owner, TRAIT_BLACK_BRIAR) && world.time > next_limb_infection && prob(4))
			var/list/uninfected_bodyparts = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			uninfected_bodyparts -= root_network
			var/mob/living/carbon/C = owner
			var/obj/item/bodypart/BP = C.get_bodypart_complex(uninfected_bodyparts)
			var/wound_type = get_black_briar_wound_type(BP?.body_zone)
			if(wound_type)
				BP.add_wound(wound_type, TRUE)
			next_limb_infection = world.time + max_infection * BBC_STAGE_DETECTABLE
	else
		owner.remove_status_effect(/datum/status_effect/debuff/black_briar1)
		var/_emote = pick("yawn", "cough", "clearthroat")
		if(prob(0.5))
			owner.emote(_emote, forced = TRUE)

/datum/wound/black_briar_curse/chest/on_death(mob/living/affected, gibbed)
	. = ..()
	if(dying || gibbed)
		return
	if(infection_percent >= BBC_STAGE_MID)
		addtimer(CALLBACK(src, PROC_REF(die_in_agony), affected), 5 SECONDS, (TIMER_UNIQUE|TIMER_DELETE_ME))
		playsound(owner, 'sound/misc/briarcursewood.ogg', 100, FALSE, 1)
	dying = TRUE

/datum/wound/black_briar_curse/chest/proc/die_in_agony(mob/living/affected, silent=FALSE)
	if(!affected)
		return
	var/turf/T = get_turf(affected)
	if(!T)
		return
	if(affected.loc != T)
		affected.forceMove(T)
	var/list/uninfected_zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG) - root_network
	for(var/zone in uninfected_zones)
		var/wound_type = get_black_briar_wound_type(zone)
		var/obj/item/bodypart/BP = affected.get_bodypart(zone)
		BP?.add_wound(wound_type, TRUE)
	for(var/zone in root_network)
		var/datum/weakref/wound_ref = root_network[zone]
		var/datum/wound/black_briar_curse/tumor = wound_ref.resolve()
		if(!tumor)
			continue
		tumor.infection = tumor.max_infection
		tumor.infection_percent = 1
		tumor.update_appearance()
		if(prob(25))
			tumor.bodypart_owner?.add_embedded_object(new /obj/item/ore/cursedrosa(), TRUE)
	affected.spawn_gibs(FALSE)
	var/datum/component/vine_controller/controller = affected.AddComponent(/datum/component/vine_controller, /obj/structure/vine/black_briar, max_vines=12, seconds_to_grow=3, delete_after_growing = TRUE)
	if(!silent)
		playsound(affected, 'sound/gore/briarcursegore.ogg', 150, TRUE, 1)
		affected.visible_message(span_danger("Briars burst from [affected]'s flesh!"), blind_message=span_danger("I hear the sickening churning of flesh!"))
		message_admins("BLACK BRIAR at [ADMIN_VERBOSEJMP(T)], caused by [affected]'s death [ADMIN_PP(affected)]")
	var/obj/structure/vine/black_briar/root_vine = controller.vines[1]
	if(istype(root_vine))
		root_vine.permanent_buckle = TRUE
		root_vine.dir = affected.dir
		root_vine.buckle_mob(affected, TRUE)
	var/obj/item/organ/brain/brain = affected.getorgan(/obj/item/organ/brain)
	var/obj/item/organ/eyes/eyes = affected.getorganslot(ORGAN_SLOT_EYES)
	var/obj/item/organ/lungs/lungs = affected.getorganslot(ORGAN_SLOT_LUNGS)
	brain?.brain_death = TRUE
	if(eyes)
		qdel(eyes)
	if(lungs)
		qdel(lungs)

/datum/wound/black_briar_curse/head
	show_in_book = FALSE
	body_zones = list(BODY_ZONE_HEAD)
	var/insane = FALSE

/datum/wound/black_briar_curse/head/on_life()
	. = ..()
	if(!.)
		return
	if(infection_percent >= BBC_STAGE_LATE ^ insane) // this flips if these dont match up
		owner.refresh_looping_ambience()
		insane = !insane
	if(insane && prob((owner.ckey ? 1 : 15)))
		owner.emote(pick("laugh", "agony", "firescream"))
	if(HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH))
		return
	if(infection_percent >= BBC_STAGE_DETECTABLE && prob(3 * infection_percent))
		owner.set_eye_blur_if_lower(rand(3, 6) SECONDS)
		owner.stuttering = max(owner.stuttering, 10)

/datum/wound/black_briar_curse/arm
	//show_in_book = FALSE
	body_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

/datum/wound/black_briar_curse/arm/on_life()
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH))
		return
	if(infection_percent >= BBC_STAGE_LATE ^ disabling) // if these two are synced up, we dont need to call
		disabling = !disabling
		if(bodypart_owner.can_be_disabled)
			bodypart_owner.update_disabled()


/datum/wound/black_briar_curse/leg
	//show_in_book = FALSE
	body_zones = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	// used for left and rights.
	var/specific_zone
	//prevents redundant calls on second leg
	var/too_slow = FALSE

/datum/wound/black_briar_curse/leg/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	specific_zone = affected.body_zone

/datum/wound/black_briar_curse/leg/on_mob_loss(mob/living/affected)
	. = ..()
	var/datum/wound/black_briar_curse/leg/other
	if(!too_slow)
		var/datum/weakref/WR = LAZYACCESS(root_network, specific_zone == BODY_ZONE_L_LEG ? BODY_ZONE_R_LEG : BODY_ZONE_L_LEG)
		other = WR?.resolve()
		other?.too_slow = TRUE
		REMOVE_TRAIT(affected, TRAIT_IMMOBILIZED, "[type]")
	affected.remove_movespeed_modifier("[MOVESPEED_ID_BLACK_BRIAR]_[specific_zone]", (!other == TRUE))
	too_slow = FALSE

/datum/wound/black_briar_curse/leg/on_life()
	. = ..()
	if(!.)
		return
	var/datum/wound/black_briar_curse/leg/other
	if(!too_slow)
		var/datum/weakref/WR = LAZYACCESS(root_network, specific_zone == BODY_ZONE_L_LEG ? BODY_ZONE_R_LEG : BODY_ZONE_L_LEG)
		other = WR?.resolve()
		other?.too_slow = TRUE
		var/immobilizing = HAS_TRAIT_FROM(owner, TRAIT_IMMOBILIZED, "[type]")
		if(!HAS_TRAIT(owner, TRAIT_NO_BRIAR_DEATH) && other?.infection_percent >= 1 && infection_percent >= 1 && !HAS_TRAIT(owner, TRAIT_NO_IMMOBILIZE))
			if(!immobilizing)
				ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "[type]")
		else if(immobilizing)
			REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "[type]")
	//only the second leg updates on these if they exist
	owner.add_movespeed_modifier("[MOVESPEED_ID_BLACK_BRIAR]_[specific_zone]", (!other == TRUE), multiplicative_slowdown = infection_percent, override = TRUE)
	too_slow = FALSE

/proc/get_black_briar_wound_type(def_zone)
	switch(def_zone)
		if(BODY_ZONE_HEAD)
			return /datum/wound/black_briar_curse/head
		if(BODY_ZONE_CHEST)
			return /datum/wound/black_briar_curse/chest
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return /datum/wound/black_briar_curse/arm
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return /datum/wound/black_briar_curse/leg
