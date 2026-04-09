GLOBAL_LIST_EMPTY(inqsupplies)


/datum/inqports
	var/name = null
	var/item_type = null
	var/held_items = list(0, 0)
	var/marquescost = 0
	var/maximum = null // If there's no maximum, it's infinite.
	var/remaining = null // Limited stock items.
	var/category = null // Category for the HERMES. They are -  " SUPPLIES ", " ARTICLES ", " EQUIPMENT ", " RELIQUARY "


/datum/inqports/New()
	..()
	switch(category)
		if(1)
			category = "RELIQUARY"
		if(2)
			category = "SUPPLIES"
		if(3)
			category = "ARTICLES"
		if(4)
			category = "EQUIPMENT"
		if(5)
			category = "WARDROBE"


	if(name)
		name = "[initial(name)] - [marquescost]"


	if(maximum)
		remaining = maximum
		name = "[initial(name)] ([remaining]/[maximum]) - [marquescost]"
	return
