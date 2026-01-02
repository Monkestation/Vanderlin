
/obj/item/clothing/cloak/apron
	name = "apron"
	desc = ""
	color = null
	icon_state = "apron"
	item_state = "apron"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	salvage_result = /obj/item/natural/cloth

/obj/item/clothing/cloak/apron/brown
	color = CLOTHING_BARK_BROWN
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/apron/waist
	name = "apron"
	desc = ""
	color = null
	icon_state = "waistpron"
	item_state = "waistpron"
	body_parts_covered = GROIN
	boobed = FALSE

/obj/item/clothing/cloak/apron/waist/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/cloak/apron/waist/colored/brown
	color = CLOTHING_BARK_BROWN

/obj/item/clothing/cloak/apron/waist/colored/bar
	color = "#251f1d"

/obj/item/clothing/cloak/apron/cook
	name = "cook apron"
	desc = "An apron covering the frontal part of the body. Apart from protection from spills, won't prevent you from getting cut in half."
	color = null
	icon_state = "aproncook"
	item_state = "aproncook"
	body_parts_covered = GROIN
	boobed = FALSE

/obj/item/clothing/cloak/apron/maid
	name = "maid apron"
	desc = "The frilly apron of a housemaster. It has pockets to store small things."
	detail_color = "_detail"
	detail_color = CLOTHING_DARK_INK
	icon_state = "maidapron"
	item_state = "maidapron"
	boobed = FALSE
	grid_width = 64
	grid_height = 64
	pocket_storage_component_path = /datum/component/storage/concrete/grid/cloak

/obj/item/clothing/cloak/apron/maid/Initialize(mapload, ...)
	. = ..()
	// I fucking love pilgrims
	AddComponent(
		/datum/component/equipment_stress/job_specific, \
		/datum/stress_event/maidapron, \
		list(TRAIT_VILLAIN = null, TRAIT_NOBLE = /datum/stress_event/maidapron/noble), \
		immune_jobs = list(/datum/job/prince, /datum/job/squire, /datum/job/advclass/pilgrim/noble, /datum/job/advclass/pilgrim/rare/zaladin, /datum/job/advclass/pilgrim/rare/grenzelhoft, /datum/job/advclass/pilgrim/rare/merchant), \
		immune_departments = (NOBLEMEN | GARRISON | OUTSIDERS | COMPANY), \
		department_exceptions = list(/datum/job/advclass/pilgrim, /datum/job/grabber), \
		inverse = TRUE, \
	)

