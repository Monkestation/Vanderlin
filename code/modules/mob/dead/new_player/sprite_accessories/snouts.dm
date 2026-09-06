/datum/sprite_accessory/snout
	abstract_type = /datum/sprite_accessory/snout
	icon = 'icons/mob/sprite_accessory/snouts/snouts.dmi'
	color_key_name = "Snout"
	color_key_defaults = list(KEY_SKIN_COLOR)
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/snout/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/snout/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE)

/datum/sprite_accessory/snout/cat
	name = "Cat"
	icon_state = "cat"

/datum/sprite_accessory/snout/sharp
	name = "Sharp"
	icon_state = "sharp"

/datum/sprite_accessory/snout/round
	name = "Round"
	icon_state = "round"

/datum/sprite_accessory/snout/sharplight
	name = "Sharp + Light"
	icon_state = "sharplight"

/datum/sprite_accessory/snout/roundlight
	name = "Round + Light"
	icon_state = "roundlight"

/datum/sprite_accessory/snout/vulp
	name = "Vulp Two-shade"
	icon_state = "vulp"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/shark
	name = "Shark"
	icon_state = "shark"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/bug
	name = "Bug"
	icon_state = "bug"
	color_keys = 2
	color_key_names = list("Snout", "Eyes")

/datum/sprite_accessory/snout/elephant
	name = "Elephant"
	icon_state = "elephant"
	color_keys = 2
	color_key_names = list("Snout", "Horns")

/datum/sprite_accessory/snout/husky
	name = "Husky"
	icon_state = "husky"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/rhino
	name = "Horn"
	icon_state = "rhino"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/bovine
	name = "Bovine"
	icon_state = "bovine"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/rodent
	name = "Rodent"
	icon_state = "rodent"

/datum/sprite_accessory/snout/lcanid
	name = "Mammal, Long"
	icon_state = "lcanid"

/datum/sprite_accessory/snout/lcanidalt
	name = "Mammal, Long ALT"
	icon_state = "lcanidalt"

/datum/sprite_accessory/snout/lcanidstriped
	name = "Mammal, Long, Striped"
	icon_state = "lcanidstripe"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/lcanidstripedalt
	name = "Mammal, Long, Striped ALT"
	icon_state = "lcanidstripealt"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/scanid
	name = "Mammal, Short"
	icon_state = "scanid"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/scanidalt
	name = "Mammal, Short ALT"
	icon_state = "scanidalt"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/scanidalt2
	name = "Mammal, Short ALT 2"
	icon_state = "scanidalt2"

/datum/sprite_accessory/snout/scanidalt3
	name = "Mammal, Short ALT 3"
	icon_state = "scanidalt3"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/tajaran
	name = "Tajaran, normal"
	icon_state = "ntajaran"

/datum/sprite_accessory/snout/wolf
	name = "Mammal, Thick"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/wolfalt
	name = "Mammal, Thick ALT"
	icon_state = "wolfalt"

/datum/sprite_accessory/snout/otie
	name = "Otie"
	icon_state = "otie"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/otiesmile
	name = "Otie Smile"
	icon_state = "otiesmile"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/pede
	name = "Scolipede"
	icon_state = "pede"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/sergal
	name = "Sergal"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/toucan
	name = "Toucan"
	icon_state = "toucan"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/redpanda
	name = "WahCoon"
	icon_state = "wah"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/redpandaalt
	name = "WahCoon ALT"
	icon_state = "wahalt"
	color_keys = 2
	color_key_names = list("Snout", "Details")

/datum/sprite_accessory/snout/sbeak
	name = "Corvid Beak"
	icon_state = "corvid"

/datum/sprite_accessory/snout/rat
	name = "Rat"
	icon_state = "rat"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/stubby
	name = "Stubby"
	icon_state = "stubby"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/alienlizard
	name = "Alien Lizard"
	icon_state = "alienlizard"

/datum/sprite_accessory/snout/alienlizardteeth
	name = "Alien Lizard Teeth"
	icon_state = "alienlizardteeth"
	extra_state = TRUE

/datum/sprite_accessory/snout/skulldog
	name = "Skulldog"
	icon_state = "skulldog"
	extra_state = TRUE
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hanubus
	name = "Anubus"
	icon_state = "hanubus"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hpanda
	name = "Panda"
	icon_state = "hpanda"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hjackal
	name = "Jackal"
	icon_state = "hjackal"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hspots
	name = "Hyena"
	icon_state = "hspots"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hhorse
	name = "Horse"
	icon_state = "hhorse"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/hzebra
	name = "Zebra"
	icon_state = "hzebra"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/******************************************
**************** Snouts *******************
*************but higher up*****************/

/datum/sprite_accessory/snout/front
	abstract_type = /datum/sprite_accessory/snout/front
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/snout/front/sharp
	name = "Sharp (Top)"
	icon_state = "fsharp"

/datum/sprite_accessory/snout/front/round
	name = "Round (Top)"
	icon_state = "fround"

/datum/sprite_accessory/snout/front/sharplight
	name = "Sharp + Light (Top)"
	icon_state = "fsharplight"

/datum/sprite_accessory/snout/front/roundlight
	name = "Round + Light (Top)"
	icon_state = "froundlight"

/datum/sprite_accessory/snout/front/bird
	name = "Beak (Top)"
	icon_state = "fbird"
	color_keys = 3
	color_key_names = list("Beak", "Detail", "Top")

/datum/sprite_accessory/snout/front/bigbeak
	name = "Big Beak (Top)"
	icon_state = "fbigbeak"

/datum/sprite_accessory/snout/front/bug
	name = "Bug (Top)"
	icon_state = "fbug"
	color_keys = 2
	color_key_names = list("Snout", "Eyes")

