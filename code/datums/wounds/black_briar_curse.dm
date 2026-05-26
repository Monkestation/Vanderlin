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
	overlay_on_skeleton = TRUE
	use_blood_color = FALSE
	can_roll = FALSE

	// the body zones this curse type targets
	var/list/body_zones
	// all of these instances of this in a body
	var/list/datum/weakref/root_network

	var/max_infection = BBC_TIME_MAX_LIMB
	// this goes up every onlife.
	var/infection = 0
	// this is redefined every on-life, it only exists for convenience
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
	if(IsAdminGhost(user))
		var/infection_stage
		switch(infection_percent)
			if(BBC_STAGE_LATE to INFINITY)
				infection_stage = "LATE-STAGE"
			if(BBC_STAGE_MID to BBC_STAGE_LATE)
				infection_stage = "MID-STAGE"
			if(BBC_STAGE_DETECTABLE to BBC_STAGE_MID)
				infection_stage = "DETECTABLE"
			if(-INFINITY to BBC_STAGE_DETECTABLE)
				infection_stage = "LATENT"
		. += " - [span_briar("[PERCENT(infection_percent)]%")]"
		. += " - [span_briar(infection_stage)]"
		. += " - [span_adminnotice("<a href='byond://?src=[REF(owner)];remove_briar=[REF(src)]'>Remove</a>")]"
		return
	if(isobserver(user))
		return
	if(!isliving(user))
		return
	if(infection_percent >= BBC_STAGE_DETECTABLE)
		return
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine) < 30)
		return
	. = null

/datum/wound/black_briar_curse/has_special_infection()
	return infection_percent >= BBC_STAGE_MID

/datum/wound/black_briar_curse/get_check_name(mob/user, advanced)
	if(isobserver(user))
		return ..()
	if(can_examine || infection_percent >= BBC_STAGE_DETECTABLE)
		return ..()
	if(advanced)
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
			O.infection = min(O.infection + O.max_infection * 0.05, O.max_infection)
			remove_immunity(O.owner)
		return FALSE
	return TRUE

/datum/wound/black_briar_curse/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	infection = min(infection, max_infection * BBC_STAGE_DETECTABLE)
	infection_percent = min(infection_percent, BBC_STAGE_DETECTABLE)

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

	progress_infection()
	//basically what we're doing is forcing a multiplicative inverse function to actually land where we want it to on the max pain.
	//so we take the inverse of the function and run our pain against it, which is the second number, and that is our offset from 1
	//if someone ends up tweaking it for balance this will be very annoying to actually understand
	var/woundpain_inverse = (1 - BBC_STAGE_DETECTABLE) / (1 + 65)
	//the pain should roughly start just a little bit after the infection is no longer hidden
	//because we really don't wanna overshoot somehow and get an undefined number we're gonna give a .001 bump
	woundpain = max(0, (1 - BBC_STAGE_DETECTABLE) / (1.001 + woundpain_inverse - infection_percent) - 1)
	//to_chat(owner, "[bodypart_owner.body_zone] - [round(infection / 10)] sec - [round(infection_percent * 100)]%")
	if(infection_percent >= BBC_STAGE_DETECTABLE)
		can_examine = TRUE // Once it's been identified, we'll always know if we have it if it goes back below hidden
	try_sprout()

/datum/wound/black_briar_curse/proc/progress_infection()
	// No, this will not correlate to dungeon or island waits. But it's expensive to check, so we're gonna deal with asynced rate.
	infection = clamp(infection + (rand(20, 25) - GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE)) * SSmobs.wait * 0.1, 0, max_infection)
	infection_percent = min(infection / max_infection, 1)


/datum/wound/black_briar_curse/heal_wound(heal_amount, datum/source, full_heal = FALSE, forced = FALSE)
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

	var/heal_percent = round(heal_amount * 0.01 / 3, 0.005)
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
				bodypart_owner.add_pain(5)
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
	affected.remove_quirk(/datum/quirk/black_briar)

/datum/wound/black_briar_curse/proc/try_sprout()
	if(!owner.has_quirk(/datum/quirk/black_briar) && infection_percent >= BBC_STAGE_LATE)
		if(mob_overlay != infection_overlay)
			mob_overlay = infection_overlay
			bodypart_owner.bodypart_attacked_by(BCLASS_CUT, 50, null, bodypart_owner.body_zone, TRUE, FALSE, list(CRIT_MOD_CHANCE = -100))
			playsound(owner, pick('sound/gore/flesh_eat_01.ogg', 'sound/gore/flesh_eat_02.ogg'), 70, FALSE, -1)
			bodypart_owner.add_pain(20)
			owner.update_damage_overlays()
			bodypart_owner.LoadComponent(/datum/component/cursedrosa)
	else
		var/orig = initial(mob_overlay)
		if(mob_overlay != orig)
			mob_overlay = orig
			owner.update_damage_overlays()
			var/datum/component/comp = bodypart_owner?.GetComponent(/datum/component/cursedrosa)
			if(!QDELETED(comp))
				qdel(comp)

