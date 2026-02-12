// This code handles different species in the game.
GLOBAL_LIST_EMPTY(roundstart_species)

/datum/species
	/// The name used for examine text and so on
	var/name
	/// Fluff description given when selecting this species
	var/desc
	/// Internal ID of this species used for job checks, etc.
	var/id
	// Since an unique ID is required, but subspecies probably should have the same restrictions
	/// Override for things that use species id to use instead
	var/id_override
	/// Override for limbs to use a different species' limbs
	var/limbs_id
	/// Limb icon to use to build appearance for males
	var/limbs_icon_m
	/// Limb icon to use to build appearance for females
	var/limbs_icon_f
	/// if alien colors are disabled, this is the color that will be used by that race
	var/default_color = "#FFF"
	/// List of ages that can be selected in prefs for this species
	var/list/possible_ages = ALL_AGES_LIST_CHILD
	/// Whether or not this species has sexual characteristics
	var/sexes = TRUE
	/// Whether this species a requires donator subscription to access, we removed all donator restrictions for species, but it's here if we ever want to reenable them or smth.
	var/donator_req = FALSE

	/**
	 * The list of pronouns this species allows in the character sheet.
	 * If none are specified, it will default to the PRONOUNS_LIST.
	 */
	var/list/allowed_pronouns = PRONOUNS_LIST_NO_IT

	/// The list of voice types this species allows in the character sheet for feminine bodies
	var/list/allowed_voicetypes_f = VOICE_TYPES_LIST

	/// The list of voice types this species allows in the character sheet for masculine bodies
	var/list/allowed_voicetypes_m = VOICE_TYPES_LIST

	/// Associative list of FEATURE SLOT to PIXEL ADJUSTMENTS X/Y seperated by gender
	var/list/offset_features_m = list(
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

	var/list/offset_features_f = list(
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

	/// Type of damage overlay to use
	var/damage_overlay_type = "human"
	/// Damage overlays to use for males
	var/dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	/// Damge overlays to use for females
	var/dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	/// String value ranging from t1 to t3 which controls body hair overlays for this species
	var/hairyness = null
	/// Append species id to clothing sprite name
	var/custom_clothes = FALSE
	/// Custom id for custom_clothes
	var/custom_id
	/**
	 * Males use female clothes, offsets and damage icons.
	 * Importantly males still use male limb icons.
	 * This does not effect stats or inherent traits/skills.
	 * Males will not get boob overlays from this.
	 */
	var/swap_male_clothes = FALSE
	/**
	 * Females use male clothes, offsets and damage icons.
	 * Importantly females still use female limb icons.
	 * This does not effect stats or inherent traits/skills.
	 * Females will lose their boob overlays.
	 */
	var/swap_female_clothes = FALSE

	var/no_boobs = FALSE
	/**
	 * For species that don't have mammaries, like Rakshari.
	 * Removes boob overlay
	 */

	/// Sounds for males
	var/datum/voicepack/soundpack_m = /datum/voicepack/male
	/// Sounds for females
	var/datum/voicepack/soundpack_f = /datum/voicepack/female

	/// Do we use a blood type seperate from default? (Yes, yes we do)
	var/datum/blood_type/exotic_bloodtype

	/// What meat do we get from butchering this species?
	var/meat = /obj/item/reagent_containers/food/snacks/meat/steak
	/// Food we (SHOULD) get a mood buff from
	var/liked_food = NONE
	/// Food we (SHOULD) get a mood debuff from
	var/disliked_food = NONE
	/// Food that (SHOULD) be toxic to us
	var/toxic_food = NONE

	/// List of slots this species cannot equip things to
	var/list/no_equip = list()
	/// TODO CHANGE THIS TO SOMETHING THAT ISN'T POCKETS
	var/nojumpsuit = FALSE
	/// Prefix for spoken messages
	var/say_mod = "says"

	/// Multipler for how quickly nutrition decreases
	var/nutrition_mod = 1
	/// Multiplier for how quickly hygiene decreases
	var/hygiene_mod = 1
	/// Multipler for blood loss
	var/bleed_mod = 1
	/// Multipler for pain
	var/pain_mod = 1
	/// Electrocution coeffcient
	var/siemens_coeff = 1


	/// Type of damage melee attacks do
	var/attack_type = BRUTE
	/// Special sound for grabbing for this species
	var/sound/grab_sound
	/// Special death sound for this species
	var/sound/deathsound

	/// A path to an outfit that is important for species life e.g. plasmaman outfit
	var/datum/outfit/outfit_important_for_life

	/// Generic traits tied to having the species
	var/list/inherent_traits = list()
	/// Generic traits tied to having the species and being male
	var/list/inherent_traits_m
	/// Generic traits tied to having the species and being female
	var/list/inherent_traits_f
	/// Associative list of skills to adjustments
	var/list/inherent_skills = list()
	/// Species-only traits used for drawing, can be found in DNA.dm
	var/list/species_traits = list()
	/// Components to add when spawning
	var/list/components_to_add = list()
	/// List of factions the mob gain upon gaining this species.
	var/list/inherent_factions
	/// Bitfield for biotypes used by this species
	var/inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID

	/// Icon to use when ingulfed in flames
	var/enflamed_icon = "Standing"

	/// Items that are used as hands
	var/obj/item/mutanthands

	/// Does this species ignore gravity
	var/override_float = FALSE

	/// Bitflag that controls what in game ways can select this species as a spawnable source
	/// Think magic mirror and pride mirror, slime extract, ERT etc, see defines
	/// in __DEFINES/mobs.dm, defaults to NONE, so people actually have to think about it
	var/changesource_flags = NONE

	/// Do we use custom skintones?
	var/use_skintones = FALSE

	/// Wording for skin tone on examine and on character setup
	var/skin_tone_wording = "Ancestry"

	/// List of bodypart features of this species
	var/list/bodypart_features

	/// List of customizer entries that appear in the features tab
	var/list/customizer_entries = list()

	/// Default mutant bodyparts for this species. Don't forget to set one for every mutant bodypart you allow this species to have.
	var/list/default_features = MANDATORY_FEATURE_LIST

	/// List of organs this species has.
	var/list/organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	/// List of descriptor choices this species gets in preferences customization
	var/list/descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one,
		/datum/descriptor_choice/prominent_two,
		/datum/descriptor_choice/prominent_three,
		/datum/descriptor_choice/prominent_four,
	)

	/// List of organ customizers for preferences to customize organs.
	var/list/customizers
	/// List of possible body marking sets that the player can choose from in customization
	var/list/body_marking_sets = list(
		/datum/body_marking_set/none,
	)
	/// List all of body markings that the player can choose from in customization. Body markings from sets get added to here
	var/list/body_markings

	///Statkey = bonus stat, - for malice.
	var/list/specstats_m = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_END = 0,STATKEY_CON = 0, STATKEY_INT = 0, STATKEY_SPD = 0, STATKEY_LCK = 0)

	///Statkey = bonus stat, - for malice.
	var/list/specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_END = 0,STATKEY_CON = 0, STATKEY_INT = 0, STATKEY_SPD = 0, STATKEY_LCK = 0)

	/// Can we be a youngling?
	var/can_be_youngling = TRUE
	/// Icon override for children male and female is the same
	var/child_icon = 'icons/roguetown/mob/bodies/c/child.dmi'
	/// Child damage icons
	var/child_dam_icon = 'icons/roguetown/mob/bodies/dam/dam_child.dmi'

	/// Child feature offset lists
	var/list/offset_features_child = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,-3),\
		OFFSET_CLOAK = list(0,-4),\
		OFFSET_FACEMASK = list(0,-4),\
		OFFSET_HEAD = list(0,-4),\
		OFFSET_FACE = list(0,-4),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,-4),\
		OFFSET_MOUTH = list(0,-4),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	/// Amount of times we got autocorrected?? why is this a thing?
	var/amtfail = 0

	var/punch_damage = 0

	/// Native language for accents
	var/native_language = "Imperial"
	/// Accent based of the language
	var/accent_language
	/// For races that can have more than one Accent such as the Half-Drow and Half-Elf
	var/multiple_accents

///////////
// PROCS //
///////////

/datum/species/proc/get_accent(language, variant = 0)
	if(language == "Old Psydonic")
		return strings("accents/grenz_replacement.json", "grenz")
	if(language == "Zalad")
		return strings("accents/zalad_replacement.json", "arabic")
	if(language == "Imperial")
		return
	if(language == "Elfish" && variant == 1)
		return strings("accents/russian_replacement.json", "russian")
	if(language == "Elfish" && variant == 2)
		return strings("accents/french_replacement.json", "french")
	if(language == "Dwarfish")
		return strings("accents/dwarf_replacement.json", "dwarf")
	if(language == "Infernal")
		return strings("accents/spanish_replacement.json", "spanish")
	if(language == "Celestial")
		return
	if(language == "Orcish")
		return strings("accents/halforc_replacement.json", "halforc")
	if(language == "Halfling")
		return strings("accents/halfling_replacement.json", "halfling")
	if(language == "Gutter")
		return strings("accents/kobold_replacement.json", "kobold")
	if(language == "Deepspeak")
		return strings("accents/triton_replacement.json", "triton")
	if(language == "Pirate")
		return strings("accents/pirate_replacement.json", "pirate")
	if(language == "Zizo Chant")
		return
	return

/datum/species/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	var/language = speech_args[SPEECH_LANGUAGE]

	if(message)
		var/list/accent_words = strings("accents/spellcheck.json", "spellcheck")
		var/mob/living/carbon/human/H
		if(ismob(source))
			H = source

		for(var/key in accent_words)
			var/value = accent_words[key]
			if(islist(value))
				value = pick(value)

			if(findtextEx(message,key))
				if(H)
					to_chat(H, "<span class='warning'>[key] -> [value]</span>")
				amtfail++

			message = replacetextEx(message, "[key]", "[value]")

	if(message && message[1] && message[1] != "*")
		message = " [message]"

		var/list/accent_words = strings("accents/accent_universal.json", "universal")
		for(var/key in accent_words)
			var/value = accent_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")


		var/mob/living/carbon/human/human
		var/list/species_accent
		var/special_accent = FALSE

		if(ismob(source))
			human = source
			var/nativelang = human.dna.species.native_language
			species_accent = human.dna.species.accent_language

			var/language_check


			var/list/accents_list = list(
				ACCENT_NONE,
				ACCENT_DWARF,
				ACCENT_DELF,
				ACCENT_ELF,
				ACCENT_TIEFLING,
				ACCENT_HORC,
				ACCENT_TRITON,
				ACCENT_GRENZ,
				ACCENT_PIRATE,
				ACCENT_MIDDLE_SPEAK,
				ACCENT_ZALAD,
				ACCENT_HALFLING,
				ACCENT_KOBOLD
			)

			///This will only trigger for donators
			if(human.accent in accents_list)
				/// If the human is using a specie with multiple accents
				if(length(human.dna.species.multiple_accents))
					var/normalized_accent = (human.accent in GLOB.accent_list) ? GLOB.accent_list[human.accent] : human.accent
					/// If the accent they picked is different to their species accent, in this case a Half Elf with an Elf Accent would not get special_accent set to TRUE.
					if(!(normalized_accent == species_accent))
						species_accent = human.return_accent_list()
						special_accent = TRUE
				else
					species_accent = human.return_accent_list()
					special_accent = TRUE

			var/list/language_map = list(
				/datum/language/common = "Imperial",
				/datum/language/elvish = "Elfish",
				/datum/language/dwarvish = "Dwarfish",
				/datum/language/hellspeak = "Infernal",
				/datum/language/orcish = "Orcish",
				/datum/language/celestial = "Celestial",
				/datum/language/zalad = "Zalad",
				/datum/language/deepspeak = "Deepspeak",
				/datum/language/oldpsydonic = "Old Psydonic",
				/datum/language/undead = "Zizo Chant"
			)

			if (language in language_map)
				language_check = language_map[language]
			if(nativelang != language_check || special_accent)
				if(species_accent)
					for(var/key in species_accent)
						var/value = species_accent[key]
						if(islist(value))
							value = pick(value)

						message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
						message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
						message = replacetextEx(message, " [key]", " [value]")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/species/proc/is_bodypart_feature_slot_allowed(mob/living/carbon/human/human, feature_slot)
	switch(feature_slot)
		if(BODYPART_FEATURE_FACIAL_HAIR)
			return (human.gender == MALE)
	return TRUE


