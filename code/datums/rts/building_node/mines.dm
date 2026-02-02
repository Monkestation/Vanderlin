/obj/effect/building_node/mines
	name = "Mine"
	work_template = "mine"

	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "orecinnabar"

	persistant_nodes = list(
		/datum/persistant_workorder/mine/stones,
		/datum/persistant_workorder/mine/ores,
		/datum/persistant_workorder/mine/coal,
		/datum/persistant_workorder/mine/gem,
	)
