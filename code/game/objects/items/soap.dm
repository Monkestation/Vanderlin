/obj/item/soap
	name = "soap"
	desc = "A combination of ash and animal fats used for cleaning. Typically dissolved in water."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 1
	throw_range = 7
	var/clean_speed = 0.75 SECONDS
	var/clean_effectiveness = 50
	var/clean_strength = CLEAN_SCRUB
	force_string = "robust... against filth"
	var/uses = 100
	var/slip_chance = 15

/obj/item/soap/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/slippery, 8, NONE, null, 0, FALSE, slip_chance)
	AddComponent(
		/datum/component/cleaner, \
		clean_speed, \
		clean_strength, \
		clean_effectiveness, \
		TRUE, \
		CALLBACK(src, PROC_REF(should_clean)), \
		CALLBACK(src, PROC_REF(on_clean_success)), \
		CALLBACK(src, PROC_REF(on_clean_ineffective)), \
	)

/obj/item/soap/proc/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	if(ismob(atom_to_clean))
		return DO_NOT_CLEAN
	if(isitem(atom_to_clean) && atom_to_clean.reagents && atom_to_clean.is_open_container())
		return DO_NOT_CLEAN
	return check_allowed_items(atom_to_clean) ? TRUE : DO_NOT_CLEAN

/obj/item/soap/proc/on_clean_success(datum/source, atom/target, mob/living/user, clean_succeeded)
	if(clean_succeeded)
		decreaseUses(user, 5)

/obj/item/soap/proc/on_clean_ineffective(atom/target, mob/living/user)
	to_chat(user, span_warning("This isn't working very well. I should use it with a bucket and a rag."))


/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "It looks like it was just made."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "There's just a tiny bit left of what it used to be, you're not sure it'll last much longer."
			if(0.15 to 0.30)
				msg = "It's dissolved quite a bit, but there's still some life to it."
			if(0.30 to 0.50)
				msg = "It's past its prime, but it's definitely still good."
			if(0.50 to 0.75)
				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
			else
				msg = "It's seen some light use, but it's still pretty fresh."
	. += span_notice("[msg]")

/**
 * Decrease the number of uses the bar of soap has.
 *
 * Arguments
 * * user - The mob that is using the soap to clean.
 * * amount - the amount of soap to use.
 */
/obj/item/soap/proc/decreaseUses(mob/living/user, amount)
	uses-= amount
	if(uses <= 0)
		noUses(user)

/obj/item/soap/proc/noUses(mob/user)
	to_chat(user, span_warning("\The [src] crumbles into tiny bits!"))
	qdel(src)


