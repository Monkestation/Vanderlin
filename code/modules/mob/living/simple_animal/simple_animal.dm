#define MAX_FARM_ANIMALS 20

GLOBAL_VAR_INIT(farm_animals, FALSE)

/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20
	gender = PLURAL //placeholder
	living_flags = MOVES_ON_ITS_OWN

	status_flags = CANPUSH|CANSLOWDOWN|CANSTUN

	simpmob_attack = 45
	simpmob_defend = 45

	var/icon_living = ""
	///Icon when the animal is dead. Don't use animated icons for this.
	var/icon_dead = ""
	///We only try to show a gibbing animation if this exists.
	var/icon_gib = null
	///Flip the sprite upside down on death. Mostly here for things lacking custom dead sprites.
	var/flip_on_death = FALSE

	var/list/speak = list()
	///Emotes while speaking IE: Ian [emote], [text] -- Ian barks, "WOOF!". Spoken text is generated from the speak variable.
	var/list/speak_emote = list()
	var/speak_chance = 0
	///Hearable emotes
	var/list/emote_hear = list()
	///Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/emote_see = list()

	var/move_skip = FALSE
	var/action_skip = FALSE

	var/turns_per_move = 1
	var/turns_since_move = 0
	///Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/stop_automated_movement = 0
	///Does the mob wander around when idle?
	var/wander = 1
	///When set to 1 this stops the animal from moving when someone is pulling it.
	var/stop_automated_movement_when_pulled = 1

	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.

	///When someone interacts with the simple animal.
	///Help-intent verb in present continuous tense.
	var/response_help_continuous = "pokes"
	///Help-intent verb in present simple tense.
	var/response_help_simple = "poke"
	///Disarm-intent verb in present continuous tense.
	var/response_disarm_continuous = "shoves"
	///Disarm-intent verb in present simple tense.
	var/response_disarm_simple = "shove"
	///Harm-intent verb in present continuous tense.
	var/response_harm_continuous = "hits"
	///Harm-intent verb in present simple tense.
	var/response_harm_simple = "hit"
	var/harm_intent_damage = 3
	///Minimum force required to deal any damage.
	var/force_threshold = 0
	///Temperature effect.
	var/minbodytemp = 250
	var/maxbodytemp = 350

	///Healable by medical stacks? Defaults to yes.
	var/healable = 1

	///Atmos effect - Yes, you can make creatures that require plasma or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	///Leaving something at 0 means it's off - has no maximum.
	var/list/atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	///This damage is taken when atmos doesn't fit all the requirements above.
	var/unsuitable_atmos_damage = 2

	///LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly.
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	///how much damage this simple animal does to objects, if any.
	var/obj_damage = 0
	///How much armour they ignore, as a flat reduction from the targets armour value.
	var/armor_penetration = 0
	///Damage type of a simple mob's melee attack, should it do damage.
	var/melee_damage_type = BRUTE
	///Type of melee attack
	var/damage_type = "slash"
	/// 1 for full damage , 0 for none , -1 for 1:1 heal from that source.
	var/list/damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	///Attacking verb in present continuous tense.
	var/attack_verb_continuous = "attacks"
	///Attacking verb in present simple tense.
	var/attack_verb_simple = "attack"
	var/attack_sound = PUNCHWOOSH
	///Attacking, but without damage, verb in present continuous tense.
	var/friendly_verb_continuous = "nuzzles"
	///Attacking, but without damage, verb in present simple tense.
	var/friendly_verb_simple = "nuzzle"
	///Set to 1 to allow breaking of crates,lockers,racks,tables; 2 for walls; 3 for Rwalls.
	var/environment_smash = ENVIRONMENT_SMASH_NONE

	///LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster.
	var/speed = 1

	///Hot simple_animal baby making vars.
	var/list/childtype = null
	var/next_scan_time = 0
	///Sorry, no spider+corgi buttbabies.
	var/animal_species
	var/adult_growth
	var/growth_prog = 0
	var/breedcd = 5 MINUTES
	var/breedchildren = 3

	///Simple_animal access.
	var/list/lock_hashes
	///In the event that you want to have a buffing effect on the mob, but don't want it to stack with other effects, any outside force that applies a buff to a simple mob should at least set this to 1, so we have something to check against.
	var/buffed = 0
	///If the mob can be spawned with a gold slime core. HOSTILE_SPAWN are spawned with plasma, FRIENDLY_SPAWN are spawned with blood.
	var/gold_core_spawnable = NO_SPAWN

	var/datum/component/spawner/nest

	///Sentience type, for slime potions.
	var/sentience_type = SENTIENCE_ORGANIC

	///List of things spawned at mob's loc when it dies.
	var/list/loot = list()
	///Causes mob to be deleted on death, useful for mobs that spawn lootable corpses.
	var/del_on_death = 0
	var/deathmessage = ""

	var/allow_movement_on_non_turfs = FALSE

	///Played when someone punches the creature.
	var/attacked_sound = "punch"

	///If the creature has, and can use, hands.
	var/dextrous = FALSE
	var/dextrous_hud_type = /datum/hud/dextrous

	///The Status of our AI, can be set to AI_ON (On, usual processing), AI_IDLE (Will not process, but will return to AI_ON if an enemy comes near), AI_OFF (Off, Not processing ever), AI_Z_OFF (Temporarily off due to nonpresence of players).
	var/AIStatus = AI_ON
	///once we have become sentient, we can never go back.
	var/can_have_ai = TRUE

	///convenience var for forcibly waking up an idling AI on next check.
	var/shouldwakeup = FALSE

	///Domestication.
	var/tame = FALSE
	///What the mob eats, typically used for taming or animal husbandry.
	var/list/food_type
	///Starting success chance for taming.
	var/tame_chance
	///Added success chance after every failed tame attempt.
	var/bonus_tame_chance

	var/mob/owner = null

	///I don't want to confuse this with client registered_z.
	var/my_z
	///What kind of footstep this mob should have. Null if it shouldn't have any.
	var/footstep_type

	var/food = 0	//increase to make poop
	var/food_max = 50
	var/production = 0
	var/pooptype = /obj/item/natural/poo/horse
	var/pooprog = 0

	var/swinging = FALSE

	buckle_lying = FALSE
	cmode = 1

	var/remains_type
	var/binded = FALSE

	var/botched_butcher_results
	var/perfect_butcher_results

	var/obj/item/udder/udder = null
	var/datum/reagent/milk_reagent = null

