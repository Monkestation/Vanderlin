/datum/repeatable_crafting_recipe/leather
	abstract_type = /datum/repeatable_crafting_recipe/leather
	requirements = list(
		/obj/item/natural/hide/cured = 1
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)

	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/hide/cured
	skillcraft = /datum/attribute/skill/craft/tanning
	craftdiff = 0
	subtypes_allowed = TRUE // so you can use any subtype of fur
	category = "Leatherworking"

/// Storage ///
/datum/repeatable_crafting_recipe/leather/storage
	abstract_type = /datum/repeatable_crafting_recipe/leather/storage
	attacked_atom = /obj/machinery/tanningrack
	category = "Storage"
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/storage/quiver
	name = "quiver"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/quiver

/datum/repeatable_crafting_recipe/leather/storage/javelin
	name = "javelin sheath"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/javelin

/datum/repeatable_crafting_recipe/leather/storage/dartpouch
	name = "dart pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/dartpouch

/datum/repeatable_crafting_recipe/leather/storage/bulletpouch
	name = "bullet pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/bullet

/datum/repeatable_crafting_recipe/leather/storage/magepouch
	name = "summoners pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/storage/magebag

/datum/repeatable_crafting_recipe/leather/storage/meatbag
	name = "game satchel"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/storage/meatbag

/datum/repeatable_crafting_recipe/leather/storage/waterskin
	name = "waterskin"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/reagent_containers/glass/bottle/waterskin
	craftdiff = 0

/datum/repeatable_crafting_recipe/leather/storage/pouch
	name = "leather pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 1,
	)
	output = /obj/item/storage/belt/pouch
	sellprice = 6

/datum/repeatable_crafting_recipe/leather/storage/satchel
	name = "leather satchel"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/rope = 1,
	)
	output = /obj/item/storage/backpack/satchel
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/storage/satchel/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/leather/storage/backpack
	name = "leather backpack"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/rope = 1,
	)
	output = /obj/item/storage/backpack/backpack
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/storage/backpack/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/leather/storage/orebag
	name = "miner's satchel"
	requirements = list(
		/obj/item/natural/hide/cured= 3,
		/obj/item/rope = 1,
	)
	output = /obj/item/storage/hip/orebag
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/storage/orebag/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/leather/storage/knife_sheath
	name = "knife sheath"
	output = /obj/item/weapon/scabbard/knife
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/storage/sword_scabbard
	name = "scabbard"
	output = /obj/item/weapon/scabbard/sword
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1,
	)
	craftdiff = 2

/// Misc Leatherworking
/datum/repeatable_crafting_recipe/leather/bedsheetpelt
	name = "leather bedsheet"
	output = /obj/item/bedsheet/pelt
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/cloth = 1)
	craftdiff = 1
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/double_bedsheetpelt
	name = "large leather bedsheet"
	output = /obj/item/bedsheet/double_pelt
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/cloth = 2)
	craftdiff = 2
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/sleepingbag_deluxe
	name = "deluxe bedroll"
	output = /obj/item/sleepingbag/deluxe
	attacked_atom = /obj/machinery/tanningrack
	requirements =  list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)
	craftdiff = 2
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/sleepingbag_deluxe/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/leather/saddle
	name = "saddle"
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/natural/saddle
	craftdiff = 1
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/ball
	name = "ball"
	output = /obj/item/child_toy/ball
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/cloth = 1)
	craftdiff = 2
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/whip
	name = "leather whip"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers/sinew = 1,
	)
	output = /obj/item/weapon/whip
	craftdiff = 1

/// Clothing

/// Gloves
/datum/repeatable_crafting_recipe/leather/gloves
	name = "leather gloves"
	output = /obj/item/clothing/gloves/leather
	craftdiff = 1
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/gloves/fur
	name = "fur-lined leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1
	)
	output = /obj/item/clothing/gloves/leather/feld

/datum/repeatable_crafting_recipe/leather/gloves/fencer
	name = "fencing gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/fencer
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/gloves/fencer/duelist
	name = "dueslist gloves"
	output = /obj/item/clothing/gloves/leather/duelgloves

/datum/repeatable_crafting_recipe/leather/gloves/fencer/feld
	name = "feldsher gloves"
	output = /obj/item/clothing/gloves/leather/feld

