
/obj/item/bee_treatment
	name = "bee medication"
	desc = "A treatment for bee diseases."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream"
	var/treatment_type = "general"
	var/treatment_strength = 30

/obj/item/bee_treatment/afterattack(atom/target, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return

	if(istype(target, /obj/structure/apiary))
		var/obj/structure/apiary/A = target

		if(!A.has_disease)
			to_chat(user, span_notice("The bees don't appear to need treatment."))
			return

		to_chat(user, span_notice("You apply [src] to [A]."))

		var/effectiveness = treatment_strength

		if(A.disease && treatment_type == A.disease.name)
			effectiveness *= 2

		A.treatment_progress += effectiveness

		if(A.treatment_progress >= 100)
			A.has_disease = FALSE
			A.disease = null
			A.disease_severity = 0
			A.treatment_progress = 0
			to_chat(user, span_notice("The bees appear to be recovering!"))
		else
			to_chat(user, span_notice("The treatment seems to be having some effect."))

		A.agitate_bees(20, user)

		qdel(src)

/obj/item/bee_treatment/antiviral
	name = "bee antiviral"
	desc = "A treatment for viral bee diseases like foulbrood."
	treatment_type = "Foulbrood"
	treatment_strength = 40

/obj/item/bee_treatment/miticide
	name = "bee miticide"
	desc = "A treatment for varroa mites that infest bee colonies."
	treatment_type = "Varroa Mites"
	treatment_strength = 40

/obj/item/bee_treatment/insecticide
	name = "targeted insecticide"
	desc = "A treatment for wax moths and other hive pests."
	treatment_type = "Wax Moths"
	treatment_strength = 40

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm bees with smoke."
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "smoker"
	w_class = WEIGHT_CLASS_SMALL
	var/fuel = 20
	var/max_fuel = 20
	var/active = FALSE

/obj/item/bee_smoker/attack_self(mob/user)
	if(!active && fuel > 0)
		to_chat(user, span_notice("You light [src]."))
		active = TRUE
		update_appearance(UPDATE_ICON_STATE)
		process_smoker(user)
	else if(active)
		to_chat(user, span_notice("You extinguish [src]."))
		active = FALSE
		update_appearance(UPDATE_ICON_STATE)
	else
		to_chat(user, span_warning("[src] is out of fuel!"))

/obj/item/bee_smoker/proc/process_smoker(mob/user)
	if(!active)
		return

	if(fuel <= 0)
		active = FALSE
		update_appearance(UPDATE_ICON_STATE)
		to_chat(user, span_warning("[src] runs out of fuel!"))
		return

	var/turf/T = get_turf(src)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.set_up(1, T, 0)
	S.start()

	for(var/obj/effect/bees/B in view(3, user))
		B.agitated = FALSE
		B.agitation_countdown = 0
		B.attacked_mobs.Cut()
		B.bee_state = BEE_STATE_IDLE

	for(var/obj/structure/apiary/A in view(2, user))
		A.calm_bees()

	fuel--

	addtimer(CALLBACK(src, PROC_REF(process_smoker), user), 1 SECONDS)

/obj/item/bee_smoker/update_icon_state()
	. = ..()
	icon_state = active ? "smoker_lit" : "smoker"

/obj/item/bee_smoker/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/natural/bundle/cloth))
		var/obj/item/natural/bundle/cloth/C = I
		if(C.amount >= 1 && fuel < max_fuel)
			to_chat(user, span_notice("You stuff some cloth into [src]."))
			C.use(1)
			fuel = min(fuel + 5, max_fuel)
			return TRUE
	return ..()

/obj/item/magnifying_glass
	name = "magnifying glass"
	desc = "A tool for detailed inspection."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "magnifying_glass"
	grid_height = 64
	grid_width = 32

/obj/item/magnifying_glass/attack(mob/living/M, mob/user, list/modifiers)
	return

/obj/item/magnifying_glass/afterattack(atom/target, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return

	if(istype(target, /obj/structure/apiary))
		var/obj/structure/apiary/A = target

		to_chat(user, span_notice("You carefully inspect [A]."))

		if(A.has_disease && A.disease)
			to_chat(user, A.disease.get_inspection_message())
			to_chat(user, A.disease.get_severity_description(A.disease_severity))
		else
			to_chat(user, span_notice("The bees appear to be healthy."))

		if(A.bee_count + A.outside_bees == 0)
			to_chat(user, span_warning("The hive is empty!"))
		else if(A.bee_count + A.outside_bees < 5)
			to_chat(user, span_warning("The colony is very small."))
		else if(A.bee_count + A.outside_bees < 15)
			to_chat(user, span_notice("The colony is moderate in size."))
		else
			to_chat(user, span_notice("The colony is thriving with many bees!"))
