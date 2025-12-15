GLOBAL_LIST_INIT(natural_precursor_registry, list())
/proc/initialize_natural_precursors()
	for(var/datum/natural_precursor/precursor as anything in subtypesof(/datum/natural_precursor))
		var/datum/natural_precursor/created_precursor = new precursor
		for(var/atom/atom_path as anything in created_precursor.init_types)
			GLOB.natural_precursor_registry[atom_path] = created_precursor

/proc/get_precursor_data(obj/item/I)
	if(!length(GLOB.natural_precursor_registry))
		initialize_natural_precursors()
	if(!(I.type in GLOB.natural_precursor_registry))
		return FALSE
	return GLOB.natural_precursor_registry[I.type]

/datum/natural_precursor
	abstract_type = /datum/natural_precursor
	var/category = "Precursor"
	var/name = "precursor"
	var/list/essence_yields = list() // essence_type = amount
	var/list/init_types = list() //list of all types that use this precursor


/datum/natural_precursor/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			.icon {
				width: 64px;
				height: 64px;
				vertical-align: middle;
				margin-right: 10px;
			}
			.yields {
				margin-bottom: 20px;
			}
			.category {
				font-style: italic;
				color: #8d6e63;
				margin-bottom: 10px;
			}
			.used-in {
				margin-top: 15px;
				font-style: italic;
				color: #5d4037;
			}
		</style>
		<body>
		  <div>
			<h1>[name]</h1>
			<div class="category">[category]</div>
			<div class="yields">
			  <h2>Essence Yields</h2>
	"}

	// Add essence yields
	if(length(essence_yields))
		for(var/datum/thaumaturgical_essence/essence_type as anything in essence_yields)
			var/essence_amount = essence_yields[essence_type]
			html += "[essence_amount] [essence_type.name]<br>"
	else
		html += "No essence yields<br>"

	html += {"
		</div>
	"}

	// Add usage information
	if(length(init_types))
		html += "<div class='used-in'><h2>Splits from</h2>"
		for(var/atom/type_path as anything in init_types)
			html += "[initial(type_path.name)]<br>"
		html += "</div>"

	html += {"
		</div>
	</body>
	</html>
	"}

	return html

/datum/natural_precursor/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=natural_precursor;size=500x810")

/*
--------------------PLANTS AND PRODUCE--------------------
*/

/datum/natural_precursor/vegetable
	name = "vegetable"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/water = 1,
		/datum/thaumaturgical_essence/life = 1,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/vegetable,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/potato,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/onion,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/turnip,
	)

/datum/natural_precursor/fruit
	name = "fruit"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 2,
		/datum/thaumaturgical_essence/water = 1,
		/datum/thaumaturgical_essence/life = 1,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit,
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple,
		/obj/item/reagent_containers/food/snacks/produce/fruit/strawberry,
		/obj/item/reagent_containers/food/snacks/produce/fruit/blackberry,
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry,
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison,
		/obj/item/reagent_containers/food/snacks/produce/fruit/pear,
		/obj/item/reagent_containers/food/snacks/produce/fruit/lemon,
		/obj/item/reagent_containers/food/snacks/produce/fruit/lime,
		/obj/item/reagent_containers/food/snacks/produce/fruit/tangerine,
		/obj/item/reagent_containers/food/snacks/produce/fruit/plum,
		/obj/item/reagent_containers/food/snacks/produce/fruit/mango,
		/obj/item/reagent_containers/food/snacks/produce/fruit/mangosteen,
		/obj/item/reagent_containers/food/snacks/produce/fruit/dragonfruit,
		/obj/item/reagent_containers/food/snacks/produce/fruit/avocado,
		/obj/item/reagent_containers/food/snacks/produce/fruit/pineapple,
	)

/datum/natural_precursor/grain
	name = "grain"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/earth = 1,
		/datum/thaumaturgical_essence/life = 1,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/grain,
		/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
		/obj/item/reagent_containers/food/snacks/produce/grain/oat,
	)

/datum/natural_precursor/mushroom
	name = "mushroom"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 3,
		/datum/thaumaturgical_essence/life = 1
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/mushroom,
	)

/datum/natural_precursor/swampweed
	name = "swampweed"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/chaos = 2,
		/datum/thaumaturgical_essence/poison = 1,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/swampweed,
		/obj/item/reagent_containers/food/snacks/produce/swampweed_dried,
	)

