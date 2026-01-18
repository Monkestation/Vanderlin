/obj/item/clothing/face/eyepatch
	name = "eyepatch"
	desc = "An eyepatch, fitted for the right eye."
	icon_state = "eyepatch"
	max_integrity = 20
	integrity_failure = 0.5
	block2add = FOV_RIGHT
	body_parts_covered = RIGHT_EYE
	resistance_flags = FLAMMABLE
	salvage_amount = 1

/obj/item/clothing/face/eyepatch/left
	desc = "An eyepatch, fitted for the left eye."
	icon_state = "eyepatch_l"
	block2add = FOV_LEFT
	body_parts_covered = LEFT_EYE

/obj/item/clothing/face/eyepatch/fake
	name = "eyepatch"
	desc = "A see-through eyepatch, fitted for the right eye."
	icon_state = "eyepatch"
	max_integrity = 20
	integrity_failure = 0.5
	body_parts_covered = RIGHT_EYE
	block2add = FALSE
	resistance_flags = FLAMMABLE
	salvage_amount = 1
