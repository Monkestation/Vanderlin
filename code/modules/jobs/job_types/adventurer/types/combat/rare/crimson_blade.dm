/datum/attribute_holder/sheet/job/crimson_blade
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_SPEED = 2,
		STAT_PERCEPTION = 1,
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/swords = 45,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/athletics = 45,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 20,
	)

/datum/job/advclass/combat/crimson_blade
	title = "Crimson Blade"
	tutorial = "Hailing from Valorian lands you are a master of the blade. \
	Forced to bear the weight of your cursed bloodline you have a deeper connection to your infernal heritage, \
	with fire at your fingertips and racing across your blade you bring a burning death to all dishonorable filth."
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/courtagent/crimson_blade
	cmode_music = 'sound/music/cmode/adventurer/combat_vaquero.ogg'
	total_positions = 1
	roll_chance = 7

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/crimson_blade

	spells = list(
		/datum/action/cooldown/spell/projectile/fire_flare/crimson_blade,
		/datum/action/cooldown/spell/enchantment/green_flame/crimson_blade
	)

	traits = list(
		TRAIT_EXPERT_PARRY
	)

/datum/outfit/crimson_blade
	name = "Crimson Blade (Adventurer)"
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/colored/crimsonblade
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/sword/rapier
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/belt/pouch/coins/mid
	scabbards = list(/obj/item/weapon/scabbard/sword)
