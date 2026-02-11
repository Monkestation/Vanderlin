/datum/customizer/bodypart_feature/hair
	abstract_type = /datum/customizer/bodypart_feature/hair

/datum/customizer_choice/bodypart_feature/hair
	abstract_type = /datum/customizer_choice/bodypart_feature/hair
	customizer_entry_type = /datum/customizer_entry/hair
	allows_accessory_color_customization = FALSE //Customized through hair color
	var/allows_natural_gradient = TRUE
	var/allows_dye_gradient = TRUE

/datum/customizer_choice/bodypart_feature/hair/customize_feature(datum/bodypart_feature/feature, mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/hair/entry)
	var/datum/bodypart_feature/hair/hair_feature = feature
	hair_feature.hair_color = entry.hair_color
	hair_feature.accessory_colors = entry.hair_color
	hair_feature.natural_color = entry.natural_color
	hair_feature.hair_dye_color = entry.dye_color
	hair_feature.natural_gradient = entry.natural_gradient
	hair_feature.hair_dye_gradient = entry.dye_gradient

/datum/customizer_choice/bodypart_feature/hair/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	hair_entry.hair_color = sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, initial(hair_entry.hair_color))
	hair_entry.natural_color = sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, initial(hair_entry.natural_color))
	hair_entry.dye_color = sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, initial(hair_entry.dye_color))

/datum/customizer_choice/bodypart_feature/hair/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	dat += "<br>Hair Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=hair_color''><span class='color_holder_box' style='background-color:[hair_entry.hair_color]'></span></a>"
	if(allows_natural_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.natural_gradient)
		dat += "<br>Natural Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient'>[gradient.name]</a>"
		if(hair_entry.natural_gradient != /datum/hair_gradient/none)
			dat += "<br>Natural Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.natural_color]'></span></a>"
	if(allows_dye_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.dye_gradient)
		dat += "<br>Dye Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient'>[gradient.name]</a>"
		if(hair_entry.dye_gradient != /datum/hair_gradient/none)
			dat += "<br>Dye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.dye_color]'></span></a>"