/datum/species/New()

	if(!limbs_id)	//if we havent set a limbs id to use, just use our own id
		limbs_id = name
	..()

/datum/species/proc/after_creation(mob/living/carbon/human/H)
	if(H.mind)
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
	return TRUE

/datum/species/proc/check_roundstart_eligible()
	return FALSE

// Remove when preference datums
/datum/species/proc/preference_accessible(datum/preferences/prefs)
	return TRUE

/datum/species/proc/get_possible_names(gender = MALE) as /list
	SHOULD_CALL_PARENT(FALSE)
	var/static/list/male_names = world.file2list('strings/names/first_male.txt')
	var/static/list/female_names = world.file2list('strings/names/first_female.txt')

	return (gender == FEMALE) ? female_names : male_names

/datum/species/proc/random_name(gender = MALE, unique = FALSE)
	var/list/possible_names = get_possible_names(gender)
	if(!unique)
		return pick(possible_names)

	for(var/i in 1 to 10)
		. = pick(possible_names)
		if(!findname(.))
			break

/datum/species/proc/get_possible_surnames(gender = MALE) as /list
	var/static/list/last_names = world.file2list('strings/names/last.txt')

	return last_names

/datum/species/proc/random_surname(gender = MALE)
	var/list/possible_surnames = get_possible_surnames(gender)
	return " [pick(possible_surnames)]"

/datum/species/proc/get_spec_undies_list(gender)
	if(!GLOB.underwear_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)

	var/list/used_list = GLOB.underwear_list
	if(gender == MALE)
		used_list = GLOB.underwear_m
	else if(gender == FEMALE)
		used_list = GLOB.underwear_f

	var/used_species_id = id_override ? id_override : id

	var/list/spec_undies = list()
	for(var/name in used_list)
		var/datum/sprite_accessory/accessory = used_list[name]
		if(!accessory.roundstart)
			continue
		if(!(used_species_id in accessory.specuse))
			continue
		spec_undies += accessory

	return spec_undies

/datum/species/proc/random_underwear(gender)
	var/list/spec_undies = get_spec_undies_list(gender)
	if(LAZYLEN(spec_undies))
		var/datum/sprite_accessory/underwear = pick(spec_undies)
		return underwear.name

/datum/species/proc/regenerate_icons(mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/update_damage_overlays(mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/get_hexcolor(list/L)
	return L

/datum/species/proc/get_skin_list() as /list
	RETURN_TYPE(/list)
	return GLOB.skin_tones

/datum/species/proc/get_hairc_list()
	return GLOB.haircolor

/datum/species/proc/get_oldhc_list()
	return GLOB.oldhc

/datum/species/proc/oldhc2color(oldhc)
	var/list/L = get_oldhc_list()
	return L[oldhc]


//Called when cloning, copies some vars that should be kept
/datum/species/proc/copy_properties_from(datum/species/old_species)
	return

//Please override this locally if you want to define when what species qualifies for what rank if human authority is enforced.
/datum/species/proc/qualifies_for_rank(rank, list/features)
	return 1

/**
 * Corrects organs in a carbon, removing ones it doesn't need and adding ones it does.
 *
 * Takes all organ slots, removes organs a species should not have, adds organs a species should have.
 * can use replace_current to refresh all organs, creating an entirely new set.
 *
 * Arguments:
 * * organ_holder - carbon, the owner of the species datum AKA whoever we're regenerating organs in
 * * old_species - datum, used when regenerate organs is called in a switching species to remove old mutant organs.
 * * replace_current - boolean, forces all old organs to get deleted whether or not they pass the species' ability to keep that organ
 * * excluded_zones - list, add zone defines to block organs inside of the zones from getting handled. see headless mutation for an example
 * * visual_only - boolean, only load organs that change how the species looks. Do not use for normal gameplay stuff
 * * replace_missing - Whether or not to replace missing organs
 * * pref_lod - pref organ dna (why the fuck do we need this)
 */
/datum/species/proc/regenerate_organs(
	mob/living/carbon/organ_holder,
	datum/species/old_species,
	replace_current = TRUE,
	list/excluded_zones,
	visual_only = FALSE,
	replace_missing = TRUE,
	datum/preferences/pref_load
)
	/// Add DNA and create organs from prefs
	if(pref_load)
		/// Clear the dna
		organ_holder.dna.organ_dna = list()
		var/list/organ_dna_list = pref_load.get_organ_dna_list()
		for(var/organ_slot in organ_dna_list)
			organ_holder.dna.organ_dna[organ_slot] = organ_dna_list[organ_slot]

	for(var/slot in GLOB.all_organ_slots)
		var/obj/item/organ/existing_organ = organ_holder.getorganslot(slot)
		var/obj/item/organ/new_organ = organs[slot]
		var/old_organ_type = old_species?.organs[slot]

		// if we have an extra organ that before changing that the species didnt have, remove it
		if(!new_organ)
			if(existing_organ && (old_organ_type == existing_organ.type || replace_current))
				existing_organ.Remove(organ_holder)
				qdel(existing_organ)
			continue

		if(existing_organ)
			// we dont want to remove organs that were not from the old species (such as from freak surgery or prosthetics)
			if(existing_organ.type != old_organ_type && !replace_current)
				continue

			if(existing_organ.type == new_organ)
				var/datum/organ_dna/organ_dna = organ_holder.dna.organ_dna[slot]
				organ_dna?.imprint_organ(existing_organ)
				pref_load?.customize_organ(existing_organ)
				continue // we don't want to remove organs that are the same as the new one

		if(visual_only && (!initial(new_organ.accessory_type) && !initial(new_organ.visible_organ)))
			continue

		var/used_neworgan = FALSE

		var/used_dna = FALSE
		var/datum/organ_dna/organ_dna = organ_holder.dna.organ_dna[slot]
		if(organ_dna?.can_create_organ())
			new_organ = organ_dna.create_organ(species = src)
			pref_load?.customize_organ(new_organ)
			used_dna = TRUE

		if(!used_dna)
			new_organ = new new_organ()
			new_organ.build_colors_for_accessory(color_key_source_list_from_carbon(organ_holder))

		var/should_have = new_organ.get_availability(src, organ_holder)

		// Check for an existing organ, and if there is one check to see if we should remove it
		var/health_pct = 1
		var/remove_existing = !isnull(existing_organ) && !(existing_organ.zone in excluded_zones)
		if(remove_existing)
			health_pct = (existing_organ.maxHealth - existing_organ.damage) / existing_organ.maxHealth
			if(slot == ORGAN_SLOT_BRAIN)
				var/obj/item/organ/brain/existing_brain = existing_organ
				existing_brain.before_organ_replacement(new_organ)
				existing_brain.Remove(organ_holder, special = TRUE, no_id_transfer = TRUE)
			else
				existing_organ.before_organ_replacement(new_organ)
				existing_organ.Remove(organ_holder, special = TRUE)

			QDEL_NULL(existing_organ)

		if(isnull(existing_organ) && should_have && !(new_organ.zone in excluded_zones) && organ_holder.get_bodypart(deprecise_zone(new_organ.zone)) && (replace_missing || remove_existing))
			used_neworgan = TRUE
			new_organ.setOrganDamage(new_organ.maxHealth * (1 - health_pct))
			new_organ.Insert(organ_holder, special = TRUE)

		if(!used_neworgan)
			QDEL_NULL(new_organ)
		else if(!organ_holder.dna.organ_dna[slot])
			var/datum/organ_dna/new_dna = new_organ.create_organ_dna()
			organ_holder.dna.organ_dna[slot] = new_dna

/datum/species/proc/is_organ_slot_allowed(mob/living/carbon/human/human, organ_slot)
	return TRUE

/datum/species/proc/random_character(mob/living/carbon/human/H)
	H.real_name = random_name(H.gender,1)
//	H.age = pick(possible_ages)
	H.underwear = random_underwear(H.gender)
	var/list/skins = get_skin_list()
	H.skin_tone = skins[pick(skins)]
	H.accessory = "Nothing"
	if(H.dna)
		H.dna.real_name = H.real_name
		var/list/features = random_features()
		H.dna.features = features.Copy()
	validate_customizer_entries(H)
	reset_all_customizer_accessory_colors(H)
	randomize_all_customizer_accessories(H)
	apply_customizers_to_character(H)
	if(!H.client && H.dna)
		var/list/organ_list = list()
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
			if(!customizer.is_allowed(H))
				continue
			if(entry.disabled)
				continue
			var/datum/organ_dna/dna = customizer_choice.create_organ_dna(entry, H)
			if(!dna)
				continue
			organ_list[customizer_choice.get_organ_slot()] = dna

		H.dna.organ_dna = list()
		var/list/organ_dna_list = organ_list
		for(var/organ_slot in organ_dna_list)
			H.dna.organ_dna[organ_slot] = organ_dna_list[organ_slot]
		regenerate_organs(H)

	H.update_body()
	H.update_body_parts()


/datum/species/proc/apply_customizers_to_character(mob/living/carbon/human/human)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(human))
			continue
		if(entry.disabled)
			continue
		customizer_choice.apply_customizer_to_character(human, human, entry)

/datum/species/proc/reset_all_customizer_accessory_colors(mob/living/carbon/human/human)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.reset_accessory_colors(human, entry)

/datum/species/proc/randomize_all_customizer_accessories(mob/living/carbon/human/human)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.randomize_entry(entry, human)

/datum/species/proc/validate_customizer_entries(mob/living/carbon/human/human)
	customizer_entries = SANITIZE_LIST(customizer_entries)
	listclearnulls(customizer_entries)
	/// Check if we have any customizer entries that don't match.
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/validated = FALSE
		for(var/customizer_type as anything in customizers)
			if(customizer_type != entry.customizer_type)
				continue
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!(entry.customizer_choice_type in customizer.customizer_choices))
				continue
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			if(entry.type != customizer_choice.customizer_entry_type)
				continue
			validated = TRUE
			break

		if(!validated)
			customizer_entries -= entry

	/// Check if we have any missing customizer entries
	for(var/customizer_type as anything in customizers)
		var/found = FALSE
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			found = TRUE
			break
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!found)
			customizer_entries += customizer.make_default_customizer_entry(human, FALSE)

	/// Validate the variables within customizer entries
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		customizer_choice.validate_entry(human, entry)

