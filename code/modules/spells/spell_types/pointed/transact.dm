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
		to_chat(owner, span_info("This has no value, it will be of no use In such a transaction."))
		return
	if(helditemvalue < 10)
		to_chat(owner, span_info("This has little value, it will be of no use in such a transaction."))
		return
	if(istype(cast_on.patron, /datum/patron/psydon))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		cast_on.visible_message(span_info("[cast_on] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		playsound(cast_on, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return
	if(ismobholder(held_item))
		var/obj/item/mob_holder/holder = held_item
		var/mob/living/held_mob = holder.held_mob
		held_item.visible_message(span_danger("[held_mob] starts to fade from view!"), span_userdanger("What's happening to me?!"))
		if(!do_after(owner, 5 SECONDS, held_mob, IGNORE_USER_LOC_CHANGE, display_over_user = TRUE))
			return
		var/turf/T = get_dungeon_tile()
		if(!T)
			return
		held_mob.forceMove(T)
		held_mob.emote("scream", forced = TRUE)
	owner.visible_message(span_notice("The transaction is made, [cast_on] is bathed in empowerment!"))
	to_chat(owner, "<font color='yellow'>[held_item] burns into the air suddenly, my Transaction is accepted.</font>")
	if(iscarbon(cast_on))
		var/mob/living/carbon/C = cast_on
		var/datum/status_effect/buff/matthioshealing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/matthioshealing)
		heal_effect.healing_on_tick = helditemvalue/2
	else
		cast_on.adjustBruteLoss(helditemvalue / 2)
		cast_on.adjustFireLoss(helditemvalue / 2)
	playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
	if(!QDELETED(held_item))
		qdel(held_item) // we might already be qdeleting from mob holder
