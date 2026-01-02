/datum/orderless_slapcraft
	var/name = "Generic Recipe"
	var/category
	abstract_type = /datum/orderless_slapcraft

	///if set we read this incases of creating radials
	var/recipe_name
	/// The object that needs to be attacked for each step. Does not get deducted from requirements.
	var/obj/item/starting_item
	var/list/requirements = list()
	///if set we check for this at the end to finish crafting
	var/obj/item/finishing_item
	///Keep null if you don't want the hosted_source to be deleted at the end of the recipe
	var/obj/item/output_item
	var/obj/item/hosted_source
	var/datum/skill/related_skill
	var/skill_xp_gained
	var/action_time = 3 SECONDS
	///list of atoms we pass to the output item
	var/list/atoms_to_pass = list()

/datum/orderless_slapcraft/New(loc, _source)
	. = ..()
	if(!_source)
		return
	hosted_source = _source
	RegisterSignal(hosted_source, COMSIG_PARENT_QDELETING, PROC_REF(early_end))

/datum/orderless_slapcraft/Destroy(force, ...)
	. = ..()
	UnregisterSignal(hosted_source, COMSIG_PARENT_QDELETING)
	hosted_source?.in_progress_slapcraft = null
	QDEL_LIST(atoms_to_pass)

/datum/orderless_slapcraft/proc/early_end()
	qdel(src)

/datum/orderless_slapcraft/proc/check_start(obj/item/attacking_item, obj/item/attacked_item, mob/user)
	if(!istype(attacked_item, starting_item))
		return FALSE
	for(var/obj/item/item as anything in requirements)
		if(islist(item))
			for(var/listed_item in item)
				if(istype(attacking_item, listed_item))
					return TRUE
		if(istype(attacking_item, item))
			return TRUE
	return FALSE

/datum/orderless_slapcraft/proc/get_action_time(obj/item/attacking_item, mob/user)
	return action_time

/// Return FALSE to qdel attacking_item. Return TRUE if otherwise.
/datum/orderless_slapcraft/proc/before_process_item(obj/item/attacking_item, mob/user)
	return

/// Return FALSE to qdel attacking_item. Return TRUE if otherwise.
/datum/orderless_slapcraft/proc/process_finishing_item(obj/item/attacking_item, mob/user)
	return

/datum/orderless_slapcraft/proc/try_process_item(obj/item/attacking_item, mob/user)
	var/return_value = FALSE
	var/modified_action_time = get_action_time(attacking_item, user)

	for(var/requirement as anything in requirements)
		if(islist(requirement))
			for(var/listed_item in requirement)
				if(!istype(attacking_item, listed_item))
					continue
				if(!do_after(user, modified_action_time, hosted_source))
					return
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
				requirements[requirement]--
				if(requirements[requirement] <= 0)
					requirements -= list(requirement) // See Remove() behavior documentation
				return_value = TRUE
				var/keep_item = before_process_item(attacking_item, user)
				step_process(user, attacking_item)
				if(keep_item)
					attacking_item.forceMove(locate(1,1,1))
				else
					qdel(attacking_item)
				break

		if(istype(attacking_item, requirement))
			if(!do_after(user, modified_action_time, hosted_source))
				return
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			requirements[requirement]--
			if(requirements[requirement] <= 0)
				requirements -= requirement
			return_value = TRUE
			var/keep_item = before_process_item(attacking_item, user)
			step_process(user, attacking_item)
			if(keep_item)
				attacking_item.forceMove(locate(1,1,1))
			else
				qdel(attacking_item)
			break

	if(!length(requirements) && !finishing_item)
		try_finish(user)
		return TRUE

	if(!length(requirements) && finishing_item && !QDELETED(attacking_item))
		if(!istype(attacking_item, finishing_item))
			return FALSE
		var/keep_item = process_finishing_item(attacking_item, user)
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		if(keep_item)
			attacking_item.forceMove(locate(1,1,1))
		else
			qdel(attacking_item)
		try_finish(user)
		return TRUE

	return return_value

/datum/orderless_slapcraft/proc/step_process(mob/user, obj/item/attacking_item)
	return

/datum/orderless_slapcraft/proc/try_finish(mob/user)
	user.adjust_experience(related_skill, skill_xp_gained)
	if(related_skill == /datum/skill/craft/cooking)
		user.nobles_seen_servant_work()
	var/turf/source_turf = get_turf(hosted_source)
	if(output_item)
		var/obj/item/new_item = new output_item(source_turf)

		handle_output_item(user, new_item)

		// Handle item-specific post-processing by passing used ingredients
		if(length(atoms_to_pass))
			new_item.CheckParts(atoms_to_pass)

		new_item.OnCrafted(user.dir, user)
		qdel(hosted_source)
	else
		handle_output_item(user, hosted_source)
		// Handle item-specific post-processing by passing used ingredients
		if(length(atoms_to_pass))
			hosted_source.CheckParts(atoms_to_pass)

		hosted_source.OnCrafted(user.dir, user)

/datum/orderless_slapcraft/proc/handle_output_item(mob/user, obj/item/new_item)
	to_chat(user, span_notice("You finish crafting [new_item]"))
	return

/mob/living/proc/try_orderless_slapcraft(obj/item/attacking_item, obj/item/attacked_object)
	if(!isitem(attacked_object))
		return list()
	if(attacked_object.in_progress_slapcraft)
		return attacked_object.in_progress_slapcraft.try_process_item(attacking_item, src)

	if(!(attacked_object.type in GLOB.orderless_slapcraft_recipes))
		return list()
	var/list/recipes = GLOB.orderless_slapcraft_recipes[attacked_object.type]
	var/list/passed_recipes = list()

	for(var/datum/orderless_slapcraft/recipe in recipes)
		if(!recipe.check_start(attacking_item, attacked_object, src))
			continue
		passed_recipes |= recipe

	if(!length(passed_recipes))
		return list()

	return passed_recipes

/datum/orderless_slapcraft/proc/generate_html(mob/user)
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
		"}
	html += "<strong>With the use of [related_skill.name] skill:</strong><br>"
	html += "[icon2html(new starting_item, user)] <strong class=class='scroll'>Start the process with [initial(starting_item.name)]</strong><br>"
	html += "<strong> then add </strong> <br><hr>"
	for(var/atom/path as anything in requirements)
		var/count = requirements[path]
		if(islist(path))
			var/first = TRUE
			var/list/paths = path
			html += "up to [count] of<br>"
			for(var/atom/sub_path as anything in paths)
				if(!first)
					html += "or <br>"
				html += "[icon2html(new sub_path, user)] any [initial(sub_path.name)]<br>"
				first = FALSE
		else
			html += "[icon2html(new path, user)] [count] of any [initial(path.name)]<br>"
		html += "<hr>"

	html += {"
		</div>
		<div>
		"}

	if(finishing_item)
		html += "[icon2html(new finishing_item, user)] <strong class=class='scroll'>finish with any [initial(finishing_item.name)]</strong> <br>"


	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/orderless_slapcraft/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")
