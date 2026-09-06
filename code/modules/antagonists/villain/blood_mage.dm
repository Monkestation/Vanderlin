
/datum/antagonist/blood_mage
	name = "Blood Mage"
	antagpanel_category = "Blood Mages"
	roundend_category = "Blood Mages"
	show_name_in_check_antagonists = TRUE
	increase_votepwr = TRUE
	antag_hud_type = ANTAG_HUD_BLOOD_MAGE
	antag_hud_name = "bloodmage"

/datum/antagonist/blood_mage/sorcerer
	name = "Blood Sorcerer"
	antag_hud_name = "bloodsorc"

/datum/antagonist/blood_mage/student
	name = "Blood Magic Apprentice"
	antag_hud_name = "bloodapp"

/datum/antagonist/blood_mage/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
			to_chat(world, "[the_name] was a [name].")
	return
