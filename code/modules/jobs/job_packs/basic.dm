/datum/attribute_holder/sheet/job/pack/creed
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/shields = 40,
	)

/datum/attribute_holder/sheet/job/pack/consecratia
	raw_attribute_list = list(
		/datum/attribute/skill/combat/whipsflails = 50,
		/datum/attribute/skill/combat/shields = 40,
	)

/datum/attribute_holder/sheet/job/pack/crusade
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/knives = 40,
	)

/datum/job_pack/creed
	name = "Covenant And Creed (Broadsword + Shield)"
	pack_sheets = list(
		/datum/attribute_holder/sheet/job/pack/creed
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
	pack_sheets = list(
		/datum/attribute_holder/sheet/job/pack/consecratia
	)

	pack_contents = list(
		/obj/item/weapon/flail/psydon/relic = ITEM_SLOT_HANDS,
		/obj/item/weapon/shield/tower/metal/psy = ITEM_SLOT_BACK_R,
	)

/datum/job_pack/crusade
	name = "Crusade (Greatsword) and a Silver Dagger"
	pack_sheets = list(
		/datum/attribute_holder/sheet/job/pack/crusade
	)

	pack_contents = list(
		/obj/item/weapon/sword/long/greatsword/psydon/relic = ITEM_SLOT_HANDS,
		/obj/item/weapon/knife/dagger/silver/psydon = ITEM_SLOT_HANDS,
		/obj/item/weapon/scabbard/knife = ITEM_SLOT_BACK_L,
	)