/datum/repeatable_crafting_recipe/leather/gloves/fencer/phys
	name = "physicker gloves"
	output = /obj/item/clothing/gloves/leather/phys

/datum/repeatable_crafting_recipe/leather/gloves/fencer/apothecary
	name = "apothecary gloves"
	output = /obj/item/clothing/gloves/leather/apothecary

/datum/repeatable_crafting_recipe/leather/gloves/heavy
	name = "heavy leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1
	)
	output = /obj/item/clothing/gloves/angle
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/gloves/grenzelheavy
	name = "grenzelhoftian heavy leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1
	)
	output = /obj/item/clothing/gloves/angle/grenzel

/datum/repeatable_crafting_recipe/leather/gloves/heavy/grenzel
	name = "grenzelhoftian gloves"
	output = /obj/item/clothing/gloves/leather/grenzel
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/gloves/heavy/inquisitor
	name = "inquisitor gloves"
	output = /obj/item/clothing/gloves/leather/grenzel/inqgloves
	craftdiff = 4

/// Pants
/datum/repeatable_crafting_recipe/leather/pants
	name = "work trousers"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/pants/trou/apothecary
	category = "Pants"

/datum/repeatable_crafting_recipe/leather/pants/fur
	name = "fur trousers"
	requirements = list(
		/obj/item/natural/fur = 2,
		/obj/item/natural/hide/cured = 1
	)
	output = /obj/item/clothing/pants/trou/artipants

/datum/repeatable_crafting_recipe/leather/pants/leather_tights
	name = "leather tights"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/pants/trou/leathertights

/datum/repeatable_crafting_recipe/leather/pants/apothecary_pants
	name = "apothecary trousers"
	output = /obj/item/clothing/pants/trou/apothecary

/datum/repeatable_crafting_recipe/leather/pants/artipants
	name = "artificer trousers"
	output = /obj/item/clothing/pants/trou/artipants

/datum/repeatable_crafting_recipe/leather/pants/beltpants
	name = "belt pants"
	output = /obj/item/clothing/pants/trou/beltpants

/datum/repeatable_crafting_recipe/leather/bracers
	name = "leather bracers"
	output_amount = 2
	output = /obj/item/clothing/wrists/bracers/leather

/datum/repeatable_crafting_recipe/leather/pants
	name = "leather pants"
	output = /obj/item/clothing/pants/trou/leather

/datum/repeatable_crafting_recipe/leather/pants/mourning
	name = "mourning pants"
	output = /obj/item/clothing/pants/trou/leather/mourning

/datum/repeatable_crafting_recipe/leather/pants/shepherd
	name = "shepherd's pants"
	output = /obj/item/clothing/pants/trou/leather/shepherd

/// shoes
/datum/repeatable_crafting_recipe/leather/shoes
	name = "leather shoes"
	output_amount = 2
	output = /obj/item/clothing/shoes/simpleshoes
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/shoes/buckle
	name = "leather buckle shoes"
	output = /obj/item/clothing/shoes/simpleshoes/buckle

/datum/repeatable_crafting_recipe/leather/shoes/rumaclan
	name = "raised sandals"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/grown/log/tree/small = 1
	)
	output = /obj/item/clothing/shoes/rumaclan
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/shoes/sandals
	name = "sandals"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/sandals

/datum/repeatable_crafting_recipe/leather/shoes/sandals/gladiator
	name = "caligae"
	output = /obj/item/clothing/shoes/gladiator
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/shoes/jester
	name = "jester shoes"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/jester
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/shoes/jester/babouche
	name = "babouche"
	output = /obj/item/clothing/shoes/shalal

/// boots

/datum/repeatable_crafting_recipe/leather/boots
	name = "leather boots"
	output = /obj/item/clothing/shoes/boots/leather
	category = "Boots"
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/boots/furlined
	name = "fur-lined leather boots"
	requirements = list(
		/obj/item/natural/fur = 1,
		/obj/item/natural/hide/cured = 1
	)
	output = /obj/item/clothing/shoes/boots/leather/furlined

/datum/repeatable_crafting_recipe/leather/boots/furlined/anklets
	name = "fur lined anklets"
	output = /obj/item/clothing/shoes/boots/furlinedanklets

