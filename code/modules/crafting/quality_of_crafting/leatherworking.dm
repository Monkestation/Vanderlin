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
	skillcraft = /datum/skill/craft/tanning
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

/// Clothing
/datum/repeatable_crafting_recipe/leather/gloves
	name = "leather gloves"
	output_amount = 2
	output = /obj/item/clothing/gloves/leather
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/gloves/feld_gloves
	name = "feldsher gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2
	)
	output = /obj/item/clothing/gloves/leather/feld

/datum/repeatable_crafting_recipe/leather/gloves/phys_gloves
	name = "physicker gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/phys

/datum/repeatable_crafting_recipe/leather/gloves/apothecary_gloves
	name = "apothecary gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/apothecary

/datum/repeatable_crafting_recipe/leather/gloves/otavan_gloves
	name = "grenzelhoftian gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/otavan

/datum/repeatable_crafting_recipe/leather/gloves/inquisitor_gloves
	name = "inquisitor gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/otavan/inqgloves

/datum/repeatable_crafting_recipe/leather/gloves/apothecary_pants
	name = "apothecary trou"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/pants/trou/apothecary

/datum/repeatable_crafting_recipe/leather/gloves/artipants
	name = "artificer trou"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/pants/trou/artipants

/datum/repeatable_crafting_recipe/leather/gloves/leather_tights
	name = "leather tights"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/pants/trou/leathertights

/datum/repeatable_crafting_recipe/leather/gloves/beltpants
	name = "belt pants"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/pants/trou/beltpants

/datum/repeatable_crafting_recipe/leather/gloves/duelist_gloves
	name = "dueslist gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/gloves/leather/duelgloves

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

/datum/repeatable_crafting_recipe/leather/shoes
	name = "leather shoes"
	output_amount = 2
	output = /obj/item/clothing/shoes/simpleshoes

/datum/repeatable_crafting_recipe/leather/buckle_shoes
	name = "leather buckle shoes"
	output = /obj/item/clothing/shoes/simpleshoes/buckle

/datum/repeatable_crafting_recipe/leather/boots
	name = "leather boots"
	output = /obj/item/clothing/shoes/boots/leather

/datum/repeatable_crafting_recipe/leather/corset
	name = "corset"
	output = /obj/item/clothing/armor/corset

/datum/repeatable_crafting_recipe/leather/sandals
	name = "sandals"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/sandals

/datum/repeatable_crafting_recipe/leather/gladiator
	name = "caligae"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/gladiator
	sellprice = 17
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/cloak
	name = "leather raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/cloak/raincloak
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/cloakfur
	name = "fur lined raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/cloak/raincloak/furcloak
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/battlenun_cloak
	name = "battlenun cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/silk = 1,
	)
	output = /obj/item/clothing/cloak/battlenun
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/graggar_cloak
	name = "vicious cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/silk = 1,
	)
	output = /obj/item/clothing/cloak/graggar
	craftdiff = 4


/datum/repeatable_crafting_recipe/leather/cloakfur_black
	name = "fur lined black cloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
	)
	output = /obj/item/clothing/cloak/black_cloak
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/belt
	name = "leather belt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/storage/belt/leather
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/suspenders
	name = "suspenders"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/storage/belt/leather/suspenders
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/vest
	name = "leather vest"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/vest
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/seajacket
	name = "sea jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/jacket/sea
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/apothecary_shirt
	name = "apothecary shirt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/shirt/apothshirt
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/jester_shirt
	name = "jester's tunick"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/shirt/jester
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/apron
	name = "leather apron"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/cloak/apron/brown
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/furlinedanklets
	name = "fur lined anklets"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/shoes/boots/furlinedanklets

