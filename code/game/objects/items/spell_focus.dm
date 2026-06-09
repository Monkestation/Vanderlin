/obj/item/spell_focus
	name = "arcyne focus"
	desc = "A faceted crystal blank threaded with arcyne filaments. It waits to be etched with a spell."
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "e_cut"
	w_class = WEIGHT_CLASS_TINY
	/// The spell type etched into this focus, null if blank
	var/datum/action/cooldown/spell/stored_spell_type = null
	/// Cached spell name
	var/stored_spell_name = null
	/// Spell tier of the etched spell
	var/spell_tier = 0
	/// Charges to grant when consumed by an imbuing rune
	var/grant_charges = 1

/obj/item/spell_focus/examine(mob/user)
	. = ..()
	if(stored_spell_type)
		. += span_notice("It pulses with stored memory, [stored_spell_name], tier [spell_tier].")
		. += span_notice("It will grant [grant_charges] charge\s when imbued.")
	else
		. += span_warning("It is blank, waiting to be etched.")

/obj/item/spell_focus/update_overlays()
	. = ..()
	if(!stored_spell_type)
		return
	var/mutable_appearance/MA = mutable_appearance(initial(stored_spell_type.button_icon), initial(stored_spell_type.button_icon_state))
	MA.alpha = 100
	. += MA

/obj/item/spell_focus/random/Initialize(mapload)
	. = ..()
	stored_spell_type = pick(subtypesof(/datum/action/cooldown/spell))
	if(IS_ABSTRACT(stored_spell_type))
		while(IS_ABSTRACT(stored_spell_type))
			stored_spell_type = pick(subtypesof(/datum/action/cooldown/spell))
	stored_spell_name = initial(stored_spell_type.name)
	name = "[initial(stored_spell_type.name)] focus"
	desc = "A focus etched with [initial(stored_spell_type.name)]. It can be consumed by an imbuing seal."
	update_appearance(UPDATE_OVERLAYS)
