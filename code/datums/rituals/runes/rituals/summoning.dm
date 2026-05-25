
/datum/runerituals/summoning
	abstract_type = /datum/runerituals/summoning
	name = "summoning ritual (parent)"
	desc = "Summoning parent — should not appear in player lists."
	blacklisted = TRUE

/datum/runerituals/summoning/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return summon_mob(user, loc, mob_to_summon)

/**
 * Spawns and binds the summoned mob at loc, or returns an existing mob instance.
 * The binding is removed when the summoning rune is destroyed or clicked by an arcyne.
 */
/datum/runerituals/summoning/proc/summon_mob(mob/living/user, turf/loc, mob_to_summon)
	if(isliving(mob_to_summon))
		return mob_to_summon
	var/mob/living/simple_animal/summoned = new mob_to_summon(loc)
	ADD_TRAIT(summoned, TRAIT_PACIFISM, MAGIC_TRAIT)
	summoned.status_flags += GODMODE
	summoned.binded = TRUE
	summoned.SetParalyzed(90 SECONDS)
	summoned.candodge = FALSE
	animate(summoned, color = "#ff0000", time = 5)
	return summoned


/datum/runerituals/summoning/imp
	name = "summoning lesser infernal"
	desc = "Summons an infernal imp."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/fertilizer/ash = 2, /obj/item/natural/obsidian = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/imp

/datum/runerituals/summoning/hellhound
	name = "summoning hellhound"
	desc = "Summons a hellhound."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/natural/infernalash = 3, /obj/item/natural/obsidian = 1, /obj/item/natural/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/hellhound

/datum/runerituals/summoning/watcher
	name = "summoning infernal watcher"
	desc = "Summons an infernal watcher."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/natural/hellhoundfang = 2, /obj/item/natural/obsidian = 1, /obj/item/natural/melded/t2 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/watcher

/datum/runerituals/summoning/archfiend
	name = "summoning fiend"
	desc = "Summons a fiend."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/natural/moltencore = 1, /obj/item/natural/obsidian = 3, /obj/item/natural/melded/t3 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/infernal/fiend


/datum/runerituals/summoning/sprite
	name = "summoning sprite"
	desc = "Summons a fae sprite."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/sprite

/datum/runerituals/summoning/glimmer
	name = "summoning glimmerwing"
	desc = "Summons a fae spirit."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 1,
		/obj/item/natural/fairydust = 3,
		/obj/item/natural/melded/t1 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/glimmerwing

/datum/runerituals/summoning/dryad
	name = "summoning dryad"
	desc = "Summons a dryad."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 2,
		/obj/item/natural/iridescentscale = 2,
		/obj/item/natural/melded/t2 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/dryad

/datum/runerituals/summoning/sylph
	name = "summoning sylph"
	desc = "Summons an archfae."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 1,
		/obj/item/natural/heartwoodcore = 1,
		/obj/item/natural/melded/t3 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/fae/sylph


/datum/runerituals/summoning/crawler
	name = "summoning elemental crawler"
	desc = "Summons a minor elemental."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/natural/stone = 3, /obj/item/mana_battery/mana_crystal/small = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/crawler

/datum/runerituals/summoning/warden
	name = "summoning elemental warden"
	desc = "Summons an elemental."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(
		/obj/item/natural/elementalmote = 3,
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/natural/melded/t1 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/warden

/datum/runerituals/summoning/behemoth
	name = "summoning elemental behemoth"
	desc = "Summons a large elemental."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(
		/obj/item/natural/elementalshard = 2,
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/natural/melded/t2 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/behemoth

/datum/runerituals/summoning/collossus
	name = "summoning elemental colossus"
	desc = "Summons a huge elemental."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(
		/obj/item/natural/elementalfragment = 1,
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/natural/melded/t3 = 1
	)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/elemental/collossus

/datum/runerituals/summoning/abberant
	name = "summoning aberrant from the void"
	desc = "Summons a long-forgotten creature."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/natural/melded/t5 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/voiddragon