/datum/species/proc/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	// Drop the items the new species can't wear
	if((AGENDER in species_traits))
		C.gender = PLURAL
	for(var/slot_id in no_equip)
		var/obj/item/thing = C.get_item_by_slot(slot_id)
		if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
			C.dropItemToGround(thing)
	if(C.hud_used)
		C.hud_used.update_locked_slots()

	if(ishuman(C) && !pref_load)
		random_character(C)
	else
		regenerate_organs(C, old_species, pref_load = pref_load)

	C.mob_biotypes = inherent_biotypes

	if(exotic_bloodtype && C.dna.human_blood_type != exotic_bloodtype)
		C.dna.human_blood_type = exotic_bloodtype

	if(old_species.mutanthands)
		for(var/obj/item/I in C.held_items)
			if(istype(I, old_species.mutanthands))
				qdel(I)

	if(mutanthands)
		// Drop items in hands
		// If you're lucky enough to have a TRAIT_NODROP item, then it stays.
		for(var/obj/item/I as anything in C.held_items)
			if(istype(I))
				C.dropItemToGround(I)
			else	//Entries in the list should only ever be items or null, so if it's not an item, we can assume it's an empty hand
				C.put_in_hands(new mutanthands())

	for(var/trait as anything in inherent_traits)
		ADD_TRAIT(C, trait, SPECIES_TRAIT)

	if(LAZYLEN(inherent_traits_f) && C.gender == FEMALE)
		for(var/trait as anything in inherent_traits_f)
			ADD_TRAIT(C, trait, SPECIES_TRAIT)

	if(LAZYLEN(inherent_traits_m) && C.gender == MALE)
		for(var/trait as anything in inherent_traits_m)
			ADD_TRAIT(C, trait, SPECIES_TRAIT)

	for(var/skill as anything in inherent_skills)
		C.adjust_skillrank(skill, inherent_skills[skill], TRUE)

	for(var/component in components_to_add)
		C.AddComponent(component)

	if(TRAIT_TOXIMMUNE in inherent_traits)
		C.setToxLoss(0, TRUE, TRUE)

	if(TRAIT_NOMETABOLISM in inherent_traits)
		C.reagents.end_metabolization(src, keep_liverless = TRUE)

	if(inherent_factions)
		for(var/i in inherent_factions)
			C.faction += i //Using +=/-= for this in case you also gain the faction from a different source.

	soundpack_m = new soundpack_m()
	soundpack_f = new soundpack_f()

	C.remove_all_bodypart_features()
	for(var/bodypart_feature_type in bodypart_features)
		var/datum/bodypart_feature/feature = new bodypart_feature_type()
		if(!is_bodypart_feature_slot_allowed(C, feature.feature_slot))
			continue
		C.add_bodypart_feature(feature)

	if(pref_load)
		pref_load.apply_customizers_to_character(C)
		pref_load.apply_descriptors(C)
	else
		apply_customizers_to_character(C)

	SEND_SIGNAL(C, COMSIG_SPECIES_GAIN, src, old_species)


/datum/species/proc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	if(C.dna.species.exotic_bloodtype)
		C.dna.human_blood_type = random_human_blood_type()
	for(var/X in inherent_traits)
		REMOVE_TRAIT(C, X, SPECIES_TRAIT)

	for(var/skill as anything in inherent_skills)
		C.adjust_skillrank(skill, -inherent_skills[skill], TRUE)

	if(inherent_factions)
		for(var/i in inherent_factions)
			C.faction -= i

	SEND_SIGNAL(C, COMSIG_SPECIES_LOSS, src)

/datum/species/proc/handle_body(mob/living/carbon/human/H)
	H.remove_overlay(BODY_LAYER)
	H.remove_overlay(ABOVE_BODY_FRONT_LAYER)

	var/datum/species/species = H.dna?.species
	var/use_female_sprites = FALSE
	var/list/offsets
	if(species)
		if(species.sexes)
			if(H.gender == FEMALE && !species.swap_female_clothes || H.gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_BOOB
		if(use_female_sprites)
			offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	var/list/standing = list()

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)

	if(HD && !(HAS_TRAIT(H, TRAIT_HUSK)) && !HD.skeletonized)
		// lipstick
		if(H.lip_style && (LIPS in species_traits))
			var/mutable_appearance/lip_overlay = mutable_appearance('icons/mob/human_face.dmi', "lips_[H.lip_style]", -BODY_LAYER)
			lip_overlay.color = H.lip_color
			if(LAZYACCESS(offsets, OFFSET_FACE))
				lip_overlay.pixel_x += offsets[OFFSET_FACE][1]
				lip_overlay.pixel_y += offsets[OFFSET_FACE][2]
			standing += lip_overlay

		if(species?.hairyness)
			var/limb_icon
			// Not use_female_sprites for limb icons
			if(H.gender == MALE)
				limb_icon = species.limbs_icon_m
			else
				limb_icon = species.limbs_icon_f
			var/mutable_appearance/bodyhair_overlay = mutable_appearance(limb_icon, "[species?.hairyness]", -FRONT_MUTATIONS_LAYER)
			bodyhair_overlay.color = H.get_hair_color()
			standing += bodyhair_overlay

	//Underwear
	if(!(NO_UNDERWEAR in species_traits))
		var/hide_top = FALSE
		var/hide_bottom = FALSE
		var/obj/item/clothing/w_armor = H.wear_armor
		if(w_armor)
			hide_top = w_armor.flags_inv & (HIDEBOOB | HIDEUNDIESTOP)
			hide_bottom = w_armor.flags_inv & (HIDEUNDIESBOT)

		var/obj/item/clothing/w_shirt = H.wear_shirt
		if(w_shirt)
			hide_top = w_shirt.flags_inv & (HIDEBOOB |HIDEUNDIESTOP)
			hide_bottom = w_shirt.flags_inv & ( HIDEUNDIESBOT)

		var/obj/item/clothing/w_cloak = H.wear_shirt
		if(w_cloak)
			hide_top = w_cloak.flags_inv & (HIDEBOOB | HIDEUNDIESTOP)
			hide_bottom = w_cloak.flags_inv & (HIDEUNDIESBOT)

		if(H.wear_pants)
			hide_bottom = H.wear_pants.flags_inv & HIDEUNDIESBOT

		if(H.underwear)
			if(H.age == AGE_CHILD)
				hide_top = FALSE
				hide_bottom = FALSE

				if(H.gender == FEMALE)
					H.underwear = "FemYoungling"
				else
					H.underwear = "Youngling"

			var/datum/sprite_accessory/underwear/underwear = GLOB.underwear_list[H.underwear]

			if(underwear)
				var/mutable_appearance/underwear_overlay
				var/mutable_appearance/underwear_emissive
				if(!hide_bottom)
					underwear_overlay = mutable_appearance(underwear.icon, underwear.icon_state, -BODY_LAYER)
					if(LAZYACCESS(offsets, OFFSET_UNDIES))
						underwear_overlay.pixel_x += offsets[OFFSET_UNDIES][1]
						underwear_overlay.pixel_y += offsets[OFFSET_UNDIES][2]
					if(!underwear.use_static)
						if(H.underwear_color)
							underwear_overlay.color = H.underwear_color
						else //default undies are brown
							H.underwear_color = "#755f46"
							underwear_overlay.color = "#755f46"
					standing += underwear_overlay
					if(!istype(H, /mob/living/carbon/human/dummy))
						underwear_emissive = emissive_blocker(underwear.icon, underwear.icon_state, -BODY_LAYER)
						underwear_emissive.pixel_y = underwear_overlay.pixel_y
						underwear_emissive.pixel_x = underwear_overlay.pixel_x
						standing += underwear_emissive

				if(!hide_top && H.gender == FEMALE)
					underwear_overlay = mutable_appearance(underwear.icon, "[underwear.icon_state]_boob", -BODY_LAYER)
					if(LAZYACCESS(offsets, OFFSET_UNDIES))
						underwear_overlay.pixel_x += offsets[OFFSET_UNDIES][1]
						underwear_overlay.pixel_y += offsets[OFFSET_UNDIES][2]
					if(!underwear.use_static)
						if(H.underwear_color)
							underwear_overlay.color = H.underwear_color
						else
							H.underwear_color = "#755f46"
							underwear_overlay.color = "#755f46"
					standing += underwear_overlay
					if(!istype(H, /mob/living/carbon/human/dummy))
						underwear_emissive = emissive_blocker(underwear.icon, "[underwear.icon_state]_boob", -BODY_LAYER)
						underwear_emissive.pixel_y = underwear_overlay.pixel_y
						underwear_emissive.pixel_x = underwear_overlay.pixel_x
						standing += underwear_emissive

	if(length(standing))
		H.overlays_standing[BODY_LAYER] = standing

	H.apply_overlay(BODY_LAYER)
	H.apply_overlay(ABOVE_BODY_FRONT_LAYER)

/datum/species/proc/spec_life(mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)
	if(H.stat == DEAD)
		return

	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		H.setOxyLoss(0)
		H.losebreath = 0
	else if((H.health < H.crit_threshold) && !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		H.adjustOxyLoss(1)

/datum/species/proc/spec_death(gibbed, mob/living/carbon/human/H)
	return

/datum/species/proc/auto_equip(mob/living/carbon/human/H)
	// handles the equipping of species-specific gear
	return

/datum/species/proc/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if(slot in no_equip)
		if(!I.species_exception || !is_type_in_list(src, I.species_exception))
			return FALSE

	switch(slot)
		if(ITEM_SLOT_HANDS)
			if(H.get_empty_held_indexes())
				return TRUE
			return FALSE
		if(ITEM_SLOT_MASK)
			if(H.wear_mask)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_MASK))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_MOUTH)
			if(H.mouth)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_MOUTH))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_NECK)
			if(H.wear_neck)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_NECK) )
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACK_R)
			if(H.backr)
				return FALSE
			if( (I.slot_flags & ITEM_SLOT_CLOAK) )
				if(H.cloak)
					if((H.cloak.slot_flags & ITEM_SLOT_BACK_R) )
						return FALSE
			if( !(I.slot_flags & ITEM_SLOT_BACK_R) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_BACK_L)
			if(H.backl)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_BACK_L) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_ARMOR)
			if(H.wear_armor)
				return FALSE
			if(I.blocking_behavior & BULKYBLOCKS)
				if(H.cloak)
					return FALSE
				if(istype(H.cloak, I.type))
					return FALSE
			if(H.wear_shirt)
				if(H.wear_shirt.blocking_behavior & BULKYBLOCKS)
					return FALSE
				if(istype(H.wear_shirt, I.type))
					return FALSE
				if(I.blocksound)
					if(I.blocksound == H.wear_shirt.blocksound)
						return FALSE
			if( !(I.slot_flags & ITEM_SLOT_ARMOR) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_GLOVES)
			if(H.gloves)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_GLOVES) )
				return FALSE
			if(H.num_hands < 1)
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_SHOES)
			if(H.shoes)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_SHOES) )
				return FALSE
			if(H.num_legs < 1)
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_BELT)
			if(H.belt)
				return FALSE

			if(!(I.slot_flags & ITEM_SLOT_BELT))
				return
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_BELT_R)
			if(H.beltr)
				return FALSE

			if(!H.belt)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_HIP))
				return
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_BELT_L)
			if(H.beltl)
				return FALSE

			if(!H.belt)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_HIP))
				return
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_HEAD)
			if(H.head)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_HEAD))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_PANTS)
			if(H.wear_pants)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_PANTS) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_SHIRT)
			if(H.wear_shirt)
				return FALSE
			if(I.blocking_behavior & BULKYBLOCKS)
				if(H.cloak)
					return FALSE
				if(H.wear_armor)
					return FALSE
			if(H.wear_armor)
				if(istype(H.wear_armor, I.type))
					return FALSE
				if(I.blocksound)
					if(I.blocksound == H.wear_armor.blocksound)
						return FALSE
			if( !(I.slot_flags & ITEM_SLOT_SHIRT) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_CLOAK)
			if(H.cloak)
				return FALSE
			if( (I.slot_flags & ITEM_SLOT_BACK_R) )
				if(H.backr)
					if((H.backr.slot_flags & ITEM_SLOT_CLOAK) )
						return FALSE
			if(H.wear_shirt)
				if(H.wear_shirt.blocking_behavior & BULKYBLOCKS)
					return FALSE
				if(istype(H.wear_shirt, I.type))
					return FALSE
			if(H.wear_armor)
				if(H.wear_armor.blocking_behavior & BULKYBLOCKS)
					return FALSE
				if(istype(H.wear_armor, I.type))
					return FALSE
			if( !(I.slot_flags & ITEM_SLOT_CLOAK) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_RING)
			if(H.wear_ring)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_RING) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_WRISTS)
			if(H.wear_wrists)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_WRISTS) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_HANDCUFFED)
			if(H.handcuffed)
				return FALSE
			if(!I.breakouttime)
				return FALSE
