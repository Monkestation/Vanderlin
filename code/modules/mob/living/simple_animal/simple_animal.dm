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

	///Does the mob wander around when idle?
	var/wander = 1

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

	var/next_scan_time = 0
	///Sorry, no spider+corgi buttbabies.
	var/animal_species
	var/adult_growth
	var/growth_prog = 0

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

	///Played when someone punches the creature.
	var/punched_sound = "punch"

	///If the creature has, and can use, hands.
	var/dextrous = FALSE
	var/dextrous_hud_type = /datum/hud/dextrous

	///If the creature should have an innate TRAIT_MOVE_FLYING trait added on init that is also toggled off/on on death/revival.
	var/is_flying_animal = FALSE

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

	var/food_max = 50
	var/pooptype = /obj/item/natural/poo/horse
	var/pooprog = 0

	var/swinging = FALSE

	buckle_lying = FALSE
	cmode = 1

	var/remains_type
	var/binded = FALSE

	var/botched_butcher_results
	var/perfect_butcher_results
	/// Path of head to drop upon butchering
	var/head_butcher

	var/happy_funtime_mob = FALSE

	var/can_saddle = FALSE
	var/obj/item/ssaddle
	// A flat percentage bonus to our ability to detect sneaking people only. Use in lieu of giving mobs huge STAPER bonuses if you want them to be observant.
	var/simple_detect_bonus = 0

	var/static/list/mob_friends = list(
		"enemy" = -50,
		"dislike" = -10,
		"neutral" = 0,
		"like" = 25,
		"friend" = 50,
		"best_friend" = 100
	)

/mob/living/simple_animal/Initialize()
	. = ..()
	if(gender == PLURAL)
		gender = pick(MALE, FEMALE)
	if(!real_name)
		real_name = name
	if(!loc)
		stack_trace("Simple animal being instantiated in nullspace")
	update_simplemob_varspeed()
	if(ai_controller && !length(ai_controller.blackboard[BB_BASIC_FOODS]))
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(food_type))
	if(footstep_type)
		AddElement(/datum/element/footstep, footstep_type, 1, -6)
	if(is_flying_animal)
		ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
	if(food_max)
		var/initial_hunger = food_max * 0.75
		AddComponent(/datum/component/generic_mob_hunger, food_max, 0.25, starting_hunger = initial_hunger)
	if(happy_funtime_mob)
		AddComponent(/datum/component/friendship_container, mob_friends, "friend")
		AddComponent(/datum/component/happiness_container, 30, list(), list(), food_type)

/mob/living/simple_animal/Destroy()
	if(nest)
		nest.spawned_mobs -= src
		nest = null

	if(ssaddle)
		QDEL_NULL(ssaddle)

	return ..()

/mob/living/simple_animal/attackby(obj/item/O, mob/user, list/modifiers)
	if(!is_type_in_list(O, food_type))
		return ..()
	else
		if(try_tame(O, user))
			SEND_SIGNAL(src, COMSIG_ATOM_ATTACKBY, O, user, modifiers) // for udder functionality
			return TRUE
	. = ..()

/mob/living/simple_animal/proc/try_tame(obj/item/O, mob/living/carbon/human/user)
	if(!stat)
		user.visible_message("<span class='info'>[user] hand-feeds [O] to [src].</span>", "<span class='notice'>I hand-feed [O] to [src].</span>")
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		SEND_SIGNAL(src, COMSIG_MOB_FEED, O, 30, user)
		SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHANGE, user, 10)
		qdel(O)
		if(tame && owner == user)
			return TRUE
		var/realchance = tame_chance
		if(realchance)
			if(user.mind)
				realchance += (user.get_skill_level(/datum/skill/labor/taming, TRUE) * 20)
			if(prob(realchance))
				tamed(user)
				var/boon = user.get_learning_boon(/datum/skill/labor/taming)
				user.adjust_experience(/datum/skill/labor/taming, (user.STAINT*10) * boon)
			else
				tame_chance += bonus_tame_chance
		return TRUE

