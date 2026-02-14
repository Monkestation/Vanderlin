/datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	abstract_type = /datum/anvil_recipe/weapons
	category = "Weapons"


////////////////////////////////////
// --------- TIN -----------
//honestly the only tin "weapon" that comes to mind would be lead bullets
/datum/anvil_recipe/weapons/tin
	abstract_type = /datum/anvil_recipe/weapons/tin
	req_bar = /obj/item/ingot/tin
	craftdiff = 0
////////////////////////////////////

/datum/anvil_recipe/weapons/tin/lead_bullet //guys how are you making LEAD bullets out of TIN?
	name = "4x Lead Bullets"
	recipe_name = "a handful of lead bullets."
	created_item = /obj/item/ammo_casing/caseless/bullet
	craftdiff = 1
	createditem_extra = 3

/datum/anvil_recipe/weapons/tin/grenade_shell
	name = "2x Grenade shells"
	recipe_name = "Grenade Casings"
	created_item = /obj/item/ammo_casing/caseless/grenadeshell
	craftdiff = 3
	createditem_extra = 1
	///jokes on you whoever said lead bullets were the only tin weapon, may I introduce the pipe casing.
//////////////////////////////////////////////////////////////////////////////////////////////
// --------- COPPER -----------
/datum/anvil_recipe/weapons/copper
	abstract_type = /datum/anvil_recipe/weapons/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = 0
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/copper/caxe
	name = "Copper Hatchet (+Bar)"
	recipe_name = "an Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/weapon/axe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Copper Bludgeon (+Stick)"
	recipe_name = "a Bludgeon"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bludgeon/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "x2 Copper Daggers"
	recipe_name = "a couple Daggers"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/copper
	createditem_extra = 1

//datum/anvil_recipe/weapons/copper/cmace
//	name = "Mace (2)"
//	recipe_name = "a Mace"
//	appro_skill = /datum/skill/craft/weaponsmithing
//	req_bar = /obj/item/ingot/copper
//	additional_items = list(/obj/item/ingot/copper)
//	created_item = (/obj/item/weapon/mace/coppermace)
//	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Copper Messer (+Stick)"
	recipe_name = "a Messer"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/sword/coppermesser

/datum/anvil_recipe/weapons/copper/cspears
	name = "2x Copper Javelins (+Small Log)"
	recipe_name = "two Spears"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/stone/copper
	createditem_extra = 1

/datum/anvil_recipe/weapons/copper/cfalx
	name = "Copper Falx (+Bar)"
	recipe_name = "a great copper sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/weapon/sword/long/rider/copper

// --------- BRONZE -----------
/datum/anvil_recipe/weapons/bronze
	abstract_type = /datum/anvil_recipe/weapons/bronze
	req_bar = /obj/item/ingot/bronze
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
	name = "Artificer Cane (+ Copper)"
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
	name = "Bronze Dadao (+1 Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/sword/sabre/dadao/bronze

/datum/anvil_recipe/weapons/bronze/shishpar
	name = "Bronze Shishpar (+1 Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/mace/bronze/shishpar

