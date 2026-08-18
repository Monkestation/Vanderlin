GLOBAL_LIST_EMPTY(broodmother_eggs)

#define BIOMASS_TIER_1 "tier_1"
#define BIOMASS_TIER_2 "tier_2"
#define BIOMASS_TIER_3 "tier_3"

#define BIOMASS_TIER_1_COST 25
#define BIOMASS_TIER_2_COST 50
#define BIOMASS_TIER_3_COST 90

#define BIOMASS_MAX_AMOUNT 100
#define BIOMASS_MIN_AMOUNT 0

#define FRENZY_DURATION 60 SECONDS
#define FRENZY_COOLDOWN 5 MINUTES

/area/broodmother_den
	name = "Broodmothers Den"

/mob/living/simple_animal/hostile/retaliate/troll/broodmother
	name = "Broodmother"
	desc = "Once, Eora gifted to Graggar the Luxus Pragmas and told him to make a female companion with it.\
			He was supposed to make a beautiful and courageous wife from it, is what Eora had hoped he would do.\
			Instead, Graggar created this."
	icon = 'icons/mob/creacher/trolls/broodmother.dmi'
	icon_state = "broodmother"
	gender = FEMALE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	SET_BASE_PIXEL(-38, -8)
	hud_type = /datum/hud/broodmother
	icon_dead = "broodmother_dead"
	icon_living = "broodmother"

	var/tier_1_biomass_amount = 25
	var/tier_2_biomass_amount = 10
	var/tier_3_biomass_amount = 5

	var/tier_1_biomass_cost = BIOMASS_TIER_1_COST
	var/tier_2_biomass_cost = BIOMASS_TIER_2_COST
	var/tier_3_biomass_cost = BIOMASS_TIER_3_COST

	var/frenzy_ready = TRUE

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/death(gibbed)
	frenzy_off()
	. = ..()
	new /obj/item/reagent_containers/lux/pragmas (get_turf(src))

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/Initialize()
	. = ..()

	ADD_TRAIT(src, TRAIT_BROOD, INNATE_TRAIT)
	add_spell(/datum/action/cooldown/spell/projectile/acid_splash_broodmother)
	add_spell(/datum/action/cooldown/spell/stone_throw)
	add_spell(/datum/action/cooldown/mob_cooldown/earth_quake)
	add_spell(/datum/action/cooldown/spell/broodmother_hole)
	add_spell(/datum/action/cooldown/spell/stone_drop)

	grant_language(/datum/language/common)
	grant_language(/datum/language/orcish)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/help_blurb()
	to_chat(
		src,
		span_notice("\
			earth quake flings enemies around you away\
			\n\n\
			frenzy makes you faster on a cooldown\
			\n\n\
			rock throw throws an explosive rock\
			\n\n\
			middle click to butcher corpses and eat food.\
			\n\n\
			top left is your biomass, with this you can lay eggs, click the bars to see more info.\
			\n\n\
			you can command your children with generic commands like: \"follow\", \"attack\", \"halt\"\
			\n\n\
			good luck!\
			"\
		)
	)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/death(gibbed)
	icon_state = initial(icon_state)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/frenzy_on()
	if(!frenzy_ready)
		to_chat(src, span_danger("Not ready!"))
		return FALSE

	frenzy_ready = FALSE
	icon_state = "broodmother_frenzy"
	add_filter("frenzy_rays", 20, rays_filter(size = 80, color = "#c21a03"))
	playsound(src, 'sound/misc/gods/astrata_omen.ogg', 80, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, frequency = 32000)
	animate(src, time = 0.15 SECONDS, pixel_w = rand(10, 15) * pick(1, -1), pixel_z = rand(10, 20) * pick(1, -1), transform = src.transform.Turn(rand(10, 20)), easing = BOUNCE_EASING)
	animate(time = 0.15 SECONDS, pixel_w = -rand(10, 20) * pick(1, -1), pixel_z = rand(10, 20) * pick(1, -1), transform = initial(src.transform):Turn(-rand(10, 20)), easing = BOUNCE_EASING)
	animate(time = 0.2 SECONDS, pixel_w = 0, pixel_z = 0, transform = initial(src.transform), easing = BOUNCE_EASING)
	add_movespeed_modifier(MOVESPEED_ID_FRENZY, priority = 1, override = TRUE, multiplicative_slowdown = -2)
	addtimer(CALLBACK(src, PROC_REF(frenzy_off)), FRENZY_DURATION)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/make_frenzy_ready()
	to_chat(src, span_bignotice("Frenzy ready!"))
	frenzy_ready = TRUE

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/frenzy_off()
	remove_filter("frenzy_rays")
	remove_movespeed_modifier(MOVESPEED_ID_FRENZY)
	addtimer(CALLBACK(src, PROC_REF(make_frenzy_ready), FRENZY_COOLDOWN))

