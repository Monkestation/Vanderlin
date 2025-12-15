/datum/action/cooldown/spell/heat_metal
	name = "Heat Metal"
	desc = ""
	button_icon_state = "heatmetal"
	sound = 'sound/items/bsmithfail.ogg'

	cast_range = 2
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/malum)

	invocation = "Metal bends to the heat of Malum's forge!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_slowdown = 1.3
	cooldown_time = 2 MINUTES
	spell_cost = 40

/datum/action/cooldown/spell/heat_metal/cast(atom/cast_on)
	. = ..()
	if(istype(cast_on, /obj/item))
		handle_item_smelting(cast_on)
		return
	if(istype(cast_on, /obj/machinery/anvil))
		handle_anvil(cast_on)
		return
	if(iscarbon(cast_on))
		handle_living_entity(cast_on)

/datum/action/cooldown/spell/heat_metal/proc/handle_item_smelting(obj/item/target)
	if(istype(target, /obj/item/weapon/tongs))
		handle_tongs(target)
		return
	if(!target.smeltresult || target.smeltresult == /obj/item/fertilizer/ash)
		return
	var/atom/target_loc = target.loc
	var/obj/item/itemtospawn
	// Only ores can be smelted remotely, other items must be held by the owner
	if(istype(target, /obj/item/ore))
		target.visible_message("<font color='yellow'>After [owner]'s incantation, [target] melts into an ingot.</font>")
		itemtospawn = new target.smeltresult(get_turf(target))
	else if(target_loc == owner)
		owner.visible_message("<font color='yellow'>[owner] channels Malum's power to smelt [target] [owner.p_theyre()] holding.</font>")
		itemtospawn = new target.smeltresult(get_turf(target))
	else
		return FALSE
	qdel(target)
	if(ismob(target_loc))
		var/mob/holding_mob = target_loc
		holding_mob.put_in_hands(itemtospawn)
	else
		SEND_SIGNAL(target_loc, COMSIG_TRY_STORAGE_INSERT, itemtospawn, null, TRUE, FALSE)
	var/datum/effect_system/spark_spread/sparks = new()
	sparks.set_up(1, 1, target.loc)
	sparks.start()

/datum/action/cooldown/spell/heat_metal/proc/handle_tongs(obj/item/weapon/tongs/T) //Stole the code from smithing.
	if(!T.held_item)
		return
	var/tyme = world.time + 20 SECONDS
	T.hott = tyme
	addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/weapon/tongs, make_unhot), tyme), 30 SECONDS)
	T.proxy_heat(150)
	T.update_appearance(UPDATE_ICON_STATE)
	T.visible_message("<font color='yellow'>After [owner]'s incantation, [T.held_item] inside [T] starts glowing from divine heat.</font>")

/datum/action/cooldown/spell/heat_metal/proc/handle_anvil(obj/machinery/anvil/A) //Stole the code from smithing.
	if(A.hingot)
		A.hott = world.time
		START_PROCESSING(SSmachines, A)
	A.cool_time = 30 SECONDS
	addtimer(VARSET_CALLBACK(A, cool_time, 10 SECONDS), 30 SECONDS)
	A.update_appearance(UPDATE_ICON_STATE)
	A.visible_message("<font color='yellow'>After [owner]'s incantation, [A] begins to glow from divine heat.</font>")

/datum/action/cooldown/spell/heat_metal/proc/handle_living_entity(mob/target)
	var/obj/item/targeteditem = get_targeted_item(target)
	if(!targeteditem)
		return

	if(istype(targeteditem, /obj/item/weapon/tongs))
		handle_tongs(targeteditem)
		return

	if(!targeteditem.smeltresult || targeteditem.smeltresult == /obj/item/fertilizer/ash)
		owner.visible_message(
			"<font color='yellow'>After their incantation, [owner] points at [target], but nothing happens.</font>",
			"<font color='yellow'>After your incantation, you point at [target], but nothing happens.</font>"
		)
		return

	if(iscarbon(target))
		if(target.is_holding(targeteditem))
			handle_heating_in_hand(target, targeteditem)
		else
			handle_heating_equipped(target, targeteditem)

