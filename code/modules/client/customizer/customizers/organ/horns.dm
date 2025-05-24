/obj/item/organ/horns
	name = "horns"
	desc = "A severed pair of horns. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_HORNS

/obj/item/organ/horns/tiefling
	name = "tiefling horns"
	accessory_type = /datum/sprite_accessory/horns/tiefling

/obj/item/organ/horns/humanoid

/obj/item/organ/horns/triton
	name = "triton horns"
	accessory_type = /datum/sprite_accessory/horns/triton

/datum/customizer/organ/horns
	abstract_type = /datum/customizer/organ/horns
	name = "Horns"

/datum/customizer_choice/organ/horns
	abstract_type = /datum/customizer_choice/organ/horns
	name = "Horns"
	organ_type = /obj/item/organ/horns
	organ_slot = ORGAN_SLOT_HORNS
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/horns/humanoid
	customizer_choices = list(/datum/customizer_choice/organ/horns/humanoid)
	allows_disabling = TRUE

/datum/customizer/organ/horns/humanoid/sissean
	default_disabled = TRUE

/datum/customizer_choice/organ/horns/humanoid
	name = "Horns"
	organ_type = /obj/item/organ/horns/humanoid
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/horns/simple,
		/datum/sprite_accessory/horns/short,
		/datum/sprite_accessory/horns/curled,
		/datum/sprite_accessory/horns/ram,
		/datum/sprite_accessory/horns/angler,
		/datum/sprite_accessory/horns/guilmon,
		/datum/sprite_accessory/horns/uni,
		/datum/sprite_accessory/horns/oni,
		/datum/sprite_accessory/horns/oni_large,
		/datum/sprite_accessory/horns/broken,
		/datum/sprite_accessory/horns/rbroken,
		/datum/sprite_accessory/horns/lbroken,
		/datum/sprite_accessory/horns/drake,
		/datum/sprite_accessory/horns/knight,
		/datum/sprite_accessory/horns/antlers,
		/datum/sprite_accessory/horns/ramalt,
		/datum/sprite_accessory/horns/smallantlers,
		/datum/sprite_accessory/horns/curledramhorns,
		/datum/sprite_accessory/horns/curledramhornsalt,
		/datum/sprite_accessory/horns/smallramhorns,
		/datum/sprite_accessory/horns/smallramhornsalt,
		/datum/sprite_accessory/horns/smallramhornsthree,
		/datum/sprite_accessory/horns/liftedhorns,
		/datum/sprite_accessory/horns/sideswept,
		/datum/sprite_accessory/horns/bigcurlyhorns,
		/datum/sprite_accessory/horns/billberry,
		/datum/sprite_accessory/horns/stabbers,
		/datum/sprite_accessory/horns/unihorn,
		/datum/sprite_accessory/horns/longhorns,
		/datum/sprite_accessory/horns/outstretched,
		/datum/sprite_accessory/horns/halo,
		/datum/sprite_accessory/horns/greathorns,
		/datum/sprite_accessory/horns/bunhorns,
		/datum/sprite_accessory/horns/marauder,
		/datum/sprite_accessory/horns/faceguard,
		/datum/sprite_accessory/horns/sheephorns,
		/datum/sprite_accessory/horns/doublehorns,
		/datum/sprite_accessory/horns/tiefling
		)

/datum/customizer/organ/horns/demihuman
	customizer_choices = list(/datum/customizer_choice/organ/horns/demihuman)
	allows_disabling = TRUE
	default_disabled =  TRUE

/datum/customizer_choice/organ/horns/demihuman
	name = "Horns"
	organ_type = /obj/item/organ/horns
	sprite_accessories = list(
		/datum/sprite_accessory/horns/simple,
		/datum/sprite_accessory/horns/short,
		/datum/sprite_accessory/horns/curled,
		/datum/sprite_accessory/horns/ram,
//		/datum/sprite_accessory/horns/guilmon,				Quality control removal ; Will not be re-added until sprites are improved.
		/datum/sprite_accessory/horns/uni,
		/datum/sprite_accessory/horns/oni,
		/datum/sprite_accessory/horns/oni_large,
		/datum/sprite_accessory/horns/broken,
		/datum/sprite_accessory/horns/rbroken,
		/datum/sprite_accessory/horns/lbroken,
		/datum/sprite_accessory/horns/drake,
//		/datum/sprite_accessory/horns/knight,				QC
		/datum/sprite_accessory/horns/antlers,
		/datum/sprite_accessory/horns/ramalt,
		/datum/sprite_accessory/horns/smallantlers,
		/datum/sprite_accessory/horns/curledramhorns,
		/datum/sprite_accessory/horns/curledramhornsalt,
		/datum/sprite_accessory/horns/smallramhorns,
		/datum/sprite_accessory/horns/smallramhornsalt,
		/datum/sprite_accessory/horns/smallramhornsthree, //This is a fucking angler fish????
		/datum/sprite_accessory/horns/liftedhorns,
		/datum/sprite_accessory/horns/sideswept,
//		/datum/sprite_accessory/horns/bigcurlyhorns,		QC
//		/datum/sprite_accessory/horns/billberry,			QC
		/datum/sprite_accessory/horns/stabbers,
		/datum/sprite_accessory/horns/unihorn,
		/datum/sprite_accessory/horns/longhorns,
		/datum/sprite_accessory/horns/outstretched,
		/datum/sprite_accessory/horns/halo,
		/datum/sprite_accessory/horns/greathorns,
		/datum/sprite_accessory/horns/bunhorns,
		/datum/sprite_accessory/horns/marauder,
		/datum/sprite_accessory/horns/faceguard,
//		/datum/sprite_accessory/horns/sheephorns,			Ears in horns. Doesn't fit.
		/datum/sprite_accessory/horns/doublehorns,
//		/datum/sprite_accessory/horns/tiefling				Hollowkin aren't tieflings.
		)

