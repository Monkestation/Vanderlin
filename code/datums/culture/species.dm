/datum/culture/species/subterra
	name = "Subterra"
	description = "Known by humens to be hardened by the harsh environment of the world below. \
	To the average humen, a Subterran could refer to anywhere from citizens of the nearest outpost of Zizo, \
	to a deep culture of hermits, or even a group of dwarves who dug too deep. Regardless, none are to be trusted."
	species = list(
		SPEC_ID_DROW,
		SPEC_ID_HALF_DROW,
		SPEC_ID_DWARF,
		SPEC_ID_KOBOLD,
	)

/datum/culture/species/elven
	abstract_type = /datum/culture/species/elven
	species = list(
		SPEC_ID_ELF,
		SPEC_ID_HALF_ELF,
	)

/datum/culture/species/elven/costal
	name = "Costal Tribes"
	description = "Known by humens to be haughty, wealthy, disconnected pricks. \
	Much of the culture has since been absorbed by Wintermare. Never ask their opinions on any of the Sea Tribes."
	pre_append = "the "

/datum/culture/species/elven/sea
	name = "Sea Tribes"
	description = "Known by humens to be cruel, relentless slavers. \
	They say the basalt sands of their home island are stained with blood. Never ask their opinions on any of the Coastal Tribes."

/datum/culture/species/elven/desert
	name = "Desert Tribes"
	description = "Known by humens to be rebellious and unruly. Assumed to be involved with the Xylixian freemen of Zaladin."

/datum/culture/species/elven/crimson
	name = "Crimson Tribes"
	description = "Known by humens to be naive and weak. How they manage to survive the harsh steppe with roaming orc bands is anyone's guess."

/datum/culture/species/elven/obsidian
	name = "Obsidian Tribes"
	description = "Known by humens to be miserably devout Necrans. \
	They worship their holy tree, \"The Waiting Wood,\" praying to its skulls for but a chance to speak to The Veiled Lady herself."
	species = list(
		SPEC_ID_ELF,
		SPEC_ID_AASIMAR,
	)

/datum/culture/species/half_orc
	abstract_type = /datum/culture/species/half_orc
	species = list(
		SPEC_ID_HALF_ORC,
	)
