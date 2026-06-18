/datum/anvil_recipe/tools
	abstract_type = /datum/anvil_recipe/tools
	appro_skill = /datum/attribute/skill/craft/blacksmithing // already in parent just in here so people know
	category = "Tools"

// --------- TIN -----------

/datum/anvil_recipe/tools/tin
	craftdiff = 0 // for starters
	required_material = /obj/item/ingot/tin
	abstract_type = /datum/anvil_recipe/tools/tin
///////////////////////////////////////////////

/datum/anvil_recipe/tools/tin/platter
	name = "Platters (tin)"
	created_item = /obj/item/plate/pewter
	output_amount = 2

/datum/anvil_recipe/tools/tin/spoon
	name = "Spoons (tin)"
	created_item = /obj/item/kitchen/spoon/pewter
	output_amount = 2

/datum/anvil_recipe/tools/tin/fork
	name = "Forks (tin)"
	created_item = /obj/item/kitchen/fork/pewter
	output_amount = 2

/datum/anvil_recipe/tools/tin/bowl
	name = "Bowl (tin)"
	created_item = /obj/item/reagent_containers/glass/bowl/pewter
	output_amount = 2

/datum/anvil_recipe/tools/tin/zig
	name = "tin zigbox"
	created_item = /obj/item/storage/fancy/cigarettes/tinzig/empty

// --------- COPPER -----------

/datum/anvil_recipe/tools/copper
	craftdiff = 0 // for starters
	required_material = /obj/item/ingot/copper
	abstract_type = /datum/anvil_recipe/tools/copper
///////////////////////////////////////////////

/datum/anvil_recipe/tools/copper/hoe
	name = "Copper Hoe (+Stick x2)"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hoe/copper

/datum/anvil_recipe/tools/copper/sickle
	name = "Copper Sickle (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sickle/copper

/datum/anvil_recipe/tools/copper/pitchfork
	name = "Copper Pitchfork (+Stick x2)"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pitchfork/copper

/datum/anvil_recipe/tools/copper/pick
	name = "Copper Pick (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/copper

/datum/anvil_recipe/tools/copper/lamptern
	name = "Copper Lamptern"
	created_item = /obj/item/flashlight/flare/torch/lantern/copper

/datum/anvil_recipe/tools/copper/hammer
	name = "Copper Hammer (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hammer/copper

/datum/anvil_recipe/tools/copper/pote
	name = "Cooking pot (copper)"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper

/datum/anvil_recipe/tools/copper/platter
	name = "Platters (copper)"
	created_item = /obj/item/plate/copper
	output_amount = 2

// --------- BRONZE -----------

/datum/anvil_recipe/tools/bronze
	craftdiff = 1
	required_material = /obj/item/ingot/bronze
	abstract_type = /datum/anvil_recipe/tools/bronze
///////////////////////////////////////////////

/datum/anvil_recipe/tools/bronze/chisel
	name = "Bronze Chisel"
	created_item = /obj/item/weapon/chisel/bronze

/datum/anvil_recipe/tools/bronze/cogbronze
	name = "Bronze Cog"
	appro_skill = /datum/attribute/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/bronze
	craftdiff = 1
	output_amount = 3

// --------- IRON -----------

/datum/anvil_recipe/tools/iron
	craftdiff = 1
	required_material = /obj/item/ingot/iron
	abstract_type = /datum/anvil_recipe/tools/iron
///////////////////////////////////////////////

/datum/anvil_recipe/tools/iron/syringe
	name = "Infusion Syringe"
	created_item = /obj/item/reagent_containers/syringe

/datum/anvil_recipe/tools/iron/keyring
	name = "Keyrings"
	created_item = /obj/item/storage/keyring
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/locks
	name = "Custom Locks"
	appro_skill = /datum/attribute/skill/craft/locksmithing // To train engineering
	created_item = /obj/item/customlock
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/lockpicks
	name = "Lockpicks"
	created_item = /obj/item/lockpick
	output_amount = 5
	craftdiff = 1

