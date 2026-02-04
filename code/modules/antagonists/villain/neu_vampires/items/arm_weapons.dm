/obj/item
	var/masquerade_violating = FALSE

/obj/item/weapon/arms
	lefthand_file = 'icons/obj/items/righthand.dmi'
	righthand_file = 'icons/obj/items/lefthand.dmi'
	icon = 'icons/obj/items/weapons.dmi'
	var/quieted = FALSE

/obj/item/weapon/arms/gangrel
	name = "claws"
	icon_state = "claws"
	w_class = WEIGHT_CLASS_BULKY
	force = 6
	armor_penetration = 100	//It's magical damage
	block_chance = 20
	item_flags = DROPDEL
	masquerade_violating = TRUE

/obj/item/weapon/arms/gangrel/afterattack(atom/target, mob/living/carbon/user, proximity, list/modifiers)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.apply_damage(30, BURN)
	. = ..()
