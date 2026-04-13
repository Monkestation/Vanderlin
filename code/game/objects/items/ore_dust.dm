/obj/item/ore/dust
	name = "ore dust"
	icon_state = "dust"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	item_weight = 300 GRAMS

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
	item_weight = 500 GRAMS

/obj/item/ore/dust/silver
	name = "silver dust"
	desc = "Fine particles of silver ore."
	melting_material = /datum/material/silver
	item_weight = 400 GRAMS

/obj/item/ore/dust/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/ore/dust/iron
	name = "iron dust"
	desc = "Fine particles of iron ore."
	melting_material = /datum/material/iron
	item_weight = 350 GRAMS

/obj/item/ore/dust/copper
	name = "copper dust"
	desc = "Fine particles of copper ore."
	melting_material = /datum/material/copper
	item_weight = 350 GRAMS

/obj/item/ore/dust/tin
	name = "tin dust"
	desc = "Fine particles of tin ore."
	melting_material = /datum/material/tin
	item_weight = 300 GRAMS
