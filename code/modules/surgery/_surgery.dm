/datum/surgery
	abstract_type = /datum/surgery
	/// Name of the surgical procedure
	var/name = "surgery"
	/// Description of the surgical procedure
	var/desc = ""
	/// Category for book
	var/category = "Surgery"

	/// Bitfield for flags that determine different behaviors and requirement for the surgery. See __DEFINES/surgery.dm
	var/surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB
	///The surgery step we're currently on, increases each time we do a step.
	var/status = 1
	///All steps the surgery has to do to complete.
	var/list/steps = list()
	///Boolean on whether a surgery step is currently being done, to prevent multi-surgery.
	var/step_in_progress = FALSE

	///The bodypart this specific surgery is being performed on.
	var/location = BODY_ZONE_CHEST
	/// Acceptable body zones
	var/list/possible_locs = list()
	/// Acceptable mob types
	var/list/target_mobtypes = list(/mob/living/carbon/human)
	/// Intents that can be used to perform this surgery step
	var/list/possible_intents

	/// Skill used to perform this surgery
	var/datum/skill/skill_used = /datum/skill/misc/medicine
	/// Necessary skill MINIMUM to perform this surgery, of skill_used
	var/skill_min = SKILL_LEVEL_NOVICE
	/// Skill median used to apply success and speed bonuses
	var/skill_median = SKILL_LEVEL_JOURNEYMAN

	///The person the surgery is being performed on. Funnily enough, it isn't always a carbon.
	VAR_FINAL/mob/living/carbon/target
	///The specific bodypart being operated on.
	VAR_FINAL/obj/item/bodypart/operated_bodypart
	///The wound datum that is being operated on.
	VAR_FINAL/datum/wound/operated_wound

	///Types of wounds this surgery can target.
	var/datum/wound/targetable_wound = null
	///The types of bodyparts that this surgery can have performed on it. Used for augmented surgeries.
	var/requires_bodypart_type = BODYPART_ORGANIC

	/// Organ being directly manipulated, used for checking if the organ is still in the body after surgery has begun
	var/organ_to_manipulate = null

	/// Will the church kill us
	var/heretical = FALSE

/datum/surgery/New(atom/surgery_target, surgery_location, surgery_bodypart)
	. = ..()
	if(!surgery_target)
		return

	target = surgery_target
	LAZYADD(target.surgeries, src)

	if(surgery_location)
		location = surgery_location

	if(!surgery_bodypart)
		return

	operated_bodypart = surgery_bodypart
	if(targetable_wound)
		operated_wound = operated_bodypart.has_wound(targetable_wound)
		operated_wound.attached_surgery = src

	SEND_SIGNAL(surgery_target, COMSIG_MOB_SURGERY_STARTED, src, surgery_location, surgery_bodypart)

/datum/surgery/Destroy()
	if(operated_wound)
		operated_wound.attached_surgery = null
		operated_wound = null

	if(target)
		LAZYREMOVE(target.surgeries, src)
		if(!QDELING(target))
			SEND_SIGNAL(target, COMSIG_MOB_SURGERY_FINISHED, type, location, operated_bodypart)

	target = null
	operated_bodypart = null
	return ..()

