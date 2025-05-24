/datum/repeatable_crafting_recipe/sewing
	abstract_type = /datum/repeatable_crafting_recipe/sewing
	requirements = list(
		/obj/item/natural/cloth = 1
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)

	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/cloth
	skillcraft = /datum/skill/misc/sewing
	craftdiff = 0
	subtypes_allowed = TRUE // so you can use any subtype of fur
	category = "Shirt"

/datum/repeatable_crafting_recipe/sewing/rags
	name = "rags"
	requirements = list(
		/obj/item/natural/cloth = 2,
	)
	output = /obj/item/clothing/shirt/rags


/datum/repeatable_crafting_recipe/sewing/tribalrags
	name = "tribal rags"
	output = /obj/item/clothing/shirt/tribalrag
	attacked_atom = /obj/item/natural/hide
	requirements = list(/obj/item/natural/hide = 1,
				/obj/item/natural/fibers = 1)
	sellprice = 6
	craftdiff = 0

/datum/repeatable_crafting_recipe/sewing/winding_sheet
	name = "winding sheet"
	requirements = list(
		/obj/item/natural/cloth = 2,
	)
	output = /obj/item/burial_shroud
	craftdiff = 1
	category = "Misc"

/datum/repeatable_crafting_recipe/sewing/loincloth
	name = "loincloth"
	requirements = list(
		/obj/item/natural/cloth = 1,
	)
	output = /obj/item/clothing/pants/loincloth
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/apron
	name = "cloth apron"
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/cloak/apron
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/clothgloves
	name = "cloth gloves"
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/gloves/fingerless
	category = "Gloves"

/datum/repeatable_crafting_recipe/sewing/shortshirt
	name = "cloth short shirt"
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/shirt/shortshirt/uncolored

/datum/repeatable_crafting_recipe/sewing/clothshirt
	name = "cloth shirt"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/shirt/undershirt/uncolored

/datum/repeatable_crafting_recipe/sewing/tunic
	name = "tunic"
	output = /obj/item/clothing/shirt/tunic
	requirements = list(/obj/item/natural/cloth = 2)

/datum/repeatable_crafting_recipe/sewing/lowcut_shirt
	name = "low cut tunic"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/shirt/undershirt/lowcut
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/stripedtunic
	name = "striped tunic"
	output = /obj/item/clothing/armor/gambeson/light/striped
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/clothtights
	name = "cloth tights"
	output = /obj/item/clothing/pants/tights/uncolored
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/headband
	name = "headband"
	output = /obj/item/clothing/head/headband
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/strawhat
	name = "crude straw hat"
	output = /obj/item/clothing/head/strawhat
	requirements = list(/obj/item/natural/fibers = 3)
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/knitcap
	name = "knit cap"
	output = /obj/item/clothing/head/knitcap
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/cmask
	name = "cloth mask"
	output = /obj/item/clothing/face/shepherd/clothmask
	requirements = list(/obj/item/natural/fibers = 1, /obj/item/natural/cloth = 1)
	category = "Mask"

/datum/repeatable_crafting_recipe/sewing/linedanklet
	name = "cloth anklet"
	output = /obj/item/clothing/shoes/boots/clothlinedanklets
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	category = "Shoes"

/datum/repeatable_crafting_recipe/sewing/zigbox
	name = "zigbox"
	output = /obj/item/storage/fancy/cigarettes/zig/empty
	requirements = list(/obj/item/paper = 1,
				/obj/item/natural/fibers = 1)
	blacklisted_paths = list(/obj/item/paper/scroll, /obj/item/paper/confession)
	category = "Misc"
/*.............. recipes requiring skill 1 ..............*/

/datum/repeatable_crafting_recipe/sewing/stripedtunic
	name = "striped tunic"
	output = /obj/item/clothing/armor/gambeson/light/striped
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/Reyepatch
	name = "right eye patch"
	output = /obj/item/clothing/face/eyepatch
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Face"

/datum/repeatable_crafting_recipe/sewing/Leyepatch
	name = "left eye patch"
	output = /obj/item/clothing/face/eyepatch/left
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Face"

/datum/repeatable_crafting_recipe/sewing/fakeeyepatch
	name = "see through eyepatch"
	output = /obj/item/clothing/face/eyepatch/fake
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Face"

/datum/repeatable_crafting_recipe/sewing/fisherhat
	name = "straw fisher hat"
	output = /obj/item/clothing/head/fisherhat
	requirements = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/sack
	name = "sack hood"
	output = /obj/item/clothing/head/menacing
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 1
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/clothknapsack
	name = "cloth knapsack"
	output = /obj/item/storage/backpack/satchel/cloth
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 3)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/pcoif
	name = "cloth coif"
	output = /obj/item/clothing/neck/coif/cloth
	requirements = list(/obj/item/natural/fibers = 1, /obj/item/natural/cloth = 2)
	craftdiff = 1
	category = "Neck"

/datum/repeatable_crafting_recipe/sewing/roguehood
	name = "cloth hood"
	requirements = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1,)
	output = /obj/item/clothing/head/roguehood/uncolored
	craftdiff = 1
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/clothpouch
	name = "cloth pouch"
	output = /obj/item/storage/belt/pouch/cloth
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/clothtrou
	name = "cloth trousers"
	output = /obj/item/clothing/pants/trou
	requirements = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/lgambeson
	name = "light gambeson"
	output = /obj/item/clothing/armor/gambeson/light
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/sleepingbag
	name = "bedroll"
	output = /obj/item/sleepingbag
	requirements =  list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Misc"

