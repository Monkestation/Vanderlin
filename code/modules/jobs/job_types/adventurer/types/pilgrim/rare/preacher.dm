/datum/attribute_holder/sheet/job/pilgrim/preacher
	raw_attribute_list = list(
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/music = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20
	)

/datum/job/advclass/pilgrim/rare/preacher
	title = "Preacher"
	tutorial = "A devout follower of Psydon, you came to this land with nothing more than \
	the clothes on your back and the faith in your heart. \n\
	Sway these nonbelievers to the right path!"
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/pilgrim/preacher
	category_tags = list(CTAG_PILGRIM)
	total_positions = 1
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/preacher

	traits = list(
		TRAIT_FOREIGNER
	)

	languages = list(/datum/language/newpsydonic)

/datum/job/advclass/pilgrim/rare/preacher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.native_language = "Old Psydonic"
		spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/pilgrim/preacher
	name = "Preacher (Pilgrim)"
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/colored/black
	neck = /obj/item/clothing/neck/psycross
	head = /obj/item/clothing/head/brimmed
	r_hand = /obj/item/book/bibble/psy
	beltl = /obj/item/handheld_bell
