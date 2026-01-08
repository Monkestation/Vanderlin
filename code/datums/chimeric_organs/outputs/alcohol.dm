/datum/chimeric_node/output/alcoholic
	name = "Distillery"
	desc = "Adds anti toxin in relation to the alcohol inside you."
	tier = 4
	node_purity = 100

/datum/chimeric_node/output/alcoholic/set_values(node_purity, tier)
	return

/datum/chimeric_node/output/alcoholic/trigger_effect(multiplier)
	. = ..()

	var/is_good = TRUE
	for(var/datum/reagent/reagent as anything in hosted_carbon.reagents.reagent_list)
		if(!istype(reagent, /datum/reagent/consumable/ethanol) && !istype(reagent, /datum/reagent/distillery))
			is_good = FALSE
			break

	if(is_good)
		to_chat(hosted_carbon, span_notice("You feel your body produce some anti-toxin to help with the alcohol!"))
		hosted_carbon.reagents.add_reagent(/datum/reagent/distillery, multiplier)
		attached_organ.applyOrganDamage(-3)
	else
		to_chat(hosted_carbon, span_warning("You feel your body reject any drinks besides alcohol!"))
		hosted_carbon.reagents.add_reagent(/datum/reagent/consumable/ethanol, multiplier)
		var/obj/item/organ/liver/carbons_liver = hosted_carbon.getorganslot(ORGAN_SLOT_LIVER)
		carbons_liver.applyOrganDamage(3) //this hurts but you can still drink it

/datum/reagent/distillery
	name = "Distillery Juice"
	description = "Heals toxin damage and liver damage"
	reagent_state = LIQUID
	color = "#00a000"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/distillery/on_mob_life(mob/living/carbon/M)
	var/repair_strength = 1
	var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
	if(L.damage > 0)
		L.damage = max(L.damage - 4 * repair_strength, 0)
		M.set_confusion_if_lower(2 SECONDS)
	M.reagents.remove_all_type(/datum/reagent/medicine, 3*REM, 0, 1)
	M.adjustToxLoss(-6)
	. = ..()
