//................	Chisel	............... //
/obj/item/weapon/chisel
	name = "chisel"
	desc = "Hold it in one hand with a mallet or stone in the other. Strike with this to stonework."
	icon_state = "chisel"
	icon = 'icons/roguetown/weapons/tools.dmi'
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	force = 10
	throwforce = 2
	possible_item_intents = list(/datum/intent/chisel, /datum/intent/stab)
	sharpness = IS_SHARP
	dropshrink = 0.9
	w_class = WEIGHT_CLASS_SMALL
	wdefense = 0
	blade_dulling = 0
	max_integrity = 140
	slot_flags = ITEM_SLOT_HIP
	// swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/brick_drop.ogg'
	associated_skill = /datum/skill/combat/knives
	max_blade_int = 50
	dropshrink = 0.9
	grid_height = 64
	grid_width = 32
	melt_amount = 50
	melting_material = /datum/material/steel
	var/time_multiplier = 1

/datum/intent/chisel
	name = "chisel"
	icon_state = "inchisel"
	attack_verb = list("chisels")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	blade_class = null
	no_attack = TRUE
	noaa = TRUE
	misscost = 0
	releasedrain = 0

/obj/item/weapon/chisel/iron
	name = "iron chisel"
	smeltresult = /obj/item/ingot/iron
	time_multiplier = 1.1

/obj/item/weapon/chisel/bronze
	name = "bronze chisel"
	smeltresult = /obj/item/ingot/bronze
	time_multiplier = 1.2
