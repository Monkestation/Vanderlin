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
	name = "Copper Hatchet (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/weapon/axe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Copper Bludgeon (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bludgeon/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Copper Daggers"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/copper
	output_amount = 2

//datum/anvil_recipe/weapons/copper/cmace
//	name = "Mace (2)"
//	recipe_name = "a Mace"
//	appro_skill = /datum/attribute/skill/craft/weaponsmithing
//	required_material = /obj/item/ingot/copper
//	additional_items = list(/obj/item/ingot/copper)
//	created_item = (/obj/item/weapon/mace/coppermace)
//	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Copper Messer (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sword/coppermesser

/datum/anvil_recipe/weapons/copper/cspears
	name = "Copper Javelins (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/javelin
	output_amount = 2

/datum/anvil_recipe/weapons/copper/cfalx
	name = "Copper Falx (+Copper Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/copper)
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
	name = "Bronze Spear (+Bar, +Small Log)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/bronze

/datum/anvil_recipe/weapons/bronze/cane
	name = "Artificer Cane (+Copper Bar)"
	additional_items = list(/obj/item/ingot/copper)
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
	name = "Bronze Dadao (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/sword/sabre/dadao/bronze

/datum/anvil_recipe/weapons/bronze/shishpar
	name = "Bronze Shishpar (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/mace/bronze/shishpar