/datum/customizer_choice/bodypart_feature/hair/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	switch(href_list["customizer_task"])
		if("hair_color")
			var/list/hairs
			var/new_color
			if(prefs.age == AGE_OLD && (OLDGREY in prefs.pref_species.species_traits))
				hairs = prefs.pref_species.get_oldhc_list()
			else
				hairs = prefs.pref_species.get_hairc_list()
			var/new_hair = browser_input_list(user, "SELECT YOUR HERO'S HAIR COLOR", "BARBER", hairs)
			if(new_hair)
				new_color = hairs[new_hair]
			if(!new_color)
				return
			hair_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("natural_gradient")
			if(!allows_natural_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = browser_input_list(user, "Choose your natural gradient:", "Character Preference", choice_list)
			if(!chosen_input)
				return
			hair_entry.natural_gradient = choice_list[chosen_input]
		if("natural_gradient_color")
			if(!allows_natural_gradient)
				return
			var/new_color = color_pick_sanitized_lumi(user, "Choose your natural gradient color:", "Character Preference", hair_entry.natural_color)
			if(!new_color)
				return
			hair_entry.natural_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("dye_gradient")
			if(!allows_dye_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = browser_input_list(user, "Choose your dye gradient:", "Character Preference", choice_list)
			if(!chosen_input)
				return
			hair_entry.dye_gradient = choice_list[chosen_input]
		if("dye_gradient_color")
			if(!allows_dye_gradient)
				return
			var/new_color = color_pick_sanitized_lumi(user, "Choose your dye gradient color:", "Character Preference", hair_entry.dye_color)
			if(!new_color)
				return
			hair_entry.dye_color = sanitize_hexcolor(new_color, 6, TRUE)

/datum/customizer_entry/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/dye_gradient = /datum/hair_gradient/none
	var/dye_color = "#FFFFFF"

/datum/customizer_choice/bodypart_feature/hair/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return pick(sprite_accessories)

/datum/customizer_choice/bodypart_feature/hair/get_random_color(datum/customizer_entry/entry, datum/preferences/prefs, accessory_type)
	var/datum/species/species = return_species(prefs)
	var/list/hairs
	var/new_color
	if(prefs.age == AGE_OLD)
		hairs = species.get_oldhc_list()
	else
		hairs = species.get_hairc_list()
	new_color = hairs[pick(hairs)]
	return sanitize_hexcolor(new_color, 6, TRUE)

/datum/customizer_choice/bodypart_feature/hair/set_accessory_colors(datum/preferences/prefs, datum/customizer_entry/entry, color)
	var/datum/customizer_entry/hair/hair_entry = entry
	hair_entry.hair_color = color

/datum/customizer_entry/hair/head

/datum/customizer/bodypart_feature/hair/head
	abstract_type = /datum/customizer/bodypart_feature/hair/head
	name = "Hair"

/datum/customizer/bodypart_feature/hair/head/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

/datum/customizer_choice/bodypart_feature/hair/head
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/head
	name = "Hair"
	feature_type = /datum/bodypart_feature/hair/head
	customizer_entry_type = /datum/customizer_entry/hair/head

/datum/customizer_choice/bodypart_feature/hair/head/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/adventurer_human,
		/datum/sprite_accessory/hair/head/alchemist,
		/datum/sprite_accessory/hair/head/bedheadv4,
		/datum/sprite_accessory/hair/head/berserker,
		/datum/sprite_accessory/hair/head/bluntbangs,
		/datum/sprite_accessory/hair/head/bluntbangs_alt,
		/datum/sprite_accessory/hair/head/bog,
		/datum/sprite_accessory/hair/head/boss_dwarf,
		/datum/sprite_accessory/hair/head/bowlcut,
		/datum/sprite_accessory/hair/head/brother,
		/datum/sprite_accessory/hair/head/cavehead,
		/datum/sprite_accessory/hair/head/cornrows,
		/datum/sprite_accessory/hair/head/cornrows2,
		/datum/sprite_accessory/hair/head/cornrowbraid,
		/datum/sprite_accessory/hair/head/cornrowbun,
		/datum/sprite_accessory/hair/head/cornrowtail,
		/datum/sprite_accessory/hair/head/conscript,
		/datum/sprite_accessory/hair/head/courtier,
		/datum/sprite_accessory/hair/head/dark_knight,
		/datum/sprite_accessory/hair/head/dave,
		/datum/sprite_accessory/hair/head/dome,
		/datum/sprite_accessory/hair/head/druid,
		/datum/sprite_accessory/hair/head/dunes,
		/datum/sprite_accessory/hair/head/fancy_elf,
		/datum/sprite_accessory/hair/head/forester,
		/datum/sprite_accessory/hair/head/foreigner_tief,
		/datum/sprite_accessory/hair/head/forsaken_aas,
		/datum/sprite_accessory/hair/head/forged,
		/datum/sprite_accessory/hair/head/graceful,
		/datum/sprite_accessory/hair/head/heroic,
		/datum/sprite_accessory/hair/head/hornet,
		/datum/sprite_accessory/hair/head/hunter,
		/datum/sprite_accessory/hair/head/landlord,
		/datum/sprite_accessory/hair/head/lover_tief,
		/datum/sprite_accessory/hair/head/lion,
		/datum/sprite_accessory/hair/head/monk,
		/datum/sprite_accessory/hair/head/majestic_human,
		/datum/sprite_accessory/hair/head/merc,
		/datum/sprite_accessory/hair/head/miner_dwarf,
		/datum/sprite_accessory/hair/head/nobility_human,
		/datum/sprite_accessory/hair/head/nomadic_humtief,
		/datum/sprite_accessory/hair/head/pirate,
		/datum/sprite_accessory/hair/head/princely,
		/datum/sprite_accessory/hair/head/rogue,
		/datum/sprite_accessory/hair/head/romantic,
		/datum/sprite_accessory/hair/head/sandcrop,
		/datum/sprite_accessory/hair/head/scribe,
		/datum/sprite_accessory/hair/head/southern_human,
		/datum/sprite_accessory/hair/head/son,
		/datum/sprite_accessory/hair/head/son_elf,
		/datum/sprite_accessory/hair/head/squire_human,
		/datum/sprite_accessory/hair/head/swain,
		/datum/sprite_accessory/hair/head/top_aas,
		/datum/sprite_accessory/hair/head/troubadour,
		/datum/sprite_accessory/hair/head/tied,
		/datum/sprite_accessory/hair/head/tied_long,
		/datum/sprite_accessory/hair/head/tied_sidecut,
		/datum/sprite_accessory/hair/head/trimmed,
		/datum/sprite_accessory/hair/head/warrior,
		/datum/sprite_accessory/hair/head/wildside,
		/datum/sprite_accessory/hair/head/woodsman_elf,
		/datum/sprite_accessory/hair/head/zaladin,
		/datum/sprite_accessory/hair/head/vagabond,
		/datum/sprite_accessory/hair/head/steward,
		/datum/sprite_accessory/hair/head/amazon,
		/datum/sprite_accessory/hair/head/archivist,
		/datum/sprite_accessory/hair/head/barbarian,
		/datum/sprite_accessory/hair/head/beartails,
		/datum/sprite_accessory/hair/head/buns,
		/datum/sprite_accessory/hair/head/lowbun,
		/datum/sprite_accessory/hair/head/bob,
		/datum/sprite_accessory/hair/head/curlyshort,
		/datum/sprite_accessory/hair/head/conscriptf,
		/datum/sprite_accessory/hair/head/emma,
		/datum/sprite_accessory/hair/head/empress,
		/datum/sprite_accessory/hair/head/fancy_femelf,
		/datum/sprite_accessory/hair/head/felfhair_fatherless,
		/datum/sprite_accessory/hair/head/grumpy_f,
		/datum/sprite_accessory/hair/head/gnomish_f,
		/datum/sprite_accessory/hair/head/hearth_f,
		/datum/sprite_accessory/hair/head/homely,
		/datum/sprite_accessory/hair/head/junia,
		/datum/sprite_accessory/hair/head/lady,
		/datum/sprite_accessory/hair/head/highbun,
		/datum/sprite_accessory/hair/head/ruffled,
		/datum/sprite_accessory/hair/head/loosebraid,
		/datum/sprite_accessory/hair/head/maiden,
		/datum/sprite_accessory/hair/head/majestic_dwarf_F,
		/datum/sprite_accessory/hair/head/majestic_f,
		/datum/sprite_accessory/hair/head/messy,
		/datum/sprite_accessory/hair/head/mysterious_elf,
		/datum/sprite_accessory/hair/head/mystery,
		/datum/sprite_accessory/hair/head/noblesse,
		/datum/sprite_accessory/hair/head/orc,
		/datum/sprite_accessory/hair/head/performer,
		/datum/sprite_accessory/hair/head/pix,
		/datum/sprite_accessory/hair/head/pigtails,
		/datum/sprite_accessory/hair/head/plain,
		/datum/sprite_accessory/hair/head/ponytail,
		/datum/sprite_accessory/hair/head/ponytail8,
		/datum/sprite_accessory/hair/head/puffdouble,
		/datum/sprite_accessory/hair/head/puffleft,
		/datum/sprite_accessory/hair/head/puffright,
		/datum/sprite_accessory/hair/head/queen,
		/datum/sprite_accessory/hair/head/sideways_ponytail,
		/datum/sprite_accessory/hair/head/shrine,
		/datum/sprite_accessory/hair/head/soilbride,
		/datum/sprite_accessory/hair/head/squire_f,
		/datum/sprite_accessory/hair/head/tails,
		/datum/sprite_accessory/hair/head/tied_pony,
		/datum/sprite_accessory/hair/head/tiedup,
		/datum/sprite_accessory/hair/head/tiedcutf,
		/datum/sprite_accessory/hair/head/tomboy1,
		/datum/sprite_accessory/hair/head/tomboy2,
		/datum/sprite_accessory/hair/head/tomboy3,
		/datum/sprite_accessory/hair/head/twintail_floor,
		/datum/sprite_accessory/hair/head/updo,
		/datum/sprite_accessory/hair/head/wildcutf,
		/datum/sprite_accessory/hair/head/wisp,
		/datum/sprite_accessory/hair/head/singlebraid,
		/datum/sprite_accessory/hair/head/shorthime,
		/datum/sprite_accessory/hair/head/spicy,
		/datum/sprite_accessory/hair/head/stacy,
		/datum/sprite_accessory/hair/head/stacybun,
		/datum/sprite_accessory/hair/head/zoey,
		/datum/sprite_accessory/hair/head/mediumbraid,
		/datum/sprite_accessory/hair/head/martial,
		/datum/sprite_accessory/hair/head/shaved,
		/datum/sprite_accessory/hair/head/runt,
		/datum/sprite_accessory/hair/head/majestic_elf,
		/datum/sprite_accessory/hair/head/gloomy,
		/datum/sprite_accessory/hair/head/gloomylong,
		/datum/sprite_accessory/hair/head/shortmessy,
		/datum/sprite_accessory/hair/head/mediumessy,
		/datum/sprite_accessory/hair/head/inari,
		/datum/sprite_accessory/hair/head/ziegler,
		/datum/sprite_accessory/hair/head/gronnbraid,
		/datum/sprite_accessory/hair/head/grenzelcut,
		/datum/sprite_accessory/hair/head/fluffy,
		/datum/sprite_accessory/hair/head/fluffyshort,
		/datum/sprite_accessory/hair/head/fluffylong,
		/datum/sprite_accessory/hair/head/jay,
		/datum/sprite_accessory/hair/head/hairfre,
		/datum/sprite_accessory/hair/head/dawn,
		/datum/sprite_accessory/hair/head/morning,
		/datum/sprite_accessory/hair/head/kobeni_1,
		/datum/sprite_accessory/hair/head/kobeni_2,
		/datum/sprite_accessory/hair/head/gloomy_short,
		/datum/sprite_accessory/hair/head/gloomy_medium,
		/datum/sprite_accessory/hair/head/gloomy_long,
		/datum/sprite_accessory/hair/head/emo_long,
		/datum/sprite_accessory/hair/head/dreadlocks_long,
		/datum/sprite_accessory/hair/head/rows1,
		/datum/sprite_accessory/hair/head/rows2,
		/datum/sprite_accessory/hair/head/rowbraid,
		/datum/sprite_accessory/hair/head/rowdualtail,
		/datum/sprite_accessory/hair/head/rowbun,
		/datum/sprite_accessory/hair/head/long_over_eye_alt,
		/datum/sprite_accessory/hair/head/sabitsuki,
		/datum/sprite_accessory/hair/head/cotton,
		/datum/sprite_accessory/hair/head/cottonalt,
		/datum/sprite_accessory/hair/head/bushy,
		/datum/sprite_accessory/hair/head/bushy_alt,
		/datum/sprite_accessory/hair/head/curtains,
		/datum/sprite_accessory/hair/head/glamourh,
		/datum/sprite_accessory/hair/head/wavylong,
		/datum/sprite_accessory/hair/head/straightlong,
		/datum/sprite_accessory/hair/head/fluffball,
		/datum/sprite_accessory/hair/head/halfshave_long,
		/datum/sprite_accessory/hair/head/halfshave_long_alt,
		/datum/sprite_accessory/hair/head/halfshave_messy,
		/datum/sprite_accessory/hair/head/halfshave_messylong,
		/datum/sprite_accessory/hair/head/halfshave_messy_alt,
		/datum/sprite_accessory/hair/head/halfshave_messylong_alt,
		/datum/sprite_accessory/hair/head/halfshave_glamorous,
		/datum/sprite_accessory/hair/head/halfshave_glamorous_alt,
		/datum/sprite_accessory/hair/head/thicklong,
		/datum/sprite_accessory/hair/head/thickshort,
		/datum/sprite_accessory/hair/head/thickcurly,
		/datum/sprite_accessory/hair/head/baum,
		/datum/sprite_accessory/hair/head/highlander,
		/datum/sprite_accessory/hair/head/royalcurls,
		/datum/sprite_accessory/hair/head/dreadlocksmessy,
		/datum/sprite_accessory/hair/head/suave,
		/datum/sprite_accessory/hair/head/ponytailwitcher,
		/datum/sprite_accessory/hair/head/countryponytailalt,
		/datum/sprite_accessory/hair/head/kusanagi_alt,
		/datum/sprite_accessory/hair/head/shorthair6,
		/datum/sprite_accessory/hair/head/helmet,
		/datum/sprite_accessory/hair/head/phoenix,
		/datum/sprite_accessory/hair/head/phoenixhalfshaven,
		/datum/sprite_accessory/hair/head/royalcurl,
		/datum/sprite_accessory/hair/head/shorthair4,
		/datum/sprite_accessory/hair/head/slightlymessy,
		/datum/sprite_accessory/hair/head/veryshortovereye,
		/datum/sprite_accessory/hair/head/flatpressed,
		/datum/sprite_accessory/hair/head/beachwave,
		/datum/sprite_accessory/hair/head/fortuneteller,
		/datum/sprite_accessory/hair/head/hyenamane,
		/datum/sprite_accessory/hair/head/kajam,
		/datum/sprite_accessory/hair/head/mermaid,
		/datum/sprite_accessory/hair/head/unkemptcurls,
		/datum/sprite_accessory/hair/head/viper,
		/datum/sprite_accessory/hair/head/shrinepriestess,
		)

/datum/customizer/bodypart_feature/hair/head/humanoid/triton
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/triton)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/triton
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/triton/fin,
		/datum/sprite_accessory/hair/head/triton/seaking,
		/datum/sprite_accessory/hair/head/triton/siren,
		/datum/sprite_accessory/hair/head/triton/jellyfish,
		/datum/sprite_accessory/hair/head/triton/anemonger,
		/datum/sprite_accessory/hair/head/triton/punkfish,
		/datum/sprite_accessory/hair/head/triton/weed,
		/datum/sprite_accessory/hair/head/triton/gorgon,
		/datum/sprite_accessory/hair/head/triton/lion,
		/datum/sprite_accessory/hair/head/triton/betta,
	)

