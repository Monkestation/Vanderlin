/datum/artificer_recipe
	appro_skill = /datum/skill/craft/engineering

// --------- GENERAL -----------

/datum/artificer_recipe/general
	i_type = "General"
	category = "General"

/datum/artificer_recipe/general/bronze_cast
	name = "Bronze Casting"
	required_item = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/tin = 1)
	created_item = /obj/item/ingot/bronze
	hammers_per_item = 3
	created_amount = 2
	craftdiff = 0

/datum/artificer_recipe/general/woodcog //This looks a bit silly but due to how these datums work is necessary for other things to inherit from it
	name = "Wooden Gear"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/gear/wood/basic
	hammers_per_item = 5
	craftdiff = 1

/datum/artificer_recipe/general/woodcogupgrade2
	name = "Reliable Wooden Gear (+1 Essence of Lumber)"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/gear/wood/reliable
	additional_items = list(/obj/item/grown/log/tree/essence = 1)
	hammers_per_item = 5
	craftdiff = 2

/datum/artificer_recipe/general/unstable
	name = "Unstable Wooden Gear (+1 Essence of Wilderness)"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/gear/wood/unstable
	additional_items = list(/obj/item/natural/cured/essence = 1)
	hammers_per_item = 10
	craftdiff = 3

/datum/artificer_recipe/general/cog
	name = "3x Bronze Gears"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/gear/metal/bronze
	hammers_per_item = 10
	craftdiff = 1
	created_amount = 3

/datum/artificer_recipe/general/cog/iron
	name = "2x Iron Gear"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/gear/metal/iron
	created_amount = 2

/datum/artificer_recipe/general/cog/steel
	name = "3x Steel Gears"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/gear/metal/steel

/datum/artificer_recipe/general/locks
	name = "5x Custom Locks"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/customlock
	hammers_per_item = 5
	craftdiff = 1
	created_amount = 5

/datum/artificer_recipe/general/keys
	name = "5x Blank Custom Keys"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/key/custom
	hammers_per_item = 5
	craftdiff = 1
	created_amount = 5

/datum/artificer_recipe/general/bronze_chisel
	name = "Bronze Chisel"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/weapon/chisel/bronze
	hammers_per_item = 5
	craftdiff = 1

/datum/artificer_recipe/general/headhook
	name = "Bronze Headhook (+2 Fibers)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/headhook/bronze
	additional_items = list(/obj/item/natural/fibers = 2)
	hammers_per_item = 6
	craftdiff = 3

/datum/artificer_recipe/gold/headhook
	name = "Royal Headhook (+2 Silk)"
	required_item = /obj/item/ingot/gold
	created_item = /obj/item/storage/hip/headhook/royal
	additional_items = list(/obj/item/natural/silk = 2)
	hammers_per_item = 6
	craftdiff = 3

// --------- TOOLS -----------

/datum/artificer_recipe/tools
	i_type = "Tools"
	category = "Tools"

/datum/artificer_recipe/tools/lamptern
	name = "Bronze Lamptern"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	hammers_per_item = 9
	craftdiff = 3

/datum/artificer_recipe/tools/lockpicks
	name = "3x Lockpicks"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/lockpick
	hammers_per_item = 5
	created_amount = 3
	craftdiff = 2

/datum/artificer_recipe/tools/lockpickring
	name = "Lockpick ring"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/lockpickring
	hammers_per_item = 5
	craftdiff = 2

/datum/artificer_recipe/tools/drill
	name = "Clockwork Drill (+1 Bronze) (+1 Metal Gear) (+1 Wooden Plank)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze = 1, /obj/item/gear/metal = 1, /obj/item/natural/wood/plank = 1)
	created_item = /obj/item/weapon/pick/drill
	hammers_per_item = 6
	craftdiff = 4

// --------- WEAPON -----------

/datum/artificer_recipe/weapons
	i_type = "Weapons"
	category = "Weapons"

/datum/artificer_recipe/weapons/crossbow
	name = "Crossbow (+1 Steel) (+2 Fibers)"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/natural/fibers = 2)
	hammers_per_item = 7
	craftdiff = 4

/datum/artificer_recipe/weapons/harpoon_gun
	name = "Harpoon Gun (+1 Chain) (+2 Metal Gear) (+2 Bronze)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/harpoon_gun
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/gear/metal = 2, /obj/item/ingot/bronze = 2)
	hammers_per_item = 7
	craftdiff = 4