/datum/anvil_recipe/weapons/bronze/urumi
	name = "Bronze Urumi (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/whip/urumi/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "Bronze Mace (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "Bronze Axe (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
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
	name = "Bronze Dagger-Ax (+Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/bronze

// --------- IRON ------------ Middle Tier, what most disgusting Men at Arms have
/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	required_material = /obj/item/ingot/iron
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/iron/arrows
	name = "Arrows (+Plank)"
	appro_skill = /datum/attribute/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/ammo_casing/caseless/arrow
	output_amount = 5
	category = "Ammo"
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts (+Plank)"
	appro_skill = /datum/attribute/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/ammo_casing/caseless/bolt
	output_amount = 5
	category = "Ammo"

/datum/anvil_recipe/weapons/iron/javelin
	name = "Iron Javelins (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/javelin/iron
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/iron/quarterstaff
	name = "Iron Quarertstaff (+Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron

/datum/anvil_recipe/weapons/iron/axe_iron
	name = "Iron Axe (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/iron

/datum/anvil_recipe/weapons/iron/nsapo
	name = "Iron Kasuyu (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/iron/nsapo

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/assegai
	name = "Iron Assegai (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/assegai

/datum/anvil_recipe/weapons/iron/woodcutter
	name = "Woodcutter Axe (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/woodcutter

/datum/anvil_recipe/weapons/iron/warcutter
	name = "Footman War Axe (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/warcutter
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe (+Bar, +Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/iron)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "Dagger"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger
	output_amount = 2
	craftdiff = 0 // To train with

/datum/anvil_recipe/weapons/iron/njora
	name = "Iron Seme's"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/njora
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/kukri
	name = "Iron Kukri"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting/kukri/iron

/datum/anvil_recipe/weapons/iron/aruval
	name = "Iron Aruval (+Iron Bar x2)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/long/aruval/iron

/datum/anvil_recipe/weapons/iron/dadao
	name = "Iron Dadao (+Iron Bar)"
	additional_items = list(/obj/item/ingot/iron)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/dadao/iron

/datum/anvil_recipe/weapons/iron/ji
	name = "Iron Dagger-Ax (+Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/iron

/datum/anvil_recipe/weapons/iron/wodao
	name = "Iron Wo Dao"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/wodao/iron

/datum/anvil_recipe/weapons/iron/urumi
	name = "Iron Urumi (+Iron Bar)"
	additional_items = list(/obj/item/ingot/iron)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi/iron

/datum/anvil_recipe/weapons/iron/lakkarikhopesh
	name = "Iron Khopesh"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh/iron

/datum/anvil_recipe/weapons/iron/sengese
	name = "Iron Sengese"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese/iron

/datum/anvil_recipe/weapons/iron/jile
	name = "Iron Jile Daggers"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/jile
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "Villager Knives"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/villager
	output_amount = 3
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/cleaver
	name = "Cleaver"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/cleaver

/datum/anvil_recipe/weapons/iron/flail_iron
	name = "Militia flail (+Chain, +Stick)"
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/flail/militia

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/eaglebeak/lucerne
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/sledgehammer
	name = "Sledgehammer (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = 	/obj/item/weapon/hammer/sledgehammer

/datum/anvil_recipe/weapons/iron/mace_iron
	name = "Iron Mace (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace

/datum/anvil_recipe/weapons/iron/rungu
	name = "Iron Rungu (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/rungu

/datum/anvil_recipe/weapons/iron/ibludgeon
	name = "Iron Bludgeon (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bludgeon

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Iron Warhammer (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/warhammer

/datum/anvil_recipe/weapons/iron/messer_iron
	name = "Messer"
	created_item = /obj/item/weapon/sword/scimitar/messer

/datum/anvil_recipe/weapons/iron/spear_iron
	name = "Spears (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear
	output_amount = 2

/datum/anvil_recipe/weapons/iron/shortsword_iron
	name = "Short Sword"
	created_item = /obj/item/weapon/sword/short/iron
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/ida
	name = "Ida"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/short/iron/ida

/datum/anvil_recipe/weapons/iron/shotel
	name = "Shotel (+Iron Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,)
	created_item = /obj/item/weapon/sword/long/shotel/iron

/datum/anvil_recipe/weapons/iron/shishpar
	name = "Iron Shishpar (+Iron Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/weapon/mace/shishpar

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Sword"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/iron

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Estoc"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier/ironestoc

/datum/anvil_recipe/weapons/iron/kaskara
	name = "Iron Kaskara"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/kaskara/iron

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/shield/tower
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/ironbuckler
	name = "Iron Buckler"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	created_item = /obj/item/weapon/shield/tower/buckleriron

/datum/anvil_recipe/weapons/iron/warclub
	name = "Warclub (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/mace/goden
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/zweihander
	name = "Zweihander (+Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/weapon/sword/long/greatsword/zwei
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/claymore
	name = "Iron Claymore (+Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore/iron
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/elvenclub
	name = "Elven Warclub"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/mace/elvenclub
	craftdiff = 2

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
	name = "Steel Assegai (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/assegai/steel

/datum/anvil_recipe/weapons/steel/javelin
	name = "Steel Javelins (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/javelin/steel
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/steel/quarterstaff
	name = "Steel Quarterstaff (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel

/datum/anvil_recipe/weapons/steel/spear
	name = "Steel Spears (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/steel
	output_amount = 2

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/steel/partizan

/datum/anvil_recipe/weapons/steel/aruval
	name = "Steel Aruval (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/long/aruval

/datum/anvil_recipe/weapons/steel/dadao
	name = "Steel Dadao (+Steel Bar)"
	additional_items = list(/obj/item/ingot/steel)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/dadao

/datum/anvil_recipe/weapons/steel/ji
	name = "Steel Dagger-Ax (+Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/polearm/spear/billhook/ji

/datum/anvil_recipe/weapons/steel/wodao
	name = "Steel Wo Dao"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/wodao

/datum/anvil_recipe/weapons/steel/urumi
	name = "Steel Urumi (+Steel Bar)"
	additional_items = list(/obj/item/ingot/steel)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi

/datum/anvil_recipe/weapons/steel/lakkarikhopesh
	name = "Steel Khopesh"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh

/datum/anvil_recipe/weapons/steel/sengese
	name = "Steel Sengese"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese

/datum/anvil_recipe/weapons/steel/axe_steel
	name = "Steel Axe (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/steel

/datum/anvil_recipe/weapons/steel/felling_axe
	name = "Felling Axe (+Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/woodcutter/steel

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe (+Bar, +Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/steel)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe/steel
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/doubleheaded_greataxe
	name = "Double-headed Greataxe (+Bar x2), (+Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/steel, /obj/item/ingot/steel)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe/steel/doublehead
	craftdiff = 5

/datum/anvil_recipe/weapons/steel/nsapo
	name = "Steel Kasuyu (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/steel/nsapo

/datum/anvil_recipe/weapons/steel/rungu
	name = "Steel Rungu (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/steel/rungu


/datum/anvil_recipe/weapons/steel/sledgehammer
	name = "Steel Sledgehammer (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = 	/obj/item/weapon/hammer/sledgehammer/war

/datum/anvil_recipe/weapons/steel/njora
	name = "Steel Seme's"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/njora
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/jile
	name = "Steel Jile Daggers"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/jile
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe (+Steel Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/axe/battle
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/billhook
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/cutlass_steel
	name = "Cutlass"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/cutlass

/datum/anvil_recipe/weapons/steel/shotel
	name = "Steel Shotel (+Steel Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/shotel

/datum/anvil_recipe/weapons/steel/shishpar
	name = "Steel Shishpar (+Steel Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel/shishpar

/datum/anvil_recipe/weapons/steel/ida
	name = "Steel Ida"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/short/ida

/datum/anvil_recipe/weapons/steel/kaskara // I FORGOT TO INCLUDE IT
	name = "Steel Kaskara"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/kaskara

/datum/anvil_recipe/weapons/steel/kukri
	name = "Steel Kukri"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting/kukri

/datum/anvil_recipe/weapons/steel/hackknife
	name = "Hack-Knife"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/cleaver/combat

/datum/anvil_recipe/weapons/steel/knuckles
	name = "Knuckles"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knuckles

/datum/anvil_recipe/weapons/steel/dagger_steel
	name = "Steel Daggers"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/stiletto
	name = "Steel Stilettos"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/stiletto
	output_amount = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/royal
	name = "Decorated Dagger"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/knife/dagger/steel/royal
	output_amount = 2
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/decsaber
	name = "Decorated Sabre (+Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/sabre/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decsword
	name = "Decorated Sword (+Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/decorated
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decrapier
	name = "Decorated Rapier (+Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/rapier/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/nimcha
	name = "Nimcha (+Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/rapier/nimcha
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/eaglebeak
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/flail_steel
	name = "Steel Flail (+Chain, +Stick)"
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/flail/sflail

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/goden/steel
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword (+Steel Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/flamberge
	name = "Flamberge (+Steel Bar x3)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword/flamberge
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/claymore
	name = "Steel Claymore (+Steel Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore
	craftdiff = 4

/datum/anvil_recipe/weapons/silver/noble_sword_scabbard
	name = "Decorated Silver Sword Scabbard (+Scabbard)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/sword)
	created_item = /obj/item/weapon/scabbard/sword/noble

/datum/anvil_recipe/weapons/silver/noble_knife_sheath
	name = "Decorated Silver Knife Sheath (+Sheath)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/knife)
	created_item = /obj/item/weapon/scabbard/knife/noble

/datum/anvil_recipe/weapons/gold
	abstract_type = /datum/anvil_recipe/weapons/gold
	required_material = /obj/item/ingot/gold
	craftdiff = 5

/datum/anvil_recipe/weapons/gold/noble_sword_scabbard
	name = "Decorated Golden Sword Scabbard (+Scabbard)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/sword)
	created_item = /obj/item/weapon/scabbard/sword/royal

/datum/anvil_recipe/weapons/gold/noble_knife_sheath
	name = "Decorated Golden Knife Sheath (+Sheath)"
	additional_items = list(/obj/item/weapon/scabbard/knife)
	created_item = /obj/item/weapon/scabbard/knife/royal

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/glaive
	name = "Glaive (+Steel Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/glaive

/datum/anvil_recipe/weapons/steel/huntknife
	name = "Hunting Knife"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+Bar, +Hide)"
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide)
	created_item = /obj/item/weapon/shield/tower/metal
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/longsword/kriegsmesser
	name = "Kriegsmesser (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/kriegmesser

/datum/anvil_recipe/weapons/steel/mace_steel
	name = "Steel Mace (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Steel Warhammer (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/warhammer/steel

/datum/anvil_recipe/weapons/steel/peasant_flail
	name = "Peasant Flail (+Chain, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/flail/peasant
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/chain_whip
	name = "Chain Whip (+Chain)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/rope/chain)
	created_item = /obj/item/weapon/whip/chain
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/paxe
	name = "Pick-Axe (+Bar, +Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/paxe
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/rapier_steel
	name = "Rapier"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier

/datum/anvil_recipe/weapons/steel/saber_steel
	name = "Sabre"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre

/datum/anvil_recipe/weapons/steel/sword_steel
	name = "Arming Sword"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/arming

/datum/anvil_recipe/weapons/steel/scimitar_steel
	name = "Scimitar"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/falchion

/datum/anvil_recipe/weapons/steel/elvenclub
	name = "Steel Elven Warclub (+Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/elvenclub/steel

// --------- SILVER ------------  Harder to craft, does less damage and has less durability than steel, but banes undead.

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/silver
	required_material = /obj/item/ingot/silver
	craftdiff = 4
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/silver/javelin
	name = "Silver Javelins (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/javelin/silver
	output_amount = 2
	category = "Ammo"

/datum/anvil_recipe/weapons/silver/staff
	name = "Silver Quarterstaff (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/woodstaff/quarterstaff/silver

/datum/anvil_recipe/weapons/silver/spear
	name = "Silver Spears (+Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/silver
	output_amount = 2

/datum/anvil_recipe/weapons/silver/halberd
	name = "Silver Halberd (+Bar, +Small Log)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/silver
	craftdiff = 4

/datum/anvil_recipe/weapons/silver/dagger
	name = "Silver Dagger"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/silver_whip
	name = "Silver Whip (+Cured Hide x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/natural/hide/cured,/obj/item/natural/hide/cured)
	created_item = /obj/item/weapon/whip/silver

/datum/anvil_recipe/weapons/silver/urumi
	name = "Silver Urumi (+Silver Bar)"
	additional_items = list(/obj/item/ingot/silver)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi/silver

/datum/anvil_recipe/weapons/silver/silflail
	name = "Silver Flail (+Chain, +Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/flail/silver

/datum/anvil_recipe/weapons/silver/sword_silver
	name = "Silver Sword"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/silver

/datum/anvil_recipe/weapons/silver/sengese
	name = "Silver Sengese"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese/silver

/datum/anvil_recipe/weapons/silver/rapier_silver
	name = "Silver Rapier"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/forgotten
	name = "Forgotten Blade (+Steel Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/forgotten

/datum/anvil_recipe/weapons/silver/declong
	name = "Decorated Silver Longsword (+Silver Bar, +Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/long/silver/decorated

/datum/anvil_recipe/weapons/silver/sillong
	name = "Silver Longsword (+Silver Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/weapon/sword/long/silver

/datum/anvil_recipe/weapons/silver/executioner
	name = "Silver Executioner's Sword (+Silver Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/weapon/sword/long/exe/silver

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Silver Broadsword (+Silver Bar x2)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/weapon/sword/long/greatsword/claymore/silver

/datum/anvil_recipe/weapons/silver/mace
	name = "Silver Mace (+Silver Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/weapon/mace/silver

/datum/anvil_recipe/weapons/silver/rungu
	name = "Silver Rungu (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/rungu/silver

/datum/anvil_recipe/weapons/silver/gada
	name = "Regal Gada (+1 Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/mace/gada

/datum/anvil_recipe/weapons/silver/elvenclub
	name = "Regal Elven Club (+1 Gold Bar)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/mace/elvenclub/silver

/datum/anvil_recipe/weapons/silver/silhammer
	name = "Silver Warhammer (+1 Silver Bar)"
	additional_items = list(/obj/item/ingot/silver)
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/mace/warhammer/silver

/datum/anvil_recipe/weapons/silver/silveraxe
	name = "Silver Axe (+Stick)"
	appro_skill = /datum/attribute/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/silver

// --------------- Psydonite --------------------
/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonian War Axe (+B. Silver, +Stick)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/axe/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonian Mace (+B. Silver, +Stick)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/mace/goden/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonian Spear (+Small Log)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/spear/psydon
	additional_items = list(/obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonian Dagger"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/knife/dagger/silver/psydon

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonian Shortsword"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/short/psy

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonian Katar"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/katar/psydon

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonian Knuckles"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/knuckles/psydon

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonian Handmace"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/mace/cudgel/psy

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonian Halberd (+B. Silver, +Small Log)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/halberd/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonian Greatsword (+B. Silver)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/greatsword/psydon
	additional_items = list(/obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonian Sword"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/psydon

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonian Whip (+Cured Leather x2)"
	required_material = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/whip/psydon
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)

// ------------------ Miscellaneous Weapons ------------------

/datum/anvil_recipe/weapons/atgervi_shield
	name = "kite shield"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree)
	created_item = /obj/item/weapon/shield/atgervi
	category = "Shields"
	craftdiff = 2

/datum/anvil_recipe/weapons/atgervi_axe
	name = "Bearded axe (+Small Log)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/axe/steel/atgervi
	craftdiff = 3

/datum/anvil_recipe/weapons/mace/cane/noble
	name = "Decorated Cane (+Gold Bar, +Large Log)"
	craftdiff = 3
	additional_items = list(/obj/item/ingot/gold, /obj/item/grown/log/tree)
	created_item = /obj/item/weapon/mace/cane/noble
