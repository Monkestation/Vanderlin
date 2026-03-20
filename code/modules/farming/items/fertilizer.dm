/obj/item/fertilizer
	name = "generic fertilizer"
	desc = "A basic fertilizer."
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32

	var/nitrogen_content = 20
	var/phosphorus_content = 20
	var/potassium_content = 20

/obj/item/fertilizer/examine(mob/user)
	. = ..()
	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/labor/farming) >= 3)
		if(nitrogen_content)
			. += span_info("Restores [nitrogen_content] Nitrogen")
		if(phosphorus_content)
			. += span_info("Restores [phosphorus_content] Phosphorus")
		if(potassium_content)
			. += span_info("Restores [potassium_content] Potassium")

/obj/item/fertilizer/bone_meal
	name = "bone meal"
	desc = "Crushed bones, perfect for the garden."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "bonemeal"
	nitrogen_content = 5
	phosphorus_content = 45
	potassium_content = 10

/obj/item/fertilizer/compost
	name = "compost"
	desc = "Decomposed produce ready to give life to plants."
	icon = 'icons/roguetown/misc/composter.dmi'
	icon_state = "compost"
	nitrogen_content = 30
	phosphorus_content = 15
	potassium_content = 25

/obj/item/fertilizer/ash
	name = "ash"
	desc = "A handful of soot."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	w_class = WEIGHT_CLASS_TINY
	nitrogen_content = 0
	phosphorus_content = 20
	potassium_content = 50

/obj/item/fertilizer/ash/burn()
	if(resistance_flags & ON_FIRE)
		SSfire_burning.processing -= src
	deconstruct(FALSE)

/obj/item/fertilizer/ash/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			qdel(src)
