#define BLOOD_MARK_TYPE_CURSE "curse"
#define BLOOD_MARK_TYPE_TAG "tag"
#define BLOOD_MARK_TYPE_SHIELD "shield"
#define BLOOD_MARK_TYPE_BEFRIEND "befriend"
#define BLOOD_MARK_TYPE_MOVE "move"

#define BLOOD_MARK_CURSE list("name" = "Curse", "tag" = "C", "status_type" = BLOOD_MARK_TYPE_CURSE, "cooldown" = 3 MINUTES)
#define BLOOD_MARK_TAG list("name" = "Tag", "tag" = "T", "status_type" = BLOOD_MARK_TYPE_TAG, "cooldown" = 1.5 MINUTES)
#define BLOOD_MARK_SHIELD list("name" = "Curse Shield", "tag" = "S", "status_type" = BLOOD_MARK_TYPE_SHIELD, "cooldown" = 1.5 MINUTES)
#define BLOOD_MARK_BEFRIEND list("name" = "Befriend", "tag" = "F", "status_type" = BLOOD_MARK_TYPE_BEFRIEND, "cooldown" = 1 MINUTES)
#define BLOOD_MARK_MOVE list("name" = "Blood Shift", "tag" = "M", "status_type" = BLOOD_MARK_TYPE_MOVE, "cooldown" = 5 MINUTES)

/datum/action/cooldown/spell/status/blood_mark
	name = "Blood Mark"
	desc = "Apply various Blood Marks to a target, effects are variable."
	button_icon_state = "dream_mark"
	sound = 'sound/magic/psydonbleeds.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	invocation_type = INVOCATION_WHISPER
	invocation = "Sanguis nota"

	charge_required = FALSE
	cooldown_time = 3 MINUTES
	spell_cost = 200
	spell_flags = SPELL_UNETCHABLE
	status_effect = /datum/status_effect/debuff/blood_mark/curse
	self_cast_possible = TRUE

	var/mode_index = 1
	var/mode_status_type
	var/static/list/modes = list(
		BLOOD_MARK_CURSE,
		//BLOOD_MARK_TAG,
		BLOOD_MARK_SHIELD,
	)

	var/static/list/weaker_modes = list(
		BLOOD_MARK_CURSE,
		//BLOOD_MARK_TAG,
		BLOOD_MARK_SHIELD,
	)

	var/static/list/empowered_modes = list(
		BLOOD_MARK_CURSE,
		//BLOOD_MARK_TAG,
		BLOOD_MARK_SHIELD,
		BLOOD_MARK_BEFRIEND,
		//BLOOD_MARK_MOVE
	)

/datum/action/cooldown/spell/status/blood_mark/proc/empower()
	modes = empowered_modes
/datum/action/cooldown/spell/status/blood_mark/proc/weaken()
	modes = weaker_modes

/datum/action/cooldown/spell/status/blood_mark/Grant(mob/grant_to)
	. = ..()
	apply_mode(mode_index)

/datum/action/cooldown/spell/status/blood_mark/proc/apply_mode(index)
	var/list/mode = modes[index]
	mode_status_type = mode["status_type"]
	to_chat(owner, span_notice("[name]: [mode["name"]]"))
	owner.balloon_alert(owner, mode["name"])

	switch(mode_status_type)
		if(BLOOD_MARK_TYPE_CURSE)
			status_effect = /datum/status_effect/debuff/blood_mark/curse
			desc = "Mark a target with blood, weakening their physical traits. The Curse Mark will also prevent divine healing upon the target for its duration."
		if(BLOOD_MARK_TYPE_TAG)
			status_effect = /datum/status_effect/debuff/blood_mark/tag
			desc = "Mark a target with blood, allowing you to track them for its duration."
		if(BLOOD_MARK_TYPE_SHIELD)
			status_effect = /datum/status_effect/buff/blood_mark/curse_shield
			desc = "Mark a target with blood, protecting them from Blood Cursed objects."
		if(BLOOD_MARK_TYPE_BEFRIEND)
			status_effect = /datum/status_effect/buff/blood_mark/befriend
			desc = "Mark a target with blood, declaring them a friend to hemomancy."
		if(BLOOD_MARK_TYPE_MOVE)
			status_effect = /datum/status_effect/debuff/blood_mark
			desc = "Mark a target with blood, allowing you to transport yourself to them, or summon them to you."

	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/status/blood_mark/toggle_alt_mode(mob/user)
	mode_index = (mode_index % length(modes)) + 1
	apply_mode(mode_index)

/datum/action/cooldown/spell/status/blood_mark/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#b11212"
/**
 * Change this to be a spell with multiple types of mark.
 *
 * Curse - Current function
 * Tag - Locate them while it lasts ? Scrying
 * Anchor/Move - Either move to their location or have them move to you
 * Guard - Protect from Bloodcurse ? other protection
 * Friend - Toggled mark, add to FACTION_BLOOD
 */

