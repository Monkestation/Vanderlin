//! Once we have actual nations this should be snapped away in favor of SSmerchants.nations[nation_type]
//! This is legit just to show what stuff is like
/datum/trade/iron_basics
	name = "Iron Basics"
	desc = "Basic iron equipment trade"
	min_imports = 5
	max_imports = 8
	supply_packs = list(
		/datum/supply_pack/armor/light/skullcap,
		/datum/supply_pack/armor/light/poth,
		/datum/supply_pack/armor/light/imask,
		/datum/supply_pack/armor/light/chaincoif_iron,
		/datum/supply_pack/armor/light/light_armor_boots
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/helmet/ironpot,
		/obj/item/clothing/face/facemask,
		/obj/item/clothing/neck/chaincoif/iron,
		/obj/item/clothing/shoes/boots/armor/light
	)

/datum/trade/leather_start
	name = "Leather Goods"
	desc = "Leather armor and accessories"
	min_imports = 5
	max_imports = 8
	supply_packs = list(
		/datum/supply_pack/armor/light/lightleather_armor,
		/datum/supply_pack/armor/light/leather_bracers,
		/datum/supply_pack/armor/light/heavy_gloves
	)
	acceptable_imports = list(
		/obj/item/clothing/armor/leather,
		/obj/item/clothing/wrists/bracers/leather,
		/obj/item/clothing/gloves/angle
	)

/datum/trade/iron_advanced
	name = "Advanced Iron"
	desc = "Higher quality iron equipment"
	min_imports = 8
	max_imports = 12
	required_trades = list(/datum/trade/iron_basics, /datum/trade/leather_start)
	supply_packs = list(
		/datum/supply_pack/armor/light/splint,
		/datum/supply_pack/armor/light/studleather,
		/datum/supply_pack/armor/light/icuirass,
		/datum/supply_pack/armor/light/ihalf_plate,
		/datum/supply_pack/armor/light/ifull_plate,
		/datum/supply_pack/armor/light/chainmail_iron,
		/datum/supply_pack/armor/light/haukberk
	)
	acceptable_imports = list(
		/obj/item/clothing/armor/leather/splint,
		/obj/item/clothing/armor/leather/advanced,
		/obj/item/clothing/armor/cuirass/iron,
		/obj/item/clothing/armor/plate/iron,
		/obj/item/clothing/armor/plate/full/iron,
		/obj/item/clothing/armor/chainmail/iron,
		/obj/item/clothing/armor/chainmail/hauberk/iron
	)

/datum/trade/steel_start
	name = "Steel Equipment"
	desc = "Basic steel armor and weapons"
	min_imports = 10
	max_imports = 15
	required_trades = list(/datum/trade/iron_advanced)
	supply_packs = list(
		/datum/supply_pack/armor/steel/nasalh,
		/datum/supply_pack/armor/steel/sallet,
		/datum/supply_pack/armor/steel/buckethelm,
		/datum/supply_pack/armor/steel/smask,
		/datum/supply_pack/armor/steel/chaincoif_steel,
		/datum/supply_pack/armor/steel/cuirass,
		/datum/supply_pack/armor/steel/chainmail,
		/datum/supply_pack/armor/steel/chainmail_hauberk,
		/datum/supply_pack/armor/steel/steel_boots
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/nasal,
		/obj/item/clothing/head/helmet/sallet,
		/obj/item/clothing/head/helmet/heavy/bucket,
		/obj/item/clothing/face/facemask/steel,
		/obj/item/clothing/neck/chaincoif,
		/obj/item/clothing/armor/cuirass,
		/obj/item/clothing/armor/chainmail,
		/obj/item/clothing/armor/chainmail/hauberk,
		/obj/item/clothing/shoes/boots/armor
	)

