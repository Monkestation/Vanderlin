/obj/effect/mob_spawn
	abstract_type = /obj/effect/mob_spawn
	name = "Mob Spawner"
	density = TRUE
	anchored = TRUE
	//So it shows up in the map editor
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "mobspawner"

	///A forced name of the mob, though can be overridden if a special name is passed as an argument
	var/mob_name
	///the type of the mob, you best inherit this
	var/mob_type = /mob/living/simple_animal/pet/cat/black
	///Lazy string list of factions that the spawned mob will be in upon spawn
	var/list/faction
	///Weakref to spawned mob

	//Human specific stuff. Don't set these if you aren't using a human, the unit tests will put a stop to your sinful hand.

	///sets the human as a species, use a typepath (example: /datum/species/skeleton)
	var/mob_species
	///job to pull stats and an outfit from, DOES NOT EquipRank. Outfit below overrides job outfit.
	var/datum/job/equipment_job
	///equips the human with an outfit.
	var/datum/outfit/outfit
	///for mappers to override parts of the outfit. really only in here for secret away missions, please try to refrain from using this out of laziness
	var/list/outfit_override
	/// Randomise DNA appearance if possible
	var/randomise_dna = FALSE
	///sets a human's hairstyle
	var/hairstyle
	///sets a human's facial hair
	var/facial_hairstyle
	///sets a human's hair color (use special for gradients, sorry)
	var/haircolor
	///sets a human's facial hair color
	var/facial_haircolor
	///sets a human's skin tone
	var/skin_tone

/obj/effect/mob_spawn/Initialize(mapload)
	. = ..()
	if(faction)
		faction = string_list(faction)
	if(!ispath(mob_type, /mob/living))
		stack_trace("[src] has a non living mob type!")

/**
 * Creates whatever mob the spawner makes.
 *
 * * mob_possessor - The ghost/mob that is possessing this mob, if applicable
 * * newname - A forced name for the mob, if applicable
 * * apply_prefs - Whether we should apply the possessor's preferences to the mob, if applicable
 *
 * Returns
 * - the created mob
 * - CANCEL_SPAWN if the spawn process should be stopped
 * - null if the spawn failed (and something went wrong)
 */
/obj/effect/mob_spawn/proc/create(mob/mob_possessor, newname, apply_prefs)
	SHOULD_NOT_SLEEP(TRUE)

	var/mob/living/spawned_mob = new mob_type(get_turf(src)) //living mobs only
	special(spawned_mob, mob_possessor)
	name_mob(spawned_mob, newname)
	equip(spawned_mob)
	return spawned_mob

/**
 * Any special behavior that needs to be done to the mob after it's created but before it's equipped.
 *
 * * spawned_mob - The mob that was created
 * * mob_possessor - The ghost/mob that is possessing this mob, if applicable
 * * apply_prefs - Whether we should apply the possessor's preferences to the mob, if applicable
 */
/obj/effect/mob_spawn/proc/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	SHOULD_CALL_PARENT(TRUE)

	if(faction)
		spawned_mob.faction = faction

	if(!ishuman(spawned_mob))
		return

	var/mob/living/carbon/human/spawned_human = spawned_mob
	if(mob_species)
		spawned_human.set_species(mob_species)

	spawned_human.underwear = "Nude"
	spawned_human.undershirt = "Nude"
	spawned_human.socks = "Nude"

	if(randomise_dna && spawned_human.dna?.species)
		spawned_human.dna.species.random_character(spawned_human)
		return

/obj/effect/mob_spawn/proc/name_mob(mob/living/spawned_mob, forced_name)
	var/chosen_name
	//passed arguments on mob spawns are number one priority
	if(forced_name)
		chosen_name = forced_name
	//then the mob name var
	else if(mob_name)
		chosen_name = mob_name
	//then if no name was chosen the one the mob has by default works great
	if(!chosen_name)
		return
	//not using an old name doesn't update records- but ghost roles don't have records so who cares
	spawned_mob.fully_replace_character_name(null, chosen_name)

/obj/effect/mob_spawn/proc/equip(mob/living/spawned_mob)
	if(!ishuman(spawned_mob))
		return

	var/mob/living/carbon/human/spawned_human = spawned_mob
	var/datum/outfit/outfit_used

	if(equipment_job)
		var/datum/job/real_job = SSjob.GetJobType(equipment_job)
		if(real_job)
			if(spawned_human.gender == FEMALE && real_job.outfit_female)
				outfit_used = real_job.outfit_female
			else
				outfit_used = real_job.outfit

			// Sadly job copy pasta to not spam after_spawn with mostly dead calls

			// Add traits, skills and stats of job
			for(var/trait in real_job.traits)
				ADD_TRAIT(spawned_human, trait, JOB_TRAIT)

			for(var/datum/skill/skill as anything in real_job.skills)
				var/amount_or_list = real_job.skills[skill]
				if(islist(amount_or_list))
					spawned_human.clamped_adjust_skillrank(skill, amount_or_list[1], amount_or_list[2], TRUE)
				else
					spawned_human.adjust_skillrank(skill, amount_or_list, TRUE)

			spawned_mob.adjust_stat_modifier_list(STATMOD_JOB, real_job.jobstats)

	if(outfit)
		outfit_used = outfit

	if(!outfit_used)
		return

	if(outfit_override)
		outfit_used = new outfit_used //create it now to apply vars
		for(var/outfit_var in outfit_override)
			if(!ispath(outfit_override[outfit_var]) && !isnull(outfit_override[outfit_var]))
				CRASH("outfit_override var on [mob_name] spawner has incorrect values! it must be an assoc list with outfit \"var\" = path | null")
			outfit_used.vars[outfit_var] = outfit_override[outfit_var]

	spawned_human.equipOutfit(outfit_used)
