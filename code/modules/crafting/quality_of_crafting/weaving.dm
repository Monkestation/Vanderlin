
/// SILKS

/datum/repeatable_crafting_recipe/sewing/weaving
	abstract_type = /datum/repeatable_crafting_recipe/sewing/weaving
	attacked_atom = /obj/machinery/loom
	requirements = list(
		/obj/item/natural/silk = 1
	)
	craftdiff = 1

/* craftdif of 1 = NOVICE */

/datum/repeatable_crafting_recipe/sewing/weaving/shepardmask
	name = "half-mask"
	output = /obj/item/clothing/face/shepherd
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	category = "Mask"

/datum/repeatable_crafting_recipe/sewing/weaving/rags
	name = "shirt (webbed)"
	output = /obj/item/clothing/shirt/undershirt/webs
	requirements = list(/obj/item/natural/silk = 1)
	craftdiff = 1
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/weaving/webbing
	name = "trousers (webbed)"
	output = /obj/item/clothing/pants/webs
	requirements = list(/obj/item/natural/silk = 2)
	craftdiff = 1
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/weaving/feld_mask
	name = "feldsher mask"
	output = /obj/item/clothing/face/feld
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	category = "Mask"

/datum/repeatable_crafting_recipe/sewing/weaving/phys_mask
	name = "physicker mask"
	output = /obj/item/clothing/face/phys
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	category = "Mask"

/* craftdif of 2 = APPRENTICE */

/datum/repeatable_crafting_recipe/sewing/weaving/shadowgloves
	name = "gloves"
	output = /obj/item/clothing/gloves/fingerless/shadowgloves
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 2
	category = "Gloves"

/datum/repeatable_crafting_recipe/sewing/weaving/courtphys_mask
	name = "court physician mask"
	output = /obj/item/clothing/face/courtphysician
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2,
				/obj/item/alch/bone = 1)
	craftdiff = 2
	category = "Mask"

/* craftdif of 3 = JOURNEYMAN */

/datum/repeatable_crafting_recipe/sewing/weaving/cloak
	name = "cloak (half, silk)"
	output = /obj/item/clothing/cloak/half
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/weaving/feld_hood
	name = "hood (feldsher)"
	output = /obj/item/clothing/head/roguehood/feld
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/phys_hood
	name = "hood (physicker)"
	output = /obj/item/clothing/head/roguehood/phys
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/courtphys_hat
	name = "court physician's beret"
	output = /obj/item/clothing/head/courtphysician
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/nochood
	name = "hood (moon/Noc)"
	output = /obj/item/clothing/head/roguehood/nochood
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/shadowfacemask
	name = "shadow face mask"
	output = /obj/item/clothing/face/facemask/shadowfacemask
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Mask"

/datum/repeatable_crafting_recipe/sewing/weaving/shadowfacemask_sheperd // this is really stupid
	name = "purple face mask"
	output = /obj/item/clothing/face/shepherd/shadowmask
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Mask"