/datum/trade/steel_advanced
	name = "Elite Steel"
	desc = "Premium steel equipment and rare items"
	min_imports = 12
	max_imports = 20
	required_trades = list(/datum/trade/steel_start)
	supply_packs = list(
		/datum/supply_pack/armor/steel/hounskull,
		/datum/supply_pack/armor/steel/visorsallet,
		/datum/supply_pack/armor/steel/elvenhelm,
		/datum/supply_pack/armor/steel/brigandine,
		/datum/supply_pack/armor/steel/coatofplates,
		/datum/supply_pack/armor/steel/half_plate,
		/datum/supply_pack/armor/steel/elvenplate,
		/datum/supply_pack/armor/steel/plate_gloves
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/visored/hounskull,
		/obj/item/clothing/head/helmet/visored/sallet,
		/obj/item/clothing/head/helmet/sallet/elven,
		/obj/item/clothing/armor/brigandine,
		/obj/item/clothing/armor/brigandine/coatplates,
		/obj/item/clothing/armor/plate,
		/obj/item/clothing/armor/cuirass/rare/elven,
		/obj/item/clothing/gloves/plate
	)

/datum/nation/debug_showcase
	nodes = list(
		/datum/trade/iron_basics,
		/datum/trade/leather_start,
		/datum/trade/iron_advanced,
		/datum/trade/steel_start,
		/datum/trade/steel_advanced
	)

// Mob proc to show UI
/mob/proc/show_trade_showcase()
	var/datum/nation/debug_showcase/nation = new()
	show_trade_tree_ui(nation)


