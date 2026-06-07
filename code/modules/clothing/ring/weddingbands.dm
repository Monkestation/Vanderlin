/obj/item/clothing/ring/band
	name = "silver weddingband"
	desc = "A glimmering weddingband of silver, ornately decorated with the engravings of a lover's name."
	icon_state = "s_ring_wedding"
	sellprice = 3	//You don't get to smelt this down or sell it. No free mams for a loadout item.
	var/choicename = FALSE
	var/choicedesc = FALSE


/obj/item/clothing/ring/band/attack_hand_secondary(mob/user, list/modifiers)
	if(choicename)
		return
	if(choicedesc)
		return
	var/current_time = world.time
	var/namechoice = input(user, "Input a new name", "Rename Object")
	var/descchoice = input(user, "Input a new description", "Describe Object")
	if(namechoice)
		name = namechoice
		choicename = TRUE
	if(descchoice)
		desc = descchoice
		choicedesc = TRUE
	else
		return
	if(world.time > (current_time + 30 SECONDS))
		return

/obj/item/clothing/ring/band/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Right-click to add a custom name and description to the weddingband.")
    . += span_info("If your character is meant to be already married to someone else, offer the ring to them while they are offering theirs to you. This will mark you as spouses, but will not change your names.")

/obj/item/clothing/ring/band/gold
	name = "gold weddingband"
	desc = "A beautiful weddingband of gold, ornately decorated with the engravings of a lover's name."
	icon_state = "g_ring_wedding"

/obj/item/clothing/ring/band/bronze
	name = "bronze weddingband"
	desc = "A resilient weddingband of bronze, ornately decorated with the engravings of a lover's name."
	icon_state = "b_ring_wedding"

/obj/item/clothing/ring/band/aalloy
	name = "decrepit weddingband"
	desc = "A decaying weddingband of tarnished bronze, ornately decorated with the engravings of a lover's name."
	icon_state = "a_ring_wedding"
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/ring/band/paalloy
	name = "ancient weddingband"
	desc = "An enchanting weddingband of polished gilbranze, ornately decorated with the engravings of a lover's name."
	icon_state = "a_ring_wedding"