/datum/repeatable_crafting_recipe/leather/furboots
	name = "fur lined boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
	)
	output = /obj/item/clothing/shoes/boots/furlinedboots
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/boots/short
	name = "shortboots"
	output = /obj/item/clothing/shoes/shortboots

/datum/repeatable_crafting_recipe/leather/boots/dark
	name = "dark boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/cloth = 1
	)
	output = /obj/item/clothing/shoes/boots/darkboots
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/boots/riding
	name = "riding boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1
	)
	output = /obj/item/clothing/shoes/ridingboots
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/boots/riding/psydon
	name = "enduring boots"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers/sinew = 1
	)
	output = /obj/item/clothing/shoes/psydonboots

/datum/repeatable_crafting_recipe/leather/boots/riding/apothecary
	name = "leather apothecary boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2
	)
	output = /obj/item/clothing/shoes/apothboots

/datum/repeatable_crafting_recipe/leather/boots/riding/grenzel
	name = "grenzelhoftian boots"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/grenzel

/datum/repeatable_crafting_recipe/leather/boots/fencer
	name = "fencing boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/boots/fencer
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/boots/fencer/grenzelhoft
	name = "grenzelhoftian leather boots"
	output = /obj/item/clothing/shoes/rare/grenzelhoft

/datum/repeatable_crafting_recipe/leather/boots/fencer/noble
	name = "noble boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 2
	)
	output = /obj/item/clothing/shoes/nobleboot

/datum/repeatable_crafting_recipe/leather/boots/fencer/hunter
	name = "hunting boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
		/obj/item/natural/fibers/sinew = 2
	)
	output = /obj/item/clothing/shoes/boots/hunter

/datum/repeatable_crafting_recipe/leather/boots/fencer/watch
	name = "watch boots"
	requirements = list(
	/obj/item/natural/hide/cured = 2,
	/obj/item/natural/fibers = 1,
	/obj/item/ingot/iron = 1
	)
	output = /obj/item/clothing/shoes/boots/leather/advanced/watch

/datum/repeatable_crafting_recipe/leather/boots/fencer/duelist
	name = "leather duelist boots"
	output = /obj/item/clothing/shoes/nobleboot/duelboots

/datum/repeatable_crafting_recipe/leather/boots/fencer/thigh
	name = "leather thigh boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2
	)
	output = /obj/item/clothing/shoes/nobleboot/thighboots

/datum/repeatable_crafting_recipe/leather/boots/inqboots
	name = "inquisitorial boots"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/grenzel/inqboots
	craftdiff = 5

/// Cloaks

/datum/repeatable_crafting_recipe/leather/cloak
	name = "leather raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/cloak/raincloak
	craftdiff = 2
	category = "Cloak"

/datum/repeatable_crafting_recipe/leather/cloak/bandolier
	name = "bandolier"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/rope = 1,
	)
	output = /obj/item/clothing/cloak/bandolier

/datum/repeatable_crafting_recipe/leather/cloak/fur
	name = "fur lined raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/cloak/raincloak/furcloak

/datum/repeatable_crafting_recipe/leather/cloak/forrester
	name = "forrester cloak"
	output = /obj/item/clothing/cloak/forrestercloak
	requirements = list(
		/obj/item/natural/fibers/sinew = 1,
		/obj/item/natural/fur = 1,
		/obj/item/natural/hide/cured = 2
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/cloak/forrester/snow
	name = "forrester cloak (snow)"
	output = /obj/item/clothing/cloak/forrestercloak/snow

/datum/repeatable_crafting_recipe/leather/cloak/battlenun
	name = "battlenun cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/silk = 1
	)
	output = /obj/item/clothing/cloak/battlenun
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/cloak/battlenun/graggar
	name = "vicious cloak"
	output = /obj/item/clothing/cloak/graggar
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/cloak/battlenun/graggar/heavy
	name = "heavy vicious cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/natural/silk = 1,
	)
	output = /obj/item/clothing/cloak/graggar/heavy

/datum/repeatable_crafting_recipe/leather/cloak/savage
	name = "savage cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers/sinew = 1,
	)
	output = /obj/item/clothing/cloak/savage
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/cloak/fur/black
	name = "fur lined black cloak"
	output = /obj/item/clothing/cloak/black_cloak
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/cloak/lord
	name = "lordly cloak"
	output = /obj/item/clothing/cloak/lordcloak
	requirements = list(
		/obj/item/natural/fur = 2,
		/obj/item/natural/hide/cured = 4
	)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/cloak/lord/lady
	name = "lady cloak"
	output = /obj/item/clothing/cloak/lordcloak/ladycloak

