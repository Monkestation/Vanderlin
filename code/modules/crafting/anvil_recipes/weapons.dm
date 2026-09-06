/datum/anvil_recipe/weapons
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	abstract_type = /datum/anvil_recipe/weapons
	category = "Weapons"


////////////////////////////////////
// --------- TIN -----------
//honestly the only tin "weapon" that comes to mind would be lead bullets
/datum/anvil_recipe/weapons/tin
	abstract_type = /datum/anvil_recipe/weapons/tin
	required_material = /obj/item/ingot/tin
	craftdiff = 0
////////////////////////////////////

/datum/anvil_recipe/weapons/tin/lead_bullet //guys how are you making LEAD bullets out of TIN?
	name = "Lead Bullets"
	created_item = /obj/item/ammo_casing/caseless/bullet
	craftdiff = 1
	output_amount = 4

/datum/anvil_recipe/weapons/tin/grenade_shell
	name = "Grenade shells"
	created_item = /obj/item/ammo_casing/caseless/grenadeshell
	craftdiff = 3
	output_amount = 2
	///jokes on you whoever said lead bullets were the only tin weapon, may I introduce the pipe casing.
//////////////////////////////////////////////////////////////////////////////////////////////
// --------- COPPER -----------
/datum/anvil_recipe/weapons/copper
	abstract_type = /datum/anvil_recipe/weapons/copper
	required_material = /obj/item/ingot/copper
	craftdiff = 0
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/copper/caxe
	name = "Copper Hatchet"
	additional_items = list(/obj/item/ingot/copper = 1)
	created_item = /obj/item/weapon/axe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Copper Bludgeon"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/bludgeon/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Copper Daggers"
	created_item = /obj/item/weapon/knife/copper
	output_amount = 2

//datum/anvil_recipe/weapons/copper/cmace
//	name = "Mace"
//	recipe_name = "a Mace"
//	appro_skill = /datum/attribute/skill/craft/weaponsmithing
//	required_material = /obj/item/ingot/copper
//	additional_items = list(/obj/item/ingot/copper)
//	created_item = (/obj/item/weapon/mace/coppermace)
//	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Copper Messer"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/sword/coppermesser

/datum/anvil_recipe/weapons/copper/cspears
	name = "Copper Javelins"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/javelin
	output_amount = 2

/datum/anvil_recipe/weapons/copper/cfalx
	name = "Copper Falx"
	additional_items = list(/obj/item/ingot/copper = 1)
	created_item = /obj/item/weapon/sword/long/rider/copper

// --------- BRONZE -----------
/datum/anvil_recipe/weapons/bronze
	abstract_type = /datum/anvil_recipe/weapons/bronze
	required_material = /obj/item/ingot/bronze
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius"
	created_item = /obj/item/weapon/sword/gladius