/mob/living/simple_animal/Initialize()
	. = ..()
	if(!(AIStatus in GLOB.simple_animals))
		GLOB.simple_animals |= "[AIStatus]"
		GLOB.simple_animals["[AIStatus]"] = list()

	GLOB.simple_animals["[AIStatus]"] += src
	if(gender == PLURAL)
		gender = pick(MALE,FEMALE)
	if(!real_name)
		real_name = name
	if(!loc)
		stack_trace("Simple animal being instantiated in nullspace")
	update_simplemob_varspeed()
	if(milk_reagent)
		udder = new(src, milk_reagent)
//	if(dextrous)
//		AddComponent(/datum/component/personal_crafting)

/mob/living/simple_animal/Destroy()
	GLOB.simple_animals["[AIStatus]"] -= src
	if (SSnpcpool.state == SS_PAUSED && LAZYLEN(SSnpcpool.currentrun))
		SSnpcpool.currentrun -= src

	if(nest)
		nest.spawned_mobs -= src
		nest = null

	if(ssaddle)
		QDEL_NULL(ssaddle)
		ssaddle = null

	var/turf/T = get_turf(src)
	if (T && AIStatus == AI_Z_OFF)
		SSidlenpcpool.idle_mobs_by_zlevel[T.z] -= src

	qdel(udder)
	udder = null

	return ..()

/mob/living/simple_animal/attackby(obj/item/O, mob/user, params)
	if(!stat && istype(O, /obj/item/reagent_containers/glass))
		if(udder && user.used_intent.type == INTENT_FILL)
			changeNext_move(20) // milking sound length
			udder.milkAnimal(O, user)
			return TRUE
	if(!is_type_in_list(O, food_type))
		return ..()
	else
		if(try_tame(O, user))
			return TRUE
	. = ..()

