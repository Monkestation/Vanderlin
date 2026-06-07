/proc/add_mammons_to_atom(mob/target, mammons_to_add)
	if(!target || mammons_to_add <= 0)
		return FALSE

	var/remaining_mammons = mammons_to_add

	// First, try to add to existing coin stacks
	for(var/obj/item/coin/existing_coin in target.contents)
		if(!existing_coin.base_type || remaining_mammons <= 0)
			continue

		var/space_in_stack = 20 - existing_coin.quantity // MAX_COIN_STACK_SIZE = 20
		if(space_in_stack <= 0)
			continue

		var/coins_to_add = min(floor(remaining_mammons / existing_coin.sellprice), space_in_stack)
		if(coins_to_add > 0)
			existing_coin.set_quantity(existing_coin.quantity + coins_to_add)
			remaining_mammons -= coins_to_add * existing_coin.sellprice

	// Create new coin stacks for remaining mammons
	while(remaining_mammons > 0)
		var/coin_type_to_create = null
		var/coin_value = 0

		// Determine best coin denomination
		if(remaining_mammons >= 10)
			coin_type_to_create = /obj/item/coin/gold
			coin_value = 10
		else if(remaining_mammons >= 5)
			coin_type_to_create = /obj/item/coin/silver
			coin_value = 5
		else if(remaining_mammons >= 1)
			coin_type_to_create = /obj/item/coin/copper
			coin_value = 1
		else
			break // Less than 1 mammon remaining

		var/coins_to_create = min(floor(remaining_mammons / coin_value), 20)
		var/obj/item/coin/new_coin = new coin_type_to_create(get_turf(target), coins_to_create)

		if(ismob(target))
			target.put_in_hands(new_coin)
		else
			new_coin.forceMove(target)

		remaining_mammons -= coins_to_create * coin_value

	return mammons_to_add - remaining_mammons // Return actual amount added

// Remove mammons from an atom by modifying/deleting coins
/proc/remove_mammons_from_atom(atom/movable/target, mammons_to_remove)
	if(!target || mammons_to_remove <= 0)
		return 0

	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/remaining_to_remove = mammons_to_remove
	var/total_removed = 0

	// Create a list of all coins sorted by value (highest first for efficient removal)
	var/list/coin_list = list()
	for(var/obj/item/coin/coin in target.contents)
		if(coins_types[coin.type])
			coin_list += coin

	// Sort coins by sellprice (descending)
	sortTim(coin_list, GLOBAL_PROC_REF(cmp_coin_value_desc))

	// Remove from coins starting with highest value
	for(var/obj/item/coin/coin in coin_list)
		if(remaining_to_remove <= 0)
			break

		var/coin_total_value = coin.quantity * coin.sellprice
		if(coin_total_value <= remaining_to_remove)
			// Remove entire coin
			remaining_to_remove -= coin_total_value
			total_removed += coin_total_value
			qdel(coin)
		else
			// Partially remove from this coin
			var/quantity_to_remove = remaining_to_remove / coin.sellprice
			if(quantity_to_remove >= 1)
				coin.quantity -= quantity_to_remove
				var/value_removed = quantity_to_remove * coin.sellprice
				remaining_to_remove -= value_removed
				total_removed += value_removed
				coin.update_appearance(UPDATE_ICON_STATE | UPDATE_NAME | UPDATE_DESC)

		// Also check contents recursively
		if(remaining_to_remove > 0)
			var/removed_from_contents = remove_mammons_from_atom_recursive(coin, remaining_to_remove)
			remaining_to_remove -= removed_from_contents
			total_removed += removed_from_contents

	// Check other contents recursively
	for(var/atom/movable/content in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(!coins_types[content.type]) // Skip coins we already processed
			var/removed_from_content = remove_mammons_from_atom_recursive(content, remaining_to_remove)
			remaining_to_remove -= removed_from_content
			total_removed += removed_from_content

	return total_removed

// Helper function for recursive mammon removal
/proc/remove_mammons_from_atom_recursive(atom/movable/target, mammons_to_remove)
	if(!target || mammons_to_remove <= 0)
		return 0

	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/remaining_to_remove = mammons_to_remove
	var/total_removed = 0

	// Remove from direct coin contents first
	for(var/obj/item/coin/coin in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(coins_types[coin.type])
			var/coin_total_value = coin.quantity * coin.sellprice
			if(coin_total_value <= remaining_to_remove)
				remaining_to_remove -= coin_total_value
				total_removed += coin_total_value
				qdel(coin)
			else
				var/quantity_to_remove = remaining_to_remove / coin.sellprice
				if(quantity_to_remove >= 1)
					coin.quantity -= quantity_to_remove
					var/value_removed = quantity_to_remove * coin.sellprice
					remaining_to_remove -= value_removed
					total_removed += value_removed
					coin.update_appearance(UPDATE_ICON_STATE | UPDATE_NAME | UPDATE_DESC)

	// Then check other contents recursively
	for(var/atom/movable/content in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(!coins_types[content.type])
			var/removed = remove_mammons_from_atom_recursive(content, remaining_to_remove)
			remaining_to_remove -= removed
			total_removed += removed

	return total_removed

/proc/cmp_coin_value_desc(obj/item/coin/a, obj/item/coin/b)
	return b.sellprice - a.sellprice