/datum/anvil_recipe/weapons/bronze/spear
	name = "Bronze Spear"
	additional_items = list(/obj/item/ingot/bronze = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/bronze

/datum/anvil_recipe/weapons/bronze/cane
	name = "Artificer Cane"
	additional_items = list(/obj/item/ingot/copper = 1)
	created_item = /obj/item/weapon/mace/cane/bronze

/datum/anvil_recipe/weapons/bronze/shortsword
	name = "Bronze Shortsword"
	created_item = /obj/item/weapon/sword/short/bronze

/datum/anvil_recipe/weapons/bronze/sword
	name = "Bronze Sword"
	created_item = /obj/item/weapon/sword/bronze

/datum/anvil_recipe/weapons/bronze/sengese
	name = "Bronze Sengese"
	created_item = /obj/item/weapon/sword/scimitar/sengese/bronze

/datum/anvil_recipe/weapons/bronze/dadao
	name = "Bronze Dadao"
	additional_items = list(/obj/item/ingot/bronze = 1)
	created_item = /obj/item/weapon/sword/sabre/dadao/bronze

/datum/anvil_recipe/weapons/bronze/shishpar
	name = "Bronze Shishpar"
	additional_items = list(/obj/item/ingot/bronze = 1)
	created_item = /obj/item/weapon/mace/bronze/shishpar

/datum/anvil_recipe/weapons/bronze/urumi
	name = "Bronze Urumi"
	additional_items = list(/obj/item/ingot/bronze = 1)
	created_item = /obj/item/weapon/whip/urumi/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "Bronze Mace"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "Bronze Axe"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/bronze

/datum/anvil_recipe/weapons/bronze/elvenclub
	name = "Bronze Elven Warclub"
	created_item = /obj/item/weapon/mace/elvenclub/bronze

/datum/anvil_recipe/weapons/bronze/dagger
	name = "Bronze Daggers"
	created_item = /obj/item/weapon/knife/dagger/bronze
	output_amount = 2

/datum/anvil_recipe/weapons/bronze/throwingdagger
	name = "Bronze Throwing Daggers"
	created_item = /obj/item/weapon/knife/throwingknife/bronze
	output_amount = 3

/datum/anvil_recipe/weapons/bronze/ji
	name = "Bronze Dagger-Ax"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/bronze

/datum/anvil_recipe/weapons/bronze/bronze_whip
	name = "Bronze Whip"
	additional_items = list(/obj/item/natural/hide/cured,/obj/item/natural/hide/cured)
	created_item = /obj/item/weapon/whip/bronze

/datum/anvil_recipe/weapons/bronze/knuckles
	name = "Bronze Knuckles"
	created_item = /obj/item/weapon/knuckles/bronze

// --------- IRON ------------ Middle Tier, what most disgusting Men at Arms have
/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	required_material = /obj/item/ingot/iron
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/iron/arrows
	name = "Arrows"
	appro_skill = /datum/attribute/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank = 1)
	created_item = /obj/item/ammo_casing/caseless/arrow
	output_amount = 5
	category = "Ammo"
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts"
	appro_skill = /datum/attribute/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank = 1)
	created_item = /obj/item/ammo_casing/caseless/bolt
	output_amount = 5
	category = "Ammo"

/datum/anvil_recipe/weapons/iron/javelin
	name = "Iron Javelins"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/javelin/iron
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/iron/quarterstaff
	name = "Iron Quarertstaff"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron

/datum/anvil_recipe/weapons/iron/axe_iron
	name = "Iron Axe"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/iron

/datum/anvil_recipe/weapons/iron/nsapo
	name = "Iron Kasuyu"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/iron/nsapo

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche"
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bardiche
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/assegai
	name = "Iron Assegai"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/assegai

/datum/anvil_recipe/weapons/iron/woodcutter
	name = "Woodcutter Axe"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/woodcutter

/datum/anvil_recipe/weapons/iron/warcutter
	name = "Footman War Axe"
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/warcutter
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe"
	additional_items = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1)
	created_item = /obj/item/weapon/greataxe
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "Dagger"
	created_item = /obj/item/weapon/knife/dagger
	output_amount = 2
	craftdiff = 0 // To train with

/datum/anvil_recipe/weapons/iron/njora
	name = "Iron Seme's"
	created_item = /obj/item/weapon/knife/dagger/njora
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/kukri
	name = "Iron Kukri"
	created_item = /obj/item/weapon/knife/hunting/kukri/iron

/datum/anvil_recipe/weapons/iron/aruval
	name = "Iron Aruval"
	additional_items = list(/obj/item/ingot/iron = 2)
	created_item = /obj/item/weapon/sword/long/aruval/iron

/datum/anvil_recipe/weapons/iron/dadao
	name = "Iron Dadao"
	additional_items = list(/obj/item/ingot/iron = 1)
	created_item = /obj/item/weapon/sword/sabre/dadao/iron

/datum/anvil_recipe/weapons/iron/ji
	name = "Iron Dagger-Ax"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/iron

/datum/anvil_recipe/weapons/iron/wodao
	name = "Iron Wo Dao"
	created_item = /obj/item/weapon/sword/scimitar/wodao/iron

/datum/anvil_recipe/weapons/iron/urumi
	name = "Iron Urumi"
	additional_items = list(/obj/item/ingot/iron = 1)
	created_item = /obj/item/weapon/whip/urumi/iron

/datum/anvil_recipe/weapons/iron/lakkarikhopesh
	name = "Iron Khopesh"
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh/iron

/datum/anvil_recipe/weapons/iron/sengese
	name = "Iron Sengese"
	created_item = /obj/item/weapon/sword/scimitar/sengese/iron