/datum/wound/black_briar_curse/chest
	//show_in_book = FALSE
	body_zones = list(BODY_ZONE_CHEST)
	max_infection = BBC_TIME_MAX
	layer_override = ARMOR_LAYER-0.1
	var/atom/movable/screen/fullscreen/briar/overlay
	COOLDOWN_DECLARE(blossom)
	COOLDOWN_DECLARE(next_limb_infection)
	var/blossoms = 0

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
	if(overlay)
		affected.clear_fullscreen("briar")
		overlay = null
	var/datum/component/comp = affected.GetComponent(/datum/component/cursedrosa)
	if(!QDELETED(comp))
		qdel(comp)

/datum/wound/black_briar_curse/chest/on_life()
	. = ..()
	if(!.)
		return
	owner.adjust_energy(max(0, (GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE) - 20)) * (SSmobs.wait * 0.1) * infection_percent)
	if(infection_percent >= 1)
		if(!HAS_TRAIT(owner, TRAIT_NOPAIN))
			to_chat(owner, span_briar("IT HURTS! IT HURTS!"))
			if(prob(80))
				owner.emote(pick("agony", "painscream", "firescream", "laugh"))
		owner.Paralyze(3 SECONDS, TRUE)
		if(prob(10))
			owner.death()
		return
	if(infection_percent >= BBC_STAGE_LATE)
		owner.apply_status_effect(/datum/status_effect/debuff/black_briar2)
		if(!istype(owner.patron, /datum/patron/alternate/black_briar))
			owner.set_patron(/datum/patron/alternate/black_briar)
	else
		owner.remove_status_effect(/datum/status_effect/debuff/black_briar2)
	if(infection_percent >= BBC_STAGE_MID)
		owner.apply_status_effect(/datum/status_effect/debuff/black_briar1)
		if(prob(6) && !HAS_ANY_OF_TRAITS(owner, list(TRAIT_NOBREATH, TRAIT_SOOTHED_THROAT)))
			cough()
			if(prob(12))
				to_chat(owner, span_warning("[pick("You have a coughing fit!", "You can't stop coughing!")]"))
				var/fit = 0
				for(fit = rand(6,8), fit <= 2.1 SECONDS, fit += rand(5,8))
					addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wound/black_briar_curse/chest, cough)), fit)
				owner.Immobilize(fit)
				owner.Stun(fit)
				if(prob(25))
					owner.drop_all_held_items(FALSE)

		if(!owner.has_quirk(/datum/quirk/black_briar))
			overlay = owner.overlay_fullscreen("briar", /atom/movable/screen/fullscreen/briar, round(lerp(0, 9, (infection_percent - BBC_STAGE_MID) / (1 - BBC_STAGE_MID))))
			if(COOLDOWN_FINISHED(src, next_limb_infection) && prob(3))
				var/list/uninfected_bodyparts = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
				uninfected_bodyparts = shuffle(uninfected_bodyparts - root_network)
				var/mob/living/carbon/C = owner
				var/obj/item/bodypart/BP
				for(var/zone in uninfected_bodyparts)
					BP = C.get_bodypart(zone)
					if(BP?.status == BODYPART_ORGANIC)
						break
					BP = null
				BP?.add_wound(get_black_briar_wound_type(BP?.body_zone), TRUE)
				COOLDOWN_START(src, next_limb_infection, max_infection * BBC_SPREAD_RATE)
	else
		owner.remove_status_effect(/datum/status_effect/debuff/black_briar1)
		var/_emote = pick("yawn", "cough", "clearthroat")
		if(prob(0.5))
			owner.emote(_emote, forced = TRUE)
		if(overlay)
			owner.clear_fullscreen("briar")
			overlay = null

/datum/wound/black_briar_curse/chest/proc/cough()
	owner.emote("sickcough", forced = TRUE)
	var/p = round(max(0, (infection_percent - BBC_STAGE_MID) / (1 - BBC_STAGE_MID)) * 20)
	if(isturf(owner.loc) && prob(p) && owner.add_drip_floor(owner.loc, p))
		owner.visible_message(span_danger("[src] coughs up blood!"), span_danger("I cough up blood!"))

/datum/wound/black_briar_curse/chest/progress_infection()
	..()
	if(infection_percent < BBC_STAGE_LATE)
		return
	if(owner.stat == DEAD)
		return
	var/mob/living/carbon/C = owner
	var/organic_bodyparts = 0
	for(var/obj/item/bodypart/BP in C.bodyparts)
		if(BP.status == BODYPART_ORGANIC)
			organic_bodyparts++
	if(organic_bodyparts > 2)
		var/required_infection = infection_percent >= 1 ? BBC_STAGE_LATE : BBC_STAGE_MID
		var/requirements_met = 0
		for(var/node in root_network)
			var/datum/wound/black_briar_curse/tumor = root_network[node].resolve()
			if(!tumor || tumor == src)
				continue
			if(tumor.infection_percent >= required_infection)
				requirements_met++
		if(requirements_met < 2)
			infection = min(infection, max_infection * (required_infection == BBC_STAGE_MID ? BBC_STAGE_LATE : 1) - 1)
			infection_percent = min(infection / max_infection, 1)

