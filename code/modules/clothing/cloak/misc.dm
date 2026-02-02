
/obj/item/clothing/cloak/chasuble
	name = "chasuble"
	desc = "Pristine white liturgical vestments with a golden psycross adornment."
	icon_state = "chasuble"
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
	allowed_sex = list(MALE)
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

/obj/item/clothing/cloak/half/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/half/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

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
	icon_state = "bksash"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

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
	icon_state = "graggarcloak"
	icon_state = "graggarcloak"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

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
	name = "pegasus knight tabard"
	desc = "A quilted tabard worn by Lakkarian pegasus knights."
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
