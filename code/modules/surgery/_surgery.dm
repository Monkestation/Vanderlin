/datum/surgery
	abstract_type = /datum/surgery
	var/category = "Surgery"
	/// Name of the surgical procedure
	var/name = "surgery"
	/// Description of the surgical procedure
	var/desc = ""
	/// Steps to be performed in order
	var/list/steps = list()
	/// Acceptable mob types
	var/list/target_mobtypes = list(/mob/living/carbon/human)
	/// Acceptable body zones
	var/list/possible_locs = list()
	/// Surgery available only when a bodypart is present
	var/requires_bodypart = TRUE
	/// Surgery available only when a bodypart is missing
	var/requires_missing_bodypart = FALSE
	/// Surgery not available on pseudoparts
	var/requires_real_bodypart = FALSE
	/// Acceptable limb statuses
	var/requires_bodypart_type = BODYPART_ORGANIC
	///will the church kill us
	var/heretical = FALSE

/datum/surgery/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	if(heretical)
		desc = "<div style='color: red;'><b>HERETICAL RESEARCH</b></div>" + desc
	var/html = {"
		<!DOCTYPE html>
		<html>
		<head>
			<link rel="stylesheet" type="text/css" href="slop_menustyle2.css">
		</head>
		<body>
			<div class='book'>
				<div class='page'>
					<h1>[name]</h1>
					<div class='info'>
						<p class='desc'>[desc]</p>
						<h2>Requirements</h2>
					</div>
	"}

	if(requires_bodypart)
		html += "<div class='section'><b>**Requires bodypart to be present**</b></div>"
	if(requires_missing_bodypart)
		html += "<div class='section'><b>**Requires bodypart to be MISSING**</b></div>"
	if(requires_real_bodypart)
		html += "<div class='section'><b>**Cannot be performed on prosthetics**</b></div>"
	if(requires_bodypart_type && requires_bodypart_type != BODYPART_ORGANIC)
		html += "<div class='section'><b>Can only be done on prosthetic limbs.</div>"

	if(length(steps))
		html += "<div class='section'><h2>Procedure Steps</h2>"
		var/step_num = 1
		for(var/datum/surgery_step/step as anything in steps)
			var/datum/surgery_step/new_step = new step()
			html += generate_step_html(new_step, step_num, user)
			qdel(new_step)
			step_num++
		html += "</div>"

	html += {"
				</div>
			</div>
		</body>
		</html>
	"}

	return html

/datum/surgery/proc/generate_step_html(datum/surgery_step/step, step_num, mob/user)
	var/html = "<div class='step-section'>"
	html += "<h3>Step [step_num]: [step.name]</h3>"

	if(step.desc)
		html += "<p class='step-desc'>[step.desc]</p>"

	if(length(step.implements))
		html += "<div class='step-info'><b>Tools Required (Success Rate):</b><br>"
		for(var/tool in step.implements)
			var/success_rate = step.implements[tool]
			var/tool_name = tool
			if(ispath(tool))
				var/atom/atom_path = tool
				tool_name = initial(atom_path.name)
			else
				tool_name = "any [tool_name]"
			html += "[tool_name] ([success_rate]%)<br>"
		html += "</div>"

	if(step.accept_hand)
		html += "<div class='step-info'><b>Can be performed with bare hands</b></div>"
	if(step.accept_any_item)
		html += "<div class='step-info'><b>Accepts any item</b></div>"

	if(step.skill_used && step.skill_min)
		var/datum/skill/used_skill = step.skill_used
		var/skill_name = initial(used_skill.name)
		html += "<div class='step-info'><b>Minimum Experience:</b> [SSskills.level_names[step.skill_min]] [skill_name]</div>"
		html += "<div class='step-info'><b>Optimal Experience:</b> [SSskills.level_names[step.skill_median]] [skill_name]</div>"

	if(length(step.chems_needed))
		html += "<div class='step-info'><b>Chemicals Required:</b><br>"
		var/chem_string = step.get_chem_string()
		html += "[chem_string]<br>"
		html += "</div>"

	if(length(step.required_organs))
		html += "<div class='step-info'><b>Required Organs:</b><br>"
		for(var/organ in step.required_organs)
			html += "• [organ]<br>"
		html += "</div>"
	var/list/flags = list()
	/*
	if(step.surgery_flags & SURGERY_BLOODY) //this is on EVERYTHING
		flags += "Bloody procedure"
	*/
	if(step.surgery_flags & SURGERY_INCISED)
		flags += "Requires incision"
	if(step.surgery_flags & SURGERY_RETRACTED)
		flags += "Requires retraction"
	if(step.surgery_flags & SURGERY_CLAMPED)
		flags += "Requires clamping"
	if(step.surgery_flags & SURGERY_DISLOCATED)
		flags += "Requires dislocation"
	if(step.surgery_flags & SURGERY_BROKEN)
		flags += "Requires broken bodypart"
	if(step.surgery_flags & SURGERY_DRILLED)
		flags += "Requires drilling"
	if(step.lying_required)
		flags += "Patient must be lying down"
	if(!step.self_operable)
		flags += "Cannot self-operate"
	if(step.ignore_clothes)
		flags += "Ignores clothing"
	if(step.repeating)
		flags += "Repeatable until failure"

	if(length(flags))
		html += "<div class='step-info'><b>Special Requirements:</b><br>"
		for(var/flag in flags)
			html += "• [flag]<br>"
		html += "</div>"

	html += "</div><hr>"

	return html

/datum/surgery/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=surgery;size=600x900")
