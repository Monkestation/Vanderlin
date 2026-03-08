/datum/job/advclass/wretch/antiquarian
	title = "Antiquarian"
	tutorial = "You're a professional. You've seen things. Many disturbing, and many strange - and it's all changed who you are. Your years of avoiding the watch of Heartfelt \
	gave you the skills needed to escape when the steam rose from the cracks in the roads, when you saw the fire in the streets, when it took your friends and family away. \
	You're not the same anymore, in mind and in flesh - beyond it all you saw your home be pilfered. It's time to take it all back."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/antiquarian
	total_positions = 10
	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg'

// The idea is that they're a slippery bastard. Cantrip focused, stealth-focused. They rely on their spells.
	languages = list(/datum/language/thievescant)
	allowed_patrons = list(/datum/patron/godless/defiant) // This one has seen too much. Matthiosans are not compatible with Heartfelt.

	skills = list(
		/datum/skill/combat/axesmaces = SKILL_LEVEL_JOURNEYMAN, // Needed just for NPC's.
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT, // They're not meant to kill.
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/stealing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/bombs = SKILL_LEVEL_JOURNEYMAN // To craft Smoke Bombs.
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_STINKY, // Flies gotta come from somewhere!
		TRAIT_THIEVESGUILD,
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP
	)

	jobstats = list(
		STATKEY_CON = -1,
		STATKEY_END = -1,
		STATKEY_STR = -2 // These are all relatively low, the class requires cantrips to work around these.
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/conjure_item/smoke_bomb,
		/datum/action/cooldown/spell/undirected/adrenalinerush,
		/datum/action/cooldown/spell/undirected/secondsight,
		///datum/action/cooldown/spell/undirected/jaunt/ethereal_jaunt, // He's missing a two-tile jaunt, something to slip under doors. Outta my skill-level. Oh well!
		/datum/action/cooldown/spell/undirected/conjure_item/summon_lockpick,
		/datum/action/cooldown/spell/projectile/flashpowder,
		///datum/action/cooldown/spell/aoe/snuff,
		/datum/action/cooldown/spell/undirected/conjure_item/calling_card
	)
	honoraries = list(
		"Acquisitions Expert" = HONORARY_PREFIX,
		"the Cleptologist" = HONORARY_SUFFIX,
		"the One Who Walks" = HONORARY_SUFFIX,
		"of Deadly Shadows" = HONORARY_SUFFIX,
		"the Prince of Shadows" = HONORARY_SUFFIX,
		"the Recovery Specialist" = HONORARY_SUFFIX,
		"the Acquirer" = HONORARY_SUFFIX,
		"the Antiquarian" = HONORARY_SUFFIX,
		"the Art Critic" = HONORARY_SUFFIX,
		"the Collector" = HONORARY_SUFFIX,
		"the Courier" = HONORARY_SUFFIX,
		"the Crow" = HONORARY_SUFFIX,
		"the Fence" = HONORARY_SUFFIX,
		"the Filcher" = HONORARY_SUFFIX,
		"the Ghost" = HONORARY_SUFFIX,
		"the Grifter" = HONORARY_SUFFIX,
		"the Infiltrator" = HONORARY_SUFFIX,
		"the Intruder" = HONORARY_SUFFIX,
		"the Invisible" = HONORARY_SUFFIX,
		"the Keeper" = HONORARY_SUFFIX,
		"the Locksmith" = HONORARY_SUFFIX,
		"the Lurker" = HONORARY_SUFFIX,
		"the Magpie" = HONORARY_SUFFIX,
		"the Mask" = HONORARY_SUFFIX,
		"the Master Thief" = HONORARY_SUFFIX,
		"the Night Watch" = HONORARY_SUFFIX,
		"the Phantom" = HONORARY_SUFFIX,
		"the Raven" = HONORARY_SUFFIX,
		"the Respectable Citizen" = HONORARY_SUFFIX,
		"the Shadow" = HONORARY_SUFFIX,
		"the Skeleton Key" = HONORARY_SUFFIX,
		"the Specialist" = HONORARY_SUFFIX,
		"the Stalker" = HONORARY_SUFFIX,
		"the Trickster" = HONORARY_SUFFIX,
		"the Watcher" = HONORARY_SUFFIX,
	)

/datum/outfit/wretch/antiquarian/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Antiquarian (Wretch)"
	mask = /obj/item/clothing/face/antiq
	shoes = /obj/item/clothing/shoes/boots/leather
	cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
	head = /obj/item/clothing/head/roguehood/faceless
	shirt = /obj/item/clothing/shirt/tunic/colored/purple
	backr = /obj/item/storage/backpack/satchel
	pants = /obj/item/clothing/pants/trou/leather
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	armor = /obj/item/clothing/armor/leather/splint
	neck = /obj/item/clothing/neck/coif
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/weapon/mace/cudgel
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)


/datum/job/advclass/wretch/antiquarian/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	wretch_select_bounty(spawned)
