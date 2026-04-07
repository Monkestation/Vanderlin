//The contant in the rate of reagent transfer on life ticks
#define STOMACH_METABOLISM_CONSTANT 0.5

/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_STOMACH
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = ""

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = "<span class='info'>My stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.</span>"
	high_threshold_passed = "<span class='warning'>My stomach flares up with constant pain. I can hardly stomach the idea of food right now!</span>"
	high_threshold_cleared = "<span class='info'>The pain in my stomach dies down for now, but food still seems unappealing.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in my stomach have died out.</span>"

	var/disgust_metabolism = 1
	var/metabolism_efficiency = 0.1 // the lowest we should go is 0.05

/obj/item/organ/stomach/Initialize()
	. = ..()
	create_reagents(1000)

/obj/item/organ/stomach/on_life()
	. = ..()

	//Manage species digestion
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/humi = owner
		if(!(organ_flags & ORGAN_FAILING))
			humi.dna.species.handle_digestion(humi)

	var/mob/living/carbon/body = owner

	// digest food, sent all reagents that can metabolize to the body
	for(var/datum/reagent/bit as anything in reagents.reagent_list)
		// If the reagent does not metabolize then it will sit in the stomach
		// This has an effect on items like plastic causing them to take up space in the stomach
		if(!(bit.metabolization_rate > 0))
			continue

		//Ensure that the the minimum is equal to the metabolization_rate of the reagent if it is higher then the STOMACH_METABOLISM_CONSTANT
		var/amount_min = max(bit.metabolization_rate, STOMACH_METABOLISM_CONSTANT)
		//Do not transfer over more then we have
		var/amount_max = bit.volume


		// Transfer the amount of reagents based on volume with a min amount of 1u
		var/amount = min(round(metabolism_efficiency * bit.volume, 0.1) + amount_min, amount_max)

		if(!(amount > 0))
			continue

		// transfer the reagents over to the body at the rate of the stomach metabolim
		// this way the body is where all reagents that are processed and react
		// the stomach manages how fast they are feed in a drip style
		reagents.trans_id_to(body, bit.type, amount=amount)

	//Handle disgust
	if(body)
		handle_disgust(body)

	//If the stomach is not damage exit out
	if(damage < low_threshold)
		return

	//We are checking if we have nutriment in a damaged stomach.
	var/datum/reagent/nutri = locate(/datum/reagent/consumable/nutriment) in reagents.reagent_list
	//No nutriment found lets exit out
	if(!nutri)
		return

	//The stomach is damage has nutriment but low on theshhold, lo prob of vomit
	if(prob(damage * 0.025 * nutri.volume * nutri.volume))
		body.vomit(damage)
		to_chat(body, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")
		return

	// the change of vomit is now high
	if(damage > high_threshold && prob(damage * 0.1 * nutri.volume * nutri.volume))
		body.vomit(damage)
		to_chat(body, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")

/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H)
	if(H.disgust)
		var/pukeprob = 5 + 0.05 * H.disgust
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(prob(10))
				H.stuttering += 1
				H.adjust_confusion(4 SECONDS)
			if(prob(10) && !H.stat)
				to_chat(H, "<span class='warning'>I feel kind of iffy...</span>")
			H.adjust_jitter(-6 SECONDS)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(prob(pukeprob)) //iT hAndLeS mOrE ThaN PukInG
				H.adjust_confusion(5 SECONDS)
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.set_dizzy(10 SECONDS)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(prob(25))
				H.set_eye_blur_if_lower(6 SECONDS)

		H.adjust_disgust(-0.5 * disgust_metabolism)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
			H.remove_stress(/datum/stress_event/disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /atom/movable/screen/alert/gross)
			H.add_stress(/datum/stress_event/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /atom/movable/screen/alert/verygross)
			H.add_stress(/datum/stress_event/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /atom/movable/screen/alert/disgusted)
			H.add_stress(/datum/stress_event/disgusted)

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

/obj/item/organ/stomach/ethereal
	name = "biological battery"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = ""
	var/crystal_charge = ETHEREAL_CHARGE_FULL

/obj/item/organ/stomach/ethereal/on_life()
	..()
	adjust_charge(-ETHEREAL_CHARGE_FACTOR)

/obj/item/organ/stomach/ethereal/Insert(mob/living/carbon/M, special = 0)
	..()
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	..()

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, amount, repairs)
	adjust_charge(amount / 70)

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, "<span class='notice'>I absorb some of the shock into my body!</span>")

/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	crystal_charge = CLAMP(crystal_charge + amount, ETHEREAL_CHARGE_NONE, ETHEREAL_CHARGE_FULL)

/obj/item/organ/stomach/acid_spit
	var/datum/action/cooldown/spell/projectile/acid_splash/organ/spit

/obj/item/organ/stomach/acid_spit/Destroy(force)
	if(spit)
		QDEL_NULL(spit)
	return ..()

/obj/item/organ/stomach/acid_spit/Insert(mob/living/carbon/M, special, drop_if_replaced)
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
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = "<span class='info'>My guts flashes with pain before subsiding.</span>"
	high_threshold_passed = "<span class='warning'>My guts flares up with constant pain.</span>"
	high_threshold_cleared = "<span class='info'>The pain in my guts die down for now.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in my guts have died out.</span>"


#undef STOMACH_METABOLISM_CONSTANT