/datum/wound/black_briar_curse/chest/on_death(mob/living/affected, gibbed)
	. = ..()
	if(gibbed)
		return
	if(blossoms > 2)
		return
	if(!COOLDOWN_FINISHED(src, blossom))
		return
	COOLDOWN_START(src, blossom,  rand(5, 10) MINUTES)
	if(!QDELETED(owner.buckled) && istype(owner.buckled, /obj/structure/vine/black_briar)) // we're still a signpost, dwbi and try again in another cooldown
		return
	blossoms++
	if(infection_percent >= BBC_STAGE_MID)
		addtimer(CALLBACK(src, PROC_REF(die_in_agony), owner), 5 SECONDS, (TIMER_UNIQUE|TIMER_DELETE_ME))
		playsound(owner, 'sound/misc/briarcursewood.ogg', 150, FALSE, 1)

/datum/wound/black_briar_curse/chest/proc/die_in_agony(mob/living/affected)
	if(QDELETED(affected))
		return
	var/turf/T = get_turf(affected)
	if(!T)
		return
	if(affected.loc != T)
		affected.forceMove(T)
	if(affected.buckled)
		affected.buckled.unbuckle_mob(affected, TRUE)
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
		tumor.try_sprout()
		if(prob(50))
			tumor.bodypart_owner?.add_embedded_object(new /obj/item/ore/cursedrosa(), TRUE)
	if(!bodypart_owner.skeletonized)
		playsound(affected, 'sound/gore/briarcursegore.ogg', 150, TRUE, 1)
		affected.visible_message(span_danger("Black Briar blossoms from [affected]'s body!"), blind_message=span_danger("I hear the sickening churning of flesh!"))
		affected.spawn_gibs(FALSE)
	var/datum/component/vine_controller/controller = affected.AddComponent(/datum/component/vine_controller, /obj/structure/vine/black_briar, max_vines=15, seconds_to_grow=3, delete_after_growing = TRUE)
	message_admins("BLACK BRIAR at [ADMIN_VERBOSEJMP(T)], caused by [affected.real_name] [ADMIN_PP(affected)]")
	var/obj/structure/vine/black_briar/root_vine = controller.vines[1]
	if(istype(root_vine))
		root_vine.permanent_buckle = TRUE
		root_vine.dir = affected.dir
		root_vine.buckle_mob(affected, TRUE)
	var/obj/item/organ/brain/brain = affected.getorgan(/obj/item/organ/brain)
	brain?.brain_death = TRUE
	affected.LoadComponent(/datum/component/cursedrosa)

/datum/wound/black_briar_curse/head
	show_in_book = FALSE
	body_zones = list(BODY_ZONE_HEAD)
	layer_override = HEAD_LAYER - 0.1
	var/datum/brain_trauma/mild/concussion/concussion
	var/datum/brain_trauma/mild/speech_impediment/impediment

/datum/wound/black_briar_curse/head/on_life()
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/C = owner
	if(infection_percent >= BBC_STAGE_MID)
		if(QDELETED(concussion))
			concussion = C.gain_trauma(/datum/brain_trauma/mild/concussion, TRAUMA_RESILIENCE_ABSOLUTE)
	else if(!QDELETED(concussion))
		qdel(concussion)

	if(infection_percent >= BBC_STAGE_LATE)
		if(QDELETED(impediment))
			impediment = C.gain_trauma(/datum/brain_trauma/mild/speech_impediment, TRAUMA_RESILIENCE_ABSOLUTE)
	else if(!QDELETED(impediment))
		qdel(impediment)

/datum/wound/black_briar_curse/head/on_mob_loss(mob/living/affected)
	if(!QDELETED(concussion))
		qdel(concussion)
	if(!QDELETED(impediment))
		qdel(impediment)
	concussion = null
	impediment = null
	. = ..()

/datum/wound/black_briar_curse/arm
	layer_override = GLOVES_LAYER-0.1
	armdam_override = GLOVESLEEVE_LAYER-0.1
	//show_in_book = FALSE
	body_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

/datum/wound/black_briar_curse/arm/on_life()
	. = ..()
	if(!.)
		return
	if(infection_percent >= BBC_STAGE_LATE ^ disabling) // if these two are synced up, we dont need to call
		disabling = !disabling
		if(bodypart_owner.can_be_disabled)
			bodypart_owner.update_disabled()


/datum/wound/black_briar_curse/leg
	layer_override = SHOES_LAYER-0.1
	legdam_override = SHOESLEEVE_LAYER-0.1
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
		if(other?.infection_percent >= 1 && infection_percent >= 1 && !HAS_TRAIT(owner, TRAIT_NO_IMMOBILIZE))
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