/mob/proc/show_trade_tree_ui(datum/nation/debug_showcase/nation)
	var/dat = "<html><head><title>Trade Tree</title></head><body>"
	dat += "<style>"
	dat += "body { background: #1a1a1a; color: #e0e0e0; font-family: monospace; margin: 0; padding: 0; overflow: hidden; }"
	dat += ".viewport { width: 100vw; height: 100vh; overflow: hidden; position: relative; cursor: grab; }"
	dat += ".viewport.dragging { cursor: grabbing; }"
	dat += ".canvas { position: absolute; min-width: 3000px; min-height: 2000px; }"
	dat += ".trade-node { position: absolute; border: 2px solid #4CAF50; background: #2a2a2a; padding: 15px; min-width: 250px; max-width: 300px; border-radius: 8px; box-shadow: 0 0 10px rgba(76,175,80,0.3); cursor: default; }"
	dat += ".trade-node.has-reqs { border-color: #FFC107; }"
	dat += "h3 { color: #4CAF50; margin: 5px 0 10px 0; font-size: 16px; }"
	dat += ".desc { font-size: 11px; color: #bbb; margin-bottom: 10px; }"
	dat += ".info { font-size: 11px; color: #888; margin: 5px 0; }"
	dat += ".requirements { font-size: 11px; color: #FFC107; margin: 10px 0 5px 0; font-weight: bold; }"
	dat += ".req-list { font-size: 10px; color: #f44336; margin-left: 10px; }"
	dat += ".supply-section { margin-top: 10px; border-top: 1px solid #444; padding-top: 8px; }"
	dat += ".supply-label { font-size: 11px; color: #64B5F6; font-weight: bold; margin-bottom: 5px; }"
	dat += ".supply-item { font-size: 10px; color: #999; margin: 2px 0; padding-left: 10px; }"
	dat += "svg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; }"
	dat += ".trade-node { z-index: 1; }"
	dat += "</style>"

	dat += "<h1>Trade Tree Showcase</h1>"
	dat += "<div class='viewport' id='viewport'>"
	dat += "<div class='canvas' id='canvas'>"

	dat += "<svg id='connections'>"

	var/x_start = 500
	var/y_spacing = 350
	var/x_spacing = 400

	var/list/node_positions = list()
	var/tier = 0
	var/tier_count = 0

	for(var/datum/trade/T in nation.nodes)
		var/node_x = x_start
		var/node_y = 100 + (tier * y_spacing)

		//x
		if(T.required_trades && T.required_trades.len)
			if(T.required_trades.len > 1)
				node_x = x_start
			else
				node_x = x_start + x_spacing
			tier++
		else
			node_x = x_start + (tier_count * x_spacing)
			tier_count++
			if(tier == 0)
				tier = 1

		node_positions["[T.type]"] = list("x" = node_x, "y" = node_y, "trade" = T)

	for(var/datum/trade/T in nation.nodes)
		var/list/pos_data = node_positions["[T.type]"]

		if(T.required_trades && T.required_trades.len)
			for(var/req_path in T.required_trades)
				if(node_positions["[req_path]"])
					var/list/req_pos = node_positions["[req_path]"]
					var/from_x = req_pos["x"] + 150
					var/from_y = req_pos["y"] + 150
					var/to_x = pos_data["x"] + 150
					var/to_y = pos_data["y"]

					dat += "<line x1='[from_x]' y1='[from_y]' x2='[to_x]' y2='[to_y]' stroke='#555' stroke-width='2'/>"
					dat += "<polygon points='[to_x],[to_y] [to_x-6],[to_y-10] [to_x+6],[to_y-10]' fill='#555'/>"

	dat += "</svg>"

	//nodes
	for(var/datum/trade/T in nation.nodes)
		var/list/pos_data = node_positions["[T.type]"]
		var/node_x = pos_data["x"]
		var/node_y = pos_data["y"]

		var/has_reqs = (T.required_trades && T.required_trades.len) ? "has-reqs" : ""

		dat += "<div class='trade-node [has_reqs]' style='left: [node_x]px; top: [node_y]px;'>"
		dat += "<h3>[T.name]</h3>"
		dat += "<div class='desc'>[T.desc]</div>"
		dat += "<div class='info'>Imports Required: [T.min_imports]-[T.max_imports]</div>"
		dat += "<div class='info'>Progress: [T.current_imports]/[T.target_imports]</div>"

		if(T.required_trades && T.required_trades.len)
			dat += "<div class='requirements'>Requires:</div>"
			for(var/req_path in T.required_trades)
				for(var/datum/trade/RT in nation.nodes)
					if(RT.type == req_path)
						dat += "<div class='req-list'>- [RT.name]</div>"
						break

		dat += "<div class='supply-section'>"
		dat += "<div class='supply-label'>Unlocks ([T.supply_packs.len] items):</div>"
		var/count = 0
		for(var/pack_path in T.supply_packs)
			if(count >= 5)
				dat += "<div class='supply-item'>... and [T.supply_packs.len - 5] more</div>"
				break
			var/datum/supply_pack/P = new pack_path()
			dat += "<div class='supply-item'>. [P.name] ([P.cost])</div>"
			count++
		dat += "</div>"

		dat += "</div>"

	dat += "</div>"
	dat += "</div>"

	dat += "<script>"
	dat += "var viewport = document.getElementById('viewport');"
	dat += "var canvas = document.getElementById('canvas');"
	dat += "var isDragging = false;"
	dat += "var startX, startY, currentX = 0, currentY = 0;"
	dat += "viewport.addEventListener('mousedown', function(e) {"
	dat += "  if(e.target.classList.contains('trade-node') || e.target.closest('.trade-node')) return;"
	dat += "  isDragging = true;"
	dat += "  viewport.classList.add('dragging');"
	dat += "  startX = e.clientX - currentX;"
	dat += "  startY = e.clientY - currentY;"
	dat += "});"
	dat += "viewport.addEventListener('mousemove', function(e) {"
	dat += "  if(!isDragging) return;"
	dat += "  e.preventDefault();"
	dat += "  currentX = e.clientX - startX;"
	dat += "  currentY = e.clientY - startY;"
	dat += "  canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px)';"
	dat += "});"
	dat += "viewport.addEventListener('mouseup', function() {"
	dat += "  isDragging = false;"
	dat += "  viewport.classList.remove('dragging');"
	dat += "});"
	dat += "viewport.addEventListener('mouseleave', function() {"
	dat += "  isDragging = false;"
	dat += "  viewport.classList.remove('dragging');"
	dat += "});"
	dat += "</script>"

	dat += "</body></html>"

	src << browse(dat, "window=trade_showcase;size=1200x800")
