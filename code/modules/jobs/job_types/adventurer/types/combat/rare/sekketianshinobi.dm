/datum/job/advclass/combat/sekketianshinobi
	title = "Sekketian Shinobi"
	tutorial = "You belong to the Shinobi's of Sekket. An elusive order of Xylixian freedom fighters originating from the Queendom of Lakkari. You have dedicated yourself to uplifting the enslaved and oppressed, and hope to continue doing so in the lands you travel."
	allowed_patrons = list(/datum/patron/divine/xylix)
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_TIEFLING,
		SPEC_ID_DROW,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_DROW,\
	) // excluding harpies because their weak as hell, excluding rakshari, hollowkin, and kobolds because they have no lux, which is incredibly taboo in lakkarian society/culture, half orcs are excluded as well becausee theyll be too damn strong
	total_positions = 0 //Lakkari disabled
	roll_chance = 0
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
	outfit = /datum/outfit/adventurer/sekketianshinobi

	jobstats = list(
		STATKEY_END = 1,
		STATKEY_SPD = 2, //they're basically ninjas.
		STATKEY_STR = 1, //because they're mainly supposed to use blunt weapons.
		STATKET_INT = -1,
		STATKEY_PER = -1,
	)

	skills = list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/mathematics = 1,
		/datum/skill/misc/lockpicking = 2, //these guys free slaves, they probably know how to disarm traps and unlock things
		/datum/skill/misc/stealing = 2,
		/datum/skill/craft/crafting = 1,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR, // so they can dodge wearing their mask, these guys dont actually spawn with medium armor, they have to EARN it.

	)

/datum/outfit/adventurer/sekketianshinobi
	name = "Sekketian Shinobi (Adventurer)"
	head = /obj/item/clothing/head/helmet/leather/headscarf/colored/red
	neck = /obj/item/clothing/neck/coif/cloth/colored/berryblue
	mask = /obj/item/clothing/face/shellmask
	armor = /obj/item/clothing/shirt/clothvest/colored/red
	cloak = /obj/item/clothing/shirt/undershirt/sash/colored/white
	gloves = /obj/item/clothing/gloves/angle
	shirt = /obj/item/clothing/armor/gambeson/heavy/colored/dark
	pants = /obj/item/clothing/pants/trou/shadowpants
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/weapon/mace/rungu
	beltl = /obj/item/storage/belt/pouch //broke as hell!
	wrists = /obj/item/clothing/wrists/gem/shellbracelet