/mob/living/simple_animal/proc/try_tame(obj/item/O, mob/user)
	if(!stat)
		user.visible_message("<span class='info'>[user] hand-feeds [O] to [src].</span>", "<span class='notice'>I hand-feed [O] to [src].</span>")
		playsound(loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(O)
		food = min(food + 30, 100)
		if(tame && owner == user)
			return TRUE
		var/realchance = tame_chance
		if(realchance)
			if(user.mind)
				realchance += (user.get_skill_level(/datum/skill/labor/taming) * 20)
			if(prob(realchance))
				tamed(user)
			else
				tame_chance += bonus_tame_chance
		return TRUE

///Extra effects to add when the mob is tamed, such as adding a riding component
/mob/living/simple_animal/proc/tamed(mob/user)
	INVOKE_ASYNC(src, PROC_REF(emote), "lower_head", null, null, null, TRUE)
	tame = TRUE
	if(user)
		befriend(user)
		SEND_SIGNAL(user, COMSIG_ANIMAL_TAMED, src)
	pet_passive = TRUE

	if(ai_controller)
		ai_controller.can_idle = FALSE
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
		)
		var/datum/component/obeys_commands/commands = GetComponent(/datum/component/obeys_commands)
		if(!commands)
			AddComponent(/datum/component/obeys_commands, pet_commands)

	stop_automated_movement_when_pulled = TRUE
	if(user)
		owner = user
	return

//mob/living/simple_animal/examine(mob/user)
//	. = ..()
//	if(stat == DEAD)
//		. += "<span class='deadsay'>Upon closer examination, [p_they()] appear[p_s()] to be dead.</span>"

/mob/living/simple_animal/updatehealth()
	..()
	update_damage_overlays()

/mob/living/simple_animal
	var/retreating
	var/melee_attack_cooldown = 1.4 SECONDS

/mob/living/simple_animal/hostile/updatehealth()
	..()
	if(!retreating)
		if(target)
			if(retreat_health)
				if(health <= round(maxHealth*retreat_health))
					emote("retreat")
					retreat_distance = 20
					minimum_distance = 20
					retreating = world.time
	if(!retreating || (world.time > retreating + 10 SECONDS))
		retreating = null
		retreat_distance = initial(retreat_distance)
		minimum_distance = initial(minimum_distance)
	if(HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		move_to_delay = initial(move_to_delay)
		return
	var/health_deficiency = getBruteLoss() + getFireLoss()
	if(health_deficiency >= ( maxHealth - (maxHealth*0.75) ))
		move_to_delay = initial(move_to_delay) + 2
	else
		move_to_delay = initial(move_to_delay)

/mob/living/simple_animal/hostile/forceMove(turf/T)
	var/list/BM = list()
	for(var/m in buckled_mobs)
		BM += m
	. = ..()
	for(var/mob/x in BM)
		x.forceMove(get_turf(src))
		buckle_mob(x, TRUE)

/mob/living/simple_animal/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health <= 0)
			death()
			// SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, DEAD)
			return
		else
			set_stat(CONSCIOUS)
	// SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, stat)
	if(footstep_type)
		AddComponent(/datum/component/footstep, footstep_type)

/mob/living/simple_animal/handle_status_effects()
	..()
	if(stuttering)
		stuttering = 0

/mob/living/simple_animal/proc/handle_automated_action()
	set waitfor = FALSE
	return

/mob/living/simple_animal/proc/handle_automated_movement()
	set waitfor = FALSE
	if(binded)
		return
	if(ai_controller)
		return
	if(!stop_automated_movement && wander && !doing())
		if(ssaddle && has_buckled_mobs())
			return 0
		if((isturf(loc) || allow_movement_on_non_turfs) && !HAS_TRAIT(src, TRAIT_IMMOBILIZED))		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Some animals don't move when pulled
					var/anydir = pick(GLOB.cardinals)
					if(Process_Spacemove(anydir))
						Move(get_step(src, anydir), anydir)
						turns_since_move = 0
			return 1

