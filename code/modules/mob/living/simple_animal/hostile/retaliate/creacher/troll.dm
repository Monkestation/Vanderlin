/mob/living/simple_animal/hostile/retaliate/troll
	name = "troll"
	desc = "Elven legends say these monsters were servants of Dendor tasked to guard his realm; nowadays, they are sometimes found in the company of orcs."
	icon = 'icons/mob/creacher/trolls/troll.dmi'
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll_dead"
	SET_BASE_PIXEL(-16, 0)

	faction = list(FACTION_ORCS)
	footstep_type = FOOTSTEP_MOB_HEAVY
	emote_hear = null
	emote_see = null
	verb_say = "groans"
	verb_ask = "grunts"
	verb_exclaim = "roars"
	verb_yell = "roars"

	see_in_dark = 10
	move_to_delay = 7
	vision_range = 6
	aggro_vision_range = 6

	animal_type = /datum/blood_type/troll

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1,
						/obj/item/natural/hide = 2, \
						/obj/item/alch/horn = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange= 2, \
						/obj/item/natural/hide = 3, \
						/obj/item/alch/horn = 2)
	head_butcher = /obj/item/natural/head/troll

	health = TROLL_HEALTH
	maxHealth = TROLL_HEALTH
	food_type = list(
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/unarmed/claw, /datum/intent/simple/bigbite)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	melee_damage_lower = 40
	melee_damage_upper = 60
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

	base_constitution = 16
	base_strength = 16
	base_speed = 2
	base_endurance = 17

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 20
	defdrain = 15
	del_on_deaggro = 99 SECONDS
	retreat_health = 0
	food_max = 250

	dodgetime = 50
	dendor_taming_chance = DENDOR_TAME_PROB_HIGH

	remains_type = /obj/effect/decal/remains/troll

	ai_controller = /datum/ai_controller/troll


	var/range = 9

/mob/living/simple_animal/hostile/retaliate/troll/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/simple_animal/hostile/retaliate/troll/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system, 10 , range)
	ADD_TRAIT(src, TRAIT_ACID_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/troll/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/troll/aggro1.ogg','sound/vo/mobs/troll/aggro2.ogg')
		if("pain")
			return pick('sound/vo/mobs/troll/pain1.ogg','sound/vo/mobs/troll/pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/troll/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/troll/idle1.ogg','sound/vo/mobs/troll/idle2.ogg')
		if("cidle")
			return pick('sound/vo/mobs/troll/cidle1.ogg','sound/vo/mobs/troll/aggro2.ogg')


/mob/living/simple_animal/hostile/retaliate/troll/Life()
	..()
	if(fire_stacks + divine_fire_stacks <= 0)
		adjustHealth(-rand(20,35))

/mob/living/simple_animal/hostile/retaliate/troll/simple_limb_hit(zone)
	return ..()

/mob/living/simple_animal/hostile/retaliate/troll/proc/hide()
	flick("troll_hiding", src)
	sleep(1 SECONDS)
	icon_state = "troll_hide"

/mob/living/simple_animal/hostile/retaliate/troll/proc/ambush()
	flick("troll_ambush", src)
	sleep(1 SECONDS)
	icon_state = initial(icon_state)

/obj/effect/decal/remains/troll
	icon_state = "troll_dead"

/mob/living/simple_animal/hostile/retaliate/troll/after_creation()
	. = ..()
	var/list/eye_list = getorganslotlist(ORGAN_SLOT_EYES)
	for(var/obj/item/organ/eyes/eyes as anything in eye_list)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)

	var/obj/item/organ/eyes/LE = new /obj/item/organ/eyes/night_vision/nightmare
	var/obj/item/organ/eyes/RE = new /obj/item/organ/eyes/night_vision/nightmare
	LE.switch_side(LEFT_SIDE)

	LE.Insert(src)
	RE.Insert(src)