/datum/anvil_recipe/weapons/iron/jile
	name = "Iron Jile Daggers"
	created_item = /obj/item/weapon/knife/dagger/jile
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "Villager Knives"
	created_item = /obj/item/weapon/knife/villager
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/cleaver
	name = "Cleaver"
	created_item = /obj/item/weapon/knife/cleaver

/datum/anvil_recipe/weapons/iron/flail_iron
	name = "Militia flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/flail/militia

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne"
	additional_items = list(/obj/item/ingot/iron = 1,/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/eaglebeak/lucerne
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/sledgehammer
	name = "Sledgehammer"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = 	/obj/item/weapon/hammer/sledgehammer

/datum/anvil_recipe/weapons/iron/mace_iron
	name = "Iron Mace"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace

/datum/anvil_recipe/weapons/iron/rungu
	name = "Iron Rungu"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/rungu

/datum/anvil_recipe/weapons/iron/ibludgeon
	name = "Iron Bludgeon"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/bludgeon

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Iron Warhammer"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/warhammer

/datum/anvil_recipe/weapons/iron/messer_iron
	name = "Messer"
	created_item = /obj/item/weapon/sword/scimitar/messer

/datum/anvil_recipe/weapons/iron/spear_iron
	name = "Spears"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear
	output_amount = 2

/datum/anvil_recipe/weapons/iron/shortsword_iron
	name = "Short Sword"
	created_item = /obj/item/weapon/sword/short/iron
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/ida
	name = "Ida"
	created_item = /obj/item/weapon/sword/short/iron/ida

/datum/anvil_recipe/weapons/iron/shotel
	name = "Shotel"
	additional_items = list(/obj/item/ingot/iron = 1)
	created_item = /obj/item/weapon/sword/long/shotel/iron

/datum/anvil_recipe/weapons/iron/shishpar
	name = "Iron Shishpar"
	additional_items = list(/obj/item/ingot/iron = 1)
	created_item = /obj/item/weapon/mace/shishpar

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Sword"
	created_item = /obj/item/weapon/sword/iron

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Estoc"
	created_item = /obj/item/weapon/sword/rapier/ironestoc

/datum/anvil_recipe/weapons/iron/kaskara
	name = "Iron Kaskara"
	created_item = /obj/item/weapon/sword/kaskara/iron

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/shield/tower
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/ironbuckler
	name = "Iron Buckler"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	created_item = /obj/item/weapon/shield/tower/buckleriron

/datum/anvil_recipe/weapons/iron/warclub
	name = "Warclub"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/mace/goden
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/zweihander
	name = "Zweihander"
	additional_items = list(/obj/item/ingot/iron = 2)
	created_item = /obj/item/weapon/sword/long/greatsword/zwei
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/claymore
	name = "Iron Claymore"
	additional_items = list(/obj/item/ingot/iron = 2)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore/iron
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/elvenclub
	name = "Elven Warclub"
	created_item = /obj/item/weapon/mace/elvenclub
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/knuckles
	name = "Iron Knuckles"
	created_item = /obj/item/weapon/knuckles/iron

// --------- STEEL ------------  Fancy gear for Knights
/datum/anvil_recipe/weapons/steel
	abstract_type = /datum/anvil_recipe/weapons/steel
	required_material = /obj/item/ingot/steel
	craftdiff = 2

///////////////////////////////////////////////

/datum/anvil_recipe/weapons/steel/short_sword
	name = "Steel Short Sword"
	created_item = /obj/item/weapon/sword/short

/datum/anvil_recipe/weapons/steel/assegai
	name = "Steel Assegai"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/assegai/steel

/datum/anvil_recipe/weapons/steel/javelin
	name = "Steel Javelins"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/javelin/steel
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/steel/quarterstaff
	name = "Steel Quarterstaff"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel

/datum/anvil_recipe/weapons/steel/spear
	name = "Steel Spears"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/steel
	output_amount = 2

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/steel/partizan

/datum/anvil_recipe/weapons/steel/aruval
	name = "Steel Aruval"
	additional_items = list(/obj/item/ingot/steel = 2)
	created_item = /obj/item/weapon/sword/long/aruval

/datum/anvil_recipe/weapons/steel/dadao
	name = "Steel Dadao"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/sword/sabre/dadao

/datum/anvil_recipe/weapons/steel/ji
	name = "Steel Dagger-Ax"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/billhook/ji

/datum/anvil_recipe/weapons/steel/wodao
	name = "Steel Wo Dao"
	created_item = /obj/item/weapon/sword/scimitar/wodao

/datum/anvil_recipe/weapons/steel/whip
	name = "Steel Whip"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/weapon/whip/steel

/datum/anvil_recipe/weapons/steel/urumi
	name = "Steel Urumi"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/whip/urumi

/datum/anvil_recipe/weapons/steel/lakkarikhopesh
	name = "Steel Khopesh"
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh

/datum/anvil_recipe/weapons/steel/sengese
	name = "Steel Sengese"
	created_item = /obj/item/weapon/sword/scimitar/sengese

/datum/anvil_recipe/weapons/steel/axe_steel
	name = "Steel Axe"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/steel

/datum/anvil_recipe/weapons/steel/felling_axe
	name = "Felling Axe"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/woodcutter/steel

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe"
	additional_items = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/greataxe/steel
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/doubleheaded_greataxe
	name = "Double-headed Greataxe"
	additional_items = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/steel = 2)
	created_item = /obj/item/weapon/greataxe/steel/doublehead
	craftdiff = 5

