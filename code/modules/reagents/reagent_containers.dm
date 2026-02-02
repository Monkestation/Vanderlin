/obj/item/reagent_containers
	name = "Container"
	desc = ""
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_TINY

	grid_height = 64
	grid_width = 32
	/// Starting transfer amount
	var/amount_per_transfer_from_this = 5
	/// Does this container allow changing transfer amounts at all, the container can still have only one possible transfer value in possible_transfer_amounts at some point even if this is true
	var/has_variable_transfer_amount = TRUE
	/// List of selectable transfer amounts
	var/list/possible_transfer_amounts = list(5, 10, 15, 20, 25, 30)
	/// Reagents max volume
	var/volume = 30
	/// Reagent flags, a few examples being if the container is open or not, if its transparent, if you can inject stuff in and out of the container, and so on
	var/reagent_flags
	/// Whether this can be splashed
	var/spillable = FALSE
	/// Current reagents
	var/list/list_reagents = null
	/// List of thresholds to change the filling icon. If null no filling icons are used.
	var/list/fill_icon_thresholds = null // list(10, 50, 100)
	/// Optional custom name for reagent fill icon_state prefix
	var/fill_icon_state = null
	/// Underlays fill state instead of overlaying it
	var/fill_icon_under_override = FALSE
	/// Sounds when consuming
	var/drinksounds = list('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg')
	/// Sounds when filling another container
	var/fillsounds
	/// Sounds when pouring out of
	var/poursounds
	/// Short cooktime, when high cooking skill
	var/short_cooktime = FALSE
	/// Long cooktime, when low cooking skill
	var/long_cooktime = FALSE

	/// Can be labelled by parchment
	var/can_label_container = FALSE
	/// Label prefix such as "bottle of"
	var/label_prefix = null
	/// Label is currently applied to the bottle
	var/labelled = FALSE
	/// Auto label with proc [apply_initial_label] of course requires an override.
	var/auto_label = FALSE

	COOLDOWN_DECLARE(weather_act_cooldown)

/obj/item/reagent_containers/Initialize(mapload, vol)
	. = ..()
	if(isnum(vol) && vol > 0)
		volume = vol
	create_reagents(volume, reagent_flags)

	add_initial_reagents()

	apply_initial_label()

	if(is_open_container())
		GLOB.weather_act_upon_list |= src

/obj/item/reagent_containers/examine(mob/user)
	. = ..()
	if(has_variable_transfer_amount && length(possible_transfer_amounts) > 1)
		. += span_notice("Alt Left-click or right-click in-hand to increase or decrease its transfer amount.")

/obj/item/reagent_containers/Destroy()
	if(is_open_container())
		GLOB.weather_act_upon_list -= src
	return ..()

/obj/item/reagent_containers/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN || !COOLDOWN_FINISHED(src, weather_act_cooldown))
		return
	if(!isturf(loc))
		return
	reagents.add_reagent(/datum/reagent/water, clamp(severity * 0.5, 1, 5))
	COOLDOWN_START(src, weather_act_cooldown, 10 SECONDS)

/obj/item/reagent_containers/ex_act()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			R.on_ex_act()
	if(!QDELETED(src))
		..()

/obj/item/reagent_containers/fire_act(added, maxstacks)
	reagents.expose_temperature(added)
	..()

/obj/item/reagent_containers/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	SplashReagents(hit_atom, TRUE)

/obj/item/reagent_containers/heating_act()
	reagents.expose_temperature(1000)
	..()

/obj/item/reagent_containers/temperature_expose(exposed_temperature, exposed_volume)
	reagents.expose_temperature(exposed_temperature)

/obj/item/reagent_containers/on_reagent_change(changetype)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/update_overlays()
	. = ..()
	if(labelled)
		. += mutable_appearance(icon, "[icon_state]_label")
	if(!reagents?.total_volume)
		return
	if(!fill_icon_thresholds)
		return
	var/fill_name = fill_icon_state ? fill_icon_state : icon_state
	var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[fill_name][fill_icon_thresholds[1]]")

	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/i in 1 to length(fill_icon_thresholds))
		var/threshold = fill_icon_thresholds[i]
		var/threshold_end = (i == length(fill_icon_thresholds)) ? INFINITY : fill_icon_thresholds[i+1]
		if(threshold <= percent && percent < threshold_end)
			filling.icon_state = "[fill_name][fill_icon_thresholds[i]]"

	filling.color = mix_color_from_reagents(reagents.reagent_list)
	filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)

	if(fill_icon_under_override)
		underlays.Cut()
		underlays += filling
	else
		. += filling

	var/datum/reagent/master = reagents.get_master_reagent()
	if(master?.glows)
		. += emissive_appearance(filling.icon, filling.icon_state, alpha = filling.alpha)

/obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!can_label_container || !(istype(I, /obj/item/paper) && !istype(I, /obj/item/paper/scroll)))
		return
	if(labelled)
		to_chat(user, span_warning("\The [src] is already labelled."))
		return
	var/obj/item/paper/parchment = I
	if(length(parchment.info))
		to_chat(user, span_warning("I need a clean parchment."))
		return
	if(!user.is_literate())
		to_chat(user, span_warning("I do not know how to write."))
		return
	var/other_hand = user.get_inactive_held_item()
	if(!other_hand || !istype(other_hand, /obj/item/natural/feather))
		to_chat(user, span_warning("I need a feather to write on the parchment."))
		return
	var/label_name = browser_input_text(user, "Write a name.", max_length = 32)
	if(QDELETED(src) || QDELETED(I))
		return
	var/label_desc = browser_input_text(user, "Write an optional description?")
	if(QDELETED(src) || QDELETED(I))
		return
	if(!label_name && !label_desc)
		to_chat(user, span_warning("I decide not to label \the [src]."))
		return
	label_container(user, label_name, label_desc)
	qdel(I)

