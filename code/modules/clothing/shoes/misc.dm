/obj/item/clothing/shoes/nobleboot
	name = "noble boots"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = "Fine dark leather boots. Offers light protection against melee attacks."
	gender = PLURAL
	icon_state = "nobleboots"
	item_state = "nobleboots"
	armor = list("blunt" = 20, "slash" = 20, "stab" = 20,  "piercing" = 15, "fire" = 0, "acid" = 0)
	sellprice = 10
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/shoes/nobleboot/apply_components()
	. = ..()
	AddComponent(/datum/component/storage/concrete/boots)

/obj/item/clothing/shoes/nobleboot/thighboots
	name = "thigh boots"
	icon_state = "thighboot"
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'

/obj/item/clothing/shoes/shortboots
	name = "shortboots"
	color = "#d5c2aa"
	desc = "A shorter format of boots worn by about anyone."
	gender = PLURAL
	icon_state = "shortboots"
	item_state = "shortboots"
	armor = list("blunt" = 10, "slash" = 10, "stab" = 10,  "piercing" = 0, "fire" = 0, "acid" = 0)
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/shoes/ridingboots
	name = "riding boots"
	color = "#d5c2aa"
	desc = "Boots designed for riding a mount."
	armor = list("blunt" = 20, "slash" = 20, "stab" = 20,  "piercing" = 10, "fire" = 0, "acid" = 0)
	gender = PLURAL
	icon_state = "ridingboots"
	item_state = "ridingboots"
	sellprice = 10
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	wetable = FALSE

/obj/item/clothing/shoes/apothboots
	name = "apothecary boots"
	desc = "Boots designed for the toil of tincture gathering and mixing."
	gender = PLURAL
	icon_state = "apothboots"
	item_state = "apothboots"
	armor = list("blunt" = 15, "slash" = 15, "stab" = 15,  "piercing" = 5, "fire" = 0, "acid" = 0)
	sellprice = 10
	wetable = FALSE

/obj/item/clothing/shoes/simpleshoes
	name = "shoes"
	desc = "Simple shoes worn by about anyone."
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	color = CLOTHING_OLD_LEATHER
	salvage_result = null

/obj/item/clothing/shoes/simpleshoes/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shoes/simpleshoes/buckle
	name = "shoes"
	icon_state = "buckleshoes"
	color = null

/obj/item/clothing/shoes/simpleshoes/colored/lord
	name = "shoes"
	desc = "Shoes typically worn by the Monarch themselves."
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	color = CLOTHING_ASH_GREY
	sellprice = 20

/obj/item/clothing/shoes/gladiator
	name = "caligae"
	desc = "Open design sandals made from sturdy leather. Can be typically seen worn by gladiators."
	gender = PLURAL
	icon_state = "gladiator"
	item_state = "gladiator"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/shoes/sandals
	name = "sandals"
	desc = "Standard sandals."
	gender = PLURAL
	icon_state = "sandals"
	item_state = "sandals"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/shoes/rare
	abstract_type = /obj/item/clothing/shoes/rare

/obj/item/clothing/shoes/rare/hoplite
	name = "ancient sandals"
	desc = "Worn sandals lined with bronze, ready to march ever onwards."
	icon_state = "aasimarfeet"
	item_state = "aasimarfeet"
	sellprice = 20

/obj/item/clothing/shoes/shalal
	name = "babouche"
	desc = "Leather slippers of Zaladin origin."
	gender = PLURAL
	icon_state = "shalal"
	item_state = "shalal"
	sellprice = 15
	wetable = FALSE

/obj/item/clothing/shoes/tribal
	name = "primative shoes"
	desc = "Haphazardly-made slippers of creecher leather worn by those with nothing better, or those who don't care about fashion and just want to protect their feet."
	icon_state = "tribalshoes"
	item_state = "tribalshoes"
	sellprice = 3

/obj/item/clothing/shoes/jester
	name = "funny shoes"
	desc = "Shoes typically worn by a Jester."
	icon_state = "jestershoes"
	sellprice = 10

/obj/item/clothing/shoes/jester/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = list(SFX_JINGLE_BELLS), step_delay_override = 2, falloff_exponent = 20)

/obj/item/clothing/shoes/rare/grenzelhoft
	name = "grenzelhoft boots"
	icon_state = "grenzelboots"
	item_state = "grenzelboots"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	armor = list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 15, "fire" = 0, "acid" = 0)
	sellprice = 20
	wetable = FALSE

/obj/item/clothing/shoes/otavan
	name = "grenzelhoftian leather boots"
	desc = "Boots of outstanding craft, your fragile feet have never felt so protected and comfortable before."
	body_parts_covered = FEET
	icon_state = "fencerboots"
	item_state = "fencerboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	max_integrity = 200
	armor = ARMOR_LEATHER_GOOD
	wetable = FALSE

/obj/item/clothing/shoes/otavan/inqboots
	name = "inquisitorial boots"
	desc = "The steel-lined heels click."
	icon_state = "inqboots"
	item_state = "inqboots"

//Valorian Duelist Merc - On par with grenzelhoftian's stats.
/obj/item/clothing/shoes/nobleboot/duelboots
	desc = "Boots custom fit for a Valorian Duelist. Footwork is paramount in a duel, so good boots are a must."
	armor = list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 15, "fire" = 0, "acid" = 0)

/obj/item/clothing/shoes/psydonboots
	name = "enduring boots"
	desc = "A reliable pair of dark leather boots. Seems like they could endure the world!"
	color = "#d5c2aa"
	icon_state = "psydonboots"
	item_state = "psydonboots"

/obj/item/clothing/shoes/courtphysician
	name = "sanguine shoes"
	desc = "Leather shoes, the solemn tap of these bears grim news, or salvation."
	icon_state = "docshoes"
	item_state = "docshoes"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'

/obj/item/clothing/shoes/courtphysician/female
	name = "sanguine heels"
	desc = "Leather heels, the solemn tap of these bears grim news, or salvation."
	icon_state = "docheels"
	item_state = "docheels"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY
