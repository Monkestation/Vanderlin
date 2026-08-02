/datum/recovery_pack
	/// Display name used in the quest scroll title/objective text.
	var/pack_name = "stolen goods"
	var/item_count_min = 1
	var/item_count_max = 3
	var/list/loot_table = list()
	/// If non-empty, this pack may only be selected when the landmark sits in one of these region names.
	var/list/allowed_regions = list()
	/// If non-empty, this pack will never be selected in these region names.
	var/list/denied_regions = list()

/datum/recovery_pack/proc/roll_items(obj/item/quest_package/package)
	var/count = rand(item_count_min, item_count_max)
	var/list/types = list()
	var/list/weights = list()
	for(var/obj/item/T as anything in loot_table)
		types += T
		weights += loot_table[T]
	for(var/i in 1 to count)
		var/picked_type = pickweight(types, weights)
		new picked_type(package)
