// BOUQUETS & FLOWER CROWNS

/obj/item/bouquet
	name = "bouquet"
	desc = "The bouquet people love the most is one that produces a beautiful display of flowers."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bouquet_base"
	item_state = ""

	grid_width = 32
	grid_height = 64

/obj/item/bouquet/rosa
	name = "rosa bouquet"
	desc =  "A bouquet of rosas, one of Eora's most beautiful flowers. They are a symbol of love and devotion."
	icon_state = "bouquet_rosa"

/obj/item/bouquet/salvia
	name = "salvia bouquet"
	desc = "A bouquet of sweet smelling salvia, a beautiful and royal purple flower."
	icon_state = "bouquet_salvia"

/obj/item/bouquet/matricaria
	name = "matricaria bouquet"
	desc = "A bouquet of maricaria."
	icon_state = "bouquet_matricaria"

/obj/item/bouquet/calendula
	name = "calendula bouquet"
	desc = "A bouquet of calendula, a flower used in herbal medicine due to its supposed healing properties."
	icon_state = "bouquet_calendula"

/obj/item/clothing/head/flowercrown
	name = ""
	desc = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	dynamic_hair_suffix = null
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = null
	icon_state = ""
	item_state = ""
	abstract_type = /obj/item/clothing/head/flowercrown

	grid_width = 64
	grid_height = 32

/obj/item/clothing/head/flowercrown/rosa
	name = "rosa crown"
	desc = "A crown of rosas, often worn during weddings officiated by Eoran acolytes."
	item_state = "rosa_crown"
	icon_state = "rosa_crown"

/obj/item/clothing/head/flowercrown/salvia
	name = "salvia crown"
	desc = "A crown of salvia, often worn by consorts and princesses of particularly joyful royal courts"
	item_state = "salvia_crown"
	icon_state = "salvia_crown"
