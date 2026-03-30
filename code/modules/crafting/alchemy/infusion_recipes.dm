/datum/essence_infusion_recipe
	abstract_type = /datum/essence_infusion_recipe
	var/category = "Infusions"
	var/name = "infusion recipe"
	var/obj/item/target_type
	var/list/required_essences = list() // essence_type = amount
	var/infusion_time = 10 SECONDS
	var/obj/item/result_type

/datum/essence_infusion_recipe/glass
	name = "Glass Transmutation"
	target_type  = /obj/item/natural/stone
	result_type = /obj/item/natural/glass
	required_essences = list(/datum/thaumaturgical_essence/crystal = 5)

/datum/essence_infusion_recipe/heat_iron
	name = "Heat Iron"
	target_type  = /obj/item/ore/iron
	result_type = /obj/item/ingot/iron
	required_essences = list(/datum/thaumaturgical_essence/fire = 10)

/datum/essence_infusion_recipe/thaumic_iron
	name = "Thaumic Iron"
	target_type  = /obj/item/ingot/iron
	result_type = /obj/item/ingot/thaumic
	required_essences = list(/datum/thaumaturgical_essence/fire = 10)

/datum/essence_infusion_recipe/mana_crystal
	name = "Mana Crystal"
	target_type  = /obj/item/gem
	result_type = /obj/item/mana_battery/mana_crystal/standard
	required_essences = list(/datum/thaumaturgical_essence/magic = 10)

/datum/essence_infusion_recipe/seed_random
	name = "Seed Transmutation"
	target_type  = /obj/item/neuFarm/seed
	result_type = /obj/item/neuFarm/seed/mixed_seed
	required_essences = list(/datum/thaumaturgical_essence/life = 5)

//quicksilver is mercury
//so we're literally transmuting silver into quicksilver
//hence the cost of magic, earth, and motion essence
//magic because... magic
//earth because we are turning one metal into another, heavier metal
//motion because QUICKsilver, get it?
/datum/essence_infusion_recipe/cinnabar
	name = "Cinnabar Transmutation"
	target_type  = /obj/item/alch/silverdust
	result_type = /obj/item/ore/cinnabar
	required_essences = list(/datum/thaumaturgical_essence/magic = 20, /datum/thaumaturgical_essence/earth = 10, /datum/thaumaturgical_essence/motion = 10)

