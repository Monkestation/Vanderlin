
/obj/item/clothing/gloves/chain
	name = "chain gauntlets"
	desc = "Gauntlets made out of interwoven steel chains. Average melee protection, though better used to stop arrows from being lethal."
	icon_state = "cgloves"
	resistance_flags = null
	blocksound = CHAINHIT
	blade_dulling = DULLING_BASHCHOP
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = null
	sewrepair = FALSE

	armor_class = AC_MEDIUM
	armor = ARMOR_MAILLE
	prevent_crits = ALL_EXCEPT_BLUNT
	max_integrity = INTEGRITY_STRONGEST
	sewrepair = FALSE
	item_weight = 7 * IRON_MULTIPLIER
	smeltresult = null
	melting_material = /datum/material/steel
	melt_amount = 50

/obj/item/clothing/gloves/chain/psydon
	name = "grenzelhoftian chain gauntlets"
	icon_state = "psydongloveschain"
	item_state = "psydongloveschains"
	melting_material = /datum/material/silver
	melt_amount = 75

/obj/item/clothing/gloves/chain/iron
	name = "iron chain gauntlets"
	icon_state = "icgloves"
	desc = "Gauntlets made out of interwoven iron chains. Decent melee protection, but are better suited to stop arrows than blades."
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STRONG
	item_weight = 7 * IRON_MULTIPLIER
	smeltresult = null
	melting_material = /datum/material/iron
	melt_amount = 50

/obj/item/clothing/gloves/chain/iron/shadowgauntlets
	name = "darkplate gauntlets"
	desc = "Gauntlets with gilded fingers fashioned into talons. The tips are all too dull to be of harm."
	icon_state = "shadowgauntlets"
	allowed_race = RACES_PLAYER_ELF_ALL
	item_weight = 6 * STEEL_MULTIPLIER

/obj/item/clothing/gloves/chain/vampire
	name = "ancient ceremonial gloves"
	desc = "A weathered gauntlet with an ancient design."
	icon_state = "vgloves"
	item_weight = 6 * STEEL_MULTIPLIER
