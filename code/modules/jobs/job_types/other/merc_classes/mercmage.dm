/datum/job/advclass/mercenary/sellmage
	//a mage noble selling his services.
	title = "Sellmage"
	tutorial = "( DUE TO BEING A NOBLE, THIS CLASS WILL BE DIFFICULT FOR INHUMEN. YOU HAVE BEEN WARNED. )\
	\n\n\ \
	You're a noble, but in name only. You were taught in magic from an early age, but it wasn't enough. \
	You lost your wealth, taken away by force or spent carelessly by your family. \
	Either way, the result is the same. Your family fortune is gone, and you have become a mercenary to make ends meet. \
	It was gruelling, certainly difficult, but you're now a seasoned mage who can handle themselves during combat. \
	You have the scars and the arcyne prowess to prove it, after all.\
	\n\n\ \
	Yet after all this, you still think to yourself, that this work is beneath you, as your sense of pride protests every morning. \
	But it all goes away whenever a zenarii filled pouch is thrown your way, for a while at least."
	//not RACES_PLAYER_NONDISCRIMINATED becauses they are a FOREIGN noble
	allowed_races = RACES_PLAYER_FOREIGNNOBLE
	outfit = /datum/outfit/mercenary/sellmage
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2 //balance slop
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)//they were a mage, or learnt magic, before becoming a mercenary
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)//only noc or zizo worshippers can be mages
	exp_types_granted  = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)

/datum/outfit/mercenary/sellmage/pre_equip(mob/living/carbon/human/H)
	..()

	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)

	if(prob(1)) //extremely rare just like court mage
		H.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	shirt = /obj/item/clothing/armor/chainmail/iron //intended, iron chainmail underneath the robe to stop knives
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/storage/magebag/poor
	beltl = /obj/item/weapon/knife/dagger/steel/special //remnant from when they were a noble
	shoes = /obj/item/clothing/shoes/nobleboot
	neck = /obj/item/storage/belt/pouch/coins/poor //broke
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron
	backpack_contents = list(/obj/item/book/granter/spellbook/adept = 1, /obj/item/chalk = 1, /obj/item/reagent_containers/glass/bottle/manapot = 1)

	//combat
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)

	//athleticism and movement
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)

	//misc skills
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_END, 1)//to counteract the innate endurance loss
		H.change_stat(STATKEY_PER, -1)//instead they lose some perception

	//increased endurance more than common mages due to them being a merc
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_INT, 4)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_PER, -1)
	H.change_stat(STATKEY_STR, -1)

	H.adjust_spell_points(8)//less than courtmagician, more than an a adventurer wizard

	H.merctype = 9

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

/datum/outfit/mercenary/sellmage/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "WIZARD")
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