/datum/repeatable_crafting_recipe/leather/cloak/warden
	name = "warden cloak"
	output = /obj/item/clothing/cloak/wardencloak
	requirements = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/hide/cured = 2
	)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/cloak/warden/red
	name = "red cloak"
	output = /obj/item/clothing/cloak/heartfelt
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/cloak/captain
	name = "captain cloak"
	output = /obj/item/clothing/cloak/captain
	requirements = list(
		/obj/item/natural/silk = 3,
		/obj/item/natural/hide/cured = 2
	)
	craftdiff = 6

/datum/repeatable_crafting_recipe/leather/cloak/battlenun/matron
	name = "matron cloak"
	output = /obj/item/clothing/cloak/matron
	craftdiff = 6

/// Belts

/datum/repeatable_crafting_recipe/leather/belt
	name = "leather belt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/storage/belt/leather
	craftdiff = 2
	category = "Belt"

/datum/repeatable_crafting_recipe/leather/belt/black
	name = "black leather belt"
	output = /obj/item/storage/belt/leather/black

/datum/repeatable_crafting_recipe/leather/belt/shalal
	name = "shalal leather belt"
	output = /obj/item/storage/belt/leather/shalal

/datum/repeatable_crafting_recipe/leather/belt/breechloth
	name = "leather belt with breechloth"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 2
	)
	output = /obj/item/storage/belt/leather/breechcloth

/datum/repeatable_crafting_recipe/leather/belt/breechloth/black
	name = "black leather belt with breechloth"
	output = /obj/item/storage/belt/leather/breechcloth/blackbelt

/datum/repeatable_crafting_recipe/leather/belt/plaquesilver
	name = "silver plaque belt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/ingot/silver = 1
	)
	craftdiff = 3
	output = /obj/item/storage/belt/leather/plaquesilver

/datum/repeatable_crafting_recipe/leather/belt/plaquesilver/plaquegold
	name = "gold plaque belt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/ingot/gold = 1,
	)
	output = /obj/item/storage/belt/leather/plaquegold

/datum/repeatable_crafting_recipe/leather/belt/suspenders
	name = "suspenders"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/storage/belt/leather/suspenders
	craftdiff = 3

/// Head pieces
/datum/repeatable_crafting_recipe/leather/helmet
	name = "leather helmet"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather
	craftdiff = 1
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/helmet/hardened_conical
	name = "hardened conical helmet"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/ingot/iron = 1,
	)
	output = /obj/item/clothing/head/helmet/leather/conical
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/helmet/ominous_hood
	name = "ominous hood"
	output = /obj/item/clothing/head/helmet/leather/hood_ominous
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/coif
	name = "leather coif"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/neck/coif
	craftdiff = 1
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/coif/headscarf
	name = "headscarf"
	output = /obj/item/clothing/head/helmet/leather/headscarf
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/coif/adept_cowl
	name = "adept cowl"
	output = /obj/item/clothing/head/adeptcowl
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/coif/jester
	name = "jester hat"
	output = /obj/item/clothing/head/jester
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/hat
	name = "brimmed hat"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/head/brimmed
	craftdiff = 1
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/hat/court_physician_hat
	name = "court physician hat"
	output = /obj/item/clothing/head/physhat

/datum/repeatable_crafting_recipe/leather/hat/buckled
	name = "buckled hat"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
	)
	output = /obj/item/clothing/head/helmet/leather/inquisitor
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/hat/inquisitor
	name = "inquisitorial hat"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/feather = 1,
	)
	output = /obj/item/clothing/head/leather/inqhat
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/hat/inquisitor/gravetender
	name = "gravetender's hat"
	output = /obj/item/clothing/head/leather/inqhat/gravehat
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/hat/tricorn
	name = "tricorn (black)"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather/tricorn
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/hat/inquisitor/duel
	name = "duelist hat"
	output = /obj/item/clothing/head/leather/duelhat
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/hat/top
	name = "top hat"
	output = /obj/item/clothing/head/tophat
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 4

