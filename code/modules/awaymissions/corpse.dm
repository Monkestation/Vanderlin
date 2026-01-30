//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/effect/mob_spawn
	icon_state = MAP_SWITCH("", "corpse_spawner")
	name = "Unknown"
	density = TRUE
	anchored = TRUE
	var/mob_type = null
	var/mob_name = ""
	var/mob_gender = null
	var/death = TRUE //Kill the mob
	var/roundstart = TRUE //fires on initialize
	var/instant = FALSE	//fires on New
	var/flavour_text = "The mapper forgot to set this!"
	var/faction = null
	var/permanent = FALSE	//If true, the spawner will not disappear upon running out of uses.
	var/random = FALSE		//Don't set a name or gender, just go random
	var/antagonist_type
	var/objectives = null
	var/uses = 1			//how many times can we spawn from it. set to -1 for infinite.
	var/brute_damage = 0
	var/oxy_damage = 0
	var/burn_damage = 0
	var/mob_color //Change the mob's color
	var/datum/job/assignedrole
	var/show_flavour = TRUE
	var/banType = ROLE_NECRO_SKELETON
	var/ghost_usable = TRUE

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/mob_spawn/attack_ghost(mob/user)
	if(!SSticker.HasRoundStarted() || !loc || !ghost_usable)
		return
	if(!uses)
		to_chat(user, "<span class='warning'>This spawner is out of charges!</span>")
		return
	if(is_banned_from(user.key, banType))
		to_chat(user, "<span class='warning'>I am jobbanned!</span>")
		return
	if(QDELETED(src) || QDELETED(user))
		return
	var/ghost_role = alert("Become [mob_name]? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(ghost_role == "No" || !loc)
		return
	log_game("[key_name(user)] became [mob_name]")
	create(ckey = user.ckey)

/obj/effect/mob_spawn/Initialize(mapload)
	. = ..()
	if(instant || (roundstart && (mapload || (SSticker && SSticker.current_state > GAME_STATE_SETTING_UP))))
		INVOKE_ASYNC(src, PROC_REF(create))
	else if(ghost_usable)
		GLOB.poi_list |= src
		LAZYADD(GLOB.mob_spawners[name], src)

/obj/effect/mob_spawn/Destroy()
	GLOB.poi_list -= src
	var/list/spawners = GLOB.mob_spawners[name]
	LAZYREMOVE(spawners, src)
	if(!LAZYLEN(spawners))
		GLOB.mob_spawners -= name
	return ..()

/obj/effect/mob_spawn/proc/special(mob/M)
	return

/obj/effect/mob_spawn/proc/equip(mob/M)
	return

/obj/effect/mob_spawn/proc/create(ckey, newname)
	var/mob/living/M = new mob_type(get_turf(src)) //living mobs only
	if(!random || newname)
		if(newname)
			M.real_name = newname
		else
			M.real_name = mob_name ? mob_name : M.name
		if(!mob_gender)
			mob_gender = pick(MALE, FEMALE)
		M.gender = mob_gender
	if(faction)
		M.faction = list(faction)
	if(death)
		M.death(1) //Kills the new mob

	M.adjustOxyLoss(oxy_damage)
	M.take_overall_damage(brute_damage, burn_damage)
	M.color = mob_color
	equip(M)

	if(ckey)
		M.ckey = ckey
		if(show_flavour)
			to_chat(M, "[flavour_text]")
		var/datum/mind/MM = M.mind
		var/datum/antagonist/A
		if(antagonist_type)
			A = MM.add_antag_datum(antagonist_type)
		if(objectives)
			if(!A)
				A = MM.add_antag_datum(/datum/antagonist/custom)
			for(var/objective in objectives)
				var/datum/objective/O = new/datum/objective(objective)
				O.owner = MM
				A.objectives += O
		if(assignedrole)
			M.mind.set_assigned_role(assignedrole)
		special(M)
		MM.name = M.real_name
	if(uses > 0)
		uses--
	if(!permanent && !uses)
		qdel(src)
	return M

// Base version - place these on maps/templates.
/obj/effect/mob_spawn/human
	mob_type = /mob/living/carbon/human
	//Human specific stuff.
	var/list/mob_species = list(/datum/species/human/northern, /datum/species/elf/snow, /datum/species/human/halfelf) //Set to make them a mutant race such as lizard or skeleton. Uses the datum typepath instead of the ID.
	var/datum/outfit/outfit = /datum/outfit	//If this is a path, it will be instanced in Initialize()

	var/husk = FALSE
	//these vars are for lazy mappers to override parts of the outfit
	//these cannot be null by default, or mappers cannot set them to null if they want nothing in that slot
	var/uniform = -1
	var/r_hand = -1
	var/l_hand = -1
	var/suit = -1
	var/shoes = -1
	var/gloves = -1
	var/ears = -1
	var/glasses = -1
	var/mask = -1
	var/head = -1
	var/belt = -1
	var/r_pocket = -1
	var/l_pocket = -1
	var/back = -1
	var/id = -1
	var/neck = -1
	var/backpack_contents = -1
	var/suit_store = -1
	assignedrole = /datum/job/unassigned
	var/list/possible_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

	var/hairstyle
	var/facial_hairstyle
	var/skin_tone

/obj/effect/mob_spawn/human/Initialize()
	if(ispath(outfit))
		outfit = new outfit()
	if(!outfit)
		outfit = new /datum/outfit
	return ..()

/obj/effect/mob_spawn/human/equip(mob/living/carbon/human/H)
	if(length(possible_ages))
		H.age = pick(possible_ages)
	if(length(mob_species))
		var/species = pick(mob_species)
		H.set_species(species)
		H.dna.species.random_character(H)
		if(mob_name)
			H.change_name(mob_name)
	else
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
	if(husk)
		H.become_husk(TRAIT_GENERIC)
	else
		H.cure_husk()
	if(hairstyle)
		H.set_hair_style(hairstyle, FALSE)
	if(facial_hairstyle)
		H.set_facial_hair_style(facial_hairstyle, FALSE)
	if(skin_tone)
		H.skin_tone = skin_tone
	H.update_body()
	H.update_body_parts()
	if(outfit)
		var/static/list/slots = list("uniform", "r_hand", "l_hand", "suit", "shoes", "gloves", "ears", "glasses", "mask", "head", "belt", "r_pocket", "l_pocket", "back", "id", "neck", "backpack_contents", "suit_store")
		for(var/slot in slots)
			var/T = vars[slot]
			if(!isnum(T))
				outfit.vars[slot] = T
		H.equipOutfit(outfit)

//Instant version - use when spawning corpses during runtime
/obj/effect/mob_spawn/human/corpse
	roundstart = FALSE
	instant = TRUE

/obj/effect/mob_spawn/human/corpse/damaged
	brute_damage = 1000
	burn_damage = 1000
	oxy_damage = 500

/obj/effect/mob_spawn/human/corpse/damaged/briar

/obj/effect/mob_spawn/human/corpse/damaged/briar/equip(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/bodypart/ch = H.get_bodypart()
	if(!ch)
		return
	var/datum/wound/black_briar_curse/chest/wound = ch.add_wound(/datum/wound/black_briar_curse/chest, TRUE)
	if(!wound)
		return
	wound.infection = wound.max_infection
	wound.infection_percent = 1
	wound.dying = TRUE
	wound.die_in_agony(H, TRUE)

/obj/effect/mob_spawn/human/corpse/delayed
	ghost_usable = FALSE //These are just not-yet-set corpses.
	instant = FALSE
