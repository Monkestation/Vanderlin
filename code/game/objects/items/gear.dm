/obj/item/gear
	icon = 'icons/roguetown/items/misc.dmi'
	name = "gear"
	desc = ""
	icon_state = ""
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = null
	grid_height = 32
	grid_width = 32
	item_weight = 200 GRAMS

/obj/item/gear/metal
	desc = "A gear with teeth meticulously crafted for tight interlocking."
	icon_state = "gear"
	melt_amount = 25
	item_weight = 250 GRAMS

// To prevent metal transmutation
/obj/item/gear/metal/bronze
	melting_material = /datum/material/bronze

/obj/item/gear/metal/iron
	icon = 'icons/roguetown/items/new_gears.dmi'
	icon_state = "iron_gear"
	melting_material = /datum/material/iron
	melt_amount = 35
	item_weight = 400 GRAMS

/obj/item/gear/metal/steel
	icon = 'icons/roguetown/items/new_gears.dmi'
	icon_state = "steel_gear"
	melting_material = /datum/material/steel
	item_weight = 350 GRAMS

/obj/item/gear/wood
	var/cart_capacity = 0
	var/misfire_modification
	var/name_prefix
	grid_height = 64
	grid_width = 32
	item_weight = 100 GRAMS

/obj/item/gear/wood/basic
	name = "wooden gear"
	desc = "A very simple wooden gear. Used in carts and machinery."
	icon_state = "upgrade"
	metalizer_result = /obj/item/gear/metal
	smeltresult = /obj/item/fertilizer/ash
	cart_capacity = 390 KILOGRAMS
	misfire_modification = -5

/obj/item/gear/wood/reliable
	name = "reliable wooden gear"
	desc = "A gear imbued with a special essence, making it very reliable. Used in carts and machinery."
	icon_state = "upgrade2"
	cart_capacity = 420 KILOGRAMS
	misfire_modification = -50
	name_prefix = "stable"
	item_weight = 120 GRAMS

/obj/item/gear/wood/reliable/Initialize()
	. = ..()
	filters = filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(32, 196, 218, 200))

/obj/item/gear/wood/unstable
	name = "unstable wooden gear"
	desc = "A gear imbued with a special essence, making it prone to breaking at any time. Used in carts and machinery."
	icon_state = "upgrade2"
	cart_capacity = 440 KILOGRAMS
	misfire_modification = 50
	name_prefix = "unstable"
	item_weight = 110 GRAMS

/obj/item/gear/wood/unstable/Initialize()
	. = ..()
	filters = filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(167, 17, 17, 200))