/datum/anvil_recipe/weapons/steel/nsapo
	name = "Steel Kasuyu"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/steel/nsapo

/datum/anvil_recipe/weapons/steel/rungu
	name = "Steel Rungu"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/steel/rungu


/datum/anvil_recipe/weapons/steel/sledgehammer
	name = "Steel Sledgehammer"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = 	/obj/item/weapon/hammer/sledgehammer/war

/datum/anvil_recipe/weapons/steel/njora
	name = "Steel Seme's"
	created_item = /obj/item/weapon/knife/dagger/steel/njora
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/jile
	name = "Steel Jile Daggers"
	created_item = /obj/item/weapon/knife/dagger/steel/jile
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/axe/battle
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/double_battleaxe
	name = "Double-headed Battle Axe"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/axe/battle/double
	craftdiff = 5

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/billhook
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/cutlass_steel
	name = "Cutlass"
	created_item = /obj/item/weapon/sword/sabre/cutlass

/datum/anvil_recipe/weapons/steel/shotel
	name = "Steel Shotel"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/sword/long/shotel

/datum/anvil_recipe/weapons/steel/shishpar
	name = "Steel Shishpar"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/mace/steel/shishpar

/datum/anvil_recipe/weapons/steel/ida
	name = "Steel Ida"
	created_item = /obj/item/weapon/sword/short/ida

/datum/anvil_recipe/weapons/steel/kaskara // I FORGOT TO INCLUDE IT
	name = "Steel Kaskara"
	created_item = /obj/item/weapon/sword/kaskara

/datum/anvil_recipe/weapons/steel/kukri
	name = "Steel Kukri"
	created_item = /obj/item/weapon/knife/hunting/kukri

/datum/anvil_recipe/weapons/steel/hackknife
	name = "Hack-Knife"
	created_item = /obj/item/weapon/knife/cleaver/combat

/datum/anvil_recipe/weapons/steel/knuckles
	name = "Steel Knuckles"
	created_item = /obj/item/weapon/knuckles

/datum/anvil_recipe/weapons/steel/dagger_steel
	name = "Steel Daggers"
	created_item = /obj/item/weapon/knife/dagger/steel
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/stiletto
	name = "Steel Stilettos"
	created_item = /obj/item/weapon/knife/dagger/steel/stiletto
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/royal
	name = "Decorated Dagger"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/knife/dagger/steel/royal
	output_amount = 2
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/decsaber
	name = "Decorated Sabre"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/sword/sabre/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decsword
	name = "Decorated Sword"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/sword/decorated
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decrapier
	name = "Decorated Rapier"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/sword/rapier/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/nimcha
	name = "Nimcha"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/sword/rapier/nimcha
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak"
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/eaglebeak
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/flail_steel
	name = "Steel Flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/flail/sflail

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace"
	additional_items = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/mace/goden/steel
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword"
	additional_items = list(/obj/item/ingot/steel = 2)
	created_item = /obj/item/weapon/sword/long/greatsword
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/flamberge
	name = "Flamberge"
	additional_items = list(/obj/item/ingot/steel = 3)
	created_item = /obj/item/weapon/sword/long/greatsword/flamberge
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/zweihander
	name = "Zweihander"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel = 2)
	created_item = /obj/item/weapon/sword/long/greatsword/zwei/steel
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/claymore
	name = "Steel Claymore"
	additional_items = list(/obj/item/ingot/steel = 2)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore
	craftdiff = 4

