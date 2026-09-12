/datum/action/cooldown/spell/aetherknife
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	name = "Aetherknife"
	desc = "Congeal magickal energies into a blade which gains a bonus to power based on INT.\n\
	The blade lasts until a new one is summoned or the spell is forgotten. Deals physical damage."
	button_icon_state = "aetherknife"
	sound = 'sound/magic/whiteflame.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	required_form = FORM_LIGHTNING

	invocation = "Desperta ferro!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/weapon/conjured_knife = null

/datum/action/cooldown/spell/aetherknife/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_knife)
		qdel(conjured_knife)
	var/obj/item/weapon/R = new /obj/item/weapon/knife/throwingknife/aetherknife(user.drop_location())
	R.AddComponent(/datum/component/conjured_item, null, FALSE, user, src)

	if(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) > 10)
		var/int_scaling = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) - 10
		R.force = R.force + int_scaling
		R.throwforce = FLOOR(R.throwforce + int_scaling * 1.5, 1)
		R.name = "aetherknife +[int_scaling]"
	user.put_in_hands(R)
	src.conjured_knife = R
	return TRUE

/datum/action/cooldown/spell/aetherknife/Destroy()
	if(src.conjured_knife)
		conjured_knife.visible_message(span_warning("[conjured_knife] disintegrates into glittering motes!"))
		qdel(conjured_knife)
	return ..()

/obj/item/weapon/knife/throwingknife/aetherknife
	name = "aetherknife"
	desc = "A knife formed out of congealed magickal energies. Makes for a very deadly melee and throwing weapon."
	icon_state = "aetherknife"
	icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	force = 15
	throwforce = 20
	wdefense = 3
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/sword/thrust/short)
	sellprice = 0