/mob/living/simple_animal/proc/handle_automated_speech(override)
	set waitfor = FALSE
	if(speak_chance)
		if(prob(speak_chance) || override)
			if(speak && speak.len)
				if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
					var/length = speak.len
					if(emote_hear && emote_hear.len)
						length += emote_hear.len
					if(emote_see && emote_see.len)
						length += emote_see.len
					var/randomValue = rand(1,length)
					if(randomValue <= speak.len)
						say(pick(speak), forced = "poly")
					else
						randomValue -= speak.len
						if(emote_see && randomValue <= emote_see.len)
							emote("me [pick(emote_see)]", 1)
						else
							emote("me [pick(emote_hear)]", 2)
				else
					say(pick(speak), forced = "poly")
			else
				if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					emote("me", 1, pick(emote_see))
				if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
					emote("me", 2, pick(emote_hear))
				if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					var/length = emote_hear.len + emote_see.len
					var/pick = rand(1,length)
					if(pick <= emote_see.len)
						emote("me", 1, pick(emote_see))
					else
						emote("me", 2, pick(emote_hear))

/mob/living/simple_animal/handle_environment()
	var/atom/A = src.loc
	if(isturf(A))
		var/areatemp = BODYTEMP_NORMAL
		if( abs(areatemp - bodytemperature) > 5)
			var/diff = areatemp - bodytemperature
			diff = diff / 5
			adjust_bodytemperature(diff)

	handle_temperature_damage()

/mob/living/simple_animal/proc/handle_temperature_damage()
	if((bodytemperature < minbodytemp) || (bodytemperature > maxbodytemp))
		adjustHealth(unsuitable_atmos_damage)

/mob/living/simple_animal/MiddleClick(mob/living/user, params)
	if(stat == DEAD)
		var/obj/item/held_item = user.get_active_held_item()
		var/boon = user.get_learning_boon(/datum/skill/labor/butchering)
		if(held_item)
			if((butcher_results || guaranteed_butcher_results) && held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
				if(src.buckled && istype(src.buckled, /obj/structure/meathook))
					var/obj/structure/meathook/hook = buckled
					hook.butchery(user, src)
					return
				var/used_time = 21 SECONDS
				if(user.mind)
					used_time -= (user.get_skill_level(/datum/skill/labor/butchering) * 3 SECONDS)
				visible_message("[user] begins to butcher [src].")
				playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
				var/amt2raise = user.STAINT // this is due to the fact that butchering is not as spammable as training a sword because you cant just spam click
				if(do_after(user, used_time, src))
					user.mind.add_sleep_experience(/datum/skill/labor/butchering, amt2raise * boon, FALSE)
					butcher(user)
	..()

/mob/living/simple_animal/proc/butcher(mob/user)
	if(ssaddle)
		ssaddle.forceMove(get_turf(src))
		ssaddle = null
	if(butcher_results || guaranteed_butcher_results)
		var/list/butcher = list()

		if(butcher_results)
			if(user.get_skill_level(/datum/skill/labor/butchering) <= 1)
				if(prob(50))
					butcher = botched_butcher_results // chance to get shit result
				else
					butcher = butcher_results
			if(user.get_skill_level(/datum/skill/labor/butchering) == 3)
				if(prob(10))
					butcher = perfect_butcher_results // small chance to get great result
				else
					butcher = butcher_results
			if(user.get_skill_level(/datum/skill/labor/butchering) == 4)
				if(prob(50))
					butcher = perfect_butcher_results // decent chance to get great result
				else
					butcher = butcher_results
			else
				if(user.get_skill_level(/datum/skill/labor/butchering) == 5)
					butcher = perfect_butcher_results
				else
					butcher = butcher_results

		var/rotstuff = FALSE
		var/datum/component/rot/simple/CR = GetComponent(/datum/component/rot/simple)
		if(CR)
			if(CR.amount >= 10 MINUTES)
				rotstuff = TRUE
		var/atom/Tsec = drop_location()
		for(var/path in butcher)
			for(var/i in 1 to butcher[path])
				var/obj/item/I = new path(Tsec)
				I.add_mob_blood(src)
				if(rotstuff && istype(I,/obj/item/reagent_containers/food/snacks))
					var/obj/item/reagent_containers/food/snacks/F = I
					F.become_rotten()
	gib()

/mob/living/simple_animal/spawn_dust(just_ash = FALSE)
	if(just_ash || !remains_type)
		for(var/i in 1 to 5)
			new /obj/item/ash(loc)
	else
		new remains_type(loc)

/mob/living/simple_animal/gib_animation()
	if(icon_gib)
		new /obj/effect/temp_visual/gib_animation/animal(loc, icon_gib)

/mob/living/simple_animal/say_mod(input, message_mode)
	if(speak_emote && speak_emote.len)
		verb_say = pick(speak_emote)
	. = ..()

/mob/living/simple_animal/proc/set_varspeed(var_value)
	speed = var_value
	update_simplemob_varspeed()

/mob/living/simple_animal/proc/update_simplemob_varspeed()
	if(speed == 0)
		remove_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE)
	add_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE, 100, multiplicative_slowdown = speed, override = TRUE)