/datum/anvil_recipe/weapons/bronze/urumi
	name = "Bronze Urumi (+1 Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/weapon/whip/urumi/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "Bronze Mace (+ Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "Bronze Axe (+ Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/bronze

/datum/anvil_recipe/weapons/bronze/elvenclub
	name = "Bronze Elven Warclub"
	created_item = /obj/item/weapon/mace/elvenclub/bronze

/datum/anvil_recipe/weapons/bronze/dagger
	name = "2x Bronze Daggers"
	created_item = /obj/item/weapon/knife/dagger/bronze
	createditem_extra = 1

/datum/anvil_recipe/weapons/bronze/throwingdagger
	name = "3x Bronze Throwing Daggers"
	created_item = /obj/item/weapon/knife/throwingknife/bronze
	createditem_extra = 2

/datum/anvil_recipe/weapons/bronze/ji
	name = "Bronze Dagger-Ax (+ Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/bronze

// --------- IRON ------------ Middle Tier, what most disgusting Men at Arms have
/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/iron/arrows
	name = "5x Arrows (+Plank)"
	recipe_name = "five Arrows"
	appro_skill = /datum/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/ammo_casing/caseless/arrow
	createditem_extra = 4
	i_type = "Ammo"
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/bolts
	name = "5x Crossbow Bolts (+Plank)"
	recipe_name = "five Crossbow Bolts"
	appro_skill = /datum/skill/craft/engineering
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/ammo_casing/caseless/bolt
	createditem_extra = 4
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/axe_iron
	name = "Iron Axe (+Stick)"
	recipe_name = "an Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/iron

/datum/anvil_recipe/weapons/iron/nsapo
	name = "Iron Kasuyu (+Stick)"
	recipe_name = "an Iron Kasuyu Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/iron/nsapo

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche (+Bar, +Small Log)"
	recipe_name = "a Bardiche"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/assegai
	name = "Iron Assegai (+ Small Log)"
	recipe_name = "an Iron Assegai"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/assegai

/datum/anvil_recipe/weapons/iron/woodcutter
	name = "Woodcutter Axe (+Small Log)"
	recipe_name = "a great axe for woodcutters"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/woodcutter

/datum/anvil_recipe/weapons/iron/warcutter
	name = "Footman War Axe (+Bar, +Small Log)"
	recipe_name = "a war greataxe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd/bardiche/warcutter
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe (+Bar x2), (+Small log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/iron, /obj/item/ingot/iron)
	recipe_name = "a Greataxe with a single blade."
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "Dagger x2"
	recipe_name = "a couple Daggers"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger
	createditem_extra = 1
	craftdiff = 0 // To train with

/datum/anvil_recipe/weapons/iron/njora
	name = "2x Iron Seme's"
	recipe_name = "a Iron Seme"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/njora
	createditem_extra = 1
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/kukri
	name = "Iron Kukri"
	recipe_name = "a Iron Kukri"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting/kukri/iron

/datum/anvil_recipe/weapons/iron/aruval
	name = "Iron Aruval (+2 Iron Bar)"
	recipe_name = "a Iron Aruval"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/long/aruval/iron

/datum/anvil_recipe/weapons/iron/dadao
	name = "Iron Dadao (+1 Iron Bar)"
	recipe_name = "a Iron Dadao"
	additional_items = list(/obj/item/ingot/iron)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/dadao/iron

/datum/anvil_recipe/weapons/iron/ji
	name = "Iron Dagger-Ax (+ Small Log)"
	recipe_name = "a Iron Dagger-Ax"
	additional_items = list(/obj/item/grown/log/tree/small)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/polearm/spear/billhook/ji/iron

/datum/anvil_recipe/weapons/iron/wodao
	name = "Iron Wo Dao"
	recipe_name = "a Iron Wo Dao"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/wodao/iron

/datum/anvil_recipe/weapons/iron/urumi
	name = "Iron Urumi (+1 Iron Bar)"
	recipe_name = "a Iron Urumi"
	additional_items = list(/obj/item/ingot/iron)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi/iron

/datum/anvil_recipe/weapons/iron/lakkarikhopesh
	name = "Iron Khopesh"
	recipe_name = "a Iron Khopesh"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh/iron

/datum/anvil_recipe/weapons/iron/sengese
	name = "Iron Sengese"
	recipe_name = "a Iron Sengese"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese/iron

/datum/anvil_recipe/weapons/iron/jile
	name = "2x Iron Jile Daggers"
	recipe_name = "a Iron Jile"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/jile
	createditem_extra = 1
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/dagger_iron
	name = "3x Villager Knives"
	recipe_name = "three peasantry knives"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/villager
	createditem_extra = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/cleaver
	name = "Cleaver"
	recipe_name = "a Cleaver"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/cleaver

/datum/anvil_recipe/weapons/iron/flail_iron
	name = "Militia flail (+Chain, +Stick)"
	recipe_name = "a militia flail"
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/flail/militia

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne (+Bar, +Small Log)"
	recipe_name = "a Lucerne"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/eaglebeak/lucerne
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/sledgehammer
	name = "Sledgehammer (+Small Log)"
	recipe_name = "a big hammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = 	/obj/item/weapon/hammer/sledgehammer

/datum/anvil_recipe/weapons/iron/mace_iron
	name = "Iron Mace (+Stick)"
	recipe_name = "a Mace"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace

/datum/anvil_recipe/weapons/iron/rungu
	name = "Iron Rungu (+Stick)"
	recipe_name = "an Iron Rungu"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/rungu

/datum/anvil_recipe/weapons/iron/ibludgeon
	name = "Iron Bludgeon (+Stick)"
	recipe_name = "a Bludgeon"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/bludgeon

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Iron Warhammer (+1 Stick)"
	recipe_name = "a Warhammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/warhammer

/datum/anvil_recipe/weapons/iron/messer_iron
	name = "Messer"
	recipe_name = "a Messer"
	created_item = /obj/item/weapon/sword/scimitar/messer

/datum/anvil_recipe/weapons/iron/spear_iron
	name = "2x Spears (+Small Log)"
	recipe_name = "a couple Spears"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear
	createditem_extra = 1

/datum/anvil_recipe/weapons/iron/shortsword_iron
	name = "Short Sword"
	recipe_name = "a Short Sword"
	created_item = /obj/item/weapon/sword/short/iron

/datum/anvil_recipe/weapons/iron/ida
	name = "Ida"
	recipe_name= "an Iron Ida"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/short/iron/ida

/datum/anvil_recipe/weapons/iron/shotel
	name = "Shotel (+Iron Bar)"
	recipe_name= "an Iron Shotel"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron,)
	created_item = /obj/item/weapon/sword/long/shotel/iron

