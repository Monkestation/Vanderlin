/datum/ingredient_buff_modifier
	var/name = "topping"
	/// Added to the quality of affected buffs
	var/quality_bonus = 0
	var/quality_cap = COOK_QUALITY_VERYGOOD
	var/potency_mult = 1
	var/duration_mult = 1
	/// If set, only buffs of these types are modified (null = all)
	var/list/affected_buff_types
	/// Optional buff the condiment grants outright
	var/datum/ingredient_buff/granted_buff_type
	var/granted_quality = 0

/datum/ingredient_buff_modifier/proc/apply_to_dish(obj/item/reagent_containers/food/snacks/dish)
	// A raw item with only a template gets frozen into assembled buffs first
	if(!length(dish.assembled_buffs))
		dish.assembled_buffs = dish.get_contributed_buffs()

	for(var/datum/ingredient_buff/buff as anything in dish.assembled_buffs)
		if(affected_buff_types && !is_type_in_list(buff, affected_buff_types))
			continue
		buff.quality = clamp(buff.quality + quality_bonus, 0, max(quality_cap, buff.quality))
		buff.potency_mult *= potency_mult
		buff.duration_mult *= duration_mult

	if(granted_buff_type)
		var/datum/ingredient_buff/existing
		for(var/datum/ingredient_buff/buff as anything in dish.assembled_buffs)
			if(buff.type == granted_buff_type)
				existing = buff
				break
		if(existing)
			existing.quality = max(existing.quality, granted_quality)
		else
			var/datum/ingredient_buff/granted = new granted_buff_type()
			granted.quality = granted_quality
			granted.composition_required = 0 // never diluted away by later stages
			granted.composition_share = 100
			dish.assembled_buffs += granted
