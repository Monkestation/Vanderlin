/datum/attribute_holder/sheet/job/vigilante
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = 1,
		STAT_FORTUNE = 2,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/sewing = 40,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/combat/firearms = 40,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/magic/holy = 10,
	)

/datum/job/advclass/wretch/vigilante
	title = "Renegade"
	tutorial = "A renegade, deserter and a gunslinger, Favoured by Matthios, You've turned your back on the black empire and Psydon alike, Now? you wander around Faience, wielding black powder, grit, and a gambler's instinct."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/wretch/vigilante
	total_positions = 10
	roll_chance = 100
	cmode_music = 'sound/music/cmode/antag/CombatBeest.ogg'
	allowed_patrons = list(/datum/patron/inhumen/matthios)

	attribute_sheet = /datum/attribute_holder/sheet/job/vigilante

	traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_INHUMENCAMP,
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/conjure_item/puffer
	)

	honoraries = list(
 		"Big Iron" = HONORARY_PREFIX,
 		"Dead or Alive" = HONORARY_PREFIX,
 		"Guns Blazing" = HONORARY_PREFIX,
 		"Heaven's Smile" = HONORARY_PREFIX,
 		"High Noon" = HONORARY_PREFIX,
 		"Last Sight" = HONORARY_PREFIX,
 		"Lethal Shot" = HONORARY_PREFIX,
 		"Mammon Shot" = HONORARY_PREFIX,
 		"Mattarella" = HONORARY_PREFIX,
 		"Freyja's-Dae Nite" = HONORARY_PREFIX,
 		"Number One" = HONORARY_PREFIX,
 		"Flintlock Chirurgeon" = HONORARY_PREFIX,
 		"Bodystacker" = HONORARY_SUFFIX,
 		"Corpsestacker" = HONORARY_SUFFIX,
 		"of No Paradise" = HONORARY_SUFFIX,
 		"of the Gallows" = HONORARY_SUFFIX,
 		"Subterra-Walker" = HONORARY_SUFFIX,
 		"the Cleaner" = HONORARY_SUFFIX,
 		"the Courier" = HONORARY_SUFFIX,
 		"the Desperado" = HONORARY_SUFFIX,
 		"the Equalizer" = HONORARY_SUFFIX,
 		"the First Murderer" = HONORARY_SUFFIX,
 		"the Gunslinger" = HONORARY_SUFFIX,
 		"the Hanged Man" = HONORARY_SUFFIX,
 		"the Hitman" = HONORARY_SUFFIX,
 		"the Killer Seven" = HONORARY_SUFFIX,
 		"the Lifestealer" = HONORARY_SUFFIX,
 		"the Mammon-Taker" = HONORARY_SUFFIX,
 		"the One Who Sold Creation" = HONORARY_SUFFIX,
 		"the Opposition" = HONORARY_SUFFIX,
 		"the Power-Monger" = HONORARY_SUFFIX,
 		"the Renegade" = HONORARY_SUFFIX,
		"the Showoff" = HONORARY_SUFFIX,
 		"the Son of a Bitch" = HONORARY_SUFFIX,
 		"the Wanted Man" = HONORARY_SUFFIX,
	)

/datum/job/advclass/wretch/vigilante/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	wretch_select_bounty(spawned)

/datum/outfit/wretch/vigilante
	name = "Renegade (Wretch)"
	neck = /obj/item/clothing/neck/highcollier/iron/renegadecollar
	mask = /obj/item/clothing/face/spectacles/inqglasses
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/armor/gambeson/heavy/colored/dark
	head = /obj/item/clothing/head/leather/inqhat/vigilante
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/colored/wretchrenegade
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/knifebelt/black/iron
	gloves = /obj/item/clothing/gloves/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/storage/fancy/cigarettes/zig = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
