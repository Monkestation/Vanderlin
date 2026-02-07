// Note: tails only work in humans. They use human-specific parameters and rely on human code for displaying.
/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	var/can_wag = TRUE
	var/wagging = FALSE

/obj/item/organ/tail/Remove(mob/living/carbon/human/H,  special = 0)
	. = ..()
	if(H && H.dna && H.dna.species)
		H.dna.species.stop_wagging_tail(H)

/obj/item/organ/tail/cat
	name = "cat tail"

/obj/item/organ/tail/harpy
	name = "harpy plumage"
	accessory_type = /datum/sprite_accessory/tail/hawk

/obj/item/organ/tail/medicator
	name = "medicator plumage"
	desc = "A foul smelling substance drips from the tips, even without its host."
	accessory_type = /datum/sprite_accessory/tail/medicator
	var/datum/component/stillness_timer/stillness

/obj/item/organ/tail/medicator/Destroy()
	if(stillness)
		QDEL_NULL(stillness)
	return ..()

/obj/item/organ/tail/medicator/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!istype(owner, /mob/living/carbon/human/dummy))
		stillness = owner.AddComponent(/datum/component/stillness_timer, 25 SECONDS, null, CALLBACK(src, PROC_REF(do_goop)))

/obj/item/organ/tail/medicator/Remove(mob/living/carbon/human/H, special)
	. = ..()
	if(stillness)
		QDEL_NULL(stillness)

/obj/item/organ/tail/medicator/proc/do_goop()
	if(!owner || QDELETED(src))
		return
	if(!isturf(owner.loc))
		return
	var/turf/owner_turf = owner.loc
	if(locate(/obj/effect/decal/cleanable/greenglow) in owner_turf)
		return
	var/obj/effect/decal/cleanable/greenglow/mess = new(owner_turf)
	mess.name = "goo"
	var/matrix/goo_matrix = matrix()
	goo_matrix.Scale(0.3)
	goo_matrix.Turn(-60, 60)
	mess.transform = goo_matrix
	mess.pixel_x += rand(-5, 5)
	mess.pixel_y += rand(-5, 5)

	QDEL_IN(mess, 30 SECONDS)

/obj/item/organ/tail/kobold
	name = "small lizard tail"
	accessory_type = /datum/sprite_accessory/tail/kobold

/obj/item/organ/tail/kobold/round
	accessory_type = /datum/sprite_accessory/tail/kobold/round

/obj/item/organ/tail/triton
	name = "triton bell"
	accessory_type = /datum/sprite_accessory/tail/triton
