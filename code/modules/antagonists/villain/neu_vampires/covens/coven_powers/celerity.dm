/datum/coven/celerity
	name = "Celerity"
	desc = "Boosts your speed. Violates Masquerade."
	icon_state = "celerity"
	power_type = /datum/coven_power/celerity

/datum/coven_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"
	var/multiplicative_slowdown = -0.5

/obj/effect/celerity
	name = "Afterimage"
	desc = "..."
	anchored = TRUE

/obj/effect/celerity/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

//CELERITY 1
/datum/coven_power/celerity/one
	name = "Celerity 1"
	desc = "Enhances your speed to make everything a little bit easier."

	level = 1
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five
	)

/datum/coven_power/celerity/one/activate()
	. = ..()
	owner.AddComponent(/datum/component/after_image)
	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -0.2)
	owner.apply_status_effect(/datum/status_effect/buff/celerity, level)

/datum/coven_power/celerity/one/deactivate()
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)

//CELERITY 2

/datum/coven_power/celerity/two
	name = "Celerity 2"
	desc = "Significantly improves your speed and reaction time."

	level = 2
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five
	)

/datum/coven_power/celerity/two/activate()
	. = ..()
	owner.AddComponent(/datum/component/after_image)

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -0.4)

/datum/coven_power/celerity/two/deactivate()
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)

//CELERITY 3
/datum/coven_power/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	level = 3
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five
	)

/datum/coven_power/celerity/three/activate()
	. = ..()
	owner.AddComponent(/datum/component/after_image)

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -0.5)

/datum/coven_power/celerity/three/deactivate()
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)

//CELERITY 4
/datum/coven_power/celerity/four
	name = "Celerity 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."

	level = 4
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/five
	)

/datum/coven_power/celerity/four/activate()
	. = ..()
	owner.AddComponent(/datum/component/after_image)

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -0.8)

/datum/coven_power/celerity/four/deactivate()
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)

//CELERITY 5
/datum/coven_power/celerity/five
	name = "Celerity 5"
	desc = "You are like light. Blaze your way through the world."

	level = 5
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four
	)

/datum/coven_power/celerity/five/activate()
	. = ..()
	owner.AddComponent(/datum/component/after_image)

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -1)

/datum/coven_power/celerity/five/deactivate()
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)
