
/**
 * Get the name of this object for examine
 *
 * You can override what is returned from this proc by registering to listen for the
 * COMSIG_ATOM_GET_EXAMINE_NAME signal
 */
/atom/proc/get_examine_name(mob/user, use_article = TRUE)
	if(use_article)
		return article ? "[article] <b>[name]</b>" : gender == PLURAL ? "some <b>[name]</b>" : "\a <b>[name]</b>"
	return "<b>[name]</b>"

///Generate the full examine string of this atom (including icon for goonchat)
/atom/proc/get_examine_string(mob/user, thats = FALSE)
	. = get_examine_name(user)
	var/list/override = list(article || (gender == PLURAL ? "some" : "a"), " ", "[get_examine_name(user, FALSE)]")
	if(SEND_SIGNAL(src, COMSIG_ATOM_GET_EXAMINE_NAME, user, override) & COMPONENT_EXNAME_CHANGED)
		. = override.Join("")
	return "[thats ? ismob(src) ? "This is " : "That's " : ""][.]"

/atom/proc/get_examine_desc(mob/user)
	return desc

/atom/proc/get_examine_icon(mob/user)
	return ma2html(src, user)

/atom/proc/get_inspect_button()
	return ""

/atom/proc/get_inspect_entries()
	return list()

/**
 * Called when a mob examines (shift click or verb) this atom
 *
 * Default behaviour is to get the name and icon of the object and it's reagents where
 * the TRANSPARENT flag is set on the reagents holder
 *
 * Produces a signal COMSIG_ATOM_EXAMINE
 */
/atom/proc/examine(mob/user)
	var/examine_string = get_examine_string(user, thats = TRUE)
	if(examine_string)
		. = list("[examine_string].[get_inspect_button()]")
	else
		. = list()

	var/examine_desc = get_examine_desc(user)
	if(examine_desc)
		. += "<span class='info'>[examine_desc]</span>"

	if(reagents)
		if(reagents.flags & TRANSPARENT)
			if(length(reagents.reagent_list))
				if(user.can_see_reagents()) //Show each individual reagent
					. += "It contains:"
					for(var/datum/reagent/R in reagents.reagent_list)
						. += "[(UNIT_FORM_STRING(R.volume))] of <font color=[R.color]>[R.name]</font>"
				else //Otherwise, just show the total volume
					var/total_volume = 0
					var/reagent_color
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					reagent_color = mix_color_from_reagents(reagents.reagent_list)
					. += "It contains [(UNIT_FORM_STRING(total_volume))] of <font color=[reagent_color]>something.</font>"
			else
				. += "It's empty."
		else if(reagents.flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				. += "<span class='notice'>It has [(UNIT_FORM_STRING(round(reagents.total_volume, 0.1)))] left.</span>"
			else
				. += "<span class='danger'>It's empty.</span>"
		//SNIFFING
		if (user.zone_selected == BODY_ZONE_PRECISE_NOSE && get_dist(src, user) <= 1)
			// if atom's path is item/reagent_containers/glass/carafe
			var/is_not_closed = FALSE
			if(istype(src, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/A = src
				is_not_closed = !A.closed
			else if(istype(src, /obj/item/reagent_containers/glass/alchemical))
				var/obj/item/reagent_containers/glass/alchemical/A = src
				is_not_closed = !A.closed
			if(is_not_closed && reagents.total_volume) // if the container is open, and there's liquids in there
				user.visible_message(span_info("[user] takes a whiff of [src]."))
				. += span_notice("I smell [src.reagents.generate_scent_message()].")
				if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
					var/list/full_reagents = list()
					for(var/datum/reagent/R in reagents.reagent_list)
						if(R.volume > 0)
							full_reagents += "[LOWER_TEXT(R.name)]"
					if(length(full_reagents))
						. += span_notice("I can identity this smell as [full_reagents.Join(", ")].")
	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE, user, .)

/**
 * Called when a mob examines (shift click or verb) this atom twice (or more) within EXAMINE_MORE_WINDOW (default 1 second)
 *
 * This is where you can put extra information on something that may be superfluous or not important in critical gameplay
 * moments, while allowing people to manually double-examine to take a closer look
 *
 * Produces a signal [COMSIG_ATOM_EXAMINE_MORE]
 */
/atom/proc/examine_more(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE_MORE, user, .)
	SEND_SIGNAL(user, COMSIG_MOB_EXAMINING_MORE, src, .)

/atom/proc/get_mechanics_examine(mob/user)
	return list()
