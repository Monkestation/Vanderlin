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
		/datum/skill/misc/sewing = SKILL_LEVEL_JOURNEYMAN,
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

/datum/outfit/wretch/antiquarian/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/godless/defiant) // This one has seen too much. Matthiosans are not compatible with Heartfelt.
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
	wretch_select_bounty(H)

	H.grant_language(/datum/language/thievescant)
	to_chat(H, span_info("I can gesture in thieves' cant with ,t before my speech."))

/datum/outfit/wretch/antiquarian/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()

	if(alert("Do you wish for a random title? You will not receive one if you click No.", "", "Yes", "No") == "Yes")
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/title
		var/list/titles = list("The Keeper", "The Phantom", "The Crow", "The Raven", "The Magpie", "The Courier", "The Mask", "The Shadow", "The Ghost", "The Fence", "The Intruder", "The Infiltrator", "The Filcher", "The Grifter", "He Who Walks", "The Invisible", "The Watcher", "The Master Thief", "The Dark Project", "The Lurker", "Prince of Shadows", "The Night Watch", "The Antiquarian", "Acquisitions Expert", "Cleptologist", "The Specialist", "The Stalker", "Of Deadly Shadows", "The Trickster", "The Respectable Citizen", "The Locksmith", "The Acquirer", "The Collector", "The Skeleton Key", "The Art Critic", "Recovery Specialist" ) //Dude, Trust.
		title = pick(titles)
		H.real_name = "[prev_real_name], [title]"
		H.name = "[prev_name], [title]"

