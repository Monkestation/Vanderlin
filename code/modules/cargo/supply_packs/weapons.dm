/datum/supply_pack/weapons
	group = "Weapons"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

// PRICESHEET: (this prices are based on aprox 1.5X before tax of prices of the player market at 11/08/25 )
// Leather = 20 per
// Iron = 30 per
// Steel = 50 per
// Wood = betwen 10-20
// essential items can be discounted because nobody even makes those anyways.
// any item can be little more or less , this is just a reference to not outcompete the smiths.


/datum/supply_pack/weapons/shield
	group = "Shields"

/datum/supply_pack/weapons/shield/wood
	name = "Wooden Shield"
	cost = 10
	contains = /obj/item/weapon/shield/wood

/datum/supply_pack/weapons/shield/towershield
	name = "Tower Shield"
	cost = 30
	contains = /obj/item/weapon/shield/tower

/datum/supply_pack/weapons/shield/iron
	name = "Iron Buckler"
	cost = 30
	contains = /obj/item/weapon/shield/tower/buckleriron

// IRON MELEE WEAPONS

/datum/supply_pack/weapons/iron
	group = "Weapons (Iron)"

/datum/supply_pack/weapons/iron/shortsword
	name = "Iron Short Sword"
	cost = 30
	contains = /obj/item/weapon/sword/short/iron

/datum/supply_pack/weapons/iron/sword_iron
	name = "Iron Arming Sword"
	cost = 35
	contains = /obj/item/weapon/sword/iron

/datum/supply_pack/weapons/iron/mace
	name = "Iron Mace"
	cost = 30
	contains = /obj/item/weapon/mace

/datum/supply_pack/weapons/iron/axe
	name = "Iron Axe"
	cost = 30
	contains = /obj/item/weapon/axe

/datum/supply_pack/weapons/iron/huntingknife
	name = "Iron Hunting Knife"
	cost = 20
	contains = /obj/item/weapon/knife/hunting

/datum/supply_pack/weapons/iron/dagger
	name = "Iron Dagger"
	cost = 20
	contains = /obj/item/weapon/knife/dagger

/datum/supply_pack/weapons/iron/spear
	name = "Iron Spear"
	cost = 30
	contains = /obj/item/weapon/polearm/spear

/datum/supply_pack/weapons/iron/flail
	name = "Military Flail"
	cost = 35
	contains = /obj/item/weapon/flail

/datum/supply_pack/weapons/iron/greatmace
	name = "Iron Warclub"
	cost = 60
	contains = /obj/item/weapon/mace/goden

/datum/supply_pack/weapons/iron/greatsword
	name = "Zweihander"
	cost = 70
	contains = /obj/item/weapon/sword/long/greatsword/zwei

/datum/supply_pack/weapons/iron/bardiche
	name = "Bardiche"
	cost = 70
	contains = /obj/item/weapon/polearm/halberd/bardiche

// STEEL MELEE WEAPONS

/datum/supply_pack/weapons/steel
	group = "Weapons (Steel)"

/datum/supply_pack/weapons/steel/sword
	name = "Steel Arming Sword"
	cost = 50
	contains = /obj/item/weapon/sword

/datum/supply_pack/weapons/steel/smace
	name = "Flanged Steel Mace"
	cost = 50
	contains = /obj/item/weapon/mace/steel

/datum/supply_pack/weapons/steel/saxe
	name = "Steel Axe"
	cost = 50
	contains = /obj/item/weapon/axe/steel

/datum/supply_pack/weapons/steel/baxe
	name = "Battle Axe"
	cost = 60
	contains = /obj/item/weapon/axe/battle

/datum/supply_pack/weapons/steel/sdagger
	name = "Steel Dagger"
	cost = 26
	contains = /obj/item/weapon/knife/dagger/steel

/datum/supply_pack/weapons/steel/sflail
	name = "Steel Flail"
	cost = 32
	contains = /obj/item/weapon/flail/sflail

/datum/supply_pack/weapons/steel/greatmace
	name = "Steel Greatmace"
	cost = 120
	contains = /obj/item/weapon/mace/goden/steel

