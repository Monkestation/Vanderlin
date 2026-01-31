/datum/action/cooldown/spell/undirected/conjure_item/brick
	name = "Magician's Brick"
	desc = "Conjure a magical brick in your hand for 3 minutes. \
	This spell has been honed over centuries to bypass anti-magic defenses."
	button_icon_state = "magicians_brick"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1

	cooldown_time = 5 SECONDS
	spell_cost = 30

	invocation = "Valtarem!"
	invocation_type = INVOCATION_SHOUT
	spell_flags = SPELL_RITUOS
	item_type = /obj/item/weapon/magicbrick
	item_duration = 3 MINUTES
	item_outline = "#6495ED"

	attunements = list(
		/datum/attunement/earth = 0.3,
	)

/datum/action/cooldown/spell/undirected/conjure_item/brick/make_item()
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	var/INT = L.STAINT
	if(INT <= 10)
		return
	var/obj/item/brick = .
	var/int_scaling = INT - 10
	brick.force = (brick.force + int_scaling) * attuned_strength
	brick.throwforce = (brick.throwforce + int_scaling * 2) * attuned_strength // 2x scaling for throwing. Let's go.
	brick.name = "magician's brick +[int_scaling]"
	return brick

/obj/item/weapon/magicbrick
	name = "magician's brick"
	desc = "A brick formed out of arcyne energy. Makes for a deadly melee and throwing weapon."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickcook"
	dropshrink = 0.75
	force = 15 // Copy pasted from real brick + 1 for neat number
	throwforce = 20 // +2 from real brick for neat scaling
	throw_speed = 4
	armor_penetration = 30 // From iron tossblade
	wdefense = BAD_PARRY
	wbalance = DODGE_CHANCE_NORMAL
	max_integrity = INTEGRITY_WORST / 2 //Not for parrying
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	possible_item_intents = list(MACE_STRIKE) // Not giving it smash so it don't become competetive with conjure weapon (as a melee weapon)
	associated_skill = /datum/skill/combat/axesmaces // If it was tied to Arcane it'd be too strong
	hitsound = list('sound/combat/hits/blunt/brick.ogg')
