/datum/action/cooldown/meatvine/personal/transfer_resources
	name = "Transfer Resources"
	desc = "Transfer 20 personal resources to another meatvine. Must be adjacent. Cost: 20 resources."
	button_icon_state = "transfer"
	cooldown_time = 15 SECONDS
	personal_resource_cost = 20
	var/transfer_amount = 20

/datum/action/cooldown/meatvine/personal/transfer_resources/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/giver = owner
	if(!istype(giver))
		return FALSE

	// Check if target is another meatvine
	if(!istype(target, /mob/living/simple_animal/hostile/retaliate/meatvine))
		to_chat(giver, span_warning("You can only transfer resources to other meatvines!"))
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/receiver = target

	// Check if same master
	if(giver.master != receiver.master)
		to_chat(giver, span_warning("You can only transfer resources to meatvines from your hive!"))
		return FALSE

	// Check if adjacent
	if(!giver.Adjacent(receiver))
		to_chat(giver, span_warning("You must be adjacent to transfer resources!"))
		return FALSE

	// Check if receiver can accept resources
	var/can_receive = receiver.personal_resource_max - receiver.personal_resource_pool
	if(can_receive < transfer_amount)
		to_chat(giver, span_warning("[receiver] cannot accept the full transfer! They can only accept [can_receive] more resources."))
		// Still allow partial transfer
		transfer_amount = can_receive
		if(transfer_amount <= 0)
			return FALSE

	// Perform the transfer
	giver.visible_message(
		span_notice("[giver] transfers resources to [receiver]."),
		span_boldnotice("You transfer [transfer_amount] resources to [receiver].")
	)

	to_chat(receiver, span_nicegreen("You receive [transfer_amount] resources from [giver]!"))

	receiver.adjust_personal_resources(transfer_amount)

	// Deduct resources and start cooldown
	. = ..()
	return TRUE

/datum/action/cooldown/meatvine/personal/transfer_resources/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return 0

	// Don't transfer if we're low on resources ourselves
	if(user.personal_resource_pool < user.personal_resource_max * 0.6)
		return 0

	// Look for nearby allies who need resources
	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(1, user))
		if(ally == user || ally.master != user.master)
			continue

		var/ally_resource_percent = (ally.personal_resource_pool / ally.personal_resource_max) * 100
		if(ally_resource_percent < 30)
			return 70 // High priority for low-resource allies
		else if(ally_resource_percent < 60)
			return 40 // Medium priority

	return 0

/datum/action/cooldown/meatvine/personal/transfer_resources/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner

	// Find the ally with lowest resources nearby
	var/mob/living/simple_animal/hostile/retaliate/meatvine/best_target
	var/lowest_percent = 100

	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(1, user))
		if(ally == user || ally.master != user.master)
			continue

		var/ally_percent = (ally.personal_resource_pool / ally.personal_resource_max) * 100
		if(ally_percent < lowest_percent)
			lowest_percent = ally_percent
			best_target = ally

	if(!best_target)
		return FALSE

	return Activate(best_target)

/datum/action/cooldown/meatvine/personal/transfer_resources/get_movement_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner

	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in user.master?.mobs)
		if(ally == user || get_dist(user, ally) > 7)
			continue

		var/ally_percent = (ally.personal_resource_pool / ally.personal_resource_max) * 100
		if(ally_percent < 40)
			return ally

	return null

/datum/action/cooldown/meatvine/personal/transfer_resources/improved
	name = "ImprovedTransfer Resources"
	desc = "Transfer 40 personal resources to another meatvine. Must be adjacent. Cost: 20 resources."
	transfer_amount = 40