/obj/item/reagent_containers/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(iscarbon(user))
		remove_label(user)

/obj/item/reagent_containers/proc/label_container(mob/user, label_name, label_desc)
	if((!label_name && !label_desc) || !can_label_container)
		return
	if(labelled)
		if(user)
			to_chat(user, span_warning("\The [src] is already labelled."))
		return
	if(user)
		playsound(src, 'sound/foley/dropsound/paper_drop.ogg', 70)
		user.visible_message(span_notice("[user] applies a label to \the [src]."), span_notice("I label \the [src]."), vision_distance = 3)
	name = label_prefix ? "[label_prefix][label_name]" : label_name
	if(label_desc)
		desc += " [label_desc]"
	labelled = TRUE
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/proc/remove_label(mob/user, force)
	if(!labelled)
		if(user)
			to_chat(user, span_warning("\The [src] has no label to remove."))
		return
	if(force || !user)
		name = initial(name)
		labelled = FALSE
		return
	if(!do_after(user, 1 SECONDS, src))
		return
	user.visible_message(span_warning("[user] tears the label off of \the [src]!"), span_notice("I remove the label from \the [src]."), vision_distance = 3)
	name = initial(name)
	if(desc != initial(desc))
		desc = initial(desc)
	labelled = FALSE
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/proc/apply_initial_label()
	return

/obj/item/reagent_containers/proc/add_initial_reagents()
	if(list_reagents)
		reagents.add_reagent_list(list_reagents)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/AltClick(mob/user, list/modifiers)
	if(!user.Adjacent(src) || !has_variable_transfer_amount)
		return
	change_transfer_amount(user, FORWARD)

/obj/item/reagent_containers/AltRightClick(mob/user)
	if(!user.Adjacent(src) || !has_variable_transfer_amount)
		return
	change_transfer_amount(user, BACKWARD)

/obj/item/reagent_containers/proc/mode_change_message(mob/user)
	return

/obj/item/reagent_containers/proc/change_transfer_amount(mob/user, direction = FORWARD)
	var/list_len = length(possible_transfer_amounts)
	if(!list_len)
		return
	var/index = possible_transfer_amounts.Find(amount_per_transfer_from_this) || 1
	switch(direction)
		if(FORWARD)
			index = (index % list_len) + 1
		if(BACKWARD)
			index = (index - 1) || list_len
		else
			CRASH("change_transfer_amount() called with invalid direction value")
	amount_per_transfer_from_this = possible_transfer_amounts[index]
	balloon_alert(user, "transferring [UNIT_FORM_STRING(amount_per_transfer_from_this)].")
	mode_change_message(user)

/obj/item/reagent_containers/proc/canconsume(mob/eater, mob/user, silent = FALSE)
	if(!iscarbon(eater))
		return FALSE
	var/mob/living/carbon/C = eater
	var/covered = ""
	if(C.is_mouth_covered(ITEM_SLOT_HEAD))
		covered = "headgear"
	else if(C.is_mouth_covered(ITEM_SLOT_MASK))
		covered = "mask"
	if(C != user)
		if(isturf(eater.loc))
			if(C.body_position != LYING_DOWN)
				if(get_dir(eater, user) != eater.dir)
					to_chat(user, "<span class='warning'>I must stand in front of [C.p_them()].</span>")
					return FALSE
	if(covered)
		if(!silent)
			var/who = (isnull(user) || eater == user) ? "my" : "[eater.p_their()]"
			to_chat(user, "<span class='warning'>I have to remove [who] [covered] first!</span>")
		return FALSE
	return TRUE

/obj/item/reagent_containers/proc/bartender_check(atom/target)
	. = FALSE
	if(target.CanPass(src, get_turf(src)) && thrownby && HAS_TRAIT(thrownby, TRAIT_BOOZE_SLIDER))
		. = TRUE

/obj/item/reagent_containers/proc/SplashReagents(atom/target, thrown = FALSE)
	if(!reagents || !reagents.total_volume || !spillable)
		return

	if(ismob(target) && target.reagents)
		if(thrown)
			reagents.total_volume *= rand(5,10) * 0.1 //Not all of it makes contact with the target
		var/mob/M = target
		var/R
		target.visible_message("<span class='danger'>[M] has been splashed with something!</span>", \
						"<span class='danger'>[M] has been splashed with something!</span>")
		for(var/datum/reagent/A in reagents.reagent_list)
			R += "[A.type]  ([num2text(A.volume)]),"

		if(thrownby)
			log_combat(thrownby, M, "splashed", R)
		reagents.reaction(target, TOUCH)

	else if(bartender_check(target) && thrown)
		visible_message("<span class='notice'>[src] lands onto the [target.name] without spilling a single drop.</span>")
		return

	else
		if(isturf(target))
			var/turf/target_turf = target
			if(istype(target_turf, /turf/open))
				target_turf.add_liquid_from_reagents(reagents, FALSE, reagents.chem_temp)
			if(reagents.reagent_list.len && thrownby)
				log_combat(thrownby, target, "splashed (thrown) [english_list(reagents.reagent_list)]", "in [AREACOORD(target)]")
				log_game("[key_name(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] in [AREACOORD(target)].")
				message_admins("[ADMIN_LOOKUPFLW(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] in [ADMIN_VERBOSEJMP(target)].")
		visible_message("<span class='notice'>[src] spills its contents all over [target].</span>")
		reagents.reaction(target, TOUCH)
		if(QDELETED(src))
			return

	reagents.clear_reagents()