/datum/customizer/bodypart_feature/hair/head/humanoid/medicator
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/medicator)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/medicator
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/medicator/windswept,
		/datum/sprite_accessory/hair/head/medicator/curl,
		/datum/sprite_accessory/hair/head/medicator/spencer,
		/datum/sprite_accessory/hair/head/medicator/dynamic,
		/datum/sprite_accessory/hair/head/medicator/jockey,
		/datum/sprite_accessory/hair/head/medicator/hook,
		/datum/sprite_accessory/hair/head/medicator/crown,
	)

/datum/customizer/bodypart_feature/hair/head/humanoid/rakshari
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/rakshari)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/rakshari
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/rakshari/high_tail,
		/datum/sprite_accessory/hair/head/rakshari/doubleknot,
		/datum/sprite_accessory/hair/head/rakshari/fluffy_tail,
	)

// ===== FACIAL HAIR

/datum/customizer_entry/hair/facial

/datum/customizer/bodypart_feature/hair/facial
	abstract_type = /datum/customizer/bodypart_feature/hair/facial
	name = "Facial Hair"

/datum/customizer/bodypart_feature/hair/facial/is_allowed(datum/preferences/prefs)
	var/datum/species/species = return_species(prefs)
	if(prefs.age == AGE_CHILD && !(YOUNGBEARD in species.species_traits))
		return FALSE
	return (prefs.gender == MALE) || istype(species, /datum/species/dwarf) || istype(species, /datum/species/triton)