/datum/artificer_recipe/weapons/airgun
	name = "Airgun (+2 Cured Leather) (+3 Bronze) (+4 Metal Gear)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/airgun
	additional_items = list(/obj/item/natural/hide/cured = 2, /obj/item/ingot/bronze = 3, /obj/item/gear/metal = 4)
	hammers_per_item = 10
	craftdiff = 5

// --------- ARMOR -----------

//should be armour not armor fight me, but most of the codebase uses american english so its armor
/datum/artificer_recipe/armor
	i_type = "Armor"
	category = "Armor"

/datum/artificer_recipe/armor/steam_knight_helm
	name = "Steamknight Helmet (+3 Bronze) (+3 Metal Gear) (+1 Cloth)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/steam
	additional_items = list(/obj/item/ingot/bronze = 3, /obj/item/gear/metal = 3, /obj/item/natural/cloth = 1)
	hammers_per_item = 4
	craftdiff = 5

/datum/artificer_recipe/armor/steam_knight_plate
	name = "Steamknight Plate (+5 Bronze) (+3 Metal Gear) (+2 Cloth)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/clothing/armor/steam
	additional_items = list(/obj/item/ingot/bronze = 5, /obj/item/gear/metal = 3, /obj/item/natural/cloth = 2)
	hammers_per_item = 6
	craftdiff = 5

/datum/artificer_recipe/armor/steam_knight_gloves
	name = "Steamknight Gloves (+2 Bronze) (+2 Metal Gear) (+1 Cloth)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/plate/steam
	additional_items = list(/obj/item/ingot/bronze = 3, /obj/item/gear/metal = 2, /obj/item/natural/cloth = 1)
	hammers_per_item = 4
	craftdiff = 5

/datum/artificer_recipe/armor/steam_knight_boots
	name = "Steamknight Boots (+2 Bronze) (+2 Metal Gear) (+1 Cloth)"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/clothing/shoes/boots/armor/steam
	additional_items = list(/obj/item/ingot/bronze = 3, /obj/item/gear/metal = 2, /obj/item/natural/cloth = 1)
	hammers_per_item = 4
	craftdiff = 5

/datum/artificer_recipe/armor/boiler
	name = "Steamknight Boiler (+1 Backpack) (+1 Bronze) (+3 Cogs)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/cloak/boiler
	additional_items = list(/obj/item/gear/metal/bronze = 3, /obj/item/ingot/bronze = 1, /obj/item/storage/backpack/backpack = 1)
	hammers_per_item = 5
	craftdiff = 5

// --------- Contraptions -----------

/datum/artificer_recipe/contraptions
	i_type = "Contraptions"
	category = "Contraptions"

/datum/artificer_recipe/contraptions/smelter
	name = "Portable Smelter (+1 Coal)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ore/coal = 1)
	created_item = /obj/item/contraption/smelter
	hammers_per_item = 10
	craftdiff = 3

/datum/artificer_recipe/contraptions/advanced_ingot_mold
	name = "Advanced Ingot Mold (+1 Ingot Mold) (+1 Metal Gear) (+1 Bucket)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/mould/ingot = 1, /obj/item/gear/metal = 1, /obj/item/reagent_containers/glass/bucket/wooden = 1)
	created_item = /obj/item/mould/ingot/advanced
	hammers_per_item = 6
	craftdiff = 3

/datum/artificer_recipe/contraptions/shears
	name = "Amputation Shears (+2 Bronze)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze = 2)
	created_item = /obj/item/contraption/shears
	hammers_per_item = 7
	craftdiff = 4

/datum/artificer_recipe/contraptions/linker
	name = "Engineering Wrench (+1 Gold)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/contraption/linker
	hammers_per_item = 10
	craftdiff = 3

/datum/artificer_recipe/contraptions/waterpurifier
	name = "Self-Purifying Waterskin (+1 Waterskin)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
	additional_items = list(/obj/item/reagent_containers/glass/bottle/waterskin)
	hammers_per_item = 8
	craftdiff = 3

/datum/artificer_recipe/contraptions/coolingbackpack
	name = "Cooling Backpack (+1 Backpack) (+2 Cogs)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/backpack/backpack/artibackpack
	additional_items = list(/obj/item/gear/metal = 2, /obj/item/storage/backpack/backpack)
	hammers_per_item = 4
	craftdiff = 5

/datum/artificer_recipe/contraptions/dwarven_music_box
	name = "Dwarven Music Box (+2 Bronze) (+2 Cogs) (+1 Amethyst)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/dmusicbox
	additional_items = list(/obj/item/gear/metal = 2, /obj/item/ingot/bronze = 2, /obj/item/gem/amethyst = 1)
	hammers_per_item = 10
	craftdiff = 6

