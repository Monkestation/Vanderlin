/datum/persistant_workorder/craft_gear
	ui_icon = 'icons/roguetown/items/misc.dmi'
	work_type = /datum/work_order/craft_gear
	var/list/gear_path
	var/list/material_cost
	var/datum/worker_gear/gear_type

/datum/persistant_workorder/craft_gear/apply_to_worker(mob/living/worker)
	arg_1 = pick(created_node.workspots)
	arg_2 = created_node
	arg_3 = pick(gear_path)
	arg_4 = material_cost
	arg_5 = gear_type
	. = ..()

/datum/persistant_workorder/craft_gear/pickaxe
	name = "Craft Pickaxe"
	ui_icon_state = "pick"
	ui_icon = 'icons/roguetown/weapons/tools.dmi'
	gear_path = list(/obj/item/weapon/pick/copper, /obj/item/weapon/pick/steel)
	material_cost = list(MAT_INGOT = 2, MAT_WOOD = 1)
	gear_type = /datum/worker_gear/pickaxe

/datum/persistant_workorder/craft_gear/axe
	name = "Craft Axe"
	ui_icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	ui_icon_state = "axe"
	gear_path = list(/obj/item/weapon/axe/copper, /obj/item/weapon/axe/iron)
	material_cost = list(MAT_INGOT = 2, MAT_WOOD = 1)
	gear_type = /datum/worker_gear/axe

/datum/persistant_workorder/craft_gear/hammer
	name = "Craft Hammer"
	ui_icon_state = "hammer"
	ui_icon = 'icons/roguetown/weapons/tools.dmi'
	gear_path = list(/obj/item/weapon/hammer, /obj/item/weapon/hammer/copper)
	material_cost = list(MAT_INGOT = 2, MAT_WOOD = 1)
	gear_type = /datum/worker_gear/hammer

/datum/persistant_workorder/craft_gear/hoe
	name = "Craft Hoe"
	ui_icon_state = "hoe"
	ui_icon = 'icons/roguetown/weapons/tools.dmi'
	gear_path = list(/obj/item/weapon/hoe)
	material_cost = list(MAT_INGOT = 1, MAT_WOOD = 1)
	gear_type = /datum/worker_gear/hoe

/datum/persistant_workorder/craft_gear/tanning_knife
	name = "Craft Tanning Knife"
	ui_icon = 'icons/roguetown/weapons/32/knives.dmi'
	ui_icon_state = "knife"
	gear_path = list(/obj/item/weapon/knife/dagger)
	material_cost = list(MAT_INGOT = 1)
	gear_type = /datum/worker_gear/tanning_knife

/datum/persistant_workorder/craft_gear/cooking_knife
	name = "Craft Cooking Knife"
	ui_icon = 'icons/roguetown/weapons/32/knives.dmi'
	ui_icon_state = "knife"
	gear_path = list(/obj/item/weapon/knife/villager, /obj/item/weapon/knife/cleaver)
	material_cost = list(MAT_INGOT = 1)
	gear_type = /datum/worker_gear/cooking_knife

/datum/persistant_workorder/craft_gear/farming_hat
	name = "Craft Farming Hat"
	ui_icon = 'icons/roguetown/clothing/head.dmi'
	ui_icon_state = "strawhat"
	gear_path = list(/obj/item/clothing/head/strawhat)
	material_cost = list(MAT_CLOTH = 2)
	gear_type = /datum/worker_gear/farming_hat

/datum/persistant_workorder/craft_gear/lumberjack_hat
	name = "Craft Lumberjack Hat"
	ui_icon = 'icons/roguetown/clothing/head.dmi'
	ui_icon_state = "chaperon"
	gear_path = list(/obj/item/clothing/head/chaperon/colored)
	material_cost = list(MAT_LEATHER = 2)
	gear_type = /datum/worker_gear/lumberjack_hat

/datum/persistant_workorder/craft_gear/chef_hat
	name = "Craft Chef Hat"
	ui_icon = 'icons/roguetown/clothing/head.dmi'
	ui_icon_state = "chef"
	gear_path = list(/obj/item/clothing/head/cookhat)
	material_cost = list(MAT_CLOTH = 2)
	gear_type = /datum/worker_gear/chef_hat

/datum/persistant_workorder/craft_gear/performer_hat
	name = "Craft Performer Hat"
	ui_icon = 'icons/roguetown/clothing/special/steward.dmi'
	ui_icon_state = "stewardtophat"
	gear_path = list(/obj/item/clothing/head/stewardtophat)
	material_cost = list(MAT_CLOTH = 3, MAT_SILK = 1)
	gear_type = /datum/worker_gear/performer_hat

/datum/persistant_workorder/craft_gear/tailor_spectacles
	name = "Craft Spectacles"
	ui_icon = 'icons/roguetown/clothing/masks.dmi'
	ui_icon_state = "bglasses"
	gear_path = list(/obj/item/clothing/face/spectacles/inqglasses)
	material_cost = list(MAT_INGOT = 1)
	gear_type = /datum/worker_gear/tailor_spectacles

/datum/persistant_workorder/craft_gear/farming_shirt
	name = "Craft Farming Shirt"
	ui_icon = 'icons/roguetown/clothing/armor.dmi'
	ui_icon_state = "apothshirt"
	gear_path = list(/obj/item/clothing/shirt/apothshirt)
	material_cost = list(MAT_CLOTH = 3)
	gear_type = /datum/worker_gear/farming_shirt

/datum/persistant_workorder/craft_gear/lumberjack_shirt
	name = "Craft Lumberjack Shirt"
	ui_icon = 'icons/roguetown/clothing/armor.dmi'
	ui_icon_state = "lowcut"
	gear_path = list(/obj/item/clothing/shirt/undershirt/lowcut)
	material_cost = list(MAT_LEATHER = 4)
	gear_type = /datum/worker_gear/lumberjack_shirt

/datum/persistant_workorder/craft_gear/performer_clothes
	name = "Craft Performer Clothes"
	ui_icon = 'icons/roguetown/clothing/shirts.dmi'
	ui_icon_state = "artishirt"
	gear_path = list(/obj/item/clothing/shirt/undershirt/artificer)
	material_cost = list(MAT_CLOTH = 3, MAT_SILK = 2)
	gear_type = /datum/worker_gear/performer_clothes
