/obj/item/organ/horns
	name = "horns"
	desc = "A severed pair of horns. What did you cut this off of?"
	icon_state = "horns" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_HORNS
	organ_efficiency = list(ORGAN_SLOT_HORNS = 100)
	gender = PLURAL

/obj/item/organ/horns/humanoid

/obj/item/organ/horns/tiefling
	accessory_type = /datum/sprite_accessory/horns/tiefling

/obj/item/organ/horns/triton
	name = "triton tusks"
	accessory_type = /datum/sprite_accessory/horns/triton

/obj/item/organ/horns/demihuman