/datum/repeatable_crafting_recipe/sewing/weaving/abyssorhood
	name = "hood (Abyssor)"
	output = /obj/item/clothing/head/padded/abyssor
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/briarthorns
	name = "briar thorns"
	output = /obj/item/clothing/head/padded/briarthorns
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1,
				/obj/item/natural/thorn = 3)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/eorahood
	name = "hood (eora)"
	output = /obj/item/clothing/head/roguehood/eora
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1,
				/obj/item/natural/thorn = 3)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/necrahood
	name = "hood (Necra)"
	output = /obj/item/clothing/head/padded/deathshroud
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/pestrahood
	name = "hood (pestra)"
	output = /obj/item/clothing/head/padded/pestra
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/eoramask
	name = "mask (Eora)"
	output = /obj/item/clothing/face/operavisage
	requirements = list(/obj/item/ingot/silver = 1,
				/obj/item/natural/silk = 4)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/astratahood
	name = "hood (solar/Astrata)"
	output = /obj/item/clothing/head/roguehood/astrata
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/wizard_hat_gen
	name = "wizard hat"
	output = /obj/item/clothing/head/wizhat/gen
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/shirt
	name = "shirt (formal silks)"
	output = /obj/item/clothing/shirt/undershirt/puritan
	requirements = list(/obj/item/natural/silk = 5)
	craftdiff = 3
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/weaving/noblecoat
	name = "coat (fancy)"
	output = /obj/item/clothing/shirt/tunic/noblecoat
	requirements = list(/obj/item/natural/cloth = 3,
			/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/nunhood
	name = "hood (nun)"
	output = /obj/item/clothing/head/nun
	requirements = list(/obj/item/natural/silk = 2)
	craftdiff = 3
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/nunrobe
	name = "robes (nun)"
	output = /obj/item/clothing/shirt/robe/nun
	requirements = list(/obj/item/natural/silk = 3)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/puritancape

	name = "puritan cape"
	output = /obj/item/clothing/cloak/cape/puritan
	requirements = list(/obj/item/natural/silk = 4)
	craftdiff = 3
	sellprice = 35
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/weaving/silktabard
	name = "fine silk tabard"
	output = /obj/item/clothing/cloak/silktabard
	requirements = list(/obj/item/natural/silk = 4)
	craftdiff = 3
	category = "Cloak"

/* craftdif of 4 = EXPERT */

/datum/repeatable_crafting_recipe/sewing/weaving/shadowcloak
	name = "stalker cloak"
	output = /obj/item/clothing/cloak/half/shadowcloak
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 4
	category = "Cloak"

/datum/repeatable_crafting_recipe/sewing/weaving/shadowshirt
	name = "shirt (dark)"
	output = /obj/item/clothing/shirt/shadowshirt
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/silkchaperone
	name = "hat (chaperone)"
	output = /obj/item/clothing/head/chaperon/colored/greyscale/silk
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 4
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/shadowpants
	name = "pants (dark)"
	output = /obj/item/clothing/pants/trou/shadowpants
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3)
	craftdiff = 4
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/weaving/astratarobe
	name = "robes (Astrata)"
	output = /obj/item/clothing/shirt/robe/astrata
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/eorarobe
	name = "robes (Eora)"
	output = /obj/item/clothing/shirt/robe/eora
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/dendorrobe
	name = "robes (Dendor)"
	output = /obj/item/clothing/shirt/robe/dendor
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/necrarobe
	name = "robes (Necra)"
	output = /obj/item/clothing/shirt/robe/necra
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/nocrobe
	name = "robes (Noc)"
	output = /obj/item/clothing/shirt/robe/noc
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/abyssor_robe
	name = "robes (Abyssor)"
	output = /obj/item/clothing/shirt/robe/abyssor
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/pestra_robe
	name = "robes (Pestra)"
	output = /obj/item/clothing/shirt/robe/pestra
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/merchant_robe
	name = "merchant robe"
	output = /obj/item/clothing/shirt/robe/merchant
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/archivist_robe
	name = "archivist robe"
	output = /obj/item/clothing/shirt/robe/archivist
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/heartfelt_suit
	name = "heartfeltian suit"
	output = /obj/item/clothing/shirt/undershirt/artificer
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/fancy_tunic
	name = "fancy tunic"
	output = /obj/item/clothing/shirt/undershirt/fancy
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/winter_jacket
	name = "winter jacket"
	output = /obj/item/clothing/armor/leather/vest/winterjacket
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/silk_jacket
	name = "silk jacket"
	output = /obj/item/clothing/armor/leather/jacket/apothecary
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 4



/datum/repeatable_crafting_recipe/sewing/weaving/artificer_jacket
	name = "artificer jacket"
	output = /obj/item/clothing/armor/leather/jacket/artijacket
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/chasuble
	name = "chasuble"
	output = /obj/item/clothing/cloak/chasuble
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/stole_gold
	name = "stole (gold)"
	output = /obj/item/clothing/cloak/stole
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/stole_red
	name = "stole (red)"
	output = /obj/item/clothing/cloak/stole/red
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/stole_purple
	name = "stole (purple)"
	output = /obj/item/clothing/cloak/stole/purple
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/hand_jacket
	name = "hand jacket"
	output = /obj/item/clothing/armor/leather/jacket/hand
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/hand_jacket_alt
	name = "hand jacket (alt)"
	output = /obj/item/clothing/armor/leather/jacket/handjacket
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/sewing/weaving/paddedgambeson
	name = "padded gambeson"
	output = /obj/item/clothing/armor/gambeson/heavy
	requirements = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	craftdiff = 4
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/weaving/armordress
	name = "padded dress"
	output = /obj/item/clothing/armor/gambeson/heavy/dress
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 4,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 4
	sellprice = 80
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/weaving/armordress_alt
	name = "padded dress (alt)"
	output = /obj/item/clothing/armor/gambeson/heavy/dress/alt
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 4,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 4
	sellprice = 80
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/weaving/stalker_robe
	name = "stalker robe"
	output = /obj/item/clothing/armor/gambeson/shadowrobe
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 4,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 4
	sellprice = 80
	category = "Armor"

/* craftdif of 5 = MASTER */