/datum/natural_precursor/sunflower
	name = "sunflower"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 2,
		/datum/thaumaturgical_essence/life = 3,
		/datum/thaumaturgical_essence/light = 5,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/sunflower,
	)

/datum/natural_precursor/fyritius
	name = "fyritius flower"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/fyritius,
	)

/datum/natural_precursor/poppy
	name = "poppy"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/chaos = 2,
		/datum/thaumaturgical_essence/poison = 1
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/poppy,
	)

/*
--------------------WOOD AND STONE--------------------
*/

/datum/natural_precursor/stone
	name = "stone"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 3,
		/datum/thaumaturgical_essence/order = 1,
	)
	init_types = list(
		/obj/item/natural/stone,
		/obj/item/natural/stone/sending,
	)

/datum/natural_precursor/wood
	name = "wood"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 3,
		/datum/thaumaturgical_essence/order = 1
	)
	init_types = list(
		/obj/item/grown/log/tree,
		/obj/item/grown/log/tree/small,
	)

/datum/natural_precursor/plank
	name = "wooden plank"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 1,
		/datum/thaumaturgical_essence/order = 3,
	)
	init_types = list(
		/obj/item/natural/wood/plank,
	)

/datum/natural_precursor/stoneblock
	name = "stone block"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 1,
		/datum/thaumaturgical_essence/order = 3,
	)
	init_types = list(
		/obj/item/natural/stoneblock
	)

/*
--------------------ORES AND GEMS--------------------
*/
//featuring coal and charcoal from the devil may cry series

//Why are there so many gem categories?
//since gems are rarer than other items, they can have their own specialized category, akin to the alchemy dusts
//each gem shouldn't have its own unique category, but rather it should be assigned to a unique category, for example
//the gem_magic precursor is for gems strongly connected to magic
//gem_frost precursor is for gems strongly connected to frost
//and so on and so on
//gem_fire and gem_water, atm of writing, have one gem each
//but more gems can be added in the future

/datum/natural_precursor/gem_magic
	name = "magic gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/magic = 2,
	)
	init_types = list(
		/obj/item/gem/amethyst,
		/obj/item/gem/violet,
	)

/datum/natural_precursor/gem_light
	name = "light gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/light = 4,
	)
	init_types = list(
		/obj/item/gem/yellow,
		/obj/item/gem/amber,
	)

/datum/natural_precursor/gem_frost
	name = "frost gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/frost = 4,
	)
	init_types = list(
		/obj/item/gem/blue,
		/obj/item/gem/turq,//frost because its associated with necra
	)

//we can assume opal is really dense due to being seen as crystallized rainbow
//also something about E = cm^2, you get the idea I hope
/datum/natural_precursor/gem_energia
	name = "energia gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/energia = 4,
	)
	init_types = list(
		/obj/item/gem/opal,
		/obj/item/gem/diamond,
	)

/datum/natural_precursor/gem_earth
	name = "earth gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/earth = 8,
	)
	init_types = list(
		/obj/item/gem/green,
		/obj/item/gem/jade,
	)

/datum/natural_precursor/gem_fire
	name = "fire gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/fire = 8,
	)
	init_types = list(
		/obj/item/gem/red,
	)

/datum/natural_precursor/gem_water
	name = "water gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/water = 8,
	)
	init_types = list(
		/obj/item/gem/oyster,
	)

/datum/natural_precursor/gem_void
	name = "void gem"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 6,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/void = 4,
	)
	init_types = list(
		/obj/item/gem/onyxa,
		/obj/item/gem/coral,
	)

/datum/natural_precursor/riddleofsteel
	name = "riddle of steel"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 50,
		/datum/thaumaturgical_essence/order = 40,
		/datum/thaumaturgical_essence/earth = 30,
		/datum/thaumaturgical_essence/fire = 30,
	)
	init_types = list(
		/obj/item/riddleofsteel
	)

/datum/natural_precursor/coal
	name = "coal"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 3,
		/datum/thaumaturgical_essence/earth = 2
	)
	init_types = list(
		/obj/item/ore/coal,
		/obj/item/ore/coal/charcoal,
	)

/datum/natural_precursor/quicksilver
	name = "quicksilver"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 3,
		/datum/thaumaturgical_essence/poison = 1
	)
	init_types = list(
		/obj/item/ore/cinnabar,
		/obj/item/chalk,
	)

/datum/natural_precursor/common_ore
	name = "common ore"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 3,
		/datum/thaumaturgical_essence/order = 1
	)
	init_types = list(
		/obj/item/ore/iron,
		/obj/item/ore/copper,
		/obj/item/ore/tin,
	)