//			if(num_arms < 2)
//				return FALSE
			return TRUE
		if(ITEM_SLOT_LEGCUFFED)
			if(H.legcuffed)
				return FALSE
			if(!I.breakouttime)
				return FALSE
			if(H.num_legs < 2)
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACKPACK)
			if(H.backr)
				if(SEND_SIGNAL(H.backr, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			if(H.backl)
				if(SEND_SIGNAL(H.backl, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			if(H.beltr)
				if(SEND_SIGNAL(H.beltr, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			if(H.beltl)
				if(SEND_SIGNAL(H.beltl, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			if(H.belt)
				if(SEND_SIGNAL(H.belt, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			return FALSE
	return FALSE //Unsupported slot

/datum/species/proc/equip_delay_self_check(obj/item/I, mob/living/carbon/human/H, bypass_equip_delay_self)
	if(!I.equip_delay_self || bypass_equip_delay_self)
		return TRUE
	if(HAS_TRAIT(H, TRAIT_CHUNKYFINGERS))
		return do_after(H, 5 MINUTES)
	var/doafter_flags = I.edelay_type ? (IGNORE_USER_LOC_CHANGE) : (NONE)
	return do_after(H, min((I.equip_delay_self - H.STASPD), 1), timed_action_flags = doafter_flags)

/// Equips the necessary species-relevant gear before putting on the rest of the uniform.
/datum/species/proc/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	return

/datum/species/proc/post_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	return

/datum/species/proc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == exotic_bloodtype)
		H.blood_volume = min(H.blood_volume + round(chem.volume, 0.1), BLOOD_VOLUME_MAXIMUM)
		H.reagents.del_reagent(chem.type)
		return TRUE
	if(chem.overdose_threshold && chem.volume >= chem.overdose_threshold)
		chem.overdosed = TRUE

/datum/species/proc/check_species_weakness(obj/item, mob/living/attacker, mob/living/parent)
	return 0 //This is not a boolean, it's the multiplier for the damage that the user takes from the item.It is added onto the check_weakness value of the mob, and then the force of the item is multiplied by this value

/**
 * Equip the outfit required for life. Replaces items currently worn.
 */
/datum/species/proc/give_important_for_life(mob/living/carbon/human/human_to_equip)
	if(!outfit_important_for_life)
		return

	outfit_important_for_life= new()
	outfit_important_for_life.equip(human_to_equip)

////////
//LIFE//
////////

/datum/species/proc/handle_digestion(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOHUNGER))
		return //hunger is for BABIES

	// nutrition decrease and satiety
	if(H.nutrition > 0 && H.stat != DEAD)
		var/hunger_rate = (HUNGER_FACTOR * nutrition_mod)
		H.adjust_nutrition(-hunger_rate)

	if(H.hydration > 0 && H.stat != DEAD)
		var/hunger_rate = HUNGER_FACTOR
		H.adjust_hydration(-hunger_rate)

	if(H.nutrition > NUTRITION_LEVEL_FULL && H.overeatduration < 600)
		H.overeatduration++ //capped so people don't take forever to unfat
	else if(H.overeatduration > 1)
		H.overeatduration -= 2 //doubled the unfat rate

	switch(H.nutrition)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			H.apply_status_effect(/datum/status_effect/debuff/hungryt1)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt2)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt3)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt4)
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			H.apply_status_effect(/datum/status_effect/debuff/hungryt2)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt1)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt3)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt4)
		if(0 to NUTRITION_LEVEL_STARVING)
			H.apply_status_effect(/datum/status_effect/debuff/hungryt3)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt1)
			H.remove_status_effect(/datum/status_effect/debuff/hungryt2)
			if(CONFIG_GET(flag/starvation_death))
				H.apply_status_effect(/datum/status_effect/debuff/hungryt4)
			if(prob(3))
				playsound(H, pick('sound/vo/hungry1.ogg','sound/vo/hungry2.ogg','sound/vo/hungry3.ogg'), 100, TRUE, -1)

	switch(H.hydration)
		if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
			H.apply_status_effect(/datum/status_effect/debuff/thirstyt1)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt3)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt4)
		if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
			H.apply_status_effect(/datum/status_effect/debuff/thirstyt2)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt3)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt4)
		if(0 to HYDRATION_LEVEL_DEHYDRATED)
			H.apply_status_effect(/datum/status_effect/debuff/thirstyt3)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			H.remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			if(CONFIG_GET(flag/dehydration_death))
				H.apply_status_effect(/datum/status_effect/debuff/thirstyt4)

/datum/species/proc/update_health_hud(mob/living/carbon/human/H)
	return 0

/datum/species/proc/go_bald(mob/living/carbon/human/H)
	if(QDELETED(H))	//may be called from a timer
		return
	if(H.gender == MALE)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/shaved, FALSE)
	if(H.gender == FEMALE)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/none, FALSE)
	H.set_hair_style(/datum/sprite_accessory/hair/head/bald)


/datum/species/proc/handle_hygiene(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return
	if(HAS_TRAIT(H, TRAIT_NOHYGIENE))
		return
	switch(H.hygiene)
		if(HYGIENE_LEVEL_CLEAN to HYGIENE_LEVEL_CLEAN)
			if(HAS_TRAIT(H, TRAIT_STINKY))
				H.add_stress(/datum/stress_event/forced_clean)
				H.remove_stress(/datum/stress_event/filth_lover)
			else
				H.add_stress(/datum/stress_event/clean)
			H.remove_status_effect(/datum/status_effect/debuff/stinky_person)
			H.remove_stress(/datum/stress_event/dirty)
			H.remove_stress(/datum/stress_event/disgusting)
		if(HYGIENE_LEVEL_DISGUSTING to HYGIENE_LEVEL_DISGUSTING)
			if(HAS_TRAIT(H, TRAIT_STINKY))
				H.add_stress(/datum/stress_event/filth_lover)
			else
				H.add_stress(/datum/stress_event/disgusting)
			H.apply_status_effect(/datum/status_effect/debuff/stinky_person)
			H.remove_stress(/datum/stress_event/forced_clean)
			H.remove_stress(/datum/stress_event/dirty)
			H.remove_stress(/datum/stress_event/clean)

		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_CLEAN)
			H.remove_stress(/datum/stress_event/dirty)
			H.remove_stress(/datum/stress_event/disgusting)
			H.remove_status_effect(/datum/status_effect/debuff/stinky_person)
		if(HYGIENE_LEVEL_DISGUSTING to HYGIENE_LEVEL_DIRTY)
			if(HAS_TRAIT(H, TRAIT_STINKY))
				H.add_stress(/datum/stress_event/filth_lover)
			else
				H.add_stress(/datum/stress_event/dirty)
			H.remove_status_effect(/datum/status_effect/debuff/stinky_person)
			H.remove_stress(/datum/stress_event/forced_clean)
			H.remove_stress(/datum/stress_event/disgusting)
			H.remove_stress(/datum/stress_event/clean)






//////////////////
// ATTACK PROCS //
//////////////////

/datum/species/proc/spec_updatehealth(mob/living/carbon/human/H)
	return

/datum/species/proc/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
//	if(!((target.health < 0 || HAS_TRAIT(target, TRAIT_FAKEDEATH)) && !(target.mobility_flags & MOBILITY_STAND)))
	if(target.body_position == LYING_DOWN)
		target.help_shake_act(user)
		if(target != user)
			log_combat(user, target, "shaken")
		return TRUE
/*	else
		var/we_breathe = !HAS_TRAIT(user, TRAIT_NOBREATH)
		var/we_lung = user.getorganslot(ORGAN_SLOT_LUNGS)

		if(we_breathe && we_lung)
			user.do_cpr(target)
		else if(we_breathe && !we_lung)
			to_chat(user, "<span class='warning'>I have no lungs to breathe with, so you cannot perform CPR!</span>")
		else
			to_chat(user, "<span class='warning'>I do not breathe, so you cannot perform CPR!</span>")*/

/datum/species/proc/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s grab!</span>", \
						"<span class='danger'>I block [user]'s grab!</span>", "<span class='hear'>I hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='warning'>My grab at [target] was blocked!</span>")
		return FALSE

	if(attacker_style && attacker_style.grab_act(user,target))
		return TRUE
	else
/*		//Steal them shoes
		if(!(target.mobility_flags & MOBILITY_STAND) && (user.zone_selected == BODY_ZONE_L_LEG || user.zone_selected == BODY_ZONE_R_LEG) && user.used_intent.type == INTENT_GRAB && target.shoes)
			var/obj/item/I = target.shoes
			user.visible_message("<span class='warning'>[user] starts stealing [target]'s [I.name]!</span>",
							"<span class='danger'>I start stealing [target]'s [I.name]...</span>", null, null, target)
			to_chat(target, "<span class='danger'>[user] starts stealing my [I.name]!</span>")
			if(do_after(user, I.strip_delay, TRUE, target, TRUE))
				target.dropItemToGround(I, TRUE)
				user.put_in_hands(I)
				user.visible_message("<span class='warning'>[user] stole [target]'s [I.name]!</span>",
								"<span class='notice'>I stole [target]'s [I.name]!</span>", null, null, target)
				to_chat(target, "<span class='danger'>[user] stole my [I.name]!</span>")*/
		var/def_zone = check_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)
		if(length(affecting?.embedded_objects))
			for(var/obj/item/embedded in affecting.embedded_objects)
				target.grabbedby(user, 1, item_override = embedded)
				return TRUE
		target.grabbedby(user)
		return TRUE

