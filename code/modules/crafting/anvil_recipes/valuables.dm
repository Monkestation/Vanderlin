/datum/anvil_recipe/valuables
	appro_skill = /datum/skill/craft/blacksmithing
	i_type = "Valuables"
	abstract_type = /datum/anvil_recipe/valuables
	category = "Valuables"

// --------- IRON -----------

/datum/anvil_recipe/valuables/gold_mask
	name = "Golden Half Mask"
	recipe_name = "a golden half mask"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask
	craftdiff = 2

/datum/anvil_recipe/valuables/gold_mask_left
	name = "Golden Half Mask (Left)"
	recipe_name = "a golden half mask"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask/l
	craftdiff = 2

/datum/anvil_recipe/valuables/iron
	req_bar = /obj/item/ingot/iron
	abstract_type = /datum/anvil_recipe/valuables/iron
	craftdiff = 1
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/iron/statue
	name = "Iron Statue"
	recipe_name = "a Statue"
	created_item = /obj/item/statue/iron

// --------- STEEL -----------


/datum/anvil_recipe/valuables/rontzs
	name = "Silver Face Mask"
	recipe_name = "a silver face mask"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/face/facemask/silver
	craftdiff = 2

/datum/anvil_recipe/valuables/steel
	abstract_type = /datum/anvil_recipe/valuables/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = 2
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/steel/statue
	name = "Steel Statue"
	recipe_name = "a Statue"
	created_item = /obj/item/statue/steel

// --------- SILVER -----------

/datum/anvil_recipe/valuables/silver
	abstract_type = /datum/anvil_recipe/valuables/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = 3
///////////////////////////////////////////////

/datum/anvil_recipe/valuables/silver/statue
	name = "Silver Statue"
	recipe_name = "a Statue"
	created_item = /obj/item/statue/silver

/datum/anvil_recipe/valuables/silver/volf
	name = "Silver Volf Bust (+Silver Bar)"
	recipe_name = "a Silver Volf Bust"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/volf

/datum/anvil_recipe/valuables/silver/urn
	name = "Silver Urn (+Silver Bar)"
	recipe_name = "a Silver Urn"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/urn

/datum/anvil_recipe/valuables/silver/vasefancy
	name = "Fancy Silver Vase (+Silver Bar)"
	recipe_name = "a Fancy Silver Vase"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/vasefancy

/datum/anvil_recipe/valuables/silver/finger
	name = "Silver Middle Finger (+2 Silver Bar)"
	recipe_name = "a Silver Middle Finger "
	additional_items = list(/obj/item/ingot/silver/, /obj/item/ingot/silver)
	created_item = /obj/item/statue/silver/finger

/datum/anvil_recipe/valuables/silver/bust
	name = "Silver Bust"
	recipe_name = "a Silver Bust"
	created_item = /obj/item/statue/silver/bust

/datum/anvil_recipe/valuables/silver/vase
	name = "Silver Vase"
	recipe_name = "a Silver Vase"
	created_item = /obj/item/statue/silver/vase

/datum/anvil_recipe/valuables/silver/totem
	name = "Silver Totem"
	recipe_name = "a Silver Totem"
	created_item = /obj/item/statue/silver/totem

/datum/anvil_recipe/valuables/silver/teapot
	name = "Silver Teapot"
	recipe_name = "a Silver Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/silver

/datum/anvil_recipe/valuables/silver/obelisk
	name = "Silver Obelisk"
	recipe_name = "a Silver Obelisk"
	created_item = /obj/item/statue/silver/obelisk

/datum/anvil_recipe/valuables/silver/tablet
	name = "Silver Tablet"
	recipe_name = "a Silver Tablet"
	created_item = /obj/item/statue/silver/tablet

/datum/anvil_recipe/valuables/silver/comb
	name = "2x Silver Combs"
	recipe_name = "two Silver Combs"
	created_item = /obj/item/statue/silver/comb
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/figurine
	name = "2x Silver Figurines"
	recipe_name = "two Silver Figurines"
	created_item = /obj/item/statue/silver/figurine
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/cameo
	name = "2x Silver Cameo's"
	recipe_name = "two Silver Cameo's"
	created_item = /obj/item/statue/silver/cameo
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/fish
	name = "2x Silver Fish"
	recipe_name = "two Silver Fish"
	created_item = /obj/item/statue/silver/fish
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/rings
	name = "3x Silver Rings"
	recipe_name = "three Rings"
	created_item = /obj/item/clothing/ring/silver
	createditem_extra = 2

