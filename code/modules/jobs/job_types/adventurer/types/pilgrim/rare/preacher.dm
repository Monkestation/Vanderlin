/datum/job/advclass/pilgrim/rare/preacher
	title = "Preacher"
	tutorial = "A devout follower of Psydon, you came to this land with nothing more than \
	the clothes on your back and the faith in your heart. \n\
	Sway these nonbelievers to the right path!"
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/adventurer/preacher
	category_tags = list(CTAG_PILGRIM)
	total_positions = 1

	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

/datum/outfit/adventurer/preacher/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/colored/black
	neck = /obj/item/clothing/neck/psycross
	head = /obj/item/clothing/head/brimmed
	r_hand = /obj/item/book/bibble/psy
	beltl = /obj/item/handheld_bell
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		if(!H.has_language(/datum/language/oldpsydonic))
			H.grant_language(/datum/language/oldpsydonic)
			to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")
		if(!istype(H.patron, /datum/patron/psydon)) // don't overwrite extremist psydon
			H.set_patron(/datum/patron/psydon, TRUE)
	ADD_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