/datum/action/toggle_frenzy
	name = "Toggle Frenzy"
	var/state = FALSE

/datum/action/toggle_frenzy/Trigger(trigger_flags)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/troll/broodmother/mother = owner
	mother.frenzy_on()

/datum/action/cooldown/spell/projectile/acid_splash_broodmother
	name = "Acid Vomit"
	desc = "A slow-moving glob of acid that sprays over an area upon impact."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'

	required_form = null

	charge_time = 3 SECONDS
	charge_slowdown = 0.7
	cooldown_time = 30 SECONDS
	projectile_type = /obj/projectile/magic/acidsplash

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/adjust_biomass(tier, amount)
	switch(tier)
		if(1)
			if((tier_1_biomass_amount + amount) < BIOMASS_MIN_AMOUNT)
				return FALSE
		if(2)
			if((tier_2_biomass_amount + amount) < BIOMASS_MIN_AMOUNT)
				return FALSE
		if(3)
			if((tier_3_biomass_amount + amount) < BIOMASS_MIN_AMOUNT)
				return FALSE

	_adjust_biomass(arglist(args))
	return TRUE

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/_adjust_biomass(tier, amount)
	var/end_amount
	switch(tier)
		if(1)
			end_amount = clamp(tier_1_biomass_amount + amount, BIOMASS_MIN_AMOUNT, BIOMASS_MAX_AMOUNT)
			tier_1_biomass_amount = end_amount
		if(2)
			end_amount = clamp(tier_2_biomass_amount + amount, BIOMASS_MIN_AMOUNT, BIOMASS_MAX_AMOUNT)
			tier_2_biomass_amount = end_amount
		if(3)
			end_amount = clamp(tier_3_biomass_amount + amount, BIOMASS_MIN_AMOUNT, BIOMASS_MAX_AMOUNT)
			tier_3_biomass_amount = end_amount

	SEND_SIGNAL(src, COMSIG_BROODMOTHER_BIOMASS_CHANGE, end_amount, tier)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/get_biomass_amounts()
	return list(
		tier_1_biomass_amount,
		tier_2_biomass_amount,
		tier_3_biomass_amount,
		)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/attempt_lay_egg(tier, obj/structure/broodmother_egg/override)
	if(!tier)
		stack_trace("didn't pass tier for egg")
	if(!egg_laying_checks(tier))
		return

	lay_egg(tier, override)

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/egg_laying_checks(tier)
	var/check = tier
	switch(tier)
		if(1)
			check = tier_1_biomass_cost
		if(2)
			check = tier_2_biomass_cost
		if(3)
			check = tier_3_biomass_cost

	return (vars["tier_[tier]_biomass_amount"] >= check) ? TRUE : FALSE // gaming

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/proc/lay_egg(tier, obj/structure/broodmother_egg/override)
	var/egg_to_lay
	switch(tier)
		if(1)
			egg_to_lay = /obj/structure/broodmother_egg/goblin
			adjust_biomass(tier, -tier_1_biomass_cost)
		if(2)
			egg_to_lay = /obj/structure/broodmother_egg/orc
			adjust_biomass(tier, -tier_2_biomass_cost)
		if(3)
			egg_to_lay = /obj/structure/broodmother_egg/troll
			adjust_biomass(tier, -tier_3_biomass_cost)

	if(override)
		egg_to_lay = override

	var/obj/structure/broodmother_egg/made_egg = new egg_to_lay(get_turf(src))
	made_egg.mother_weak_ref = WEAKREF(src)
	to_chat(src, span_notice("you lay \a [made_egg]."))

