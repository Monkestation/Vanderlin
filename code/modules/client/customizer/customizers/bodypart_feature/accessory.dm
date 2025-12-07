/datum/customizer/bodypart_feature/face_detail
	name = "Face Detail"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/face_detail)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/face_detail
	name = "Face Detail"
	feature_type = /datum/bodypart_feature/face_detail
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/detail/nothing,
		/datum/sprite_accessory/detail/burnface_r,
		/datum/sprite_accessory/detail/burnface_l,
		/datum/sprite_accessory/detail/burneye_r,
		/datum/sprite_accessory/detail/burneye_l,
		/datum/sprite_accessory/detail/brows,
		/datum/sprite_accessory/detail/brows/dark,
		/datum/sprite_accessory/detail/unibrow,
		/datum/sprite_accessory/detail/unibrow/dark,
		/datum/sprite_accessory/detail/deadeye_r,
		/datum/sprite_accessory/detail/deadeye_l,
		/datum/sprite_accessory/detail/scarhead,
		/datum/sprite_accessory/detail/scar,
		/datum/sprite_accessory/detail/scart,
		/datum/sprite_accessory/detail/slashedeye_r,
		/datum/sprite_accessory/detail/slashedeye_l,
		/datum/sprite_accessory/detail/mangled,
		/datum/sprite_accessory/detail/warpaint_blue,
		/datum/sprite_accessory/detail/warpaint_red,
		/datum/sprite_accessory/detail/warpaint_green,
		/datum/sprite_accessory/detail/warpaint_purple,
		/datum/sprite_accessory/detail/warpaint_black,
		/datum/sprite_accessory/detail/harlequin,
		/datum/sprite_accessory/detail/tattoo_lips,
		/datum/sprite_accessory/detail/tattoo_eye_r,
		/datum/sprite_accessory/detail/tattoo_eye_l,
	)

/datum/customizer/bodypart_feature/accessory
	name = "Accessory"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/accessory)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer/bodypart_feature/accessory/is_allowed(datum/preferences/prefs)
	. = ..()
	if(prefs.age == AGE_CHILD)
		return FALSE

/datum/customizer_choice/bodypart_feature/accessory
	name = "Accessory"
	feature_type = /datum/bodypart_feature/accessory
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/accessories/nothing,
		/datum/sprite_accessory/accessories/earrings/sil,
		/datum/sprite_accessory/accessories/earrings,
		/datum/sprite_accessory/accessories/earrings/em,
		/datum/sprite_accessory/accessories/choker,
		/datum/sprite_accessory/accessories/chokere,
		/datum/sprite_accessory/accessories/eyepierce,
		/datum/sprite_accessory/accessories/eyepierce/alt,
	)

/datum/customizer/bodypart_feature/accessory/rakshari
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/accessory/rakshari)

/datum/customizer_choice/bodypart_feature/accessory/rakshari
	name = "Accessory"
	feature_type = /datum/bodypart_feature/accessory
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
	/datum/sprite_accessory/accessories/rakshari/gilded_g,
	/datum/sprite_accessory/accessories/rakshari/cat_earrings_g,
	/datum/sprite_accessory/accessories/rakshari/gilded_s,
	/datum/sprite_accessory/accessories/rakshari/cat_earrings_s,
	)