/// Chest pieces
/datum/repeatable_crafting_recipe/leather/corset
	name = "corset"
	output = /obj/item/clothing/armor/corset
	category = "Shirt"

/datum/repeatable_crafting_recipe/leather/apothecary
	name = "apothecary shirt"
	output = /obj/item/clothing/shirt/apothshirt
	craftdiff = 3
	category = "Shirt"

/datum/repeatable_crafting_recipe/leather/vest
	name = "leather vest"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/vest
	craftdiff = 2
	category = "Shirt"

/datum/repeatable_crafting_recipe/leather/vest/jester
	name = "jester's tunick"
	output = /obj/item/clothing/shirt/jester
	craftdiff = 3"

/datum/repeatable_crafting_recipe/leather/jacket
	name = "leather jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/jacket
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/jacket/sea
	name = "sea jacket"
	output = /obj/item/clothing/armor/leather/jacket/sea
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/jacket/coat
	name = "leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/jacket/coat/black // never add items with the same names
	name = "black leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/black

/datum/repeatable_crafting_recipe/leather/apron
	name = "leather apron"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/cloak/apron/brown
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/armor
	name = "leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather
	craftdiff = 1
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/armor/hidearmor
	name = "fur lined leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1
	)
	output = /obj/item/clothing/armor/leather/hide
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/armor/hidearmor/steppe
	name = "frontier fur lined leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
		/obj/item/natural/fibers/sinew = 1,
	)
	output = /obj/item/clothing/armor/leather/hide/steppe

/datum/repeatable_crafting_recipe/leather/jerkin
	name = "leather jerkin"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers/sinew = 1
	)
	output = /obj/item/clothing/armor/leather/jerkin
	craftdiff = 3
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/jerkin/belted
	name = "belted leather jerkin"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers/sinew = 1
	)
	output = /obj/item/clothing/armor/leather/jerkin/belted
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/jerkin/belted/long
	name = "leather jerkin coat"
	output = /obj/item/clothing/armor/leather/jerkin/belted/long
	craftdiff = 5

/// Standalones

/datum/repeatable_crafting_recipe/leather/leathercollar
	name = "leather collar"
	output = /obj/item/clothing/neck/leathercollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 2
	category = "Neck"

/datum/repeatable_crafting_recipe/leather/bellcollar
	name = "bell collar"
	output = /obj/item/clothing/neck/bellcollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/jingle_bells = 1)
	craftdiff = 2
	category = "Neck"

/datum/repeatable_crafting_recipe/leather/standalone
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/boots
	name = "hardened leather boots"
	output = /obj/item/clothing/shoes/boots/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/fencerboots
	name = "fencing boots"
	output = /obj/item/clothing/shoes/boots/fencer
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/furboots
	name = "hardened fur lined boots"
	output = /obj/item/clothing/shoes/boots/furlinedboots/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 2,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/standalone/gatemaster_coat
	name = "gatemaster's coat"
	output = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket
	requirements = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/gatemaster_coat_armored
	name = "gatemaster's coat (armored)"
	output = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
	requirements = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/ingot/iron)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_bracers
	name = "hardened leather bracers"
	output = /obj/item/clothing/wrists/bracers/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/bracer_scabbard
	name = "knife-sheath bracers"
	output = /obj/item/clothing/wrists/bracers/leather/scabbard
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	category = "Wrists"

