/datum/sprite_accessory/tail
	abstract_type = /datum/sprite_accessory/tail
	icon = 'icons/mob/sprite_accessory/tails/tails.dmi'
	color_key_name = "Tail"
	relevant_layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	color_key_defaults = list(KEY_HAIR_COLOR)
	var/can_wag = FALSE

/datum/sprite_accessory/tail/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDETAIL)

/datum/sprite_accessory/tail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES)

/datum/sprite_accessory/tail/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!can_wag)
		return ..()
	var/obj/item/organ/tail/tail_organ = organ
	if(!owner || !tail_organ.wagging)
		return ..()
	return "[icon_state]_wagging"

#ifdef UNIT_TESTS

/datum/sprite_accessory/tail/unit_testing_icon_states(list/states)
	states += icon_state
	if(can_wag)
		states += "[icon_state]_wagging"

#endif

/datum/sprite_accessory/tail/cat
	name = "Cat"
	icon_state = "cat"
	relevant_layers = list(BODY_FRONT_LAYER)
	can_wag = TRUE

/datum/sprite_accessory/tail/monkey
	name = "Monkey"
	icon_state = "monkey"

/datum/sprite_accessory/tail/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/tail/batl
	name = "Bat (Long)"
	icon_state = "batl"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/bats
	name = "Bat (Short)"
	icon_state = "bats"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/bee
	name = "Bee"
	icon_state = "bee"
	color_keys = 2
	color_key_names = list("Abdomen", "Stripes")

/datum/sprite_accessory/tail/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	can_wag = TRUE

/datum/sprite_accessory/tail/twocat
	name = "Cat, Double"
	icon_state = "twocat"
	can_wag = TRUE

/datum/sprite_accessory/tail/corvid
	name = "Corvid"
	icon_state = "crow"

/datum/sprite_accessory/tail/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/tail/eevee
	name = "Eevee"
	icon_state = "eevee"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/fennec
	name = "Fennec"
	icon_state = "fennec"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/fish
	name = "Fish"
	icon_state = "fish"
	can_wag = TRUE

/datum/sprite_accessory/tail/fox
	name = "Fox"
	icon_state = "fox"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/fox2
	name = "Fox 2"
	icon_state = "fox2"

/datum/sprite_accessory/tail/hawk
	name = "Hawk"
	icon_state = "hawk"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/tail/horse
	name = "Horse"
	icon_state = "horse"

/datum/sprite_accessory/tail/husky
	name = "Husky"
	icon_state = "husky"
	color_keys = 2
	color_key_names = list("Tail", "Inner")
	can_wag = TRUE

/datum/sprite_accessory/tail/insect
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/tail/kangaroo
	name = "kangaroo"
	icon_state = "kangaroo"

/datum/sprite_accessory/tail/kitsune
	name = "Kitsune"
	icon_state = "kitsune"
	color_keys = 2
	color_key_names = list("Tails", "Tips")

/datum/sprite_accessory/tail/lab
	name = "Lab"
	icon_state = "lab"
	can_wag = TRUE

/datum/sprite_accessory/tail/murid
	name = "Murid"
	icon_state = "murid"

/datum/sprite_accessory/tail/orca
	name = "Orca"
	icon_state = "orca"

/datum/sprite_accessory/tail/otie
	name = "Otusian"
	icon_state = "otie"
	can_wag = TRUE

/datum/sprite_accessory/tail/rabbit
	name = "Rabbit"
	icon_state = "rabbit"
	can_wag = TRUE

/datum/sprite_accessory/tail/redpanda
	name = "Red Panda"
	icon_state = "wah"
	color_keys = 2
	color_key_names = list("Tail", "Stripes")
	can_wag = TRUE

/datum/sprite_accessory/tail/pede
	name = "Scolipede"
	icon_state = "pede"
	color_keys = 3
	color_key_names = list("Tail", "Inner", "Details")

/datum/sprite_accessory/tail/sergal
	name = "Sergal"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("Tail", "Inner")

/datum/sprite_accessory/tail/shark
	name = "Shark"
	icon_state = "shark"
	can_wag = TRUE

/datum/sprite_accessory/tail/shepherd
	name = "Shepherd"
	icon_state = "shepherd"
	color_keys = 2
	color_key_names = list("Tail", "Inner")
	can_wag = TRUE

/datum/sprite_accessory/tail/australian_shepherd
	name = "Australian Shepherd"
	icon_state = "australianshepherd"
	color_keys = 2
	color_key_names = list("Tail", "Inner")
	can_wag = TRUE

/datum/sprite_accessory/tail/skunk
	name = "Skunk"
	icon_state = "skunk"
	color_keys = 3
	color_key_names = list("Tail", "Inner", "Stripes")

