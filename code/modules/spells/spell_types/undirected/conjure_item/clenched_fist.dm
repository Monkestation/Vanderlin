/datum/action/cooldown/spell/undirected/conjure_item/closecombat
	name = "Clench your fists"
	desc = "Ready yourself ofr a fight and assume a stronger stance"
	button_icon_state = "dendor"
	invocation_type = INVOCATION_EMOTE
	invocation_self_message = "You clench your fist and ready yourself for a fight."
	spell_type = SPELL_STAMINA
	antimagic_flags = null
	associated_skill = null
	required_items = null
	spell_cost = 5
	item_duration = null
	cooldown_time = null
	item_type = /obj/item/weapon/clenched_fist
	uses_component = TRUE
	refresh_count = 0
	delete_old = TRUE
	item_outline = null
	attunements = null

/datum/action/cooldown/spell/undirected/conjure_item/closecombat/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	if(!iscarbon(owner))
		if(feedback)
			owner.balloon_alert(owner, "Need hands to clench your fists!")
		return FALSE

/datum/action/cooldown/spell/undirected/conjure_item/closecombat/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/M = owner
	if(!M)
		to_chat(owner, span_warning("Hard to clench your fists when your hands are full"))
		return SPELL_CANCEL_CAST
	if(M.active_hand_index == 1)
		item_type = /obj/item/weapon/clenched_fist
	else
		item_type = /obj/item/weapon/clenched_fist