/datum/anvil_recipe/valuables/silver/diadem
	name = "Silver Diadem"
	recipe_name = "a Silver Diadem"
	created_item = /obj/item/clothing/head/crown/circlet/silverdiadem

/datum/anvil_recipe/valuables/silver/nosechain
	name = "2x Silver Nosechain's"
	recipe_name = "two Silver Nosechains"
	created_item = /obj/item/clothing/face/facemask/silvernosechain
	createditem_extra = 1
/datum/anvil_recipe/valuables/silver/faceveil
	name = "Silver Face Veil"
	recipe_name = "a Silver Veil"
	created_item = /obj/item/clothing/face/facemask/silverveil

/datum/anvil_recipe/valuables/silver/headdress
	name = "Ziliquae Headdress"
	recipe_name = "a Ziliquae Headdress"
	created_item = /obj/item/clothing/head/crown/circlet/silverheaddress

/datum/anvil_recipe/valuables/silver/sbracelet
	name = "2x Silver Bracelets"
	recipe_name = "two Silver Bracelets"
	created_item = /obj/item/clothing/wrists/silverbracelet
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/amulet
	name = "2x Silver Amulets"
	recipe_name = "two Silver Amulets"
	created_item = /obj/item/clothing/neck/silveramulet
	createditem_extra = 1

/datum/anvil_recipe/valuables/silver/dorpels
	name = "Silver Dorpel Ring"
	recipe_name = "a Silver Dorpel Ring"
	additional_items = list(/obj/item/gem/diamond)
	created_item = /obj/item/clothing/ring/silver/dorpel
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/blortzs
	name = "Silver Blortz Ring"
	recipe_name = "a Silver Blortz Ring"
	additional_items = list(/obj/item/gem/blue)
	created_item = /obj/item/clothing/ring/silver/blortz
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/saffiras
	name = "Silver Saffira Ring"
	recipe_name = "a Silver Saffira Ring"
	additional_items = list(/obj/item/gem/violet)
	created_item = /obj/item/clothing/ring/silver/saffira
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/gemeralds
	name = "Silver Gemerald Ring"
	recipe_name = "a Silver Gemerald Ring"
	additional_items = list(/obj/item/gem/green)
	created_item = /obj/item/clothing/ring/silver/gemerald
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/topers
	name = "Silver Toper Ring"
	recipe_name = "a Silver Toper Ring"
	additional_items = list(/obj/item/gem/yellow)
	created_item = /obj/item/clothing/ring/silver/toper
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/rontzs
	name = "Silver Rontz Ring"
	recipe_name = "a Silver Rontz Ring"
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/silver/rontz
	craftdiff = 4

/datum/anvil_recipe/valuables/silver/maker_ring
	name = "Maker's guild ring"
	recipe_name = "a silver maker's guild ring"
	created_item = /obj/item/clothing/ring/silver/makers_guild
	craftdiff = 6

// --------- GOLD -----------

/datum/anvil_recipe/valuables/gold
	req_bar = /obj/item/ingot/gold
	abstract_type = /datum/anvil_recipe/valuables/gold
	craftdiff = 4
//////////////////////////////////////////////

/datum/anvil_recipe/valuables/gold/statue
	name = "Golden Statue"
	recipe_name = "a Statue"
	created_item = /obj/item/statue/gold

/datum/anvil_recipe/valuables/gold/bust
	name = "Golden Bust"
	recipe_name = "a Golden Bust"
	created_item = /obj/item/statue/gold/bust