/mob/living/simple_animal/hostile/retaliate/troll/broodmother/eat_food(obj/item/reagent_containers/food/snacks/eaten)
	. = ..()
	if(!.)
		return

	var/nutriments = .
	adjust_biomass(1, round(nutriments / 50, 0.1))
	adjust_biomass(2, round(nutriments / 150, 0.1))
	adjust_biomass(3, round(nutriments / 500, 0.1))

///this whole proc is fucking ass holy
/mob/living/simple_animal/hostile/retaliate/troll/broodmother/MiddleClickOn(atom/A, list/modifiers) // it's so bad :sob: I'm so sorry
	. = ..()
	if(isanimal(A))
		var/mob/living/simple_animal/animal = A
		if(!animal.is_dead())
			return
		if(do_after(src, 3 SECONDS, animal))
			animal.butcher(src)
			return TRUE
	else if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(!C.is_dead())
			return
		var/obj/item/bodypart/limb
		var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		for(var/zone in limb_list)
			limb = C.get_bodypart(zone)
			if(limb)
				limb.dismember()
				return TRUE
		limb = C.get_bodypart(BODY_ZONE_HEAD)
		if(limb)
			limb.dismember()
			return
		limb = C.get_bodypart(BODY_ZONE_CHEST)
		if(limb)
			if(!limb.dismember())
				C.gib()
	else if(isorgan(A))
		var/obj/item/organ/organ = A
		var/turf/organ_turf = get_turf(organ)
		var/obj/item/reagent_containers/food/snacks/S = organ.prepare_eat(src)
		if(S)
			S.forceMove(organ_turf)
			eat_food(S)
			eat_food_after(S)
	else if(issnack(A))
		var/obj/item/reagent_containers/food/snacks/S = A
		eat_food(S)
		eat_food_after(S)

/obj/structure/broodmother_egg
	name = "egg"
	desc = "An egg..."
	abstract_type = /obj/structure/broodmother_egg
	icon = 'icons/obj/broodmother_32x.dmi'
	///name that shows in the hud on hover
	var/hud_name = ""
	var/hatched = FALSE
	var/hatch_time = 60 SECONDS
	var/type_to_spawn
	var/time_before_first_crack = 30 SECONDS
	var/cracking_speed = 6 SECONDS
	///if we wait until a possession happens for hatching
	var/possessed_only = FALSE
	var/datum/weakref/mother_weak_ref
	/// Whitelist vessel ID ghosts get polled against for this egg's occupant
	var/vessel_id
	/// If TRUE, the egg hatches the instant a ghost possesses the resident vessel,
	/// ignoring hatch_time/cracking entirely. Used for mapper-placed broodmother eggs.
	var/hatch_on_possess = FALSE
	/// The living mob quietly gestating inside this egg, waiting on a ghost
	var/mob/living/resident_mob
	///are we ready to hatch?
	var/ready_to_hatch = FALSE
	///maploaded vessel
	var/maploaded_vessel = TRUE

/obj/structure/broodmother_egg/Initialize()
	. = ..()
	if(maploaded_vessel)
		spawn_resident_vessel()
	if(hatch_on_possess)
		return
	addtimer(CALLBACK(src, PROC_REF(hatch)), hatch_time)
	addtimer(CALLBACK(src, PROC_REF(crack)), time_before_first_crack)

/obj/structure/broodmother_egg/Destroy()
	if(resident_mob && !hatched)
		qdel(resident_mob)
	resident_mob = null
	return ..()

/obj/structure/broodmother_egg/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/mob/living/liver = mother_weak_ref?.resolve()
	if(user != liver)
		return
	possessed_only = !possessed_only
	if(possessed_only)
		to_chat(liver, span_notice("You coat the egg in your mucus preventing it from hatching without a strong will!"))
	else
		to_chat(liver, span_notice("You wipe the egg free of mucus!"))