/datum/surgery/proc/can_start(mob/user, mob/living/patient, obj/item/tool, feedback = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	var/surgery_signal = SEND_SIGNAL(user, COMSIG_SURGERY_STARTING, src, patient)
	if(surgery_signal & COMPONENT_FORCE_SURGERY)
		return TRUE
	if(surgery_signal & COMPONENT_CANCEL_SURGERY)
		return FALSE

	if(IS_IN_INVALID_SURGICAL_POSITION(patient, src))
		if(feedback)
			patient.balloon_alert(user, "patient is not lying down!")
		return FALSE

	if(!is_type_in_list(patient, target_mobtypes))
		if(feedback)
			patient.balloon_alert(user, "can't operate on this creature!")
		return FALSE

	var/selected_zone = user.zone_selected

	if(!(selected_zone in possible_locs))
		if(feedback)
			patient.balloon_alert(user, "can't operate there!")
		return FALSE

	for(var/datum/surgery/surgery in patient.surgeries)
		if(surgery.location == selected_zone)
			if(feedback)
				patient.balloon_alert(user, "already operating there!")
			return FALSE

	var/obj/item/bodypart/affecting_limb = patient.get_bodypart(check_zone(selected_zone))

	if((surgery_flags & SURGERY_REQUIRE_LIMB) && isnull(affecting_limb))
		if(feedback)
			patient.balloon_alert(user, "patient has no [parse_zone(selected_zone)]!")
		return FALSE

	if(isnull(affecting_limb))
		if(surgery_flags & SURGERY_REQUIRE_LIMB)
			if(feedback)
				patient.balloon_alert(user, "needs a limb!")
			return FALSE
	else
		if(requires_bodypart_type && (affecting_limb.status != requires_bodypart_type))
			if(feedback)
				patient.balloon_alert(user, "not the right type of limb!")
			return FALSE
		if(targetable_wound && !affecting_limb.has_wound(targetable_wound))
			if(feedback)
				patient.balloon_alert(user, "no wound to operate on!")
			return FALSE
		if(organ_to_manipulate && !target.getorganslot(organ_to_manipulate))
			if(feedback)
				patient.balloon_alert(user, "missing organ!")
			return FALSE

	if(!(surgery_flags & SURGERY_IGNORE_CLOTHES) && !get_location_accessible(patient, user.zone_selected))
		patient.balloon_alert(user, "expose [patient.p_their()] [parse_zone(selected_zone)]!")
		return FALSE

	return TRUE

/datum/surgery/proc/can_next_step(mob/living/user, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)

	if(!(user.zone_selected in possible_locs))
		return FALSE

	var/surgery_type = steps[status]
	var/datum/surgery_step/surgery_step = new surgery_type()

	if(!surgery_step)
		return FALSE

	var/obj/item/tool = user.get_active_held_item()
	if(tool)
		tool = tool.get_proxy_attacker_for(target, user)

	if(!surgery_step.is_implement(user, tool))
		return FALSE

	return TRUE

/datum/surgery/proc/next_step(mob/living/user, list/modifiers)
	if(step_in_progress)
		return TRUE

	if(!can_next_step(user, modifiers))
		return FALSE

	var/try_to_fail = FALSE
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		try_to_fail = TRUE
	else if(!target.stat == DEAD && user.get_skill_level(skill_used) < skill_min)
		try_to_fail = TRUE // If you don't have the skill it will fail always

	var/obj/item/tool = user.get_active_held_item()
	if(tool)
		tool = tool.get_proxy_attacker_for(target, user)

	var/surgery_type = steps[status]
	var/datum/surgery_step/surgery_step = new surgery_type()

	if(surgery_step.try_op(user, target, user.zone_selected, tool, src, try_to_fail))
		return TRUE

	if(!tool)
		return FALSE

	// Just because you used the wrong tool it doesn't mean you meant to whack the patient with it
	if((surgery_flags & SURGERY_CHECK_TOOL_BEHAVIOUR) ? tool.tool_behaviour : (tool.item_flags & SURGICAL_TOOL))
		to_chat(user, span_warning("This step requires a different tool!"))
		return TRUE

	return FALSE

/datum/surgery/proc/get_surgery_next_step()
	if(status < length(steps))
		var/step_type = steps[status + 1]
		return new step_type
	return null

/datum/surgery/proc/complete(mob/living/surgeon)
	SSblackbox.record_feedback("tally", "surgeries_completed", 1, type)
	var/exp = (surgeon.STAINT * 0.75) * (0.15 * length(steps))
	surgeon.mind?.add_sleep_experience(skill_used, exp)
	qdel(src)

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

	if(surgery_flags & SURGERY_REQUIRE_LIMB)
		html += "<div class='section'><b>**Requires bodypart to be present**</b></div>"
	else
		html += "<div class='section'><b>**Requires bodypart to be MISSING**</b></div>"

	if(surgery_flags & SURGERY_REQUIRES_REAL_LIMB)
		html += "<div class='section'><b>**Cannot be performed on prosthetics**</b></div>"

	if(requires_bodypart_type && requires_bodypart_type != BODYPART_ORGANIC)
		html += "<div class='section'><b>Can only be done on prosthetic limbs.</div>"

	if(organ_to_manipulate)
		html += "<div class='section'><b>Required Organ: [organ_to_manipulate]"
		html += "</div>"

	if(targetable_wound)
		html += "<div class='section'><b>Required Wound: [targetable_wound::name]"
		html += "</div>"

	if(skill_used && skill_min)
		var/datum/skill/used_skill = skill_used
		var/skill_name = initial(used_skill.name)
		html += "<div class='step-info'><b>Minimum Experience:</b> [SSskills.level_names[skill_min]] [skill_name]</div>"
		html += "<div class='step-info'><b>Optimal Experience:</b> [SSskills.level_names[skill_median]] [skill_name]</div>"

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

	if(length(step.chems_needed))
		html += "<div class='step-info'><b>Chemicals Required:</b><br>"
		html += "[step.get_chem_list()]<br>"
		html += "</div>"

	var/list/flags = list()

	if(step.repeatable)
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