/datum/repeatable_crafting_recipe/leather/standalone/leather_duelcoat
	name = "leather duelist coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_renegade_coat
	name = "leather renegade coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/apothecary_overcoat
	name = "apothecary overcoat"
	output = /obj/item/clothing/armor/gambeson/apothecary
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/steward_coat
	name = "steward coat"
	output = /obj/item/clothing/armor/gambeson/steward
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/huntergamb
	name = "hunting gambeson"
	output = /obj/item/clothing/armor/gambeson/hunts
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers/sinew = 1,
		/obj/item/clothing/armor/gambeson = 1
	)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/gloves
	name = "hardened leather gloves"
	output = /obj/item/clothing/gloves/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/standalone/heavygloves
	name = "hardened heavy leather gloves"
	output = /obj/item/clothing/gloves/angle/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/fibers/sinew = 1,
	)
	craftdiff = 4
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/standalone/atgervi_gloves_advanced
	name = "hardened fur-lined leather gloves"
	output = /obj/item/clothing/gloves/angle/furlined/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/standalone/coat
	name = "hardened leather armor"
	output = /obj/item/clothing/armor/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/fencercoat
	name = "fencing coat"
	output = /obj/item/clothing/armor/leather/fencer
	requirements = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/shaman_coat
	name = "hardened shamanic coat"
	output = /obj/item/clothing/armor/leather/shamancoat/advanced
	requirements = list(
			/obj/item/natural/hide/cured = 2,
			/obj/item/natural/fur = 2,
			/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/hidearmor
	name = "hardened fur lined leather armor"
	output = /obj/item/clothing/armor/leather/hide/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
			/obj/item/natural/fur = 1,
			/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/steppe
	name = "hardened frontier fur lined leather armor"
	output = /obj/item/clothing/armor/leather/hide/steppe/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
			/obj/item/natural/fur = 2,
			/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/inquisitor_duster
	name = "inquisitorial duster"
	output = /obj/item/clothing/armor/medium/scale/inqcoat
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/clothing/armor/medium/scale = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/coat/forest
	name = "forrester leather armor"
	output = /obj/item/clothing/armor/leather/advanced/forrester
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/helmet
	name = "hardened leather helmet"
	output = /obj/item/clothing/head/helmet/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leatherhood
	name = "hardened leather hood"
	output = /obj/item/clothing/head/roguehood/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
			/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/standalone/chausses
	name = "hardened leather trousers"
	output = /obj/item/clothing/pants/trou/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/fur_pants/advanced
	name = "hardened fur trousers"
	output = /obj/item/clothing/pants/trou/leather/furpants/advanced
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers/sinew = 1,)
	craftdiff = 4

/// MASTERWORK

