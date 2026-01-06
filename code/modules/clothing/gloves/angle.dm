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
	item_weight = 4
	sellprice = VALUE_SMALL_LEATHER + M_FUR + SKILL_1

/obj/item/clothing/gloves/angle/grenzel
	name = "grenzelhoft gloves"
	desc = "Regal gloves of Grenzelhoftian design, more a fashion statement than actual protection."
	icon_state = "grenzelgloves"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	sellprice = VALUE_SMALL_LEATHER + M_FUR + SKILL_4
