#define LIVER_DEFAULT_TOX_TOLERANCE 3 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_LETHALITY 0.01 //lower values lower how harmful toxins are to the liver

/obj/item/organ/liver
	name = "liver"
	icon_state = "liver"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER
	desc = ""
	organ_efficiency = list(ORGAN_SLOT_LIVER = 100)
	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING

	organ_volume = 2
	max_blood_storage = 25
	current_blood = 25
	blood_req = 4
	oxygen_req = 4
	nutriment_req = 1.2
	hydration_req = 1.2

	var/alcohol_tolerance = ALCOHOL_RATE        //affects how much damage the liver takes from alcohol
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE  //maximum amount of toxins the liver can just shrug off
	var/toxLethality = LIVER_DEFAULT_TOX_LETHALITY  //affects how much damage toxins do to the liver
	var/filterToxins = FALSE                    //whether to filter toxins
	food_type = /obj/item/reagent_containers/food/snacks/meat/organ/liver

/obj/item/organ/liver/on_owner_examine(datum/source, mob/user, list/examine_list)
	if(!ishuman(owner) || !is_failing())
		return

	var/mob/living/carbon/human/humie_owner = owner
	if(!humie_owner.getorganslot(ORGAN_SLOT_EYES) || humie_owner.is_eyes_covered())
		return
	var/eyes_amount = LAZYLEN(humie_owner.getorganslotlist(ORGAN_SLOT_EYES))
	switch(failure_time)
		if(0 to 3 * LIVER_FAILURE_STAGE_SECONDS - 1)
			examine_list += span_notice("<b>[owner]</b>'s eye[eyes_amount > 1 ? "s" : ""] [eyes_amount > 1 ? "are" : "is"] slightly yellow.")
		if(3 * LIVER_FAILURE_STAGE_SECONDS to 4 * LIVER_FAILURE_STAGE_SECONDS - 1)
			examine_list += span_notice("<b>[owner]</b>'s eye[eyes_amount > 1 ? "s" : ""] [eyes_amount > 1 ? "are" : "is"] completely yellow.")
		if(4 * LIVER_FAILURE_STAGE_SECONDS to INFINITY)
			examine_list += span_danger("<b>[owner]</b>'s eye[eyes_amount > 1 ? "s" : ""] [eyes_amount > 1 ? "are" : "is"] completely yellow and swelling with pus.")

#undef LIVER_DEFAULT_TOX_TOLERANCE
#undef LIVER_DEFAULT_TOX_LETHALITY
