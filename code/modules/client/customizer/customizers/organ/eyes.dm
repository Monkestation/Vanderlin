/datum/customizer/organ/eyes
	abstract_type = /datum/customizer/organ/eyes
	name = "Eyes"

/datum/customizer_choice/organ/eyes
	abstract_type = /datum/customizer_choice/organ/eyes
	name = "Eyes"
	organ_type = /obj/item/organ/eyes
	organ_slot = ORGAN_SLOT_EYES
	customizer_entry_type = /datum/customizer_entry/organ/eyes
	organ_dna_type = /datum/organ_dna/eyes
	allows_accessory_color_customization = FALSE
	var/allows_heterochromia = TRUE

/datum/customizer_choice/organ/eyes/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/organ/eyes/eye_entry = entry
	var/picked_color = pick(EYE_COLOR_LIST)
	eye_entry.right_eye_color = picked_color
	eye_entry.left_eye_color = picked_color

/datum/customizer_choice/organ/eyes/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	eyes_entry.right_eye_color = sanitize_hexcolor(eyes_entry.right_eye_color, 6, TRUE, initial(eyes_entry.right_eye_color))
	eyes_entry.left_eye_color = sanitize_hexcolor(eyes_entry.left_eye_color, 6, TRUE, initial(eyes_entry.left_eye_color))

/datum/customizer_choice/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
    ..()
    var/datum/organ_dna/eyes/eyes_dna = organ_dna
    var/datum/customizer_entry/organ/eyes/eyes_entry = entry
    eyes_dna.eye_color = eyes_entry.right_eye_color
    eyes_dna.second_color = eyes_entry.left_eye_color

/datum/customizer_choice/organ/eyes/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	dat += "<br>Right Eye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=right_eye_color'><span class='color_holder_box' style='background-color:[eyes_entry.right_eye_color]'></span></a>"
	if(allows_heterochromia)
		dat += "<br>Left Eye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=left_eye_color'><span class='color_holder_box' style='background-color:[eyes_entry.left_eye_color]'></span></a>"

/datum/customizer_choice/organ/eyes/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	switch(href_list["customizer_task"])
		if("right_eye_color")
			var/new_color = input(user, "Choose your right eye color:", "Character Preference", eyes_entry.right_eye_color) as color|null
			if(!new_color)
				return
			eyes_entry.right_eye_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("left_eye_color")
			if(!allows_heterochromia)
				return
			var/new_color = input(user, "Choose your left eye color:", "Character Preference", eyes_entry.left_eye_color) as color|null
			if(!new_color)
				return
			eyes_entry.left_eye_color = sanitize_hexcolor(new_color, 6, TRUE)

/datum/customizer_entry/organ/eyes
	var/right_eye_color = "111111"
	var/left_eye_color = "111111"

/datum/customizer/organ/eyes/humanoid
	customizer_choices = list(/datum/customizer_choice/organ/eyes/humanoid)
	default_choice = /datum/customizer_choice/organ/eyes/humanoid

/datum/customizer_choice/organ/eyes/humanoid
	organ_type = /obj/item/organ/eyes
