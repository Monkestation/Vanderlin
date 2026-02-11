/datum/job/advclass/wretch/bloodsucker
	title = "Bloodsucker"
	tutorial = "You have recently been embraced as a vampire. You do not know whom your sire is, strange urges, unnatural strength, a thirst you can barely control. You were outed as a monster and are now on the run"
	allowed_sexes = list(MALE, FEMALE)
	total_positions = 10
	roll_chance = 100

	pack_title = "Fledgling Origins"
	pack_message = "Choose your past"
	job_packs = list(
		/datum/job_pack/bloodsucker_noble,
		/datum/job_pack/bloodsucker_count,
		/datum/job_pack/bloodsucker_bum,
		/datum/job_pack/bloodsucker_vagrant,
	)

/datum/job/advclass/wretch/bloodsucker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.mind)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire/outcast(/datum/clan/caitiff, TRUE)
		spawned.mind.add_antag_datum(new_antag)

	spawned.grant_undead_eyes()

	if(alert("Do you wish for a random title? You will not receive one if you click No.", "", "Yes", "No") == "Yes")
		var/prev_real_name = spawned.real_name
		var/prev_name = spawned.name
		var/title
		var/list/titles = list("The Nitebeest", "The Ravenous", "The Reborn", "The Immortal", "The Revenant", "The Kindred", "Lord of Murder", "The Coffindweller", "The Hanged Man", "The Second Death", "The Bloodsucker", "Of The Blood", "The Childe", "The Dhampiraj", "The Nitewalker", "The Blade", "The Strangler")
		title = pick(titles)
		spawned.real_name = "[prev_real_name], [title]"
		spawned.name = "[prev_name], [title]"

	wretch_select_bounty(spawned)

/datum/job_pack/bloodsucker_noble
	name = "The Noble"
	pack_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 2
	)

	pack_skills = list(
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/combat/knives = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/bows = 3
	)

	pack_traits = list(
		TRAIT_NOBLE,
		TRAIT_DODGEEXPERT
	)

	pack_contents = list(
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/clothing/neck/gorget = ITEM_SLOT_NECK,
		/obj/item/storage/belt/leather = ITEM_SLOT_BELT,
	)

	pack_backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/wine = 1,
		/obj/item/reagent_containers/glass/cup/golden = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/clothing/face/shepherd/rag = 1
	)

/datum/job_pack/bloodsucker_noble/can_pick_pack(mob/living/carbon/human/picker, list/previous_picked_types)
	if(picker.dna?.species?.id in RACES_PLAYER_NONDISCRIMINATED)
		return TRUE
	else
		return FALSE

/datum/job_pack/bloodsucker_noble/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	var/prev_real_name = picker.real_name
	var/prev_name = picker.name
	var/honorary = "Lord"
	if(picker.pronouns == SHE_HER)
		honorary = "Lady"
	picker.real_name = "[honorary] [prev_real_name]"
	picker.name = "[honorary] [prev_name]"

	picker.adjust_skillrank(/datum/skill/misc/music, pick(1,2), TRUE)

	if(picker.gender == FEMALE)
		var/obj/item/clothing/shirt/dress/silkdress/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/head/hatfur/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
		var/obj/item/clothing/cloak/raincloak/furcloak/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/backr = new()
		picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		var/obj/item/weapon/sword/rapier/dec/beltr = new()
		picker.equip_to_slot_or_del(beltr, ITEM_SLOT_BELT_R, TRUE)
		var/obj/item/ammo_holder/quiver/arrows/beltl = new()
		picker.equip_to_slot_or_del(beltl, ITEM_SLOT_BELT_L, TRUE)

	if(picker.gender == MALE)
		var/obj/item/clothing/pants/tights/colored/black/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/tunic/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/cloak/raincloak/furcloak/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
		var/obj/item/clothing/head/fancyhat/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/backr = new()
		picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		var/obj/item/weapon/sword/rapier/dec/beltr = new()
		picker.equip_to_slot_or_del(beltr, ITEM_SLOT_BELT_R, TRUE)
		var/obj/item/ammo_holder/quiver/arrows/beltl = new()
		picker.equip_to_slot_or_del(beltl, ITEM_SLOT_BELT_L, TRUE)


