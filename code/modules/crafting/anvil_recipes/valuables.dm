/datum/anvil_recipe/valuables
	appro_skill = /datum/attribute/skill/craft/blacksmithing
	abstract_type = /datum/anvil_recipe/valuables
	category = "Valuables"

// --------- IRON -----------

/datum/anvil_recipe/valuables/gold_teeth
	name = "Golden Teeth"
	required_material = /obj/item/ingot/gold
	created_item = /obj/item/natural/teeth/gold
	craftdiff = 2
	output_amount = 8

/datum/anvil_recipe/valuables/gold_mask
	name = "Golden Half Mask"
	required_material = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask
	craftdiff = 2

/datum/anvil_recipe/valuables/gold_mask_left
	name = "Golden Half Mask (Left)"
	required_material = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask/l
	craftdiff = 2

/datum/anvil_recipe/valuables/iron
	required_material = /obj/item/ingot/iron
	abstract_type = /datum/anvil_recipe/valuables/iron
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/iron/statue
	name = "Iron Statue"
	created_item = /obj/item/statue/iron

// --------- STEEL -----------


/datum/anvil_recipe/valuables/rontzs
	name = "Silver Face Mask"
	required_material = /obj/item/ingot/silver
	created_item = /obj/item/clothing/face/facemask/silver
	craftdiff = 2

/datum/anvil_recipe/valuables/steel
	abstract_type = /datum/anvil_recipe/valuables/steel
	required_material = /obj/item/ingot/steel
	craftdiff = 2
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/steel/statue
	name = "Steel Statue"
	created_item = /obj/item/statue/steel

// --------- SILVER -----------

/datum/anvil_recipe/valuables/silver
	abstract_type = /datum/anvil_recipe/valuables/silver
	required_material = /obj/item/ingot/silver
	craftdiff = 3
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/silver/statue
	name = "Silver Statue"
	created_item = /obj/item/statue/silver

/datum/anvil_recipe/valuables/silver/volf
	name = "Silver Volf Bust (+Silver Bar)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/volf

/datum/anvil_recipe/valuables/silver/urn
	name = "Silver Urn (+Silver Bar)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/urn

/datum/anvil_recipe/valuables/silver/vasefancy
	name = "Fancy Silver Vase (+Silver Bar)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/vasefancy

