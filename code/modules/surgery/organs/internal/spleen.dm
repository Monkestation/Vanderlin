//Spleen: Regenerates blood over time
//Without it, you cannot generate blood without transfusions.
/obj/item/organ/spleen
	name = "spleen"
	desc = "The most underrated organ of the human body."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kidney-l" //placeholder
	zone = BODY_ZONE_CHEST
	organ_efficiency = list(ORGAN_SLOT_SPLEEN = 100)

	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.7
	high_threshold = STANDARD_ORGAN_THRESHOLD * 0.6
	low_threshold = STANDARD_ORGAN_THRESHOLD * 0.2
	w_class = WEIGHT_CLASS_SMALL

	organ_volume = 0.5
	max_blood_storage = 20
	current_blood = 20
	blood_req = 2
	oxygen_req = 2
	nutriment_req = 2.5
	hydration_req = 1

	var/blood_regen_factor = 0.01 // how much blood the spleen regenerates per efficiency point, per 2 seconds

/obj/item/organ/spleen/on_owner_examine(datum/source, mob/user, list/examine_list)
	if(!ishuman(owner))
		return
	if(is_failing())
		examine_list += span_danger("<b>[owner]</b> is ashen-faced, with a waxy, bloodless pallor across [owner.p_their()] skin.")
	else if(damage >= high_threshold)
		examine_list += span_warning("<b>[owner]</b> looks unusually pale and drawn.")
	else if(damage >= low_threshold)
		examine_list += span_notice("<b>[owner]</b> looks a little wan.")

/obj/item/organ/spleen/get_availability(datum/species/S)
	return (!(NOBLOOD in S.species_traits))
