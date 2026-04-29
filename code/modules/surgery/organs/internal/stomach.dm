/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_STOMACH
	organ_efficiency = list(ORGAN_SLOT_STOMACH = 100)
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = ""

	healing_factor = STANDARD_ORGAN_HEALING

	organ_volume = 1
	max_blood_storage = 20
	current_blood = 20
	blood_req = 4
	oxygen_req = 4
	nutriment_req = 1.5
	hydration_req = 1.2

	low_threshold_passed = "<span class='info'>My stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.</span>"
	high_threshold_passed = "<span class='warning'>My stomach flares up with constant pain. I can hardly stomach the idea of food right now!</span>"
	high_threshold_cleared = "<span class='info'>The pain in my stomach dies down for now, but food still seems unappealing.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in my stomach have died out.</span>"

	var/disgust_metabolism = 1
	var/metabolism_efficiency = 0.1 // the lowest we should go is 0.05

/obj/item/organ/stomach/Initialize()
	. = ..()
	create_reagents(1000)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		H.clear_alert("disgust")
		H.remove_stress(/datum/stress_event/disgust)
	..()

/obj/item/organ/stomach/fly
	name = "insectoid stomach"
	icon_state = "stomach-x" //xenomorph liver? It's just a black liver so it fits.
	desc = ""

/obj/item/organ/stomach/plasmaman
	name = "digestive crystal"
	icon_state = "stomach-p"
	desc = ""

/obj/item/organ/stomach/acid_spit
	var/datum/action/cooldown/spell/projectile/acid_splash/organ/spit

/obj/item/organ/stomach/acid_spit/Destroy(force)
	if(spit)
		QDEL_NULL(spit)
	return ..()

/obj/item/organ/stomach/acid_spit/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	if(QDELETED(spit))
		spit = new(src)
	spit.Grant(M)

/obj/item/organ/stomach/acid_spit/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(QDELETED(spit))
		return
	spit.Remove(M)

/obj/item/organ/guts // relatively unimportant, just fluff :)
	name = "guts"
	icon_state = "guts"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_GUTS
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = ""

	healing_factor = STANDARD_ORGAN_HEALING
	low_threshold_passed = "<span class='info'>My guts flashes with pain before subsiding.</span>"
	high_threshold_passed = "<span class='warning'>My guts flares up with constant pain.</span>"
	high_threshold_cleared = "<span class='info'>The pain in my guts die down for now.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in my guts have died out.</span>"
