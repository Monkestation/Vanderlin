GLOBAL_LIST_INIT(runeritualslist, generate_runeritual_types())
GLOBAL_LIST_INIT(allowedrunerituallist, generate_allowed_runeritual_types())
GLOBAL_LIST_INIT(t1summoningrunerituallist, generate_t1summoning_rituallist())
GLOBAL_LIST_INIT(t2summoningrunerituallist, generate_t2summoning_rituallist())
GLOBAL_LIST_INIT(t3summoningrunerituallist, generate_t3summoning_rituallist())
GLOBAL_LIST_INIT(t4summoningrunerituallist, generate_t4summoning_rituallist())
GLOBAL_LIST_INIT(t2wallrunerituallist, generate_t2wall_rituallist())
GLOBAL_LIST_INIT(t4wallrunerituallist, generate_t4wall_rituallist())
GLOBAL_LIST_INIT(buffrunerituallist, generate_buff_rituallist())
GLOBAL_LIST_INIT(t2buffrunerituallist, generate_t2buff_rituallist())
/proc/generate_runeritual_types()	//debug list
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in typesof(/datum/runerituals))
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals
/proc/generate_allowed_runeritual_types()	//list of all non-summoning rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals))
		if(istype(runeritual, /datum/runerituals/summoning || /datum/runerituals/wall))
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t1summoning_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/summoning))
		if(runeritual.tier > 1)
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t2summoning_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/summoning))
		if(runeritual.tier > 2)
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t3summoning_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/summoning))
		if(runeritual.tier > 3)
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t4summoning_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/summoning))
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t2wall_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in typesof(/datum/runerituals/wall))
		if(runeritual.tier > 2)
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t4wall_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/wall))
		if(runeritual.tier < 3)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_buff_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/buff))
		if(runeritual.tier > 1)
			continue
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/proc/generate_t2buff_rituallist()	//list of all rituals for player use
	RETURN_TYPE(/list)
	var/list/runerituals = list()
	for(var/datum/runerituals/runeritual as anything in subtypesof(/datum/runerituals/buff))
		if(runeritual.blacklisted)
			continue
		runerituals[initial(runeritual.name)] = runeritual
	return runerituals

/datum/runerituals
	abstract_type = /datum/runerituals
	var/category = "Rituals"
	var/name
	var/desc
	var/list/required_atoms = list()
	var/list/result_atoms = list()
	var/list/banned_atom_types = list()
	var/mob_to_summon
	var/blacklisted = FALSE
	var/tier = 0				/// Tier var is used for 'tier' of ritual, if the ritual has tiers. EX: Summoning rituals. If it doesn't have tiers, set tier to 0.

/datum/runerituals/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")

/datum/runerituals/proc/generate_html(mob/user)
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
		</style>
		<body>
		  <div>
		    <h1>[name]</h1>
		    <div>
			  <h2>Complexity Tier: [tier] </h2>
			  <br>
			  <h2>Requirements</h2>
			  <br>
		"}

	if(length(required_atoms))
		html += "<strong>Items Required</strong><br>"
		for(var/atom/path as anything in required_atoms)
			var/count = required_atoms[path]
			html += "[icon2html(new path, user)] [count] counts of [initial(path.name)]<br>"

	html += "<h1>Steps</h1>"
	html += "To start any ritual draw the required rune with Arcyne Chalk, then supply with the above items."
	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/runerituals/proc/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!length(result_atoms))
		return FALSE

	for(var/result in result_atoms)
		new result(loc)
	return TRUE

/datum/runerituals/proc/parse_required_item(atom/item_path, number_of_things)
	// If we need a human, there is a high likelihood we actually need a (dead) body
	if(ispath(item_path, /mob/living/carbon/human))
		return "bod[number_of_things > 1 ? "ies" : "y"]"
	if(ispath(item_path, /mob/living))
		return "carcass[number_of_things > 1 ? "es" : ""] of any kind"
	return "[initial(item_path.name)]\s"

