/obj/item/spellbook/mid/starter
	abstract_type = /obj/item/spellbook/mid/starter
	themed_cost_multiplier = 0.94
	themed_cast_speed_multiplier = 1.10
	themed_magnitude_bonus = 0.15

/obj/item/spellbook/mid/starter/apply_themed_bonuses()
	if(!themed_form)
		return ..()
	var/list/flavor = get_theme_flavor(themed_form)
	if(flavor[1])
		name = "[initial(name)], [flavor[1]]"
	if(flavor[2])
		desc = "[initial(desc)] [flavor[2]]"
	var/scale = bookquality / SPELLBOOK_THEME_BASELINE_QUALITY
	base_form_points = CEILING(SPELLBOOK_THEME_BASELINE_FORM_POINTS * scale, 1)
	base_technique_points = CEILING(SPELLBOOK_THEME_BASELINE_TECHNIQUE_POINTS * scale, 1)
	var/themed_amount = CEILING(base_form_points * 0.5, 1)
	mastery.adjust_form_mastery_points(themed_amount, FALSE, themed_form)
	if(base_form_points - themed_amount)
		mastery.adjust_form_points(base_form_points - themed_amount)
	mastery.adjust_technique_points(base_technique_points)
	AddComponent(/datum/component/spell_modifier, \
		list("[themed_form]" = themed_cost_multiplier), \
		list("[themed_form]" = themed_cast_speed_multiplier), \
		list("[themed_form]" = themed_magnitude_bonus))

/obj/item/spellbook/mid/starter/fire
	themed_form = FORM_FIRE
	designlist = list("steel")

/obj/item/spellbook/mid/starter/ice
	themed_form = FORM_ICE
	designlist = list("steel")

/obj/item/spellbook/mid/starter/lightning
	themed_form = FORM_LIGHTNING
	designlist = list("steel")

/obj/item/spellbook/mid/starter/earth
	themed_form = FORM_EARTH
	designlist = list("steel")

/obj/item/spellbook/mid/starter/arcane
	themed_form = FORM_ARCANE
	designlist = list("gem")

/obj/item/spellbook/mid/starter/death
	themed_form = FORM_DEATH
	designlist = list("skin")

/obj/item/spellbook/mid/starter/life
	themed_form = FORM_LIFE
	designlist = list("mimic")

/obj/item/spellbook/mid/starter/air
	themed_form = FORM_AIR
	designlist = list("steel")

/obj/item/spellbook/mid/starter/water
	themed_form = FORM_WATER
	designlist = list("steel")