/datum/sprite_accessory/snout/front/elephant
	name = "Elephant (Top)"
	icon_state = "felephant"
	color_keys = 2
	color_key_names = list("Snout", "Horns")

/datum/sprite_accessory/snout/front/rhino
	name = "Horn (Top)"
	icon_state = "frhino"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/front/bovine
	name = "Bovine (Top)"
	icon_state = "fbovine"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/front/husky
	name = "Husky (Top)"
	icon_state = "fhusky"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/lcanid
	name = "Mammal, Long (Top)"
	icon_state = "flcanid"

/datum/sprite_accessory/snout/front/lcanidalt
	name = "Mammal, Long ALT (Top)"
	icon_state = "flcanidalt"

/datum/sprite_accessory/snout/front/lcanidstriped
	name = "Mammal, Long, Striped (Top)"
	icon_state = "flcanidstripe"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/lcanidstripedalt
	name = "Mammal, Long, Striped ALT (Top)"
	icon_state = "flcanidstripealt"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/scanid
	name = "Mammal, Short (Top)"
	icon_state = "fscanid"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/scanidalt
	name = "Mammal, Short ALT (Top)"
	icon_state = "fscanidalt"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/scanidalt2
	name = "Mammal, Short ALT 2 (Top)"
	icon_state = "fscanidalt2"

/datum/sprite_accessory/snout/front/scanidalt3
	name = "Mammal, Short ALT 3 (Top)"
	icon_state = "fscanidalt3"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/wolf
	name = "Mammal, Thick (Top)"
	icon_state = "fwolf"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/wolfalt
	name = "Mammal, Thick ALT (Top)"
	icon_state = "fwolfalt"

/datum/sprite_accessory/snout/front/otie
	name = "Otie (Top)"
	icon_state = "fotie"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/otiesmile
	name = "Otie Smile (Top)"
	icon_state = "fotiesmile"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/rodent
	name = "Rodent (Top)"
	icon_state = "frodent"

/datum/sprite_accessory/snout/front/pede
	name = "Scolipede (Top)"
	icon_state = "fpede"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/sergal
	name = "Sergal (Top)"
	icon_state = "fsergal"
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/front/toucan
	name = "Toucan (Top)"
	icon_state = "ftoucan"
	color_keys = 2
	color_key_names = list("Detail", "Beak")

/datum/sprite_accessory/snout/front/redpanda
	name = "WahCoon (Top)"
	icon_state = "fwah"
	color_keys = 3
	color_key_names = list("Snout", "Details", "Details")

/datum/sprite_accessory/snout/front/redpandaalt
	name = "WahCoon ALT (Top)"
	icon_state = "fwahalt"
	color_keys = 2
	color_key_names = list("Snout", "Details")

/datum/sprite_accessory/snout/front/skulldog
	name = "Skulldog (Top)"
	icon_state = "fskulldog"
	extra_state = TRUE
	color_keys = 2
	color_key_names = list("Snout", "Inner")

/datum/sprite_accessory/snout/shortnosed
	name = "Short Nosed"
	icon_state = "shortnosed"
	color_keys = 2
	color_key_names = list("Snout", "Nose")

/datum/sprite_accessory/snout/stubby
	name = "Stubby"
	icon_state = "stubby"
	color_keys = 2
	color_key_names = list("Mask", "Snout")

/datum/sprite_accessory/snout/stubbyalt
	name = "Stubby ALT"
	icon_state = "stubbyalt"
	color_keys = 2
	color_key_names = list("Snout", "Nose")

/datum/sprite_accessory/snout/bird
	name = "Beak"
	icon_state = "bird"
	color_keys = 3
	color_key_names = list("Beak", "Detail", "Top")

/datum/sprite_accessory/snout/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"

/datum/sprite_accessory/snout/bigbeakshort
	name = "Big Beak Short"
	icon_state = "bigbeakshort"

/datum/sprite_accessory/snout/slimbeak
	name = "Slim Beak"
	icon_state = "slimbeak"

/datum/sprite_accessory/snout/slimbeakshort
	name = "Slim Beak Short"
	icon_state = "slimbeakshort"

/datum/sprite_accessory/snout/slimbeakalt
	name = "Slim Beak Alt"
	icon_state = "slimbeakalt"

/datum/sprite_accessory/snout/hookbeak
	name = "Hook Beak"
	icon_state = "hookbeak"

/datum/sprite_accessory/snout/hookbeakbig
	name = "Hook Beak Big"
	icon_state = "hookbeakbig"

// Sorry
/datum/sprite_accessory/snout/thin_beak
	abstract_type = /datum/sprite_accessory/snout/thin_beak
	icon = 'icons/mob/sprite_accessory/snouts/thin.dmi'
	default_colors = list("#5e5e5e")

/datum/sprite_accessory/snout/thin_beak/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"

/datum/sprite_accessory/snout/thin_beak/bigbeakshort
	name = "Big Beak Short"
	icon_state = "bigbeakshort"

/datum/sprite_accessory/snout/thin_beak/slimbeak
	name = "Slim Beak"
	icon_state = "slimbeak"

/datum/sprite_accessory/snout/thin_beak/slimbeakshort
	name = "Slim Beak Short"
	icon_state = "slimbeakshort"

/datum/sprite_accessory/snout/thin_beak/slimbeakalt
	name = "Slim Beak Alt"
	icon_state = "slimbeakalt"

/datum/sprite_accessory/snout/thin_beak/hookbeak
	name = "Hook Beak"
	icon_state = "hookbeak"

/datum/sprite_accessory/snout/thin_beak/hookbeakbig
	name = "Hook Beak Big"
	icon_state = "hookbeakbig"


