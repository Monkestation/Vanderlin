/datum/action/cooldown/spell/transact
	name = "Transact"
	desc = "Call upon your patron to heal the wounds of yourself or others by sacrificing an item's value as healing."
	button_icon_state = "transact"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy

	cast_range = 4
	charge_required = FALSE
	cooldown_time = 20 SECONDS
	spell_cost = 20

/datum/action/cooldown/spell/transact/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/transact/cast(mob/living/cast_on)
	. = ..()
	var/obj/item/held_item = owner.get_active_held_item()
	if(!held_item)
		to_chat(owner, span_info("I need something of value to make a transaction..."))
		return
	var/helditemvalue = held_item.get_real_price()
	if(!helditemvalue)
		to_chat(owner, span_info("This has no value, It will be of no use In such a transaction."))
		return
	if(helditemvalue < 10)
		to_chat(owner, span_info("This has little value, It will be of no use In such a transaction."))
		return
	if(istype(held_item, /obj/item/clothing/head/mob_holder))
		to_chat(owner, span_info("This feels like a bad idea."))
		return
	if(istype(cast_on.patron, /datum/patron/psydon))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		cast_on.visible_message(span_info("[cast_on] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		playsound(cast_on, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return
	owner.visible_message(span_notice("The transaction Is made, [cast_on] Is bathed In empowerment!"))
	to_chat(owner, "<font color='yellow'>[held_item] burns into the air suddenly, my Transaction is accepted.</font>")
	if(iscarbon(cast_on))
		var/mob/living/carbon/C = cast_on
		var/datum/status_effect/buff/matthioshealing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/matthioshealing)
		heal_effect.healing_on_tick = helditemvalue/2
	else
		cast_on.adjustBruteLoss(helditemvalue / 2)
		cast_on.adjustFireLoss(helditemvalue / 2)
	playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
	qdel(held_item)