/datum/anvil_recipe/tools/iron/lockpickring
	name = "Lockpick Rings"
	created_item = /obj/item/lockpickring
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/blankeys
	name = "Blank Custom Keys"
	appro_skill = /datum/attribute/skill/craft/engineering // To train engineering
	created_item = /obj/item/key/custom
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/chains
	name = "Chains"
	created_item = /obj/item/rope/chain
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/lamptern
	name = "Iron Lamptern"
	created_item = /obj/item/flashlight/flare/torch/lantern

/datum/anvil_recipe/tools/iron/cogiron
	name = "Iron Cog"
	appro_skill = /datum/attribute/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/iron
	craftdiff = 1
	output_amount = 2

/datum/anvil_recipe/tools/iron/hammer
	name = "Hammer (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hammer/iron

/datum/anvil_recipe/tools/iron/hoe
	name = "Hoe (+Stick x2)"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/hoe

/datum/anvil_recipe/tools/iron/mantrap
	name = "Mantrap"
	created_item = /obj/item/restraints/legcuffs/beartrap/crafted

/datum/anvil_recipe/tools/iron/fishinghooks
	name = "Fishing hooks"
	created_item = /obj/item/fishing/hook/iron
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/pick
	name = "Pick (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick

/datum/anvil_recipe/tools/iron/pitchfork
	name = "Pitchfork (+Stick x2)"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pitchfork

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "Sewing Needles"
	created_item = /obj/item/needle
	output_amount = 3 // They can be refilled with fiber now

/datum/anvil_recipe/tools/iron/shovel
	name = "Shovel (+Stick x2)"
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/shovel

/datum/anvil_recipe/tools/iron/sickle
	name = "Sickle (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sickle

/datum/anvil_recipe/tools/iron/tongs
	name = "Tongs"
	created_item = /obj/item/weapon/tongs