/datum/anvil_recipe/valuables/silver/finger
	name = "Silver Middle Finger (+2 Silver Bar)"
	additional_items = list(/obj/item/ingot/silver/, /obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/finger

/datum/anvil_recipe/valuables/silver/bust
	name = "Silver Bust"
	created_item = /obj/item/statue/silver/bust

/datum/anvil_recipe/valuables/silver/vase
	name = "Silver Vase"
	created_item = /obj/item/statue/silver/vase

/datum/anvil_recipe/valuables/silver/totem
	name = "Silver Totem"
	created_item = /obj/item/statue/silver/totem

/datum/anvil_recipe/valuables/silver/teapot
	name = "Silver Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/silver

/datum/anvil_recipe/valuables/silver/obelisk
	name = "Silver Obelisk"
	created_item = /obj/item/statue/silver/obelisk

/datum/anvil_recipe/valuables/silver/tablet
	name = "Silver Tablet"
	created_item = /obj/item/statue/silver/tablet

/datum/anvil_recipe/valuables/silver/comb
	name = "Silver Combs"
	created_item = /obj/item/statue/silver/comb
	output_amount = 2

/datum/anvil_recipe/valuables/silver/figurine
	name = "Silver Figurines"
	created_item = /obj/item/statue/silver/figurine
	output_amount = 2

/datum/anvil_recipe/valuables/silver/cameo
	name = "Silver Cameo's"
	created_item = /obj/item/statue/silver/cameo
	output_amount = 2

/datum/anvil_recipe/valuables/silver/fish
	name = "Silver Fish"
	created_item = /obj/item/statue/silver/fish
	output_amount = 2

/datum/anvil_recipe/valuables/silver/rings
	name = "Silver Rings"
	created_item = /obj/item/clothing/ring/silver
	output_amount = 3

/datum/anvil_recipe/valuables/silver/diadem
	name = "Silver Diadem"
	created_item = /obj/item/clothing/head/crown/circlet/silverdiadem

/datum/anvil_recipe/valuables/silver/nosechain
	name = "Silver Nosechain's"
	created_item = /obj/item/clothing/face/facemask/silvernosechain
	output_amount = 2
/datum/anvil_recipe/valuables/silver/faceveil
	name = "Silver Face Veil"
	created_item = /obj/item/clothing/face/facemask/silverveil

/datum/anvil_recipe/valuables/silver/headdress
	name = "Ziliquae Headdress"
	created_item = /obj/item/clothing/head/crown/circlet/silverheaddress

/datum/anvil_recipe/valuables/silver/sbracelet
	name = "Silver Bracelets"
	created_item = /obj/item/clothing/wrists/silverbracelet
	output_amount = 2

/datum/anvil_recipe/valuables/silver/amulet
	name = "Silver Amulets"
	created_item = /obj/item/clothing/neck/silveramulet
	output_amount = 2

/datum/anvil_recipe/valuables/silver/dorpels
	name = "Silver Dorpel Ring"
	additional_items = list(/obj/item/gem/diamond)
	created_item = /obj/item/clothing/ring/silver/dorpel
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/blortzs
	name = "Silver Blortz Ring"
	additional_items = list(/obj/item/gem/blue)
	created_item = /obj/item/clothing/ring/silver/blortz
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/saffiras
	name = "Silver Saffira Ring"
	additional_items = list(/obj/item/gem/violet)
	created_item = /obj/item/clothing/ring/silver/saffira
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/gemeralds
	name = "Silver Gemerald Ring"
	additional_items = list(/obj/item/gem/green)
	created_item = /obj/item/clothing/ring/silver/gemerald
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/topers
	name = "Silver Toper Ring"
	additional_items = list(/obj/item/gem/yellow)
	created_item = /obj/item/clothing/ring/silver/toper
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/rontzs
	name = "Silver Rontz Ring"
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/silver/rontz
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/maker_ring
	name = "Maker's guild ring"
	created_item = /obj/item/clothing/ring/silver/makers_guild
	craftdiff = 6

// --------- GOLD -----------

/datum/anvil_recipe/valuables/gold
	required_material = /obj/item/ingot/gold
	abstract_type = /datum/anvil_recipe/valuables/gold
	craftdiff = 4
//////////////////////////////////////////////

/datum/anvil_recipe/valuables/gold/statue
	name = "Golden Statue"
	created_item = /obj/item/statue/gold

/datum/anvil_recipe/valuables/gold/bust
	name = "Golden Bust"
	created_item = /obj/item/statue/gold/bust

/datum/anvil_recipe/valuables/gold/finger
	name = "Golden Middle Finger (2+ Gold Bars)"
	additional_items = list(/obj/item/ingot/gold/, /obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/finger

/datum/anvil_recipe/valuables/gold/volf
	name = "Golden Volf Bust (+ Gold Bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/volf

/datum/anvil_recipe/valuables/gold/urn
	name = "Gold Urn (+ Gold Bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/urn

/datum/anvil_recipe/valuables/gold/vasefancy
	name = "Fancy Gold Vase (+ Gold Bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/vasefancy

/datum/anvil_recipe/valuables/gold/vase
	name = "Gold Vase"
	created_item = /obj/item/statue/gold/vase

/datum/anvil_recipe/valuables/gold/obelisk
	name = "Gold Obelisk"
	created_item = /obj/item/statue/gold/obelisk

/datum/anvil_recipe/valuables/gold/totem
	name = "Gold Totem"
	created_item = /obj/item/statue/gold/totem

/datum/anvil_recipe/valuables/gold/teapot
	name = "Golden Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/gold

/datum/anvil_recipe/valuables/gold/tablet
	name = "Golden Tablet"
	created_item = /obj/item/statue/gold/tablet

/datum/anvil_recipe/valuables/gold/cameo
	name = "Golden Cameos"
	created_item = /obj/item/statue/gold/cameo
	output_amount = 2

/datum/anvil_recipe/valuables/gold/comb
	name = "Gold Combs"
	created_item = /obj/item/statue/gold/comb
	output_amount = 2

/datum/anvil_recipe/valuables/gold/figurine
	name = "Gold Figurines"
	created_item = /obj/item/statue/gold/figurine
	output_amount = 2

/datum/anvil_recipe/valuables/gold/bracelet
	name = "Gold Bracelets"
	created_item = /obj/item/clothing/wrists/goldbracelet
	output_amount = 2

/datum/anvil_recipe/valuables/gold/amulet
	name = "Gold Amulets"
	created_item = /obj/item/clothing/neck/goldamulet
	output_amount = 2

/datum/anvil_recipe/valuables/gold/fish
	name = "Golden Fish Figurines"
	created_item = /obj/item/statue/gold/fish
	output_amount = 2

/datum/anvil_recipe/valuables/gold/circulet
	name = "Golden Circlet"
	created_item = /obj/item/clothing/head/crown/circlet

/datum/anvil_recipe/valuables/gold/rings
	name = "Gold Rings"
	created_item = /obj/item/clothing/ring/gold
	output_amount = 3

/datum/anvil_recipe/valuables/gold/diadem
	name = "Gold Diadem"
	created_item = /obj/item/clothing/head/crown/circlet/golddiadem

/datum/anvil_recipe/valuables/gold/nosechain
	name = "Gold Nosechain's"
	created_item = /obj/item/clothing/face/facemask/goldnosechain
	output_amount = 2

/datum/anvil_recipe/valuables/gold/faceveil
	name = "Golden Face Veil"
	created_item = /obj/item/clothing/face/facemask/goldveil

/datum/anvil_recipe/valuables/gold/headdress
	name = "Zenarii Headdress"
	created_item = /obj/item/clothing/head/crown/circlet/goldheaddress

/datum/anvil_recipe/valuables/gold/dorpel
	name = "Golden Dorpel Ring"
	additional_items = list(/obj/item/gem/diamond)
	created_item = /obj/item/clothing/ring/gold/dorpel
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/blortz
	name = "Golden Blortz Ring"
	additional_items = list(/obj/item/gem/blue)
	created_item = /obj/item/clothing/ring/gold/blortz
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/saffira
	name = "Golden Saffira Ring"
	additional_items = list(/obj/item/gem/violet)
	created_item = /obj/item/clothing/ring/gold/saffira
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/gemerald
	name = "Golden Gemerald Ring"
	additional_items = list(/obj/item/gem/green)
	created_item = /obj/item/clothing/ring/gold/gemerald
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/toper
	name = "Golden Toper Ring"
	additional_items = list(/obj/item/gem/yellow)
	created_item = /obj/item/clothing/ring/gold/toper
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/rontz
	name = "Golden Rontz Ring"
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/gold/rontz
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/mercator_ring
	name = "Golden Mercator Ring"
	created_item = /obj/item/clothing/ring/gold/guild_mercator
	craftdiff = 6

/datum/anvil_recipe/valuables/gold/sparrow_crown
	name = "Champion's circlet"
	created_item = /obj/item/clothing/head/crown/sparrowcrown
	craftdiff = 6

/datum/anvil_recipe/valuables/signet
	name = "Signet Ring"
	required_material = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/signet

/datum/anvil_recipe/valuables/signet/silver
	name = "Blessed Silver Signet Ring"
	craftdiff = SKILL_LEVEL_MASTER
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/ring/signet/silver

/datum/anvil_recipe/valuables/signet/silver/inq
	name = "Blessed Silver Signet Ring"
	craftdiff = SKILL_LEVEL_MASTER
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/ring/signet/silver

// --------- BRONZE -----------

/datum/anvil_recipe/valuables/bronze
	required_material = /obj/item/ingot/bronze
	abstract_type = /datum/anvil_recipe/valuables/bronze
	craftdiff = 1
//////////////////////////////////////////////

/datum/anvil_recipe/valuables/bronze/statue
	name = "Bronze Statue"
	created_item = /obj/item/statue/bronze

/datum/anvil_recipe/valuables/bronze/bust
	name = "Bronze Bust"
	created_item = /obj/item/statue/bronze/bust

/datum/anvil_recipe/valuables/bronze/volf
	name = "Bronze Volf Bust (+ Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/volf

/datum/anvil_recipe/valuables/bronze/urn
	name = "Bronze Urn (+ Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/urn

/datum/anvil_recipe/valuables/bronze/vasefancy
	name = "Fancy Bronze Vase (+ Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/vasefancy

/datum/anvil_recipe/valuables/bronze/vase
	name = "Bronze Vase"
	created_item = /obj/item/statue/bronze/vase

/datum/anvil_recipe/valuables/bronze/obelisk
	name = "Bronze Obelisk"
	created_item = /obj/item/statue/bronze/obelisk

/datum/anvil_recipe/valuables/bronze/totem
	name = "Bronze Totem"
	created_item = /obj/item/statue/bronze/totem

/datum/anvil_recipe/valuables/bronze/teapot
	name = "Bronze Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/bronze

/datum/anvil_recipe/valuables/bronze/tablet
	name = "Bronze Tablet"
	created_item = /obj/item/statue/bronze/tablet

/datum/anvil_recipe/valuables/bronze/cameo
	name = "Bronze Cameos"
	created_item = /obj/item/statue/bronze/cameo
	output_amount = 2

/datum/anvil_recipe/valuables/bronze/comb
	name = "Bronze Combs"
	created_item = /obj/item/statue/bronze/comb
	output_amount = 2

/datum/anvil_recipe/valuables/bronze/figurine
	name = "Bronze Figurines"
	created_item = /obj/item/statue/bronze/figurine
	output_amount = 2

/datum/anvil_recipe/valuables/bronze/fish
	name = "Bronze Fish Figurines"
	created_item = /obj/item/statue/bronze/fish
	output_amount = 2
