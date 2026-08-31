/datum/action/cooldown/spell/blood_poison
	name = "Create Blood Poison"
	desc = "Coat a blade with deadly poison or contaminate target food and drink."
	button_icon_state = "dream_lotus"
	sound = 'sound/magic/psydonbleeds.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_CREATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	invocation_type = INVOCATION_WHISPER
	invocation = "Sanguis nota"

	charge_required = FALSE
	cooldown_time = 3 MINUTES
	spell_cost = 200
	spell_flags = SPELL_UNETCHABLE
	self_cast_possible = FALSE

	var/blade_poison_amt = 5
	var/container_poison_amt = 5

/datum/action/cooldown/spell/blood_poison/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(isweapon(cast_on))
		var/obj/item/weapon/target_weapon = cast_on
		if(!target_weapon.sharpness)
			to_chat(owner, span_warning("[src] can only be used on bladed weapons!"))
			return FALSE
		return TRUE

	if(isreagentcontainer(cast_on))
		var/obj/item/reagent_containers/container = cast_on
		if(container.reagents.maximum_volume >= container.reagents.total_volume)
			to_chat(owner, span_warning("[container] is already full!"))
			return FALSE
		return TRUE
	return FALSE

/datum/action/cooldown/spell/blood_poison/cast(atom/cast_on)
	. = ..()
	if(isweapon(cast_on))
		var/obj/item/weapon/target_weapon = cast_on
		target_weapon.AddElement(/datum/element/one_time_poison, list(/datum/reagent/poison/bloodstone_essence = blade_poison_amt))
		to_chat(owner, span_warning("I poison [target_weapon]."))
		log_attack("[key_name(owner)] coated [target_weapon] with blood poison.")
		return TRUE

	if(isreagentcontainer(cast_on))
		var/obj/item/reagent_containers/container = cast_on
		container.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, container_poison_amt)
		to_chat(owner, span_warning("I poison [container]."))
		log_attack("[key_name(owner)] added blood poison to [container] in [get_area(container)].")
		return TRUE
	return FALSE
