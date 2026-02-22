/datum/molten_recipe
	abstract_type = /datum/molten_recipe
	var/name = "Generic Molten Recipe"
	var/category = "Metallurgy"

	var/list/materials_required = list()
	var/list/output = list()

	var/temperature_required

/datum/molten_recipe/proc/try_create(list/reagent_data, temperature)
	if(temperature < temperature_required)
		return FALSE

	var/list/materials_copy = materials_required.Copy()

	var/list/cared_values = list()
	for(var/item in reagent_data)
		if(!(item in materials_copy))
			continue
		cared_values |= item
		cared_values[item] = reagent_data[item]

	if(!length(cared_values) == length(materials_required))
		return

	var/smallest_multiplier = 0
	for(var/datum/material/material as anything in materials_copy)
		if(cared_values[material] < materials_copy[material])
			return
		var/multiplier = FLOOR(cared_values[material] / materials_copy[material], 1)
		if(!smallest_multiplier || (multiplier < smallest_multiplier))
			smallest_multiplier = multiplier

	return smallest_multiplier


/datum/molten_recipe/proc/generate_html(mob/user)
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
		"}
	for(var/atom/path as anything in materials_required)
		var/count = materials_required[path]
		html += "[count] parts Molten [initial(path.name)]<br>"
	html += "<br>"
	html += "Heated to: [temperature_required - 273.15] Celcius<br>"

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

/datum/molten_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")

/datum/molten_recipe/bronze
	name = "Bronze"
	materials_required = list(
		/datum/material/copper = 9,
		/datum/material/tin = 1,
	)
	temperature_required = 1423.15
	output = list(
		/datum/material/bronze = 10,
	)

/datum/molten_recipe/blacksteel
	name = "Blacksteel"
	materials_required = list(
		/datum/material/steel = 6,
		/datum/material/silver = 4,
	)
	temperature_required = 1953.15
	output = list(
		/datum/material/blacksteel = 10,
	)
