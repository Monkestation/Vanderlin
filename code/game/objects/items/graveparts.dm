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
	///3 means an EXPENSIVE decoration, usually forged.
	var/decorationquality
	///Set this if this decoration is not crafted/doesn't have an item state, but instead is made by using a non decoration item on a grave.
	var/sourceitem
	///Patrons associated with this grave decoration. Usually a headstone.
	var/list/patron

/obj/item/gravedecor/headstone
	name = "peaked headstone"
	desc = "A headstone with a sharp peak, and plenty of room for an inscription."
	icon_state = "headstone_basic"
	decorationquality = 2

/obj/item/gravedecor/headstone/crude
	name = "crude headstone"
	desc = ""
	sourceitem = /obj/item/grown/log/tree/stick
	icon_state = "gravemarker1"
	decorationquality = 1

/obj/item/gravedecor/headstone/psydon
	name = "psydonic headstone"
	desc = "A psycross shaped headstone, may be considered heretical by some, but to disturb the graves it lies upon even more so."
	icon_state = "headstone_psycross"
	decorationquality = 2
	patron = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

/obj/item/gravedecor/headstone/astrata
	name = "astratan headstone"
	desc = "The golden cross of Astrata, nothing less for the Sun Tyrant."
	icon_state = "headstone_astrata"
	decorationquality = 3
	patron = list(/datum/patron/divine/astrata)

/obj/item/gravedecor/headstone/pestra
	name = "pestran headstone"
	desc = "Any grave this is on is practically begging to be robbed. Maybe that's the intent."
	icon_state = "headstone_pestra"
	decorationquality = 2
	patron = list(/datum/patron/divine/pestra)

/obj/item/gravedecor/headstone/abyssor
	name = "abyssorite headstone"
	desc = "Not a common sight, most corpses are lost to his briny embrace before they can see land."
	icon_state = "headstone_abyssor"
	decorationquality = 2
	patron = list(/datum/patron/divine/abyssor)

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