/datum/customizer/organ/horns/anthro
	customizer_choices = list(/datum/customizer_choice/organ/horns/anthro)
	allows_disabling = TRUE
	default_disabled =  TRUE

/datum/customizer_choice/organ/horns/anthro
	name = "Horns"
	organ_type = /obj/item/organ/horns
	sprite_accessories = list(
		/datum/sprite_accessory/horns/simple,
		/datum/sprite_accessory/horns/short,
		/datum/sprite_accessory/horns/curled,
		/datum/sprite_accessory/horns/ram,
		/datum/sprite_accessory/horns/guilmon,
		/datum/sprite_accessory/horns/uni,
		/datum/sprite_accessory/horns/oni,
		/datum/sprite_accessory/horns/oni_large,
		/datum/sprite_accessory/horns/broken,
		/datum/sprite_accessory/horns/rbroken,
		/datum/sprite_accessory/horns/lbroken,
		/datum/sprite_accessory/horns/drake,
		/datum/sprite_accessory/horns/knight,
		/datum/sprite_accessory/horns/antlers,
		/datum/sprite_accessory/horns/ramalt,
		/datum/sprite_accessory/horns/smallantlers,
		/datum/sprite_accessory/horns/curledramhorns,
		/datum/sprite_accessory/horns/curledramhornsalt,
		/datum/sprite_accessory/horns/smallramhorns,
		/datum/sprite_accessory/horns/smallramhornsalt,
		/datum/sprite_accessory/horns/smallramhornsthree,
		/datum/sprite_accessory/horns/liftedhorns,
		/datum/sprite_accessory/horns/sideswept,
		/datum/sprite_accessory/horns/bigcurlyhorns,
		/datum/sprite_accessory/horns/billberry,
		/datum/sprite_accessory/horns/stabbers,
		/datum/sprite_accessory/horns/unihorn,
		/datum/sprite_accessory/horns/longhorns,
		/datum/sprite_accessory/horns/outstretched,
		/datum/sprite_accessory/horns/halo,
		/datum/sprite_accessory/horns/greathorns,
		/datum/sprite_accessory/horns/bunhorns,
		/datum/sprite_accessory/horns/marauder,
		/datum/sprite_accessory/horns/faceguard,
		/datum/sprite_accessory/horns/sheephorns,
		/datum/sprite_accessory/horns/doublehorns,
		/datum/sprite_accessory/horns/tiefling
		)

/datum/customizer/organ/horns/tiefling
	customizer_choices = list(/datum/customizer_choice/organ/horns/tiefling)
	allows_disabling = FALSE

/datum/customizer_choice/organ/horns/tiefling
	name = "Horns"
	organ_type = /obj/item/organ/horns
	sprite_accessories = list(
		/datum/sprite_accessory/horns/tiefling,
		/datum/sprite_accessory/horns/tiefling/alt,
		/datum/sprite_accessory/horns/simple,
		/datum/sprite_accessory/horns/short,
		/datum/sprite_accessory/horns/curled,
		/datum/sprite_accessory/horns/ram,
		/datum/sprite_accessory/horns/oni,
		/datum/sprite_accessory/horns/oni_large,
		/datum/sprite_accessory/horns/broken,
		/datum/sprite_accessory/horns/rbroken,
		/datum/sprite_accessory/horns/lbroken,
		/datum/sprite_accessory/horns/drake,
		/datum/sprite_accessory/horns/antlers,
		/datum/sprite_accessory/horns/ramalt,
		/datum/sprite_accessory/horns/smallantlers,
		/datum/sprite_accessory/horns/liftedhorns,
		/datum/sprite_accessory/horns/sideswept,
		/datum/sprite_accessory/horns/bigcurlyhorns,
		/datum/sprite_accessory/horns/stabbers,
		/datum/sprite_accessory/horns/unihorn,
		/datum/sprite_accessory/horns/outstretched,
		/datum/sprite_accessory/horns/halo,
		/datum/sprite_accessory/horns/marauder,
		/datum/sprite_accessory/horns/faceguard,
		/datum/sprite_accessory/horns/doublehorns,
	)