/datum/sprite_accessory/tail/stripe
	name = "Stripe"
	icon_state = "stripe"
	color_keys = 2
	color_key_names = list("Tail", "Inner")

/datum/sprite_accessory/tail/straighttail
	name = "Straight Tail"
	icon_state = "straighttail"
	can_wag = TRUE

/datum/sprite_accessory/tail/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	can_wag = TRUE

/datum/sprite_accessory/tail/tamamo_kitsune
	name = "Tamamo Kitsune Tails"
	icon_state = "9sune"
	color_keys = 2
	color_key_names = list("Tails", "Tips")

/datum/sprite_accessory/tail/tiger
	name = "Tiger"
	icon_state = "tiger"
	color_keys = 3
	color_key_names = list("Tail", "Tip", "Stripes")
	can_wag = TRUE

/datum/sprite_accessory/tail/wolf
	name = "Wolf"
	icon_state = "wolf"
	can_wag = TRUE

/datum/sprite_accessory/tail/guilmon
	name = "Guilmon"
	icon_state = "guilmon"
	can_wag = TRUE

/datum/sprite_accessory/tail/sharknofin
	name = "Shark no fin"
	icon_state = "sharknofin"
	can_wag = TRUE

/datum/sprite_accessory/tail/raptor
	name = "Raptor"
	icon_state = "raptor"
	color_keys = 3
	color_key_names = list("Tail", "Details", "Details")

/datum/sprite_accessory/tail/lunasune
	name = "Lunasune"
	icon_state = "lunasune"
	can_wag = TRUE

/datum/sprite_accessory/tail/spade
	name = "Succubus Spade Tail"
	icon_state = "spade"

/datum/sprite_accessory/tail/leopard
	name = "Leopard"
	icon_state = "leopard"
	color_keys = 2
	color_key_names = list("Tail", "Spots")
	can_wag = TRUE

/datum/sprite_accessory/tail/deer
	name = "Deer"
	icon_state = "deer"
	color_keys = 2
	color_key_names = list("Tail", "Inner")

/datum/sprite_accessory/tail/raccoon
	name = "Raccoon"
	icon_state = "raccoon"
	color_keys = 2
	color_key_names = list("Tail", "Stripes")
	can_wag = TRUE

/datum/sprite_accessory/tail/sabresune
	name = "Sabresune"
	icon_state = "sabresune"
	color_keys = 2
	color_key_names = list("Tails", "Tips")

/datum/sprite_accessory/tail/lizard
	abstract_type = /datum/sprite_accessory/tail/lizard
	icon = 'icons/mob/sprite_accessory/tails/lizard.dmi'
	can_wag = TRUE

/datum/sprite_accessory/tail/lizard/smooth
	name = "Smooth"
	icon_state = "smooth"

/datum/sprite_accessory/tail/lizard/dtiger
	name = "Dark Tiger"
	icon_state = "dtiger"

/datum/sprite_accessory/tail/lizard/ltiger
	name = "Light Tiger"
	icon_state = "ltiger"

/datum/sprite_accessory/tail/lizard/spikes
	name = "Spikes"
	icon_state = "spikes"

/datum/sprite_accessory/tail/lizard/kobold
	name = "Kobold"
	icon_state = "kobold"

/datum/sprite_accessory/tail/tiefling
	name = "Tiefling"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "tiebtail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/tiefling/heart
	name = "Succubus"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "hearttail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/rattlesnake
	name = "Rattlesnake"
	icon_state = "rattlesnake"
	color_keys = 2
	color_key_names = list("Tail", "Tip")
	can_wag = TRUE

/datum/sprite_accessory/tail/tiefling
	icon = 'icons/roguetown/mob/bodies/attachments.dmi'
	name = "TiebTail"
	icon_state = "tiebtail"
	specuse = list(SPEC_ID_TIEFLING)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/tail/triton
	name = "Triton Bell"
	icon = 'icons/mob/sprite_accessory/tails/triton.dmi'
	icon_state = "triton"
	specuse = list(SPEC_ID_TRITON)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/tail/kobold
	name = "Kobold Curly"
	icon = 'icons/mob/sprite_accessory/tails/lizard.dmi'
	icon_state = "kobold"
	specuse = list(SPEC_ID_KOBOLD)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/tail/kobold/alt
	name = "Kobold Straight"
	icon_state = "kobold_alt"
	can_wag = TRUE

/datum/sprite_accessory/tail/kobold/round
	name = "Kobold Round"
	icon_state = "kobold_round"

/datum/sprite_accessory/tail/medicator
	name = "Medicator Plumage"
	icon = 'icons/mob/sprite_accessory/tails/medicator.dmi'
	icon_state = "vulture"
	specuse = list(SPEC_ID_MEDICATOR)