/datum/action/cooldown/spell/status/blood_mark/is_valid_target(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE

	return validate_target(cast_on)

/datum/action/cooldown/spell/status/blood_mark/proc/validate_target(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_VITAE_USER))
		to_chat(owner, span_bloody("I cannot mark another master of Vitae!"))
		return FALSE
	var/can_self_cast = FALSE

	switch(mode_status_type)
		if(BLOOD_MARK_TYPE_CURSE)
			if(target.has_status_effect(/datum/status_effect/buff/blood_mark/curse_shield))
				to_chat(owner, span_bloody("[target] is shielded with a Blood Mark!"))
				return FALSE
			if(target.has_status_effect(/datum/status_effect/debuff/revive_bloodmagic))
				to_chat(owner, span_bloody("[target] already bears a Resurrection Curse, marking them will be pointless!"))
				return FALSE
			if(target.has_status_effect(/datum/status_effect/debuff/blood_mark/curse))
				to_chat(owner, span_bloody("[target] already bears a Curse Blood Mark!"))
				return FALSE
		if(BLOOD_MARK_TYPE_TAG)
			return FALSE
		if(BLOOD_MARK_TYPE_SHIELD)
			can_self_cast = TRUE
		if(BLOOD_MARK_TYPE_BEFRIEND)
			if(target.cleric)
				to_chat(owner, span_bloody("[target] is in service to their god, they cannot be trusted!"))
				return FALSE
		if(BLOOD_MARK_TYPE_MOVE)
			return FALSE

	if(!can_self_cast && (target == owner))
		to_chat(owner, span_bloody("You cannot place that mark upon yourself!"))
		return FALSE
	return TRUE

// ##########################################################################################
/datum/status_effect/buff/blood_mark
	id = "blood_mark_buf"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_mark
	duration = 5 MINUTES

/atom/movable/screen/alert/status_effect/buff/blood_mark
	name = "Blood Marked"
	desc = span_bloody("I have been marked by blood magic.")
	icon_state = "dream_mark_g"
	alert_group = ALERT_BUFF

// ##########################################################################################
/datum/status_effect/buff/blood_mark/befriend
	id = "blood_mark_friend_buf"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_mark/friend
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	var/activated = FALSE

/datum/status_effect/buff/blood_mark/befriend/on_apply()
	. = ..()
	if(!owner.has_faction(FACTION_BLOOD_MAGIC))
		activated = TRUE
		owner.add_faction(FACTION_BLOOD_MAGIC)

/datum/status_effect/buff/blood_mark/befriend/on_remove()
	if(activated)
		owner.remove_faction(FACTION_BLOOD_MAGIC)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/blood_mark/friend
	name = "Blood Marked (ALLY)"
	desc = span_bloody("I am known as a friend to those who wield sanguine power.")

// ##########################################################################################
/datum/status_effect/buff/blood_mark/curse_shield
	duration = 15 MINUTES
	id = "blood_mark_shield_buf"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_mark/shield

/atom/movable/screen/alert/status_effect/buff/blood_mark/shield
	name = "Blood Marked (CURSE SHIELD)"
	desc = span_bloody("I am protected from objects that are Blood Cursed.")

// ##########################################################################################
/datum/status_effect/debuff/blood_mark
	id = "blood_mark_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_mark
	duration = 5 MINUTES

/datum/status_effect/debuff/blood_mark/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/blood_mark)

/atom/movable/screen/alert/status_effect/debuff/blood_mark
	name = "Blood Marked"
	desc = span_bloody("I have been marked by blood magic.")
	icon_state = "dream_mark"
	alert_group = ALERT_DEBUFF

/datum/stress_event/blood_mark
	stress_change = 1
	desc = span_bloody("I have been marked by Blood Magic!")
	timer = 5 MINUTES

// ##########################################################################################
/datum/status_effect/debuff/blood_mark/curse
	id = "blood_mark_curse_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_mark/curse
	effectedstats = list(STAT_SPEED = -2, STAT_STRENGTH = -1, STAT_CONSTITUTION = -1, STAT_ENDURANCE = -1)

/atom/movable/screen/alert/status_effect/debuff/blood_mark/curse
	name = "Blood Marked (CURSE)"

// ##########################################################################################
/datum/status_effect/debuff/blood_mark/tag
	id = "blood_mark_tag_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_mark/tag

/atom/movable/screen/alert/status_effect/debuff/blood_mark/tag
	name = "Blood Tagged"
	desc = span_bloody("I am being tracked with Blood Magic!")
	icon_state = "blackeye"





#undef BLOOD_MARK_TYPE_CURSE
#undef BLOOD_MARK_TYPE_TAG
#undef BLOOD_MARK_TYPE_SHIELD
#undef BLOOD_MARK_TYPE_BEFRIEND
#undef BLOOD_MARK_TYPE_MOVE
#undef BLOOD_MARK_CURSE
#undef BLOOD_MARK_TAG
#undef BLOOD_MARK_SHIELD
#undef BLOOD_MARK_BEFRIEND
#undef BLOOD_MARK_MOVE
