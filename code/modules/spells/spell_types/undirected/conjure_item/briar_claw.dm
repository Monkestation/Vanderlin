/datum/action/cooldown/spell/undirected/conjure_item/briar_claw
	name = "Briar Claw"
	desc = "Turns one hand into a wolf's claw."
	button_icon_state = "dendor"
	invocation = "Beast-Lord, lend me the claws of a volf."
	invocation_type = INVOCATION_WHISPER
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	spell_cost = 15
	item_duration = 1 MINUTES
	cooldown_time = 4 MINUTES
	item_type = /obj/item/weapon/briar_claw/left
	uses_component = TRUE
	refresh_count = 0
	delete_old = TRUE
	item_outline = "#1bab68"
	attunements = list(
		/datum/attunement/blood = 0.3,
		/datum/attunement/earth = 0.7
	)

/datum/action/cooldown/spell/undirected/conjure_item/briar_claw/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	if(!iscarbon(owner))
		if(feedback)
			owner.balloon_alert(owner, "Only mortals may use the briar claw!")
		return FALSE

/datum/action/cooldown/spell/undirected/conjure_item/briar_claw/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/M = owner
	if(!M)
		to_chat(owner, span_warning("You have no hands to transform!"))
		return SPELL_CANCEL_CAST
	if(M.active_hand_index == 1)
		item_type = /obj/item/weapon/briar_claw/left
	else
		item_type = /obj/item/weapon/briar_claw/right

/obj/item/weapon/briar_claw
	parent_type = /obj/item/weapon/werewolf_claw
	name = "briar claw"
	desc = "A volf's claw."
	force = DAMAGE_KATAR
	wdefense = MEDIOCRE_PARRY
	armor_penetration = 7
	max_blade_int = 700
	max_integrity = INTEGRITY_STRONGEST + 200

/obj/item/weapon/briar_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/item/weapon/briar_claw/right
	icon_state = "claw_r"

/obj/item/weapon/briar_claw/left
	icon_state = "claw_l"