/datum/repeatable_crafting_recipe/sewing/weaving/silkcoat
	name = "coat (silk)"
	output = /obj/item/clothing/armor/leather/jacket/silk_coat
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3,
				/obj/item/natural/fur = 2)
	craftdiff = 5
	sellprice = 60
	category = "Armor"

/datum/repeatable_crafting_recipe/sewing/weaving/eorastraps
	name = "straps (eora)"
	output = /obj/item/clothing/shirt/robe/eora/alt
	requirements = list(/obj/item/ingot/gold = 1,
				/obj/item/natural/silk = 5,
				)
	craftdiff = 5
	sellprice = 50


/datum/repeatable_crafting_recipe/sewing/weaving/barkeep
	name = "dress (bar, silk)"
	output = /obj/item/clothing/shirt/dress
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 5
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/steward_dress
	name = "steward dress (silk)"
	output = /obj/item/clothing/shirt/dress/stewarddress
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 5
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/silkdress
	name = "dress (chemise, silk)"
	output = /obj/item/clothing/shirt/dress/silkdress/colored/random
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 5
	category = "Dress"

/* craftdif of 6 = LEGENDARY */
// IDK how to balance these

/datum/repeatable_crafting_recipe/sewing/weaving/royal_gown
	name = "royal gown"
	output = /obj/item/clothing/shirt/dress/royal
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85
	category = "Dress"



/datum/repeatable_crafting_recipe/sewing/weaving/royal_headdress
	name = "foreign headdress"
	output = /obj/item/clothing/head/headdress
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 6
	sellprice = 30
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/royal_headdress_alt
	name = "foreign headdress (alt)"
	output = /obj/item/clothing/head/headdress/alt
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 6
	sellprice = 30
	category = "Hat"

/datum/repeatable_crafting_recipe/sewing/weaving/royal_sleeves
	name = "royal sleeves"
	output = /obj/item/clothing/wrists/royalsleeves
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 6
	sellprice = 30
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/royal_gown_winter
	name = "winter dress"
	output = /obj/item/clothing/armor/gambeson/heavy/winterdress
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/royal_gown_prince
	name = "gilded dress shirt"
	output = /obj/item/clothing/shirt/dress/royal/prince
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 6
	sellprice = 85
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/royal_gown_princess
	name = "pristine dress"
	output = /obj/item/clothing/shirt/dress/royal/princess
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 2)
	craftdiff = 6
	sellprice = 85
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/springgown
	name = "gown (spring)"
	output = /obj/item/clothing/shirt/dress/gown
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/summergown
	name = "gown (summer)"
	output = /obj/item/clothing/shirt/dress/gown/summergown
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3)
	craftdiff = 6
	sellprice = 70
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/fallgown
	name = "gown (fall, silk)"
	output = /obj/item/clothing/shirt/dress/gown/fallgown
	requirements = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	sellprice = 75
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/wintergown
	name = "gown (winter)"
	output = /obj/item/clothing/shirt/dress/gown/wintergown
	requirements = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur/cabbit = 1)
	craftdiff = 6
	sellprice = 90
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/ornatedress
	name = "ornate dress"
	output = /obj/item/clothing/shirt/ornate/dress
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/weaving/ornatetunic
	name = "ornate tunic"
	output = /obj/item/clothing/shirt/ornate/tunic
	requirements = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/weaving/weddingdress
	name = "wedding silk dress"
	output = /obj/item/clothing/shirt/dress/silkdress/weddingdress
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/absolver
	name = "absolver's robe"
	output = /obj/item/clothing/cloak/absolutionistrobe
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/ordinatorcape
	name = "ordinator cape"
	output = /obj/item/clothing/cloak/ordinatorcape
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguinetrousers
	name = "sanguine trousers"
	output = /obj/item/clothing/pants/trou/courtphysician
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguinevest
	name = "sanguine vest"
	output = /obj/item/clothing/shirt/undershirt/courtphysician
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguineblouse
	name = "sanguine blouse"
	output = /obj/item/clothing/shirt/undershirt/courtphysician/female
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguineskirt
	name = "sanguine skirt"
	output = /obj/item/clothing/pants/skirt/courtphysician
	requirements = list(
		/obj/item/natural/silk = 3
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguinehat
	name = "sanguine hat"
	output = /obj/item/clothing/head/courtphysician/male
	requirements = list(
		/obj/item/natural/silk = 2
	)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/weaving/sanguinecap
	name = "sanguine cap"
	output = /obj/item/clothing/head/courtphysician/female
	requirements = list(
		/obj/item/natural/silk = 2
	)
	craftdiff = 3
