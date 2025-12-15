/datum/stock/import
	import_only = TRUE
	stable_price = TRUE

/datum/stock/import/crackers
	name = "Bin of Rations"
	desc = "Low moisture bread that keeps well."
	item_type = /obj/item/bin/crackers
	export_price = 100
	importexport_amt = 1

/obj/item/bin/crackers/Initialize()
	. = ..()
	for(var/i in 1 to 10)
		var/obj/item/reagent_containers/food/snacks/hardtack/new_hardtack = new()
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_hardtack, null, TRUE, FALSE))
			qdel(new_hardtack)

/obj/structure/closet/crate/chest/steward
	lock = /datum/lock/key/steward

/datum/stock/import/wheat
	name = "Crate of Wheat"
	desc = "Grains of wheat."
	item_type = /obj/structure/closet/crate/chest/steward/wheat
	export_price = 125
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/wheat/populate_contents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/food/snacks/produce/grain/wheat(src)

/datum/stock/import/watchman
	name = "City Watchman Equipment Crate"
	desc = "Starting kit for a new City Watchman."
	item_type = /obj/structure/closet/crate/chest/steward/townguard
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/townguard/populate_contents()
	new /obj/item/clothing/head/helmet/townwatch(src)
	new /obj/item/clothing/cloak/half/guard(src)
	new /obj/item/clothing/armor/gambeson(src)
	new	/obj/item/clothing/pants/trou/leather/guard(src)
	new /obj/item/clothing/shoes/boots(src)
	new /obj/item/clothing/neck/gorget(src)
	new /obj/item/weapon/mace/cudgel(src)

/datum/stock/import/maa
	name = "Man-at-Arms Equipment Crate"
	desc = "Starting kit for a new Man-at-Arms."
	item_type = /obj/structure/closet/crate/chest/steward/manatarms
	export_price = 350
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/manatarms/populate_contents()
	new /obj/item/clothing/head/helmet/kettle(src)
	new /obj/item/clothing/neck/chaincoif/iron(src)
	new /obj/item/clothing/cloak/stabard/guard(src)
	new /obj/item/clothing/armor/chainmail(src)
	new /obj/item/clothing/pants/trou/leather/guard(src)
	new /obj/item/clothing/shoes/boots(src)
	new /obj/item/weapon/knife/dagger/steel(src)
	new /obj/item/weapon/polearm/spear/billhook(src)

/datum/stock/import/crossbow
	name = "Crossbows Crate"
	desc = "A crate of 3 crossbows with 3 full quivers."
	item_type = /obj/structure/closet/crate/chest/steward/crossbow
	export_price = 400
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/crossbow/populate_contents()
	for(var/i in 1 to 3)
		new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
		new /obj/item/ammo_holder/quiver/bolts(src)

/datum/stock/import/saigabuck
	name = "Saigabuck"
	desc = "One tamed Saigabuck with a saddle from nearby lands."
	item_type = /obj/structure/closet/crate/chest/steward/saigabuck
	export_price = 250
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/saigabuck/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(src)

/datum/stock/import/cow
	name = "Cow"
	desc = "Farmer's best friend, reliable provider of milk and meat."
	item_type = /obj/structure/closet/crate/chest/steward/cow
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/cow/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/cow(src)

/datum/stock/import/bull
	name = "Bull"
	desc = "Horned and aggressive, required to start a herd."
	item_type = /obj/structure/closet/crate/chest/steward/bull
	export_price = 200
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/bull/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/bull(src)

/datum/stock/import/goat
	name = "Doe Goat"
	desc = "An all-purpose source of milk, hide and fat."
	item_type = /obj/structure/closet/crate/chest/steward/goat
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/goat/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/goat(src)

/datum/stock/import/goatmale
	name = "Billy Goat"
	desc = "Bearded, male goat capable of saddling."
	item_type = /obj/structure/closet/crate/chest/steward/goatmale
	export_price = 200
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/goatmale/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/goatmale(src)

/datum/stock/import/chicken
	name = "Chicken"
	desc = "A reliable source of egg and meat."
	item_type = /obj/structure/closet/crate/chest/steward/chicken
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/chicken/populate_contents()
	new /mob/living/simple_animal/hostile/retaliate/chicken(src)

/datum/stock/import/farmequip
	name = "Farm Equipment Crate"
	desc = "A starter crate with a pitchfork, sickle, hoe and some seeds."
	item_type = /obj/structure/closet/crate/chest/steward/farmequip
	export_price = 250
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/farmequip/populate_contents()
	new /obj/item/weapon/hoe(src)
	new /obj/item/weapon/pitchfork(src)
	new /obj/item/weapon/sickle(src)
	new /obj/item/neuFarm/seed/apple(src)
	new /obj/item/neuFarm/seed/wheat(src)
	new /obj/item/neuFarm/seed/berry(src)