/obj/item/soap/attack(mob/living/carbon/human/target, mob/living/carbon/user, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)

	if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(target.is_mouth_covered())
			to_chat(user, span_warning("[target.p_their(TRUE)] mouth is blocked!"))
			return FALSE

		if(user != target)
			var/obj/item/grabbing/G = user.get_active_held_item()
			if(!istype(G) || !ishuman(G.grabbed) || G.grabbed != target) // gotta have the target in your offhand
				to_chat(user, span_warning("I can't hold them still if I don't grab them!"))
				return FALSE
		user.visible_message(span_warning("<[user] starts to wash \the [target]'s mouth out with [src]..."), span_notice("I start to wash \the [target]'s mouth out with [src]...")) //washes mouth out with soap sounds better than 'the soap' here
		// how this looks vvv https://www.desmos.com/calculator/55fpadxol5
		if(do_after(user, (20 / user.STASPD + 2) SECONDS, target))
			user.visible_message(span_warning("[user] washes \the [target]'s mouth out with [src]!"), span_notice("I wash \the [target]'s mouth out with [src]!")) //washes mouth out with soap sounds better than 'the soap' here
			target.emote("drown")
			target.adjustOxyLoss(20)
			var/datum/reagents/reagents = new()
			reagents.add_reagent(/datum/reagent/soap, 5)
			reagents.trans_to(target, reagents.total_volume, transfered_by = user, method = INGEST)
			log_combat(user, target, "fed", /datum/reagent/soap)
			decreaseUses(5)
			target.lip_style = null //removes lipstick
			target.update_body()
			return TRUE


	if(!ishuman(target))
		to_chat(user, span_warning("They don't want to be soaped..."))
		return FALSE

	var/turf/T = get_turf(target)
	if(!istype(T, /turf/open/water))
		if(istype(T, /turf/open/lava) && user == target) //shits and giggles
			to_chat(user, span_warning("Why am I doing this..."))
		else
			to_chat(user, span_warning("They must be in water!"))
		return FALSE
	else
		var/turf/open/water/bathspot = T
		if(!bathspot.wash_in)
			to_chat(user, span_warning("I can't bathe in this..."))
			return FALSE

	if(istype(target.head, /obj/item/clothing) || istype(target.wear_armor, /obj/item/clothing) || istype(target.wear_shirt, /obj/item/clothing) || istype(target.cloak, /obj/item/clothing))
		to_chat(user, span_warning("Can't get a proper bath with clothing on."))
		return FALSE
	if(istype(target.gloves, /obj/item/clothing))
		to_chat(user, span_warning("Can't get a proper bath with gloves on."))
		return FALSE
	if(istype(target.wear_pants, /obj/item/clothing) && !istype(target.wear_pants, /obj/item/clothing/pants/loincloth)) // you can bathe in a loincloth
		to_chat(user, span_warning("Can't get a proper bath with pants on."))
		return FALSE
	if(istype(target.shoes, /obj/item/clothing))
		to_chat(user, span_warning("Can't get a proper bath with shoes on."))
		return FALSE

	user.visible_message(span_info("\The [user] begins scrubbing \the [target] with [src]."))
	playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(do_after(user, 5 SECONDS, target))
		playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		scrub_scrub(target, user)
		return TRUE
	return FALSE

/obj/item/soap/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()

	var/obj/O = attacked_atom
	var/datum/reagents/r = O.reagents
	if(!r || !O.is_open_container())
		return ..()
	. = TRUE
	if(r.total_volume >= r.maximum_volume)
		to_chat(user, span_warning("There's no room to add [src]."))
		return
	var/datum/reagent/wawa = r.get_reagent_amount(/datum/reagent/water)
	if(!wawa)
		to_chat(user, span_warning("[O] needs to have water to dissolve [src]!"))
		return
	var/amt2Add = min(10, wawa, r.maximum_volume - r.total_volume)
	if(do_after(user, 2 SECONDS, O))
		var/datum/reagents/reagents = new()
		reagents.add_reagent(/datum/reagent/soap, amt2Add)
		reagents.trans_to(O, reagents.total_volume, transfered_by = user, method = TOUCH)
		to_chat(user, span_info("I dissolve some of \the [name] in the water."))
		decreaseUses(5)

/obj/item/soap/proc/scrub_scrub(mob/living/carbon/human/target, mob/living/carbon/user)
	target.wash(clean_strength)
	user.visible_message(span_info("[user] scrubs [target] with [src]."), span_info("I scrub [target] with [src]."))
	decreaseUses(5)
	target.add_stress(/datum/stress_event/clean)
	target.adjust_hygiene(50)
	target.ExtinguishMob()
	target.adjust_fire_stacks(-20)

/obj/item/soap/bath
	name = "herbal soap"
	icon_state = "soapherbal"
	desc = "A combination of ash and animal fats used for cleaning. Typically dissolved in water. This one smells pretty nice."
	uses = 40

//Only get the buff if you use the good stuff
/obj/item/soap/bath/scrub_scrub(mob/living/carbon/human/target, mob/living/carbon/user)
	. = ..()
	if(target.hygiene == HYGIENE_LEVEL_CLEAN)
		to_chat(target, span_green("I feel so relaxed and clean!"))
		target.apply_status_effect(/datum/status_effect/buff/clean_plus)
		user.add_stress(/datum/stress_event/clean_plus)