/datum/anvil_recipe/weapons/iron/shishpar
	name = "Iron Shishpar (+ Iron Bar)"
	recipe_name = "a Iron Shishpar"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/weapon/mace/shishpar

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Sword"
	recipe_name = "a Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/iron
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/sword_iron
	name = "Estoc"
	recipe_name = "a Duelist Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier/ironestoc

/datum/anvil_recipe/weapons/iron/kaskara
	name = "Iron Kaskara"
	recipe_name = "a Iron Kaskara"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/kaskara/iron

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+Small Log)"
	recipe_name = "a Tower Shield"
	appro_skill = /datum/skill/craft/armorsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/shield/tower
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/ironbuckler
	name = "Iron Buckler"
	recipe_name = "a small Shield"
	appro_skill = /datum/skill/craft/armorsmithing
	created_item = /obj/item/weapon/shield/tower/buckleriron

/datum/anvil_recipe/weapons/iron/warclub
	name = "Warclub (+Small Log)"
	recipe_name = "a Warclub"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/mace/goden
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/zweihander
	name = "Zweihander (+Bar x2)"
	recipe_name = "a Zweihander"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/weapon/sword/long/greatsword/zwei
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/claymore
	name = "Iron Claymore (+Bar x2)"
	recipe_name = "a Iron Claymore"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/weapon/sword/long/greatsword/ironclaymore
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/elvenclub
	name = "Elven Warclub"
	recipe_name = "a Warclub"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/mace/elvenclub
	craftdiff = 2

// --------- STEEL ------------  Fancy gear for Knights
/datum/anvil_recipe/weapons/steel
	abstract_type = /datum/anvil_recipe/weapons/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = 2

///////////////////////////////////////////////

/datum/anvil_recipe/weapons/steel/short_sword
	name = "Steel Short Sword"
	recipe_name = "a Steel Short Sword"
	created_item = /obj/item/weapon/sword/short

/datum/anvil_recipe/weapons/steel/assegai
	name = "Steel Assegai (+ Small Log)"
	recipe_name = "a Steel Assegai"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/steel/assegai

/datum/anvil_recipe/weapons/steel/aruval
	name = "Steel Aruval (+2 Steel Bar)"
	recipe_name = "a Steel Aruval"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/long/aruval

