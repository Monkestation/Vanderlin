/datum/customizer/organ/snout
	abstract_type = /datum/customizer/organ/snout
	name = "Snout"

/datum/customizer_choice/organ/snout
	abstract_type = /datum/customizer_choice/organ/snout
	name = "Snout"
	organ_type = /obj/item/organ/snout
	organ_slot = ORGAN_SLOT_SNOUT

/datum/customizer/organ/snout/beak
	name = "Beak"
	customizer_choices = list(/datum/customizer_choice/organ/snout/beak)

/datum/customizer_choice/organ/snout/beak
	name = "Beak"
	organ_type = /obj/item/organ/snout/beak
	sprite_accessories = list(
		/datum/sprite_accessory/snout/bird,
		/datum/sprite_accessory/snout/bigbeak,
		/datum/sprite_accessory/snout/bigbeakshort,
		/datum/sprite_accessory/snout/slimbeak,
		/datum/sprite_accessory/snout/slimbeakshort,
		/datum/sprite_accessory/snout/slimbeakalt,
		/datum/sprite_accessory/snout/hookbeak,
		/datum/sprite_accessory/snout/hookbeakbig,
	)

/datum/customizer/organ/snout/beak/thin
	name = "Thin Beak"
	customizer_choices = list(/datum/customizer_choice/organ/snout/beak/thin)

/datum/customizer_choice/organ/snout/beak/thin
	name = "Thin Beak"
	organ_type = /obj/item/organ/snout/beak
	allows_accessory_color_customization = FALSE
	default_accessory = /datum/sprite_accessory/snout/thin_beak/slimbeak
	sprite_accessories = list(
		/datum/sprite_accessory/snout/thin_beak/bigbeak,
		/datum/sprite_accessory/snout/thin_beak/bigbeakshort,
		/datum/sprite_accessory/snout/thin_beak/slimbeak,
		/datum/sprite_accessory/snout/thin_beak/slimbeakshort,
		/datum/sprite_accessory/snout/thin_beak/slimbeakalt,
		/datum/sprite_accessory/snout/thin_beak/hookbeak,
		/datum/sprite_accessory/snout/thin_beak/hookbeakbig,
	)