/mob/living/simple_animal/hostile/retaliate/troll/quiet
	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/hostile/retaliate/troll/quiet/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/troll/aggro1.ogg','sound/vo/mobs/troll/aggro2.ogg')
		if("pain")
			return pick('sound/vo/mobs/troll/pain1.ogg','sound/vo/mobs/troll/pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/troll/death.ogg')

/mob/living/simple_animal/hostile/retaliate/troll/bog
	name = "bog troll"
	ai_controller = /datum/ai_controller/bog_troll

	health = BOGTROLL_HEALTH
	maxHealth = BOGTROLL_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/headbutt, /datum/intent/simple/bigbite)
	melee_damage_lower = 30
	melee_damage_upper = 50

	defprob = 25
	defdrain = 13
	range = 3

/mob/living/simple_animal/hostile/retaliate/troll/bog/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/simple_animal/hostile/retaliate/troll/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/obj/projectile/thrown_stone
	name = "stone"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig1"
	damage = 20
	damage_type = BRUTE
	speed = 6
	///this is chip damage/knockback, not a real siege weapon so yea
	var/explosion_power = 25
	var/explosion_falloff = 10

/obj/projectile/thrown_stone/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		return
	cell_explosion(
		epicenter = T, \
		power = explosion_power, \
		falloff = explosion_falloff, \
		falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, \
		explosion_source = "[name] (Stone Throw)", \
		burns = FALSE \
	)

/mob/living/simple_animal/hostile/retaliate/troll/cave
	name = "cave troll"
	desc = "Dwarven tales of giants and trolls often contain these creatures, for the fear of mining into one runs deep."
	icon = 'icons/mob/creacher/trolls/troll_cave.dmi'
	health = CAVETROLL_HEALTH
	maxHealth = CAVETROLL_HEALTH
	ai_controller = /datum/ai_controller/troll/cave

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 1, \
						/obj/item/natural/rock/mana_crystal = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 2, \
						/obj/item/alch/horn = 1, \
						/obj/item/natural/rock/mana_crystal = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange= 2, \
						/obj/item/natural/hide = 3, \
						/obj/item/alch/horn = 2, \
						/obj/item/natural/rock/mana_crystal = 3)
	head_butcher = /obj/item/natural/head/troll/cave

	dendor_taming_chance = DENDOR_TAME_PROB_LOW
	defprob = 15

	//stone chucking ability
	var/datum/action/cooldown/spell/stone_throw/throwing_stone

/mob/living/simple_animal/hostile/retaliate/troll/cave/Initialize()
	. = ..()
	throwing_stone = new
	throwing_stone.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, throwing_stone)

/mob/living/simple_animal/hostile/retaliate/troll/cave/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/simple_animal/hostile/retaliate/troll/cave/ambush
	ai_controller = /datum/ai_controller/troll/ambush
	range = 3

/datum/action/cooldown/spell/ground_slam
	name = "Ground Slam"
	desc = "Rears back and slams the ground in a line, crushing anything caught beneath it."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spell_default"
	cooldown_time = 10 SECONDS
	charge_required = FALSE
	spell_type = NONE
	/// How many tiles out the slam reaches
	var/slam_range = 4
	/// How long the troll telegraphs before slamming
	var/telegraph_time = 1 SECONDS
	/// Damage dealt per tile hit
	var/slam_damage = 40

/datum/action/cooldown/spell/ground_slam/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!istype(caster) || !cast_on)
		return

	var/list/turf/line = get_line(get_turf(caster), get_turf(cast_on))
	if(line.len > slam_range)
		line = line.Copy(1, slam_range + 1)

	caster.visible_message(
		span_danger("[caster] rears back, axe raised high!"),
		span_userdanger("[caster] rears back, axe raised high!"),
	)
	caster.Stun(telegraph_time, ignore_canstun = TRUE)

	var/list/real_lines = list()
	for(var/turf/marked_turf as anything in line)
		if(isopenspace(marked_turf) || isclosedturf(marked_turf))
			break
		new /obj/effect/temp_visual/telegraph_marking/troll_slam(marked_turf)
		real_lines += marked_turf

	addtimer(CALLBACK(src, PROC_REF(slam_down), real_lines, caster), telegraph_time)

