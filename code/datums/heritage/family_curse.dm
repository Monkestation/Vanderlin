/datum/family_curse
	var/name
	var/description
	var/curse_type
	var/severity = 1 // 1–3
	var/inherited = TRUE
	var/tmp/datum/weakref/cursed_by
	var/when_cursed
	var/blessing = FALSE
	var/list/curse_effects = list()

/atom/movable/screen/alert/status_effect/family_curse/Click(location, control, params)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(!user.family_datum)
		return

	var/curse_info = ""
	for(var/datum/family_curse/curse in user.family_datum.family_curses)
		curse_info += "<b>[curse.name]</b><br>[curse.description]<br>"
		if(curse.cursed_by)
			var/mob/curser = curse.cursed_by.resolve()
			if(curser)
				curse_info += "[curse.blessing ? "Blessed" : "Cursed"] by: [curser.real_name]<br>"
		curse_info += "Severity: [curse.severity]/3<br>"
		curse_info += "Time cursed: [DisplayTimeText(world.time - curse.when_cursed)] ago<br>"

	if(!curse_info)
		return
	var/datum/browser/popup = new(usr, "curse_info", "Family Modifier Details", 300, 200)
	popup.set_content(curse_info)
	popup.open()


/datum/family_curse/misfortune
	name = "Family Misfortune"
	description = "Bad luck follows this bloodline"
	curse_effects = list(/datum/status_effect/misfortune)

/datum/status_effect/misfortune
	id = "family_misfortune"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/misfortune
	effectedstats = list(STAT_FORTUNE = -2)

/atom/movable/screen/alert/status_effect/family_curse/misfortune
	name = "Family Misfortune"
	desc = "Your family's curse brings ill fortune to your steps."
	icon_state = "debuff"

	var/static/list/misfortune_tips = list(
		"Dark clouds seem to follow you wherever you go...",
		"You feel the weight of your family's curse.",
		"Even simple tasks seem to go wrong more often.",
		"The fates seem to conspire against you.",
		"Your ancestors' misdeeds continue to haunt you."
	)

/atom/movable/screen/alert/status_effect/family_curse/misfortune/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(desc == initial(desc))
		desc = "[initial(desc)] [pick(misfortune_tips)]"

/datum/family_curse/hunger
	name = "Insatiable Appetite"
	description = "This bloodline is voracious in its hunger."
	curse_effects = list(/datum/status_effect/hunger)

/datum/status_effect/hunger
	id = "family_hunger"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/hunger

/datum/status_effect/hunger/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.dna.species.nutrition_mod += 1.1

/atom/movable/screen/alert/status_effect/family_curse/hunger
	name = "Insatiable Appetite"
	desc = "Your family is cursed with a hunger that is rarely sated."
	icon_state = "debuff"
