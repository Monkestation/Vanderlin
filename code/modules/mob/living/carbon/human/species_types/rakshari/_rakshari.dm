/mob/living/carbon/human/species/rakshari
	race = /datum/species/rakshari

/datum/attribute_holder/sheet/job/species/rakshari
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_PERCEPTION = 2,
		STAT_CONSTITUTION = -1,
		STAT_SPEED = 2,
	)

/datum/species/rakshari
	name = "Rakshari"
	id = SPEC_ID_RAKSHARI
	changesource_flags = WABBAJACK
	native_language = "Zalad"

	desc = "Rakshari origins trace back to nomadic desert tribes, \
	whose survival in the harsh sands cultivated a culture steeped in resilience, cunning, and adaptability. \
	\n\n\
	Over centuries, the Rakshari united under the banners of powerful Zalad merchant-kings and warlords,\
	transforming their scattered clans into a dominant slaver force across the region. \
	They would often raid weaker settlements and rival caravans, \
	capturing slaves to fuel their expanding cities and economies. \
	Practice of this was justified through religious doctrines, \
	venerating strength and dominance as divine virtues. \
	\n\n\
	As they further attached themselves to Zaladin, however, \
	their people would integrate more sophisticated forms of servitude, \
	such as indentured contracts and debt bondage. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "FFFFFF"

	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_KITTEN_MOM)

	statsheet_male = /datum/attribute_holder/sheet/job/species/rakshari

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/rakshari.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/rakshari.dmi'
	child_icon = 'icons/roguetown/mob/bodies/c/child-rakshari.dmi'

	no_boobs = TRUE

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	exotic_bloodtype = /datum/blood_type/human/rakshari

	offset_features_m = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,-1),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,-1),\
		OFFSET_HEAD = list(0,-1),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,-1),\
		OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,2),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,0),\
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/rakshari,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/rakshari,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/rakshari,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/rakshari,
		/datum/customizer/bodypart_feature/accessory/rakshari,
		/datum/customizer/bodypart_feature/face_detail,
	)
	COOLDOWN_DECLARE(cat_meow_cooldown)

/datum/species/rakshari/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/zalad)
	add_verb(C, /mob/living/carbon/human/species/rakshari/verb/emote_meow)
	add_verb(C, /mob/living/carbon/human/species/rakshari/verb/emote_purr)
	var/datum/action/cooldown/keen_nose/action = new(C)
	action.Grant(C)
	to_chat(C, "<span class='info'>I can speak Zalad with ,z before my speech.</span>")

/datum/species/rakshari/check_roundstart_eligible()
	return TRUE

/datum/species/rakshari/after_creation(mob/living/carbon/C)
	..()
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/zalad)

/datum/species/rakshari/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(prob(1) && !(H.rogue_sneaking))
		if(!COOLDOWN_FINISHED(src, cat_meow_cooldown))
			return
		var/emote = "meow"
		if(prob(15))
			emote = "purr"
		H.emote(emote, forced = TRUE)

		COOLDOWN_START(src, cat_meow_cooldown, 5 MINUTES)

/datum/species/rakshari/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	var/datum/action/cooldown/keen_nose/action = locate() in C.actions
	if(action)
		qdel(action)

/datum/species/rakshari/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/rakshari/get_skin_list()
	return sortList(list(
		"Mountains" = SKIN_COLOR_CONTINENTAL, // - (White 3)
		"City" = SKIN_COLOR_TEMPERATE, // - (White 4)
		"Desert" = SKIN_COLOR_SUBTROPICAL, // - (Mediterranean 1)
		"Deep Desert" = SKIN_COLOR_TROPICALWET, // - (Latin)
		"Oasis" = SKIN_COLOR_HOMUNCULUS, // - (Grey-blue)
		"Oasis Shade" = SKIN_COLOR_NIGHTSHADE, // - (Black-blue)
		"Quicksand" = SKIN_COLOR_QUICKSAND, // Orange, apparently sphynx cats can be orange, who knew!
	))

/datum/species/rakshari/get_hairc_list()
	return sortList(list(
	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",
	"brown - bark" = "2d1300",

	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"orange - rust" = "bc5e35",
	"orange - flame" = "b24c2e",
	))

/datum/action/cooldown/keen_nose
	name = "Sniff for scents"
	desc = "Smell the air to detect living beings at a distance."
	button_icon_state = "shieldsparkles"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/keen_nose/proc/get_smell_message(mob/living/target)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/mob/living/carbon/human/U = owner
		var/datum/species/target_species = H.dna.species
		var/datum/species/user_species = U.dna.species

		if(!target_species)
			return "You smell something"
		if((H.mind && H.mind.has_antag_datum(/datum/antagonist/werewolf)) && U.mind.has_antag_datum(/datum/antagonist/werewolf))
			return "You smell [H.name], a fellow werevolf"
		if((H.mob_biotypes & MOB_UNDEAD) || H.stat == DEAD || H.hygiene == HYGIENE_LEVEL_DISGUSTING)
			return "Euuugh! You smell something rotten"
		if(istype(target_species, /datum/species/rakshari) && istype(user_species, /datum/species/rakshari))
			return "You smell [H.name], the rakshari"
		if(target_species.id in RACES_PLAYER_LUXLESS)
			return "You smell an animal"
		if(target_species.id in RACES_PLAYER_NONDISCRIMINATED)
			return "You smell something humen"
		if((target_species.id in RACES_PLAYER_HERETICAL_RACE) || (istype(target_species, /datum/species/goblin) || istype(target_species, /datum/species/orc)))
			return "Ugh! You smell something tainted"

	if(istype(target, /mob/living/simple_animal))
		return "You smell an animal"

	if(istype(target, /mob/living))
		var/mob/living/L = target
		if((L.mob_biotypes & MOB_UNDEAD) || L.stat == DEAD)
			return "Euuugh! You smell something rotten"

		return "You smell something"

/datum/action/cooldown/keen_nose/Activate(atom/target)
	. = ..(target)
	if(!owner)
		return

	var/list/smelled_targets = list()
	for(var/mob/living/smell_target in range(20, owner))
		smelled_targets += smell_target
	smelled_targets -= owner

	owner.visible_message(span_notice("[owner] sniffs the air!"))
	playsound(owner, 'sound/items/sniff.ogg', 70, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), owner, 'sound/items/sniff.ogg', 70, TRUE), 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(finish_sniff), smelled_targets), 1.5 SECONDS)

/datum/action/cooldown/keen_nose/proc/finish_sniff(list/smelled_targets)
	if(QDELETED(owner) || QDELETED(src))
		return

	playsound(owner, 'sound/items/sniff.ogg', 100, TRUE)
	if(!length(smelled_targets))
		to_chat(owner, span_notice("You smell the air! No creatures are nearby, save yourself."))
		return

	for(var/mob/living/smell_target in smelled_targets)
		var/distance = get_dist(owner, smell_target)
		var/direction = dir2text(get_dir(owner, smell_target))
		var/distance_phrase = " to the [direction]"
		if(distance <= 6)
			distance_phrase = " close to the [direction]"
		else if(distance > 12)
			distance_phrase = " far to the [direction]"

		var/message = get_smell_message(smell_target)
		if(message)
			to_chat(owner, span_notice("[message][distance_phrase]!"))