/datum/action/cooldown/spell/ground_slam/proc/slam_down(list/turf/line, mob/living/caster)
	if(QDELETED(caster))
		return

	caster.visible_message(span_danger("[caster] slams its axe into the ground!"))
	playsound(caster, "genblunt", 100, TRUE) // swap for a real impact sound

	for(var/turf/hit_turf as anything in line)
		for(var/mob/living/hit_mob in hit_turf)
			if(hit_mob == caster)
				continue
			hit_mob.apply_damage(slam_damage, BRUTE, def_zone = BODY_ZONE_HEAD, damage_type = BCLASS_CHOP)
			hit_mob.visible_message(span_danger("[hit_mob] is crushed by the slam!"))

/mob/living/simple_animal/hostile/retaliate/troll/axe
	name = "Troll Skull-Splitter"
	desc = "This one seems smarter than the rest... And its axe could cut a man in two."
	icon = 'icons/mob/creacher/trolls/troll_axe.dmi'
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 2, \
					/obj/item/natural/hide = 3, \
					/obj/item/alch/horn = 2)
	head_butcher = /obj/item/natural/head/troll/axe
	dendor_taming_chance = DENDOR_TAME_PROB_LOW
	base_intents = list(/datum/intent/simple/troll_axe)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	loot = list(/obj/item/weapon/axe/iron/troll)
	deathmessage = "As the creacher tumbles, it falls upon its axe, snapping the handle."
	ai_controller = /datum/ai_controller/troll/axe

/mob/living/simple_animal/hostile/retaliate/troll/axe/Initialize()
	. = ..()
	var/datum/action/cooldown/spell/ground_slam/swipe = new(src)
	swipe.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, swipe)

/mob/living/simple_animal/hostile/retaliate/troll/axe/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/datum/intent/simple/troll_axe
	name = "troll axe"
	icon_state = "instrike"
	attack_verb = list("hacks at", "slashes", "chops", "crushes")
	animname = "blank22"
	hitsound = "genchop"
	blade_class = BCLASS_CHOP
	chargetime = 20
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "slash"

// You know I had to. Hostile, killer cabbit. Strong. Fast. But not as durable.
// The most foul, cruel and bad tempered feline-rodent you ever set eyes on.
/mob/living/simple_animal/hostile/retaliate/troll/caerbannog
	name = "cabbit of the Cairne Bog"
	desc = "That's no ordinary cabbit..."
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_evil"
	icon_living = "cabbit_evil"
	icon_dead = "cabbit_evil_dead"
	speak = list("HISSS", "GHRHRHRHL")
	speak_emote = list("squeaks")
	emote_hear = list("raises its ears.", "hisses.")
	emote_see = list("turns his head around.", "stands with its hindlegs in guard.")
	health = 160
	maxHealth = 160
	move_to_delay = 3 // FAST.
	attack_sound = list('sound/vo/mobs/rat/aggro (1).ogg', 'sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg')
	base_constitution = 5
	base_strength = 5
	base_speed = 10
	base_endurance = 5
	remains_type = /obj/effect/decal/remains/cabbit
	melee_damage_lower = 20
	melee_damage_upper = 40
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, \
							/obj/item/alch/sinew = 1, \
							/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, \
							/obj/item/alch/sinew = 2, \
							/obj/item/alch/bone = 1, \
							/obj/item/natural/fur/cabbit = 1)
	head_butcher = null

/mob/living/simple_animal/hostile/retaliate/troll/caerbannog/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rabbit/rabbit_alert.ogg')
		if("pain")
			return pick('sound/vo/mobs/rabbit/rabbit_pain1.ogg', 'sound/vo/mobs/rabbit/rabbit_pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/rabbit/rabbit_death.ogg')

/obj/effect/decal/remains/cabbit
	name = "remains"
	gender = PLURAL
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_remains"