///Extra effects to add when the mob is tamed, such as adding a riding component
/mob/living/simple_animal/proc/tamed(mob/user)
	INVOKE_ASYNC(src, PROC_REF(emote), "lower_head", null, null, null, TRUE)

	if(ai_controller)
		ai_controller.can_idle = FALSE

		var/datum/ai_planning_subtree/pet_planning/subtree = locate() in ai_controller.planning_subtrees
		if(subtree)
			var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/good_boy,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/fetch,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
			if(!GetComponent(/datum/component/obeys_commands))
				AddComponent(/datum/component/obeys_commands, pet_commands)

	tame = TRUE
	if(user)
		SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHANGE, user, 55)
		befriend(user)
		record_round_statistic(STATS_ANIMALS_TAMED)
		SEND_SIGNAL(user, COMSIG_ANIMAL_TAMED, src)
	pet_passive = TRUE

	if(user)
		owner = user

//mob/living/simple_animal/examine(mob/user)
//	. = ..()
//	if(stat == DEAD)
//		. += "<span class='deadsay'>Upon closer examination, [p_they()] appear[p_s()] to be dead.</span>"

/mob/living/simple_animal/updatehealth(amount)
	..()
	update_damage_overlays()

/mob/living/simple_animal
	var/retreating
	var/melee_attack_cooldown = 1.4 SECONDS

/mob/living/simple_animal/hostile/updatehealth(amount)
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

/mob/living/simple_animal/handle_status_effects()
	..()
	if(stuttering)
		stuttering = 0

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
	return

