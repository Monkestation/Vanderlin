/datum/action/cooldown/spell/undirected/touch/bladeofpsydon
	name = "Blade of Psydon"
	desc = "The manifestation of the higher concept of a blade itself. Said to be drawn upon from Noc's treasury of wisdom, each casting a poor facsimile of the perfect weapon They hold."
	button_icon_state = "boundkatar"
	can_cast_on_self = TRUE

	point_cost = 2
	attunements = list(
		/datum/attunement/light = 0.6,
	)

	hand_path = /obj/item/melee/touch_attack/bladeofpsydon
	draw_message = "I imagine the perfect weapon, forged by arcyne knowledge, it's edge flawless. \
	I feel it in my mind's eye -- but it's just out of reach. I pull away it's shadow, a bad copy, and yet it is one of a great weapon nonetheless... "
	drop_message = "I release my arcyne focus."
	charges = 3

/datum/action/cooldown/spell/undirected/touch/bladeofpsydon/adjust_hand_charges()
	charges += FLOOR(attuned_strength * 1.5, 1)

/datum/action/cooldown/spell/undirected/touch/bladeofpsydon/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)


/obj/item/melee/touch_attack/bladeofpsydon
	name = "\improper arcyne push dagger"
	desc = "This blade throbs, translucent and iridescent, blueish arcyne energies running through its translucent surface..."
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	force = DAMAGE_KATAR + 9
	wdefense = GREAT_PARRY
	wlength = WLENGTH_SHORT
	possible_item_intents = list(KATAR_CUT, KATAR_THRUST)
	max_blade_int = 999
	max_integrity = INTEGRITY_WORST / 2

	gripsprite = FALSE
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
