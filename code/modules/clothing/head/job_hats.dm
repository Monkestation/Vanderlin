/obj/item/clothing/head/fisherhat
	name = "straw hat"
	desc = "Wenches shall lust for thee. Fishe will fear thee. \
			Humen will cast their gaze aside. As thou walk, \
			no creecher shall dare make a sound on thy presence. \
			Thou wilt be alone on these barren lands."
	icon_state = "fisherhat"
	max_heat_protection_temperature = 60

/obj/item/clothing/head/stewardtophat
	name = "top hat"
	icon_state = "stewardtophat"
	icon = 'icons/roguetown/clothing/special/steward.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"

/obj/item/clothing/head/strawhat
	name = "crude straw hat"
	desc = "Welcome to the grain fields, thou plowerer of the fertile."
	icon_state = "strawhat"
	salvage_result = /obj/item/natural/fibers

/obj/item/clothing/head/articap
	desc = "A sporting cap with a small gear adornment. Popular fashion amongst Heartfelt engineers."
	icon_state = "articap"

/obj/item/clothing/head/articap/porter
	desc = "A cap with a small adornment."
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/cookhat
	name = "cook hat"
	desc = "A white top hat typically worn by distinguished kitchen workers."
	icon_state = "chef"
	item_state = "chef"
	flags_inv = HIDEEARS

/obj/item/clothing/head/nun
	name = "nun's habit"
	desc = "Habits worn by nuns of the pantheon's faith."
	icon_state = "nun"
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/head/fancyhat
	name = "fancy hat"
	icon_state = "fancyhat"
	sellprice = VALUE_FINE_CLOTHING

/obj/item/clothing/head/courtierhat
	name = "fancy hat"
	icon_state = "courtier"
	flags_inv = HIDEEARS
	sellprice = VALUE_FINE_CLOTHING

/obj/item/clothing/head/bardhat
	name = "plumed hat"
	desc = "A simple leather hat with a fancy plume on top. A corny attempt at appearing regal \
			despite one's status. Typically worn by travelling minstrels of all kinds."
	icon_state = "bardhat"

/obj/item/clothing/head/jester
	name = "jester's hat"
	desc = "Just remember that the last laugh is on you."
	icon_state = "jester"

/obj/item/clothing/head/jester/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = list(SFX_JINGLE_BELLS), step_delay_override = 2, falloff_exponent = 20) //die off quickly

/obj/item/clothing/head/cookhat/chef // only unique thing is the name
	name = "chef's hat"

/obj/item/clothing/head/tophat
	name = "teller's hat"
	icon_state = "tophat"
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/head/wizhat
	name = "wizard hat"
	desc = "Used to distinguish dangerous wizards from senile old men."
	icon_state = "wizardhat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	dynamic_hair_suffix = "+generic"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	body_parts_covered = null

	prevent_crits =  MINOR_CRITICALS

/obj/item/clothing/head/wizhat/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/kobold_storage)

//random wizhat
/obj/item/clothing/head/wizhat/random
	misc_flags = CRAFTING_TEST_EXCLUDE //meant to not be craftable, its a random wizhat for adventurers and mages

/obj/item/clothing/head/wizhat/random/Initialize()
	. = ..()
	icon_state = pick("wizardhat", "wizardhatred", "wizardhatgreen", "wizardhatblack", "wizardhatyellow")

/obj/item/clothing/head/wizhat/witch
	name = "witch hat"
	desc = "While officially, Witches heretical to Astrata and risk harassment by the faithkeepers, quite a few mages and Pestrans wear such hats anyways as a fashion statement."
	icon_state = "witchhat"
	detail_tag = "_detail"
	detail_color = CLOTHING_SOOT_BLACK

/obj/item/clothing/head/wizhat/gen
	icon_state = "wizardhatgen"

/obj/item/clothing/head/leather
	abstract_type = /obj/item/clothing/head/leather

/obj/item/clothing/head/leather/inqhat
	name = "inquisitorial hat"
	desc = "A wide-brimmed leather hat, adorned with a crimson-dyed feather. Death has come to your little town."
	icon_state = "inqhat"
	item_state = "inqhat"
	sewrepair = TRUE

/obj/item/clothing/head/leather/inqhat/vigilante
	name = "fancy hat"

/obj/item/clothing/head/physhat
	name = "court physician's hat"
	desc = "A head covering for the distinguished physician."
	icon_state = "physicianhat"
	item_state = "physicianhat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'

/obj/item/clothing/head/courtphysician
	name = "court physician's beret"
	desc = "A head covering for elegance, and to hide the bald spot."
	icon_state = "courthat"
	item_state = "courthat"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'

/obj/item/clothing/head/courtphysician/male
	name = "sanguine hat"
	desc = "A hat for keeping the splattered blood out of your face, for when your trade is required."
	icon_state = "dochat1"
	item_state = "dochat1"
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/head/courtphysician/female
	name = "sanguine cap"
	desc = "A cap for keeping the splattered blood out of your hair, for when your trade is required."
	icon_state = "dochat2"
	item_state = "dochat2"
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/head/maidband
	name = "maid headband"
	desc = "A pleated cloth headband. It has gained widespread popularity from Valorian nobles travelling with their servants."
	icon_state = "maidband"
	body_parts_covered = NONE

/obj/item/clothing/head/maidband/Initialize(mapload, ...)
	. = ..()
	// I fucking love pilgrims
	AddComponent(
		/datum/component/equipment_stress/job_specific, \
		/datum/stress_event/maidband, \
		list(TRAIT_VILLAIN = null, TRAIT_NOBLE = /datum/stress_event/maidband/noble), \
		immune_jobs = list(/datum/job/prince, /datum/job/squire, /datum/job/advclass/pilgrim/noble, /datum/job/advclass/pilgrim/rare/zaladin, /datum/job/advclass/pilgrim/rare/grenzelhoft, /datum/job/advclass/pilgrim/rare/merchant), \
		immune_departments = (NOBLEMEN | GARRISON | OUTSIDERS | COMPANY), \
		department_exceptions = list(/datum/job/advclass/pilgrim, /datum/job/grabber), \
		inverse = TRUE, \
	)