/datum/natural_precursor/noble_ore
	name = "noble ore"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/energia = 1,
	)
	init_types = list(
		/obj/item/ore/gold,
		/obj/item/ore/silver,
	)

/*
--------------------HERBS--------------------
*/

//Try to keep the herbs being 1 T0 essence and 1 T1 essence
//T1 essences should primarly be poison, life and cycle, but feel free to go wild

//earth herbs
/datum/natural_precursor/atropa
	name = "atropa"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/poison = 5
	)
	init_types = list(
		/obj/item/alch/herb/atropa
	)

/datum/natural_precursor/matricaria
	name = "matricaria"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/cycle = 5
	)
	init_types = list(
		/obj/item/alch/herb/matricaria
	)

/datum/natural_precursor/euphorbia
	name = "euphorbia"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/alch/herb/euphorbia
	)

/datum/natural_precursor/salvia
	name = "salvia"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/void = 5
	)
	init_types = list(
		/obj/item/alch/herb/salvia
	)

//air herbs
/datum/natural_precursor/symphitum
	name = "symphitum"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/alch/herb/symphitum
	)

/datum/natural_precursor/urtica
	name = "urtica"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 10,
		/datum/thaumaturgical_essence/void = 5
	)
	init_types = list(
		/obj/item/alch/herb/urtica
	)

/datum/natural_precursor/euphrasia
	name = "euphrasia"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 10,
		/datum/thaumaturgical_essence/cycle = 5
	)
	init_types = list(
		/obj/item/alch/herb/euphrasia
	)

//water herbs
/datum/natural_precursor/mentha
	name = "mentha"
	essence_yields = list(
		/datum/thaumaturgical_essence/water = 10,
		/datum/thaumaturgical_essence/frost = 5
	)
	init_types = list(
		/obj/item/alch/herb/mentha
	)

/datum/natural_precursor/paris
	name = "paris"
	essence_yields = list(
		/datum/thaumaturgical_essence/water = 10,
		/datum/thaumaturgical_essence/poison = 5
	)
	init_types = list(
		/obj/item/alch/herb/paris
	)

/datum/natural_precursor/artemisia
	name = "artemisia"
	essence_yields = list(
		/datum/thaumaturgical_essence/water = 10,
		/datum/thaumaturgical_essence/cycle = 5
	)
	init_types = list(
		/obj/item/alch/herb/artemisia
	)

//fire herbs

/datum/natural_precursor/calendula
	name = "calendula"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/alch/herb/calendula
	)

/datum/natural_precursor/taraxacum
	name = "taraxacum"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/motion = 5
	)
	init_types = list(
		/obj/item/alch/herb/taraxacum
	)

/datum/natural_precursor/hypericum
	name = "hypericum"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/cycle = 5
	)
	init_types = list(
		/obj/item/alch/herb/hypericum
	)

//order herbs

/datum/natural_precursor/benedictus
	name = "benedictus"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/crystal = 5
	)
	init_types = list(
		/obj/item/alch/herb/benedictus
	)

/datum/natural_precursor/rosa
	name = "rosa"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/alch/herb/rosa
	)

/datum/natural_precursor/valeriana
	name = "valeriana"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/motion = 5
	)
	init_types = list(
		/obj/item/alch/herb/valeriana
	)

/*
--------------------OTHER NATURAL ITEMS--------------------
*/

/datum/natural_precursor/feather
	name = "feather"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 5,
		/datum/thaumaturgical_essence/motion = 1,
	)
	init_types = list(
		/obj/item/natural/feather,
		/obj/item/natural/feather/infernal
	)

/datum/natural_precursor/obsidian
	name = "obsidian"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 4,
		/datum/thaumaturgical_essence/chaos = 3,
	)
	init_types = list(
		/obj/item/natural/obsidian
	)

/datum/natural_precursor/hide_and_fur
	name = "animal hide and fur"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 2,
		/datum/thaumaturgical_essence/earth = 4
	)
	init_types = list(
		/obj/item/natural/hide,
		/obj/item/natural/hide/cured,
		/obj/item/natural/fur,
		/obj/item/natural/fur/gote,
		/obj/item/natural/fur/volf,
		/obj/item/natural/fur/mole,
		/obj/item/natural/fur/rous,
		/obj/item/natural/fur/cabbit
	)

//intentionally no fibre, turn it into cloth instead
/datum/natural_precursor/cloth_and_silk
	name = "silk and cloth"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 2,
		/datum/thaumaturgical_essence/order = 2
	)
	init_types = list(
		/obj/item/natural/silk,
		/obj/item/natural/cloth
	)

