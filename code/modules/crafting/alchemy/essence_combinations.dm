
/datum/essence_combination
	abstract_type = /datum/essence_combination
	var/category = "Essence Combination"
	var/name = "essence combination"
	var/list/inputs = list() // essence_type = amount_needed
	var/datum/thaumaturgical_essence/output_type = null
	var/output_amount = 1
	var/skill_required = SKILL_LEVEL_NOVICE


/datum/essence_combination/proc/generate_html(mob/user)
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
			.requirements {
				margin-bottom: 20px;
			}
			.category {
				font-style: italic;
				color: #8d6e63;
				margin-bottom: 10px;
			}
			.skill {
				margin-top: 15px;
				font-style: italic;
				color: #5d4037;
			}
		</style>
		<body>
		  <div>
			<h1>[name]</h1>
			<div class="category">[category]</div>
			<div class="requirements">
			  <h2>Required Essences</h2>
	"}

	// Add input essences
	if(length(inputs))
		for(var/datum/thaumaturgical_essence/essence_type as anything in inputs)
			var/essence_amount = inputs[essence_type]
			html += "[essence_amount] parts [essence_type.name]<br>"
	else
		html += "No essences required<br>"

	html += {"
		</div>
		<div>
			<h2>Creates</h2>
	"}

	// Add output
	if(output_type)
		html += "[output_amount] [initial(output_type.name)]<br>"
	else
		html += "No output specified<br>"

	if(skill_required)
		html += "<div class='skill'><strong>Skill Required:</strong> [skill_required]</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}

	return html

/datum/essence_combination/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=essence_combination;size=500x810")

// Tier 1 combinations (Basic essences -> First Compound)
/datum/essence_combination/frost
	name = "Frost Essence"
	inputs = list(
		/datum/thaumaturgical_essence/air = 2,
		/datum/thaumaturgical_essence/water = 2
	)
	output_type = /datum/thaumaturgical_essence/frost
	output_amount = 3

/datum/essence_combination/light
	name = "Light Essence"
	inputs = list(
		/datum/thaumaturgical_essence/fire = 2,
		/datum/thaumaturgical_essence/order = 2
	)
	output_type = /datum/thaumaturgical_essence/light
	output_amount = 3

/datum/essence_combination/motion
	name = "Motion Essence"
	inputs = list(
		/datum/thaumaturgical_essence/air = 2,
		/datum/thaumaturgical_essence/chaos = 2
	)
	output_type = /datum/thaumaturgical_essence/motion
	output_amount = 3

/datum/essence_combination/cycle
	name = "Cycle Essence"
	inputs = list(
		/datum/thaumaturgical_essence/water = 2,
		/datum/thaumaturgical_essence/earth = 2
	)
	output_type = /datum/thaumaturgical_essence/cycle
	output_amount = 3

/datum/essence_combination/energia
	name = "Energia Essence"
	inputs = list(
		/datum/thaumaturgical_essence/fire = 2,
		/datum/thaumaturgical_essence/chaos = 2,
	)
	output_type = /datum/thaumaturgical_essence/energia
	output_amount = 3

/datum/essence_combination/void
	name = "Void Essence"
	inputs = list(
		/datum/thaumaturgical_essence/chaos = 2,
		/datum/thaumaturgical_essence/earth = 2,
	)
	output_type = /datum/thaumaturgical_essence/void
	output_amount = 3

/datum/essence_combination/poison
	name = "Poison Essence"
	inputs = list(
		/datum/thaumaturgical_essence/chaos = 2,
		/datum/thaumaturgical_essence/water = 2,
	)
	output_type = /datum/thaumaturgical_essence/poison
	output_amount = 3

/datum/essence_combination/life
	name = "Life Essence"
	inputs = list(
		/datum/thaumaturgical_essence/water = 2,
		/datum/thaumaturgical_essence/order = 2,
	)
	output_type = /datum/thaumaturgical_essence/life
	output_amount = 3

/datum/essence_combination/crystal
	name = "Crystal Essence"
	inputs = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/order = 2,
	)
	output_type = /datum/thaumaturgical_essence/crystal
	output_amount = 3

// Tier 2 combinations (First Compound -> Second Compound)
/datum/essence_combination/magic
	name = "Magic Essence"
	inputs = list(
		/datum/thaumaturgical_essence/energia = 2,
		/datum/thaumaturgical_essence/void = 2,
		/datum/thaumaturgical_essence/order = 1,
	)
	output_type = /datum/thaumaturgical_essence/magic
	output_amount = 2
	skill_required = SKILL_LEVEL_JOURNEYMAN

/datum/essence_combination/death
	name = "Death Essence"
	inputs = list(
		/datum/thaumaturgical_essence/void = 4,
		/datum/thaumaturgical_essence/poison = 2,
		/datum/thaumaturgical_essence/chaos = 2,
	)
	output_type = /datum/thaumaturgical_essence/death
	output_amount = 2
	skill_required = SKILL_LEVEL_JOURNEYMAN
