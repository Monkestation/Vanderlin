/datum/pottery_recipe
	abstract_type = /datum/pottery_recipe
	var/category = "Pottery"
	var/name
	///the thing created by the recipe
	var/atom/created_item
	///the steps we need and the thing we need
	var/list/recipe_steps = list(
		/obj/item/natural/clay
	)
	///I HATE THAT THIS IS A THING, it exists because alists will not like 2 of the same key existing
	var/list/step_to_time = list(
		4 SECONDS
	)
	///more of this it has a chance of failing the step and the time to work on it is increased
	var/speed_sweetspot = 8
	///difficulty of recipe
	var/difficulty = 0
	var/skill = /datum/attribute/skill/craft/crafting

/datum/pottery_recipe/proc/get_delay(mob/user, rotations_per_minute)
	rotations_per_minute = max(1, rotations_per_minute)
	var/time = step_to_time[1]
	var/skill_level = max(1, GET_MOB_SKILL_VALUE_OLD(user, skill))

	if(rotations_per_minute < speed_sweetspot)
		time *= ((speed_sweetspot / rotations_per_minute) * 0.25)

	if(rotations_per_minute > speed_sweetspot)
		time += (rotations_per_minute - speed_sweetspot) * 2

	time /= skill_level
	return time

/datum/pottery_recipe/proc/next_step(obj/item)
	if(!istype(item, recipe_steps[1]))
		return FALSE
	return TRUE

/datum/pottery_recipe/proc/update_step(mob/living/user, rotations_per_minute)
	var/skill_level = max(0, GET_MOB_SKILL_VALUE_OLD(user, skill))
	var/success_chance = 25 * ((skill_level - difficulty) + 1)
	success_chance = clamp(success_chance, 5, 95) // No reason to block pottery with lower skills, just make it not worth the time.

	if(rotations_per_minute > speed_sweetspot)
		success_chance -= (rotations_per_minute - speed_sweetspot) * 2
	if(!prob(success_chance))
		if(user.client?.prefs.showrolls)
			to_chat(user,span_danger("I've messed up \the [name]. (Success chance: [success_chance]%)"))
			return
		to_chat(user, span_danger("I've messed up \the [name]"))
		return

	recipe_steps.Cut(1,2)
	step_to_time.Cut(1,2)
	var/amt2raise = (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.5) + (difficulty * 2)

	user?.mind?.add_sleep_experience(skill, amt2raise, FALSE)

	if(!length(recipe_steps))
		return TRUE

/datum/pottery_recipe/proc/finish(mob/living/user)
	var/amt2raise = (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 2) + (difficulty * 10)
	user?.mind?.add_sleep_experience(skill, amt2raise, FALSE)
	return TRUE