/datum/natural_precursor/clod_and_clay
	name = "dirt and clay"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/water = 1
	)
	init_types = list(
		/obj/item/natural/dirtclod,
		/obj/item/natural/clay
	)

/datum/natural_precursor/glass
	name = "glass shard"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 3
	)
	init_types = list(
		/obj/item/natural/glass,
		/obj/item/natural/glass/shard
	)

/datum/natural_precursor/poo
	name = "animal waste"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 4,
		/datum/thaumaturgical_essence/chaos = 3
	)
	init_types = list(
		/obj/item/natural/poo,
		/obj/item/natural/poo/cow,
		/obj/item/natural/poo/horse
	)

/datum/natural_precursor/worms
	name = "worms"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 2,
		/datum/thaumaturgical_essence/earth = 2
	)
	init_types = list(
		/obj/item/natural/worms,
		/obj/item/natural/worms/grub_silk
	)

/datum/natural_precursor/leech
	name = "leech"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 2,
		/datum/thaumaturgical_essence/water = 2
	)
	init_types = list(
		/obj/item/natural/worms/leech,
		/obj/item/natural/worms/leech/parasite,
		/obj/item/natural/worms/leech/propaganda,
		/obj/item/natural/worms/leech/abyssoid,
	)

/datum/natural_precursor/dendor_essence
	name = "dendor essence"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 10,
		/datum/thaumaturgical_essence/chaos = 10
	)
	init_types = list(
		/obj/item/natural/cured/essence,
		/obj/item/grown/log/tree/essence
	)

/datum/natural_precursor/meat
	name = "meat"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 4,
		/datum/thaumaturgical_essence/order = 3
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/meat/steak,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/fatty,
		/obj/item/reagent_containers/food/snacks/meat/strange,
		/obj/item/reagent_containers/food/snacks/meat/poultry,
		/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet,
		/obj/item/reagent_containers/food/snacks/meat/mince,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef/mett,
		/obj/item/reagent_containers/food/snacks/meat/mince/poultry,
		/obj/item/reagent_containers/food/snacks/meat/sausage,
		/obj/item/reagent_containers/food/snacks/meat/wiener,
		/obj/item/reagent_containers/food/snacks/meat/salami,
		/obj/item/reagent_containers/food/snacks/meat/mince/fish,
	)

/datum/natural_precursor/fish
	name = "fish"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 4,
		/datum/thaumaturgical_essence/order = 3
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/fish/carp,
		/obj/item/reagent_containers/food/snacks/fish/clownfish,
		/obj/item/reagent_containers/food/snacks/fish/angler,
		/obj/item/reagent_containers/food/snacks/fish/eel,
		/obj/item/reagent_containers/food/snacks/fish/shrimp,
		/obj/item/reagent_containers/food/snacks/fish/swordfish,
	)

/datum/natural_precursor/bone
	name = "bone"
	essence_yields = list(
		/datum/thaumaturgical_essence/void = 10,
		/datum/thaumaturgical_essence/crystal = 5
	)
	init_types = list(
		/obj/item/alch/bone,
	)

/datum/natural_precursor/sinew
	name = "sinew"
	essence_yields = list(
		/datum/thaumaturgical_essence/life = 10,
		/datum/thaumaturgical_essence/motion = 5
	)
	init_types = list(
		/obj/item/alch/sinew
	)

/datum/natural_precursor/viscera
	name = "viscera"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 10,
		/datum/thaumaturgical_essence/poison = 5
	)
	init_types = list(
		/obj/item/alch/viscera
	)

/datum/natural_precursor/bonemeal
	name = "bone meal"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 10,
		/datum/thaumaturgical_essence/cycle = 5
	)
	init_types = list(
		/obj/item/fertilizer/bone_meal
	)

/*
--------------------ALCHEMY DUSTS--------------------
*/

/datum/natural_precursor/magicdust
	name = "magic dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 20
	)
	init_types = list(
		/obj/item/alch/magicdust
	)

/datum/natural_precursor/runedust
	name = "rune dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/magic = 5
	)
	init_types = list(
		/obj/item/alch/runedust
	)

/datum/natural_precursor/transisdust
	name = "transis dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 10,
		/datum/thaumaturgical_essence/magic = 5
	)
	init_types = list(
		/obj/item/alch/transisdust
	)