/mob/living/simple_animal/Stat()
	..()
	return //RTCHANGE
/* 	if(statpanel("Status"))
		stat(null, "Health: [round((health / maxHealth) * 100)]%")
		return 1 */

/mob/living/simple_animal/proc/drop_loot()
	if(loot.len)
		for(var/i in loot)
			new i(loc)

/mob/living/simple_animal/death(gibbed)
	movement_type &= ~FLYING
	if(nest)
		nest.spawned_mobs -= src
		nest = null
	drop_loot()
	if(dextrous)
		drop_all_held_items()
	if(!gibbed)
		emote("death", forced = TRUE)
	layer = layer-0.1
	if(del_on_death)
		..()
		//Prevent infinite loops if the mob Destroy() is overridden in such
		//a manner as to cause a call to death() again
		del_on_death = FALSE
		qdel(src)
	else
		health = 0
		icon_state = icon_dead
		if(flip_on_death)
			transform = transform.Turn(180)
		density = FALSE
		..()
		// SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, DEAD)

/mob/living/simple_animal/proc/CanAttack(atom/the_target)
	if(see_invisible < the_target.invisibility)
		return FALSE
	if(ismob(the_target))
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE
	if (isliving(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return TRUE

/mob/living/simple_animal/handle_fire()
	. = ..()
	if(!on_fire)
		return TRUE
	if(fire_stacks + divine_fire_stacks > 0)
		apply_damage(5, BURN)
		if(fire_stacks + divine_fire_stacks > 5)
			apply_damage(10, BURN)

//mob/living/simple_animal/IgniteMob()
//	return FALSE

///mob/living/simple_animal/ExtinguishMob()
//	return

/mob/living/simple_animal/revive(full_heal = FALSE, admin_revive = FALSE)
	. = ..()
	if(!.)
		return
	icon = initial(icon)
	icon_state = icon_living
	density = initial(density)
	setMovetype(initial(movement_type))

/mob/living/simple_animal/proc/make_babies() // <3 <3 <3
	if(gender != FEMALE || stat || next_scan_time > world.time || !childtype || !animal_species || !SSticker.IsRoundInProgress())
		return
	if(GLOB.farm_animals >= MAX_FARM_ANIMALS)
		return
	if(food < 10)
		return
	if(next_scan_time == 0)
		next_scan_time = world.time + breedcd
		return
	if(breedchildren <= 0)
		childtype = null //we no longer can br33d bro
		return
	next_scan_time = world.time + breedcd
	var/alone = TRUE
	var/children = 0
	var/mob/living/simple_animal/partner
	for(var/mob/M in view(7, src))
		if(M.stat != CONSCIOUS) //Check if it's conscious FIRST.
			continue
		else if(istype(M, childtype)) //Check for children SECOND.
			children++
		else if(istype(M, animal_species))
			if(M.ckey)
				continue
			else if(!istype(M, childtype) && M.gender == MALE && !(M.flags_1 & HOLOGRAM_1)) //Better safe than sorry ;_;
				partner = M

	if(alone && partner && children < 3)
		var/childspawn = pickweight(childtype)
		var/turf/target = get_turf(loc)
		if(target)
			GLOB.vanderlin_round_stats[STATS_ANIMALS_BRED]++
			return new childspawn(target)

/mob/living/simple_animal/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(incapacitated(ignore_grab = TRUE))
		to_chat(src, "<span class='warning'>I can't do that right now!</span>")
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, "<span class='warning'>I are too far away!</span>")
		return FALSE
	if(!(no_dexterity || dextrous))
		to_chat(src, "<span class='warning'>I don't have the dexterity to do this!</span>")
		return FALSE
	return TRUE

/mob/living/simple_animal/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!canUseTopic(who, BE_CLOSE))
		return
	else
		..()