/**
 * Called after on_finished_recipe returns TRUE
 * and a ritual was successfully completed.
 *
 * Goes through and cleans up (deletes)
 * all atoms in the selected_atoms list.
 *
 * Remove atoms from the selected_atoms
 * (either in this proc or in on_finished_recipe)
 * to NOT have certain atoms deleted on cleanup.
 *
 * Arguments
 * * selected_atoms - a list of all atoms we intend on destroying.
 */
/datum/runerituals/proc/cleanup_atoms(list/selected_atoms)
	SHOULD_CALL_PARENT(TRUE)

	for(var/atom/sacrificed as anything in selected_atoms)
		if(isliving(sacrificed))
			continue

		selected_atoms -= sacrificed
		qdel(sacrificed)



/datum/runerituals/buff
	blacklisted = TRUE
	tier = 1
	var/buff

/datum/runerituals/knowledge
	name = "knowledge gain"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 1)

/datum/runerituals/knowledge/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE
/datum/runerituals/leyattunement
	name = "leyline attunement"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 1,/obj/item/reagent_containers/food/snacks/produce/manabloom = 2,/obj/item/natural/leyline = 1)

/datum/runerituals/leyattunement/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE


/datum/runerituals/buff/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runerituals/buff/strength
	name = "arcane augmentation of strength"
	buff = /datum/status_effect/buff/magicstrength
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2,/obj/item/natural/elementalshard = 2)

/datum/runerituals/buff/lesserstrength
	name = "lesser arcane augmentation of strength"
	buff = /datum/status_effect/buff/magicstrength/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/elementalmote = 2,/obj/item/mana_battery/mana_crystal/small = 1)

/datum/runerituals/buff/constitution
	name = "fortify constitution"
	buff = /datum/status_effect/buff/magicconstitution
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/obsidian = 4)

/datum/runerituals/buff/lesserconstitution
	name = "lesser fortify constitution"
	buff = /datum/status_effect/buff/magicconstitution/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/obsidian = 2)

/datum/runerituals/buff/speed
	name = "haste"
	buff = /datum/status_effect/buff/magicspeed
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/artifact = 2, /obj/item/natural/leyline = 2)

/datum/runerituals/buff/lesserspeed
	name = "lesser haste"
	buff = /datum/status_effect/buff/magicspeed/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/artifact = 1, /obj/item/natural/leyline = 1)

/datum/runerituals/buff/perception
	name = "arcane eyes"
	buff = /datum/status_effect/buff/magicperception
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 2, /obj/item/natural/hellhoundfang = 1)

/datum/runerituals/buff/lesserperception
	name = "lesser arcane eyes"
	buff = /datum/status_effect/buff/magicperception/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/natural/infernalash = 2)

/datum/runerituals/buff/endurance
	name = "vitalized endurance"
	buff = /datum/status_effect/buff/magicendurance
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/obsidian = 2, /obj/item/natural/iridescentscale = 1)

/datum/runerituals/buff/lesserendurance
	name = "lesser vitalized endurance"
	buff = /datum/status_effect/buff/magicendurance/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/obsidian = 1, /obj/item/natural/fairydust = 2)

/datum/runerituals/buff/nightvision
	name = "darksight"
	buff = /datum/status_effect/buff/darkvision
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/iridescentscale = 1, /obj/item/natural/elementalshard = 1)

/datum/runerituals/wall
	name = "lesser arcyne wall"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/elementalmote = 2, /obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/melded/t1 = 1)

/datum/runerituals/wall/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return 1

/datum/runerituals/wall/t2
	name = "greater arcyne wall"
	tier = 2
	required_atoms = list(/obj/item/natural/elementalmote = 4, /obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/melded/t1 = 1)

/datum/runerituals/wall/t2/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return 2

/datum/runerituals/wall/t3
	name = "arcyne fortress"
	tier = 3
	required_atoms = list(/obj/item/natural/artifact = 3, /obj/item/mana_battery/mana_crystal/small = 3, /obj/item/natural/melded/t3 = 1)


/datum/runerituals/attunement
	name = "arcyne attunement"
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/natural/melded/t1 = 1)

	var/list/attunement_modifiers = list()
	var/list/attuned_items = list()

/datum/runerituals/attunement/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	for(var/obj/item/item in selected_atoms)
		if(!length(item.attunement_values))
			continue
		for(var/attunement in item.attunement_values)
			attunement_modifiers |= attunement
			attunement_modifiers[attunement] += item.attunement_values[attunement]
		attuned_items |= item

