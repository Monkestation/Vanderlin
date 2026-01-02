/datum/customizer/organ/wings
	name = "Wings"
	abstract_type = /datum/customizer/organ/wings

/datum/customizer_choice/organ/wings
	name = "Wings"
	organ_type = /obj/item/organ/wings
	organ_slot = ORGAN_SLOT_WINGS
	abstract_type = /datum/customizer_choice/organ/wings

/obj/item/organ/wings/anthro
	name = "wild-kin wings"

/obj/item/organ/wings/flight/night_kin
	name = "Vampire Wings"
	accessory_type = /datum/sprite_accessory/wings/large/gargoyle

/datum/customizer/organ/wings/harpy
	customizer_choices = list(/datum/customizer_choice/organ/wings/harpy)
	allows_disabling = FALSE

/datum/customizer_choice/organ/wings/harpy
	name = "Wings"
	organ_type = /obj/item/organ/wings/flight/harpy
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/wings/large/harpyswept,
	)