/mob/living/simple_animal/stripPanelEquip(obj/item/what, mob/who, where)
	if(!canUseTopic(who, BE_CLOSE))
		return
	else
		..()

/mob/living/simple_animal/update_resting()
	if(resting)
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, RESTING_TRAIT)
	else
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, RESTING_TRAIT)
	return ..()

/mob/living/simple_animal/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/changed = FALSE

	if(resize != RESIZE_DEFAULT_SIZE)
		changed = TRUE
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 2, easing = EASE_IN|EASE_OUT)

/mob/living/simple_animal/proc/sentience_act() //Called when a simple animal gains sentience via gold slime potion
	toggle_ai(AI_OFF) // To prevent any weirdness.
	can_have_ai = FALSE

/mob/living/simple_animal/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_OBSERVER
		return

	see_invisible = initial(see_invisible)
	see_in_dark = initial(see_in_dark)
	sight = initial(sight)

	if(client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return
	sync_lighting_plane_alpha()

/mob/living/simple_animal/can_hold_items()
	return dextrous

/mob/living/simple_animal/IsAdvancedToolUser()
	return dextrous

/mob/living/simple_animal/activate_hand(selhand)
	if(!dextrous)
		return ..()
	if(!selhand)
		selhand = (active_hand_index % held_items.len)+1
	if(istext(selhand))
		selhand = lowertext(selhand)
		if(selhand == "right" || selhand == "r")
			selhand = 2
		if(selhand == "left" || selhand == "l")
			selhand = 1
	if(selhand != active_hand_index)
		swap_hand(selhand)
	else
		mode()

/mob/living/simple_animal/swap_hand(hand_index)
	if(!dextrous)
		return ..()
	if(!hand_index)
		hand_index = (active_hand_index % held_items.len)+1
	var/oindex = active_hand_index
	active_hand_index = hand_index
	if(hud_used)
		var/atom/movable/screen/inventory/hand/H
		H = hud_used.hand_slots["[hand_index]"]
		if(H)
			H.update_icon()
		H = hud_used.hand_slots["[oindex]"]
		if(H)
			H.update_icon()
	return TRUE

/mob/living/simple_animal/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE)
	. = ..(I, del_on_fail, merge_stacks)
	update_inv_hands()

/mob/living/simple_animal/update_inv_hands()
	if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
		var/obj/item/l_hand = get_item_for_held_index(1)
		var/obj/item/r_hand = get_item_for_held_index(2)
		if(r_hand)
			r_hand.layer = ABOVE_HUD_LAYER
			r_hand.plane = ABOVE_HUD_PLANE
			r_hand.screen_loc = ui_hand_position(get_held_index_of_item(r_hand))
			client.screen |= r_hand
		if(l_hand)
			l_hand.layer = ABOVE_HUD_LAYER
			l_hand.plane = ABOVE_HUD_PLANE
			l_hand.screen_loc = ui_hand_position(get_held_index_of_item(l_hand))
			client.screen |= l_hand

//ANIMAL RIDING