/datum/anvil_recipe/weapons/steel/dadao
	name = "Steel Dadao (+1 Steel Bar)"
	recipe_name = "a Steel Dadao"
	additional_items = list(/obj/item/ingot/steel)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/dadao

/datum/anvil_recipe/weapons/steel/ji
	name = "Steel Dagger-Ax (+ Small Log)"
	recipe_name = "a Steel Dagger-Ax"
	additional_items = list(/obj/item/grown/log/tree/small)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/polearm/spear/billhook/ji

/datum/anvil_recipe/weapons/steel/wodao
	name = "Steel Wo Dao"
	recipe_name = "a Steel Wo Dao"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/wodao

/datum/anvil_recipe/weapons/steel/urumi
	name = "Steel Urumi (+1 Steel Bar)"
	recipe_name = "a Steel Urumi"
	additional_items = list(/obj/item/ingot/steel)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi

/datum/anvil_recipe/weapons/steel/lakkarikhopesh
	name = "Steel Khopesh"
	recipe_name = "a Steel Khopesh"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/lakkarikhopesh

/datum/anvil_recipe/weapons/steel/sengese
	name = "Steel Sengese"
	recipe_name = "a Steel Sengese"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese

/datum/anvil_recipe/weapons/steel/axe_steel
	name = "Steel Axe (+Stick)"
	recipe_name = "an Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/steel

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe (+Bar x2), (+Small log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/steel, /obj/item/ingot/steel)
	recipe_name = "a Greataxe with a single blade."
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe/steel
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/doubleheaded_greataxe
	name = "Double-headed Greataxe (+Bar x3), (+Small log)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	recipe_name = "a Greataxe with two blades."
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/greataxe/steel/doublehead
	craftdiff = 5

/datum/anvil_recipe/weapons/steel/nsapo
	name = "Steel Kasuyu (+Stick)"
	recipe_name = "an Steel Kasuyu Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/axe/steel/nsapo

/datum/anvil_recipe/weapons/steel/rungu
	name = "Steel Rungu (+Stick)"
	recipe_name = "an Steel Rungu"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/steel/rungu


/datum/anvil_recipe/weapons/steel/sledgehammer
	name = "Steel Sledgehammer (+Small Log)"
	recipe_name = "a big Sledgehammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = 	/obj/item/weapon/hammer/sledgehammer/war

/datum/anvil_recipe/weapons/steel/njora
	name = "2x Steel Seme's"
	recipe_name = "a Steel Seme"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/njora
	createditem_extra = 1
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/jile
	name = "2x Steel Jile Daggers"
	recipe_name = "a Steel Jile"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/jile
	createditem_extra = 1
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe (+Bar x2)"
	recipe_name = "a Battle Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/axe/battle
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook (+Small Log)"
	recipe_name = "a Billhook"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/spear/billhook
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/cutlass_steel
	name = "Cutlass"
	recipe_name = "a Cutlass"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre/cutlass

/datum/anvil_recipe/weapons/steel/shotel
	name = "Steel Shotel (+ Steel Bar)"
	recipe_name = "a Steel Shotel"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/shotel

/datum/anvil_recipe/weapons/steel/shishpar
	name = "Steel Shishpar (+ Steel Bar)"
	recipe_name = "a Steel Shishpar"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel/shishpar

/datum/anvil_recipe/weapons/steel/ida
	name = "Steel Ida"
	recipe_name = "a Steel Ida"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/short/ida

/datum/anvil_recipe/weapons/steel/kaskara // I FORGOT TO INCLUDE IT
	name = "Steel Kaskara"
	recipe_name = "a Steel Kaskara"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/kaskara

/datum/anvil_recipe/weapons/steel/kukri
	name = "Steel Kukri"
	recipe_name = "a Steel Kukri"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting/kukri

/datum/anvil_recipe/weapons/steel/knuckles
	name = "Knuckles"
	recipe_name = "a Steel Knuckles"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knuckles

