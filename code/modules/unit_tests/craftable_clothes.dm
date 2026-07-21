/*
this unit test makes sure every piece of clothing is craftable
abstract types are automatically excluded.

*/
/datum/unit_test/craftable_clothes
	/// explicitly excluded paths with this path only
	var/list/excluded_paths = list(
		/obj/item/clothing/neck/blkknight, // mapped in only
		/obj/item/clothing/accessory/medal/gold/ordom, // memorial item, RIP OrdoM.
		/obj/item/clothing/neck/portalamulet, // vampire antag item
		/obj/item/clothing/head/peaceflower, // spawns naturally
		/obj/item/clothing/head/corruptflower, // spawns naturally
		/obj/item/clothing/face/facemask/steel/harlequin, // antag only
		/obj/item/clothing/shirt/robe/necromancer, // antag
		/obj/item/clothing/shirt/robe/priest, // unattainable
		/obj/item/clothing/head/padded/deathface, // ???
		/obj/item/clothing/head/roguehood/priest, // unattainable
		/obj/item/clothing/face/facemask/prisoner,
		/obj/item/clothing/head/priestmask, // unattainable
		/obj/item/clothing/head/leather/inqhat/vigilante, //Renegade Bullshit
		/obj/item/clothing/face/phys/plaguebearer, //Plague Only
		/obj/item/clothing/ring/feldsher_ring, // uncraftable
		/obj/item/clothing/ring/apothecary_ring, // uncraftable
		/obj/item/clothing/ring/courtagent_ring, //uncraftable
		/obj/item/clothing/head/maniac,
		/obj/item/clothing/cloak/half/shadowcloak/cult, // cultist item
		/obj/item/clothing/head/helmet/skullcap/cult, // cultist item
		/obj/item/clothing/head/helmet/leather/saiga, // idk what kind of recipe to make this
		/obj/item/clothing/neck/mana_star, // todo?
		/obj/item/clothing/neck/gorget/explosive, // Inq shop only
		/obj/item/storage/backpack/backpack/artibackpack/porter, //Unique to Kobl
		/obj/item/clothing/face/spectacles/inq/spawnpair, //spawn type
		/obj/item/clothing/face/facemask/steel/confessor/lensed, //manual craft
		/obj/item/clothing/head/helmet/heavy/ordinatorhelm/plume, //manual craft
		/obj/item/clothing/wall_grab, ///abstract
		/obj/item/clothing/climbing_gear, ///weird
		/obj/item/clothing/wrists/bracers/psythorns, //inqport
		/obj/item/clothing/cloak/psydontabard, ///they'd kill you for this
		/obj/item/clothing/cloak/psydontabard/alt, ///same here
		/obj/item/clothing/face/spectacles/inq, //these are powerful
		/obj/item/clothing/head/helmet/heavy/psydonbarbute, //buyable
		/obj/item/clothing/head/helmet/heavy/psysallet, //buyable
		/obj/item/clothing/head/helmet/heavy/psybucket, //buyable
		/obj/item/clothing/head/helmet/heavy/psydonhelm, //buyable
		/obj/item/clothing/head/helmet/heavy/ordinatorhelm, ///special item //! probably can add this at some point
		/obj/item/clothing/head/roguehood/psydon/confessor, ///inqport
		/obj/item/clothing/face/facemask/steel/confessor, ///inqport
		/obj/item/clothing/gloves/bandages/pugilist,
		/obj/item/clothing/armor/gambeson/heavy/otavan/inq, ///inqport
		/obj/item/clothing/armor/gambeson/heavy/otavan, ///null
		/obj/item/clothing/armor/gambeson/heavy/inq, //inqport
		/obj/item/clothing/armor/leather/studded,
		/obj/item/clothing/armor/leather/jacket/leathercoat/confessor, //inqport
		/obj/item/clothing/head/roguehood/psydon,
		/obj/item/clothing/neck/fencerguard/inq, ///inqport
		/obj/item/clothing/neck/fencerguard, //null
		/obj/item/clothing/armor/cuirass/fencer, //meh
		/obj/item/clothing/armor/medium/scale/inqcoat/armored, //upgrade
		/obj/item/clothing/armor/brigandine/light, //basetype,
		/obj/item/clothing/armor/plate/fluted/ornate, //basetype
		/obj/item/clothing/armor/plate/fluted/ornate/ordinator, //inqport
		/obj/item/clothing/armor/plate/fluted,
		/obj/item/clothing/cloak/templar, //base type
		/obj/item/clothing/face/antiq, //implied to be a weird heartfelt technoitem. good luck replicating this. unique to antiquarian
		/obj/item/clothing/wrists/bracers/naledi, //Inqstuff
		/obj/item/clothing/head/menacing/mad_touched_treasure_hunter, //cursed
		/obj/item/clothing/face/facemask/steel/mad_touched, //cursed
		/obj/item/clothing/cloak/poncho/yellow,//No free colouring
		/obj/item/clothing/cloak/ordinatorcape/lirvas,
		/obj/item/clothing/cloak/minotaur,
		/obj/item/clothing/cloak/psydontabard/black,
		/obj/item/clothing/cloak/psydontabard/black/alt,
		/obj/item/clothing/shoes/boots/armor/gold/king,
		/obj/item/clothing/armor/cuirass/fluted/gold/king,
		/obj/item/clothing/head/helmet/visored/gold/king,
		/obj/item/clothing/neck/gorget/gold/king,
		/obj/item/clothing/head/helmet/visored/gold/king,
		/obj/item/clothing/shirt/robe/hag,
		/obj/item/clothing/armor/leather/splint/pyromaniac,
		/obj/item/clothing/head/roguehood/colored/red/pyromaniac,
		/obj/item/clothing/face/pyromaniac,
		/obj/item/clothing/pants/trou/leather/pyromaniac,
		/obj/item/clothing/armor/gambeson/heavy/pyromaniac,
		/obj/item/clothing/gloves/leather/pyromaniac,
		/obj/item/clothing/head/helmet/heavy/necked/cadwyn,
		/obj/item/clothing/cloak/cadwyn,

		/obj/item/clothing/head/helmet/heavy/dwarven,
		/obj/item/clothing/head/helmet/heavy/dwarven/smith,
		/obj/item/clothing/shoes/boots/armor/dwarven,
		/obj/item/clothing/gloves/plate/dwarven,
		/obj/item/clothing/armor/plate/full/dwarven,
		/obj/item/clothing/armor/plate/full/dwarven/smith,

		//stat rings
		/obj/item/clothing/ring/statgemerald,
		/obj/item/clothing/ring/statonyx,
		/obj/item/clothing/ring/statamythortz,
		/obj/item/clothing/ring/statrontz,
		/obj/item/clothing/ring/statdorpel,

		/obj/item/clothing/armor/heartfelt,
		/obj/item/clothing/armor/heartfelt/hand,

		/obj/item/clothing/wrists/bracers/iron/concealed, // watchmen drip special

		///these can probably have recipes?
		/obj/item/clothing/face/xylixmask,
		/obj/item/clothing/face/xylixmask/weathered,
		/obj/item/clothing/ring/duelist,
		/obj/item/clothing/cloak/stabard/templar/justice,
		/obj/item/clothing/cloak/cape/inquisitorgold,
		/obj/item/clothing/cloak/cape/inquisitorsilver,
		/obj/item/clothing/cloak/sleevedtabard,
		/obj/item/clothing/cloak/absolutionistrobe/black,
		/obj/item/clothing/gloves/angle/freifechter,
		/obj/item/clothing/head/dancer_headdress,
		/obj/item/clothing/face/faceveil,

		//we have no way to get aalloy yet
		/obj/item/clothing/head/helmet/heavy/aalloy,
		/obj/item/clothing/head/helmet/kettle/aalloy,
		/obj/item/clothing/head/helmet/visored/knight/aalloy,
		/obj/item/clothing/armor/chainmail/hauberk/aalloy,
		/obj/item/clothing/ring/band/aalloy,

		//funny clothes no recipe
		/obj/item/clothing/gloves/plate/iron/banded,
		/obj/item/clothing/head/helmet/sallet/beastskull,
		/obj/item/clothing/head/helmet/sallet/iron/banded,
		/obj/item/clothing/armor/plate/iron/banded,
		/obj/item/clothing/gloves/plate/iron/banded,

		///all blackmeadow are pending blackmeadow features
		/obj/item/clothing/cloak/kazengun,
		/obj/item/clothing/neck/gorget/kazengun,
		/obj/item/clothing/shoes/boots/leather/kazengun,
		/obj/item/clothing/pants/trou/leather/kazengun,
		/obj/item/clothing/face/facemask/steel/kazengun,
		/obj/item/clothing/face/facemask/steel/kazengun/full,
		/obj/item/clothing/head/helmet/heavy/kabuto,
		/obj/item/clothing/armor/plate/full/samsibsa,
		/obj/item/clothing/gloves/plate/kote,
		/obj/item/clothing/head/helmet/kettle/jingasa,
		/obj/item/clothing/armor/brigandine/haraate,

		/obj/item/clothing/wrists/bracers/naledi, //Inqstuff
		/obj/item/clothing/pants/trou/leather/pontifex,
		/obj/item/clothing/head/peel_pin, //Giveaway only
	)
	// these don't use misc_flags = CRAFTING_TEST_EXCLUDE because we want to explicitly know which paths we are excluding.
	/// excludes paths along with their subtypes
	var/list/excluded_paths_with_their_subtypes = list(
		/obj/item/clothing/neck/mercmedal, // only earnable via hermes
		/obj/item/clothing/neck/shalal, // this is a medal
		/obj/item/clothing/neck/psycross/silver/divine/eora/potion, // unimplemented
		/obj/item/clothing/armor/skin_armor, // bruh
		/obj/item/clothing/head/hooded, // abstract items connected to a cloak, shouldn't be craftable
		/obj/item/clothing/accessory, // ???
		/obj/item/clothing/head/crown/serpcrown, // should only be one
		/obj/item/clothing/face/cigarette, // TODO
		/obj/item/clothing/head/takuhatsugasa,
		/obj/item/clothing/shirt/robe/kimono, //these are mob holders only
		/obj/item/clothing/armor/regenerating, ///uh no
		/obj/item/clothing/head/inqarticles, //inqports
	)

	/// excludes paths that are subtypes of these types and only subtypes
	var/list/excluded_paths_subtypes_only = list(

	)

	/// if the path of the item contains this keyword, it will be excluded
	var/list/excluded_paths_by_text = list(
		"faceless", // antag items
		"blk", // antag items
		"vampire", // vampire craftable items
		"maniac", // fluff maniac items
		"rust",
		"rousman",
		"orc",
		"goblin",
		"rare",
		"captain",
		"baotha",
		"matthios",
		"zizo",
		"graggar",
		"steam",
		"royalknight",
		"warden",
		"sinistar",
		"gronn", //pending further lore review.
	)