/datum/supply_pack/weapons/steel/greatsword
	name = "Steel Greatsword"
	cost = 150
	contains = /obj/item/weapon/sword/long/greatsword

/datum/supply_pack/weapons/steel/halberd
	name = "Halberd"
	cost = 120 // no more free money
	contains = /obj/item/weapon/polearm/halberd

/*
/datum/supply_pack/weapons/nets
	name = "Throwing Net"
	cost = 15
	contains = list(/obj/item/net,
			/obj/item/net,
			/obj/item/net)
*/

// RANGED WEAPONS (ALL TOGETHER)
/datum/supply_pack/weapons/ranged
	group = "Weapons (Ranged)"

/datum/supply_pack/weapons/ranged/puffer
	name = "Smuggled Püffer"
	cost = 800
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol

/datum/supply_pack/weapons/ranged/crossbow
	name = "Crossbow"
	cost = 50
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/supply_pack/weapons/ranged/bow
	name = "Hunting Bow"
	cost = 30
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

/datum/supply_pack/weapons/ranged/longbow
	name = "Longbow"
	cost = 40
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long

/datum/supply_pack/weapons/ranged/shortbow
	name = "Imported Short Bow"
	cost = 40
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short

/datum/supply_pack/weapons/ranged/tossbladeiron
	name = "Iron Tossblade Belt"
	cost = 30
	contains = /obj/item/storage/belt/leather/knifebelt/black/iron

/datum/supply_pack/weapons/ranged/tossbladesteel
	name = "Steel Tossblade Belt"
	cost = 40
	contains = /obj/item/storage/belt/leather/knifebelt/black/steel

/datum/supply_pack/weapons/ranged/whip
	name = "Leather Whip"
	cost = 20
	contains = /obj/item/weapon/whip

/datum/supply_pack/weapons/ranged/bomb
	name = "Bottle Bomb"
	cost = 40
	contains = /obj/item/explosive/bottle/homemade

// AMMO & Quivers (for ranged)

/datum/supply_pack/weapons/ammo
	group = "Ammunition"

/datum/supply_pack/weapons/ammo/Blowpouch
	name = "Empty Dart Pouch"
	cost = 15 // this is so unused i will just leave it cheap ngl
	contains = /obj/item/ammo_holder/dartpouch

/datum/supply_pack/weapons/ammo/quivers
	name = "Empty Quiver"
	cost = 25
	contains = /obj/item/ammo_holder/quiver

/datum/supply_pack/weapons/ammo/arrowquiver
	name = "Quiver of Arrows"
	cost = 40
	contains = /obj/item/ammo_holder/quiver/arrows

/datum/supply_pack/weapons/ammo/boltquiver
	name = "Quiver of Bolts"
	cost = 40
	contains = /obj/item/ammo_holder/quiver/bolts

/datum/supply_pack/weapons/ammo/bullets
	name = "Pouch of Lead Bullets"
	cost = 60
	contains = /obj/item/storage/belt/pouch/bullets

/datum/supply_pack/weapons/ammo/bullets
	name = "Gunpowder Flask"
	cost = 120
	contains = /obj/item/reagent_containers/glass/bottle/aflask

/datum/supply_pack/weapons/ammo/arrows
	name = "Arrow x10"
	cost = 30
	contains = list(/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/arrow,
					/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/arrow,
					/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/arrow,
					/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/arrow,
					/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/arrow,
					)

/datum/supply_pack/weapons/ammo/bolts
	name = "Crossbow Bolt x10"
	cost = 30
	contains = list(/obj/item/ammo_casing/caseless/bolt, /obj/item/ammo_casing/caseless/bolt,
					/obj/item/ammo_casing/caseless/bolt, /obj/item/ammo_casing/caseless/bolt,
					/obj/item/ammo_casing/caseless/bolt, /obj/item/ammo_casing/caseless/bolt,
					/obj/item/ammo_casing/caseless/bolt, /obj/item/ammo_casing/caseless/bolt,
					/obj/item/ammo_casing/caseless/bolt, /obj/item/ammo_casing/caseless/bolt,
					) // insanity

