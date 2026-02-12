/datum/customizer/organ/tail
	name = "Tail"
	abstract_type = /datum/customizer/organ/tail

/datum/customizer_choice/organ/tail
	name = "Tail"
	organ_type = /obj/item/organ/tail
	organ_slot = ORGAN_SLOT_TAIL
	abstract_type = /datum/customizer_choice/organ/tail

/obj/item/organ/tail/tiefling
	accessory_type = /datum/sprite_accessory/tail/tiefling

/datum/customizer/organ/tail/tiefling
	customizer_choices = list(/datum/customizer_choice/organ/tail/tiefling)
	allows_disabling = FALSE

/datum/customizer_choice/organ/tail/tiefling
	name = "Tail"
	organ_type = /obj/item/organ/tail/tiefling
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/tiefling,
		)

/datum/customizer/organ/tail/demihuman
	customizer_choices = list(/datum/customizer_choice/organ/tail/demihuman)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tail/demihuman
	name = "Hollow-Kin Tail"
	organ_type = /obj/item/organ/tail
	generic_random_pick = TRUE
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
//		/datum/sprite_accessory/tail/axolotl,		Clipping issues.
		/datum/sprite_accessory/tail/batl,			//Clipping - Ook request to remain.
		/datum/sprite_accessory/tail/bats,			//Clipping - Ook request to remain.
//		/datum/sprite_accessory/tail/bee,			Clipping
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
//		/datum/sprite_accessory/tail/corvid,		For harpies instead?
		/datum/sprite_accessory/tail/cow,
//		/datum/sprite_accessory/tail/eevee,			Clipping
		/datum/sprite_accessory/tail/fennec,
//		/datum/sprite_accessory/tail/fish,			Clipping
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,			//Clipping - Ook request to keep in.
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
//		/datum/sprite_accessory/tail/insect,		Clipping
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
//		/datum/sprite_accessory/tail/lab,			Bad quality.
		/datum/sprite_accessory/tail/murid,
//		/datum/sprite_accessory/tail/orca,			Clipping
//		/datum/sprite_accessory/tail/otie,			Clipping
		/datum/sprite_accessory/tail/rabbit,		//Clipping - Ook request to keep in.
//		/datum/sprite_accessory/tail/redpanda,		Clipping + intrusive
//		/datum/sprite_accessory/tail/pede,			Clipping
		/datum/sprite_accessory/tail/shark,
//		/datum/sprite_accessory/tail/shepherd,		Clipping
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/skunk,
//		/datum/sprite_accessory/tail/stripe,		Clipping
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
//		/datum/sprite_accessory/tail/guilmon,		Clipping
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
//		/datum/sprite_accessory/tail/spade,			Clipping also should be tief exclusive.
//		/datum/sprite_accessory/tail/leopard,		Clipping
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/rattlesnake
		)

/datum/customizer/organ/tail/harpy
	customizer_choices = list(/datum/customizer_choice/organ/tail/harpy)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tail/harpy
	name = "Harpy Plumage"
	organ_type = /obj/item/organ/tail
	generic_random_pick = TRUE
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/hawk,
	)

/datum/customizer/organ/tail/triton
	customizer_choices = list(/datum/customizer_choice/organ/tail/triton)
	allows_disabling = FALSE

/datum/customizer_choice/organ/tail/triton
	name = "Triton Bell"
	organ_type = /obj/item/organ/tail/triton
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/triton,
	)

/datum/customizer/organ/tail/kobold
	customizer_choices = list(/datum/customizer_choice/organ/tail/kobold)
	allows_disabling = FALSE

/datum/customizer_choice/organ/tail/kobold
	name = "Kobold Tail"
	organ_type = /obj/item/organ/tail/kobold
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/kobold,
		/datum/sprite_accessory/tail/kobold/alt,
	)

/datum/customizer/organ/tail/medicator
	customizer_choices = list(/datum/customizer_choice/organ/tail/medicator)
	allows_disabling = FALSE

/datum/customizer_choice/organ/tail/medicator
	name = "Medicator Plumage"
	organ_type = /obj/item/organ/tail/medicator
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/medicator
	)