/mob/living/simple_animal/MiddleClick(mob/living/user, list/modifiers)
	if(stat == DEAD)
		var/obj/item/held_item = user.get_active_held_item()
		if(held_item)
			if((butcher_results || guaranteed_butcher_results) && held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
				if(src.buckled && istype(src.buckled, /obj/structure/meathook))
					var/obj/structure/meathook/hook = buckled
					hook.butchery(user, src)
					return
				visible_message("[user] begins to butcher [src].")
				playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
				if(do_after(user, 3 SECONDS, src))
					butcher(user)
	..()

/mob/living/simple_animal/proc/butcher(mob/living/user)
	if(ssaddle)
		ssaddle.forceMove(get_turf(src))
		ssaddle = null
	var/list/butcher = list()
	var/butchery_skill_level = user.get_skill_level(/datum/skill/labor/butchering) + user.get_inspirational_bonus()
	var/time_per_cut = max(5, 30 - butchery_skill_level * 5) // 30 seconds for no skill, 5 seconds for master
	var/botch_chance = 0
	if(length(botched_butcher_results) && butchery_skill_level < SKILL_LEVEL_JOURNEYMAN)
		botch_chance = 70 - (20 * butchery_skill_level)
	var/perfect_chance = 0
	if(length(perfect_butcher_results))
		switch(butchery_skill_level)
			if(SKILL_LEVEL_NONE to SKILL_LEVEL_APPRENTICE)
				perfect_chance = 0
			if(SKILL_LEVEL_JOURNEYMAN)
				perfect_chance = 10
			if(SKILL_LEVEL_EXPERT)
				perfect_chance = 50
			if(SKILL_LEVEL_MASTER to INFINITY)
				perfect_chance = 100

	// Get happiness bonus - ranges from 0% to 50% extra yield
	var/happiness_bonus = get_happiness_yield_bonus()
	var/happiness_message = get_happiness_butcher_message(happiness_bonus)

	// Always add guaranteed items up front
	if(guaranteed_butcher_results)
		butcher += guaranteed_butcher_results
	var/rotstuff = FALSE
	var/datum/component/rot/simple/CR = GetComponent(/datum/component/rot/simple)
	if(CR && CR.amount >= 10 MINUTES)
		rotstuff = TRUE
	var/atom/Tsec = drop_location()
	// Track results
	var/botch_count = 0
	var/perfect_count = 0
	var/normal_count = 0
	var/bonus_count = 0 // Track bonus items from happiness

	for(var/path in butcher_results)
		var/amount = butcher_results[path]
		if(!do_after(user, time_per_cut, target = src))
			if(botch_count || normal_count || perfect_count || bonus_count)
				to_chat(user, span_notice("I stop butchering: [butcher_summary(botch_count, normal_count, perfect_count, bonus_count, botch_chance, perfect_chance, happiness_bonus)]."))
			else
				to_chat(user, span_notice("I stop butchering for now."))
			break
		// Check for botch first
		if(prob(botch_chance))
			botch_count++
			if(length(botched_butcher_results) && (path in botched_butcher_results))
				amount = botched_butcher_results[path]
			else
				amount = 0
		// Otherwise check for perfect
		else if(length(perfect_butcher_results) && (path in perfect_butcher_results) && prob(perfect_chance))
			amount = perfect_butcher_results[path]
			perfect_count++
		else
			normal_count++

		// Apply happiness bonus to yield (only if not botched)
		var/bonus_amount = 0
		if(amount > 0 && happiness_bonus > 0)
			// Calculate bonus items based on happiness
			var/total_bonus = amount * happiness_bonus
			bonus_amount = round(total_bonus)
			// Handle fractional bonuses with probability
			var/fractional_part = total_bonus - bonus_amount
			if(fractional_part > 0 && prob(fractional_part * 100))
				bonus_amount++
			bonus_count += bonus_amount

		butcher_results -= path
		var/total_amount = amount + bonus_amount
		for(var/j in 1 to total_amount)
			var/obj/item/I = new path(Tsec)
			I.add_mob_blood(src)
			if(rotstuff && istype(I,/obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/F = I
				F.become_rotten()
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/labor/butchering, user.STAINT * 0.5)
		playsound(src, 'sound/foley/gross.ogg', 70, FALSE)
	if(isemptylist(butcher_results))
		if(head_butcher)
			var/obj/item/natural/head/head = new head_butcher(Tsec)
			switch(butchery_skill_level)
				if(SKILL_LEVEL_NONE to SKILL_LEVEL_NOVICE)
					head.ButcheringResults(0)
				if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_EXPERT)
					head.ButcheringResults(1)
					if(prob(20 - user.STALUC))
						head.ButcheringResults(0)
					else if(prob(user.STALUC))
						head.ButcheringResults(2)
				if(SKILL_LEVEL_MASTER to INFINITY)
					head.ButcheringResults(2)
			if(rotstuff)
				head.ButcheringResults(-1)
		var/final_message = "I finish butchering: [butcher_summary(botch_count, normal_count, perfect_count, bonus_count, botch_chance, perfect_chance, happiness_bonus)]"
		if(happiness_message)
			final_message += " [happiness_message]"
		to_chat(user, span_notice("[final_message]"))
		SEND_SIGNAL(user, COMSIG_MOB_BUTCHERED, src)
		gib()

/mob/living/proc/butcher_summary(botch_count, normal_count, perfect_count, bonus_count, botch_chance, perfect_chance, happiness_bonus)
	var/list/parts = list()
	if(botch_count)
		parts += "[botch_count] botched ([botch_chance]%)"
	if(normal_count)
		parts += "[normal_count] normal"
	if(perfect_count)
		parts += "[perfect_count] perfect ([perfect_chance]%)"
	if(bonus_count)
		parts += "[bonus_count] bonus ([round(happiness_bonus * 100)]%)"
	var/msg = ""
	for(var/i = 1, i <= length(parts), i++)
		msg += parts[i]
		if(i < length(parts))
			msg += ", "
	return msg

/mob/living/simple_animal/proc/get_happiness_yield_bonus(multiplier = 0.5)
	var/datum/component/happiness_container/happiness_comp = GetComponent(/datum/component/happiness_container)
	if(!happiness_comp)
		return 0

	var/current_happiness = SEND_SIGNAL(src, COMSIG_HAPPINESS_RETURN_VALUE)
	if(!current_happiness || current_happiness <= 0)
		return 0

	// Generational scaling: each 30 happiness represents one generation of care //! IF YOU CHANGE THE GENERATIONAL HAPPINESS VALUE ADJUST THIS
	// Gen 1 (0-30): 0-12.5% bonus
	// Gen 2 (31-60): 12.5-25% bonus
	// Gen 3 (61-90): 25-37.5% bonus
	// Gen 4+ (91+): 37.5-50% bonus (capped)

	var/generation = min(ceil(current_happiness / 30.0), 4) // Cap at generation 4
	var/happiness_in_gen = ((current_happiness - 1) % 30) + 1
	var/gen_progress = happiness_in_gen / 30.0

	var/base_bonus = (generation - 1) * 0.25
	var/gen_bonus = gen_progress * 0.25
	var/total_bonus = (base_bonus + gen_bonus) * multiplier

	return min(total_bonus, 1.0) // Cap at 100% bonus

/mob/living/simple_animal/proc/get_happiness_butcher_message(happiness_bonus)
	if(happiness_bonus <= 0)
		return null

	switch(happiness_bonus)
		if(0 to 0.1)
			return "The animal seems content."
		if(0.1 to 0.25)
			return "The well-cared-for animal yields extra meat."
		if(0.25 to 0.4)
			return "The happy animal provides generous portions."
		if(0.4 to INFINITY)
			return "The blissful animal rewards your care with abundant meat."

/mob/living/simple_animal/spawn_dust(just_ash = FALSE)
	if(just_ash || !remains_type)
		for(var/i in 1 to 5)
			new /obj/item/fertilizer/ash(loc)
	else
		new remains_type(loc)

/mob/living/simple_animal/gib_animation()
	if(icon_gib)
		new /obj/effect/temp_visual/gib_animation/animal(loc, icon_gib)

/mob/living/simple_animal/say_mod(input, list/message_mods = list())
	if(length(speak_emote))
		verb_say = pick(speak_emote)
	. = ..()

/mob/living/simple_animal/proc/set_varspeed(var_value)
	speed = var_value
	update_simplemob_varspeed()

/mob/living/simple_animal/proc/update_simplemob_varspeed()
	if(speed == 0)
		remove_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE)
	add_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE, 100, multiplicative_slowdown = speed, override = TRUE)

