/datum/sprite_accessory/underwear
	icon = 'icons/roguetown/mob/underwear.dmi'
	use_static = FALSE

/datum/sprite_accessory/underwear/regm
	name = "Undies"
	icon_state = "male"
	gender = MALE
	specuse = RACES_UNDERWEAR_MALE

/datum/sprite_accessory/underwear/regme
	name = "Undiese"
	icon_state = "male_elf"
	gender = MALE
	specuse = list(SPEC_ID_ELF, SPEC_ID_DROW)

/datum/sprite_accessory/underwear/regmd
	name = "Undiesd"
	icon_state = "male_dwarf"
	gender = MALE
	specuse = list(SPEC_ID_DWARF)

/datum/sprite_accessory/underwear/male_half
	name = "Undies Half"
	icon_state = "male_half"
	gender = MALE
	specuse = list(SPEC_ID_HALFLING)

/datum/sprite_accessory/underwear/female_bikini
	name = "Femundies"
	icon_state = "female"
	gender = FEMALE
	specuse = RACES_UNDERWEAR_FEMALE

/datum/sprite_accessory/underwear/female_dwarf
	name = "FemUndiesD"
	icon_state = "female_dwarf"
	gender = FEMALE
	specuse = list(SPEC_ID_DWARF, SPEC_ID_HALFLING)

/datum/sprite_accessory/underwear/female_leotard
	name = "Femleotard"
	icon_state = "female_leotard"
	gender = FEMALE
	specuse = RACES_UNDERWEAR_FEMALE
	roundstart = FALSE

//For use on Younglings
/datum/sprite_accessory/underwear/child
	name = "Youngling"
	icon_state = "male_child"
	gender = MALE
	specuse = ALL_RACES_LIST
	roundstart = FALSE

/datum/sprite_accessory/underwear/child_f
	name = "FemYoungling"
	icon_state = "female_child"
	gender = FEMALE
	specuse = ALL_RACES_LIST
	roundstart = FALSE
