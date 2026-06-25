/obj/item/clothing/pants/webs
	name = "webbing"
	desc = "A fine webbing made from spidersilk, popular fashion within the underdark."
	gender = PLURAL
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	salvage_result = /obj/item/natural/silk
	item_weight = 90 GRAMS

/obj/item/clothing/pants/grenzelpants
	name = "grenzelhoftian paumpers"
	desc = "Padded pants for extra comfort and protection, adorned in vibrant colors."
	icon_state = "grenzelpants"
	item_state = "grenzelpants"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED_OCHRE
	colorgrenz = TRUE
	armor = ARMOR_PADDED
	prevent_crits = MINOR_CRITICALS
	max_integrity = INTEGRITY_STANDARD
	item_weight = 400 GRAMS

/obj/item/clothing/pants/fencer
	name = "fencing breeches"
	desc = "Comfortable padded breeches designed for fencers, providing a bit of protection to the legs while not restricting movement."
	icon_state = "fencingbreeches"
	item_state = "fencingbreeches"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "leg"
	detail_tag = "_detail"
	detail_color = "#5E4440"
	armor = ARMOR_PADDED
	prevent_crits = MINOR_CRITICALS
	max_integrity = INTEGRITY_STANDARD
	item_weight = 400 GRAMS
