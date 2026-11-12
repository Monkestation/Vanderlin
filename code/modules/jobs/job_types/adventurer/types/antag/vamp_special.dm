// A caveat job to catch Vampire Spawn that are somehow children. Otherwise they're kicked back to the lobby and there's one less vampire in the round.
/datum/attribute_holder/sheet/job/young_vampire
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 5,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10
	)

/datum/job/advclass/vampspecial/rascal
	title= "Immortal Rascal"
	tutorial = "You were cursed when you were very young, growth stunted by immortality your physical age is a poor reflection of the centuries. Perhaps with your lord's ascension, you will finally age."
	outfit = /datum/outfit/vamp_rascal
	category_tags = list(CTAG_VAMP_ADVENTURE)
	attribute_sheet = /datum/attribute_holder/sheet/job/young_vampire
	allowed_ages = list(AGE_CHILD)

/datum/outfit/vamp_rascal/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	head = pick(
		/obj/item/clothing/head/helmet/kettle/iron,
		/obj/item/clothing/head/helmet/ironpot,
		/obj/item/clothing/head/helmet/winged,
		/obj/item/clothing/head/helmet/horned,
	)
	armor = /obj/item/clothing/shirt/rags
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/tights/colored/random
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/mace/woodclub