///This proc handles punching damage. IMPORTANT: Our owner is the TARGET and not the USER in this proc. For whatever reason...
/datum/species/proc/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>I don't want to harm [target]!</span>")
		return FALSE
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s attack!</span>", \
						"<span class='danger'>I block [user]'s attack!</span>", "<span class='hear'>I hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='warning'>My attack at [target] was blocked!</span>")
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	else

//		var/atk_verb = user.dna.species.attack_verb
//		if(!(target.mobility_flags & MOBILITY_STAND))
//			atk_verb = ATTACK_EFFECT_KICK

//	switch(atk_verb)//this code is really stupid but some genius apparently made "claw" and "slash" two attack types but also the same one so it's needed i guess
//		if(ATTACK_EFFECT_KICK)
//			user.do_attack_animation(target, ATTACK_EFFECT_KICK)
//		if(ATTACK_EFFECT_SLASH || ATTACK_EFFECT_CLAW)//smh
//			user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
//		if(ATTACK_EFFECT_SMASH)
//			user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
///			else
//				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

		var/cached_intent = user.used_intent
		sleep(user.used_intent.swingdelay)
		if(user.a_intent != cached_intent)
			return FALSE
		if(!target.Adjacent(user))
			return
		if(user.incapacitated(IGNORE_GRAB))
			return

		var/damage = user.get_punch_dmg()

		var/selzone = accuracy_check(user.zone_selected, user, target, /datum/skill/combat/unarmed, user.used_intent)

		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(selzone))

		if(!affecting)
			to_chat(user, "<span class='warning'>Unfortunately, there's nothing there.</span>")
			return 0

		if(!target.lying_attack_check(user))
			return 0

		var/armor_block = target.run_armor_check(selzone, "blunt", blade_dulling = user.used_intent.blade_class)

		target.lastattacker = user.real_name
		if(target.mind)
			target.mind.attackedme[user.real_name] = world.time
		target.lastattackerckey = user.ckey
		target.lastattacker_weakref = WEAKREF(user)
		user.dna.species.spec_unarmedattacked(user, target)

		user.do_attack_animation(target, visual_effect_icon = user.used_intent.animname, used_item = FALSE, atom_bounce = TRUE)
		target.next_attack_msg.Cut()

		var/nodmg = FALSE
		var/actual_damage = target.apply_damage(damage, user.dna.species.attack_type, affecting, armor_block)
		if(!actual_damage)
			nodmg = TRUE
			target.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
		else
			affecting.bodypart_attacked_by(user.used_intent.blade_class, damage, user, selzone, crit_message = TRUE)
			if(affecting.body_zone == BODY_ZONE_HEAD)
				SEND_SIGNAL(user, COMSIG_HEAD_PUNCHED, target)
		log_combat(user, target, "punched")
		knockback(attacker_style, target, user, nodmg, actual_damage)

		if(!nodmg)
			if(user.limb_destroyer)
				var/easy_dismember = HAS_TRAIT(target, TRAIT_EASYDISMEMBER) || affecting.rotted
				if(prob(damage/2) || (easy_dismember && prob(damage/2))) //try twice
					if(affecting.brute_dam > 0)
						affecting.dismember()

/*		if(user == target)
			target.visible_message("<span class='danger'>[user] [atk_verb]ed themself![target.next_attack_msg.Join()]</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='userdanger'>I [atk_verb] myself![target.next_attack_msg.Join()]</span>")
		else
			target.visible_message("<span class='danger'>[user] [atk_verb]ed [target]![target.next_attack_msg.Join()]</span>", \
							"<span class='userdanger'>I'm [atk_verb]ed by [user]![target.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>I [atk_verb] [target]![target.next_attack_msg.Join()]</span>")
*/
		var/message_verb = "punched"
		if(user.used_intent)
			message_verb = "[pick(user.used_intent.attack_verb)]"
		var/message_hit_area = ""
		if(selzone)
			message_hit_area = " in the [parse_zone(selzone)]"
		var/attack_message = "[user] [message_verb] [target][message_hit_area]!"
		var/attack_message_local = "[user] [message_verb] me[message_hit_area]!"
		target.visible_message("<span class='danger'>[attack_message][target.next_attack_msg.Join()]</span>",\
			"<span class='danger'>[attack_message_local][target.next_attack_msg.Join()]</span>", null, COMBAT_MESSAGE_RANGE)
		target.next_attack_msg.Cut()

/*		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message("<span class='danger'>[user] knocks [target] down!</span>", \
							"<span class='danger'>You're knocked down by [user]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>I knock [target] down!</span>")
			var/knockdown_duration = 40 + (target.getStaminaLoss() + (target.getBruteLoss()*0.5))*0.8 //50 total damage = 40 base stun + 40 stun modifier = 80 stun duration, which is the old base duration
			target.apply_effect(knockdown_duration, EFFECT_KNOCKDOWN, armor_block)
			target.forcesay(GLOB.hit_appends)
			log_combat(user, target, "got a stun punch with their previous punch")*/
		if(target.body_position == LYING_DOWN)
			target.forcesay(GLOB.hit_appends)
		if(!nodmg)
			playsound(target, user.used_intent.hitsound, 100, FALSE)


/datum/species/proc/spec_unarmedattacked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[user]'s shove is blocked by [target]!</span>", \
						"<span class='danger'>I block [user]'s shove!</span>", "<span class='hear'>I hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='warning'>My shove at [target] was blocked!</span>")
		return FALSE
	if(attacker_style && attacker_style.disarm_act(user,target))
		return TRUE
	if(HAS_TRAIT(user, TRAIT_FLOORED))
		return FALSE
	if(user == target)
		return FALSE
	if(user.loc == target.loc)
		return FALSE
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM, used_item = FALSE, atom_bounce = TRUE)
		playsound(target, 'sound/combat/shove.ogg', 100, TRUE, -1)

		if(target.wear_pants)
			target.wear_pants.add_fingerprint(user)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)

		var/turf/target_oldturf = target.loc
		var/shove_dir = get_dir(user.loc, target_oldturf)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/target_collateral_mob
		var/obj/structure/table/target_table
//		var/obj/machinery/disposal/bin/target_disposal_bin
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		if(prob(clamp(30 + (user.stat_compare(target, STATKEY_STR, STATKEY_CON)*10),0,100)))//check if we actually shove them
			//Thank you based whoneedsspace
			target_collateral_mob = locate(/mob/living) in target_shove_turf.contents
			if(target_collateral_mob)
				shove_blocked = TRUE
			else
				target.Move(target_shove_turf, shove_dir)
				if(get_turf(target) == target_oldturf)
					target_table = locate(/obj/structure/table) in target_shove_turf.contents
	//				target_disposal_bin = locate(/obj/machinery/disposal/bin) in target_shove_turf.contents
					if(target_table)
						shove_blocked = TRUE
			qdel(user.check_arm_grabbed(user.active_hand_index))

/*		if(target.IsKnockdown() && !target.IsParalyzed())
			target.Paralyze(SHOVE_CHAIN_PARALYZE)
			target.visible_message("<span class='danger'>[user.name] kicks [target.name] onto their side!</span>",
							"<span class='danger'>You're kicked onto my side by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>I kick [target.name] onto their side!</span>")
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, SetKnockdown), 0), SHOVE_CHAIN_PARALYZE)
			log_combat(user, target, "kicks", "onto their side (paralyzing)")*/

		if(shove_blocked && !target.is_shove_knockdown_blocked() && !target.buckled)
			var/directional_blocked = FALSE
			if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
				var/target_turf = get_turf(target)
				for(var/obj/O in target_turf)
					if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
						directional_blocked = TRUE
						break
				if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
					for(var/obj/O in target_shove_turf)
						if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
							directional_blocked = TRUE
							break
			if((!target_table && !target_collateral_mob) || directional_blocked)
				target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
				target.visible_message("<span class='danger'>[user.name] shoves [target.name], knocking them down!</span>",
								"<span class='danger'>You're knocked down from a shove by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I shove [target.name], knocking them down!</span>")
				log_combat(user, target, "shoved", "knocking them down")
			else if(target_table)
				target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
				target.visible_message("<span class='danger'>[user.name] shoves [target.name] onto \the [target_table]!</span>",
								"<span class='danger'>I'm shoved onto \the [target_table] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I shove [target.name] onto \the [target_table]!</span>")
				target.throw_at(target_table, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
				log_combat(user, target, "shoved", "onto [target_table] (table)")
			else if(target_collateral_mob)
				target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				target_collateral_mob.Knockdown(SHOVE_KNOCKDOWN_COLLATERAL)
				target.visible_message("<span class='danger'>[user.name] shoves [target.name] into [target_collateral_mob.name]!</span>",
					"<span class='danger'>I'm shoved into [target_collateral_mob.name] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I shove [target.name] into [target_collateral_mob.name]!</span>")
				log_combat(user, target, "shoved", "into [target_collateral_mob.name]")
		else
			target.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
							"<span class='danger'>I'm shoved by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>I shove [target.name]!</span>")
			var/target_held_item = target.get_active_held_item()
			var/knocked_item = FALSE
			if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types))
				target_held_item = null
			if(!target.has_movespeed_modifier(MOVESPEED_ID_SHOVE))
				target.add_movespeed_modifier(MOVESPEED_ID_SHOVE, multiplicative_slowdown = SHOVE_SLOWDOWN_STRENGTH)
				if(target_held_item)
					target.visible_message("<span class='danger'>[target.name]'s grip on \the [target_held_item] loosens!</span>",
						"<span class='warning'>My grip on \the [target_held_item] loosens!</span>", null, COMBAT_MESSAGE_RANGE)
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, clear_shove_slowdown)), SHOVE_SLOWDOWN_LENGTH)
			else if(target_held_item)
				target.dropItemToGround(target_held_item)
				knocked_item = TRUE
				target.visible_message("<span class='danger'>[target.name] drops \the [target_held_item]!</span>",
					"<span class='warning'>I drop \the [target_held_item]!</span>", null, COMBAT_MESSAGE_RANGE)
			var/append_message = ""
			if(target_held_item)
				if(knocked_item)
					append_message = "causing them to drop [target_held_item]"
				else
					append_message = "loosening their grip on [target_held_item]"
			log_combat(user, target, "shoved", append_message)

