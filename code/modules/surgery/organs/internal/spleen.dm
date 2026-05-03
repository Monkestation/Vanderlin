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
	nutriment_req = 2.4
	hydration_req = 0.9

	var/blood_regen_factor = 0.01 // how much blood the spleen regenerates per efficiency point, per 2 seconds

/obj/item/organ/spleen/get_availability(datum/species/S)
	return (!(NOBLOOD in S.species_traits))
