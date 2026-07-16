
/obj/item/clothing/cloak/chasuble
	name = "chasuble"
	desc = "Pristine white liturgical vestments with a golden Astratan cross adornment."
	icon_state = "chasuble"
	body_parts_covered = CHEST|GROIN|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE)
	allowed_race = SPECIES_BASE_BODY
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/chasuble/psydon
	name = "chasuble"
	desc = "Pristine white liturgical vestments with a golden psycross adornment."
	icon_state = "chasuble_psydon"
	body_parts_covered = CHEST|GROIN|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE)
	allowed_race = SPECIES_BASE_BODY
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/stole
	name = "stole"
	desc = "Garments of a priest, usually worn when giving mass to the people."
	icon_state = "stole_gold"
	sleeved = null
	sleevetype = null
	body_parts_covered = null
	flags_inv = null

/obj/item/clothing/cloak/stole/red
	icon_state = "stole_red"

/obj/item/clothing/cloak/stole/purple
	icon_state = "stole_purple"

/obj/item/clothing/cloak/black_cloak
	name = "fur coat"
	desc = "A coat made out of fur that covers chest, arms, groin and a chest. Has no protection capacities."
	icon_state = "black_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE)
	allowed_race = SPECIES_BASE_BODY
	sellprice = 50
	nodismemsleeves = TRUE
	min_cold_protection_temperature = -20

/obj/item/clothing/cloak/tribal
	name = "tribal pelt"
	desc = "A haphazardly cured pelt of a creecher, thrown on top of one's body or armor, to serve as additional protection against the cold. Itchy."
	icon_state = "tribal"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|GROIN|VITALS
	allowed_sex = list(MALE, FEMALE)
	// allowed_race = list("human", "tiefling", "elf", "aasimar", "dwarf")
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	boobed = FALSE
	sellprice = 10

/obj/item/clothing/cloak/heartfelt
	name = "red cloak"
	desc = "A typical cloak, this one is in red colours."
	icon_state = "heartfelt_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = SPECIES_BASE_BODY
	sellprice = 50
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/half
	name = "half cloak"
	desc = "A cloak that covers only half of the body."
	color = null
	icon_state = "halfcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	color = CLOTHING_SOOT_BLACK
	allowed_sex = list(MALE, FEMALE)
	allowed_race = SPECIES_BASE_BODY
	has_storage = TRUE

/obj/item/clothing/cloak/half/guard
	name = "guard's half cloak"
	color = CLOTHING_PLUM_PURPLE
	icon_state = "guardcloak"
	allowed_race = ALL_RACES_LIST
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/half/guardsecond
	name = "guard's half cloak"
	color = CLOTHING_BLOOD_RED
	icon_state = "guardcloak"
	allowed_race = ALL_RACES_LIST
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/half/shadowcloak
	name = "stalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin. The pin depicts a spider with disconnected legs."
	icon_state = "shadowcloak"
	item_state = "shadowcloak"
	color = null
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	mob_overlay_icon = 'icons/roguetown/clothing/newclothes/onmob/shadowcloak.dmi'
	sleeved = 'icons/roguetown/clothing/newclothes/onmob/shadowcloak.dmi'
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	toggle_icon_state = FALSE
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/cloak/half/shadowcloak/cult
	name = "ominous cloak"
	desc = "Those who wear, thy should beware, for those who do; never come back as who they once were again."
	allowed_race = ALL_RACES_LIST
	body_parts_covered = ARMS|CHEST
	armor = ARMOR_MAILLE_GOOD

/obj/item/clothing/cloak/half/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/cloak/half/colored/brown
	color = CLOTHING_BARK_BROWN

/obj/item/clothing/cloak/half/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/cloak/half/vet
	name = "town watch cloak"
	icon_state = "guardcloak"
	color = CLOTHING_BLOOD_RED
	inhand_mod = FALSE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/half/colored/random/Initialize()
	color = pick(CLOTHING_WINESTAIN_RED, CLOTHING_MUSTARD_YELLOW, CLOTHING_SOOT_BLACK, CLOTHING_BARK_BROWN, CLOTHING_FOREST_GREEN, CLOTHING_BERRY_BLUE)
	return ..()

