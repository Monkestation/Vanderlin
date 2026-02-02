/obj/effect/building_node/tailorshop
    name = "Tailor Shop"
    work_template = "tailorshop"
    icon = 'icons/roguetown/items/natural.dmi'
    icon_state = "cloth"
    persistant_nodes = list(
        /datum/persistant_workorder/sew_clothes,
		/datum/persistant_workorder/craft_gear/farming_hat,
        /datum/persistant_workorder/craft_gear/lumberjack_hat,
        /datum/persistant_workorder/craft_gear/chef_hat,
        /datum/persistant_workorder/craft_gear/performer_hat,
        /datum/persistant_workorder/craft_gear/tailor_spectacles,
        /datum/persistant_workorder/craft_gear/farming_shirt,
        /datum/persistant_workorder/craft_gear/lumberjack_shirt,
        /datum/persistant_workorder/craft_gear/performer_clothes,
    )