/datum/anvil_recipe/weapons/silver/noble_sword_scabbard
	name = "Decorated Silver Sword Scabbard"
	additional_items = list(/obj/item/weapon/scabbard/sword = 1)
	created_item = /obj/item/weapon/scabbard/sword/noble

/datum/anvil_recipe/weapons/silver/noble_knife_sheath
	name = "Decorated Silver Knife Sheath"
	additional_items = list(/obj/item/weapon/scabbard/knife = 1)
	created_item = /obj/item/weapon/scabbard/knife/noble

/datum/anvil_recipe/weapons/gold
	abstract_type = /datum/anvil_recipe/weapons/gold
	required_material = /obj/item/ingot/gold
	craftdiff = 5

/datum/anvil_recipe/weapons/gold/noble_sword_scabbard
	name = "Decorated Golden Sword Scabbard"
	additional_items = list(/obj/item/weapon/scabbard/sword = 1)
	created_item = /obj/item/weapon/scabbard/sword/royal

/datum/anvil_recipe/weapons/gold/noble_knife_sheath
	name = "Decorated Golden Knife Sheath"
	additional_items = list(/obj/item/weapon/scabbard/knife = 1)
	created_item = /obj/item/weapon/scabbard/knife/royal

/datum/anvil_recipe/weapons/gold/staff
	name = "Golden Quarterstaff"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/gold

/datum/anvil_recipe/weapons/gold/kiteshield
	name = "Golden Kite Shield"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/ingot/gold = 2)
	created_item = /obj/item/weapon/shield/tower/metal/gold

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd"
	additional_items = list(/obj/item/ingot/steel = 1,/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/glaive
	name = "Glaive"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/glaive

/datum/anvil_recipe/weapons/steel/huntknife
	name = "Hunting Knife"
	created_item = /obj/item/weapon/knife/hunting

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/natural/hide = 1)
	created_item = /obj/item/weapon/shield/tower/metal
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/sword/long
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/longsword/kriegsmesser
	name = "Kriegsmesser"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/sword/long/kriegmesser

/datum/anvil_recipe/weapons/steel/mace_steel
	name = "Steel Mace"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/mace/steel

/datum/anvil_recipe/weapons/steel/flanged_mace
	name = "Steel Flanged Mace"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel/flanged

/datum/anvil_recipe/weapons/steel/barmace
	name = "Steel Mace"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel/barmace

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Steel Warhammer"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/mace/warhammer/steel

/datum/anvil_recipe/weapons/steel/peasant_flail
	name = "Peasant Flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/flail/peasant
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/chain_whip
	name = "Chain Whip"
	additional_items = list(/obj/item/rope/chain = 1)
	created_item = /obj/item/weapon/whip/chain
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/paxe
	name = "Pick-Axe"
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/pick/paxe
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/rapier_steel
	name = "Rapier"
	created_item = /obj/item/weapon/sword/rapier

/datum/anvil_recipe/weapons/steel/saber_steel
	name = "Sabre"
	created_item = /obj/item/weapon/sword/sabre

/datum/anvil_recipe/weapons/steel/sword_steel
	name = "Arming Sword"
	created_item = /obj/item/weapon/sword/arming

/datum/anvil_recipe/weapons/steel/scimitar_steel
	name = "Scimitar"
	created_item = /obj/item/weapon/sword/scimitar

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion"
	created_item = /obj/item/weapon/sword/scimitar/falchion

/datum/anvil_recipe/weapons/steel/elvenclub
	name = "Steel Elven Warclub"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/mace/elvenclub/steel

// --------- SILVER ------------  Harder to craft, does less damage and has less durability than steel, but banes undead.

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/silver
	required_material = /obj/item/ingot/silver
	craftdiff = 4
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/silver/javelin
	name = "Silver Javelins"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/javelin/silver
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/silver/staff
	name = "Silver Quarterstaff"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/silver