/datum/repeatable_crafting_recipe/leather/heavygloves
	name = "heavy leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/gloves/angle
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/helmet
	name = "leather helmet"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/coif
	name = "leather coif"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/neck/coif
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/leatherjacket
	name = "leather jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/jacket
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/armor
	name = "leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/hidearmor
	name = "fur lined leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/armor/leather/hide
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/hidearmor/steppe
	name = "frontier fur lined leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
	)
	output = /obj/item/clothing/armor/leather/hide/steppe
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/whip
	name = "leather whip"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/weapon/whip
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/furlinedboots
	name = "fur lined boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
	)
	output = /obj/item/clothing/shoes/boots/furlinedboots
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/shortboots
	name = "shortboots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/shoes/shortboots
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/darkboots
	name = "dark boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/cloth = 1
	)
	output = /obj/item/clothing/shoes/boots
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/ridingboots
	name = "riding boots"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 1,
	)
	output = /obj/item/clothing/shoes/ridingboots
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/leathercoat
	name = "leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/leathercoat/black // never add items with the same names
	name = "black leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/black
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/ominous_hood
	name = "ominous hood"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather/hood_ominous
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/adept_cowl
	name = "adept cowl"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/head/adeptcowl
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/inquisitor_hat
	name = "inquisitorial hat"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/feather = 1,
	)
	output = /obj/item/clothing/head/leather/inqhat
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/nobleboots
	name = "noble boots"
	output = /obj/item/clothing/shoes/nobleboot
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 2,
	)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/forrestercloak
	name = "forrester cloak"
	output = /obj/item/clothing/cloak/forrestercloak
	requirements = list(/obj/item/natural/silk = 1,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/forrestercloak_snow
	name = "forrester cloak (snow)"
	output = /obj/item/clothing/cloak/forrestercloak/snow
	requirements = list(/obj/item/natural/silk = 1,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/wardencloak
	name = "warden cloak"
	output = /obj/item/clothing/cloak/wardencloak
	requirements = list(/obj/item/natural/silk = 2,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/red_cloak
	name = "red cloak"
	output = /obj/item/clothing/cloak/heartfelt
	requirements = list(/obj/item/natural/silk = 2,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/captaincloak
	name = "captain cloak"
	output = /obj/item/clothing/cloak/captain
	requirements = list(/obj/item/natural/silk = 3,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 6

/datum/repeatable_crafting_recipe/leather/matroncloak
	name = "matron cloak"
	output = /obj/item/clothing/cloak/matron
	requirements = list(/obj/item/natural/silk = 1,
				/obj/item/natural/hide/cured = 2)
	craftdiff = 6

/datum/repeatable_crafting_recipe/leather/lordcloak
	name = "lordly cloak"
	output = /obj/item/clothing/cloak/lordcloak
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/ladycloak
	name = "lady cloak"
	output = /obj/item/clothing/cloak/lordcloak/ladycloak
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/brimmedhat
	name = "brimmed hat"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/head/brimmed
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/court_physician_hat
	name = "court physician hat"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output_amount = 1
	output = /obj/item/clothing/head/physhat
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/tricorn
	name = "tricorn (black)"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather/tricorn
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/headscarf
	name = "headscarf"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/head/helmet/leather/headscarf
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/buckled_hat
	name = "buckled hat"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
	)
	output = /obj/item/clothing/head/helmet/leather/inquisitor
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/hardened_conical
	name = "hardened conical helmet"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/ingot/iron = 1,
	)
	output = /obj/item/clothing/head/helmet/leather/conical
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/top_hat
	name = "steampunk top hat"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/stewardtophat
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/duelhat
	name = "duelist hat"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/feather = 1,
	)
	output = /obj/item/clothing/head/leather/duelhat
	craftdiff = 2

/// Standalones

/datum/repeatable_crafting_recipe/leather/leathercollar
	name = "leather collar"
	output = /obj/item/clothing/neck/leathercollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/bellcollar
	name = "bell collar"
	output = /obj/item/clothing/neck/bellcollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/jingle_bells = 1)
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/standalone
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/boots
	name = "hardened leather boots"
	output = /obj/item/clothing/shoes/boots/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/boots/watch
	name = "watch boots"
	output = /obj/item/clothing/shoes/boots/leather/advanced/watch
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1, /obj/item/ingot/iron)
	craftdiff = 4

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
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/top_hat
	name = "top hat"
	output = /obj/item/clothing/head/tophat
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/jester_hat
	name = "jester hat"
	output = /obj/item/clothing/head/jester
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/babouche
	name = "babouche"
	output = /obj/item/clothing/shoes/shalal
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/jester_shoes
	name = "jester shoes"
	output = /obj/item/clothing/shoes/jester
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/otavan_shoes
	name = "grenzelhoftian shoes"
	output = /obj/item/clothing/shoes/otavan
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/inqboots
	name = "inquisitorial shoes"
	output = /obj/item/clothing/shoes/otavan/inqboots
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/leather_duelcoat
	name = "leather duelist coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_thighboots
	name = "leather thigh boots"
	output = /obj/item/clothing/shoes/nobleboot/thighboots
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_duelist_boots
	name = "leather duelist boots"
	output = /obj/item/clothing/shoes/nobleboot/duelboots
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_apothecary_boots
	name = "leather apothecary boots"
	output = /obj/item/clothing/shoes/apothboots
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/leather_renegade_coat
	name = "leather renegade coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	requirements = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/grenzelhoft_leather_boots
	name = "grenzelhoftian leather boots"
	output = /obj/item/clothing/shoes/rare/grenzelhoft
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/grenzelhoft_heavy_leather_gloves
	name = "grenzelhoftian heavy leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/gloves/angle/grenzel
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