/datum/runerituals/teleport
	name = "planar convergence"
	tier = 3
	required_atoms = list(/obj/item/natural/artifact = 1, /obj/item/natural/leyline = 1, /obj/item/natural/melded/t2 = 1)

/datum/runerituals/teleport/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

////////////////SUMMONING RITUALS///////////////////
/datum/runerituals/summoning
	abstract_type = /datum/runerituals/summoning
	name = "summoning ritual parent"
	desc = "summoning parent rituals."
	blacklisted = TRUE



/datum/runerituals/summoning/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return summon_ritual_mob(user, loc, mob_to_summon)

/datum/runerituals/summoning/proc/summon_ritual_mob(mob/living/user, turf/loc, mob/living/mob_to_summon)
	var/mob/living/simple_animal/summoned
	if(isliving(mob_to_summon))
		summoned = mob_to_summon
	else
		summoned = new mob_to_summon(loc)
		ADD_TRAIT(summoned, TRAIT_PACIFISM, TRAIT_GENERIC)	//can't kill while planar bound.
		summoned.status_flags += GODMODE//It's not meant to be killable until released from its planar binding.
		summoned.binded = TRUE	//No auto movement, no moving to targets
		summoned.SetParalyzed(90 SECONDS)
		summoned.candodge = FALSE
		animate(summoned, color = "#ff0000",time = 5)
		return summoned



/datum/runerituals/summoning/imp
	name = "summoning lesser infernal"
	desc = "summons an infernal imp"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/fertilizer/ash = 2, /obj/item/natural/obsidian = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/imp//temporary rat 4 testing

/datum/runerituals/summoning/hellhound
	name = "summoning hellhound"
	desc = "summons a hellhound"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/natural/infernalash = 3, /obj/item/natural/obsidian = 1, /obj/item/natural/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/hellhound//temporary rat 4 testing

/datum/runerituals/summoning/watcher
	name = "summoning infernal watcher"
	desc = "summons an infernal watcher"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/natural/hellhoundfang = 2, /obj/item/natural/obsidian = 1, /obj/item/natural/melded/t2 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/watcher//temporary rat 4 testing

/datum/runerituals/summoning/archfiend
	name = "summoning fiend"
	desc = "summons a fiend"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/natural/moltencore = 1, /obj/item/natural/obsidian = 3, /obj/item/natural/melded/t3 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/fiend//temporary rat 4 testing

/datum/runerituals/summoning/sprite
	name = "summoning sprite"
	desc = "summons a fae sprite"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/sprite

/datum/runerituals/summoning/glimmer
	name = "summoning glimmerwing"
	desc = "summons a fae spirit"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/natural/fairydust = 3, /obj/item/natural/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/glimmerwing

/datum/runerituals/summoning/dryad
	name = "summoning dryad"
	desc = "summons a drayd"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 2, /obj/item/natural/iridescentscale = 2, /obj/item/natural/melded/t2 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/dryad

/datum/runerituals/summoning/sylph
	name = "summoning sylph"
	desc = "summons an archfae"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/natural/heartwoodcore = 1, /obj/item/natural/melded/t3 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/sylph

/datum/runerituals/summoning/crawler
	name = "summoning elemental crawler"
	desc = "summons a minor elemental"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/natural/stone = 3, /obj/item/mana_battery/mana_crystal/small = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/crawler

/datum/runerituals/summoning/warden
	name = "summoning elemental warden"
	desc = "summons an elemental"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/natural/elementalmote = 3, /obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/warden

/datum/runerituals/summoning/behemoth
	name = "summoning elemental behemoth"
	desc = "summons a large elemental"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/natural/elementalshard = 2, /obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/melded/t2 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/behemoth

/datum/runerituals/summoning/collossus
	name = "summoning elemental colossus"
	desc = "summons a huge elemental"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/natural/elementalfragment = 1, /obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/melded/t3 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/collossus

/datum/runerituals/summoning/abberant
	name = "summoning aberrant from the void"
	desc = "summons a long forgotten creature"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/natural/melded/t5 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/voiddragon