/mob/living/simple_animal/hostile/user_unbuckle_mob(mob/living/M, mob/user)
	if(user != M)
		return
	var/time2mount = 0
	var/amt = M.get_skill_level(/datum/skill/misc/riding)
	if(M.mind)
		if(amt)
			if(amt <= 3)
				time2mount = 40 - (amt * 10)
			else
				time2mount = 0 // Instant at Expert and above
		else
			time2mount = 40
	if(ssaddle)
		playsound(src, 'sound/foley/saddledismount.ogg', 100, TRUE)
	if(!do_after(M, time2mount, src, (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE)))
		if(amt < 3) // Skilled prevents you from fumbling
			M.Paralyze(50)
			M.Stun(50)
			playsound(src.loc, 'sound/foley/zfall.ogg', 100, FALSE)
			M.visible_message("<span class='danger'>[M] falls off [src]!</span>")
		else
			return
	..()
	M.adjust_experience(/datum/skill/misc/riding, M.STAINT, FALSE)
	update_icon()

/mob/living/simple_animal/hostile/user_buckle_mob(mob/living/M, mob/user)
	if(user != M)
		return
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	if(riding_datum)
		var/time2mount = 12
		riding_datum.vehicle_move_delay = move_to_delay
		if(M.mind)
			var/amt = M.get_skill_level(/datum/skill/misc/riding)
			if(amt)
				if(amt <= 3)
					time2mount = 50 - (amt * 10)
				else
					time2mount = 0 // Instant at Master and above
			else
				time2mount = 50

		if(!do_after(M, time2mount, src))
			return
		if(user.incapacitated())
			return
//		for(var/atom/movable/A in get_turf(src))
//			if(A != src && A != M && A.density)
//				return
		M.forceMove(get_turf(src))
		M.adjust_experience(/datum/skill/misc/riding, M.STAINT, FALSE)
		if(ssaddle)
			playsound(src, 'sound/foley/saddlemount.ogg', 100, TRUE)
	..()
	update_icon()

/mob/living/simple_animal/hostile
	var/do_footstep = FALSE

/mob/living/simple_animal/hostile/relaymove(mob/user, direction)
	if (stat == DEAD)
		return
	var/oldloc = loc
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	if(tame && riding_datum)
		if(riding_datum.handle_ride(user, direction))
			riding_datum.vehicle_move_delay = move_to_delay
			if(user.m_intent == MOVE_INTENT_RUN)
				riding_datum.vehicle_move_delay -= 1
				if(loc != oldloc)
					var/turf/open/T = loc
					if(!do_footstep && T.footstep)
						do_footstep = TRUE
						playsound(loc,pick('sound/foley/footsteps/hoof/horserun (1).ogg','sound/foley/footsteps/hoof/horserun (2).ogg','sound/foley/footsteps/hoof/horserun (3).ogg'), 100, TRUE)
					else
						do_footstep = FALSE
			else
				if(loc != oldloc)
					var/turf/open/T = loc
					if(!do_footstep && T.footstep)
						do_footstep = TRUE
						playsound(loc,pick('sound/foley/footsteps/hoof/horsewalk (1).ogg','sound/foley/footsteps/hoof/horsewalk (2).ogg','sound/foley/footsteps/hoof/horsewalk (3).ogg'), 100, TRUE)
					else
						do_footstep = FALSE
			if(user.mind)
				var/amt = user.get_skill_level(/datum/skill/misc/riding)
				if(amt)
					amt = clamp(amt, 0, 4) //higher speed amounts are a little wild. Max amount achieved at expert riding.
					riding_datum.vehicle_move_delay -= (amt/5 + 1.5)
					riding_datum.vehicle_move_delay -= 3
			if(loc != oldloc)
				var/obj/structure/door/MD = locate() in loc
				if(MD && !MD.ridethrough)
					if(isliving(user))
						var/mob/living/L = user
						var/strong_thighs = L.get_skill_level((/datum/skill/misc/riding))
						if(prob(60 - (strong_thighs * 10))) // Legendary riders do not fall!
							unbuckle_mob(L)
							L.Paralyze(50)
							L.Stun(50)
							playsound(L.loc, 'sound/foley/zfall.ogg', 100, FALSE)
							L.visible_message(span_danger("[L] falls off [src]!"))