/obj/item/clothing/cloak/matron
	name = "matron cloak"
	desc = "A cloak that only the meanest of old crones bother to wear."
	icon_state = "matroncloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon ='icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_CLOAK
	has_storage = TRUE

//............... Battle Nun ........................... (unique kit for the role, tabard for aesthetics)
/obj/item/clothing/cloak/battlenun
	name = "nun vestments"
	desc = "Chaste, righteous, merciless to the wicked."
	color = null
	icon_state = "battlenun"
	allowed_sex = list(FEMALE)
	item_state = "battlenun"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

//.............inquisitor cloaks......... (For inquisitors..)
/obj/item/clothing/cloak/cape/puritan
	icon_state = "puritan_cape"
	allowed_race = SPECIES_BASE_BODY

/obj/item/clothing/cloak/cape/inquisitor
	name = "Inquisitors Cloak"
	desc = "A time honored cloak Valorian design, used by founding clans of the Valorian Lodge"
	icon_state = "inquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

// Dumping old black knight stuff here
/obj/item/clothing/cloak/cape/blkknight
	name = "blood cape"
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/cloak/tabard/blkknight
	name = "blood sash"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	icon_state = "bksash"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	detail_tag = null

/obj/item/clothing/neck/blkknight
	name = "dragonscale necklace"
	desc = ""
	icon_state = "bktrinket"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 666
	static_price = TRUE

/obj/item/clothing/cloak/volfmantle
	name = "volf mantle"
	desc = "A warm cloak made using the hide and head of a slain volf. A status symbol if ever there was one."
	color = null
	icon_state = "volfpelt"
	item_state = "volfpelt"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/wickercloak
	name = "wicker cloak"
	desc = "A makeshift cloak constructed with mud, sticks and fibers."
	icon_state = "wicker_cloak"
	item_state = "wicker_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	allowed_race = SPECIES_BASE_BODY

/obj/item/clothing/cloak/faceless
	name = "sash"
	icon_state = "facelesssash" //Credit goes to Cre
	item_state = "facelesssash"
	desc = "A limp piece of fabric traditionally used to fasten bags that are too baggy, but in modern days has become more of a fashion statement than anything."

/obj/item/clothing/cloak/half/duelcape
	name = "duelist cape"
	desc = "A cape designed for mercenary bands hailing from Valoria."
	icon_state = "duelistcape"
	item_state = "duelistcape"
	color = null
	nodismemsleeves = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = SPECIES_BASE_BODY
	inhand_mod = FALSE

/obj/item/clothing/cloak/graggar
	name = "vicious cloak"
	desc = "A cloak with a sinister aura set to bring about violence on the world."
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	icon_state = "graggarcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	dyeable = TRUE
	sellprice = 0 // See above comment

/obj/item/clothing/cloak/graggar/heavy
	name = "vicious halfcloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	desc = "Sorrow begets spite; and when one has nothing else to lose, spite is all that's needed for Man to defy God."
	icon_state = "graggarcloak_heavy"

/obj/item/clothing/cloak/savage
	name = "savage cloak"
	desc = "A cloak covered in an predatory aura, it seeks to bring about the natural chaos of the wild to you, dripping in gore and bloodied fur."
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "savagecloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	dyeable = TRUE
	sellprice = 0

/obj/item/clothing/cloak/silktabard
	name = "fine silk tabard"
	desc = "A finely crafted long tabard weaved from silk. Fashionable, and a symbol of status and wealth."
	icon_state = "silktabard"
	item_state = "silktabard"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	allowed_ages = ALL_AGES_LIST //placeholder until younglings have onmob sprites for this item

/obj/item/clothing/cloak/shredded
	name = "shredded cloak"
	desc = "A shredded long cloak."
	icon_state = "shredded"
	item_state = "shredded"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	allowed_race = SPECIES_BASE_BODY

