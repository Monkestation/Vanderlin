
/obj/item/clothing/gloves/bandages
	name = "bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "clothwraps"
	item_state = "clothwraps"
	armor = ARMOR_GLOVES_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	unarmed_bonus = 1.125 //Sublight armor with minimal durability, but a greater unarmed damage multiplier. More damage than leather, less than maille. Loadout-selectable.

/obj/item/clothing/gloves/bandages/weighted
	name = "weighted bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with padded knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 1.225 //Craftable. Given to non-specialized Monks and other certain subclasses. Provides a +25% unarmed damage bonus over plate gauntlets.

/obj/item/clothing/gloves/bandages/pugilist
	name = "pugilistic bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with alloyed knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 1.3 //Non-craftable. Restricted to Monks who've specialized in unarmed combat, and nothing else.
