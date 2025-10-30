/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)

/datum/asset/simple/changelog
	assets = list(
		"changelog.css" = 'html/changelog.css'
	)

/datum/asset/simple/namespaced/common
	assets = list("padlock.png"	= 'html/padlock.png')
	parents = list("common.css" = 'html/browser/common.css')

/datum/asset/simple/stonekeep_class_menu_slop_layout
	assets = list(
		"try4.png" = 'icons/roguetown/misc/try4.png',
		"try4_border.png" = 'icons/roguetown/misc/try4_border.png',
		"slop_menustyle2.css" = 'html/browser/slop_menustyle2.css',
		"gragstar.gif" = 'icons/roguetown/misc/gragstar.gif'
	)

/datum/asset/simple/stonekeep_triumph_buy_menu_slop_layout
	assets = list(
		"try5.png" = 'icons/roguetown/misc/try5.png',
		"try5_border.png" = 'icons/roguetown/misc/try5_border.png',
		"slop_menustyle3.css" = 'html/browser/slop_menustyle3.css'
	)

/datum/asset/simple/stonekeep_drifter_queue_menu_slop_layout
	assets = list(
		"slop_menustyle4.css" = 'html/browser/slop_menustyle4.css',
	)

/datum/asset/simple/namespaced/roguefonts
	legacy = TRUE
	assets = list(
		"PixelifySans-VariableFont_wght.ttf" = 'interface/fonts/PixelifySans-VariableFont_wght.ttf',
		"pterra.ttf" = 'interface/fonts/pterra.ttf',
		"pterra.ttf" = 'interface/fonts/pterra.ttf',
		"chiseld.ttf" = 'interface/fonts/chiseld.ttf',
		"blackmoor.ttf" = 'interface/fonts/blackmoor.ttf',
		"handwrite.ttf" = 'interface/fonts/handwrite.ttf',
		"book1.ttf" = 'interface/fonts/book1.ttf',
		"book2.ttf" = 'interface/fonts/book1.ttf',
		"book3.ttf" = 'interface/fonts/book1.ttf',
		"book4.ttf" = 'interface/fonts/book1.ttf',
		"dwarf.ttf" = 'interface/fonts/languages/dwarf.ttf',
		"elf.ttf" = 'interface/fonts/languages/elf.ttf',
		"oldpsydonic.ttf" = 'interface/fonts/languages/oldpsydonic.ttf',
		"zalad.ttf" = 'interface/fonts/languages/zalad.ttf',
		"hell.ttf" = 'interface/fonts/languages/hell.ttf',
		"orc.ttf" = 'interface/fonts/languages/orc.ttf',
		"sand.ttf" = 'interface/fonts/languages/sand.ttf',
		"undead.ttf" = 'interface/fonts/languages/undead.ttf',
		"Vaticanus.ttf" = 'interface/fonts/Vaticanus.ttf',
		"otavan.ttf" = 'interface/fonts/languages/otavan.ttf'
	)

//this exists purely to avoid meta by pre-loading all language icons.
/datum/asset/language/register()
	for(var/path in typesof(/datum/language))
		set waitfor = FALSE
		var/datum/language/L = new path()
		L.get_icon()

/datum/asset/spritesheet_batched/achievements
	name = "achievements"

/datum/asset/spritesheet_batched/achievements/create_spritesheets()
	// Needs this proc and can't be empty and not removing entirely
	insert_icon("blank", uni_icon('icons/hud/storage.dmi', "blank"))

/datum/asset/simple/permissions
	assets = list(
		"search.js" = 'html/admin/search.js',
		"panels.css" = 'html/admin/panels.css'
	)

/datum/asset/group/permissions
	children = list(
		/datum/asset/simple/permissions,
		/datum/asset/simple/namespaced/common
	)

/datum/asset/simple/notes

/datum/asset/spritesheet_batched/goonchat
	name = "chat"

/datum/asset/spritesheet_batched/goonchat/create_spritesheets()
	// pre-loading all lanugage icons also helps to avoid meta
	insert_all_icons("language", 'icons/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/language))
		var/datum/language/L = path
		var/icon = initial(L.icon)
		if(icon != 'icons/language.dmi')
			var/icon_state = initial(L.icon_state)
			insert_icon("language-[icon_state]", uni_icon(icon, icon_state))

/datum/asset/group/tgui

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/purify,
		/datum/asset/simple/namespaced/goonchat,
		/datum/asset/spritesheet_batched/goonchat,
		/datum/asset/simple/namespaced/fontawesome,
		/datum/asset/simple/namespaced/roguefonts
	)

/datum/asset/simple/purify
	legacy = TRUE
	assets = list(
		"purify.min.js" = 'code/modules/goonchat/browserassets/js/purify.min.js',
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'code/modules/goonchat/browserassets/js/jquery.min.js',
	)

/datum/asset/simple/namespaced/goonchat
	legacy = TRUE
	assets = list(
		"json2.min.js" = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"errorHandler.js" = 'code/modules/goonchat/browserassets/js/errorHandler.js',
		"browserOutput.js" = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"browserOutput.css" = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css" = 'code/modules/goonchat/browserassets/css/browserOutput.css',
	)
	parents = list()

/datum/asset/simple/namespaced/fontawesome
	legacy = TRUE
	assets = list(
		"fa-regular-400.eot" = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot" = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff" = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"font-awesome.css" = 'html/font-awesome/css/all.min.css',
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')