/datum/anvil_recipe/tools/iron/torch
	name = "Iron Torches (+Coal)"
	additional_items = list(/obj/item/ore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	output_amount = 5
	craftdiff = 0

/datum/anvil_recipe/tools/iron/pote
	name = "Cooking pot (iron)"
	created_item = /obj/item/reagent_containers/glass/bucket/pot
	craftdiff = 1

/datum/anvil_recipe/tools/iron/headhook
	name = "Iron Headhook (+Fibers x2)"
	additional_items = list(/obj/item/natural/fibers = 2)
	created_item = /obj/item/storage/hip/headhook
	craftdiff = 3

/datum/anvil_recipe/tools/iron/chisel
	name = "Iron Chisel"
	created_item = /obj/item/weapon/chisel/iron

/datum/anvil_recipe/tools/iron/spoon
	name = "Spoons (iron)"
	created_item = /obj/item/kitchen/spoon/iron
	output_amount = 2

/datum/anvil_recipe/tools/iron/fork
	name = "Forks (iron)"
	created_item = /obj/item/kitchen/fork/iron
	output_amount = 2

/datum/anvil_recipe/tools/iron/cups
	name = "Metal Cups"
	created_item = /obj/item/reagent_containers/glass/cup
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/dice_cups
	name = "Metal Dice Cups"
	created_item = /obj/item/dice_cup
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/tools/iron/scissors
	name = "Scissors"
	created_item = /obj/item/weapon/knife/scissors

/datum/anvil_recipe/tools/iron/frypan
	name = "Pan"
	created_item = /obj/item/cooking/pan
	craftdiff = 0

/datum/anvil_recipe/tools/iron/surgerytools
	name = "Set of Surgery Tools (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/surgeontoolspawner

/datum/anvil_recipe/tools/iron/gravefence_iron
	name = "Iron Gravefence"
	created_item = /obj/item/gravedecor/gravefence/iron
	category = "Gravefences"

/datum/anvil_recipe/tools/iron/bowl
	name = "Bowl (iron)"
	created_item = /obj/item/reagent_containers/glass/bowl/iron
	output_amount = 2

// --------- STEEL -----------

/datum/anvil_recipe/tools/steel
	craftdiff = 2
	required_material = /obj/item/ingot/steel
	abstract_type = /datum/anvil_recipe/tools/steel
///////////////////////////////////////////////

/datum/anvil_recipe/tools/steel/cogstee
	name = "Steel Cogs"
	appro_skill = /datum/attribute/skill/craft/engineering // To train engineering
	created_item = /obj/item/gear/metal/steel
	craftdiff = 1
	output_amount = 3

/datum/anvil_recipe/tools/steel/scissors
	name = "Steel Scissors"
	created_item = /obj/item/weapon/knife/scissors/steel

/datum/anvil_recipe/tools/steel/pick
	name = "Steel Pick (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/steel

/datum/anvil_recipe/tools/steel/gobletsteel
	name = "Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/steel
	output_amount = 3
	craftdiff = 1

/datum/anvil_recipe/tools/steel/chisel
	name = "Steel Chisel"
	created_item = /obj/item/weapon/chisel
	craftdiff = 1

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver
	craftdiff = 3
	required_material = /obj/item/ingot/silver
	abstract_type = /datum/anvil_recipe/tools/silver
///////////////////////////////////////////////

/datum/anvil_recipe/tools/silver/gobletsilver
	name = "Silver Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/silver
	output_amount = 3
	craftdiff = 2

/datum/anvil_recipe/tools/silver/carafesilver
	name = "Silver Carafe"
	created_item = /obj/item/reagent_containers/glass/carafe/silver

/datum/anvil_recipe/tools/silver/platter
	name = "Platters (silver)"
	created_item = /obj/item/plate/silver
	craftdiff = 2

/datum/anvil_recipe/tools/silver/servantbell
	name = "x3 Service Bells"
	created_item = /obj/item/servant_bell
	output_amount = 3
	craftdiff = 3


// --------- GOLD -----------

/datum/anvil_recipe/tools/gold
	craftdiff = 3
	required_material = /obj/item/ingot/gold
	abstract_type = /datum/anvil_recipe/tools/gold
///////////////////////////////////////////////

/datum/anvil_recipe/tools/gold/gobletgold
	name = "Golden Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/golden
	output_amount = 3
	craftdiff = 2

/datum/anvil_recipe/tools/gold/carafegold
	name = "Golden Carafe"
	created_item = /obj/item/reagent_containers/glass/carafe/gold

/datum/anvil_recipe/tools/gold/platter
	name = "Platters (gold)"
	created_item = /obj/item/plate/gold
	craftdiff = 2

/datum/anvil_recipe/tools/gold/headstone_astrata
	name = "Golden Astratan Headstone"
	created_item = /obj/item/gravedecor/headstone/astrata
	category = "Headstones"

// --------- CASTING TOOLS -----------
/datum/anvil_recipe/tools/casting
	category = "Casting"
	craftdiff = SKILL_RANK_JOURNEYMAN
	abstract_type = /datum/anvil_recipe/tools/casting

/datum/anvil_recipe/tools/casting/handle_output(obj/item/output_item, datum/quality_calculator/blacksmithing/quality_calculator)
	var/obj/item/ingot_material = required_material
	output_item.main_material = initial(ingot_material.melting_material)
	output_item.set_material_information()

/datum/anvil_recipe/tools/casting/crucible
	name = "Crucible"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/storage/crucible

/datum/anvil_recipe/tools/casting/ingot_mould
	name = "Ingot mould (steel)"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/mould/ingot

/datum/anvil_recipe/tools/casting/ingot_mould/iron
	name = "Ingot mould (iron)"
	required_material = /obj/item/ingot/iron

/datum/anvil_recipe/tools/casting/generic_mould
	name = "Customizable mould"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/mould/customizable
