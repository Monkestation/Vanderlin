/obj/item/organ/neck_feature
	abstract_type = /obj/item/organ/neck_feature
	name = "neck feature"
	visible_organ = TRUE
	organ_flags = parent_type::organ_flags | ORGAN_EXTERNAL

	zone = BODY_ZONE_PRECISE_NECK
	slot = ORGAN_SLOT_NECK_FEATURE
	organ_efficiency = list(ORGAN_SLOT_NECK_FEATURE = 100)

/obj/item/organ/neck_feature/medicator
	name = "medicator fluff"
	desc = "It's slimy..."
	accessory_type = /datum/sprite_accessory/neck_feature/fluff/medicator