/datum/natural_precursor/waterdust
	name = "water dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/water = 20
	)
	init_types = list(
		/obj/item/alch/waterdust
	)

/datum/natural_precursor/firedust
	name = "fire dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 20
	)
	init_types = list(
		/obj/item/alch/firedust
	)

/datum/natural_precursor/airdust
	name = "air dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 20
	)
	init_types = list(
		/obj/item/alch/airdust
	)

/datum/natural_precursor/earthdust
	name = "earth dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 20
	)
	init_types = list(
		/obj/item/alch/earthdust
	)

/datum/natural_precursor/seeddust
	name = "seed dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/life = 5
	)
	init_types = list(
		/obj/item/alch/seeddust
	)

/datum/natural_precursor/coaldust
	name = "coal dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/earth = 10
	)
	init_types = list(
		/obj/item/alch/coaldust
	)

/datum/natural_precursor/silverdust
	name = "silver dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/void = 10
	)
	init_types = list(
		/obj/item/alch/silverdust
	)

/datum/natural_precursor/golddust
	name = "gold dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/light = 10
	)
	init_types = list(
		/obj/item/alch/golddust
	)

/datum/natural_precursor/irondust
	name = "iron dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/order = 5
	)
	init_types = list(
		/obj/item/alch/irondust
	)

/datum/natural_precursor/feaudust
	name = "feau dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 15,
		/datum/thaumaturgical_essence/energia = 5
	)
	init_types = list(
		/obj/item/alch/feaudust
	)

/datum/natural_precursor/swampdust
	name = "swamp dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/earth = 5,
		/datum/thaumaturgical_essence/life = 5,
		/datum/thaumaturgical_essence/poison = 5
	)
	init_types = list(
		/obj/item/alch/swampdust
	)

/datum/natural_precursor/westleach_dust
	name = "westleach dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/air = 5,
		/datum/thaumaturgical_essence/life = 5,
		/datum/thaumaturgical_essence/poison = 5
	)
	init_types = list(
		/obj/item/alch/tobaccodust
	)

/datum/natural_precursor/ozium
	name = "ozium"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 5,
		/datum/thaumaturgical_essence/chaos = 5,
		/datum/thaumaturgical_essence/void = 10
	)
	init_types = list(
		/obj/item/alch/ozium
	)


/*
--------------------MAGIC AND MANA--------------------
*/

//1 standard crystal can be split into two small ones
/datum/natural_precursor/mana_crystal_small
	name = "small mana crystal"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 3,
		/datum/thaumaturgical_essence/earth = 2
	)
	init_types = list(
		/obj/item/mana_battery/mana_crystal/small
	)

/datum/natural_precursor/manabloom
	name = "manabloom"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 3
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/reagent_containers/powder/manabloom
	)

/datum/natural_precursor/leyline
	name = "leyline crystal"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 10
	)
	init_types = list(
		/obj/item/natural/leyline
	)

/datum/natural_precursor/artifact
	name = "arcyne artifact"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 5,
		/datum/thaumaturgical_essence/void = 3
	)
	init_types = list(
		/obj/item/natural/artifact
	)

/datum/natural_precursor/voidstone
	name = "voidstone"
	essence_yields = list(
		/datum/thaumaturgical_essence/void = 60
	)
	init_types = list(
		/obj/item/natural/voidstone
	)

//infernal summons
/datum/natural_precursor/infernalash
	name = "infernal ash"
	essence_yields = list(
		/datum/thaumaturgical_essence/energia = 10,
		/datum/thaumaturgical_essence/fire = 5,
	)
	init_types = list(
		/obj/item/natural/infernalash
	)

/datum/natural_precursor/hellhoundfang
	name = "hellhound fang"
	essence_yields = list(
		/datum/thaumaturgical_essence/energia = 15,
		/datum/thaumaturgical_essence/fire = 10,
	)
	init_types = list(
		/obj/item/natural/hellhoundfang
	)

/datum/natural_precursor/moltencore
	name = "molten core"
	essence_yields = list(
		/datum/thaumaturgical_essence/energia = 20,
		/datum/thaumaturgical_essence/fire = 15,
	)
	init_types = list(
		/obj/item/natural/moltencore
	)

/datum/natural_precursor/abyssalflame
	name = "abyssal flame"
	essence_yields = list(
		/datum/thaumaturgical_essence/energia = 25,
		/datum/thaumaturgical_essence/fire = 20,
	)
	init_types = list(
		/obj/item/natural/abyssalflame
	)

