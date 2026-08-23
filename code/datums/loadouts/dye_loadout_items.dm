/datum/loadout_item/dye_color
	abstract_type = /datum/loadout_item/dye_color
	ui_category = "Colors"
	ui_icon = 'icons/roguetown/items/misc.dmi'
	ui_icon_state = "bait"
	loadout_flags = LOADOUT_FLAG_NO_EQUIP | LOADOUT_FLAG_NO_RENT
	/// The hex color this item represents, e.g. "#3a7d44"
	var/color_hex = "#FFFFFF"
	/// Which dye palette this comes from: "peasant", "noble", "royal", "mage"
	var/palette = "peasant"

/datum/loadout_item/dye_color/proc/is_color_owned_by(client/C)
	return is_owned_and_accessible(C)

/datum/loadout_item/dye_color/peasant
	abstract_type = /datum/loadout_item/dye_color/peasant
	triumph_cost_permanent = 0
	palette = "peasant"

/datum/loadout_item/dye_color/peasant/undyed
	name = "Undyed Linen"
	color_hex = "#d4c5a9"

/datum/loadout_item/dye_color/peasant/mud_brown
	name = "Mud Brown"
	color_hex = "#6b4226"

/datum/loadout_item/dye_color/peasant/ash_grey
	name = "Ash Grey"
	color_hex = "#7a7a7a"

/datum/loadout_item/dye_color/peasant/woad_blue
	name = "Woad Blue"
	color_hex = "#4a6fa5"

/datum/loadout_item/dye_color/peasant/madder_red
	name = "Madder Red"
	color_hex = "#8b2020"

/datum/loadout_item/dye_color/peasant/weld_yellow
	name = "Weld Yellow"
	color_hex = "#c8a415"

/datum/loadout_item/dye_color/peasant/forest_green
	name = "Forest Green"
	color_hex = "#3a7d44"

/datum/loadout_item/dye_color/peasant/onyx_black
	name = "Onyx Black"
	color_hex = "#1a1a1a"

/datum/loadout_item/dye_color/peasant/bone_white
	name = "Bone White"
	color_hex = "#f0ead6"

/datum/loadout_item/dye_color/noble
	abstract_type = /datum/loadout_item/dye_color/noble
	triumph_cost_permanent = 120
	palette = "noble"

/datum/loadout_item/dye_color/noble/royal_blue
	name = "Royal Blue"
	color_hex = "#1a3a6b"

/datum/loadout_item/dye_color/noble/deep_crimson
	name = "Deep Crimson"
	color_hex = "#8b0000"

/datum/loadout_item/dye_color/noble/forest_emerald
	name = "Forest Emerald"
	color_hex = "#1a6b3a"

/datum/loadout_item/dye_color/noble/midnight_purple
	name = "Midnight Purple"
	color_hex = "#3a1a6b"

/datum/loadout_item/dye_color/noble/burnt_sienna
	name = "Burnt Sienna"
	color_hex = "#8b4513"

/datum/loadout_item/dye_color/noble/slate_teal
	name = "Slate Teal"
	color_hex = "#2d7a7a"

/datum/loadout_item/dye_color/noble/ivory_cream
	name = "Ivory Cream"
	color_hex = "#fffff0"

/datum/loadout_item/dye_color/noble/charcoal
	name = "Charcoal"
	color_hex = "#36454f"

/datum/loadout_item/dye_color/royal
	abstract_type = /datum/loadout_item/dye_color/royal
	triumph_cost_permanent = 300
	palette = "royal"

/datum/loadout_item/dye_color/royal/tyrian_purple
	name = "Tyrian Purple"
	color_hex = "#66023c"

/datum/loadout_item/dye_color/royal/imperial_gold
	name = "Imperial Gold"
	color_hex = "#d4af37"

/datum/loadout_item/dye_color/royal/kings_scarlet
	name = "King's Scarlet"
	color_hex = "#cc2200"

/datum/loadout_item/dye_color/royal/azure_cerulean
	name = "Azure Cerulean"
	color_hex = "#007fff"

/datum/loadout_item/dye_color/royal/ivory_silk
	name = "Ivory Silk"
	color_hex = "#f8f4e3"

/datum/loadout_item/dye_color/mage
	abstract_type = /datum/loadout_item/dye_color/mage
	triumph_cost_permanent = 200
	palette = "mage"

/datum/loadout_item/dye_color/mage/mage_green
	name = "Mage Green"
	color_hex = CLOTHING_MAGE_GREEN

/datum/loadout_item/dye_color/mage/mage_yellow
	name = "Mage Yellow"
	color_hex = CLOTHING_MAGE_YELLOW

/datum/loadout_item/dye_color/mage/mage_orange
	name = "Mage Orange"
	color_hex = CLOTHING_MAGE_ORANGE

/datum/loadout_item/dye_color/mage/mage_blue
	name = "Mage Blue"
	color_hex = CLOTHING_MAGE_BLUE