//shameless copypaste
/datum/species/proc/kicked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(QDELETED(user) || QDELETED(target))
		return
	if(!ishuman(user) || !ishuman(target))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>I don't want to harm [target]!</span>")
		return FALSE
	if(HAS_TRAIT(user, TRAIT_FLOORED))
		return FALSE
	if(user == target)
		return FALSE
	if(user.check_leg_grabbed(1) || user.check_leg_grabbed(2))
		if(user.check_leg_grabbed(1) && user.check_leg_grabbed(2))		//If both legs are grabbed
			to_chat(user, span_notice("I can't move my legs!"))
			return
		else															//If only one leg is grabbed
			to_chat(user, span_notice("I can't move my leg!"))
			user.resist_grab()
		return

	if(user.stamina >= user.maximum_stamina)
		return FALSE
	var/stander = TRUE
	if(target.body_position == LYING_DOWN)
		stander = FALSE
	if(user.loc == target.loc)
		if(!stander)
			target.lastattacker = user.real_name
			target.lastattackerckey = user.ckey
			target.lastattacker_weakref = WEAKREF(user)
			if(target.mind)
				target.mind.attackedme[user.real_name] = world.time
			var/selzone = accuracy_check(user.zone_selected, user, target, /datum/skill/combat/unarmed, user.used_intent)
			var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(selzone))
			var/damage = user.get_kick_damage(2.5)
			var/armor_block = target.run_armor_check(selzone, "blunt", blade_dulling = BCLASS_BLUNT)
			var/balance = 10
			target.next_attack_msg.Cut()
			var/nodmg = FALSE
			if(!target.apply_damage(damage, user.dna.species.attack_type, affecting, armor_block))
				nodmg = TRUE
				target.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
			else
				if(affecting)
					if(selzone == BODY_ZONE_PRECISE_NECK)
						to_chat(user, "<span class='danger'>I put my foot on [target]'s neck!</span>")
						nodmg = TRUE
						target.emote("gasp")
						target.adjustOxyLoss(25)
						target.Immobilize(5)
						balance += 15
						target.visible_message("<span class='danger'>[user] puts their foot on [target]'s neck!</span>", \
										"<span class='danger'>I get my throat stepped on by [user]! I can't breathe!</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE, user)
					else
						affecting.bodypart_attacked_by(BCLASS_BLUNT, damage, user, user.zone_selected, crit_message = TRUE)
						target.visible_message("<span class='danger'>[user] stomps [target]![target.next_attack_msg.Join()]</span>", \
										"<span class='danger'>I'm stomped by [user]![target.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening kick!</span>", COMBAT_MESSAGE_RANGE, user)
						to_chat(user, "<span class='danger'>I stomp on [target]![target.next_attack_msg.Join()]</span>")
			target.next_attack_msg.Cut()
			log_combat(user, target, "kicked")
			user.OffBalance(balance)
			if(!nodmg)
				playsound(target, 'sound/combat/hits/kick/stomp.ogg', 100, TRUE, -1)
			return TRUE
		else
			to_chat(user, "<span class='warning'>I'm too close to get a good kick in.</span>")
			return FALSE
	else
		if(!target.kick_attack_check(user))
			return 0

		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)

		if(target.pulling && target.grab_state < GRAB_AGGRESSIVE)
			target.stop_pulling()

		var/turf/target_oldturf = target.loc
		var/shove_dir = get_dir(user.loc, target_oldturf)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/target_collateral_mob
		var/obj/structure/table/target_table
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		target_collateral_mob = locate(/mob/living) in target_shove_turf.contents
		if(target_collateral_mob)
			if(stander)
				shove_blocked = TRUE
		else
			target.Move(target_shove_turf, shove_dir)
			if(get_turf(target) == target_oldturf)
				if(stander)
					target_table = locate(/obj/structure/table) in target_shove_turf.contents
					shove_blocked = TRUE
			else
				if(stander && target.stamina >= target.maximum_stamina) //if you are kicked while fatigued, you are knocked down no matter what
					target.Knockdown(100)

		if(shove_blocked && !target.is_shove_knockdown_blocked() && !target.buckled)
			var/directional_blocked = FALSE
			if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
				var/target_turf = get_turf(target)
				for(var/obj/O in target_turf)
					if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
						directional_blocked = TRUE
						break
				if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
					for(var/obj/O in target_shove_turf)
						if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
							directional_blocked = TRUE
							break
			if((!target_table && !target_collateral_mob) || directional_blocked)
				target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
				target.visible_message("<span class='danger'>[user.name] kicks [target.name], knocking them down!</span>",
								"<span class='danger'>I'm knocked down from a kick by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I kick [target.name], knocking them down!</span>")
				log_combat(user, target, "kicked", "knocking them down")
			else if(target_table)
				target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
				target.visible_message("<span class='danger'>[user.name] kicked [target.name] onto \the [target_table]!</span>",
								"<span class='danger'>I'm kicked onto \the [target_table] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I kick [target.name] onto \the [target_table]!</span>")
				target.throw_at(target_table, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
				log_combat(user, target, "kicked", "onto [target_table] (table)")
			else if(target_collateral_mob)
				target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				target_collateral_mob.Knockdown(SHOVE_KNOCKDOWN_COLLATERAL)
				target.visible_message("<span class='danger'>[user.name] kicks [target.name] into [target_collateral_mob.name]!</span>",
					"<span class='danger'>I'm kicked into [target_collateral_mob.name] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
				to_chat(user, "<span class='danger'>I kick [target.name] into [target_collateral_mob.name]!</span>")
				log_combat(user, target, "kicked", "into [target_collateral_mob.name]")
		else
			target.visible_message("<span class='danger'>[user.name] kicks [target.name]!</span>",
							"<span class='danger'>I'm kicked by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>I kick [target.name]!</span>")
			log_combat(user, target, "kicked")

		var/selzone = accuracy_check(user.zone_selected, user, target, /datum/skill/combat/unarmed, user.used_intent)
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(selzone))
		if(!affecting)
			affecting = target.get_bodypart(BODY_ZONE_CHEST)
		var/armor_block = target.run_armor_check(selzone, "blunt", blade_dulling = BCLASS_BLUNT)
		var/damage = user.get_kick_damage(1.4)
		var/damage_blocked = FALSE

		if(!target.apply_damage(damage, user.dna.species.attack_type, affecting, armor_block))
			damage_blocked = TRUE
			target.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
		else
			affecting.bodypart_attacked_by(BCLASS_BLUNT, damage, user, selzone)

		SEND_SIGNAL(user, COMSIG_MOB_KICK, target, selzone, damage_blocked)
		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.lastattacker_weakref = WEAKREF(user)
		if(target.mind)
			target.mind.attackedme[user.real_name] = world.time
		user.adjust_stamina(15)
		user.OffBalance(15)
		target.forcesay(GLOB.hit_appends)

/datum/species/proc/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	return

/datum/species/proc/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return
	if(M.mind)
		attacker_style = M.mind.martial_art
	if((M != H) && M.used_intent.type != INTENT_HELP && H.check_shields(M, 0, M.name, attack_type = UNARMED_ATTACK))
		log_combat(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempts to touch [H]!</span>", \
						"<span class='danger'>[M] attempts to touch you!</span>", "<span class='hear'>I hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, M)
		to_chat(M, "<span class='warning'>I attempt to touch [H]!</span>")
		return 0
	SEND_SIGNAL(M, COMSIG_MOB_ATTACK_HAND, M, H, attacker_style)
	switch(M.used_intent.type)
		if(INTENT_HELP)
			help(M, H, attacker_style)
			return

		if(INTENT_GRAB)
			if(!M.has_hand_for_held_index(M.active_hand_index, TRUE)) //we obviously have a hand, but we need to check for fingers/prosthetics
				to_chat(M, "<span class='warning'>I can't move the fingers of my [M.active_hand_index == 1 ? "left" : "right"] hand.</span>")
				return
			grab(M, H, attacker_style)
			return

		if(INTENT_DISARM)
			disarm(M, H, attacker_style)
			return
	if(istype(M.used_intent, /datum/intent/unarmed))
		harm(M, H, attacker_style)

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H, selzone, accurate = FALSE)
	// Allows you to put in item-specific reactions based on species
	if(user != H)
		if(H.can_see_cone(user))
			if(H.check_shields(I, I.force, "\the [I]", MELEE_ATTACK, I.armor_penetration))
				return 0
	if(H.check_block())
		H.visible_message("<span class='warning'>[H] blocks [I]!</span>", \
						"<span class='danger'>I block [I]!</span>")
		return 0

	var/hit_area

	if(!selzone)
		selzone = user.zone_selected
	if(!accurate)
		selzone = accuracy_check(selzone, user, H, I.associated_skill, user.used_intent, I)
	affecting = H.get_bodypart(check_zone(selzone))

	if(!affecting)
		return

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/pen = I.armor_penetration
	if(user.used_intent?.penfactor)
		pen = I.armor_penetration + user.used_intent.penfactor