/datum/customizer/bodypart_feature/hair/facial/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

/datum/customizer_choice/bodypart_feature/hair/facial
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_type = /datum/bodypart_feature/hair/facial
	customizer_entry_type = /datum/customizer_entry/hair/facial

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/none,
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/brew,
		/datum/sprite_accessory/hair/facial/chops,
		/datum/sprite_accessory/hair/facial/chin,
		/datum/sprite_accessory/hair/facial/braided,
		/datum/sprite_accessory/hair/facial/manly,
		/datum/sprite_accessory/hair/facial/fullbeard,
		/datum/sprite_accessory/hair/facial/cousin,
		/datum/sprite_accessory/hair/facial/knightly,
		/datum/sprite_accessory/hair/facial/know,
		/datum/sprite_accessory/hair/facial/fiveoclockm,
		/datum/sprite_accessory/hair/facial/pick,
		/datum/sprite_accessory/hair/facial/pipe,
		/datum/sprite_accessory/hair/facial/viking,
		/datum/sprite_accessory/hair/facial/ranger,
		/datum/sprite_accessory/hair/facial/vandyke,
		/datum/sprite_accessory/hair/facial/burns,
		/datum/sprite_accessory/hair/facial/hermit,
	)

/datum/customizer/bodypart_feature/hair/facial/humanoid/rakshari
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/rakshari)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/rakshari
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/none,
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/rakshari/kesh,
		/datum/sprite_accessory/hair/facial/rakshari/spry,
		/datum/sprite_accessory/hair/facial/rakshari/whiskered,
		/datum/sprite_accessory/hair/facial/rakshari/jinni,
	)

/datum/customizer/bodypart_feature/hair/facial/humanoid/triton
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/triton)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/triton
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/triton/seaqueen,
		/datum/sprite_accessory/hair/facial/triton/catfish,
	)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/species/species = return_species(prefs)

	if((prefs.gender == MALE) || istype(species, /datum/species/dwarf))
		return pick(sprite_accessories)
	else
		return /datum/sprite_accessory/hair/facial/shaved