/datum/anvil_recipe/weapons/silver/spear
	name = "Silver Spears"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/silver
	output_amount = 2

/datum/anvil_recipe/weapons/silver/halberd
	name = "Silver Halberd"
	additional_items = list(/obj/item/ingot/silver = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/silver
	craftdiff = 4

/datum/anvil_recipe/weapons/silver/dagger
	name = "Silver Dagger"
	created_item = /obj/item/weapon/knife/dagger/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/silver_whip
	name = "Silver Whip"
	additional_items = list(/obj/item/natural/hide/cured = 2)
	created_item = /obj/item/weapon/whip/silver

/datum/anvil_recipe/weapons/silver/urumi
	name = "Silver Urumi"
	additional_items = list(/obj/item/ingot/silver = 1)
	created_item = /obj/item/weapon/whip/urumi/silver

/datum/anvil_recipe/weapons/silver/silflail
	name = "Silver Flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/flail/silver

/datum/anvil_recipe/weapons/silver/sword_silver
	name = "Silver Sword"
	created_item = /obj/item/weapon/sword/silver

/datum/anvil_recipe/weapons/silver/sengese
	name = "Silver Sengese"
	created_item = /obj/item/weapon/sword/scimitar/sengese/silver

/datum/anvil_recipe/weapons/silver/rapier_silver
	name = "Silver Rapier"
	created_item = /obj/item/weapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/forgotten
	name = "Forgotten Blade"
	additional_items = list(/obj/item/ingot/steel = 1)
	created_item = /obj/item/weapon/sword/long/forgotten

/datum/anvil_recipe/weapons/silver/declong
	name = "Decorated Silver Longsword"
	additional_items = list(/obj/item/ingot/silver = 1, /obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/sword/long/silver/decorated

/datum/anvil_recipe/weapons/silver/sillong
	name = "Silver Longsword"
	additional_items = list(/obj/item/ingot/silver = 1)
	created_item = /obj/item/weapon/sword/long/silver

/datum/anvil_recipe/weapons/silver/executioner
	name = "Silver Executioner's Sword"
	additional_items = list(/obj/item/ingot/silver = 2)
	created_item = /obj/item/weapon/sword/long/exe/silver

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Silver Broadsword"
	additional_items = list(/obj/item/ingot/silver = 1)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore/silver

/datum/anvil_recipe/weapons/silver/mace
	name = "Silver Mace"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver = 1)
	created_item = /obj/item/weapon/mace/silver

/datum/anvil_recipe/weapons/silver/barmace
	name = "Silver Barmace"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/weapon/mace/silver/barmace

/datum/anvil_recipe/weapons/silver/rungu
	name = "Silver Rungu"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/mace/rungu/silver

/datum/anvil_recipe/weapons/silver/gada
	name = "Regal Gada"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/mace/gada

/datum/anvil_recipe/weapons/silver/elvenclub
	name = "Regal Elven Club"
	additional_items = list(/obj/item/ingot/gold = 1)
	created_item = /obj/item/weapon/mace/elvenclub/silver

/datum/anvil_recipe/weapons/silver/silhammer
	name = "Silver Warhammer"
	additional_items = list(/obj/item/ingot/silver = 1)
	created_item = /obj/item/weapon/mace/warhammer/silver

/datum/anvil_recipe/weapons/silver/silveraxe
	name = "Silver Axe"
	additional_items = list(/obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/silver

/datum/anvil_recipe/weapons/silver/double_silveraxe
	name = "Double-headed Silver Axe"
	additional_items = list(/obj/item/ingot/silver = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/axe/silver/double

/datum/anvil_recipe/weapons/silver/katar
	name = "Silver Katar"
	created_item = /obj/item/weapon/katar/silver

/datum/anvil_recipe/weapons/silver/knuckles
	name = "Silver Knuckles"
	created_item = /obj/item/weapon/knuckles/silver

/datum/anvil_recipe/weapons/psy
	required_material = /obj/item/ingot/silverblessed

// --------------- Psydonite --------------------
/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonian War Axe"
	craftdiff = 3
	created_item = /obj/item/weapon/axe/psydon
	additional_items = list(/obj/item/ingot/silverblessed = 1, /obj/item/grown/log/tree/stick = 1)

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonian Mace"
	craftdiff = 3
	created_item = /obj/item/weapon/mace/goden/psydon
	additional_items = list(/obj/item/ingot/silverblessed = 1, /obj/item/grown/log/tree/stick = 1)

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonian Spear"
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/spear/psydon
	additional_items = list(/obj/item/grown/log/tree/small = 1)

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonian Dagger"
	craftdiff = 3
	created_item = /obj/item/weapon/knife/dagger/silver/psydon

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonian Shortsword"
	craftdiff = 3
	created_item = /obj/item/weapon/sword/short/psy

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonian Katar"
	craftdiff = 3
	created_item = /obj/item/weapon/katar/psydon

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonian Knuckles"
	craftdiff = 3
	created_item = /obj/item/weapon/knuckles/psydon

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonian Handmace"
	craftdiff = 3
	created_item = /obj/item/weapon/mace/cudgel/psy

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonian Halberd"
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/halberd/psydon
	additional_items = list(/obj/item/ingot/silverblessed = 1, /obj/item/grown/log/tree/small = 1)

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonian Greatsword"
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/greatsword/psydon
	additional_items = list(/obj/item/ingot/silverblessed = 1)

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonian Sword"
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/psydon

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonian Whip"
	craftdiff = 3
	created_item = /obj/item/weapon/whip/psydon
	additional_items = list(/obj/item/natural/hide/cured = 2)

// --------------- Blacksteel --------------------

/datum/anvil_recipe/weapons/blacksteel
	abstract_type = /datum/anvil_recipe/weapons/blacksteel
	required_material = /obj/item/ingot/blacksteel
	craftdiff = 6

/datum/anvil_recipe/weapons/blacksteel/battleaxe
	name = "Blacksteel Axe"
	additional_items = list(/obj/item/ingot/blacksteel = 1)
	created_item = /obj/item/weapon/axe/battle/blacksteel

/datum/anvil_recipe/weapons/blacksteel/double_battleaxe
	name = "Double-headed Blacksteel Axe"
	additional_items = list(/obj/item/ingot/blacksteel = 2)
	created_item = /obj/item/weapon/axe/battle/blacksteel/double

/datum/anvil_recipe/weapons/blacksteel/knuckles
	name = "Blacksteel Knuckles"
	created_item = /obj/item/weapon/knuckles/blacksteel

/datum/anvil_recipe/weapons/blacksteel/dagger
	name = "Blacksteel Daggers"
	created_item = /obj/item/weapon/knife/dagger/blacksteel
	output_amount = 2
	craftdiff = 5

/datum/anvil_recipe/weapons/blacksteel/misericorde
	name = "Blacksteel Misericordes"
	created_item = /obj/item/weapon/knife/dagger/blacksteel/misericorde
	output_amount = 2
	craftdiff = 5

/datum/anvil_recipe/weapons/blacksteel/rapier
	name = "Blacksteel Rapier"
	created_item = /obj/item/weapon/sword/rapier/blacksteel

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "Blacksteel Arming Sword"
	created_item = /obj/item/weapon/sword/blacksteel

/datum/anvil_recipe/weapons/blacksteel/arming_dec
	name = "Decorated Blacksteel Arming Sword"
	created_item = /obj/item/weapon/sword/blacksteel/decorated
	additional_items = list(/obj/item/ingot/gold = 1)

/datum/anvil_recipe/weapons/blacksteel/longsword
	name = "Blacksteel Longsword"
	additional_items = list(/obj/item/ingot/blacksteel = 1)
	created_item = /obj/item/weapon/sword/long/blacksteel

/datum/anvil_recipe/weapons/blacksteel/whip
	name = "Blacksteel Whip"
	additional_items = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 1)
	created_item = /obj/item/weapon/whip/blacksteel

/datum/anvil_recipe/weapons/blacksteel/quarterstaff
	name = "Blacksteel Quarterstaff"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/blacksteel

/datum/anvil_recipe/weapons/blacksteel/halberd
	name = "Blacksteel Halberd"
	additional_items = list(/obj/item/ingot/blacksteel = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/blacksteel

/datum/anvil_recipe/weapons/blacksteel/eaglebeak
	name = "Blacksteel Eagle's Beak"
	additional_items = list(/obj/item/ingot/blacksteel = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/eaglebeak/blacksteel

/datum/anvil_recipe/weapons/blacksteel/greataxe
	name = "Blacksteel Greataxe"
	additional_items = list(/obj/item/ingot/blacksteel = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/greataxe/blacksteel

/datum/anvil_recipe/weapons/blacksteel/mace
	name = "Blacksteel Mace"
	additional_items = list(/obj/item/ingot/blacksteel = 1)
	created_item = /obj/item/weapon/mace/blacksteel

/datum/anvil_recipe/weapons/blacksteel/barmace
	name = "Blacksteel Barmace"
	additional_items = list(/obj/item/ingot/blacksteel = 2)
	created_item = /obj/item/weapon/mace/blacksteel/barmace

/datum/anvil_recipe/weapons/blacksteel/flail
	name = "Blacksteel Flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/flail/blacksteel

/datum/anvil_recipe/weapons/blacksteel/battleaxe
	name = "Blacksteel Battle Axe"
	additional_items = list(/obj/item/ingot/blacksteel = 1)
	created_item = /obj/item/weapon/axe/battle/blacksteel

/datum/anvil_recipe/weapons/blacksteel/warhammer
	name = "Blacksteel Warhammer"
	additional_items = list(/obj/item/ingot/blacksteel = 1)
	created_item = /obj/item/weapon/mace/warhammer/blacksteel

/datum/anvil_recipe/weapons/blacksteel/kiteshield
	name = "Blacksteel Kite Shield"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/ingot/blacksteel = 2)
	created_item = /obj/item/weapon/shield/tower/metal/blacksteel

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "Blacksteel Flamberge"
	additional_items = list(/obj/item/ingot/blacksteel = 3)
	created_item = /obj/item/weapon/sword/long/greatsword/flamberge/blacksteel

// --------------- Bloodsteel --------------------

/datum/anvil_recipe/weapons/bloodsteel
	abstract_type = /datum/anvil_recipe/weapons/bloodsteel
	required_material = /obj/item/ingot/bloodsteel
	craftdiff = 6

/datum/anvil_recipe/weapons/bloodsteel/dagger
	name = "Bloodsteel Daggers"
	created_item = /obj/item/weapon/knife/dagger/bloodsteel
	output_amount = 2
	craftdiff = 5

/datum/anvil_recipe/weapons/bloodsteel/rapier
	name = "Bloodsteel Rapier"
	created_item = /obj/item/weapon/sword/rapier/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/arming
	name = "Bloodsteel Short Sword"
	created_item = /obj/item/weapon/sword/short/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/sword
	name = "Bloodsteel Sword"
	created_item = /obj/item/weapon/sword/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/broadsword
	name = "Bloodsteel Broadsword"
	additional_items = list(/obj/item/ingot/bloodsteel = 1)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/whip
	name = "Bloodsteel Whip"
	additional_items = list(/obj/item/natural/hide/cured = 2)
	created_item = /obj/item/weapon/whip/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/quarterstaff
	name = "Bloodsteel Quarterstaff"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/halberd
	name = "Bloodsteel Halberd"
	additional_items = list(/obj/item/ingot/bloodsteel = 1, /obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/halberd/bloodsteel

/datum/anvil_recipe/weapons/bloodsteel/spear
	name = "Bloodsteel Spears"
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/polearm/spear/bloodsteel
	output_amount = 2

/datum/anvil_recipe/weapons/bloodsteel/flail
	name = "Bloodsteel Flail"
	additional_items = list(/obj/item/rope/chain = 1, /obj/item/grown/log/tree/stick = 1)
	created_item = /obj/item/weapon/flail/bloodsteel

// ------------------ Miscellaneous Weapons ------------------

/datum/anvil_recipe/weapons/dwarven_shield
	name = "kite shield"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree = 1)
	created_item = /obj/item/weapon/shield/dwarvenkite
	category = "Shields"
	craftdiff = 2

/datum/anvil_recipe/weapons/bearded_axe
	name = "Bearded axe"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small = 1)
	created_item = /obj/item/weapon/axe/steel/bearded
	craftdiff = 3

/datum/anvil_recipe/weapons/mace/cane/noble
	name = "Decorated Cane"
	craftdiff = 3
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/grown/log/tree = 1)
	created_item = /obj/item/weapon/mace/cane/noble
