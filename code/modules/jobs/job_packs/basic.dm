/datum/job_pack/creed
	name = "Covenant And Creed (Broadsword + Shield)"
	pack_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)

	pack_contents = list(
		/obj/item/weapon/sword/long/broadsword/psy/relic = ITEM_SLOT_HANDS,
		/obj/item/paper/inqslip/arrival/inq = ITEM_SLOT_HANDS,
		/obj/item/weapon/shield/tower/metal/psy = ITEM_SLOT_BACK_R,
		/obj/item/storage/keyring/inquisitor = ITEM_SLOT_BACK_L,
	)

/datum/job_pack/creed/pick_pack(mob/living/carbon/human/H)
	var/annoyingbag = H.get_item_by_slot(ITEM_SLOT_BACK_L)
	qdel(annoyingbag)
	. = ..()

/datum/job_pack/consecratia
	name = "Covenant and Consecratia (Flail + Shield)"
	pack_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)

	pack_contents = list(
		/obj/item/weapon/flail/psydon/relic = ITEM_SLOT_HANDS,
		/obj/item/weapon/shield/tower/metal/psy = ITEM_SLOT_BACK_R,
	)

/datum/job_pack/crusade
	name = "Crusade (Greatsword) and a Silver Dagger"
	pack_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
	)

	pack_contents = list(
		/obj/item/weapon/sword/long/greatsword/psydon/relic = ITEM_SLOT_HANDS,
		/obj/item/weapon/knife/dagger/silver/psydon = ITEM_SLOT_HANDS,
		/obj/item/weapon/scabbard/knife = ITEM_SLOT_BACK_L,
	)
