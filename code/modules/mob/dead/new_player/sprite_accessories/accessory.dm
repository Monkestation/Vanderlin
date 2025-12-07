
/datum/sprite_accessory/accessories
	name = ""
	icon_state = null
	gender = NEUTER
	icon = 'icons/roguetown/mob/accessories.dmi'
	use_static = TRUE
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/rakshari
	name = ""
	icon = 'icons/mob/sprite_accessory/accessory/rakshari.dmi'
	gender = NEUTER
	use_static = TRUE
	specuse = list(SPEC_ID_RAKSHARI)

/datum/sprite_accessory/accessories/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/accessories/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE)


/datum/sprite_accessory/accessories/nothing
	name = "Nothing"
	icon_state = "nothing"
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/earrings/sil
	name = "Earrings"
	icon_state = "earrings_sil"
	gender = FEMALE
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/earrings
	name = "Earrings (G)"
	icon_state = "earrings"
	gender = FEMALE
	relevant_layers = list(BODY_FRONT_LAYER)
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/earrings/em
	name = "Earrings (E)"
	icon_state = "earrings_em"
	gender = FEMALE
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/choker
	name = "Neckband"
	icon_state = "choker"
	gender = FEMALE
	specuse = list(SPEC_ID_ELF)

/datum/sprite_accessory/accessories/chokere
	name = "Neckband (E)"
	icon_state = "chokere"
	gender = FEMALE
	specuse = list(SPEC_ID_ELF)

/datum/sprite_accessory/accessories/eyepierce
	name = "Pierced Brow (L)"
	icon_state = "eyepierce"
	gender = FEMALE
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/accessories/eyepierce/alt
	name = "Pierced Brow (R)"
	icon_state = "eyepiercealt"
	gender = FEMALE
	specuse = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_ELF)

/datum/sprite_accessory/accessories/rakshari
	abstract_type = /datum/sprite_accessory/accessories/rakshari
	specuse = list(SPEC_ID_RAKSHARI)

/datum/sprite_accessory/accessories/rakshari/gilded_g
	name = "Gilded (G)"
	icon_state = "gilded_g"

/datum/sprite_accessory/accessories/rakshari/cat_earrings_g
	name = "Cat Earrings (G)"
	icon_state = "cat_earrings_g"

/datum/sprite_accessory/accessories/rakshari/gilded_s
	name = "Gilded (S)"
	icon_state = "gilded_s"

/datum/sprite_accessory/accessories/rakshari/cat_earrings_s
	name = "Cat Earrings (S)"
	icon_state = "cat_earrings_s"
