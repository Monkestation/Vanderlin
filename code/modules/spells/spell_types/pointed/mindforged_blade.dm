/datum/action/cooldown/spell/mindforged_blade
	button_icon = 'icons/mob/actions/spells/spellfist.dmi'
	name = "Mindforged Blade"
	desc = "The manifestation of the higher concept of a blade itself. each casting a poor facsimile of the perfect weapon They hold."
	button_icon_state = "boundkatar"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	required_form = FORM_EARTH
	required_technique = TECHNIQUE_IMBUE

	spell_cost = 30

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/drawmessage = "I imagine the perfect weapon, forged by arcyne knowledge, it's edge flawless. \
	I feel it in my mind's eye -- but it's just out of reach. I pull away it's shadow, a bad copy, and yet it is one of a great weapon nonetheless... "
	var/dropmessage = "Letting go, I watch the blade lose it's form, unable to stay stable without my energy rooting it to this world..."
	var/obj/item/melee/touch_attack/weapon/mindforged_katar/summoned_blade

/datum/action/cooldown/spell/mindforged_blade/Destroy()
	if(summoned_blade && !QDELETED(summoned_blade))
		UnregisterSignal(summoned_blade, COMSIG_QDELETING)
		QDEL_NULL(summoned_blade)
	return ..()

/datum/action/cooldown/spell/mindforged_blade/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/user = owner
	if(!istype(user))
		return FALSE

	if(summoned_blade && !QDELETED(summoned_blade))
		qdel(summoned_blade)
		to_chat(user, span_notice("[dropmessage]"))
		return FALSE

	summoned_blade = new(user)
	summoned_blade.spell_which_made_us = null
	RegisterSignal(summoned_blade, COMSIG_QDELETING, PROC_REF(on_blade_destroyed))
	if(!user.put_in_hands(summoned_blade))
		qdel(summoned_blade)
		if(user.usable_hands <= 0)
			to_chat(user, span_warning("I don't have any usable hands!"))
		else
			to_chat(user, span_warning("My hands are full!"))
		return FALSE
	to_chat(user, span_notice("[drawmessage]"))
	return TRUE

/datum/action/cooldown/spell/mindforged_blade/proc/on_blade_destroyed(datum/source)
	SIGNAL_HANDLER
	summoned_blade = null

/obj/item/melee/touch_attack/weapon/mindforged_katar
	name = "\improper mindforged katar"
	desc = "This blade throbs, translucent and iridiscent, blueish arcyne energies running through its translucent surface..."
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 999
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/attribute/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 0
	can_parry = TRUE

/obj/item/melee/touch_attack/weapon/mindforged_katar/attack_self()
	qdel(src)
