/obj/item/alch
	name = "dust"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alch/viscera
	name = "viscera"
	icon_state = "viscera"

/obj/item/alch/waterdust
	name = "water essentia"
	icon_state = "water_runedust"

/obj/item/alch/seeddust
	name = "seed dust"
	icon_state = "seeddust"

/obj/item/alch/runedust
	name = "raw essentia"
	icon_state = "runedust"

/obj/item/alch/coaldust
	name = "coal dust"
	icon_state = "coaldust"

/obj/item/alch/silverdust
	name = "silver dust"
	icon_state = "silverdust"

/obj/item/alch/magicdust
	name = "pure essentia"
	icon_state = "magic_runedust"

/obj/item/alch/firedust
	name = "fire essentia"
	icon_state = "fire_runedust"

/obj/item/alch/sinew
	name = "sinew"
	icon_state = "sinew"
	dropshrink = 0.9

/obj/item/alch/irondust
	name = "iron dust"
	icon_state = "irondust"

/obj/item/alch/airdust
	name = "air essentia"
	icon_state = "air_runedust"

/obj/item/alch/swampdust
	name = "swampweed dust"
	icon_state = "swampdust"

/obj/item/alch/tobaccodust
	name = "westleach dust"
	icon_state = "tobaccodust"

/obj/item/alch/earthdust
	name = "earth essentia"
	icon_state = "earth_runedust"

/obj/item/alch/bone
	name = "tail bone"
	icon_state = "bone"
	desc = "The only bone in creachers with alchemical properties."
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL

	grid_height = 32
	grid_width = 32

	attunement_values = list(
		/datum/attunement/death = 0.05,
		/datum/attunement/life = -0.1,
		/datum/attunement/light = -0.1,
	)

/obj/item/alch/horn
	name = "troll horn"
	icon_state = "horn"
	desc = "The horn of a bog troll."
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL

	grid_width = 64
	grid_height = 64

/obj/item/alch/golddust
	name = "gold dust"
	icon_state = "golddust"

/obj/item/alch/feaudust
	name = "feau dust"
	desc = "Combining gold and iron results in this powder with unique alchemical properties."
	icon_state = "feaudust"

/obj/item/alch/ozium
	name = "alchemical ozium"
	desc = "Alchemical processing has left it unfit for consumption."
	icon_state = "darkredpowder"

/obj/item/alch/transisdust
	name = "transis dust"
	desc = "A complex mix of herbs that produce a powder which can modify the body."
	icon_state = "transisdust"

//BEGIN THE HERBS

/obj/item/alch/herb
	name = "herb"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_MASK
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = NONE

/obj/item/alch/herb/atropa
	name = "atropa"
	icon_state = "atropa"

/obj/item/alch/herb/matricaria
	name = "matricaria"
	icon_state = "matricaria"

/obj/item/alch/herb/symphitum
	name = "symphitum"
	icon_state = "symphitum"

/obj/item/alch/herb/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum"

/obj/item/alch/herb/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia"

/obj/item/alch/herb/paris
	name = "paris"
	icon_state = "paris"

/obj/item/alch/herb/calendula
	name = "calendula"
	icon_state = "calendula"

/obj/item/alch/herb/mentha
	name = "mentha"
	icon_state = "mentha"

/obj/item/alch/herb/urtica
	name = "urtica"
	icon_state = "urtica"

/obj/item/alch/herb/salvia
	name = "salvia"
	icon_state = "salvia"

/obj/item/alch/herb/rosa
	name = "rosa"
	icon_state = "rosa"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	spitoutmouth = FALSE

/obj/item/alch/herb/rosa/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_MOUTH)
		icon_state = "rosa_mouth"
	else
		icon_state = "rosa"

/obj/item/alch/herb/euphorbia
	name = "euphorbia"
	icon_state = "euphorbia"

/obj/item/alch/herb/hypericum
	name = "hypericum"
	icon_state = "hypericum"

/obj/item/alch/herb/benedictus
	name = "benedictus"
	icon_state = "benedictus"

/obj/item/alch/herb/valeriana
	name = "valeriana"
	icon_state = "valeriana"

/obj/item/alch/herb/artemisia
	name = "artemisia"
	icon_state = "artemisia"

/obj/item/alch/herb/lavender // Not obtainable currently, will correct later
	name = "lavender"
	icon_state = "lavender"

/obj/item/alch/thaumicdust
	name = "thaumic iron dust"
	icon_state = "thaumicirondust"
	icon = 'icons/roguetown/misc/thaumicdust.dmi'
	desc = "An odd, sticky clump of various alchemical ingredients. Smelt this down to create an ingot of thaumic iron."
	smeltresult = /obj/item/ingot/thaumic
	melting_material = /datum/material/thaumic_iron
