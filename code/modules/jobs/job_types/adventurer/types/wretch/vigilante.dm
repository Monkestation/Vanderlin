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

	jobstats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_LCK = 2
	)

	skills = list(
		/datum/skill/misc/swimming = 4,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/sewing = 4,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/combat/firearms = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/magic/holy = 1
	)

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
 		"Big Iron" = 0,
 		"Bodystacker" = 1,
 		"Corpsestacker" = 1,
 		"Dead or Alive" = 0,
 		"Guns Blazing" = 0,
 		"Heaven's Smile" = 0,
 		"High Noon" = 0,
 		"Last Sight" = 0,
 		"Lethal Shot" = 0,
 		"Mammon Shot" = 0,
 		"Mattarella" = 0,
 		"Freyja's-Dae Nite" = 0,
 		"Number One" = 0,
 		"of No Paradise" = 1,
 		"of the Gallows" = 1,
 		"Flintlock Chirurgeon" = 0,
 		"Subterra-Walker" = 1,
 		"the Cleaner" = 1,
 		"the Courier" = 1,
 		"the Desperado" = 1,
 		"the Equalizer" = 1,
 		"the First Murderer" = 1,
 		"the Gunslinger" = 1,
 		"the Hanged Man" = 1,
 		"the Hitman" = 1,
 		"the Killer Seven" = 1,
 		"the Lifestealer" = 1,
 		"the Mammon-Taker" = 1,
 		"the One Who Sold Creation" = 1,
 		"the Opposition" = 1,
 		"the Power-Monger" = 1,
 		"the Renegade" = 1,
		"the Showoff" = 1,
 		"the Son of a Bitch" = 1,
 		"the Wanted Man" = 1,
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
