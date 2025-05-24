/datum/orderless_slapcraft
	var/name = "Generic Recipe"
	var/category
	abstract_type = /datum/orderless_slapcraft

	///if set we read this incases of creating radials
	var/recipe_name
	var/obj/item/starting_item
	var/list/requirements = list()
	///if set we check for this at the end to finish crafting
	var/obj/item/finishing_item
	var/obj/item/output_item
	var/obj/item/hosted_source
	var/datum/skill/related_skill
	var/skill_xp_gained
	///tldr say you want mince and fish mince pies but don't want fish mince to work as a mince for mince pie set fallback on mince pies
	var/fallback = FALSE
	var/action_time = 3 SECONDS

	/// Quality tracking - list of ingredients and their qualities
	var/list/used_ingredients = list()
	/// Tracks the total freshness of ingredients
	var/total_freshness = 0
	/// Tracks number of ingredients with freshness
	var/ingredient_count = 0
	/// Tracks highest quality ingredient
	var/highest_quality = 0

/datum/orderless_slapcraft/New(loc, _source)
	. = ..()
	if(!_source)
		return
	hosted_source = _source
	RegisterSignal(hosted_source, COMSIG_PARENT_QDELETING, PROC_REF(early_end))
	// Initialize tracking lists
	used_ingredients = list()
	total_freshness = 0
	ingredient_count = 0
	highest_quality = 0

/datum/orderless_slapcraft/Destroy(force, ...)
	. = ..()
	hosted_source?.in_progress_slapcraft = null
	hosted_source = null
	used_ingredients = null

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

/datum/orderless_slapcraft/proc/try_process_item(obj/item/attacking_item, mob/user)
	var/return_value = FALSE
	var/short_cooktime = (action_time - ((user?.get_skill_level(related_skill)) * 5))

	// Track ingredient quality and freshness before processing
	track_ingredient_quality(attacking_item)

	for(var/obj/item/item as anything in requirements)
		if(islist(item))
			for(var/listed_item in item)
				if(!istype(attacking_item, listed_item))
					continue
				if(!do_after(user, short_cooktime, hosted_source))
					return
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
				requirements[item]--
				if(requirements[item] <= 0)
					requirements -= list(item) // See Remove() behavior documentation
				return_value = TRUE
				step_process(user, attacking_item)
				qdel(attacking_item)
				break

		if(istype(attacking_item, item))
			if(!do_after(user, short_cooktime, hosted_source))
				return
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			requirements[item]--
			if(requirements[item] <= 0)
				requirements -= item
			return_value = TRUE
			step_process(user, attacking_item)
			qdel(attacking_item)
			break

	if(!length(requirements) && !finishing_item)
		try_finish(user)
		return TRUE

	if(!length(requirements) && finishing_item && !QDELETED(attacking_item))
		if(!istype(attacking_item, finishing_item))
			return FALSE
		// Track the finishing item's quality as well
		track_ingredient_quality(attacking_item)
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		qdel(attacking_item)
		try_finish(user)
		return TRUE

	return return_value

/datum/orderless_slapcraft/proc/step_process(mob/user, obj/item/attacking_item)
	return

/datum/orderless_slapcraft/proc/track_ingredient_quality(obj/item/food_item)
	// Track the ingredient for quality calculation
	used_ingredients += food_item

	// Track freshness and quality
	if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
		ingredient_count++

		// Check warming value for freshness (higher means fresher)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/F = food_item
			total_freshness += max(0, (F.warming + F.rotprocess))
			highest_quality = max(highest_quality, F.quality)

		// Handle crops/grown items
		else if(istype(food_item, /obj/item/reagent_containers/food/snacks/produce))
			var/obj/item/reagent_containers/food/snacks/produce/G = food_item
			highest_quality = max(highest_quality, G.crop_quality - 1)

/datum/orderless_slapcraft/proc/try_finish(mob/user)
	var/turf/source_turf = get_turf(hosted_source)
	if(output_item)
		var/obj/item/reagent_containers/food/snacks/new_item = new output_item(source_turf)

		// Calculate average freshness
		var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

		// Get the user's cooking skill
		var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking)

		// Apply freshness to the new food item
		new_item.warming = min(5 MINUTES, average_freshness)

		// Calculate final quality based on ingredients, skill, and freshness
		var/final_quality = calculate_food_quality(cooking_skill, highest_quality, average_freshness)
		new_item.quality = round(final_quality)

		// Apply descriptive modifications based on quality
		apply_food_quality(new_item, final_quality)

		// Handle item-specific post-processing by passing used ingredients
		if(length(used_ingredients))
			new_item.CheckParts(used_ingredients)

		new_item.OnCrafted(user.dir, user)

	qdel(hosted_source)

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
	html += "[icon2html(new starting_item, user)] <strong class=class='scroll'>Start the process with [initial(starting_item.name)]</strong><br>"
	html += "<strong> then add </strong> <br>"
	for(var/atom/path as anything in requirements)
		var/count = requirements[path]
		if(islist(path))
			var/first = TRUE
			var/list/paths = path
			for(var/atom/sub_path as anything in paths)
				if(!first)
					html += "or <br>"
				html += "[icon2html(new sub_path, user)] [count] of any [initial(sub_path.name)]<br>"
				first = FALSE
		else
			html += "[icon2html(new path, user)] [count] of any [initial(path.name)]<br>"

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