/mob/living/simple_animal/proc/drop_loot()
	if(loot.len)
		for(var/i in loot)
			new i(loc)

/mob/living/simple_animal/death(gibbed)
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
		if(is_flying_animal)
			REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
		health = 0
		icon_state = icon_dead
		if(flip_on_death)
			transform = transform.Turn(180)
		density = FALSE
		..()
		// SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, DEAD)

/mob/living/simple_animal/handle_fire()
	. = ..()
	if(!on_fire)
		return TRUE
	if(fire_stacks + divine_fire_stacks > 0)
		apply_damage(5, BURN)
		if(fire_stacks + divine_fire_stacks > 5)
			apply_damage(10, BURN)

/mob/living/simple_animal/revive(full_heal_flags = NONE, excess_healing = 0, force_grab_ghost = FALSE)
	. = ..()
	if(!.)
		return
	icon = initial(icon)
	icon_state = icon_living
	density = initial(density)
	if(is_flying_animal)
		ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)

/mob/living/simple_animal/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!can_perform_action(who, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return
	else
		..()

/mob/living/simple_animal/stripPanelEquip(obj/item/what, mob/who, where)
	if(!can_perform_action(who, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
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
			H.update_appearance(UPDATE_OVERLAYS)
		H = hud_used.hand_slots["[oindex]"]
		if(H)
			H.update_appearance(UPDATE_OVERLAYS)
	return TRUE

/mob/living/simple_animal/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE)
	. = ..(I, del_on_fail, merge_stacks)
	update_inv_hands()

/mob/living/simple_animal/update_inv_hands()
	if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
		var/obj/item/l_hand = get_item_for_held_index(1)
		var/obj/item/r_hand = get_item_for_held_index(2)
		if(r_hand)
			r_hand.plane = ABOVE_HUD_PLANE
			r_hand.screen_loc = ui_hand_position(get_held_index_of_item(r_hand))
			client.screen |= r_hand
		if(l_hand)
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
			playsound(src, 'sound/foley/zfall.ogg', 100, FALSE)
			M.visible_message("<span class='danger'>[M] falls off [src]!</span>")
		else
			return
	..()
	M.adjust_experience(/datum/skill/misc/riding, M.STAINT, FALSE)
	update_appearance(UPDATE_OVERLAYS)

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
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile
	var/do_footstep = FALSE

/mob/living/simple_animal/hostile/RangedAttack(atom/A, list/modifiers) //Player firing
	if(!ai_controller && ranged && ranged_cooldown <= world.time)
		target = A
		OpenFire(A)
	..()

/mob/living/simple_animal/hostile/proc/OpenFire(atom/A)
	visible_message("<span class='danger'><b>[src]</b> [ranged_message] at [A]!</span>")


	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(Shoot), A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/proc/Shoot(atom/targeted_atom)

/mob/living/simple_animal/hostile/Shoot(atom/targeted_atom)
	if( QDELETED(targeted_atom) || targeted_atom == targets_from.loc || targeted_atom == targets_from )
		return
	var/turf/startloc = get_turf(targets_from)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		casing.fire_casing(targeted_atom, src, null, null, null, ran_zone(), 0,  src)
	else if(projectiletype)
		var/obj/projectile/P = new projectiletype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = targeted_atom.y - startloc.y
		P.xo = targeted_atom.x - startloc.x
		P.original = targeted_atom
		P.preparePixelProjectile(targeted_atom, src)
		P.fire()
		return P

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
						playsound(src,pick('sound/foley/footsteps/hoof/horserun (1).ogg','sound/foley/footsteps/hoof/horserun (2).ogg','sound/foley/footsteps/hoof/horserun (3).ogg'), 100, TRUE)
					else
						do_footstep = FALSE
			else
				if(loc != oldloc)
					var/turf/open/T = loc
					if(!do_footstep && T.footstep)
						do_footstep = TRUE
						playsound(src,pick('sound/foley/footsteps/hoof/horsewalk (1).ogg','sound/foley/footsteps/hoof/horsewalk (2).ogg','sound/foley/footsteps/hoof/horsewalk (3).ogg'), 100, TRUE)
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
							playsound(L, 'sound/foley/zfall.ogg', 100, FALSE)
							L.visible_message(span_danger("[L] falls off [src]!"))

/mob/living/simple_animal/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 1)
	. = ..()
	LoadComponent(/datum/component/riding)

/mob/living/simple_animal/Life()
	. = ..()
	if(.)
		if(SEND_SIGNAL(src, COMSIG_MOB_RETURN_HUNGER) > 0)
			pooprog += 0.5
			if(pooprog >= 100)
				pooprog = 0
				poop()

/mob/living/simple_animal/proc/poop()
	if(pooptype)
		if(isturf(loc))
			playsound(src, "fart", 50, TRUE)
			new pooptype(loc)

/mob/living/simple_animal/proc/handle_habitation(obj/structure/home)
	SHOULD_CALL_PARENT(TRUE)
	var/drop_location = (src in home.contents) ? get_turf(home) : home
	forceMove(drop_location)

/mob/living/simple_animal/proc/eat_food(obj/item/reagent_containers/food/snacks/eaten)
	if(!istype(eaten))
		stack_trace("eating non snack")
		return FALSE

	playsound(src, 'sound/misc/eat.ogg', rand(30,60), TRUE)
	var/nutriment_give = 0
	for(var/datum/reagent/consumable/C in eaten.reagents.reagent_list)
		nutriment_give += C.nutriment_factor * C.volume / C.metabolization_rate
	. = nutriment_give

/mob/living/simple_animal/proc/eat_food_after(obj/item/reagent_containers/food/snacks/eaten)
	qdel(eaten)