/// Spawns the mob this egg will become, tucks it out of sight inside the egg, and
/// opens it up to ghosts as a vessel. Whether or not anyone claims it, the mob
/// already exists and is ready to be revealed at hatch() (or immediately, for
/// hatch_on_possess eggs).
/obj/structure/broodmother_egg/proc/spawn_resident_vessel()
	if(!type_to_spawn)
		return
	resident_mob = new type_to_spawn(src)
	resident_mob.forceMove(src)
	resident_mob.ai_controller?.can_idle = FALSE
	resident_mob.AddComponent(
		/datum/component/ghost_vessel, \
		null, \
		vessel_id, \
		CALLBACK(src, PROC_REF(on_vessel_possessed)), \
	)
	ADD_TRAIT(resident_mob, TRAIT_BROOD, INNATE_TRAIT)

/// Whether the resident mob currently has a soul in it (possessed by a ghost).
/obj/structure/broodmother_egg/proc/is_resident_possessed()
	return resident_mob?.key || resident_mob?.ckey

/// Called by the ghost_vessel component once a ghost claims the resident mob.
/// Keeps them locked in place inside the egg (the component's own stasis traits
/// are gone the moment it qdels itself) until the egg actually hatches.
/obj/structure/broodmother_egg/proc/on_vessel_possessed(mob/living/vessel_mob, mob/dead/observer/ghost)
	ADD_TRAIT(vessel_mob, TRAIT_STASIS, BROODMOTHER_EGG_TRAIT)
	ADD_TRAIT(vessel_mob, TRAIT_IMMOBILIZED, BROODMOTHER_EGG_TRAIT)
	ADD_TRAIT(vessel_mob, TRAIT_HANDS_BLOCKED, BROODMOTHER_EGG_TRAIT)
	to_chat(vessel_mob, span_notice("You curl up inside \the [src], waiting to hatch..."))
	// possessed_only eggs were only ever waiting on a soul - now that one's here, go
	if(hatch_on_possess || (possessed_only && ready_to_hatch))
		hatch()

/obj/structure/broodmother_egg/proc/hatch()
	if(hatched)
		return
	// mucus is still up and nobody's home - refuse to hatch, on_vessel_possessed
	// will call us again the moment a ghost actually claims the resident mob
	if(possessed_only && !is_resident_possessed())
		ready_to_hatch = TRUE
		return
	hatched = TRUE
	icon_state = "[icon_state]_hatched"
	name = "hatched " + name
	playsound(src, 'sound/foley/eggbreak.ogg', 70, TRUE)
	animate(src, tag = "hatching_animation", flags = ANIMATION_END_NOW)

	var/mob/living/spawned = resident_mob
	if(spawned)
		REMOVE_TRAIT(spawned, TRAIT_STASIS, BROODMOTHER_EGG_TRAIT)
		REMOVE_TRAIT(spawned, TRAIT_IMMOBILIZED, BROODMOTHER_EGG_TRAIT)
		REMOVE_TRAIT(spawned, TRAIT_HANDS_BLOCKED, BROODMOTHER_EGG_TRAIT)
		spawned.forceMove(get_turf(src))
	else
		spawned = new type_to_spawn(get_turf(src))

	resident_mob = null
	var/mob/living/mother = mother_weak_ref?.resolve()
	if(mother)
		spawned.befriend(mother)

/obj/structure/broodmother_egg/proc/crack()
	if(hatched)
		return

	playsound(src, SFX_EGG_HATCHING, 70, TRUE)
	animate(src, time = rand(1, 3), pixel_w = rand(1, 4) * pick(1, -1), pixel_z = rand(1, 4) * pick(1, -1), easing = ELASTIC_EASING, tag = "hatching_animation")
	animate(time = rand(1, 3), pixel_w = rand(1, 4) * pick(1, -1), pixel_z = rand(1, 4) * pick(1, -1), easing = ELASTIC_EASING)
	animate(time = rand(1, 3), pixel_w = rand(1, 4) * pick(1, -1), pixel_z = rand(1, 4) * pick(1, -1), easing = ELASTIC_EASING)
	animate(time = rand(1, 3), pixel_w = 0, pixel_z = 0, easing = ELASTIC_EASING)
	cracking_speed = max(cracking_speed - 0.5 SECONDS, 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(crack)), cracking_speed)

