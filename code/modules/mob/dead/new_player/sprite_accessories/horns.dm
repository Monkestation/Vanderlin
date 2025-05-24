/datum/sprite_accessory/horns
	abstract_type = /datum/sprite_accessory/horns
	icon = 'icons/mob/sprite_accessory/horns/horns.dmi'
	color_key_name = "Horns"
	relevant_layers = list(BODY_FRONT_LAYER)
	default_colors = list("#575b68")

/datum/sprite_accessory/horns/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS|HIDEHAIR)

/datum/sprite_accessory/horns/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/horns/simple
	name = "Simple"
	icon_state = "simple"

/datum/sprite_accessory/horns/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/horns/curled
	name = "Curled"
	icon_state = "curled"

/datum/sprite_accessory/horns/ram
	name = "Ram"
	icon_state = "ram"

/datum/sprite_accessory/horns/angler
	name = "Angeler"
	icon_state = "angler"

/datum/sprite_accessory/horns/guilmon
	name = "Guilmon"
	icon_state = "guilmon"

/datum/sprite_accessory/horns/uni
	name = "Uni"
	icon_state = "uni"
	relevant_layers = list(BODY_FRONT_LAYER, BODY_ADJ_LAYER, BODY_BEHIND_LAYER)

/datum/sprite_accessory/horns/oni
	name = "Oni"
	icon_state = "oni"
	relevant_layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)

/datum/sprite_accessory/horns/oni_large
	name = "Oni (Large)"
	icon_state = "oni_large"
	relevant_layers = list(BODY_FRONT_LAYER, BODY_ADJ_LAYER, BODY_BEHIND_LAYER)

/datum/sprite_accessory/horns/broken
	name = "Broken"
	icon_state = "broken"

/datum/sprite_accessory/horns/rbroken
	name = "Broken (Right)"
	icon_state = "rbroken"

/datum/sprite_accessory/horns/lbroken
	name = "Broken (Left)"
	icon_state = "lbroken"

/datum/sprite_accessory/horns/drake
	name = "Drake"
	icon_state = "drake"

/datum/sprite_accessory/horns/knight
	name = "Knight"
	icon_state = "knight"

/datum/sprite_accessory/horns/dragon
	name = "Dragon"
	icon_state = "dragon"

/datum/sprite_accessory/horns/antlers
	name = "Antlers"
	icon_state = "antlers"

/datum/sprite_accessory/horns/ramalt
	name = "Ram Alt"
	icon_state = "ramalt"

/datum/sprite_accessory/horns/smallantlers
	name = "Small Antlers"
	icon_state = "smallantlers"

/datum/sprite_accessory/horns/curledramhorns
	name = "Curled Ram Horns"
	icon_state = "ramcurled"

/datum/sprite_accessory/horns/curledramhornsalt
	name = "Curled Ram Horns Alt"
	icon_state = "ramcurledalt"

/datum/sprite_accessory/horns/smallramhorns
	name = "Small Ram Horns"
	icon_state = "ramcurledsmall"

/datum/sprite_accessory/horns/smallramhornsalt
	name  = "Small Ram Horns Alt"
	icon_state = "ramcurledsmallalt"

/datum/sprite_accessory/horns/smallramhornsthree
	name = "Small Ram Horns 3"
	icon_state = "ramcurledsmall3"

/datum/sprite_accessory/horns/liftedhorns
	name = "Lifted Horns"
	icon_state = "lifted"

/datum/sprite_accessory/horns/sideswept
	name = "Side Swept Horns"
	icon_state = "sideswept"

/datum/sprite_accessory/horns/bigcurlyhorns
	name = "Big Curly Horns"
	icon_state = "bigcurly"

/datum/sprite_accessory/horns/billberry
	name = "Billberry"
	icon_state = "billberry"

/datum/sprite_accessory/horns/stabbers
	name = "Stabbers"
	icon_state = "stabbers"

/datum/sprite_accessory/horns/unihorn
	name = "Unihorn"
	icon_state = "unihorn"

/datum/sprite_accessory/horns/longhorns
	name = "Longhorns"
	icon_state = "longhorns"

/datum/sprite_accessory/horns/outstretched
	name = "Outstretched"
	icon_state = "outstretched"

/datum/sprite_accessory/horns/halo
	name = "Halo"
	icon_state = "halo"

/datum/sprite_accessory/horns/greathorns
	name = "Great Horns"
	icon_state = "great"

/datum/sprite_accessory/horns/bunhorns
	name = "Bunny horns"
	icon_state = "bunhorns"

/datum/sprite_accessory/horns/marauder
	name = "Marauder"
	icon_state = "marauder"

/datum/sprite_accessory/horns/faceguard
	name = "Faceguard"
	icon_state = "faceguard"

/datum/sprite_accessory/horns/sheephorns
	name = "Sheep Horns"
	icon_state = "sheep"

/datum/sprite_accessory/horns/doublehorns
	name = "Double Horns"
	icon_state = "doublehorns"

/datum/sprite_accessory/horns/large
	abstract_type = /datum/sprite_accessory/horns/large
	icon = 'icons/mob/sprite_accessory/horns/horns_large.dmi'

/datum/sprite_accessory/horns/large/big_antlers
	name = "Big Antlers"
	icon_state = "big_antlers"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/horns/halforc
	name = "Half Orc"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "orctusk"
	default_colors = list("#F4F4BE")

/datum/sprite_accessory/horns/tiefling
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "TiebHorns"
	icon_state = "tiebhorns"
	specuse = list("tiefling")
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/horns/tiefling/alt
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "TiebHornies"
	icon_state = "tiebhornsalt"
	specuse = list("tiefling")
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/horns/triton
	name = "Triton Tusks"
	icon = 'icons/mob/sprite_accessory/horns/triton.dmi'
	icon_state = "tusks"
	use_static = TRUE

/datum/sprite_accessory/horns/triton/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEMASK)