//fae summons
/datum/natural_precursor/fairydust
	name = "fairy dust"
	essence_yields = list(
		/datum/thaumaturgical_essence/cycle = 10,
		/datum/thaumaturgical_essence/chaos = 5,
	)
	init_types = list(
		/obj/item/natural/fairydust
	)

/datum/natural_precursor/iridescentscale
	name = "iridescent scale"
	essence_yields = list(
		/datum/thaumaturgical_essence/cycle = 15,
		/datum/thaumaturgical_essence/chaos = 10,
	)
	init_types = list(
		/obj/item/natural/iridescentscale
	)

/datum/natural_precursor/heartwoodcore
	name = "heartwood core"
	essence_yields = list(
		/datum/thaumaturgical_essence/cycle = 20,
		/datum/thaumaturgical_essence/chaos = 15,
	)
	init_types = list(
		/obj/item/natural/heartwoodcore
	)

/datum/natural_precursor/sylvanessence
	name = "sylvan essence"
	essence_yields = list(
		/datum/thaumaturgical_essence/cycle = 25,
		/datum/thaumaturgical_essence/chaos = 20,
	)
	init_types = list(
		/obj/item/natural/sylvanessence
	)

//elemental summons
/datum/natural_precursor/elementalmote
	name = "elemental mote"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 10,
		/datum/thaumaturgical_essence/earth = 5,
	)
	init_types = list(
		/obj/item/natural/elementalmote
	)

/datum/natural_precursor/elementalshard
	name = "elemental shard"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 15,
		/datum/thaumaturgical_essence/earth = 10,
	)
	init_types = list(
		/obj/item/natural/elementalshard
	)

/datum/natural_precursor/elementalfragment
	name = "elemental fragment"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 20,
		/datum/thaumaturgical_essence/earth = 15,
	)
	init_types = list(
		/obj/item/natural/elementalfragment
	)

/datum/natural_precursor/elementalrelic
	name = "elemental relic"
	essence_yields = list(
		/datum/thaumaturgical_essence/crystal = 25,
		/datum/thaumaturgical_essence/earth = 20,
	)
	init_types = list(
		/obj/item/natural/elementalrelic
	)

/*
--------------------MISC--------------------
*/

/datum/natural_precursor/rotten_food
	name = "rotten food"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 4,
		/datum/thaumaturgical_essence/poison = 2,
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/rotten,
		/obj/item/reagent_containers/food/snacks/rotten/meat,
		/obj/item/reagent_containers/food/snacks/rotten/bacon,
		/obj/item/reagent_containers/food/snacks/rotten/sausage,
		/obj/item/reagent_containers/food/snacks/rotten/poultry,
		/obj/item/reagent_containers/food/snacks/rotten/chickenleg,
		/obj/item/reagent_containers/food/snacks/rotten/breadslice,
		/obj/item/reagent_containers/food/snacks/rotten/egg,
		/obj/item/reagent_containers/food/snacks/rotten/mince,
		/obj/item/reagent_containers/food/snacks/stale_bread,
	)

/datum/natural_precursor/sugar
	name = "sugar"
	essence_yields = list(
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/energia = 1 //its meant to be a joke/pun about sugar being a great energy source
	)
	init_types = list(
		/obj/item/reagent_containers/food/snacks/sugar,
		/obj/item/reagent_containers/food/snacks/tiefsugar,
	)

/datum/natural_precursor/organs
	name = "organs"
	essence_yields = list(
		/datum/thaumaturgical_essence/chaos = 4,
		/datum/thaumaturgical_essence/void = 1,
		/datum/thaumaturgical_essence/poison = 1,
		/datum/thaumaturgical_essence/life = 1
	)
	init_types = list(
		/obj/item/organ/appendix,
		/obj/item/organ/heart,
		/obj/item/organ/eyes,
		/obj/item/organ/liver,
		/obj/item/organ/lungs,
		/obj/item/organ/stomach,
		/obj/item/organ/tongue,
		/obj/item/organ/brain,
	)

/datum/natural_precursor/horn
	name = "horn"
	essence_yields = list(
		/datum/thaumaturgical_essence/magic = 20,
		/datum/thaumaturgical_essence/order = 5,
		/datum/thaumaturgical_essence/earth = 5
	)
	init_types = list(
		/obj/item/alch/horn
	)

/datum/natural_precursor/thaumic_iron
	name = "thaumic iron"
	essence_yields = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/earth = 5
	)
	init_types = list(
		/obj/item/alch/thaumicdust,
		/obj/item/ingot/thaumic
	)