/datum/action/cooldown/spell/projectile/harpoon_pull
	name = "Harpoon"
	desc = "Hurls a barbed harpoon; if it connects, the line goes taut and yanks the troll straight to its prey."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spell_default"
	cooldown_time = 14 SECONDS
	spell_type = NONE
	charge_required = FALSE
	projectile_type = /obj/projectile/harpoon

/datum/action/cooldown/spell/projectile/harpoon_pull/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	user.visible_message(span_danger("[user] hurls a harpoon!"))
	to_fire.Beam(user, "shisha")

/obj/projectile/harpoon
	name = "harpoon"
	icon_state = "harpoon"
	damage = 15
	damage_type = BRUTE
	speed = 1.6
	/// Delay between the hit landing and the pull happening
	var/pull_delay = 0.4 SECONDS

/obj/projectile/harpoon/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(QDELETED(firer))
		return
	if(isliving(target))
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, fly_towards), "is yanked towards [firer] by the harpoon!", firer), pull_delay)
	else
		addtimer(CALLBACK(firer, TYPE_PROC_REF(/mob, fly_towards), "is yanked forward by the harpoon line!", target), pull_delay)

/mob/proc/fly_towards(flying_text, atom/target)
	if(QDELETED(target))
		return
	var/turf/destination = get_turf(target)
	if(!destination)
		return
	visible_message(span_danger("[src] [flying_text]"))
	safe_throw_at(destination, 20, 5, src, TRUE)

/mob/living/simple_animal/hostile/retaliate/troll/sea
	name = "sea troll"
	desc = "Bloated and near-translucent from decades in the deep, sailors say these things drag the drowning down rather than let the sea have them."
	icon = 'icons/mob/creacher/trolls/troll_sea.dmi'
	icon_state = "angler"
	icon_living = "angler"
	icon_dead = "angler_dead"

	health = SEATROLL_HEALTH
	maxHealth = SEATROLL_HEALTH
	ai_controller = /datum/ai_controller/troll/sea

	/// Are we currently submerged (sped up + reskinned)?
	var/submerged = FALSE
	/// How close the target has to be before we surface even while in water
	var/surface_distance = 4
	COOLDOWN_DECLARE(submerge_cooldown)

/mob/living/simple_animal/hostile/retaliate/troll/sea/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SWIMMER, INNATE_TRAIT)

	var/datum/action/cooldown/spell/projectile/harpoon_pull/harpoon = new(src)
	harpoon.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, harpoon)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_submersion))

/mob/living/simple_animal/hostile/retaliate/troll/sea/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
			/datum/pet_command/idle,
			/datum/pet_command/free,
			/datum/pet_command/follow,
			/datum/pet_command/attack,
			/datum/pet_command/protect_owner,
			/datum/pet_command/aggressive,
			/datum/pet_command/calm,
		)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/simple_animal/hostile/retaliate/troll/sea/proc/check_submersion()
	SIGNAL_HANDLER
	var/turf/open/water/current_turf = get_turf(src)
	var/in_water = istype(current_turf)

	var/mob/living/target
	if(ai_controller)
		target = ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/target_close = target && !QDELETED(target) && get_dist(src, target) <= surface_distance

	if(in_water && (!target || !target_close))
		go_under()
	else
		surface()

/mob/living/simple_animal/hostile/retaliate/troll/sea/proc/go_under()
	if(submerged || !COOLDOWN_FINISHED(src, submerge_cooldown))
		return
	submerged = TRUE
	update_reflection()
	add_movespeed_modifier(MOVESPEED_ID_WHIRLPOOL, multiplicative_slowdown = -1.5)

/mob/living/simple_animal/hostile/retaliate/troll/sea/proc/surface()
	if(!submerged)
		return
	submerged = FALSE
	update_reflection()
	remove_movespeed_modifier(MOVESPEED_ID_WHIRLPOOL)
	COOLDOWN_START(src, submerge_cooldown, 1 MINUTES)
