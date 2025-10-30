/datum/worker_gear
	var/obj/item/item
	var/slot
	var/datum/worker_mind/owner

	// Gear effects
	var/work_speed_modifier = 1.0
	var/stamina_cost_modifier = 1.0
	var/walkspeed_modifier = 0
	var/stamina_regen_modifier = 1.0
	var/stamina_modifier = 0

	// Task-specific bonuses
	var/list/task_bonuses = list()

/datum/worker_gear/New(obj/item/new_item, new_slot, datum/worker_mind/new_owner)
	. = ..()
	item = new_item
	if(new_slot)
		slot = new_slot
	owner = new_owner

/datum/worker_gear/proc/get_task_bonus(datum/work_order/task, task_key)
	// Apply any task-specific bonuses
	for(var/task_type in task_bonuses)
		if(istype(task, task_type) && (task_key in task_bonuses[task_type]))
			var/list/bonuses = task_bonuses[task_type]
			return bonuses[task_key]
	return


/datum/worker_gear/proc/get_work_speed_modifier()
	return work_speed_modifier

/datum/worker_gear/proc/get_stamina_cost_modifier()
	return stamina_cost_modifier

/datum/worker_gear/proc/get_walkspeed_modifier()
	return walkspeed_modifier

/datum/worker_gear/proc/get_stamina_regen_modifier()
	return stamina_regen_modifier

/datum/worker_gear/proc/get_stamina_modifier()
	return stamina_modifier

/datum/worker_gear/instrument
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/play_music = list(TASK_KEY_QUALITY = 1.2, TASK_KEY_REDUCTION = 0.8)
	)

/datum/worker_gear/performer_hat
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/play_music = list(TASK_KEY_QUALITY = 1.1)
	)
	stamina_regen_modifier = 1.2

/datum/worker_gear/performer_clothes
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/play_music = list(TASK_KEY_QUALITY = 1.08)
	)


/datum/worker_gear/pickaxe
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9, TASK_KEY_QUANTITY = 2),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_cap
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_shoes
	slot = WORKER_SLOT_SHOES
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_chest
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_pants
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/hoe
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/farm_food = list(TASK_KEY_SPEED = 1.15, TASK_KEY_REDUCTION = 0.85, TASK_KEY_QUANTITY = 1.2)
	)

/datum/worker_gear/farming_hat
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/farm_food = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)
	stamina_regen_modifier = 1.1

/datum/worker_gear/farming_boots
	slot = WORKER_SLOT_SHOES
	task_bonuses = list(
		/datum/work_order/farm_food = list(TASK_KEY_SPEED = 1.05, TASK_KEY_REDUCTION = 0.95)
	)
	walkspeed_modifier = -0.1

/datum/worker_gear/farming_shirt
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/farm_food = list(TASK_KEY_SPEED = 1.05, TASK_KEY_REDUCTION = 0.95)
	)
	stamina_modifier = 5

/datum/worker_gear/axe
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/cut_wood = list(TASK_KEY_SPEED = 1.2, TASK_KEY_REDUCTION = 0.8, TASK_KEY_QUANTITY = 1.5)
	)

/datum/worker_gear/lumberjack_hat
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/cut_wood = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/lumberjack_boots
	slot = WORKER_SLOT_SHOES
	task_bonuses = list(
		/datum/work_order/cut_wood = list(TASK_KEY_SPEED = 1.08, TASK_KEY_REDUCTION = 0.92)
	)
	walkspeed_modifier = -0.15

/datum/worker_gear/lumberjack_shirt
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/cut_wood = list(TASK_KEY_SPEED = 1.05, TASK_KEY_REDUCTION = 0.95)
	)
	stamina_modifier = 8

/datum/worker_gear/hammer
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/forge_ingot = list(TASK_KEY_SPEED = 1.25, TASK_KEY_REDUCTION = 0.75, TASK_KEY_QUALITY = 1.1)
	)

/datum/worker_gear/smith_apron
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/forge_ingot = list(TASK_KEY_SPEED = 1.15, TASK_KEY_REDUCTION = 0.85)
	)
	stamina_regen_modifier = 1.15

/datum/worker_gear/smith_boots
	slot = WORKER_SLOT_SHOES
	task_bonuses = list(
		/datum/work_order/forge_ingot = list(TASK_KEY_SPEED = 1.05, TASK_KEY_REDUCTION = 0.95)
	)

/datum/worker_gear/cooking_knife
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/make_food = list(TASK_KEY_SPEED = 1.2, TASK_KEY_REDUCTION = 0.8, TASK_KEY_QUALITY = 1.15)
	)

/datum/worker_gear/chef_hat
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/make_food = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/make_drink = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/chef_apron
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/make_food = list(TASK_KEY_SPEED = 1.12, TASK_KEY_REDUCTION = 0.88),
		/datum/work_order/make_drink = list(TASK_KEY_SPEED = 1.12, TASK_KEY_REDUCTION = 0.88)
	)
	stamina_modifier = 5

/datum/worker_gear/brewing_paddle
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/make_drink = list(TASK_KEY_SPEED = 1.15, TASK_KEY_REDUCTION = 0.85, TASK_KEY_QUALITY = 1.1)
	)

/datum/worker_gear/brewer_apron
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/make_drink = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/tanning_knife
	slot = WORKER_SLOT_HANDS
	task_bonuses = list(
		/datum/work_order/tan_leather = list(TASK_KEY_SPEED = 1.2, TASK_KEY_REDUCTION = 0.8, TASK_KEY_QUALITY = 1.1)
	)

/datum/worker_gear/tanner_apron
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/tan_leather = list(TASK_KEY_SPEED = 1.15, TASK_KEY_REDUCTION = 0.85)
	)
	stamina_modifier = 5

/datum/worker_gear/sewing_needle
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/sew_clothes = list(TASK_KEY_SPEED = 1.25, TASK_KEY_REDUCTION = 0.75, TASK_KEY_QUALITY = 1.15)
	)

/datum/worker_gear/tailor_spectacles
	slot = WORKER_SLOT_HEAD
	task_bonuses = list(
		/datum/work_order/sew_clothes = list(TASK_KEY_SPEED = 1.15, TASK_KEY_QUALITY = 1.1)
	)

/datum/worker_gear/tailor_apron
	slot = WORKER_SLOT_SHIRT
	task_bonuses = list(
		/datum/work_order/sew_clothes = list(TASK_KEY_SPEED = 1.08, TASK_KEY_REDUCTION = 0.92)
	)
