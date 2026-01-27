/obj/item/ore/dust
	name = "ore dust"
	icon_state = "dust"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32

/obj/item/ore/dust/Initialize(mapload)
	. = ..()
	if(melting_material)
		color = initial(melting_material.color)

/obj/item/ore/dust/set_quality(quality)
	..()
	mill_yield_bonus = (recipe_quality - 1) * 0.3

/obj/item/ore/dust/gold
	name = "gold dust"
	desc = "Fine particles of gold ore."
	melting_material = /datum/material/gold

/obj/item/ore/dust/silver
	name = "silver dust"
	desc = "Fine particles of silver ore."
	melting_material = /datum/material/silver

/obj/item/ore/dust/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/ore/dust/iron
	name = "iron dust"
	desc = "Fine particles of iron ore."
	melting_material = /datum/material/iron

/obj/item/ore/dust/copper
	name = "copper dust"
	desc = "Fine particles of copper ore."
	melting_material = /datum/material/copper

/obj/item/ore/dust/tin
	name = "tin dust"
	desc = "Fine particles of tin ore."
	melting_material = /datum/material/tin