//	var/armor_block = H.run_armor_check(affecting, "melee", "<span class='notice'>My armor has protected my [hit_area]!</span>", "<span class='warning'>My armor has softened a hit to my [hit_area]!</span>",pen)

	var/Iforce = get_complex_damage(I, user) //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)
	var/armor_block = H.run_armor_check(selzone, I.damage_type, "", "",pen, damage = Iforce, blade_dulling=user.used_intent.blade_class)

	var/nodmg = FALSE

	var/actual_damage = Iforce
	if(Iforce)

		var/weakness = H.check_weakness(I, user)
		actual_damage = apply_damage(Iforce * weakness, I.damtype, def_zone, armor_block, H)
		H.next_attack_msg.Cut()
		if(!actual_damage)
			nodmg = TRUE
			H.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
			if(!QDELETED(I))
				I.take_damage(1, BRUTE, I.damage_type)
		if(!nodmg)
			var/datum/wound/crit_wound = affecting.bodypart_attacked_by(user.used_intent.blade_class, (Iforce * weakness) * ((100-(armor_block))/100), user, selzone, crit_message = TRUE)
			if(crit_wound?.should_embed(I))
				var/can_impale = TRUE
				if(!affecting)
					can_impale = FALSE
				else if(I.wlength > WLENGTH_SHORT && !(affecting.body_zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
					can_impale = FALSE
				if(can_impale && user.Adjacent(H))
					affecting.add_embedded_object(I, silent = FALSE, crit_message = TRUE)
					H.emote("embed")
					affecting.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class)//It hurts to rip it out, get surgery you dingus.
					user.put_in_hands(I)
					H.emote("pain", TRUE)
					playsound(H, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
			I.do_special_attack_effect(user, affecting, intent, H, selzone)
			if(istype(user.used_intent, /datum/intent/effect) && selzone)
				var/datum/intent/effect/effect_intent = user.used_intent
				if(LAZYLEN(effect_intent.target_parts))
					if(selzone in effect_intent.target_parts)
						H.apply_status_effect(effect_intent.intent_effect)
				else
					H.apply_status_effect(effect_intent.intent_effect)
//		if(H.used_intent.blade_class == BCLASS_BLUNT && I.force >= 15 && affecting.body_zone == "chest")
//			var/turf/target_shove_turf = get_step(H.loc, get_dir(user.loc,H.loc))
//			H.throw_at(target_shove_turf, 1, 1, H, spin = FALSE)

	I.funny_attack_effects(H, user, nodmg)
	knockback(I, H, user, nodmg, actual_damage)

	H.send_item_attack_message(I, user, parse_zone(selzone))
	SEND_SIGNAL(I, COMSIG_ITEM_SPEC_ATTACKEDBY, H, user, affecting, actual_damage)
	if(nodmg)
		return FALSE //dont play a sound

	//dismemberment
	var/bloody = 0
	var/probability = I.get_dismemberment_chance(affecting, user)
	if(affecting.brute_dam && prob(probability) && affecting.dismember(I.damtype, user.used_intent?.blade_class, user, selzone))
		bloody = 1
		I.add_mob_blood(H)
		user.update_inv_hands()

	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			user.update_inv_hands()
			if(prob(I.force * 2) || bloody)	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				var/splatter_dir = get_dir(H, user)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(H.loc, splatter_dir)
				if(istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if(BODY_ZONE_HEAD)
				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()

			if(BODY_ZONE_CHEST)
				if(bloody)
					if(H.wear_armor)
						H.wear_armor.add_mob_blood(H)
						H.update_inv_armor()
					if(H.wear_shirt)
						H.wear_shirt.add_mob_blood(H)
						H.update_inv_shirt()
					if(H.wear_pants)
						H.wear_pants.add_mob_blood(H)
						H.update_inv_pants()

		if(Iforce > 10 || Iforce >= 5 && prob(Iforce))
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
	return TRUE

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, flashes = TRUE)
	SEND_SIGNAL(H, COMSIG_MOB_APPLY_DAMGE, damage, damagetype, def_zone)
	var/hit_percent = 1
	damage = max(damage - (blocked),0)
	hit_percent = (hit_percent * (100-H.physiology.damage_resistance))/100
	if(!damage || (!forced && hit_percent <= 0))
		return 0

	var/obj/item/bodypart/BP = null
	if(!spread_damage)
		if(isbodypart(def_zone))
			BP = def_zone
		else
			if(!def_zone)
				def_zone = ran_zone(def_zone)
			BP = H.get_bodypart(check_zone(def_zone))
			if(!BP)
				BP = H.bodyparts[1]

	var/damage_amount = damage
	switch(damagetype)
		if(BRUTE)
			H.damageoverlaytemp = 20
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.brute_mod
			if(!HAS_TRAIT(H, TRAIT_NOPAIN))
				if(damage_amount > 5)
					H.AdjustSleeping(-50)
					if(prob(damage_amount * 3))
						if(damage_amount > ((H.STACON*10) / 3))
							H.emote("painscream")
						else
							H.emote("pain")
				if(damage_amount > ((H.STACON*10) / 3) && !HAS_TRAIT(H, TRAIT_NOPAINSTUN))
					H.Immobilize(4)
					shake_camera(H, 2, 2)
					H.stuttering += 5
				if(damage_amount > 10 && !HAS_TRAIT(H, TRAIT_NOPAINSTUN))
					H.Slowdown(clamp(damage_amount/10, 1, 5))
					shake_camera(H, 1, 1)
				if(flashes)
					if(damage_amount < 10)
						H.flash_fullscreen("redflash1")
					else if(damage_amount < 20)
						H.flash_fullscreen("redflash2")
					else if(damage_amount >= 20)
						H.flash_fullscreen("redflash3")
			if(BP)
				if(BP.receive_damage(damage_amount, 0))
					H.update_damage_overlays()
			else//no bodypart, we deal damage with a more general method.
				H.adjustBruteLoss(damage_amount)
		if(BURN)
			H.damageoverlaytemp = 20
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.burn_mod
			if(damage_amount > 10 && prob(damage_amount))
				H.emote("pain")
			if(flashes)
				if(damage_amount < 10)
					H.flash_fullscreen("redflash1")
				else if(damage_amount < 20)
					H.flash_fullscreen("redflash2")
				else if(damage_amount >= 20)
					H.flash_fullscreen("redflash3")
			if(BP)
				if(BP.receive_damage(0, damage_amount, flashes = flashes))
					H.update_damage_overlays()
			else
				H.adjustFireLoss(damage_amount)
		if(TOX)
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.tox_mod
			H.adjustToxLoss(damage_amount)
		if(OXY)
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.oxy_mod
			H.adjustOxyLoss(damage_amount)
		if(CLONE)
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.clone_mod
			H.adjustCloneLoss(damage_amount)
		if(BRAIN)
			damage_amount = forced ? damage : damage * hit_percent * H.physiology.brain_mod
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, damage_amount)
	return damage_amount

/datum/species/proc/on_hit(obj/projectile/P, mob/living/carbon/human/H)

/datum/species/proc/bullet_act(obj/projectile/P, mob/living/carbon/human/H, def_zone = BODY_ZONE_CHEST)
	// called before a projectile hit
	if(def_zone == "head")
		if(H.head)
			var/obj/item/I = H.head
			if(I.blockproj(H))
				return 1
	return 0

/obj/item/proc/blockproj(mob/living/carbon/human/H)
	return

/datum/species/proc/handle_environment(mob/living/carbon/human/H)
	if(!H.client) //I cannot be assed to balance random npcs freezing
		return
	var/turf/T = get_turf(H)
	var/loc_temp = T ? T.return_temperature() : AMBIENT_COMFORT_MIN + 5 // Default to comfortable

	// Only start affecting body temperature outside comfort zone
	var/should_affect_body_temp = FALSE

	if(loc_temp < AMBIENT_COMFORT_MIN)
		should_affect_body_temp = TRUE
	else if(loc_temp > AMBIENT_COMFORT_MAX)
		should_affect_body_temp = TRUE

	// Natural body temperature regulation
	if(H.stat != DEAD && !H.on_fire)
		var/natural_adjustment = round(H.natural_bodytemperature_stabilization(), 0.1)

		if(should_affect_body_temp)
			var/thermal_protection = calculate_thermal_protection(H, loc_temp)
			var/temp_change = calculate_temperature_change(H, loc_temp, thermal_protection, natural_adjustment)
			H.adjust_bodytemperature(temp_change)
		else
			// Just natural regulation in comfort zone
			H.adjust_bodytemperature(natural_adjustment)

	// Apply temperature damage and effects
	handle_temperature_effects(H)

/datum/species/proc/calculate_thermal_protection(mob/living/carbon/human/H, loc_temp)
	if(loc_temp < H.bodytemperature)
		return 1 - H.get_cold_protection(loc_temp)
	else
		return 1 - H.get_heat_protection(loc_temp)


/datum/species/proc/calculate_temperature_change(mob/living/carbon/human/H, loc_temp, thermal_protection, natural_adjustment)
	var/temp_diff = loc_temp - H.bodytemperature
	var/environmental_effect = 0

	if(loc_temp < H.bodytemperature) // Environment is colder
		if(H.bodytemperature < BODYTEMP_NORMAL) // We're cold, insulation helps retain heat
			environmental_effect = max(thermal_protection * temp_diff / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX)
			// Reduce natural warming when exposed (thermal_protection = 1 means fully exposed)
			var/adjusted_natural = natural_adjustment * (1 - thermal_protection * 0.8) // 80% reduction when fully exposed
			return round(adjusted_natural + environmental_effect, 0.1)
		else // We're warm, insulation hinders cooling
			environmental_effect = max((thermal_protection * temp_diff + BODYTEMP_NORMAL - H.bodytemperature) / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX)
			// Natural regulation is hindered by exposure
			var/adjusted_natural = natural_adjustment * (1 - thermal_protection * 0.5) // 50% reduction when fully exposed
			return round(adjusted_natural + environmental_effect, 0.1)
	else if(loc_temp > H.bodytemperature) // Environment is hotter
		if(H.bodytemperature < BODYTEMP_NORMAL) // We're cold, insulation helps but reduces environmental heating
			environmental_effect = min(thermal_protection * temp_diff / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX)
			// Natural warming is hindered by heat exposure
			var/adjusted_natural = natural_adjustment * (1 - thermal_protection * 0.3) // 30% reduction when fully exposed
			return round(adjusted_natural + environmental_effect, 0.1)
		else // We're warm, insulation hinders heat dissipation
			environmental_effect = min(thermal_protection * temp_diff / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX)
			// Natural regulation is hindered by exposure
			var/adjusted_natural = natural_adjustment * (1 - thermal_protection * 0.6) // 60% reduction when fully exposed
			return round(adjusted_natural + environmental_effect, 0.1)
	return natural_adjustment

/datum/species/proc/handle_temperature_effects(mob/living/carbon/human/H)
	var/debuff_level = 0
	// Heat damage and effects
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTHEAT))
		remove_cold_stress(H)

		var/heat_excess = H.bodytemperature - BODYTEMP_HEAT_DAMAGE_LIMIT
		apply_heat_stress(H, heat_excess)

		H.remove_movespeed_modifier(MOVESPEED_ID_COLD)
		var/burn_damage = calculate_heat_damage(H, heat_excess)
		debuff_level = calculate_heat_debuff_level(heat_excess)
		// Apply damage
		if(burn_damage > 0)
			var/final_damage = CLAMP(burn_damage * H.physiology.heat_mod, 0, CONFIG_GET(number/per_tick/max_fire_damage))
			H.apply_damage(final_damage, BURN, spread_damage = TRUE, flashes = FALSE)
			if(!H.has_smoke_protection())
				H.apply_damage(final_damage/4, OXY, flashes = FALSE) // Smoke inhalation
			if(H.stat < UNCONSCIOUS && prob(burn_damage * 10 / 4))
				H.emote("pain")
		// Apply building heat debuffs
		apply_heat_debuffs(H, debuff_level)
	// Cold damage and effects
	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTCOLD))
		remove_heat_stress(H)

		var/cold_deficit = BODYTEMP_COLD_DAMAGE_LIMIT - H.bodytemperature
		apply_cold_stress(H, cold_deficit)

		var/cold_damage = calculate_cold_damage(cold_deficit)
		debuff_level = calculate_cold_debuff_level(cold_deficit)
		// Apply damage
		if(cold_damage > 0)
			H.apply_damage(cold_damage * H.physiology.cold_mod, BURN, flashes = FALSE)
		// Apply building cold debuffs
		apply_cold_debuffs(H, debuff_level, cold_deficit)
	// Clear effects when in safe range
	else
		H.clear_alert("temp")
		H.remove_movespeed_modifier(MOVESPEED_ID_COLD)
		clear_temperature_debuffs(H)

/datum/species/proc/remove_heat_stress(mob/living/carbon/human/H)
	H.remove_stress(list(
		/datum/stress_event/hot_mild,
		/datum/stress_event/hot_moderate,
		/datum/stress_event/hot_severe,
	))

/datum/species/proc/apply_heat_stress(mob/living/carbon/human/H, heat_excess)
	if(heat_excess < 0)
		return
	switch(heat_excess)
		if(0 to 5) // Mild heat
			H.add_stress(/datum/stress_event/hot_mild)
		if(5 to 15) // Moderate heat
			H.add_stress(/datum/stress_event/hot_moderate)
		else // Severe heat
			H.add_stress(/datum/stress_event/hot_severe)

/datum/species/proc/remove_cold_stress(mob/living/carbon/human/H)
	H.remove_stress(list(
		/datum/stress_event/cold_mild,
		/datum/stress_event/cold_moderate,
		/datum/stress_event/cold_severe,
	))

/datum/species/proc/apply_cold_stress(mob/living/carbon/human/H, cold_deficit)
	if(cold_deficit < 0)
		return
	switch(cold_deficit)
		if(0 to 5) // Mild cold
			H.add_stress(/datum/stress_event/cold_mild)
		if(5 to 15) // Moderate cold
			H.add_stress(/datum/stress_event/cold_moderate)
		else // Severe cold
			H.add_stress(/datum/stress_event/cold_severe)

// Heat stress events
/datum/stress_event/hot_mild
	desc = "<span class='warning'>It's getting warm in here.</span>"
	timer = 60 SECONDS
	stress_change = 1

/datum/stress_event/hot_moderate
	desc = "<span class='red'>This heat is becoming unbearable.</span>"
	timer = 60 SECONDS
	stress_change = 3

/datum/stress_event/hot_severe
	desc = "<span class='boldred'>I'm burning up!</span>"
	timer = 60 SECONDS
	stress_change = 6