/datum/anvil_recipe/weapons/steel/dagger_steel
	name = "2x Steel Daggers"
	recipe_name = "a couple Daggers"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel
	createditem_extra = 1
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/stiletto
	name = "2x Steel Stilettos"
	recipe_name = "a couple Daggers"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/steel/stiletto
	createditem_extra = 1
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/decsaber
	name = "Decorated Sabre (+Gold Bar)"
	recipe_name = "a Decorated Sabre"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/sabre/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decsword
	name = "Decorated Sword (+Gold Bar)"
	recipe_name = "a Decorated Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/decorated
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/decrapier
	name = "Decorated Rapier (+Gold Bar)"
	recipe_name = "a Decorated Rapier"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/rapier/dec
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/nimcha
	name = "Nimcha (+Gold Bar)"
	recipe_name = "a Nimcha"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/rapier/nimcha
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+Bar, +Small Log)"
	recipe_name = "an Eagle's Beak"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/eaglebeak
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/flail_steel
	name = "Steel Flail (+Chain, +Stick)"
	recipe_name = "a Flail"
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/flail/sflail

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace (+Small Log)"
	recipe_name = "a Grand Mace"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/mace/goden/steel
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword (+Bar x2)"
	recipe_name = "a Greatsword"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/flamberge
	name = "Flamberge (+Bar x3)"
	recipe_name = "a Flamberge"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword/flamberge
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/claymore
	name = "Steel Claymore (+Bar x2)"
	recipe_name = "a Steel Claymore"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/greatsword/steelclaymore
	craftdiff = 4

/datum/anvil_recipe/weapons/silver/noble_sword_scabbard
	name = "Decorated Silver Sword Scabbard (+Scabbard)"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/sword)
	created_item = /obj/item/weapon/scabbard/sword/noble

/datum/anvil_recipe/weapons/silver/noble_knife_sheath
	name = "Decorated Silver Knife Sheath (+Sheath)"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/knife)
	created_item = /obj/item/weapon/scabbard/knife/noble

/datum/anvil_recipe/weapons/gold
	abstract_type = /datum/anvil_recipe/weapons/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = 5

/datum/anvil_recipe/weapons/gold/noble_sword_scabbard
	name = "Decorated Golden Sword Scabbard (+Scabbard)"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/weapon/scabbard/sword)
	created_item = /obj/item/weapon/scabbard/sword/royal

/datum/anvil_recipe/weapons/gold/noble_knife_sheath
	name = "Decorated Golden Knife Sheath (+Sheath)"
	additional_items = list(/obj/item/weapon/scabbard/knife)
	created_item = /obj/item/weapon/scabbard/knife/royal

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd (+Bar, +Small Log)"
	recipe_name = "a Halberd"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel,/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/polearm/halberd
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/huntknife
	name = "Hunting Knife"
	recipe_name = "a Hunting Knife"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/hunting

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+Bar, +Hide)"
	recipe_name = "a Kite Shield"
	appro_skill = /datum/skill/craft/armorsmithing
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide)
	created_item = /obj/item/weapon/shield/tower/metal
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword (+Bar)"
	recipe_name = "a Longsword"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/mace_steel
	name = "Steel Mace (+Bar)"
	recipe_name = "a Mace"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/steel

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Steel Warhammer (+Bar)"
	recipe_name = "a Warhammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/mace/warhammer/steel

/datum/anvil_recipe/weapons/steel/peasant_flail
	name = "Peasant Flail (+Chain, +Small Log)"
	recipe_name = "a two-handed flail"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/rope/chain, /obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/flail/peasant
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/chain_whip
	name = "Chain Whip (+chain)"
	recipe_name = "a whip made from chains"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/rope/chain)
	created_item = /obj/item/weapon/whip/chain
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/paxe
	name = "Pick-Axe (+Bar, +Stick)"
	recipe_name = "a Pick that is also an Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/pick/paxe
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/rapier_steel
	name = "Rapier"
	recipe_name = "a Rapier"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier

/datum/anvil_recipe/weapons/steel/saber_steel
	name = "Sabre"
	recipe_name = "a Sabre"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/sabre

/datum/anvil_recipe/weapons/steel/sword_steel
	name = "Arming Sword"
	recipe_name = "a Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/arming