/datum/job_pack/bloodsucker_count
	name = "The Count"
	pack_stats = list(
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_STR = 2
	)

	pack_skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/music = 1,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 3
	)

	pack_traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE,
	)

	pack_contents = list(
		/obj/item/clothing/shoes/rare/grenzelhoft = ITEM_SLOT_SHOES,
		/obj/item/clothing/gloves/angle/grenzel = ITEM_SLOT_GLOVES,
		/obj/item/clothing/head/helmet/skullcap/grenzelhoft = ITEM_SLOT_HEAD,
		/obj/item/storage/belt/leather/plaquegold = ITEM_SLOT_BELT,
		/obj/item/weapon/sword/sabre/dec = ITEM_SLOT_BELT_L,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_R,
		/obj/item/clothing/ring/gold = ITEM_SLOT_RING,
		/obj/item/clothing/shirt/grenzelhoft = ITEM_SLOT_SHIRT,
		/obj/item/clothing/pants/grenzelpants = ITEM_SLOT_PANTS,
		/obj/item/clothing/neck/gorget = ITEM_SLOT_NECK,
	)

	pack_backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/clothing/face/shepherd/rag = 1
	)

/datum/job_pack/bloodsucker_count/can_pick_pack(mob/living/carbon/human/picker, list/previous_picked_types)
	if(picker.dna?.species?.id in RACES_PLAYER_GRENZ)
		return TRUE
	else
		return FALSE

/datum/job_pack/bloodsucker_count/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	var/prev_real_name = picker.real_name
	var/prev_name = picker.name
	var/honorary = "Count"
	if(picker.pronouns == SHE_HER)
		honorary = "Countess"
	picker.real_name = "[honorary] [prev_real_name]"
	picker.name = "[honorary] [prev_name]"

	if(!picker.has_language(/datum/language/oldpsydonic))
		picker.grant_language(/datum/language/oldpsydonic)

	if(picker.dna?.species.id == SPEC_ID_HUMEN)
		picker.dna.species.native_language = "Old Psydonic"
		picker.dna.species.accent_language = picker.dna.species.get_accent(picker.dna.species.native_language)


/datum/job_pack/bloodsucker_bum
	name = "The Bum"

	pack_traits = list(
		TRAIT_DODGEEXPERT,
	)

	pack_spells = list(
		/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire
	)

	pack_contents = list(
		/obj/item/clothing/cloak/tribal = ITEM_SLOT_CLOAK,
	)

/datum/job_pack/bloodsucker_bum/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.adjust_stat_modifier(STATMOD_PACK, STATKEY_STR, pick(1, 2, 3))
	picker.adjust_stat_modifier(STATMOD_PACK, STATKEY_INT, pick(1, 2))
	picker.adjust_stat_modifier(STATMOD_PACK, STATKEY_SPD, pick(2, 3))

	picker.adjust_skillrank(/datum/skill/misc/sneaking, pick(4, 5), TRUE)
	picker.adjust_skillrank(/datum/skill/misc/stealing, pick(4, 5), TRUE)
	picker.adjust_skillrank(/datum/skill/misc/lockpicking, pick(1, 2, 3, 4, 5), TRUE)
	picker.adjust_skillrank(/datum/skill/misc/climbing, pick(4, 5), TRUE)
	picker.adjust_skillrank(/datum/skill/combat/wrestling, pick(3, 3, 4, 4), TRUE)
	picker.adjust_skillrank(/datum/skill/combat/unarmed, pick(3, 4, 5, 5), TRUE)

	picker.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	picker.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
	picker.adjust_skillrank(/datum/skill/misc/sewing, 4, TRUE)
	picker.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)

	picker.base_fortune = rand(7, 20)


/datum/job_pack/bloodsucker_vagrant
	name = "The Vagrant"
	pack_stats = list(
		STATKEY_SPD = 2,
		STATKEY_END = 2,
		STATKEY_STR = 1
	)

	pack_skills = list(
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/music = 6,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 3
	)

	pack_traits = list(
		TRAIT_DODGEEXPERT,
	)

	pack_contents = list(
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/clothing/gloves/fingerless = ITEM_SLOT_GLOVES,
		/obj/item/clothing/head/knitcap = ITEM_SLOT_HEAD,
		/obj/item/storage/belt/leather = ITEM_SLOT_BELT,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_R,
		/obj/item/clothing/shirt/rags = ITEM_SLOT_SHIRT,
		/obj/item/clothing/face/spectacles/sglasses = ITEM_SLOT_MASK,
		/obj/item/clothing/pants/trou/beltpants = ITEM_SLOT_PANTS,
		/obj/item/clothing/neck/coif = ITEM_SLOT_NECK,
		/obj/item/clothing/armor/leather/jacket/leathercoat/renegade = ITEM_SLOT_ARMOR,
	)

	pack_backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/clothing/face/shepherd/rag = 1
	)

/datum/job_pack/bloodsucker_vagrant/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.cmode_music = 'sound/music/cmode/antag/CombatBeest.ogg'