/datum/action/cooldown/spell/heat_metal/proc/handle_heating_in_hand(mob/living/carbon/target, obj/item/targeteditem)
	var/adth_damage_to_apply = 10 //How much damage should burning your hand before dropping the item do.
	var/obj/item/bodypart/affecting
	var/hand_index = target.get_held_index_of_item(targeteditem)
	switch(hand_index)
		if(2)
			affecting = target.get_bodypart(BODY_ZONE_R_ARM)
		if(1)
			affecting = target.get_bodypart(BODY_ZONE_L_ARM)
	if(!affecting)
		return
	affecting.receive_damage(burn = adth_damage_to_apply)
	target.dropItemToGround(targeteditem)
	target.visible_message("<font color='yellow'>[target]'s [targeteditem.name] glows brightly and sears their flesh!</font>", "<font color='yellow'>Your [targeteditem.name] glows brightly, burning your hand!</font>")
	target.emote("painscream")
	playsound(target.loc, 'sound/misc/frying.ogg', 80, FALSE, -1)
	var/datum/effect_system/spark_spread/sparks = new()
	sparks.set_up(1, 1, target.loc)
	sparks.start()

/datum/action/cooldown/spell/heat_metal/proc/handle_heating_equipped(mob/living/carbon/target, obj/item/clothing/targeteditem)
	var/damage_to_apply = 30 // How much damage should your armor burning you should do.
	var/part_bitflags = targeteditem.body_parts_covered
	var/list/body_zones = body_parts_covered2organ_names(part_bitflags) //list of precise and main body zones
	if(!length(body_zones))
		return
	var/list/filtered_zones = list()
	for(var/body_zone in body_zones)
		filtered_zones |= check_zone(body_zone)
	if(BODY_ZONE_CHEST in filtered_zones)
		var/chest_damage = damage_to_apply
		var/obj/item/armor = target.get_item_by_slot(ITEM_SLOT_ARMOR)
		var/obj/item/shirt = target.get_item_by_slot(ITEM_SLOT_SHIRT)
		var/armor_can_heat = armor && armor.smeltresult && armor.smeltresult != /obj/item/fertilizer/ash
		var/shirt_can_heat = shirt && shirt.smeltresult && shirt.smeltresult != /obj/item/fertilizer/ash //Full damage if no shirt
		if(armor_can_heat && (shirt && !shirt_can_heat))
			chest_damage = damage_to_apply / 2 //Halve the damage if only armor can heat but shirt can't.
		else if(armor_can_heat && shirt_can_heat)
			chest_damage = damage_to_apply * 2 //Damage is doubled if both shirt and armor are metallic
		var/obj/item/bodypart/affecting = target.get_bodypart(BODY_ZONE_CHEST)
		affecting?.receive_damage(burn = chest_damage)
		filtered_zones -= BODY_ZONE_CHEST
	for(var/body_zone in filtered_zones)
		var/obj/item/bodypart/affecting = target.get_bodypart(body_zone)
		affecting?.receive_damage(burn = damage_to_apply)

	target.visible_message(
		"<font color='yellow'>[target]'s [targeteditem.name] glows brightly, searing their flesh!</font>",
		"<font color='yellow'>My [targeteditem.name] glows brightly, burning me!</font>"
	)

	target.emote("painscream")
	playsound(target.loc, 'sound/misc/frying.ogg', 80, FALSE, -1)
	var/datum/effect_system/spark_spread/sparks = new()
	sparks.set_up(1, 1, target.loc)
	sparks.start()

/datum/action/cooldown/spell/heat_metal/proc/get_targeted_item(mob/target)
	var/target_item
	switch(owner.zone_selected)
		if(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_R_INHAND)
			target_item = target.held_items[2]
			if(!target_item)
				target_item = target.get_item_by_slot(ITEM_SLOT_GLOVES)
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_L_INHAND)
			target_item = target.held_items[1]
			if(!target_item)
				target_item = target.get_item_by_slot(ITEM_SLOT_GLOVES)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			target_item = target.get_item_by_slot(ITEM_SLOT_HEAD)
		if(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH)
			target_item = target.get_item_by_slot(ITEM_SLOT_ARMOR)
			if(!target_item)
				target_item = target.get_item_by_slot(ITEM_SLOT_SHIRT)
		if(BODY_ZONE_PRECISE_NECK)
			target_item = target.get_item_by_slot(ITEM_SLOT_NECK)
		if(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE)
			target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
			if(!target_item)
				target_item = target.get_item_by_slot(ITEM_SLOT_HEAD)
		if(BODY_ZONE_PRECISE_MOUTH)
			target_item = target.get_item_by_slot(ITEM_SLOT_MOUTH)
			if(!target_item)
				target_item = target.get_item_by_slot(ITEM_SLOT_HEAD)
		if(BODY_ZONE_R_ARM)
			target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
			if(!target_item)
				target_item = target.held_items[2]
		if(BODY_ZONE_L_ARM)
			target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
			if(!target_item)
				target_item = target.held_items[1]
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_GROIN)
			target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
		if(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
			target_item = target.get_item_by_slot(ITEM_SLOT_SHOES)
	return target_item