/obj/structure/broodmother_egg/goblin
	name = "small egg"
	icon_state = "goblin_egg"
	hud_name = "a Goblin Egg"
	type_to_spawn = /mob/living/carbon/human/species/goblin/slaved
	vessel_id = BROODSPAWN_GOBLIN_VESSEL_ID

/obj/structure/broodmother_egg/goblin/moon
	icon_state = "goblin_moon_egg"
	hud_name = "a Moon Goblin Egg"
	type_to_spawn = /mob/living/carbon/human/species/goblin/slaved/moon

/obj/structure/broodmother_egg/goblin/hell
	icon_state = "goblin_hell_egg"
	hud_name = "a Hell Goblin Egg"
	type_to_spawn = /mob/living/carbon/human/species/goblin/slaved/hell

/obj/structure/broodmother_egg/goblin/sea
	icon_state = "goblin_sea_egg"
	hud_name = "a Sea Goblin Egg"
	type_to_spawn = /mob/living/carbon/human/species/goblin/slaved/hell

/obj/structure/broodmother_egg/goblin/cave
	icon_state = "goblin_cave_egg"
	hud_name = "a Cave Goblin Egg"
	type_to_spawn = /mob/living/carbon/human/species/goblin/slaved/hell

/obj/structure/broodmother_egg/orc
	name = "medium egg"
	icon_state = "orc_egg"
	type_to_spawn = /mob/living/carbon/human/species/orc/slaved
	vessel_id = BROODSPAWN_ORC_VESSEL_ID
	hatch_time = 3 MINUTES
	time_before_first_crack = 2 MINUTES
	cracking_speed = 6 SECONDS

/obj/structure/broodmother_egg/troll
	name = "large egg"
	icon_state = "troll_egg"
	type_to_spawn = /mob/living/simple_animal/hostile/retaliate/troll/slaved
	vessel_id = BROODSPAWN_TROLL_VESSEL_ID
	hatch_time = 5 MINUTES
	time_before_first_crack = 4 MINUTES
	cracking_speed = 6 SECONDS

/obj/structure/broodmother_egg/troll/sea
	hud_name = "a Sea Troll Egg"
	icon_state = "troll_sea_egg"
	type_to_spawn = /mob/living/simple_animal/hostile/retaliate/troll/sea/slaved

/obj/structure/broodmother_egg/troll/cave
	hud_name = "a Cave Troll Egg"
	icon_state = "troll_cave_egg"
	type_to_spawn = /mob/living/simple_animal/hostile/retaliate/troll/cave/slaved

/obj/structure/broodmother_egg/troll/axe
	hud_name = "an Axe Troll Egg"
	icon_state = "troll_axe_egg"
	type_to_spawn = /mob/living/simple_animal/hostile/retaliate/troll/axe/slaved

/// Mapper-placed egg: sits inert until a ghost claims it, then immediately becomes
/// a fully active broodmother. No hatch_time/cracking - it's not laid by anything,
/// it's map-placed decoration-turned-spawner.
/obj/structure/broodmother_egg/broodmother
	name = "ancient egg"
	desc = "A massive, leathery egg humming with old and cunning power."
	icon_state = "troll_egg"
	type_to_spawn = /mob/living/simple_animal/hostile/retaliate/troll/broodmother
	vessel_id = BROODMOTHER_VESSEL_ID
	hatch_on_possess = TRUE
	maploaded_vessel = FALSE

/obj/structure/broodmother_egg/broodmother/Initialize()
	. = ..()
	LAZYADD(GLOB.broodmother_eggs, src)

/obj/structure/broodmother_egg/broodmother/Destroy()
	. = ..()
	LAZYREMOVE(GLOB.broodmother_eggs, src)

#undef BIOMASS_TIER_1
#undef BIOMASS_TIER_2
#undef BIOMASS_TIER_3
#undef BIOMASS_TIER_1_COST
#undef BIOMASS_TIER_2_COST
#undef BIOMASS_TIER_3_COST
#undef BIOMASS_MAX_AMOUNT
#undef BIOMASS_MIN_AMOUNT
#undef FRENZY_DURATION
#undef FRENZY_COOLDOWN