/datum/repeatable_crafting_recipe/leather/standalone/boots/masterwork
	name = "masterwork leather boots"
	output = /obj/item/clothing/shoes/boots/leather/masterwork
	attacked_atom = /obj/item/clothing/shoes/boots/leather
	requirements = list(/obj/item/clothing/shoes/boots/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/furboots/masterwork
	name = "masterwork fur lined boots"
	output = /obj/item/clothing/shoes/boots/furlinedboots/masterwork
	attacked_atom = /obj/item/clothing/shoes/boots/furlinedboots
	requirements = list(/obj/item/clothing/shoes/boots/furlinedboots = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/hunterboots/masterwork
	name = "masterwork hunting boots"
	output = /obj/item/clothing/shoes/boots/hunter/masterwork
	attacked_atom = /obj/item/clothing/shoes/boots/hunter
	requirements = list(/obj/item/clothing/shoes/boots/hunter = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 2)
	craftdiff = 5
	category = "Special Leather"


/datum/repeatable_crafting_recipe/leather/standalone/gloves/masterwork
	name = "masterwork leather gloves"
	output = /obj/item/clothing/gloves/leather/masterwork
	attacked_atom = /obj/item/clothing/gloves/leather
	requirements = list(/obj/item/clothing/gloves/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/heavygloves/masterwork
	name = "masterwork heavy leather gloves"
	output = /obj/item/clothing/gloves/angle/masterwork
	attacked_atom = /obj/item/clothing/gloves/angle
	requirements = list(/obj/item/clothing/gloves/angle = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/atgervi_gloves_masterwork
	name = "masterwork fur-lined leather gloves"
	output = /obj/item/clothing/gloves/angle/furlined/masterwork
	attacked_atom = /obj/item/clothing/gloves/angle/furlined
	requirements = list(/obj/item/clothing/gloves/angle/furlined = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/bracers
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone/bracers

/datum/repeatable_crafting_recipe/leather/standalone/bracers/masterwork
	name = "masterwork leather bracers"
	output = /obj/item/clothing/wrists/bracers/leather/masterwork
	attacked_atom = /obj/item/clothing/wrists/bracers/leather
	requirements = list(/obj/item/clothing/wrists/bracers/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/coat/masterwork
	name = "masterwork leather armor"
	output = /obj/item/clothing/armor/leather/masterwork
	attacked_atom = /obj/item/clothing/armor/leather
	requirements = list(/obj/item/clothing/armor/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/forest_masterwork
	name = "masterwork forrester's armor"
	output = /obj/item/clothing/armor/leather/advanced/forrester/masterwork
	attacked_atom = /obj/item/clothing/armor/leather/advanced/forrester
	requirements = list(/obj/item/clothing/armor/leather/advanced/forrester = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 2)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/hidearmor/masterwork
	name = "masterwork fur lined leather armor"
	output = /obj/item/clothing/armor/leather/hide/masterwork
	attacked_atom = /obj/item/clothing/armor/leather/hide
	requirements = list(/obj/item/clothing/armor/leather/hide = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/steppe/masterwork
	name = "masterwork frontier fur lined leather armor"
	output = /obj/item/clothing/armor/leather/hide/steppe/masterwork
	attacked_atom = /obj/item/clothing/armor/leather/hide
	requirements = list(/obj/item/clothing/armor/leather/hide/steppe = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/atgervi_coat_masterwork
	name = "masterwork shamanic coat"
	output = /obj/item/clothing/armor/leather/shamancoat/masterwork
	attacked_atom = /obj/item/clothing/armor/leather/shamancoat
	requirements = list(/obj/item/clothing/armor/leather/shamancoat = 1,
			/obj/item/natural/cured/essence = 1,
			/obj/item/natural/fibers/sinew = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/helmet/masterwork
	name = "masterwork leather helmet"
	output = /obj/item/clothing/head/helmet/leather/masterwork
	attacked_atom = /obj/item/clothing/head/helmet/leather
	requirements = list(/obj/item/clothing/head/helmet/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/leatherhood/masterwork
	name = "masterwork leather hood"
	output = /obj/item/clothing/head/roguehood/leather/masterwork
	attacked_atom = /obj/item/clothing/head/roguehood/leather
	requirements = list(/obj/item/clothing/head/roguehood/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/chausses/masterwork
	name = "masterwork leather trousers"
	output = /obj/item/clothing/pants/trou/leather/masterwork
	attacked_atom = /obj/item/clothing/pants/trou/leather
	requirements = list(/obj/item/clothing/pants/trou/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/atgervi_pants_masterwork
	name = "masterwork fur trousers"
	output = /obj/item/clothing/pants/trou/leather/furpants/masterwork
	attacked_atom = /obj/item/clothing/pants/trou/leather/furpants
	requirements = list(/obj/item/clothing/pants/trou/leather/furpants = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers/sinew = 1,)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/shaman_coat
	name = "shamanic coat"
	output = /obj/item/clothing/armor/leather/shamancoat
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2
	)
	craftdiff = 2
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/moose_hood
	name = "moose hood"
	output = /obj/item/clothing/head/helmet/leather/saiga/moose
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/alch/bone = 2 // For antlers
	)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/psyaltrist
	name = "cuir-bouilli armor"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/ingot/iron = 1,
	)
	output = /obj/item/clothing/armor/leather/studded/psyaltrist
	craftdiff = 3
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/leatherhood
	name = "leather hood"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers/sinew = 1,
	)
	output = /obj/item/clothing/head/roguehood/leather
	craftdiff = 2
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/studdedleatherhood
	name = "studded leather hood"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers/sinew = 1,
	)
	output = /obj/item/clothing/head/roguehood/studded
	craftdiff = 2
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/studdedleatherhoodretinue
	name = "guard studded leather hood"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/clothing/head/roguehood/studded/retinue
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/sanguinejacket
	name = "sanguine jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 3
	)
	output = /obj/item/clothing/armor/leather/jacket/courtphysician/female
	craftdiff = 3
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/sanguinegloves
	name = "sanguine gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2
	)
	output = /obj/item/clothing/gloves/leather/courtphysician
	craftdiff = 3
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/sanguinesleeves
	name = "sanguine sleeves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/silk = 2,
	)
	output = /obj/item/clothing/gloves/leather/courtphysician/female
	craftdiff = 3
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/sanguinecoat
	name = "sanguine coat"
	requirements = list(
		/obj/item/natural/hide/cured = 3
	)
	output = /obj/item/clothing/armor/leather/jacket/courtphysician
	craftdiff = 3
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/sanguineshoes
	name = "sanguine shoes"
	requirements = list(
		/obj/item/natural/hide/cured = 2
	)
	output = /obj/item/clothing/shoes/courtphysician
	craftdiff = 3
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/sanguineheels
	name = "sanguine heels"
	requirements = list(
		/obj/item/natural/hide/cured = 2
	)
	output = /obj/item/clothing/shoes/courtphysician/female
	craftdiff = 3
	category = "Shoes"

// wintermare gloves

/datum/repeatable_crafting_recipe/leather/rosagloves
	name = "ivory gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/silk = 2
	)
	output = /obj/item/clothing/gloves/leather/rosa
	craftdiff = 5
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/rosagloves/two
	name = "scarlet gloves"
	output = /obj/item/clothing/gloves/leather/rosa/two

/datum/repeatable_crafting_recipe/leather/rosagloves/three
	name = "velvet gloves"
	output = /obj/item/clothing/gloves/leather/rosa/three

/datum/repeatable_crafting_recipe/leather/rosagloves/four
	name = "obsidian gloves"
	output = /obj/item/clothing/gloves/leather/rosa/four

/datum/repeatable_crafting_recipe/leather/rosagloves/five
	name = "sable gloves"
	output = /obj/item/clothing/gloves/leather/rosa/five

/datum/repeatable_crafting_recipe/leather/rosagloves/six
	name = "maroon gloves"
	output = /obj/item/clothing/gloves/leather/rosa/six

/datum/repeatable_crafting_recipe/leather/rosagloves/seven
	name = "regal gloves"
	output = /obj/item/clothing/gloves/leather/rosa/seven

/datum/repeatable_crafting_recipe/leather/rosagloves/eight
	name = "courtly gloves"
	output = /obj/item/clothing/gloves/leather/rosa/eight

/datum/repeatable_crafting_recipe/leather/rosagloves/nine
	name = "royal gloves"
	output = /obj/item/clothing/gloves/leather/rosa/nine

/datum/repeatable_crafting_recipe/leather/rosagloves/ten
	name = "stately gloves"
	output = /obj/item/clothing/gloves/leather/rosa/ten

// wintermare shoes

/datum/repeatable_crafting_recipe/leather/rosashoes
	name = "ivory shoes"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/silk = 2
	)
	output = /obj/item/clothing/shoes/boots/rosa
	craftdiff = 5
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/rosashoes/two
	name = "scarlet shoes"
	output = /obj/item/clothing/shoes/boots/rosa/two

/datum/repeatable_crafting_recipe/leather/rosashoes/three
	name = "velvet shoes"
	output = /obj/item/clothing/shoes/boots/rosa/three

/datum/repeatable_crafting_recipe/leather/rosashoes/four
	name = "obsidian shoes"
	output = /obj/item/clothing/shoes/boots/rosa/four

/datum/repeatable_crafting_recipe/leather/rosashoes/five
	name = "sable shoes"
	output = /obj/item/clothing/shoes/boots/rosa/five

/datum/repeatable_crafting_recipe/leather/rosashoes/six
	name = "maroon shoes"
	output = /obj/item/clothing/shoes/boots/rosa/six

/datum/repeatable_crafting_recipe/leather/rosashoes/seven
	name = "regal shoes"
	output = /obj/item/clothing/shoes/boots/rosa/seven

/datum/repeatable_crafting_recipe/leather/rosashoes/eight
	name = "courtly shoes"
	output = /obj/item/clothing/shoes/boots/rosa/eight

/datum/repeatable_crafting_recipe/leather/rosashoes/nine
	name = "royal shoes"
	output = /obj/item/clothing/shoes/boots/rosa/nine

/datum/repeatable_crafting_recipe/leather/rosashoes/ten
	name = "stately shoes"
	output = /obj/item/clothing/shoes/boots/rosa/ten

// wintermare coats

/datum/repeatable_crafting_recipe/leather/rosacoat
	name = "regal coat"
	requirements = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/natural/silk = 2,
		/obj/item/alch/herb/rosa = 1
	)
	output = /obj/item/clothing/armor/leather/jacket/rosa
	craftdiff = 5
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/rosacoat/two
	name = "courtly coat"
	output = /obj/item/clothing/armor/leather/jacket/rosa/two

/datum/repeatable_crafting_recipe/leather/rosacoat/three
	name = "royal coat"
	output = /obj/item/clothing/armor/leather/jacket/rosa/three

/datum/repeatable_crafting_recipe/leather/rosacoat/four
	name = "stately coat"
	output = /obj/item/clothing/armor/leather/jacket/rosa/four
