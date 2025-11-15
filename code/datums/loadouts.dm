GLOBAL_LIST_INIT(loadout_items, subtypesof(/datum/loadout_item))

/datum/loadout_item
	abstract_type = /datum/loadout_item
	/// Visible name for selection
	var/name = "Parent loadout datum"
	/// Visible description for item
	var/description
	/// Path to the item to spawn
	var/item_path

//Miscellaneous

/datum/loadout_item/card_deck
	name = "Card Deck"
	item_path = /obj/item/toy/cards/deck

/datum/loadout_item/rosa_bouquet
	name = "Rosa Bouquet"
	item_path = /obj/item/bouquet/rosa

/datum/loadout_item/salvia_bouquet
	name = "Salvia Bouquet"
	item_path = /obj/item/bouquet/salvia

/datum/loadout_item/matricaria_bouquet
	name = "Matricaria Bouquet"
	item_path = /obj/item/bouquet/matricaria

/datum/loadout_item/calendula_bouquet
	name = "Calendula Bouquet"
	item_path = /obj/item/bouquet/calendula

//HATS
/datum/loadout_item/zalad
	name = "Keffiyeh"
	item_path = /obj/item/clothing/neck/keffiyeh

/datum/loadout_item/turban
	name = "Turban"
	item_path = /obj/item/clothing/head/turban

/datum/loadout_item/rosa_flower_crown
	name = "Rosa Flower Crown"
	item_path = /obj/item/clothing/head/flowercrown/rosa

/datum/loadout_item/salvia_flower_crown
	name = "Salvia Flower Crown"
	item_path = /obj/item/clothing/head/flowercrown/salvia

/datum/loadout_item/strawhat
	name = "Straw Hat"
	item_path = /obj/item/clothing/head/strawhat

/datum/loadout_item/witchhat
	name = "Witch Hat"
	item_path = /obj/item/clothing/head/wizhat/witch

/datum/loadout_item/bardhat
	name = "Bard Hat"
	item_path = /obj/item/clothing/head/bardhat

/datum/loadout_item/fancyhat
	name = "Fancy Hat"
	item_path = /obj/item/clothing/head/fancyhat

/datum/loadout_item/furhat
	name = "Fur Hat"
	item_path = /obj/item/clothing/head/hatfur


/datum/loadout_item/headband
	name = "Headband"
	item_path = /obj/item/clothing/head/headband

/datum/loadout_item/nunveil
	name = "Nun Veil"
	item_path = /obj/item/clothing/head/nun

/datum/loadout_item/papakha
	name = "Papakha"
	item_path = /obj/item/clothing/head/papakha

//CLOAKS
/datum/loadout_item/tabard
	name = "Tabard"
	item_path = /obj/item/clothing/cloak/tabard

/datum/loadout_item/surcoat
	name = "Surcoat"
	item_path = /obj/item/clothing/cloak/stabard

/datum/loadout_item/jupon
	name = "Jupon"
	item_path = /obj/item/clothing/cloak/stabard/jupon

/datum/loadout_item/cape
	name = "Cape"
	item_path = /obj/item/clothing/cloak/cape

/datum/loadout_item/halfcloak
	name = "Halfcloak"
	item_path = /obj/item/clothing/cloak/half

/datum/loadout_item/volfmantle
	name = "Volf Mantle"
	item_path = /obj/item/clothing/cloak/volfmantle

/datum/loadout_item/sash
	name = "Cloth Sash"
	item_path = /obj/item/clothing/shirt/undershirt/sash/colored/random

/datum/loadout_item/poncho
	name = "Cloth Poncho"
	item_path = /obj/item/clothing/cloak/poncho

/datum/loadout_item/vest
	name = "Cloth Vest"
	item_path = /obj/item/clothing/shirt/clothvest/colored/random

//SHOES

/datum/loadout_item/babouche
	name = "Babouche"
	item_path = /obj/item/clothing/shoes/shalal

/datum/loadout_item/sandals
	name = "Sandals"
	item_path = /obj/item/clothing/shoes/sandals

/datum/loadout_item/gladsandals
	name = "Gladiatorial Sandals"
	item_path = /obj/item/clothing/shoes/gladiator

/datum/loadout_item/ankletscloth
	name = "Cloth Anklets"
	item_path = /obj/item/clothing/shoes/boots/clothlinedanklets

//SHIRTS

/datum/loadout_item/robe
	name = "Robe"
	item_path = /obj/item/clothing/shirt/robe

/datum/loadout_item/longshirt
	name = "Shirt"
	item_path = /obj/item/clothing/shirt

/datum/loadout_item/shortshirt
	name = "Short-sleeved Shirt"
	item_path = /obj/item/clothing/shirt/shortshirt

/datum/loadout_item/sailorshirt
	name = "Striped Shirt"
	item_path = /obj/item/clothing/shirt/undershirt/sailor

/datum/loadout_item/bottomtunic
	name = "Low-cut Tunic"
	item_path = /obj/item/clothing/shirt/undershirt/lowcut

/datum/loadout_item/tunic
	name = "Tunic"
	item_path = /obj/item/clothing/shirt/tunic/colored/random

/datum/loadout_item/dress
	name = "Dress"
	item_path = /obj/item/clothing/shirt/dress/gen

/datum/loadout_item/bardress
	name = "Bar Dress"
	item_path = /obj/item/clothing/shirt/dress

/datum/loadout_item/nun_habit
	name = "Nun Habit"
	item_path = /obj/item/clothing/shirt/robe/nun

//PANTS
/datum/loadout_item/tights
	name = "Cloth Tights"
	item_path = /obj/item/clothing/pants/tights

/datum/loadout_item/sailorpants
	name = "Seafaring Pants"
	item_path = /obj/item/clothing/pants/tights/sailor

/datum/loadout_item/skirt
	name = "Skirt"
	item_path = /obj/item/clothing/pants/skirt

//ACCESSORIES

/datum/loadout_item/elf_ear_necklace
	name = "Elf Ear Necklace"
	item_path = /obj/item/clothing/neck/elfears

/datum/loadout_item/men_ear_necklace
	name = "Men Ear Necklace"
	item_path = /obj/item/clothing/neck/menears

/datum/loadout_item/wrappings
	name = "Handwraps"
	item_path = /obj/item/clothing/wrists/wrappings

/datum/loadout_item/loincloth
	name = "Loincloth"
	item_path = /obj/item/clothing/pants/loincloth

/datum/loadout_item/fingerless
	name = "Fingerless Gloves"
	item_path = /obj/item/clothing/gloves/fingerless

/datum/loadout_item/feather
	name = "Feather"
	item_path = /obj/item/natural/feather

/datum/loadout_item/collar
	name = "Collar"
	item_path = /obj/item/clothing/neck/leathercollar

/datum/loadout_item/bell_collar
	name = "Bell Collar"
	item_path = /obj/item/clothing/neck/bellcollar

/datum/loadout_item/chaperon
	name = "Chaperon (Normal)"
	item_path = /obj/item/clothing/head/chaperon

/datum/loadout_item/jesterhat
	name = "Jester's Hat"
	item_path = /obj/item/clothing/head/jester

/datum/loadout_item/jestertunick
	name = "Jester's Tunick"
	item_path = /obj/item/clothing/shirt/jester

/datum/loadout_item/jestershoes
	name = "Jester's Shoes"
	item_path = /obj/item/clothing/shoes/jester