// Cold stress events
/datum/stress_event/cold_mild
	desc = "<span class='notice'>It's getting chilly.</span>"
	timer = 60 SECONDS
	stress_change = 1

/datum/stress_event/cold_moderate
	desc = "<span class='blue'>This cold is really getting to me.</span>"
	timer = 60 SECONDS
	stress_change = 3

/datum/stress_event/cold_severe
	desc = "<span class='boldblue'>I'm freezing to death!</span>"
	timer = 60 SECONDS
	stress_change = 6

/datum/species/proc/calculate_heat_damage(mob/living/carbon/human/H, heat_excess)
	var/firemodifier = (H.fire_stacks + H.divine_fire_stacks) / 50

	if(H.on_fire)
		if((H.fire_stacks + H.divine_fire_stacks) >= HUMAN_FIRE_STACK_ICON_NUM)
			return 200
		return 20
	else
		firemodifier = min(firemodifier, 0)
		return max(log(2-firemodifier, (H.bodytemperature-BODYTEMP_NORMAL))-5, 0)

/datum/species/proc/calculate_cold_damage(cold_deficit)
	switch(cold_deficit)
		if(0 to 60) // Mild cold
			return COLD_DAMAGE_LEVEL_1
		if(60 to 140) // Moderate cold
			return COLD_DAMAGE_LEVEL_2
		else // Severe cold
			return COLD_DAMAGE_LEVEL_3

/datum/species/proc/calculate_heat_debuff_level(heat_excess)
	switch(heat_excess)
		if(0 to 20)
			return 1
		if(20 to 50)
			return 2
		else
			return 3

/datum/species/proc/calculate_cold_debuff_level(cold_deficit)
	switch(cold_deficit)
		if(0 to 80)
			return 1
		if(80 to 140)
			return 2
		else
			return 3

/datum/species/proc/apply_heat_debuffs(mob/living/carbon/human/H, level)
	switch(level)
		if(1)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot)
			// Mild heat stress - slight stamina drain
			if(!H.temp_debuff_level || H.temp_debuff_level < 1)
				H.temp_debuff_level = 1
				H.adjust_hydration(-HUNGER_FACTOR * 0.5)
		if(2)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot)
			// Moderate heat stress - stamina drain + slight slowdown
			if(!H.temp_debuff_level || H.temp_debuff_level < 2)
				H.temp_debuff_level = 2
				H.adjust_hydration(-HUNGER_FACTOR)
		if(3)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot)
			// Severe heat stress - major stamina drain + significant slowdown
			if(!H.temp_debuff_level || H.temp_debuff_level < 3)
				H.temp_debuff_level = 3
				H.adjust_hydration(-HUNGER_FACTOR * 2)

/datum/species/proc/apply_cold_debuffs(mob/living/carbon/human/H, level, cold_deficit)
	switch(level)
		if(1)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold)
			// Mild cold - slight movement slowdown
			H.add_movespeed_modifier(MOVESPEED_ID_COLD, override = TRUE,
				multiplicative_slowdown = (cold_deficit / COLD_SLOWDOWN_FACTOR) * 0.5,
				blacklisted_movetypes = FLOATING)
			H.temp_debuff_level = 1
		if(2)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold)
			// Moderate cold - movement slowdown + reduced dexterity
			H.add_movespeed_modifier(MOVESPEED_ID_COLD, override = TRUE,
				multiplicative_slowdown = (cold_deficit / COLD_SLOWDOWN_FACTOR) * 0.8,
				blacklisted_movetypes = FLOATING)
			H.temp_debuff_level = 2
		if(3)
			H.throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold)
			// Severe cold - major slowdown + hypothermia effects
			H.add_movespeed_modifier(MOVESPEED_ID_COLD, override = TRUE,
				multiplicative_slowdown = cold_deficit / COLD_SLOWDOWN_FACTOR,
				blacklisted_movetypes = FLOATING)
			H.temp_debuff_level = 3

/datum/species/proc/clear_temperature_debuffs(mob/living/carbon/human/H)
	if(H.temp_debuff_level)
		H.remove_movespeed_modifier("heat_stress")
		H.temp_debuff_level = null
	H.remove_stress(list(
		/datum/stress_event/cold_mild,
		/datum/stress_event/cold_moderate,
		/datum/stress_event/cold_severe,
		/datum/stress_event/hot_mild,
		/datum/stress_event/hot_moderate,
		/datum/stress_event/hot_severe,
	))

//////////
// FIRE //
//////////

/datum/species/proc/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	if(!CanIgniteMob(H))
		return TRUE
	if(H.on_fire)
		//the fire tries to damage the exposed clothes and items
		var/list/burning_items = list()
		var/list/obscured = H.check_obscured_slots(TRUE)
		//HEAD//

		if(H.wear_mask && !(obscured & ITEM_SLOT_MASK))
			burning_items += H.wear_mask
		if(H.wear_neck && !(obscured & ITEM_SLOT_NECK))
			burning_items += H.wear_neck
		if(H.head && !(obscured & ITEM_SLOT_HEAD))
			burning_items += H.head

		//CHEST//
		if(H.wear_pants && !(obscured & ITEM_SLOT_PANTS))
			burning_items += H.wear_pants
		if(H.wear_shirt && !(obscured & ITEM_SLOT_SHIRT))
			burning_items += H.wear_shirt
		if(H.wear_armor && !(obscured & ITEM_SLOT_ARMOR))
			burning_items += H.wear_armor

		//ARMS & HANDS//
		var/obj/item/clothing/arm_clothes = null
		if(H.gloves && !(obscured & ITEM_SLOT_GLOVES))
			arm_clothes = H.gloves
		else if(H.wear_armor && ((H.wear_armor.body_parts_covered & HANDS) || (H.wear_armor.body_parts_covered & ARMS)))
			arm_clothes = H.wear_armor
		else if(H.wear_pants && ((H.wear_pants.body_parts_covered & HANDS) || (H.wear_pants.body_parts_covered & ARMS)))
			arm_clothes = H.wear_pants
		if(arm_clothes)
			burning_items |= arm_clothes

		//LEGS & FEET//
		var/obj/item/clothing/leg_clothes = null
		if(H.shoes && !(obscured & ITEM_SLOT_SHOES))
			leg_clothes = H.shoes
		else if(H.wear_armor && ((H.wear_armor.body_parts_covered & FEET) || (H.wear_armor.body_parts_covered & LEGS)))
			leg_clothes = H.wear_armor
		else if(H.wear_pants && ((H.wear_pants.body_parts_covered & FEET) || (H.wear_pants.body_parts_covered & LEGS)))
			leg_clothes = H.wear_pants
		if(leg_clothes)
			burning_items |= leg_clothes

		for(var/obj/item/I as anything in burning_items)
			I.fire_act(((H.fire_stacks + H.divine_fire_stacks) * 25)) //damage taken is reduced to 2% of this value by fire_act()

		var/thermal_protection = H.get_thermal_protection()

		if(thermal_protection >= 30000 && !no_protection)
			return
		if(thermal_protection >= 30000 && !no_protection)
			H.adjust_bodytemperature(5)
		else
			H.adjust_bodytemperature(BODYTEMP_HEATING_MAX + ((H.fire_stacks + H.divine_fire_stacks)* 12))
			H.add_stress(/datum/stress_event/on_fire)

/datum/species/proc/CanIgniteMob(mob/living/carbon/human/H)
	if(H.status_flags & GODMODE)
		return FALSE
	if(H.divine_fire_stacks > 0) // tieflings can't say no to astrata
		return TRUE
	if(HAS_TRAIT(H, TRAIT_NOFIRE))
		return FALSE
	return TRUE

/datum/species/proc/ExtinguishMob(mob/living/carbon/human/H)
	return


////////////
//  Stun  //
////////////

/datum/species/proc/spec_stun(mob/living/carbon/human/H,amount)
	. = H.physiology.stun_mod * amount

//////////////
//Space Move//
//////////////

/datum/species/proc/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return TRUE
	return FALSE

/datum/species/proc/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return TRUE
	return FALSE

////////////////
//Tail Wagging//
////////////////

/datum/species/proc/can_wag_tail(mob/living/carbon/human/H)
	if(!H) //Somewhere in the core code we're getting those procs with H being null
		return FALSE
	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(!T)
		return FALSE
	if(T.can_wag)
		return TRUE
	return FALSE

/datum/species/proc/is_wagging_tail(mob/living/carbon/human/H)
	if(!H) //Somewhere in the core code we're getting those procs with H being null
		return FALSE
	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(!T)
		return FALSE
	return T.wagging

/datum/species/proc/start_wagging_tail(mob/living/carbon/human/H)
	if(!H) //Somewhere in the core code we're getting those procs with H being null
		return
	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(!T)
		return FALSE
	T.wagging = TRUE
	H.update_body_parts(TRUE)

/datum/species/proc/stop_wagging_tail(mob/living/carbon/human/H)
	if(!H) //Somewhere in the core code we're getting those procs with H being null
		return
	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(!T)
		return
	T.wagging = FALSE
	H.update_body_parts(TRUE)

/datum/species/proc/knockback(obj/item/I, mob/living/target, mob/living/user, nodmg, actual_damage)
	if(!istype(I))
		if(!target.resting)
			var/chungus_str = target.STASTR
			var/knockback_tiles = 0
			var/damage = actual_damage
			if(chungus_str >= 3)
				knockback_tiles = FLOOR(damage/((chungus_str - 2) * 4), 1)
			else
				knockback_tiles = FLOOR(damage/2, 1)
			if(knockback_tiles >= 1)
				var/turf/edge_target_turf = get_edge_target_turf(target, get_dir(user, target))
				if(istype(edge_target_turf))
					target.safe_throw_at(edge_target_turf, \
										knockback_tiles, \
										knockback_tiles, \
										user, \
										spin = FALSE, \
										force = target.move_force, \
										callback = CALLBACK(target, TYPE_PROC_REF(/mob/living, handle_knockback), get_turf(target)))
	else
		if(!I.force)
			return
		if(!I.sharpness)
			if(!target.resting)
				var/endurance = target.STAEND
				var/knockback_tiles = 0
				var/newforce = actual_damage
				if(endurance >= 3)
					knockback_tiles = FLOOR(newforce/((endurance - 2) * 4), 1)
				else
					knockback_tiles = FLOOR(newforce/2, 1)
				if(knockback_tiles >= 1)
					var/turf/edge_target_turf = get_edge_target_turf(target, get_dir(user, target))
					if(istype(edge_target_turf))
						target.safe_throw_at(edge_target_turf, \
											knockback_tiles, \
											knockback_tiles, \
											user, \
											spin = FALSE, \
											force = target.move_force, \
											callback = CALLBACK(target, TYPE_PROC_REF(/mob/living, handle_knockback), get_turf(target)))

/mob/living/proc/handle_knockback(turf/starting_turf)
	var/distance = 0
	var/skill_modifier = 10
	if(istype(starting_turf) && !QDELETED(starting_turf))
		distance = get_dist(starting_turf, src)
	skill_modifier *= get_skill_level(/datum/skill/misc/athletics, TRUE)
	var/modifier = -distance
	if(!prob(STAEND+skill_modifier+modifier))
		Knockdown(8)
