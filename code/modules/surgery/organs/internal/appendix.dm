/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_APPENDIX
	organ_efficiency = list(ORGAN_SLOT_APPENDIX = 100)

	healing_factor = STANDARD_ORGAN_HEALING

	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5
	high_threshold = STANDARD_ORGAN_THRESHOLD * 0.4
	low_threshold =  STANDARD_ORGAN_THRESHOLD * 0.1
	healing_factor = 0
	now_failing = span_warning("An explosion of pain erupts in my lower right abdomen!")
	now_fixed = span_info("The pain in my abdomen has subsided.")

	organ_volume = 0.5
	max_blood_storage = 2.5
	current_blood = 2.5
	blood_req = 0.5
	oxygen_req = 0.25
	nutriment_req = 0.3
	hydration_req = 0.15

	var/inflamation_stage = 0

/obj/item/organ/appendix/update_name()
	. = ..()
	name = "[inflamation_stage ? "inflamed " : null][initial(name)]"

/obj/item/organ/appendix/organ_failure(delta_time)
	. = ..()
	inflamation_stage = TRUE
	owner.adjustToxLoss(0.5 * delta_time, TRUE, TRUE) //forced to ensure people don't use it to gain tox as slime person

/obj/item/organ/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamation_stage)
		S.reagents.add_reagent(/datum/reagent/toxin/bad_food, 5)
	return S
