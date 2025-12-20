/obj/item/fishing
	name = "fishing tackle"
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "twinereel"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 1
	//affects line hp
	var/linehealth = 0
	//affects margin of error and error mult
	var/difficultymod
	//multiplier to deep fish added to the fishing list. added to base chance dependent on targeted water tile z level and water tile
	var/deepfishingweight
	//affects fish rarity
	var/list/raritymod
	//affects fish size
	var/list/sizemod
	//affects how long the window is to hook a fish
	var/hookmod
	var/attachtype

/obj/item/fishing/Initialize()
	. = ..()

/obj/item/fishing/reel
	attachtype = "reel"

/obj/item/fishing/reel/twine
	name = "twine fishing line"
	desc = "A simple fishing line made out of woven fibers. Cheap, but breaks easily."
	linehealth = 5
	difficultymod = 1

/obj/item/fishing/reel/leather
	name = "leather fishing line"
	desc = "A fishing line made out of leather. Far stronger than twine, but its visibility makes fish more wary."
	icon_state = "leatherreel"
	linehealth = 8
	hookmod = -3

/obj/item/fishing/reel/silk
	name = "silk fishing line"
	desc = "A fishing line made out of woven silk. Strong and thin, it's a common choice among seasoned fisherman."
	icon_state = "silkreel"
	linehealth = 10
	difficultymod = -1

/obj/item/fishing/reel/deluxe
	name = "deluxe fishing line"
	desc = "Extremely sought after by seasoned fisherman, this fishing line was blessed by Abyssorians in their underwater temples. A perfect fishing line, if not for the cost."
	icon_state = "deluxereel"
	linehealth = 14
	hookmod = 3
	difficultymod = -2

/proc/pickweightmerge(list/List, list/add)//i need a way to merge multiple lists for my shenanigannery to work. remove this if fishing ever stops needing this
	var/list/returner = List
	var/addlength = length(add)
	while(addlength > 0)
		var/returnerlength = length(returner)
		var/find = FALSE
		while(returnerlength > 0)
			if(add[addlength] == returner[returnerlength])
				find = TRUE
				returner[returner[addlength]] += add[add[addlength]]
				break
			returnerlength--
		if(!find)
			returner += add[addlength]
			returner[add[addlength]] = add[add[addlength]]
		addlength--
	return returner

/proc/removenegativeweights(list/L)
	var/list/R = L
	for(var/item in R)
		if(R[item] < 0)
			R[item] = 0
	return R