/datum/artificer_recipe/contraptions/deathshell
	name = "2x Steam Grenades"
	hammers_per_item = 2
	created_item = /obj/item/explosive/deathshell
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/gear/metal = 2)
	craftdiff = 4
	created_amount = 2

// --------- Ammo -----------

/datum/artificer_recipe/ammo
	i_type = "Ammo"
	category = "Ammo"

/datum/artificer_recipe/ammo/cannon_ball
	name = "Lead Cannonball (+3 Iron)"
	created_item = /obj/item/ammo_casing/caseless/cball
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	hammers_per_item = 6
	craftdiff = 5

/datum/artificer_recipe/ammo/lead_bullet
	name = "Lead Bullets 4x"
	hammers_per_item = 4
	created_item = /obj/item/ammo_casing/caseless/bullet
	required_item = /obj/item/ingot/tin
	craftdiff = 2
	created_amount = 4

/datum/artificer_recipe/ammo/bolts
	name = "Crossbow Bolts 5x (+1 Iron)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/ammo_casing/caseless/bolt
	hammers_per_item = 6
	craftdiff = 2
	created_amount = 5

/datum/artificer_recipe/ammo/arrows
	name = "Arrows 5x (+1 Iron)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/ammo_casing/caseless/arrow
	hammers_per_item = 6
	craftdiff = 2
	created_amount = 5

/datum/artificer_recipe/ammo/arrows/pyro
	name = "Fire Arrows 5x (+1 Iron) (+1 Blast Powder)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/powder/blastpowder)
	created_item = /obj/item/ammo_casing/caseless/arrow/pyro
	hammers_per_item = 6
	craftdiff = 3
	created_amount = 5

/datum/artificer_recipe/ammo/bolts/pyro
	name = "Fire Bolts 5x (+1 Iron) (+1 Blast Powder)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/powder/blastpowder)
	created_item = /obj/item/ammo_casing/caseless/bolt/pyro
	hammers_per_item = 6
	craftdiff = 3
	created_amount = 5

/datum/artificer_recipe/ammo/arrows/water
	name = "Water Arrows 5x (+1 Iron) (+1 Waterdust)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/alch/waterdust)
	created_item = /obj/item/ammo_casing/caseless/arrow/water
	hammers_per_item = 6
	craftdiff = 3
	created_amount = 5

/datum/artificer_recipe/ammo/bolts/water
	name = "Water Bolts 5x (+1 Iron) (+1 Waterdust)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/alch/waterdust)
	created_item = /obj/item/ammo_casing/caseless/bolt/water
	hammers_per_item = 6
	craftdiff = 3
	created_amount = 5

//If anyone wants to add vial arrows/bolts, please make sure the reagents in the vial end up on the arrow/bolt

// --------- WOODEN PROSTHETICS -----------

/datum/artificer_recipe/prosthetics
	i_type = "Prosthetics"
	category = "Prosthetics"

/datum/artificer_recipe/prosthetics/wood
	name = "Left Wooden Arm (+1 Plank)"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/bodypart/l_arm/prosthetic/wood
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 4
	craftdiff = 2

/datum/artificer_recipe/prosthetics/wood/arm_right
	name = "Right Wooden Arm (+1 Plank)"
	created_item = /obj/item/bodypart/r_arm/prosthetic/wood

/datum/artificer_recipe/prosthetics/wood/leg_left
	name = "Left Wooden Leg (+1 Plank)"
	created_item = /obj/item/bodypart/l_leg/prosthetic/wood

/datum/artificer_recipe/prosthetics/wood/leg_right
	name = "Right Wooden Leg (+1 Plank)"
	created_item = /obj/item/bodypart/r_leg/prosthetic/wood

// --------- BRONZE PROSTHETICS -----------

/datum/artificer_recipe/prosthetics/bronze
	name = "Bronze Left Arm (+2 Cogs)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/bodypart/l_arm/prosthetic/bronze
	hammers_per_item = 10
	craftdiff = 4
	additional_items = list(/obj/item/gear/metal = 2)

/datum/artificer_recipe/prosthetics/bronze/arm_right
	name = "Bronze Right Arm (+2 Cogs)"
	created_item = /obj/item/bodypart/r_arm/prosthetic/bronze

// --------- GOLD PROSTHETICS -----------

/datum/artificer_recipe/prosthetics/gold // Guh this need a gold subtype oh well maybe some day there will be a golden cock! COG I MEAN GOD OMG
	name = "Gold Left Arm (+1 Cog)"
	required_item = /obj/item/ingot/gold
	created_item = /obj/item/bodypart/l_arm/prosthetic/gold
	additional_items = list(/obj/item/gear/metal = 1)
	hammers_per_item = 20
	craftdiff = 5

