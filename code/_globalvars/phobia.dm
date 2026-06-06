#define PHOBIA_FILE "phobia.json"

/// Phobia types that can be pulled randomly for brain traumas.
/// Also determines what phobias you can choose as your preference with the quirk.
GLOBAL_LIST_INIT(phobia_types, sortList(list(
	"birds",
	"doctors",
	"falling",
	"jesters",
	"lizards",
	"religion",
	"robots",
	"snakes",
	"spiders",
	"strangers",
	"undead",
)))

GLOBAL_LIST_INIT(phobia_regexes, list(
	"birds" = construct_phobia_regex("birds"),
	"doctors" = construct_phobia_regex("doctors"),
	"falling" = construct_phobia_regex("falling"),
	"jesters" = construct_phobia_regex("jesters"),
	"lizards" = construct_phobia_regex("lizards"),
	"religion" = construct_phobia_regex("religion"),
	"robots" = construct_phobia_regex("robots"),
	"snakes" = construct_phobia_regex("snakes"),
	"spiders" = construct_phobia_regex("spiders"),
	"strangers" = construct_phobia_regex("strangers"),
	"undead" = construct_phobia_regex("undead"),
))

GLOBAL_LIST_INIT(phobia_mobs, list(
	"birds" = typecacheof(list(
		/mob/living/simple_animal/hostile/retaliate/chicken,
	)),
	"lizards" = typecacheof(list(
		/mob/living/simple_animal/hostile/retaliate/voiddragon,
	)),
	"snakes" = typecacheof(list(
		/mob/living/simple_animal/hostile/retaliate/lamia,
	)),
	"spiders" = typecacheof(list(
		/mob/living/simple_animal/hostile/retaliate/spider,
	)),
	"undead" = typecacheof(list(
		/mob/living/simple_animal/hostile/haunt,
		/mob/living/simple_animal/hostile/retaliate/poltergeist,
		/mob/living/simple_animal/hostile/retaliate/shade,
		/mob/living/simple_animal/hostile/skeleton,
	)),
))

GLOBAL_LIST_INIT(phobia_objs, list(
	"birds" = typecacheof(list(
		/obj/item/reagent_containers/food/snacks/crow,
		/obj/item/organ/wings,
		/obj/item/organ/snout/beak,
	)),
	"doctors" = typecacheof(list(
		/obj/item/weapon/surgery,
		/obj/item/clothing/face/feld,
		/obj/item/clothing/face/phys,
		/obj/item/clothing/face/courtphysician,
		/obj/structure/table/optable,
	)),
	"jesters" = typecacheof(list(
		/obj/item/clothing/shoes/jester,
		/obj/item/clothing/shirt/jester,
		/obj/item/clothing/head/jester,
		/obj/item/clothing/pants/tights/colored/jester,
	)),
	"lizards" = typecacheof(list(
		/obj/item/organ/tail/kobold,
	)),
	"spiders" = typecacheof(list(
		/obj/structure/spider,
	)),
	"undead" = typecacheof(list(
		/obj/effect/decal/remains/human,
		/obj/item/alch/bone,
		/obj/item/weapon/axe/boneaxe,
		/obj/item/dice/d6/bone,
		/obj/structure/statue/bone,
		/obj/item/weapon/polearm/spear/bonespear,
		/obj/item/natural/bundle/bone,
	)),
))

GLOBAL_LIST_INIT(phobia_turfs, list(
	"falling" = typecacheof(list(
		/turf/open/openspace,
	)),
))

GLOBAL_LIST_INIT(phobia_species, list(
	"birds" = typecacheof(list(
		/datum/species/harpy,
		/datum/species/medicator,
	)),
	"lizards" = typecacheof(list(
		/datum/species/kobold,
	)),
	"undead" = typecacheof(list(
		/datum/species/zizombie,
	))
))

/// Creates a regular expression to match against the given phobia
/// Capture group 2 = the scary word
/// Capture group 3 = an optional suffix on the scary word
/proc/construct_phobia_regex(list/name)
	var/list/words = strings(PHOBIA_FILE, name)
	if(!length(words))
		CRASH("phobia [name] has no entries")
	var/words_match = ""
	for(var/word in words)
		words_match += "[REGEX_QUOTE(word)]|"
	words_match = copytext(words_match, 1, -1)
	return regex("(\\b|\\A)([words_match])('?s*)(\\b|\\|)", "i")

#undef PHOBIA_FILE
