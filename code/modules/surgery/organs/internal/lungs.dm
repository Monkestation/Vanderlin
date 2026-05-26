/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "lungs"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	organ_efficiency = list(ORGAN_SLOT_LUNGS = 100)
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.8
	high_threshold = STANDARD_ORGAN_THRESHOLD * 0.4
	low_threshold = STANDARD_ORGAN_THRESHOLD * 0.2

	organ_volume = 1
	max_blood_storage = 25
	current_blood = 25
	blood_req = 4
	oxygen_req = 4
	nutriment_req = 1.5
	hydration_req = 1.5

	high_threshold_passed = "<span class='warning'>I feel some sort of constriction around my chest as my breathing becomes shallow and rapid.</span>"
	now_fixed = "<span class='warning'>My lungs seem to once again be able to hold air.</span>"
	high_threshold_cleared = "<span class='info'>The constriction around my chest loosens as my breathing calms down.</span>"

	food_type = /obj/item/reagent_containers/food/snacks/meat/organ/lungs

/obj/item/organ/lungs/on_life(delta_time, times_fired)
	. = ..()
	if(failed)
		if(!is_failing())
			failed = FALSE
			return
	else if(is_failing())
		if(owner.stat == CONSCIOUS)
			owner.visible_message("<span class='danger'>[owner] grabs [owner.p_their()] throat, struggling for breath!</span>", \
								"<span class='danger'>I suddenly feel like you can't breathe!</span>")
		to_chat(owner, span_userdanger("I CAN'T BREATHE!"))
		failed = TRUE
	if(damage >= low_threshold)
		var/do_i_cough = DT_PROB((damage < high_threshold) ? 2.5 : 5, delta_time) // between : past high
		if(do_i_cough)
			owner.emote("cough")

/obj/item/organ/lungs/on_owner_examine(datum/source, mob/user, list/examine_list)
	if(!ishuman(owner))
		return
	if(is_failing())
		examine_list += span_danger("<b>[owner]</b>'s lips and fingertips have a faint bluish tinge, and [owner.p_their()] chest rises and falls in rapid, shallow heaves.")
	else if(damage >= high_threshold)
		examine_list += span_warning("<b>[owner]</b>'s breathing is visibly rapid and labored.")
	else if(damage >= low_threshold)
		examine_list += span_notice("<b>[owner]</b>'s breathing seems slightly faster than normal.")


/obj/item/organ/lungs/get_availability(datum/species/S)
	return !(TRAIT_NOBREATH in S.inherent_traits)

/obj/item/organ/lungs/prepare_eat()
	var/obj/S = ..()
	return S

/obj/item/organ/lungs/plasmaman
	name = "plasma filter"
	desc = ""
	icon_state = "lungs-plasma"


/obj/item/organ/lungs/slime
	name = "vacuole"
	desc = ""
