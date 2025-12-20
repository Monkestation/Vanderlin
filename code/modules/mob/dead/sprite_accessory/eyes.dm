/datum/sprite_accessory/eyes
	abstract_type = /datum/sprite_accessory/eyes
	color_keys = 2
	color_key_names = list("First Eye", "Second Eye")
	icon = 'icons/mob/sprite_accessory/eyes/eyes.dmi'

/datum/sprite_accessory/eyes/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner)
		return
	if(NOEYESPRITES in owner.dna?.species?.species_traits)
		return FALSE
	return is_human_part_visible(owner, HIDEEYES)

/datum/sprite_accessory/eyes/adjust_appearance_list(list/appearance_list, obj/item/organ/eyes/eyes, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, eyes, bodypart, owner, OFFSET_FACE)

/datum/sprite_accessory/eyes/humanoid
	name = "Humanoid Eyes"
	icon_state = "human"

/datum/sprite_accessory/eyes/humanoid/kobold
	name = "Kobold Eyes"
	icon_state = "kobold"

/datum/sprite_accessory/eyes/humanoid/triton
	name = "Triton Eyes"
	icon_state = "triton"
	use_static = TRUE

/datum/sprite_accessory/eyes/humanoid/rakshari
	name = "Rakshari Eyes"
	icon_state = "rakshari"
	use_static = TRUE
