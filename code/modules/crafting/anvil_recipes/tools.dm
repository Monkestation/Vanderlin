/datum/anvil_recipe/tools
	i_type = "Utilities"
	abstract_type = /datum/anvil_recipe/tools
	appro_skill = /datum/skill/craft/blacksmithing // already in parent just in here so people know
	category = "Tools"

// --------- TIN -----------

/datum/anvil_recipe/tools/tin
	craftdiff = 0 // for starters
	req_bar = /obj/item/ingot/tin
	abstract_type = /datum/anvil_recipe/tools/tin
///////////////////////////////////////////////

/datum/anvil_recipe/tools/tin/platter
	name = "2x Platters (tin)"
	created_item = /obj/item/plate/pewter
	createditem_extra = 1

/datum/anvil_recipe/tools/tin/spoon
	name = "2x Spoons (tin)"
	created_item = /obj/item/kitchen/spoon/pewter
	createditem_extra = 1

/datum/anvil_recipe/tools/tin/fork
	name = "2x Forks (tin)"
	created_item = /obj/item/kitchen/fork/pewter
	createditem_extra = 1

// --------- COPPER -----------

/datum/anvil_recipe/tools/copper
	craftdiff = 0 // for starters
	req_bar = /obj/item/ingot/copper
	abstract_type = /datum/anvil_recipe/tools/copper
///////////////////////////////////////////////

/datum/anvil_recipe/tools/copper/hoe
	name = "Copper Hoe (+Stick x2)"
	recipe_name = "a gardening Hoe"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hoe/copper

/datum/anvil_recipe/tools/copper/sickle
	name = "Copper Sickle (+Stick)"
	recipe_name = "a Sickle"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sickle/copper

/datum/anvil_recipe/tools/copper/pitchfork
	name = "Copper Pitchfork (+Stick x2)"
	recipe_name = "a Pitchfork"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pitchfork/copper

/datum/anvil_recipe/tools/copper/pick
	name = "Copper Pick (+Stick)"
	recipe_name = "a digging Pick"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/copper

/datum/anvil_recipe/tools/copper/lamptern
	name = "Copper Lamptern"
	recipe_name = "a Lamptern"
	created_item = /obj/item/flashlight/flare/torch/lantern/copper

/datum/anvil_recipe/tools/copper/hammer
	name = "Copper Hammer (+Stick)"
	recipe_name = "a blacksmithing Hammer"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hammer/copper

/datum/anvil_recipe/tools/copper/pote
	name = "Cooking pot (copper)"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper

/datum/anvil_recipe/tools/copper/platter
	name = "2x Platters (copper)"
	recipe_name = "a platter"
	created_item = /obj/item/plate/copper
	createditem_extra = 1

// --------- BRONZE -----------

/datum/anvil_recipe/tools/bronze
	craftdiff = 1
	req_bar = /obj/item/ingot/bronze
	abstract_type = /datum/anvil_recipe/tools/bronze
///////////////////////////////////////////////

/datum/anvil_recipe/tools/bronze/chisel
	name = "Bronze Chisel"
	created_item = /obj/item/weapon/chisel/bronze

/datum/anvil_recipe/tools/bronze/cogbronze
	name = "3x Bronze Cog"
	recipe_name = "three Cogs"
	appro_skill = /datum/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/bronze
	craftdiff = 1
	createditem_extra = 2

// --------- IRON -----------

/datum/anvil_recipe/tools/iron
	craftdiff = 1
	req_bar = /obj/item/ingot/iron
	abstract_type = /datum/anvil_recipe/tools/iron
///////////////////////////////////////////////

/datum/anvil_recipe/tools/iron/keyring
	name = "3x Keyrings"
	recipe_name = "three Keyrings"
	created_item = /obj/item/storage/keyring
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/locks
	name = "3x Custom Locks"
	recipe_name = "three Locks"
	appro_skill = /datum/skill/craft/engineering // To train engineering
	created_item = /obj/item/customlock
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/lockpicks
	name = "3x Lockpicks"
	recipe_name = "three Lockpicks"
	created_item = /obj/item/lockpick
	createditem_extra = 2
	craftdiff = 1

/datum/anvil_recipe/tools/iron/lockpickring
	name = "3x Lockpickrings"
	recipe_name = "three Lockpickrings"
	created_item = /obj/item/lockpickring
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/blankeys
	name = "3x Blank Custom Keys"
	recipe_name = "three Blank Keys"
	appro_skill = /datum/skill/craft/engineering // To train engineering
	created_item = /obj/item/key/custom
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/chains
	name = "3x Chains"
	recipe_name = "three lengths of Chain"
	created_item = /obj/item/rope/chain
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/lamptern
	name = "Iron Lamptern"
	recipe_name = "a Lamptern"
	created_item = /obj/item/flashlight/flare/torch/lantern

/datum/anvil_recipe/tools/iron/cogiron
	name = "2x Iron Cog"
	recipe_name = "two Cogs"
	appro_skill = /datum/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/iron
	craftdiff = 1
	createditem_extra = 1

/datum/anvil_recipe/tools/iron/hammer
	name = "Hammer (+Stick)"
	recipe_name = "a blacksmithing Hammer"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hammer/iron

/datum/anvil_recipe/tools/iron/hoe
	name = "Hoe (+Stick x2)"
	recipe_name = "a gardening Hoe"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hoe

/datum/anvil_recipe/tools/iron/mantrap
	name = "Mantrap"
	recipe_name = "a mantrap"
	created_item = /obj/item/restraints/legcuffs/beartrap/crafted

/datum/anvil_recipe/tools/iron/fishinghooks
	name = "3x Fishing hooks"
	created_item = /obj/item/fishing/hook/iron
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/pick
	name = "Pick (+Stick)"
	recipe_name = "a digging Pick"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick

/datum/anvil_recipe/tools/iron/pitchfork
	name = "Pitchfork (+Stick x2)"
	recipe_name = "a Pitchfork"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pitchfork

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "3x Sewing Needles"
	recipe_name = "three Sewing Needles"
	created_item = /obj/item/needle
	createditem_extra = 2 // They can be refilled with fiber now

/datum/anvil_recipe/tools/iron/shovel
	name = "Shovel (+Stick x2)"
	recipe_name = "a Shovel"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/shovel

/datum/anvil_recipe/tools/iron/sickle
	name = "Sickle (+Stick)"
	recipe_name = "a Sickle"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sickle

/datum/anvil_recipe/tools/iron/tongs
	name = "Tongs"
	recipe_name = "a pair of Tongs"
	created_item = /obj/item/weapon/tongs

/datum/anvil_recipe/tools/iron/torch
	name = "5x Iron Torches (+Coal)"
	recipe_name = "five Torches"
	additional_items = list(/obj/item/ore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	createditem_extra = 4
	craftdiff = 0

/datum/anvil_recipe/tools/iron/pote
	name = "Cooking pot (iron)"
	recipe_name = "a cooking pot"
	created_item = /obj/item/reagent_containers/glass/bucket/pot
	craftdiff = 1

/datum/anvil_recipe/tools/iron/headhook
	name = "Iron Headhook (+Fibers x2)"
	recipe_name = "An iron headhook"
	additional_items = list(/obj/item/natural/fibers = 2)
	created_item = /obj/item/storage/hip/headhook
	craftdiff = 3

/datum/anvil_recipe/tools/iron/chisel
	name = "Iron Chisel"
	created_item = /obj/item/weapon/chisel/iron

/datum/anvil_recipe/tools/iron/spoon
	name = "2x Spoons (iron)"
	recipe_name = "a Spoon"
	created_item = /obj/item/kitchen/spoon/iron
	createditem_extra = 1

/datum/anvil_recipe/tools/iron/fork
	name = "2x Forks (iron)"
	recipe_name = "a Fork"
	created_item = /obj/item/kitchen/fork/iron
	createditem_extra = 1

/datum/anvil_recipe/tools/iron/cups
	name = "3x Metal Cups"
	recipe_name = "three drinking Cups"
	created_item = /obj/item/reagent_containers/glass/cup
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/dice_cups
	name = "3x Metal Dice Cups"
	recipe_name = "three Dice Cups"
	created_item = /obj/item/dice_cup
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/tools/iron/scissors
	name = "Scissors"
	created_item = /obj/item/weapon/knife/scissors

/datum/anvil_recipe/tools/iron/frypan
	name = "Pan"
	recipe_name = "a Frypan"
	created_item = /obj/item/cooking/pan
	craftdiff = 0

/datum/anvil_recipe/tools/iron/surgerytools
	name = "Set of Surgery Tools (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/surgeontoolspawner

// --------- STEEL -----------

/datum/anvil_recipe/tools/steel
	craftdiff = 2
	req_bar = /obj/item/ingot/steel
	abstract_type = /datum/anvil_recipe/tools/steel
///////////////////////////////////////////////

/datum/anvil_recipe/tools/steel/cogstee
	name = "3x Steel Cogs"
	recipe_name = "three Cogs"
	appro_skill = /datum/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/steel
	craftdiff = 1
	createditem_extra = 2

/datum/anvil_recipe/tools/steel/scissors
	name = "Steel Scissors"
	created_item = /obj/item/weapon/knife/scissors/steel

/datum/anvil_recipe/tools/steel/pick
	name = "Steel Pick (+Stick)"
	recipe_name = "a digging Pick"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/steel

/datum/anvil_recipe/tools/steel/gobletsteel
	name = "3x Goblets"
	recipe_name = "three Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/steel
	createditem_extra = 2
	craftdiff = 1

/datum/anvil_recipe/tools/steel/chisel
	name = "Steel Chisel"
	recipe_name = "a Chisel"
	created_item = /obj/item/weapon/chisel
	craftdiff = 1

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver
	craftdiff = 3
	req_bar = /obj/item/ingot/silver
	abstract_type = /datum/anvil_recipe/tools/silver
///////////////////////////////////////////////

/datum/anvil_recipe/tools/silver/gobletsilver
	name = "3x Silver Goblets"
	recipe_name = "three Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/silver
	createditem_extra = 2
	craftdiff = 2

/datum/anvil_recipe/tools/silver/carafesilver
	name = "Silver Carafe"
	recipe_name = "Silver Carafe"
	created_item = /obj/item/reagent_containers/glass/carafe/silver

/datum/anvil_recipe/tools/silver/platter
	name = "2x Platters (silver)"
	created_item = /obj/item/plate/silver
	craftdiff = 2

/datum/anvil_recipe/tools/silver/servantbell
	name = "x3 Service Bells"
	created_item = /obj/item/servant_bell
	createditem_extra = 2
	craftdiff = 3


// --------- GOLD -----------

/datum/anvil_recipe/tools/gold
	craftdiff = 3
	req_bar = /obj/item/ingot/gold
	abstract_type = /datum/anvil_recipe/tools/gold
///////////////////////////////////////////////

/datum/anvil_recipe/tools/gold/gobletgold
	name = "3x Golden Goblets"
	recipe_name = "three Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/golden
	createditem_extra = 2
	craftdiff = 2

/datum/anvil_recipe/tools/gold/carafegold
	name = "Golden Carafe"
	recipe_name = "Golden Carafe"
	created_item = /obj/item/reagent_containers/glass/carafe/gold

/datum/anvil_recipe/tools/gold/platter
	name = "2x Platters (gold)"
	created_item = /obj/item/plate/gold
	craftdiff = 2