/datum/anvil_recipe/weapons/steel/scimitar_steel
	name = "Scimitar"
	recipe_name = "a Zalad Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion"
	recipe_name = "a heavy one handed sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/falchion

/datum/anvil_recipe/weapons/steel/elvenclub
	name = "Steel Elven Warclub"
	recipe_name = "a Steel Elven Warclub"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/mace/elvenclub/steel

// --------- SILVER ------------  Harder to craft, does less damage and has less durability than steel, but banes undead.

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = 4
///////////////////////////////////////////////

/datum/anvil_recipe/weapons/silver/dagger
	name = "Silver Dagger"
	recipe_name = "a Silver Dagger"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/knife/dagger/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/silver_whip
	name = "Silver Whip (+2 Cured Hide)"
	recipe_name = "a whip made modified with silver"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/natural/hide/cured,/obj/item/natural/hide/cured)
	created_item = /obj/item/weapon/whip/silver

/datum/anvil_recipe/weapons/silver/urumi
	name = "Silver Urumi (+1 Silver Bar)"
	recipe_name = "a Silver Urumi"
	additional_items = list(/obj/item/ingot/silver)
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/whip/urumi/silver

/datum/anvil_recipe/weapons/silver/sword_silver
	name = "Silver Sword"
	recipe_name = "a Silver Sword"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/silver

/datum/anvil_recipe/weapons/silver/sengese
	name = "Silver Sengese"
	recipe_name = "a Silver Sengese"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/scimitar/sengese/silver

/datum/anvil_recipe/weapons/silver/rapier_silver
	name = "Silver Rapier"
	recipe_name = "a Silver Rapier"
	appro_skill = /datum/skill/craft/weaponsmithing
	created_item = /obj/item/weapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/forgotten
	name = "Forgotten Blade (+Steel Bar)"
	recipe_name = "a Forgotten Blade"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/weapon/sword/long/forgotten

/datum/anvil_recipe/weapons/silver/declong
	name = "Decorated Silver Longsword (+Silver bar, +Gold bar)"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/gold)
	created_item = /obj/item/weapon/sword/long/decorated

/datum/anvil_recipe/weapons/silver/rungu
	name = "Silver Rungu (+ Stick)"
	recipe_name = "a Silver Rungu"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/weapon/mace/rungu/silver

/datum/anvil_recipe/weapons/silver/gada
	name = "Regal Gada (+1 Gold bar)"
	recipe_name = "a Regal Gada"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/mace/gada

/datum/anvil_recipe/weapons/silver/elvenclub
	name = "Regal Elven Club (+1 Gold bar)"
	recipe_name = "a Silver Elven Warclub"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/weapon/mace/elvenclub/silver

/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonian War Axe (+1 B. Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/axe/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"
/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonian Mace (+1 B. Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/mace/goden/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"
/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonian Spear (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/spear/psydon
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"
/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonian Dagger"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/knife/dagger/silver/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonian Shortsword"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/short/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonian Katar"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/katar/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonian Knuckles"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/knuckles/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonian Handmace"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/mace/cudgel/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonian Halberd (+1 B. Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/polearm/halberd/psydon
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonian Greatsword (+1 B. Silver)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/greatsword/psydon
	additional_items = list(/obj/item/ingot/silverblessed)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonian Sword"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/sword/long/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonian Whip (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 3
	created_item = /obj/item/weapon/whip/psydon
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/atgervi_shield
	name = "kite shield"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree)
	created_item = /obj/item/weapon/shield/atgervi
	i_type = "Shields"
	craftdiff = 2

/datum/anvil_recipe/weapons/atgervi_axe
	name = "Bearded axe"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/weapon/axe/steel/atgervi
	i_type = "Weapons"
	craftdiff = 3

/datum/anvil_recipe/weapons/mace/cane/noble
	name = "Decorated Cane (+ Gold Ingot + Large Log)"
	craftdiff = 3
	additional_items = list(/obj/item/ingot/gold, /obj/item/grown/log/tree)
	created_item = /obj/item/weapon/mace/cane/noble
	i_type = "Weapons"