/datum/repeatable_crafting_recipe/leather/standalone/gloves
	name = "hardened leather gloves"
	output = /obj/item/clothing/gloves/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/coat
	name = "hardened leather coat"
	output = /obj/item/clothing/armor/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
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
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/helmet
	name = "hardened leather helmet"
	output = /obj/item/clothing/head/helmet/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/chausses
	name = "hardened leather chausses"
	output = /obj/item/clothing/pants/trou/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/// MASTERWORK

/datum/repeatable_crafting_recipe/leather/standalone/boots/masterwork
	name = "masterwork leather boots"
	output = /obj/item/clothing/shoes/boots/leather/masterwork
	attacked_atom = /obj/item/clothing/shoes/boots/leather
	requirements = list(/obj/item/clothing/shoes/boots/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/gloves/masterwork
	name = "masterwork leather gloves"
	output = /obj/item/clothing/gloves/leather/masterwork
	attacked_atom = /obj/item/clothing/gloves/leather
	requirements = list(/obj/item/clothing/gloves/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/bracers
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone/bracers

/datum/repeatable_crafting_recipe/leather/standalone/bracers/masterwork
	name = "masterwork leather bracers"
	output = /obj/item/clothing/wrists/bracers/leather/masterwork
	attacked_atom = /obj/item/clothing/wrists/bracers/leather
	requirements = list(/obj/item/clothing/wrists/bracers/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/coat/masterwork
	name = "masterwork leather coat"
	output = /obj/item/clothing/armor/leather/masterwork
	attacked_atom = /obj/item/clothing/armor/leather
	requirements = list(/obj/item/clothing/armor/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/helmet/masterwork
	name = "masterwork leather helmet"
	output = /obj/item/clothing/head/helmet/leather/masterwork
	attacked_atom = /obj/item/clothing/head/helmet/leather
	requirements = list(/obj/item/clothing/head/helmet/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/chausses/masterwork
	name = "masterwork leather chausses"
	output = /obj/item/clothing/pants/trou/leather/masterwork
	attacked_atom = /obj/item/clothing/pants/trou/leather
	requirements = list(/obj/item/clothing/pants/trou/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/rumaclan
	name = "raised sandals"
	output = /obj/item/clothing/shoes/rumaclan
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/grown/log/tree/small = 1
	)
	craftdiff = 1
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/atgervi_coat
	name = "shamanic coat"
	output = /obj/item/clothing/armor/leather/heavy/atgervi
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2
	)
	craftdiff = 2
	category = "Armor"

/datum/repeatable_crafting_recipe/leather/atgervi_pants
	name = "fur pants"
	output = /obj/item/clothing/pants/trou/leather/atgervi
	requirements = list(
		/obj/item/natural/fur = 2,
		/obj/item/natural/hide/cured = 1,
	)
	craftdiff = 1
	category = "Pants"

/datum/repeatable_crafting_recipe/leather/atgervi_gloves
	name = "fur-lined leather gloves"
	output = /obj/item/clothing/gloves/angle/atgervi
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1
	)
	craftdiff = 1
	category = "Gloves"

/datum/repeatable_crafting_recipe/leather/atgervi_moose_hood
	name = "moose hood"
	output = /obj/item/clothing/head/helmet/leather/saiga/atgervi
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/alch/bone = 2 // For antlers
	)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/leather/atgervi_boots
	name = "atgervi leather boots"
	output = /obj/item/clothing/shoes/boots/leather/atgervi
	requirements = list(
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 1
	category = "Shoes"

/datum/repeatable_crafting_recipe/leather/psydonboots
	name = "enduring boots"
	output = /obj/item/clothing/shoes/psydonboots
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 1,
	)
	craftdiff = 3
	category = "Shoes"

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
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/head/roguehood/leather
	craftdiff = 2
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
