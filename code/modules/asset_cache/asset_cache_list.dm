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
		"PixelifySans.ttf" = 'interface/fonts/PixelifySans.ttf',
		"pterra.ttf" = 'interface/fonts/pterra.ttf',
		"blackmoor.ttf" = 'interface/fonts/blackmoor.ttf',
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
		"celestial.ttf" = 'interface/fonts/languages/celestial.ttf',
		"undead.ttf" = 'interface/fonts/languages/undead.ttf',
		"Vaticanus.ttf" = 'interface/fonts/Vaticanus.ttf',
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

/datum/asset/spritesheet_batched/chat
	name = "chat"

/datum/asset/spritesheet_batched/chat/create_spritesheets()
	// pre-loading all lanugage icons also helps to avoid meta
	insert_all_icons("language", 'icons/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/datum/language/L as anything in typesof(/datum/language))
		var/icon = initial(L.icon)
		if(icon != 'icons/language.dmi')
			var/icon_state = initial(L.icon_state)
			insert_icon("language-[icon_state]", uni_icon(icon, icon_state))

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/purify,
		/datum/asset/simple/namespaced/goonchat,
		/datum/asset/spritesheet_batched/chat,
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

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.woff2" = 'html/font-awesome/webfonts/fa-regular-400.woff2',
		"fa-solid-900.woff2" = 'html/font-awesome/webfonts/fa-solid-900.woff2',
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')

/// Maps icon names to ref values
/datum/asset/json/icon_ref_map
	name = "icon_ref_map"
	early = TRUE

/datum/asset/json/icon_ref_map/generate()
	var/list/data = list() //"icons/obj/drinks.dmi" => "[0xc000020]"

	//var/start = "0xc000000"
	var/value = 0

	while(TRUE)
		value += 1
		var/ref = "\[0xc[num2text(value,6,16)]\]"
		var/mystery_meat = locate(ref)

		if(isicon(mystery_meat))
			if(!isfile(mystery_meat)) // Ignore the runtime icons for now
				continue
			var/path = get_icon_dmi_path(mystery_meat) //Try to get the icon path
			if(path)
				data[path] = ref
		else if(mystery_meat)
			continue //Some other non-icon resource, ogg/json/whatever
		else //Out of resources end this, could also try to end this earlier as soon as runtime generated icons appear but eh
			break

	return data

// If you use a file(...) object, instead of caching the asset it will be loaded from disk every time it's requested.
// This is useful for development, but not recommended for production.
// And if TGS is defined, we're being run in a production environment.

#ifdef TGS
/datum/asset/simple/tgui
	keep_local_name = FALSE
	assets = list(
		"tgui.bundle.js" = "tgui/public/tgui.bundle.js",
		"tgui.bundle.css" = "tgui/public/tgui.bundle.css",
	)

/datum/asset/simple/tgui_panel
	keep_local_name = FALSE
	assets = list(
		"tgui-panel.bundle.js" = "tgui/public/tgui-panel.bundle.js",
		"tgui-panel.bundle.css" = "tgui/public/tgui-panel.bundle.css",
	)

#else
/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)
#endif

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/static/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/static/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/static/tgfont.css"),
	)