/mob/living/simple_animal/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 1)
	. = ..()
	LoadComponent(/datum/component/riding)

/mob/living/simple_animal/proc/toggle_ai(togglestatus)
	if(!can_have_ai && (togglestatus != AI_OFF))
		return
	if (AIStatus != togglestatus)
		if (togglestatus > 0 && togglestatus < 5)
			if (togglestatus == AI_Z_OFF || AIStatus == AI_Z_OFF)
				var/turf/T = get_turf(src)
				if (AIStatus == AI_Z_OFF)
					SSidlenpcpool.idle_mobs_by_zlevel[T.z] -= src
				else
					SSidlenpcpool.idle_mobs_by_zlevel[T.z] += src
			GLOB.simple_animals["[AIStatus]"] -= src
			if(!(togglestatus in GLOB.simple_animals))
				GLOB.simple_animals["[togglestatus]"] = list()
			GLOB.simple_animals["[togglestatus]"] += src
			AIStatus = togglestatus
		else
			stack_trace("Something attempted to set simple animals AI to an invalid state: [togglestatus]")

/mob/living/simple_animal/proc/consider_wakeup()
	if (pulledby || shouldwakeup)
		toggle_ai(AI_ON)

/mob/living/simple_animal/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!ckey && !stat)//Not unconscious
		if(AIStatus == AI_IDLE)
			toggle_ai(AI_ON)


/mob/living/simple_animal/onTransitZ(old_z, new_z)
	..()
	if (AIStatus == AI_Z_OFF)
		SSidlenpcpool.idle_mobs_by_zlevel[old_z] -= src
		toggle_ai(initial(AIStatus))

/mob/living/simple_animal/proc/eat_plants()
	var/obj/item/reagent_containers/food/I = locate(/obj/item/reagent_containers/food) in loc
	if(is_type_in_list(I, food_type))
		qdel(I)
		food = max(food + 30, 100)

/mob/living/simple_animal/Life()
	. = ..()
	if(.)
		if(food > 0)
			food--
			pooprog++
			production++
			production = min(production, 100)
			if(udder)
				if(production > 0)
					production--
					udder.generateMilk()
			if(pooprog >= 100)
				pooprog = 0
				poop()

/mob/living/simple_animal/proc/poop()
	if(pooptype)
		if(isturf(loc))
			playsound(src, "fart", 50, TRUE)
			new pooptype(loc)

//................. UDDER .......................//
/obj/item/udder
	name = "udder"
	var/datum/reagent/milk_reagent = /datum/reagent/consumable/milk

/obj/item/udder/Initialize(mapload, datum/reagent/reagent)
	create_reagents(100)
	if(reagent)
		milk_reagent = reagent
	reagents.add_reagent(milk_reagent, rand(0,20))
	. = ..()

/obj/item/udder/proc/generateMilk()
	reagents.add_reagent(milk_reagent, 1)

/obj/item/udder/proc/milkAnimal(obj/O, mob/living/user = usr)
	var/obj/item/reagent_containers/glass/G = O
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, span_warning("[O] is full."))
		return
	if(!reagents.has_reagent(milk_reagent, 5))
		to_chat(user, span_warning("[src] is dry. Wait a bit longer..."))
		user.changeNext_move(10)
		return
	if(do_after(user, 1 SECONDS, src))
		reagents.trans_to(O, rand(5,10))
		user.visible_message(span_notice("[user] milks [src] using \the [O]"))
		playsound(O, pick('sound/vo/mobs/cow/milking (1).ogg', 'sound/vo/mobs/cow/milking (2).ogg'), 100, TRUE, -1)
		user.Immobilize(1 SECONDS)
		user.changeNext_move(1 SECONDS)


/mob/living/simple_animal/proc/handle_habitation(obj/structure/home)
	SHOULD_CALL_PARENT(TRUE)
	var/drop_location = (src in home.contents) ? get_turf(home) : home
	forceMove(drop_location)
