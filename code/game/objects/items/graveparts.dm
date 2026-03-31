/obj/item/headstone
	name = "peaked headstone"
	icon = 'icons/turf/floors.dmi'
	desc = "A headstone with a sharp peak, and plenty of room for an inscription."
	icon_state = "headstone_basic"
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	var/decorationquality = 5

/obj/item/headstone/psydon
	name = "psydonic headstone"
	desc = "A psycross shaped headstone, may be considered heretical by some, but to disturb the graves it lies upon even more so."
	icon_state = "headstone_psycross"
	decorationquality = 10

/obj/item/gravefence
	name = "crude gravefence"
	icon = 'icons/turf/floors.dmi'
	desc = "A crude fence made of unshaped pebbles, made to deliniate a grave (somewhat) exactly."
	icon_state = "gravefence_basic"
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	var/decorationquality = 5

/obj/item/gravefence/block
	name = "chiseled gravefence"
	desc = "A gravefence of blocks to be embedded in the earth, made to deliniate a grave exactly."
	icon_state = "gravefence_block"
	decorationquality = 10
