/obj/effect/building_node/blacksmith
	name = "Blacksmith"
	work_template = "blacksmith"

	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingotsteel"

	persistant_nodes = list(
		/datum/persistant_workorder/forge_ingot,
        /datum/persistant_workorder/craft_gear/pickaxe,
        /datum/persistant_workorder/craft_gear/axe,
        /datum/persistant_workorder/craft_gear/hammer,
        /datum/persistant_workorder/craft_gear/hoe,
        /datum/persistant_workorder/craft_gear/tanning_knife,
        /datum/persistant_workorder/craft_gear/cooking_knife,
	)