/obj/item/clothing/cloak/pegasusknight
	name = "checkered tabard"
	desc = "A quilted checkered tabard."
	icon_state = "lakkaritabard"
	item_state = "lakkaritabard"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	allowed_race = SPECIES_BASE_BODY

/obj/item/clothing/cloak/poncho

	name = "cloth poncho"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin."
	icon_state = "poncho"
	item_state = "poncho"
	boobed = FALSE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/poncho/yellow
	color = CLOTHING_MUSTARD_YELLOW

/obj/item/clothing/cloak/pantheon
	name = "pantheon cloak"
	desc = "A divine blue cloak with shimmering gold sewn in, it represents the ten in their whole. Typically worn by High Templars of the Ten"
	icon_state = "seecloak"
	item_state = "seecloak"
	boobed = FALSE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/bandolier
	name = "bandolier"
	desc = "A sash that's pelted with pouches, perfect for carrying plenty of pint-sized pieces. </br>'Hail to the King, baby.'"
	color = null
	icon_state = "bandolier"
	item_state = "bandolier"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK //Same slots as the regular tabard, with the added bonus of being slingable on the rightmost backslot.
	salvage_result = /obj/item/natural/hide/cured
	grid_width = 64
	grid_height = 96

/obj/item/clothing/cloak/bandolier/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/bandolier)

/obj/item/clothing/cloak/scaledcloak
	name = "scaled cloak"
	desc = "A light cloak covered in shimmering metal scales. Beautiful even if too light to protect it's wearer from more than other travel cloaks."
	icon_state = "scalecloak"
	item_state = "scalecloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = FALSE
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	detail_tag = "_detail"
	detail_color = "#405996"

/obj/item/clothing/cloak/sleevedtabard
	name = "sleeved tabard"
	desc = "A tabard with a light sleeve and pauldron sewn on, it lacks the explicit detailing of other tabards in exchange."
	color = null
	boobed = TRUE
	icon_state = "halfsurcoat"
	item_state = "halfsurcoat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/minotaur
	name = "minotaur cloak"
	desc = "Minotaur fur and straw roughly sewn into a long mantle."
	icon_state = "mino"
	item_state = "mino"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 4

/obj/item/clothing/cloak/poncho/fancycoat
	name = "fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	icon_state = "fancycoat"
	item_state = "fancycoat"
	alternate_worn_layer = TABARD_LAYER
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	nodismemsleeves = TRUE
	detail_tag = null

/obj/item/clothing/cloak/kazengun
	name = "jinbaori"
	desc = "A simple kind of Blackmeadow surcoat, worn here in the distant battlefields of Azuria to differentiate friend from foe."
	icon_state = "kazenguncoat"
	item_state = "kazenguncoat"
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = "#FFFFFF"
	detail_color = "#FFFFFF"

//............... Cadwyn Order Cloaks ......................//
/obj/item/clothing/cloak/cadwyn/astrata
	name = "bright tabard"
	desc = "A golden-coloured cloak, torn into strips at the ends. Let it mark you as a threat to any deadite monster as you stand tall above the charge."
	icon_state = "cadwyncloak_astrata"
	item_state = "cadwyncloak_astrata"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cadwyn/ravox
	name = "tattered surcoat"
	desc = "A partially shredded red tabard.  Let your allies take shelter behind its bold colour as you bear the attack."
	icon_state = "cadwyncloak_ravox"
	item_state = "cadwyncloak_ravox"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cadwyn/necra
	name = "dark cloak"
	desc = "A dark cloak secured with a silver buckle. The edge is torn from the dangerous melees with the deadite horde."
	icon_state = "cadwyncloak_necra"
	item_state = "cadwyncloak_necra"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

//............... Legacy Totod Order Cloaks ......................//
/obj/item/clothing/cloak/cape/crusader
	name = "desert cape"
	desc = "Zaladin is known for its legacies in tailoring, this particular cape is interwoven with fine stained silks and leather - a sand elf design, renowned for its style and durability."
	icon_state = "crusader_cloak"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	has_storage = TRUE
