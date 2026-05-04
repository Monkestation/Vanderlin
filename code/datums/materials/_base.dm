/datum/material
	abstract_type = /datum/material

	var/name
	///temperature in kelvin this melts at, until we get refiners this is largely not a thing
	var/melting_point = 1358.15
	///our materials color
	var/color
	/// What object does this material form when solidified
	var/obj/item/solid_form
	/// Should we show up as part of reagent fillings?
	var/show_as_filling = FALSE

	///the temperature it "finishes" at finishing can be different for various things
	var/finishing_temperature = 700
	///the integrity modifier applied to created gear
	var/integrity_modifier = 1
	///our value modifier
	var/value_modiifer = 1
	///basically a list of material traits think things like firestarter etc
	var/list/traits = list()
	///how hard our material is
	var/hardness