/datum/artificer_recipe/prosthetics/gold/arm_right
	name = "Gold Right Arm (+1 Cog)"
	created_item = /obj/item/bodypart/r_arm/prosthetic/gold

/datum/artificer_recipe/prosthetics/gold/leg_left
	name = "Gold Left Leg (+1 Cog)"
	created_item = /obj/item/bodypart/l_leg/prosthetic/gold

/datum/artificer_recipe/prosthetics/gold/leg_right
	name = "Gold Right Leg (+1 Cog)"
	created_item = /obj/item/bodypart/r_leg/prosthetic/gold

// --------- STEEL PROSTHETICS -----------

/datum/artificer_recipe/prosthetics/steel
	name = "Steel Left Arm (+1 Steel) (+1 Cog)"
	created_item = /obj/item/bodypart/l_arm/prosthetic/steel
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/gear/metal = 1)
	hammers_per_item = 15
	craftdiff = 4

/datum/artificer_recipe/prosthetics/steel/arm_right
	name = "Steel Right Arm (+1 Steel) (+1 Cog)"
	created_item = /obj/item/bodypart/r_arm/prosthetic/steel

/datum/artificer_recipe/prosthetics/steel/leg_left
	name = "Steel Left Leg (+1 Steel) (+1 Cog)"
	created_item = /obj/item/bodypart/l_leg/prosthetic/steel

/datum/artificer_recipe/prosthetics/steel/leg_right
	name = "Steel Right Leg (+1 Steel) (+1 Cog)"
	created_item = /obj/item/bodypart/r_leg/prosthetic/steel

// --------- IRON PROSTHETICS -----------

/datum/artificer_recipe/prosthetics/iron //These are the inexpensive alternatives
	name = "Iron Left Arm (+1 Cog)"
	created_item = /obj/item/bodypart/l_arm/prosthetic/iron
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/gear/metal = 1)
	hammers_per_item = 4
	craftdiff = 2

/datum/artificer_recipe/prosthetics/iron/arm_right
	name = "Iron Right Arm (+1 Cog)"
	created_item = /obj/item/bodypart/r_arm/prosthetic/iron

/datum/artificer_recipe/prosthetics/iron/leg_left
	name = "Iron Left Leg (+1 Cog)"
	created_item = /obj/item/bodypart/l_leg/prosthetic/iron

/datum/artificer_recipe/prosthetics/iron/leg_right
	name = "Iron Right Leg (+1 Cog)"
	created_item = /obj/item/bodypart/r_leg/prosthetic/iron

// --------- Psycross -----------

/datum/artificer_recipe/psycross
	i_type = "Psycross"
	category = "Psycross"
	hammers_per_item = 5
	craftdiff = 2

/datum/artificer_recipe/psycross/silver
	name = "silver Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver

/datum/artificer_recipe/psycross/gold
	name = "golden Psycross"
	required_item = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/psycross/g
	hammers_per_item = 7
	craftdiff = 3

/datum/artificer_recipe/psycross/noc
	name = "Noc Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/noc

/datum/artificer_recipe/psycross/astrata
	name = "Astrata Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/astrata

/datum/artificer_recipe/psycross/dendor
	name = "Dendor Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/dendor

/datum/artificer_recipe/psycross/abyssor
	name = "Abyssor Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/abyssor

/datum/artificer_recipe/psycross/necra
	name = "Necra Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/necra

/datum/artificer_recipe/psycross/ravox
	name = "Ravox Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/ravox

/datum/artificer_recipe/psycross/xylix
	name = "Xylix Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/xylix

/datum/artificer_recipe/psycross/eora
	name = "Eora Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/eora

/datum/artificer_recipe/psycross/pestra
	name = "Pestra Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/pestra

/datum/artificer_recipe/psycross/malum_silver
	name = "Malum Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/malum

/datum/artificer_recipe/psycross/malum_steel
	name = "Malum Steel Psycross"
	required_item = /obj/item/ingot/silver
	created_item = /obj/item/clothing/neck/psycross/silver/malum/steel
	additional_items = list(/obj/item/ingot/steel = 1)
	craftdiff = 3

// --------- Misc -----------

/datum/artificer_recipe/misc
	i_type = "Misc"
	category = "Misc"

/datum/artificer_recipe/misc/jinglebells
	name = "Jingle Bells"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/jingle_bells
	hammers_per_item = 5
	craftdiff = 2
