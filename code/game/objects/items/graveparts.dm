/obj/item/gravedecor
	name = "grave decoration"
	desc = "If you're seeing this, yell at coders."
	icon = 'icons/turf/floors.dmi'
	icon_state = "headstone_basic"
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	///This applies a gravequality bonus when added to a grave. 1 means a CHEAP decoration, usually wood. 2 means a MODERATE decoration, usually masoned stone.
	///3 means an EXPENSIVE decoration, usually forged
	var/decorationquality
	///Patrons associated with this grave decoration. Usually a headstone.
	var/list/patron

/obj/item/gravedecor/headstone
	name = "peaked headstone"
	desc = "A headstone with a sharp peak, and plenty of room for an inscription."
	icon_state = "headstone_basic"
	decorationquality = 2

/obj/item/gravedecor/headstone/psydon
	name = "psydonic headstone"
	desc = "A psycross shaped headstone, may be considered heretical by some, but to disturb the graves it lies upon even more so."
	icon_state = "headstone_psycross"
	decorationquality = 2
	patron = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

/obj/item/gravedecor/gravefence
	name = "crude gravefence"
	desc = "A crude fence made of unshaped pebbles, made to deliniate a grave (somewhat) exactly."
	icon_state = "gravefence_basic"
	decorationquality = 1

/obj/item/gravedecor/gravefence/block
	name = "chiseled gravefence"
	desc = "A gravefence of blocks to be embedded in the earth, made to deliniate a grave exactly."
	icon_state = "gravefence_block"
	decorationquality = 2
