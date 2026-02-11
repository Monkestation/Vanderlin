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
	var/skill = /datum/skill/craft/crafting

/datum/pottery_recipe/proc/get_delay(mob/user, rotations_per_minute)
	rotations_per_minute = max(1, rotations_per_minute)
	var/time = step_to_time[1]
	var/skill_level = max(1, user?.get_skill_level(skill, TRUE))

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
	var/skill_level = max(0, user?.get_skill_level(skill, TRUE))
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
	var/amt2raise = (user.STAINT * 0.5) + (difficulty * 2)

	user?.mind?.add_sleep_experience(skill, amt2raise, FALSE)

	if(!length(recipe_steps))
		return TRUE

/datum/pottery_recipe/proc/finish(mob/living/user)
	var/amt2raise = (user.STAINT * 2) + (difficulty * 10)
	user?.mind?.add_sleep_experience(skill, amt2raise, FALSE)
	return TRUE

/datum/pottery_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;

			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			.icon {
				width: 64px;
				height: 64px;
				vertical-align: middle;
				margin-right: 10px;
			}
		</style>
		<body>
		  <div>
		    <h1>[name]</h1>
		    <div>
		      <h2>Requirements</h2>
			  <br>
			  <strong>Rotational Sweetspot: [speed_sweetspot]</strong>
			  <br>
		"}
	var/number = 0
	for(var/atom/path as anything in recipe_steps)
		number++
		html += "[icon2html(new path, user)] Add [initial(path.name)] to the Lathe.<br>"
		html += "Then spin for [step_to_time[number] / 10] Seconds.<br>"

	html += "<br>"
	html += "icon2html(new created_item, user)] <strong class=class='scroll'>and then you get [initial(created_item.name)]. </strong><br>"

	html += {"
		</div>
		<div>
		"}


	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/pottery_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")