/datum/unit_test/craftable_clothes/Run()
	/// list of all supply packs
	var/list/datum/supply_pack/supply_pack_list = subtypesof(/datum/supply_pack)
	/// list of all clothes paths, which we will remove paths that have a recipe or a supply_pack entry from.
	var/list/obj/clothes_list = subtypesof(/obj/item/clothing) - excluded_paths

	/* exclusions removed */

	// abstract typepaths and CRAFTING_TEST_EXCLUDE
	for(var/obj/item/clothing/path as anything in clothes_list)
		if(IS_ABSTRACT(path) || (path::misc_flags & CRAFTING_TEST_EXCLUDE))
			clothes_list -= path

	// paths by text, if a piece of this text is found in the typepath it's excluded
	for(var/path as anything in clothes_list)
		for(var/text_to_find as anything in excluded_paths_by_text)
			if(findtextEx("[path]", "/[text_to_find]"))
				clothes_list -= path
				break

	// paths with subtypes
	for(var/paths_to_exclude as anything in excluded_paths_with_their_subtypes)
		for(var/path in clothes_list)
			if(ispath(path, paths_to_exclude))
				clothes_list -= path

	// paths by subtypes only
	for(var/paths_to_exclude as anything in excluded_paths_subtypes_only)
		for(var/path in clothes_list)
			if(ispath(path, paths_to_exclude) && (paths_to_exclude != path))
				clothes_list -= path

	/* misc checks go next */

	// check loot tables
	for(var/datum/loot_table/loot_datum as anything in subtypesof(/datum/loot_table))
		var/datum/loot_table/loot_table_to_check = new loot_datum
		for(var/list/parent_list as anything in loot_table_to_check.loot_table)
			for(var/loot_path as anything in parent_list)
				clothes_list -= loot_path
		qdel(loot_table_to_check)

	// supply pack clothes
	for(var/datum/supply_pack/supply_pack_being_checked as anything in supply_pack_list)
		var/list/supply_pack_contents = list()
		supply_pack_contents += supply_pack_being_checked.contains // some contains definitions are not lists
		for(var/path_in_contents as anything in supply_pack_contents)
			clothes_list -= path_in_contents

	/* crafting recipes go next */

	// repeatables
	for(var/datum/repeatable_crafting_recipe/recipe as anything in subtypesof(/datum/repeatable_crafting_recipe))
		clothes_list -= initial(recipe.output)

	// orderless slapcraft
	for(var/datum/orderless_slapcraft/recipe as anything in subtypesof(/datum/orderless_slapcraft))
		clothes_list -= initial(recipe.output_item)

	// anvil recipes
	for(var/datum/anvil_recipe/recipe as anything in subtypesof(/datum/anvil_recipe))
		clothes_list -= initial(recipe.created_item)

	// artificer recipes
	for(var/datum/artificer_recipe/recipe as anything in subtypesof(/datum/artificer_recipe))
		clothes_list -= initial(recipe.created_item)

	// artificer recipes
	for(var/datum/arcyne_crafting_recipe/recipe as anything in subtypesof(/datum/arcyne_crafting_recipe))
		clothes_list -= initial(recipe.output)

	if(!clothes_list.len)
		return

	TEST_FAIL("The following clothing subtypes do not have a crafting recipe: [clothes_list.Join(", ")]")