/datum/repeatable_crafting_recipe/sewing/armingcap
	name = "arming cap"
	output = /obj/item/clothing/head/armingcap
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1
	category = "Hat"


/datum/repeatable_crafting_recipe/sewing/gambeson
	name = "gambeson"
	output = /obj/item/clothing/armor/gambeson
	requirements = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/tabard
	name = "tabard"
	output = /obj/item/clothing/cloak/tabard
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/tabard
	name = "tabard (crusader)"
	output = /obj/item/clothing/cloak/tabard/crusader
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/stabard
	name = "surcoat"
	output = /obj/item/clothing/cloak/stabard
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/bedsheet
	name = "bedsheet"
	output = /obj/item/bedsheet/cloth
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Misc"

/datum/repeatable_crafting_recipe/sewing/bedsheetpelt
	name = "leather bedsheet"
	output = /obj/item/bedsheet/pelt
	attacked_atom = /obj/item/natural/hide/cured
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Misc"

/datum/repeatable_crafting_recipe/sewing/double_bedsheetpelt
	name = "large leather bedsheet"
	output = /obj/item/bedsheet/double_pelt
	attacked_atom = /obj/item/natural/hide/cured
	requirements = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Misc"

/datum/repeatable_crafting_recipe/sewing/undervestments
	name = "undervestments"
	requirements = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/shirt/undershirt/priest
	craftdiff = 2
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/wrappings
	name = "solar wrappings"
	requirements = list(
		/obj/item/natural/cloth = 2
	)
	output = /obj/item/clothing/wrists/wrappings
	craftdiff = 2
	category = "Wrists"

/datum/repeatable_crafting_recipe/sewing/nocwrappings
	name = "moon wrappings"
	requirements = list(
		/obj/item/natural/cloth = 2
	)
	output = /obj/item/clothing/wrists/nocwrappings
	craftdiff = 2
	category = "Wrists"

/datum/repeatable_crafting_recipe/sewing/Bluskirt
	name = "blue skirt"
	output = /obj/item/clothing/pants/skirt/blue
	requirements = list(/obj/item/natural/cloth = 2,
			/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/Greskirt
	name = "green skirt"
	output = /obj/item/clothing/pants/skirt/green
	requirements = list(/obj/item/natural/cloth = 2,
			/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Pants"
/*.............. recipes requiring skill 3 ..............*/

/datum/repeatable_crafting_recipe/sewing/armingjacket
	name = "arming jacket"
	output = /obj/item/clothing/armor/gambeson/arming
	requirements = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/wizhat
	name = "wizard hat"
	output = /obj/item/clothing/head/wizhat
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/wizardrobes
	name = "wizard robes"
	output = /obj/item/clothing/shirt/robe/wizard
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/robe
	name = "robes"
	output = /obj/item/clothing/shirt/robe/plain
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/cape
	name = "cape"
	output = /obj/item/clothing/cloak/cape
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/desertcape
	name = "desert cape"
	output = /obj/item/clothing/cloak/cape/crusader
	requirements = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/halfcloak
	name = "half cloak"
	requirements = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/cloak/half
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/templar
	name = "templar surcoat"
	output = /obj/item/clothing/cloak/stabard/templar
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/astratatemplar
	name = "solar surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/astrata
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/necratemplar
	name = "necran surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/necra
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/dendortemplar
	name = "dendorian surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/dendor
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/noctemplar
	name = "lunar surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/noc
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/abyssortemplar
	name = "abyssal surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/abyssor
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/malumtemplar
	name = "malumite surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/malum
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/eoratemplar
	name = "eoran surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/eora
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/pestratemplar
	name = "pestran surcoat"
	output = /obj/item/clothing/cloak/stabard/templar/pestra
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/dress
	name = "bar dress"
	output = /obj/item/clothing/shirt/dress
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/stockdress
	name = "stock dress"
	output = /obj/item/clothing/shirt/dress/gen
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/Bladress
	name = "black dress"
	output = /obj/item/clothing/shirt/dress/gen/black
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/Bludress
	name = "blue dress"
	output = /obj/item/clothing/shirt/dress/gen/blue
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/Purdress
	name = "purple dress"
	output = /obj/item/clothing/shirt/dress/gen/purple
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Dress"

/* .............. recipes requiring skill 4 ..............*/

/datum/repeatable_crafting_recipe/sewing/fancyhat
	name = "fancy hat"
	output = /obj/item/clothing/head/fancyhat
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/feather = 1)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/courtierhat
	name = "courtier hat"
	output = /obj/item/clothing/head/courtierhat
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/feather = 1)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/bardhat
	name = "bard hat"
	output = /obj/item/clothing/head/bardhat
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/feather = 1)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/chaperonhat
	name = "chaperon hat"
	output = /obj/item/clothing/head/chaperon/greyscale
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/jupon
	name = "jupon"
	output = /obj/item/clothing/cloak/stabard/surcoat
	requirements = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	category = "Cloak"

/*.............. recipes requiring skill 5 ..............*/

/datum/repeatable_crafting_recipe/sewing/lordcloak
	name = "lordly cloak"
	output = /obj/item/clothing/cloak/lordcloak
	attacked_atom = /obj/item/natural/hide/cured
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 5
	category = "Cloak"

/*.............. recipes requiring skill 6 ..............*/

/datum/repeatable_crafting_recipe/sewing/silkydress
	name = "silky dress of legendary sewists"
	output = /obj/item/clothing/shirt/dress/silkydress
	requirements = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	craftdiff = 6
	category = "Dress"

