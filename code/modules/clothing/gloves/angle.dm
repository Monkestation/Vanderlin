/obj/item/clothing/gloves/angle
	name = "heavy leather gloves"
	desc = "A heavier pair of leather gloves with extra padding. These look like they can take some beating. Fair melee protection and decent durability."
	icon_state = "angle"
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	resistance_flags = FLAMMABLE // Made of leather

	armor = ARMOR_LEATHER
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB
	max_integrity = INTEGRITY_STANDARD
	salvage_result = /obj/item/natural/fur
	item_weight = 800 GRAMS

/obj/item/clothing/gloves/angle/advanced
	name = "hardened heavy leather gloves"
	desc = "A heavier pair of leather gloves with extra, solid padding. These look like they can take a hard beating. Good melee protection and reliable durability."
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB
	armor = list("blunt" = 50, "slash" = 40, "stab" = 35, "piercing" = 15, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/angle/masterwork
	name = "masterwork heavy leather gloves"
	desc = "A heavier pair of leather gloves with extra, thick padding. These look like they can take a brutal beating. Great melee protection and very reliable durability."
	max_integrity = INTEGRITY_STRONG + 100
	prevent_crits = ALL_EXCEPT_STAB
	armor = list("blunt" = 80, "slash" = 60, "stab" = 40, "piercing" = 15, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/angle/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/gloves/angle/grenzel
	name = "grenzelhoft gloves"
	desc = "Regal gloves of Grenzelhoftian design, more a fashion statement than actual protection."
	icon_state = "grenzelgloves"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'

// gronn subtypes
/obj/item/clothing/gloves/angle/gronn
	name = "osslandic fur-lined leather gloves"
	desc = "Thick, padded gloves made for the harshest of climates and the wildest of beasts encountered in the untamed north."
	icon_state = "gronnleathergloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	color = "#ffffff"

/obj/item/clothing/gloves/angle/gronnfur
	name = "osslandic fur-lined bone gloves"
	desc = "A pair of hardened leather gloves with bone reinforcements across the wrists\
			and the back of the hand, offering superior protection against\
			the claws of beasts and plants alike. Commonly worn by gatherers."
	icon_state = "gronnfurgloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	unarmed_bonus = 1.25
	max_integrity = 250
	color = "#ffffff"
