/datum/sprite_accessory/ears
	abstract_type = /datum/sprite_accessory/ears
	icon = 'icons/mob/sprite_accessory/ears/ears.dmi'
	color_key_name = "Ears"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS)

/datum/sprite_accessory/ears/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE)

/datum/sprite_accessory/ears/big
	icon = 'icons/mob/sprite_accessory/ears/ears_big.dmi'

/datum/sprite_accessory/ears/cat
	name = "Cat"
	icon_state = "cat"
	extra_state = TRUE
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/ears/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/ears/bat
	name = "Bat"
	icon_state = "bat"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/bear
	name = "Bear"
	icon_state = "bear"

/datum/sprite_accessory/ears/bigwolf
	name = "Big Wolf"
	icon_state = "bigwolf"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/bigwolf_inner
	name = "Big Wolf (Inner)"
	icon_state = "bigwolf_inner"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	extra_state = TRUE

/datum/sprite_accessory/ears/bunny
	name = "Bunny"
	icon_state = "bunny"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/bunny_perky
	name = "Bunny (Perky)"
	icon_state = "bunny_perky"
	color_keys = 3
	color_key_names = list("Ears", "Inner", "Tips")

/datum/sprite_accessory/ears/cat_big
	name = "Cat, Big"
	icon_state = "catbig"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/cat_normal
	name = "Cat, Normal"
	icon_state = "catnormal"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/ears/curled
	name = "Curled Horn"
	icon_state = "horn"

/datum/sprite_accessory/ears/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/ears/eevee
	name = "Eevee"
	icon_state = "eevee"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/elf
	name = "Elf"
	icon_state = "elf"

/datum/sprite_accessory/ears/elephant
	name = "Elephant"
	icon_state = "elephant"

/datum/sprite_accessory/ears/fennec
	name = "Fennec"
	icon_state = "fennec"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/fish
	name = "Fish"
	icon_state = "fish"

/datum/sprite_accessory/ears/fox
	name = "Fox"
	icon_state = "fox"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/vulp
	name = "Vulp"
	icon_state = "vulp"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/husky
	name = "Husky"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/jellyfish
	name = "Jellyfish"
	icon_state = "jellyfish"

/datum/sprite_accessory/ears/kangaroo
	name = "Kangaroo"
	icon_state = "kangaroo"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/lab
	name = "Dog, Long"
	icon_state = "lab"

/datum/sprite_accessory/ears/murid
	name = "Murid"
	icon_state = "murid"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/otie
	name = "Otusian"
	icon_state = "otie"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/rabbit
	name = "Rabbit"
	icon_state = "rabbitlop"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/big/rabbit_large
	name = "Rabbit Ears (Large)"
	icon_state = "rabbit_large"
	color_keys = 3
	color_key_names = list("Ears", "Inner", "Tips")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/pede
	name = "Scolipede"
	icon_state = "pede"
	color_keys = 2
	color_key_names = list("Ears", "Details")

/datum/sprite_accessory/ears/sergal
	name = "Sergal"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/shark
	name = "Shark"
	icon_state = "shark"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/skunk
	name = "skunk"
	icon_state = "skunk"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/wolf
	name = "Wolf"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/perky
	name = "Perky"
	icon_state = "perky"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/antenna_simple1
	name = "Insect antenna 1"
	icon_state = "antenna_simple1"

/datum/sprite_accessory/ears/antenna_simple2
	name = "Insect antenna 2"
	icon_state = "antenna_simple2"

/datum/sprite_accessory/ears/antenna_simple3
	name = "Insect antenna 3"
	icon_state = "antenna_simple3"

/datum/sprite_accessory/ears/antenna_simple4
	name = "Insect antenna 4"
	icon_state = "antenna_simple4"

/datum/sprite_accessory/ears/antenna_fuzzball1
	name = "Fuzzball antenna 1"
	icon_state = "antenna_fuzzball1"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/antenna_fuzzball2
	name = "Fuzzball antenna 2"
	icon_state = "antenna_fuzzball2"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/cobrahood
	name = "Cobra Hood"
	icon_state = "cobrahood"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/cobrahoodears
	name = "Cobra Hood (Ears)"
	icon_state = "cobraears"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/miqote
	name = "Miqo'te"
	icon_state = "miqote"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/lunasune
	name = "Lunasune"
	icon_state = "lunasune"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/sabresune
	name = "Sabresune"
	icon_state = "sabresune"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	extra_state = TRUE

/datum/sprite_accessory/ears/possum
	name = "Possum"
	icon_state = "possum"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/raccoon
	name = "Raccoon"
	icon_state = "raccoon"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/mouse
	name = "Mouse"
	icon_state = "mouse"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/halforc
	name = "Half Orc"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "halforc"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/goblin
	name = "Goblin"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "goblin"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/big
	icon = 'icons/mob/sprite_accessory/ears/ears_big.dmi'

/datum/sprite_accessory/ears/big/rabbit_large
	name = "Rabbit Ears (Large)"
	icon_state = "rabbit_large"
	color_keys = 3
	color_key_names = list("Ears", "Inner", "Tips")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/big/acrador_long
	icon_state = "acrador_long"
	name = "Acrador (Long)"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/big/acrador_short
	icon_state = "acrador_short"
	name = "Acrador (Short)"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/none
	name = "None"
	icon_state = null

/datum/sprite_accessory/ears/elf
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "Elf"
	icon_state = "elf"
	specuse = list(SPEC_ID_ELF)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/elfw
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "ElfW"
	icon_state = "elfw"
	specuse = list(SPEC_ID_ELF, SPEC_ID_TIEFLING) //tiebs use these
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/elfh //halfelfs are humens techincally
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "ElfH"
	icon_state = "elf"
	specuse = list(SPEC_ID_HUMEN)
	color_key_defaults = list(KEY_SKIN_COLOR)