/datum/anvil_recipe/valuables/gold/finger
	name = "Golden Middle Finger (2+ Gold Bars)"
	recipe_name = "a Golden Middle Finger"
	additional_items = list(/obj/item/ingot/gold/, /obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/finger

/datum/anvil_recipe/valuables/gold/volf
	name = "Golden Volf Bust (+ Gold Bar)"
	recipe_name = "a Golden Volf Bust"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/volf

/datum/anvil_recipe/valuables/gold/urn
	name = "Gold Urn (+ Gold Bar)"
	recipe_name = "a Golden Urn"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/urn

/datum/anvil_recipe/valuables/gold/vasefancy
	name = "Fancy Gold Vase (+ Gold Bar)"
	recipe_name = "a Fancy Golden Vase"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/statue/gold/vasefancy

/datum/anvil_recipe/valuables/gold/vase
	name = "Gold Vase"
	recipe_name = "a Golden Vase"
	created_item = /obj/item/statue/gold/vase

/datum/anvil_recipe/valuables/gold/obelisk
	name = "Gold Obelisk"
	recipe_name = "a Golden Obelisk"
	created_item = /obj/item/statue/gold/obelisk

/datum/anvil_recipe/valuables/gold/totem
	name = "Gold Totem"
	recipe_name = "a Golden Totem"
	created_item = /obj/item/statue/gold/totem

/datum/anvil_recipe/valuables/gold/teapot
	name = "Golden Teapot"
	recipe_name = "a Golden Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/gold

/datum/anvil_recipe/valuables/gold/tablet
	name = "Golden Tablet"
	recipe_name = "a Golden Tablet"
	created_item = /obj/item/statue/gold/tablet

/datum/anvil_recipe/valuables/gold/cameo
	name = "2x Golden Cameos"
	recipe_name = "two Gold Cameos"
	created_item = /obj/item/statue/gold/cameo
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/comb
	name = "2x Gold Combs"
	recipe_name = "two Gold Combs"
	created_item = /obj/item/statue/gold/comb
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/figurine
	name = "2x Gold Figurines"
	recipe_name = "two Gold Figurines"
	created_item = /obj/item/statue/gold/figurine
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/bracelet
	name = "2x Gold Bracelets"
	recipe_name = "two Gold Bracelets"
	created_item = /obj/item/clothing/wrists/goldbracelet
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/amulet
	name = "2x Gold Amulets"
	recipe_name = "two Gold Amulets"
	created_item = /obj/item/clothing/neck/goldamulet
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/fish
	name = "2x Golden Fish Figurines"
	recipe_name = "two Gold Fish Figurines"
	created_item = /obj/item/statue/gold/fish
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/circulet
	name = "Golden Circlet"
	recipe_name = "a golden circlet"
	created_item = /obj/item/clothing/head/crown/circlet

/datum/anvil_recipe/valuables/gold/rings
	name = "3x Gold Rings"
	recipe_name = "three Rings" // For the Elven kings under the sky...
	created_item = /obj/item/clothing/ring/gold
	createditem_extra = 2

/datum/anvil_recipe/valuables/gold/diadem
	name = "Gold Diadem"
	recipe_name = "a Gold Diadem"
	created_item = /obj/item/clothing/head/crown/circlet/golddiadem

/datum/anvil_recipe/valuables/gold/nosechain
	name = "2x Gold Nosechain's"
	recipe_name = "two Silver Nosechains"
	created_item = /obj/item/clothing/face/facemask/goldnosechain
	createditem_extra = 1

/datum/anvil_recipe/valuables/gold/faceveil
	name = "Golden Face Veil"
	recipe_name = "a Golden Veil"
	created_item = /obj/item/clothing/face/facemask/goldveil

/datum/anvil_recipe/valuables/gold/headdress
	name = "Zenarii Headdress"
	recipe_name = "a Zenarii Headdress"
	created_item = /obj/item/clothing/head/crown/circlet/goldheaddress

/datum/anvil_recipe/valuables/gold/dorpel
	name = "Golden Dorpel Ring"
	recipe_name = "a Golden Dorpel Ring"
	additional_items = list(/obj/item/gem/diamond)
	created_item = /obj/item/clothing/ring/gold/dorpel
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/blortz
	name = "Golden Blortz Ring"
	recipe_name = "a Golden Blortz Ring"
	additional_items = list(/obj/item/gem/blue)
	created_item = /obj/item/clothing/ring/gold/blortz
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/saffira
	name = "Golden Saffira Ring"
	recipe_name = "a Golden Saffira Ring"
	additional_items = list(/obj/item/gem/violet)
	created_item = /obj/item/clothing/ring/gold/saffira
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/gemerald
	name = "Golden Gemerald Ring"
	recipe_name = "a Golden Gemerald Ring"
	additional_items = list(/obj/item/gem/green)
	created_item = /obj/item/clothing/ring/gold/gemerald
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/toper
	name = "Golden Toper Ring"
	recipe_name = "a Golden Toper Ring"
	additional_items = list(/obj/item/gem/yellow)
	created_item = /obj/item/clothing/ring/gold/toper
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/rontz
	name = "Golden Rontz Ring"
	recipe_name = "a Golden Rontz Ring"
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/gold/rontz
	craftdiff = 5

/datum/anvil_recipe/valuables/gold/mercator_ring
	name = "Golden Mercator Ring"
	recipe_name = "a Golden Mercator Ring"
	created_item = /obj/item/clothing/ring/gold/guild_mercator
	craftdiff = 6

/datum/anvil_recipe/valuables/gold/sparrow_crown
	name = "Champion's circlet"
	recipe_name = "worthy of a champion"
	created_item = /obj/item/clothing/head/crown/sparrowcrown
	craftdiff = 6

/datum/anvil_recipe/valuables/signet
	name = "Signet Ring"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/signet

/datum/anvil_recipe/valuables/signet/silver
	name = "Blessed Silver Signet Ring"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/ring/signet/silver

/datum/anvil_recipe/valuables/signet/silver/inq
	name = "Blessed Silver Signet Ring"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/ring/signet/silver

// --------- BRONZE -----------

/datum/anvil_recipe/valuables/bronze
	req_bar = /obj/item/ingot/bronze
	abstract_type = /datum/anvil_recipe/valuables/bronze
	craftdiff = 1
//////////////////////////////////////////////

/datum/anvil_recipe/valuables/bronze/statue
	name = "Bronze Statue"
	recipe_name = "a Bronze Statue"
	created_item = /obj/item/statue/bronze

/datum/anvil_recipe/valuables/bronze/bust
	name = "Bronze Bust"
	recipe_name = "a Bronze Bust"
	created_item = /obj/item/statue/bronze/bust

/datum/anvil_recipe/valuables/bronze/volf
	name = "Bronze Volf Bust (+ Bronze Bar)"
	recipe_name = "a Bronze Volf Bust"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/volf

/datum/anvil_recipe/valuables/bronze/urn
	name = "Bronze Urn (+ Bronze Bar)"
	recipe_name = "a Bronze Urn"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/urn

/datum/anvil_recipe/valuables/bronze/vasefancy
	name = "Fancy Bronze Vase (+ Bronze Bar)"
	recipe_name = "a Fancy Bronze Vase"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/statue/bronze/vasefancy

/datum/anvil_recipe/valuables/bronze/vase
	name = "Bronze Vase"
	recipe_name = "a Bronze Vase"
	created_item = /obj/item/statue/bronze/vase

/datum/anvil_recipe/valuables/bronze/obelisk
	name = "Bronze Obelisk"
	recipe_name = "a Bronze Obelisk"
	created_item = /obj/item/statue/bronze/obelisk

/datum/anvil_recipe/valuables/bronze/totem
	name = "Bronze Totem"
	recipe_name = "a Bronze Totem"
	created_item = /obj/item/statue/bronze/totem

/datum/anvil_recipe/valuables/bronze/teapot
	name = "Bronze Teapot"
	recipe_name = "a Bronze Teapot"
	created_item = /obj/item/reagent_containers/glass/carafe/teapot/bronze

/datum/anvil_recipe/valuables/bronze/tablet
	name = "Bronze Tablet"
	recipe_name = "a Bronze Tablet"
	created_item = /obj/item/statue/bronze/tablet

/datum/anvil_recipe/valuables/bronze/cameo
	name = "2x Bronze Cameos"
	recipe_name = "two Bronze Cameos"
	created_item = /obj/item/statue/bronze/cameo
	createditem_extra = 1

/datum/anvil_recipe/valuables/bronze/comb
	name = "2x Bronze Combs"
	recipe_name = "two Bronze Combs"
	created_item = /obj/item/statue/bronze/comb
	createditem_extra = 1

/datum/anvil_recipe/valuables/bronze/figurine
	name = "2x Bronze Figurines"
	recipe_name = "two Bronze Figurines"
	created_item = /obj/item/statue/bronze/figurine
	createditem_extra = 1

/datum/anvil_recipe/valuables/bronze/fish
	name = "2x Bronze Fish Figurines"
	recipe_name = "two bronze Fish Figurines"
	created_item = /obj/item/statue/bronze/fish
	createditem_extra = 1
