GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_EMPTY(chosen_names)

GLOBAL_LIST_INIT(name_adjustments, list())

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 20

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	/// color of the players text in OOC messages
	var/ooccolor = null
	/// color of admin's asay messages
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.
	/// pronouns that will be shown when hovering over the users name in OOC messages
	var/oocpronouns = ""
	/// the ghost icon this admin ghost will get when becoming an aghost.
	var/admin_ghost_icon = null
	var/ui_theme = UI_PREFERENCE_LIGHT_MODE
	var/triumphs = 0
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/buttons_locked = TRUE
	var/hotkeys = TRUE

	var/showrolls = TRUE
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	var/see_chat_non_mob = TRUE

	// Custom Keybindings
	var/list/key_bindings = list()

	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/windowflashing = TRUE
	var/db_flags
	var/toggles = TOGGLES_DEFAULT
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/toggles_maptext = NONE
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null

	var/uses_glasses_colour = 0

	//character preferences
	/// Keeps track of round-to-round randomization of the character slot, prevents overwriting.
	var/slot_randomized

	/// The character's real name.
	var/real_name

	/// Gender of character (used for masculine or feminine model selection).
	var/gender = MALE

	/// Character's pronouns.
	var/pronouns = HE_HIM

	/// The type of voice soundpack the mob should use.
	var/voice_type = VOICE_TYPE_MASC

	/// Age of character.
	var/age = AGE_ADULT

	/// Character's origin.
	var/origin = "Default"

	/// Underwear type.
	var/underwear = "Nude"

	/// Underwear color.
	var/underwear_color = null

	/// Undershirt type.
	var/undershirt = "Nude"

	/// Accessory type.
	var/accessory = "Nothing"

	/// Detail type.
	var/detail = "Nothing"

	/// Socks type.
	var/socks = "Nude"

	/// Skin color.
	var/skin_tone = "caucasian1"

	/// Eye color.
	var/eye_color = "000"

	/// Voice color.
	var/voice_color = "a0a0a0"

	/// Detail color.
	var/detail_color = "000"

	/// link to a page containing your headshot image
	var/headshot_link

	/// link to a page containing your ooc extra image
	var/ooc_extra_link
	var/ooc_extra

	/// text of your flavor
	var/flavortext
	var/flavortext_display

	var/ooc_notes
	var/ooc_notes_display

	/// The species this character is.
	var/datum/species/pref_species = new /datum/species/human/northern() //Mutant race
	/// The patron/god/diety this character worships
	var/datum/patron/selected_patron
	/// The default patron to use if none is selected
	var/static/datum/patron/default_patron = /datum/patron/divine/astrata
	var/list/features = MANDATORY_FEATURE_LIST
	var/list/randomise = list(
		(RANDOM_BODY) = FALSE,
		(RANDOM_BODY_ANTAG) = FALSE,
		(RANDOM_UNDERWEAR) = FALSE,
		(RANDOM_UNDERWEAR_COLOR) = FALSE,
		(RANDOM_UNDERSHIRT) = FALSE,
		(RANDOM_SKIN_TONE) = FALSE,
		(RANDOM_EYE_COLOR) = FALSE
	)

	var/phobia = "spiders"

	var/list/custom_names = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = RETURNTOLOBBY  //defaults to 1 for fewer assistants

	/// 0 = character settings, 1 = game preferences
	var/current_tab = 0

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 100//0 is sync

	var/parallax

	var/ambientocclusion = TRUE
	///Should we automatically fit the viewport?
	var/auto_fit_viewport = FALSE
	///Should we be in the widescreen mode set by the config?
	var/widescreenpref = TRUE
	///What size should pixels be displayed as? 0 is strech to fit
	var/pixel_size = 0
	///What scaling method should we use?
	var/scaling_method = "normal"

	var/musicvol = 50
	var/mastervol = 50

	var/anonymize = TRUE

	var/lastclass

	var/list/exp = list()
	var/list/menuoptions

	var/datum/migrant_pref/migrant
	var/next_special_trait = null

	var/action_buttons_screen_locs = list()

	var/domhand = 2
	var/alignment = ALIGNMENT_TN
	var/list/quirks = list()
	var/list/quirk_customizations = list() // Maps quirk_type -> customization_value

	/// Family system
	var/family = FAMILY_NONE
	var/setspouse = ""
	var/gender_choice = ANY_GENDER

	var/crt = FALSE

	var/list/customizer_entries = list()
	var/list/list/body_markings = list()
	var/update_mutant_colors = TRUE

	var/list/descriptor_entries = list()
	var/list/custom_descriptors = list()

	var/datum/loadout_item/loadout1
	var/datum/loadout_item/loadout2
	var/datum/loadout_item/loadout3

	var/list/preference_message_list = list()

	/// Tracker to whether the person has ever spawned into the round, for purposes of applying the respawn ban
	var/has_spawned = FALSE
	///our selected accent
	var/selected_accent = ACCENT_DEFAULT
	/// If our owner is patreon or twitch sub
	var/donator = FALSE
	/// If our owner is from a race that has more than one accent
	var/change_accent = FALSE

	/// Custom UI scale
	var/ui_scale
	/// Assoc list of culinary preferences, where the key is the type of the culinary preference, and value is food/drink typepath
	var/list/culinary_preferences = list()

	/// Whether multi-character readying is enabled
	var/multi_char_ready = FALSE
	/// List of character slot indices selected for multi-ready (in priority order)
	var/list/multi_ready_slots = list()

	var/datum/multi_ready_ui/multi_ready_panel

	var/char_theme = "grimshart"
	var/static/list/char_themes = list(
		"dusty",
		"grimshart",
		"paper",
		"parchment",
	)

	// I beg for datumised prefs
	/// culture datum type
	var/datum/culture/culture = /datum/culture/universal/ambiguous

/datum/preferences/New(client/C)
	parent = C

	migrant  = new /datum/migrant_pref(src)

	flavortext = null
	headshot_link = null

	// C/parent can be a client_interface
	if(isclient(parent))
		donator = parent.is_donator()

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]

	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots += 5
		if(donator)
			max_save_slots += 30
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			if(check_nameban(C.ckey))
				real_name = pref_species.random_name(gender,1)
			return
	//we couldn't load character data so just randomize the character appearance + name
	randomise_appearance_prefs(include_donator = donator)		//let's create a random character then - rather than a fat, bald and naked man.
	if(!selected_patron)
		selected_patron = GLOB.patron_list[default_patron]
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	if(isclient(C))
		C.update_movement_keys()
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()

/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()

#define APPEARANCE_CATEGORY_COLUMN "<td valign='top' width='14%'>"
#define MAX_MUTANT_ROWS 4

/datum/preferences/proc/show_choices(mob/user, tabchoice)
	if(!user || !user.client)
		return
	if(slot_randomized)
		load_character(default_slot)
		slot_randomized = FALSE

	send_character_ui_resources(user)
	build_and_show_menu(user)

/datum/preferences/proc/build_and_show_menu(mob/user)
	var/list/dat = list()
	var/datum/faith/selected_faith = GLOB.faith_list[selected_patron.associated_faith]
	var/datum/job/high_job
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		high_job = job_type
		break

	user?.client.acquire_dpi()

	dat += {"
<html lang="en">
<head>
	<style>
		body {
			background-color: #1a1a1a;
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100vh;
			margin: 0;
			image-rendering: pixelated;
		}
		.ui-container {
			position: relative;
			width: 272px;
			height: 315px;
			background-image: url('Charsheet_BG.1.png');
			background-size: cover;
			transform: scale(3);
			zoom: [100 / user.client?.window_scaling]%;
		}
		.sprite { position: absolute; background-repeat: no-repeat; cursor: pointer; }

		.header-bg   { top: 5px;   left: 6px;   width: 260px; height: 52px; background-image: url('0_header_bg.png'); }
		.preview-bg  { top: 50px;  left: 8px;   width: 99px;  height: 83px; background-image: url('charpreview_bg.png'); }
		.body-bg     { top: 58px;  left: 110px; width: 118px; height: 75px; background-image: url('0_body_bg.png'); }
		.voice-bg    { top: 137px; left: 2px;   width: 107px; height: 41px; background-image: url('0_voice_bg.png'); }
		.family-bg   { top: 137px; left: 114px; width: 86px;  height: 74px; background-image: url('0_family_bg.png'); }
		.flavour-bg  { top: 137px; left: 201px; width: 65px;  height: 95px; background-image: url('0_flavour_bg.png'); }
		.loadout-bg  { top: 181px; left: 3px;   width: 64px;  height: 74px; background-image: url('0_loadout_bg.png'); }
		.triumphs-bg { top: 182px; left: 74px;  width: 37px;  height: 34px; background-image: url('0_triumphs_bg.png'); }
		.headshot-bg { top: 213px; left: 119px; width: 76px;  height: 76px; background-image: url('headshot_bg.png'); }
		.ooc-bg      { top: 236px; left: 201px; width: 54px;  height: 48px; background-image: url('0_ooc_bg.png'); }

		.features-bg { top: 60px; left: 231px; width: 36px; height: 48px; background-image: url('0_features_bg.png'); }
		#silhouette  { top: 3px;  left: 10px;  width: 15px; height: 28px; background-image: url('features_bodytype_f.png'); }
		.f-btn       { top: 95px; left: 232px; width: 34px; height: 10px; background-image: url('features_button.png'); z-index: 3; }
		.f-btn:hover { background-image: url('features_button_hover.png'); }
		.f-random    { top: 110px; left: 232px; width: 34px; height: 25px; background-image: url('features_random.png'); }
		.f-random:hover { background-image: url('features_random_hover.png'); }

		.flav-desc { top: 174px; left: 207px; width: 49px; height: 10px; background-image: url('flavour_descriptors.png'); }
		.flav-desc:hover { background-image: url('flavour_descriptors_hover.png'); }
		.flav-text { top: 192px; left: 207px; width: 53px; height: 10px; background-image: url('flavour_text.png'); }
		.flav-text:hover { background-image: url('flavour_text_hover.png'); }
		.flav-food { top: 210px; left: 207px; width: 45px; height: 10px; background-image: url('flavour_foodprefs.png'); }
		.flav-food:hover { background-image: url('flavour_foodprefs_hover.png'); }
		.flav-prev { top: 226px; left: 215px; width: 34px; height: 10px; background-image: url('flavour_preview.png'); }
		.flav-prev:hover { background-image: url('flavour_preview_hover.png'); }

		.ooc-notes { top: 252px; left: 207px; width: 41px; height: 10px; background-image: url('ooc_notes.png'); }
		.ooc-notes:hover { background-image: url('ooc_notes_hover.png'); }
		.ooc-extra { top: 270px; left: 207px; width: 40px; height: 10px; background-image: url('ooc_extra.png'); }
		.ooc-extra:hover { background-image: url('ooc_extra_hover.png'); }
		.btn-roles { top: 284px; left: 200px; width: 55px; height: 30px; background-image: url('ooc_specialroles.png'); }
		.btn-roles:hover { background-image: url('ooc_specialroles_hover.png'); }

		.tri-shop { top: 202px; left: 75px; width: 34px; height: 26px; background-image: url('triumphs_shop.png'); }
		.tri-shop:hover { background-image: url('triumphs_shop_hover.png'); }

		.clickable-text {
			font-weight: bold;
			position: absolute;
			background: transparent;
			border: none;
			outline: none;
			font-size: 8px;
			color: #161418;
			text-align: left;
			cursor: pointer;
			display: flex;
			align-items: center;
			justify-content: flex-start;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			padding: 0 2px;
		}

		.clickable-text:hover {
			text-decoration: underline;
		}

		.auto-shrink {
			font-size: 8px;
		}

		@media (max-width: 100px) {
			.auto-shrink { font-size: 7px; }
		}

		#bespecial   { top: 230px; left: 76px; width: 34px; height: 23px; background-image: url('bespecial_no.png'); }
		#bespecial:hover {background-image: url('bespecial_no_hover.png');}
		#bespecial.yes:hover {background-image: url('bespecial_yes_hover.png');}
		#bespecial.yes { background-image: url('bespecial_yes.png'); }

		.menu-ready  { top: 258px; left: 4px;   width: 88px; height: 10px; background-image: url('ready_order.png'); }
		.menu-ready:hover { background-image: url('ready_order_hover.png'); }
		.menu-change { top: 269px; left: 4px;   width: 69px; height: 10px; background-image: url('change_character.png'); }
		.menu-change:hover { background-image: url('change_character_hover.png'); }
		.menu-save   { top: 280px; left: 4px;   width: 21px; height: 10px; background-image: url('save.png'); }
		.menu-save:hover { background-image: url('save_hover.png'); }
		.menu-undo   { top: 280px; left: 26px;  width: 21px; height: 10px; background-image: url('undo.png'); }
		.menu-undo:hover { background-image: url('undo_hover.png'); }
		.menu-done   { top: 280px; left: 48px;  width: 20px; height: 10px; background-image: url('done.png'); }
		.menu-done:hover { background-image: url('done_hover.png'); }

		.v-color-box { top: 136px; left: 34px; width: 48px; height: 15px; background-image: url('voice_colour.png'); }
		.v-blob      { top: 4px;   left: 35px; width: 8px;  height: 7px;
		               background-image: url('voice_colour_blob.png');
		               background-blend-mode: multiply; }

		.menu-keybinds {
			top: 280px;
			left: 78px;
			width: 39px;
			height: 10px;
			background-image: url('keybinds.png');
		}
		.menu-keybinds:hover {
			background-image: url('keybinds_hover.png');
		}

		.menu-toggles {
			top: 269px;
			left: 83px;
			width: 34px;
			height: 10px;
			background-image: url('toggles.png');
		}
		.menu-toggles:hover {
			background-image: url('toggles_hover.png');
		}
	</style>
	<script>
		function shrinkText(element) {
			// Reset to default size first
			element.style.fontSize = '8px';

			// Force a reflow to ensure scrollWidth is accurate
			element.offsetHeight;

			const maxWidth = element.offsetWidth - 4;
			let fontSize = 8;

			// Only shrink if text is actually overflowing
			while (element.scrollWidth > maxWidth && fontSize > 5) {
				fontSize -= 0.5;
				element.style.fontSize = fontSize + 'px';
				// Force reflow after each change
				element.offsetHeight;
			}
		}

		function updateField(fieldId, value) {
			var elem = document.getElementById(fieldId);
			if(elem) {
				elem.textContent = value;
				if(elem.classList.contains('auto-shrink')) {
					shrinkText(elem);
				}
			}
		}

		function updateHeadshot(url) {
			var img = document.getElementById('headshot-img');
			if(img) {
				img.src = url || '';
				img.style.display = url ? 'block' : 'none';
			}
		}

		function updateBeSpecial(isActive) {
			var elem = document.getElementById('bespecial');
			if(elem) {
				if(isActive) {
					elem.classList.add('yes');
				} else {
					elem.classList.remove('yes');
				}
			}
		}

		function updateCharacterData() {
			// BYOND's list2params() with output() sends arguments in pairs
			// Arguments come as: arg0, arg1, arg2, arg3... where each pair is key=value so we can't just do update(data)
			var data = {};

			// Process all arguments - they come as strings like "key=value"
			for(var i = 0; i < arguments.length; i++) {
				var arg = arguments\[i\];
				if(typeof arg === 'string' && arg.indexOf('=') !== -1) {
					var parts = arg.split('=');
					var key = parts\[0\];
					var value = parts.slice(1).join('='); // In case value contains '='
					data\[key\] = value;
				}
			}

			// Update fields only if they exist in data
			if('name' in data) updateField('char-name', data.name || '');
			if('job' in data) updateField('char-job', data.job || 'None');
			if('faith' in data) updateField('char-faith', data.faith || '');
			if('species' in data) updateField('char-species', data.species || '');
			if('patron' in data) updateField('char-patron', data.patron || '');
			if('pq' in data) updateField('char-pq', data.pq || '');
			if('age' in data) updateField('char-age', data.age || '');
			if('domhand' in data) updateField('char-domhand', data.domhand || '');
			if('pronouns' in data) updateField('char-pronouns', data.pronouns || '');
			if('family' in data) updateField('char-family', data.family || 'None');
			if('genderpref' in data) updateField('char-genderpref', data.genderpref || 'Any');
			if('spouse' in data) updateField('char-spouse', data.spouse || 'None');
			if('voicetype' in data) updateField('char-voicetype', data.voicetype || '');
			if('accent' in data) updateField('char-accent', data.accent || '');
			if('loadout1' in data) updateField('char-loadout1', data.loadout1 || 'None');
			if('loadout2' in data) updateField('char-loadout2', data.loadout2 || 'None');
			if('loadout3' in data) updateField('char-loadout3', data.loadout3 || 'None');
			if('triumphs' in data) updateField('char-triumphs', data.triumphs || '0');
			if('culture' in data) updateField('char-culture', data.culture || 'None');

			if('headshot' in data) updateHeadshot(data.headshot);
			if('bespecial' in data) updateBeSpecial(data.bespecial === '1');


			if('gender' in data) {
				updateField('char-gender', data.gender || '');
				var silhouette = document.getElementById('silhouette');
				silhouette.style.backgroundImage = "url('features_bodytype_" + data.gender + ".png')";
				if (data.gender === "F") silhouette.style.width = "15px";
    			if (data.gender === "M") silhouette.style.width = "18px";
			}

			// Update voice color blob
			if('voice_color' in data) {
				var blob = document.getElementById('voice-blob');
				if(blob && data.voice_color) {
					blob.style.backgroundColor = data.voice_color;
				}
			}
		}

		window.addEventListener('load', function() {
			document.querySelectorAll('.auto-shrink').forEach(shrinkText);
		});
	</script>
</head>
<body>
<div class="ui-container">
	<div class="sprite header-bg"></div>
	<div class="sprite preview-bg"></div>
	<div class="sprite body-bg"></div>
	<div class="sprite voice-bg"></div>
	<div class="sprite family-bg"></div>
	<div class="sprite flavour-bg"></div>
	<div class="sprite loadout-bg"></div>
	<div class="sprite triumphs-bg"></div>
	<div class="sprite headshot-bg" style="padding: 3px; box-sizing: border-box;">
		<a href='?_src_=prefs;preference=headshot;task=input' style="display: block; width: 100%; height: 100%;">
			<img id="headshot-img" src="[headshot_link || ""]"
				 style="width: 100%; height: 100%; object-fit: cover; cursor: pointer; image-rendering: auto;"
				 onerror="this.style.display='none';">
		</a>
	</div>
	<div class="sprite ooc-bg"></div>

	<div class="sprite" style="top:26px; left:23px; width:92px; height:9px; background-image: url('header_charname.png');">
		<a href='?_src_=prefs;preference=name;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-name" class="clickable-text auto-shrink" style="width:92px; height:9px;">[real_name]</div>
		</a>
	</div>
	<div class="sprite" style="top:11px; left:122px; width:46px; height:9px; background-image: url('header_class.png');">
		<a href='?_src_=prefs;preference=job;task=menu' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-job" class="clickable-text auto-shrink" style="width:46px; height:9px;">[high_job || "None"]</div>
		</a>
	</div>
	<div class="sprite" style="top:11px; left:172px; width:42px; height:9px; background-image: url('header_faith.png');">
		<a href='?_src_=prefs;preference=faith;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-faith" class="clickable-text auto-shrink" style="width:42px; height:9px;">[selected_faith?.name || ""]</div>
		</a>
	</div>
	<div class="sprite" style="top:11px; left:220px; width:31px; height:9px; background-image: url('header_playerckey.png');">
		<div id="char-ckey" class="clickable-text" style="width:31px; height:9px; cursor: default;">[user.ckey]</div>
	</div>
	<div class="sprite" style="top:30px; left:122px; width:46px; height:9px; background-image: url('header_species.png');">
		<a href='?_src_=prefs;preference=species;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-species" class="clickable-text auto-shrink" style="width:46px; height:9px;">[pref_species.name]</div>
		</a>
	</div>
	<div class="sprite" style="top:30px; left:172px; width:42px; height:9px; background-image: url('header_patron.png');">
		<a href='?_src_=prefs;preference=patron;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-patron" class="clickable-text auto-shrink" style="width:42px; height:9px;">[selected_patron.name]</div>
		</a>
	</div>
	<div class="sprite" style="top:30px; left:220px; width:31px; height:9px; background-image: url('header_pq.png');">
		<a href='?_src_=prefs;preference=playerquality;task=menu' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-pq" class="clickable-text auto-shrink" style="width:31px; height:9px;">[get_playerquality(user.ckey, text = TRUE)]</div>
		</a>
	</div>

	<div class="sprite" style="top:70px; left:118px; width:46px; height:9px; background-image: url('body_age.png');">
		<a href='?_src_=prefs;preference=age;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-age" class="clickable-text auto-shrink" style="width:46px; height:9px;">[age]</div>
		</a>
	</div>
	<div class="sprite" style="top:70px; left:168px; width:53px; height:9px; background-image: url('body_flaw.png');">
		<a href='?_src_=prefs;preference=select_quirks' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div class="clickable-text auto-shrink" style="width:53px; height:9px;">Select Quirks</div>
		</a>
	</div>
	<div class="sprite" style="top:89px; left:119px; width:46px; height:9px; background-image: url('body_dominanthand.png');">
		<a href='?_src_=prefs;preference=domhand' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-domhand" class="clickable-text auto-shrink" style="width:46px; height:9px;">[domhand == 1 ? "Left" : "Right"]</div>
		</a>
	</div>
	<div class="sprite" style="top:89px; left:168px; width:53px; height:9px; background-image: url('body_ancestry.png');">
		<a href='?_src_=prefs;preference=s_tone;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div class="clickable-text auto-shrink" style="width:53px; height:9px;">Change</div>
		</a>
	</div>
	<div class="sprite" style="top:108px; left:119px; width:46px; height:9px; background-image: url('body_pronouns.png');">
		<a href='?_src_=prefs;preference=pronouns;task=input' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-pronouns" class="clickable-text auto-shrink" style="width:46px; height:9px;">[pronouns]</div>
		</a>
	</div>
	<a href='?_src_=prefs;preference=gender'><div class="sprite" style="top:108px; left:169px; width:53px; height:9px; background-image: url('body_bodytype.png');">
		<div id="char-gender" class="clickable-text auto-shrink" style="width:53px; height:9px;">[gender == MALE ? "M" : "F"]</div>
	</div></a>

	<a href='?_src_=prefs;preference=family'><div class="sprite" style="top:150px; left:120px; width:73px; height:9px; background-image: url('family_type.png');">
		<div id="char-family" class="clickable-text auto-shrink" style="width:73px; height:9px;">[family ? family : "None"]</div>
	</div></a>
	<a href='?_src_=prefs;preference=gender_choice'><div class="sprite" style="top:169px; left:120px; width:73px; height:9px; background-image: url('gender_pref.png');">
		<div id="char-genderpref" class="clickable-text auto-shrink" style="width:73px; height:9px;">[gender_choice ? gender_choice : "Any"]</div>
	</div></a>
	<a href='?_src_=prefs;preference=setspouse'><div class="sprite" style="top:188px; left:120px; width:73px; height:9px; background-image: url('spouse_pref.png');">
		<div id="char-spouse" class="clickable-text auto-shrink" style="width:73px; height:9px;">[setspouse ? setspouse : "None"]</div>
	</div></a>

	<a href='?_src_=prefs;preference=culture;task=input'><div class="sprite" style="top:150px; left:207px; width:51px; height:9px; background-image: url('flavour_culture.png');">
		<div id="char-culture" class="clickable-text auto-shrink" style="width:51px; height:9px;">[culture ? culture::name : "None"]</div>
	</div></a>

	<a href='?_src_=prefs;preference=voicetype;task=input'><div class="sprite" style="top:154px; left:10px; width:46px; height:9px; background-image: url('voice_type.png');">
		<div id="char-voicetype" class="clickable-text auto-shrink" style="width:46px; height:9px;">[voice_type]</div>
	</div></a>
	<a href='?_src_=prefs;preference=selected_accent;task=input'><div class="sprite" style="top:154px; left:60px; width:42px; height:9px; background-image: url('voice_accent.png');">
		<div id="char-accent" class="clickable-text auto-shrink" style="width:42px; height:9px;">[selected_accent]</div>
	</div></a>

	<a href='?_src_=prefs;preference=loadout_item;loadout_number=1;task=input'><div class="sprite" style="top:194px; left:10px; width:51px; height:9px; background-image: url('loadout_item1.png');">
		<div id="char-loadout1" class="clickable-text auto-shrink" style="width:51px; height:9px;">[loadout1 ? loadout1.name : "None"]</div>
	</div></a>
	<a href='?_src_=prefs;preference=loadout_item;loadout_number=2;task=input'><div class="sprite" style="top:213px; left:10px; width:51px; height:9px; background-image: url('loadout_item2.png');">
		<div id="char-loadout2" class="clickable-text auto-shrink" style="width:51px; height:9px;">[loadout2 ? loadout2.name : "None"]</div>
	</div></a>
	<a href='?_src_=prefs;preference=loadout_item;loadout_number=3;task=input'><div class="sprite" style="top:232px; left:10px; width:51px; height:9px; background-image: url('loadout_item3.png');">
		<div id="char-loadout3" class="clickable-text auto-shrink" style="width:51px; height:9px;">[loadout3 ? loadout3.name : "None"]</div>
	</div></a>

	<div class="sprite" style="top:195px; left:82px; width:22px; height:7px; background-image: url('triumphs_display.png');">
		<a href='?_src_=prefs;preference=triumphs;task=menu' style="text-decoration: none; display: block; width: 100%; height: 100%;">
			<div id="char-triumphs" class="clickable-text" style="width:22px; height:7px; font-size: 5px;">[user.get_triumphs() ? "\Roman [user.get_triumphs()]" : "0"]</div>
		</a>
	</div>

	<a href='?_src_=prefs;preference=triumph_buy_menu'><div class="sprite tri-shop"></div></a>
	<a href='?_src_=prefs;preference=descriptors;task=menu'><div class="sprite flav-desc"></div></a>
	<a href='?_src_=prefs;preference=flavortext;task=input'><div class="sprite flav-text"></div></a>
	<a href='?_src_=prefs;preference=culinary;task=menu'><div class="sprite flav-food"></div></a>
	<a href='?_src_=prefs;preference=ooc_preview;task=input'><div class="sprite flav-prev"></div></a>
	<a href='?_src_=prefs;preference=ooc_notes;task=input'><div class="sprite ooc-notes"></div></a>
	<a href='?_src_=prefs;preference=ooc_extra;task=input'><div class="sprite ooc-extra"></div></a>
	<a href='?_src_=prefs;preference=antag;task=menu'><div class="sprite btn-roles"></div></a>
	<a href='?_src_=prefs;preference=customizers;task=menu'><div class="sprite f-btn"></div></a>
	<a href='?_src_=prefs;preference=randomiseappearanceprefs;'><div class="sprite f-random"></div></a>

	<div class="sprite features-bg"><div id="silhouette" class="sprite" style="background-image: url('features_bodytype_[gender == MALE ? "m" : "f"].png');"></div></div>

	<div class="sprite v-color-box">
		<a href='?_src_=prefs;preference=voice;task=input' style="display: block; width: 100%; height: 100%;">
			<div id="voice-blob" class="sprite v-blob" style="background-color: [voice_color];"></div>
		</a>
	</div>
	<a href='?_src_=prefs;preference=bespecial'><div id="bespecial" class="sprite [next_special_trait ? "yes" : ""]"></div></a>
	<a href='?_src_=prefs;preference=multi;task=menu'><div class="sprite menu-ready"></div></a>
	<a href='?_src_=prefs;preference=changeslot;'><div class="sprite menu-change"></div></a>
	<a href='?_src_=prefs;preference=keybinds;task=menu'><div class="sprite menu-keybinds"></div></a>
	<a href='?_src_=prefs;preference=toggles'><div class="sprite menu-toggles"></div></a>
	<a href='?_src_=prefs;preference=save'><div class="sprite menu-save"></div></a>
	<a href='?_src_=prefs;preference=load'><div class="sprite menu-undo"></div></a>
	<a href='?_src_=prefs;preference=finished'><div class="sprite menu-done"></div></a>
</div>
</body>
</html>
"}

	winshow(user, "stonekeep_prefwin", TRUE)
	winshow(user, "stonekeep_prefwin.character_preview_map", TRUE)
	// This should really be a browser datum
	user << browse(dat.Join(), "window=preferences_browser;size=816x945")
	update_preview_icon()
	onclose(user, "stonekeep_prefwin", src)

/datum/preferences/proc/update_menu_data(mob/user, list/fields_to_update)
	if(!winexists(user, "preferences_browser"))
		return

	var/datum/faith/selected_faith = GLOB.faith_list[selected_patron.associated_faith]
	var/datum/job/high_job
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		high_job = job_type
		break

	var/list/params = list()

	// If no specific fields specified, update all
	var/update_all = !fields_to_update || !length(fields_to_update)

	if(update_all || ("name" in fields_to_update))
		params["name"] = real_name
	if(update_all || ("job" in fields_to_update))
		params["job"] = high_job || "None"
	if(update_all || ("faith" in fields_to_update))
		params["faith"] = selected_faith?.name || ""
	if(update_all || ("species" in fields_to_update))
		params["species"] = pref_species.name
	if(update_all || ("patron" in fields_to_update))
		params["patron"] = selected_patron.name
	if(update_all || ("pq" in fields_to_update))
		params["pq"] = get_playerquality(user.ckey, text = TRUE)
	if(update_all || ("age" in fields_to_update))
		params["age"] = age
	if(update_all || ("domhand" in fields_to_update))
		params["domhand"] = domhand == 1 ? "Left" : "Right"
	if(update_all || ("pronouns" in fields_to_update))
		params["pronouns"] = pronouns
	if(update_all || ("gender" in fields_to_update))
		params["gender"] = gender == MALE ? "M" : "F"
	if(update_all || ("family" in fields_to_update))
		params["family"] = family ? family : "None"
	if(update_all || ("genderpref" in fields_to_update))
		params["genderpref"] = gender_choice ? gender_choice : "Any"
	if(update_all || ("spouse" in fields_to_update))
		params["spouse"] = setspouse ? setspouse : "None"
	if(update_all || ("voicetype" in fields_to_update))
		params["voicetype"] = voice_type
	if(update_all || ("accent" in fields_to_update))
		params["accent"] = selected_accent
	if(update_all || ("loadout1" in fields_to_update))
		params["loadout1"] = loadout1 ? loadout1.name : "None"
	if(update_all || ("loadout2" in fields_to_update))
		params["loadout2"] = loadout2 ? loadout2.name : "None"
	if(update_all || ("loadout3" in fields_to_update))
		params["loadout3"] = loadout3 ? loadout3.name : "None"
	if(update_all || ("triumphs" in fields_to_update))
		params["triumphs"] = user.get_triumphs() ? "\Roman [user.get_triumphs()]" : "0"
	if(update_all || ("headshot" in fields_to_update))
		params["headshot"] = headshot_link || ""
	if(update_all || ("voice_color" in fields_to_update))
		params["voice_color"] = voice_color
	if(update_all || ("bespecial" in fields_to_update))
		params["bespecial"] = next_special_trait ? "1" : "0"
	if(update_all || ("culture" in fields_to_update))
		params["culture"] = culture::name

	// Use list2params as BYOND expects for browser output
	user << output(list2params(params), "preferences_browser:updateCharacterData")
	update_preview_icon()


/datum/preferences/proc/set_ui_theme(new_theme)
	if(new_theme in list("dusty", "grimshart", "paper", "parchment"))
		char_theme = new_theme
		return TRUE
	return FALSE

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS

/datum/preferences/proc/set_choices(mob/user, limit = 15, list/splitJobs = list("Captain", "Priest", "Merchant", "Butler", "Village Elder"), widthPerColumn = 400, height = 620)
	if(!SSjob)
		return

	var/HTML = "<center>"
	if(!length(SSjob.joinable_occupations))
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>"
	else
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>"
		if(joblessrole != RETURNTOLOBBY && joblessrole != BERANDOMJOB)
			joblessrole = RETURNTOLOBBY
		HTML += "<b>If Role Unavailable:</b><font color='purple'><a href='?_src_=prefs;preference=job;task=nojob'>[joblessrole]</a></font><BR>"
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += {"
			<script type='text/javascript'>
				function update_job_preference() {
					var data = {};
					for(var i = 0; i < arguments.length; i++) {
						var arg = arguments\[i\];
						if(typeof arg === 'string' && arg.indexOf('=') !== -1) {
							var parts = arg.split('=');
							var key = parts\[0\];
							var value = decodeURIComponent(parts.slice(1).join('='));
							data\[key\] = value;
						}
					}

					if(!data.jobTitle || data.prefLevel === undefined) return;

					var jobId = data.jobTitle.replace(/ /g, '_');
					var prefLink = document.getElementById('job-pref-' + jobId);

					if(prefLink) {
						var level = parseInt(data.prefLevel);
						// level values: 1=High, 2=Medium, 3=Low, 4=NEVER
						var config = {
							1: { label: 'High', color: 'slateblue', upper: 4, lower: 2 },
							2: { label: 'Medium', color: 'green', upper: 1, lower: 3 },
							3: { label: 'Low', color: 'orange', upper: 2, lower: 4 },
							4: { label: 'NEVER', color: 'red', upper: 3, lower: 1 }
						};

						if(config\[level\]) {
							var cfg = config\[level\];
							var jobTitle = data.jobTitle;

							prefLink.innerHTML = '<font color=' + cfg.color + '>' + cfg.label + '</font>';
							prefLink.href = '?_src_=prefs;preference=job;task=setJobLevel;level=' + cfg.upper + ';text=' + jobTitle;
							prefLink.setAttribute('oncontextmenu', 'javascript:return setJobPrefRedirect(' + cfg.lower + ', "' + jobTitle + '");');
						}
					}
				}


				function toggleCategory(categoryName) {
					var fieldset = document.getElementById('fieldset-' + categoryName);
					var content = document.getElementById('content-' + categoryName);
					if(content.style.display === 'none') {
						content.style.display = 'block';
						fieldset.setAttribute('data-collapsed', 'false');
					} else {
						content.style.display = 'none';
						fieldset.setAttribute('data-collapsed', 'true');
					}
				}
			</script>
			<style>
				.two-column-container {
					display: flex;
					justify-content: center;
					gap: 20px;
					max-width: 1000px;
					margin: 0 auto;
				}

				.column {
					display: flex;
					flex-direction: column;
					gap: 10px;
					width: 450px;
				}

				.job-category-box {
					width: 100%;
					border: 2px solid;
					margin: 0;
					box-sizing: border-box;
				}

				.job-category-box table {
					width: 100%;
				}

				fieldset\[data-collapsed="true"\] legend::after {
					content: " (Expand)";
				}
				fieldset\[data-collapsed="false"\] legend::after {
					content: " (Collapse)";
				}

				.tutorialhover {
					position: relative;
					display: inline-block;
				}
				.tutorialhover .tutorial {
					visibility: hidden;
					width: 280px;
					background-color: black;
					color: #e3c06f;
					text-align: center;
					border-radius: 6px;
					padding: 5px;
					position: absolute;
					z-index: 1000;
					left: 50%;
					transform: translateX(-50%);
					bottom: 100%;
					margin-bottom: 5px;
				}
				.tutorialhover:hover .tutorial {
					visibility: visible;
				}
			</style>
		"}

		var/race_ban = FALSE
		if(is_race_banned(user.ckey, user.client.prefs.pref_species.id))
			HTML += "<div style='color: red; text-align: center; padding: 10px;'>YOU ARE BANNED FROM PLAYING THE SPECIES: [user.client.prefs.pref_species.id]</div>"
			race_ban = TRUE

		if(!race_ban)
			var/left_column_html = ""
			var/right_column_html = ""

			var/list/omegalist = list(
				GLOB.noble_courthand_positions,
				GLOB.garrison_positions,
				GLOB.church_positions,
				GLOB.peasant_positions,
				GLOB.apprentices_positions,
				GLOB.serf_positions,
				GLOB.company_positions,
				GLOB.youngfolk_positions,
				GLOB.allmig_positions,
				GLOB.inquisition_positions,
			)

			var/category_index = 0
			for(var/list/category in omegalist)
				if(!SSjob.name_occupations[category[1]])
					continue

				var/list/available_jobs = list()
				for(var/job in category)
					var/datum/job/job_datum = SSjob.name_occupations[job]
					if(!job_datum)
						continue
					if(!job_datum.total_positions && !job_datum.spawn_positions)
						continue
					if(!job_datum.enabled)
						continue
					if(job_datum.spawn_positions <= 0)
						continue
					available_jobs += job_datum

				if(!length(available_jobs))
					continue

				var/datum/job/first_job = SSjob.name_occupations[category[1]]
				var/cat_color = first_job.selection_color
				var/cat_name = ""
				switch(first_job.department_flag)
					if(NOBLEMEN)
						cat_name = "Nobles"
					if(GARRISON)
						cat_name = "Garrison"
					if(SERFS)
						cat_name = "Yeomanry"
					if(CHURCHMEN)
						cat_name = "Churchmen"
					if(COMPANY)
						cat_name = "Company"
					if(PEASANTS)
						cat_name = "Peasantry"
					if(APPRENTICES)
						cat_name = "Apprentices"
					if(YOUNGFOLK)
						cat_name = "Young Folk"
					if(OUTSIDERS)
						cat_name = "Outsiders"
					if(INQUISITION)
						cat_name = "Inquisition"

				var/category_html = ""
				category_html += "<fieldset class='job-category-box' style='border-color: [cat_color];' id='fieldset-[cat_name]' data-collapsed='true'>"
				category_html += "<legend align='center' style='font-weight: bold; color: [cat_color]; cursor: pointer;' onclick='toggleCategory(\"[cat_name]\")'>[cat_name]</legend>"
				category_html += "<div id='content-[cat_name]' style='display: none;'>"
				category_html += "<table cellpadding='1' cellspacing='0'>"

				for(var/datum/job/job in available_jobs)
					var/rank = job.title
					var/used_name = (pronouns == SHE_HER && job.f_title) ? job.f_title : job.title
					var/job_id = replacetext(rank, " ", "_")

					category_html += "<tr bgcolor='#000000'><td width='60%' align='right'>"

					if(is_role_banned(user.ckey, job.title))
						category_html += "[used_name]</td><td><a href='?_src_=prefs;bancheck=[rank]'> BANNED</a></td></tr>"
						continue
					if(!job.player_old_enough(user.client))
						var/available_in_days = job.available_in_days(user.client)
						category_html += "[used_name]</td><td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
						continue
					if(CONFIG_GET(flag/usewhitelist))
						if(job.whitelist_req && (!user.client.whitelisted()))
							category_html += "<font color=#6183a5>[used_name]</font></td><td> </td></tr>"
							continue
					var/lock_html = get_job_lock_html(job, user, used_name)
					if(lock_html)
						category_html += lock_html
						continue

					category_html += "<div class='tutorialhover'>[used_name]"
					category_html += "<span class='tutorial'>[job.tutorial]<br>Slots: [job.get_total_positions()]</span>"
					category_html += "</div>"

					category_html += "</td><td width='40%'>"

					var/prefLevelLabel = "ERROR"
					var/prefLevelColor = "pink"
					var/prefUpperLevel = -1 // level to assign on left click
					var/prefLowerLevel = -1 // level to assign on right click

					switch(job_preferences[job.title])
						if(JP_HIGH)
							prefLevelLabel = "High"
							prefLevelColor = "slateblue"
							prefUpperLevel = 4
							prefLowerLevel = 2
						if(JP_MEDIUM)
							prefLevelLabel = "Medium"
							prefLevelColor = "green"
							prefUpperLevel = 1
							prefLowerLevel = 3
						if(JP_LOW)
							prefLevelLabel = "Low"
							prefLevelColor = "orange"
							prefUpperLevel = 2
							prefLowerLevel = 4
						else
							prefLevelLabel = "NEVER"
							prefLevelColor = "red"
							prefUpperLevel = 3
							prefLowerLevel = 1

					category_html += "<a class='white' id='job-pref-[job_id]' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"
					category_html += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
					category_html += "</a></td></tr>"

				category_html += "</table></div></fieldset>"

				if(category_index % 2 == 0)
					left_column_html += category_html
				else
					right_column_html += category_html
				category_index++

			HTML += "<div class='two-column-container'>"
			HTML += "<div class='column'>[left_column_html]</div>"
			HTML += "<div class='column'>[right_column_html]</div>"
			HTML += "</div>"

		if(user.client.prefs.lastclass)
			HTML += "<center><br><a href='?_src_=prefs;preference=job;task=triumphthing'>PLAY AS [user.client.prefs.lastclass] AGAIN</a></center>"
		else
			HTML += "<br>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset</a></center>"

	HTML += "</center>"

	var/datum/browser/noclose/popup = new(user, "mob_occupation", "<div align='center'>Class Selection</div>", 1000, 700)
	popup.set_window_options(can_close = FALSE)
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/set_job_preference_level(datum/job/job, level)
	if(!job)
		return FALSE
	if(level == JP_HIGH)
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
	job_preferences[job.title] = level
	return TRUE


/datum/preferences/proc/update_job_preference(mob/user, role, desiredLvl)
    if(!SSjob || !length(SSjob.joinable_occupations))
        return
    var/datum/job/job = SSjob.GetJob(role)
    if(!job || !(job.job_flags & JOB_NEW_PLAYER_JOINABLE))
        user << browse(null, "window=mob_occupation")
        update_menu_data(user, list("job"))
        return
    if(!isnum(desiredLvl))
        to_chat(user, "<span class='danger'>update_job_preference - desired level was not a number. Please notify coders!</span>")
        CRASH("update_job_preference called with desiredLvl value of [isnull(desiredLvl) ? "null" : desiredLvl]")

    var/jpval = null
    // desiredLvl comes from the links: 1=High, 2=Medium, 3=Low, 4=NEVER
    // JP constants: JP_LOW=1, JP_MEDIUM=2, JP_HIGH=3
    switch(desiredLvl)
        if(1)
            jpval = JP_HIGH  // 3
        if(2)
            jpval = JP_MEDIUM  // 2
        if(3)
            jpval = JP_LOW  // 1
        if(4)
            jpval = null  // NEVER

    var/was_high = (jpval == JP_HIGH)
    var/previous_high_job = null

    if(was_high)
        for(var/job_title in job_preferences)
            if(job_preferences[job_title] == JP_HIGH)
                previous_high_job = job_title
                break

    set_job_preference_level(job, jpval)

    // Send back the desiredLvl value directly since that's what JavaScript expects
    update_job_display(user, role, desiredLvl)

    if(was_high && previous_high_job && previous_high_job != role)
        update_job_display(user, previous_high_job, 2)  // Medium

    update_menu_data(user, list("job"))
    return 1

/datum/preferences/proc/reset_jobs(mob/user, silent = FALSE)
	job_preferences = list()
	if(!silent)
		to_chat(user, "<font color='red'>Classes reset.</font>")
	if(winget(user, "mob_occupation", "is-visible"))
		set_choices(user)


/datum/preferences/proc/update_job_display(mob/user, job_title, pref_level)
	if(!winexists(user, "mob_occupation"))
		return

	var/list/params = list()
	params["jobTitle"] = job_title
	params["prefLevel"] = pref_level

	user << output(list2params(params), "mob_occupation.browser:update_job_preference")

/datum/preferences/proc/capture_keybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybinds;task=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/noclose/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/reset_patron(mob/user, silent = FALSE)
	selected_patron = default_patron
	if(!silent)
		to_chat(user, "<font color='red'>Patron reset.</font>")

/datum/preferences/proc/reset_culture(mob/user, silent = FALSE)
	var/datum/culture/selected = GLOB.culture_singletons[culture]
	if(selected.is_selectable(src))
		return
	culture = src::culture
	if(!silent)
		to_chat(user, "<font color='red'>Culture reset.</font>")

/datum/preferences/proc/reset_last_class(mob/user)
	if(user.client?.prefs)
		if(!user.client.prefs.lastclass)
			return
	if(browser_alert(user, "Use 2 TRIUMPHS to play as this class again?", "OUROBOROS", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		return
	if(user.client?.prefs)
		if(user.client.prefs.lastclass)
			if(user.get_triumphs() < 2)
				to_chat(user, "<span class='warning'>I haven't TRIUMPHED enough.</span>")
				return
			user.adjust_triumphs(-2)
			user.client.prefs.lastclass = null
			user.client.prefs.save_preferences()

/datum/preferences/proc/set_keybinds(mob/user)
	var/list/dat = list()
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)

	var/list/kb_categories = list()
	// Group keybinds by category
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

	dat += "<center><a href='?_src_=prefs;preference=keybinds;task=close'>Done</a></center><br>"
	for (var/category in kb_categories)
		for (var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			if(!length(user_binds[kb.name]))
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
			//	var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
			//	if(LAZYLEN(default_keys))
			//		dat += "| Default: [default_keys.Join(", ")]"
				dat += "<br>"
			else
				var/bound_key = user_binds[kb.name][1]
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				for(var/bound_key_index in 2 to length(user_binds[kb.name]))
					bound_key = user_binds[kb.name][bound_key_index]
					dat += " | <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
					dat += "| <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
				dat += "<br>"

	dat += "<br><br>"
	dat += "<a href ='?_src_=prefs;preference=keybinds;task=keybindings_reset'>\[Reset to default\]</a>"
	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "keybind_setup", "<div align='center'>Keybinds</div>", 600, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options(can_close = FALSE)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/set_antag(mob/user)
	var/list/dat = list()

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"
	dat += "<center><a href='?_src_=prefs;preference=antag;task=close' style='display:block;margin-bottom:2px'>Done</a></center>"
	dat += "<h2 style='margin:5;padding:5;line-height:1.2'>Villains</h2>"

	if(is_total_antag_banned(user.ckey))
		dat += "<font color=red><b>I am banned from antagonist roles.</b></font><br>"
		src.be_special = list()

	for (var/i in GLOB.special_roles_rogue)
		if(is_antag_banned(user.ckey, i))
			dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;bancheck=[i]'>BANNED</a><br>"
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
				days_remaining = get_remaining_days(user.client)

			if(days_remaining)
				dat += "<b>[capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS\]</font><br>"
			else
				dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;preference=antag;task=be_special;be_special_type=[i]'>[(i in be_special) ? "Enabled" : "Disabled"]</a><br>"

	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "antag_setup", "<div align='center'>Special Roles</div>", 265, 340) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options(can_close = FALSE)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/lore_popup(mob/user)
	if(!user || !user.client)
		return
	var/list/dat = list()
	var/datum/browser/noclose/popup  = new(user, "lore_primer", "<div align='center'>Lore Primer</div>", 650, 900)
	dat += GLOB.roleplay_readme
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(href_list["bancheck"])
		var/list/ban_details = is_banned_from_with_details(user.ckey, user.client.address, user.client.computer_id, href_list["bancheck"])
		var/admin = FALSE
		if(GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey])
			admin = TRUE
		for(var/i in ban_details)
			if(admin && !text2num(i["applies_to_admins"]))
				continue
			ban_details = i
			break //we only want to get the most recent ban's details
		if(ban_details && ban_details.len)
			var/expires = "This is a permanent ban."
			if(ban_details["expiration_time"])
				expires = " The ban is for [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)] and expires on [ban_details["expiration_time"]] (server time)."
			to_chat(user, "<span class='danger'>You, or another user of this computer or connection ([ban_details["key"]]) is banned from playing [href_list["bancheck"]].<br>The ban reason is: [ban_details["reason"]]<br>This ban (BanID #[ban_details["id"]]) was applied by [ban_details["admin_key"]] on [ban_details["bantime"]] during round ID [ban_details["round_id"]].<br>[expires]</span>")
			return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				show_choices(user,4)
			if("reset")
				reset_jobs(user, TRUE)

			if("triumphthing")
				reset_last_class(user)
			if("nojob")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				set_choices(user)
			if("tutorial")
				if(href_list["tut"])
					to_chat(user, "<span class='info'>* ----------------------- *</span>")
					to_chat(user, href_list["tut"])
					to_chat(user, "<span class='info'>* ----------------------- *</span>")
			if("random")
				joblessrole = BERANDOMJOB
				set_choices(user)
			if("setJobLevel")
				if(SSticker.job_change_locked)
					return 1
				update_job_preference(user, href_list["text"], text2num(href_list["level"]))
			else
				set_choices(user)
		return 1
	else if(href_list["preference"] == "multi")
		if(isnewplayer(user))
			var/mob/dead/new_player/player = user
			player.cache_multi_ready_characters()
		open_multi_ready()
		return 1

	else if(href_list["preference"] == "antag")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=antag_setup")
				update_menu_data(user)
			if("be_special")
				var/be_special_type = href_list["be_special_type"]
				if(be_special_type in be_special)
					be_special -= be_special_type
				else
					be_special += be_special_type
				set_antag(user)
			if("update")
				set_antag(user)
			else
				set_antag(user)

	else if(href_list["preference"] == "triumphs")
		user.show_triumphs_list()

	else if(href_list["preference"] == "playerquality")
		check_pq_menu(user.ckey)

	else if(href_list["preference"] == "culinary")
		show_culinary_ui(user)
		return

	else if(href_list["preference"] == "markings")
		ShowMarkings(user)
		return
	else if(href_list["preference"] == "descriptors")
		show_descriptors_ui(user)
		return

	else if(href_list["preference"] == "customizers")
		ShowCustomizers(user)
		return
	else if(href_list["preference"] == "triumph_buy_menu")
		SStriumphs.startup_triumphs_menu(user.client)

	else if(href_list["preference"] == "keybinds")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=keybind_setup")
				update_menu_data(user)
			if("update")
				set_keybinds(user)
			if("keybindings_capture")
				var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
				var/old_key = href_list["old_key"]
				capture_keybinding(user, kb, old_key)
				return

			if("keybindings_set")
				var/kb_name = href_list["keybinding"]
				if(!kb_name)
					user << browse(null, "window=capturekeypress")
					set_keybinds(user)
					return

				var/clear_key = text2num(href_list["clear_key"])
				var/old_key = href_list["old_key"]
				if(clear_key)
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					user << browse(null, "window=capturekeypress")
					save_preferences()
					set_keybinds(user)
					return

				var/new_key = uppertext(href_list["key"])
				var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
				var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
				var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
				var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
				// var/key_code = text2num(href_list["key_code"])

				if(GLOB._kbMap[new_key])
					new_key = GLOB._kbMap[new_key]

				var/full_key
				switch(new_key)
					if("Alt")
						full_key = "[new_key][CtrlMod][ShiftMod]"
					if("Ctrl")
						full_key = "[AltMod][new_key][ShiftMod]"
					if("Shift")
						full_key = "[AltMod][CtrlMod][new_key]"
					else
						full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
				if(key_bindings[old_key])
					key_bindings[old_key] -= kb_name
					if(!length(key_bindings[old_key]))
						key_bindings -= old_key
				key_bindings[full_key] += list(kb_name)
				key_bindings[full_key] = sortList(key_bindings[full_key])
				var/datum/keybinding/client/say/kb = GLOB.keybindings_by_name[kb_name]
				if(istype(kb))
					user.client.set_macros()
				DIRECT_OUTPUT(user, browse(null, "window=capturekeypress"))
				user.client.update_movement_keys()
				save_preferences()
				set_keybinds(user)

			if("keybindings_reset")
				var/choice = browser_alert(user, "Do you really want to reset your keybindings?", "Setup keybindings", DEFAULT_INPUT_CONFIRMATIONS)
				if(choice != CHOICE_CONFIRM)
					return
				hotkeys = TRUE
				key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)
				user.client.update_movement_keys()
				set_keybinds(user)
			else
				set_keybinds(user)
		return TRUE

	else if(href_list["preference"] == "toggles")
		var/list/toggles_list = list(
			"Default Toggles" = list("toggles_default", toggles),
			"Maptext Toggles" = list("toggles_maptext", toggles_maptext)
		)
		var/toggle_type = browser_input_list(user, title = "Toggle Select", items = toggles_list)
		if(!toggle_type)
			return
		var/list/toggles_data = toggles_list[toggle_type]
		var/bitfield = toggles_data[1]
		var/prefs_variable = toggles_data[2]
		var/new_toggles = input_bitfield(user, toggle_type, bitfield, prefs_variable, nheight = 500)
		if(!isnull(new_toggles))
			if(toggle_type == "Default Toggles")
				// Reset all fields we touch to 0 first because we don't use a full set to do toggles = X
				// And don't want to override them
				for(var/field in GLOB.bitfields[bitfield])
					toggles &= ~GLOB.bitfields[bitfield][field]
				toggles ^= new_toggles
				if((prefs_variable & SOUND_LOBBY) && user.client && isnewplayer(user))
					user.client.playtitlemusic()
				else
					user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if((prefs_variable & SOUND_SHIP_AMBIENCE) && user.client && !isnewplayer(user))
					user.refresh_looping_ambience()
				else
					user.cancel_looping_ambience()

				user.client?.update_ambience_pref()

			else if(toggle_type == "Maptext Toggles")
				toggles_maptext = new_toggles

	switch(href_list["task"])
		if("change_customizer")
			handle_customizer_topic(user, href_list)
			update_menu_data(user)
			ShowCustomizers(user)
			return
		if("change_marking")
			handle_body_markings_topic(user, href_list)
			update_menu_data(user)
			ShowMarkings(user)
			return
		if("change_descriptor")
			handle_descriptors_topic(user, href_list)
			show_descriptors_ui(user)
			return
		if("change_culinary_preferences")
			handle_culinary_topic(user, href_list)
			show_culinary_ui(user)
			return
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = pick(pref_species.possible_ages)
				if("eyes")
					eye_color = random_eye_color()
				if("s_tone")
					var/list/skins = pref_species.get_skin_list()
					skin_tone = skins[pick(skins)]
				if("species")
					random_species()
				if("all")
					apply_character_randomization_prefs()

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])

			switch(href_list["preference"])
				if("name")
					var/new_name = browser_input_text(user, "DECIDE YOUR HERO'S IDENTITY", "THE SELF", real_name, MAX_NAME_LEN, encode = FALSE)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
					GLOB.name_adjustments |= "[parent] changed their characters name to [new_name]."
					log_character("[parent] changed their characters name to [new_name].")

				if("age")
					var/new_age = browser_input_list(user, "SELECT YOUR HERO'S AGE", "YILS DEAD", pref_species.possible_ages, age)
					if(new_age)
						age = new_age
						reset_jobs(user)
				if ("pronouns")
					var/list/allowed_pronouns = pref_species.allowed_pronouns
					if(!allowed_pronouns || !length(allowed_pronouns))
						// fallback to the default pronouns list
						allowed_pronouns = PRONOUNS_LIST

					if(length(allowed_pronouns) == 1)
						pronouns = allowed_pronouns[1]
						to_chat(user, span_warning("This species can only use [pronouns]."))
						return

					var/pronouns_input = browser_input_list(user, "CHOOSE HOW MORTALS REFER TO YOUR HERO", "DISOBEY SOCIAL NORMS", allowed_pronouns)
					if(pronouns_input)
						pronouns = pronouns_input
						to_chat(user, span_warning("Your character's pronouns are now [pronouns]."))
				if ("voicetype")
					var/list/allowed_voices
					if(gender == MALE)
						allowed_voices = pref_species.allowed_voicetypes_m
					else if(gender == FEMALE)
						allowed_voices = pref_species.allowed_voicetypes_f
					else
						allowed_voices = VOICE_TYPES_LIST
					if(!allowed_voices || !length(allowed_voices))
						allowed_voices = VOICE_TYPES_LIST
					if(length(allowed_voices) == 1)
						voice_type = allowed_voices[1]
						to_chat(user, span_warning("This species can only use the [voice_type] voice type."))
						return

					var/voicetype_input = browser_input_list(user, "CHOOSE YOUR HERO'S VOICE TYPE", "DISCARD SOCIETY'S EXPECTATIONS", allowed_voices)
					if(voicetype_input)
						voice_type = voicetype_input
						if(voicetype_input == VOICE_TYPE_ANDRO)
							to_chat(user, span_warning("This will use the feminine voicepack pitched down a bit to achieve a more androgynous sound."))
						to_chat(user, span_warning("Your character will now vocalize with a [lowertext(voice_type)] affect."))
				if("faith")
					var/list/faiths_named = list()
					for(var/datum/faith/faith as anything in GLOB.faith_list)
						faith = GLOB.faith_list[faith]
						if(!faith.preference_accessible(src))
							continue
						faiths_named["\The [faith.name]"] = faith
					var/faith_input = browser_input_list(user, "SELECT YOUR HERO'S BELIEF", "PUPPETS ON STRINGS", faiths_named, "\The [selected_patron.associated_faith::name]")
					if(faith_input)
						var/datum/faith/faith = faiths_named[faith_input]
						to_chat(user, "<font color='purple'>Faith: [faith.name]</font>")
						to_chat(user, "<font color='purple'>Background: [faith.desc]</font>")
						selected_patron = GLOB.patron_list[faith.godhead] || GLOB.patron_list[pick(GLOB.patrons_by_faith[faith.type])]

				if("patron")
					var/list/patrons_named = list()
					for(var/datum/patron/patron as anything in GLOB.patrons_by_faith[selected_patron.associated_faith || initial(default_patron.associated_faith)])
						patron = GLOB.patron_list[patron]
						if(!patron.preference_accessible(src))
							continue
						var/pref_name = patron.display_name ? patron.display_name : patron.name
						patrons_named[pref_name] = patron

					if(length(patrons_named))
						var/datum/faith/current_faith = GLOB.faith_list[selected_patron.associated_faith] || GLOB.faith_list[initial(default_patron.associated_faith)]
						var/god_input = browser_input_list(user, "SELECT YOUR HERO'S PATRON GOD", uppertext("\The [current_faith.name]"), patrons_named, selected_patron)
						if(god_input)
							selected_patron = patrons_named[god_input]

					to_chat(user, "<font color='purple'>Patron: [selected_patron]</font>")
					to_chat(user, "<font color='purple'>Domain: [selected_patron.domain]</font>")
					to_chat(user, "<font color='purple'>Background: [selected_patron.desc]</font>")
					to_chat(user, "<font color='purple'>Flawed aspects: [selected_patron.flaws]</font>")
					to_chat(user, "<font color='purple'>Likely Worshippers: [selected_patron.worshippers]</font>")
					to_chat(user, "<font color='red'>Considers these to be Sins: [selected_patron.sins]</font>")
					to_chat(user, "<font color='white'>Blessed with boon(s): [selected_patron.boons]</font>")

				if("voice")
					var/new_voice = input(user, "SELECT YOUR HERO'S VOICE COLOR", "THE THROAT","#"+voice_color) as color|null
					if(new_voice)
						if(color_hex2num(new_voice) < 230)
							to_chat(user, "<font color='red'>This voice color is too dark for mortals.</font>")
							return
						voice_color = sanitize_hexcolor(new_voice)

				if("headshot")
					if(!donator)
						to_chat(user, "This is a donator exclusive feature, your headshot link will be applied but others will only be able to view it if you are a Patreon supporter or Twitch subscriber.")

					to_chat(user, span_notice("Please use an image of the head and shoulder area to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or ANYTHING AI generated.</span>"]"))
					to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
					to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
					var/new_headshot_link = input(user, "Input the headshot link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Headshot", headshot_link) as text|null
					if(!new_headshot_link)
						return
					var/is_valid_link = is_valid_headshot_link(user, new_headshot_link, FALSE)
					if(!is_valid_link)
						to_chat(user, span_notice("Failed to update headshot"))
						return
					headshot_link = new_headshot_link
					to_chat(user, span_notice("Successfully updated headshot picture"))
					log_game("[user] has set their Headshot image to '[headshot_link]'.")
				if("formathelp")
					var/list/dat = list()
					dat +="You can use backslash (\\) to escape special characters.<br>"
					dat += "<br>"
					dat += "# text : Defines a header.<br>"
					dat += "|text| : Centers the text.<br>"
					dat += "**text** : Makes the text <b>bold</b>.<br>"
					dat += "*text* : Makes the text <i>italic</i>.<br>"
					dat += "^text^ : Increases the <font size = \"4\">size</font> of the text.<br>"
					dat += "((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>"
					dat += "* item : An unordered list item.<br>"
					dat += "--- : Adds a horizontal rule.<br>"
					dat += "-=FFFFFFtext=- : Adds a specific <font color = '#FFFFFF'>colour</font> to text.<br><br>"
					dat += "Minimum Flavortext: <b>[MINIMUM_FLAVOR_TEXT]</b> characters.<br>"
					dat += "Minimum OOC Notes: <b>[MINIMUM_OOC_NOTES]</b> characters."
					var/datum/browser/popup = new(user, "Formatting Help", width = 400, height = 350)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("loadout_item")
					var/list/loadouts_available = list("None" = null)
					for(var/datum/loadout_item/item as anything in GLOB.loadout_items)
						loadouts_available[item.name] += item

					var/loadout_input = browser_input_list(
						user,
						"Choose your character's loadout item. RMB a tree, statue or clock to collect.",
						"Loadout",
						loadouts_available,
						)

					var/loadout_number = href_list["loadout_number"]

					set_loadout(user, loadout_number, loadouts_available[loadout_input])

				if("species")
					selected_accent = ACCENT_DEFAULT

					var/list/selectable = list()
					for(var/species_id in GLOB.roundstart_species)
						var/species_type = GLOB.species_list[species_id]

						var/datum/species/species = new species_type()
						if(!species.preference_accessible(src))
							continue

						selectable[species.name] = species.type

					var/result = browser_input_list(user, "SELECT YOUR HERO'S PEOPLE:", "VANDERLIN FAUNA", selectable, pref_species)

					if(result)
						var/species_type = selectable[result]

						pref_species = new species_type()

						to_chat(user, "<em>[pref_species.name]</em>")
						if(pref_species.desc)
							to_chat(user, "[pref_species.desc]")

						if(!length(pref_species.allowed_pronouns))
							to_chat(user, span_warning("This species does not have any allowed pronouns. Please contact a coder to add them."))
						else if (length(pref_species.allowed_pronouns) == 1)
							pronouns = pref_species.allowed_pronouns[1]
						else if(!(pronouns in pref_species.allowed_pronouns))
							pronouns = pref_species.allowed_pronouns[1]

						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						real_name = pref_species.random_name(gender,1)
						reset_jobs(user)
						reset_patron(user)
						reset_culture(user)
						randomise_appearance_prefs(~(RANDOMIZE_SPECIES))
						customizer_entries = list()
						validate_customizer_entries()
						reset_all_customizer_accessory_colors()
						randomize_all_customizer_accessories()
						accessory = "Nothing"

				if("flavortext")
					to_chat(user, span_notice("["<span class='bold'>Flavortext should not include nonphysical nonsensory attributes such as backstory or the character's internal thoughts. NSFW descriptions are prohibited.</span>"]"))
					var/new_flavortext = input(user, "Input your character description", "DESCRIBE YOURSELF", flavortext) as message|null // browser_input_text sanitizes in the box itself, which makes it look kind of ugly when editing A LOT of FTs
					if(new_flavortext == null)
						return
					if(new_flavortext == "")
						flavortext = null
						flavortext_display = null
						update_menu_data(user)
						return
					flavortext = new_flavortext
					var/ft = flavortext
					ft = html_encode(ft)
					ft = replacetext(parsemarkdown_basic(ft), "\n", "<BR>")
					flavortext_display = ft
					to_chat(user, span_notice("Successfully updated flavortext"))
					log_game("[user] has set their flavortext'.")
				if("ooc_notes")
					to_chat(user, span_notice("["<span class='bold'>Do not put anything NSFW here. This feature is for stuff that wouldn't fit in the flavortext.</span>"]"))
					var/new_ooc_notes = input(user, "Input your OOC preferences:", "OOC notes", ooc_notes) as message|null
					if(new_ooc_notes == null)
						return
					if(new_ooc_notes == "")
						ooc_notes = null
						ooc_notes_display = null
						update_menu_data(user)
						return
					ooc_notes = new_ooc_notes

					var/ooc = ooc_notes
					ooc = html_encode(ooc)
					ooc = replacetext(parsemarkdown_basic(ooc), "\n", "<BR>")
					ooc_notes_display = ooc
					to_chat(user, span_notice("Successfully updated OOC notes."))
					log_game("[user] has set their OOC notes'.")
				if("ooc_preview")
					var/list/dat = list()
					if(is_valid_headshot_link(null, headshot_link, TRUE))
						dat += ("<div align='center'><img src='[headshot_link]' width='350px' height='350px'></div>")
					if(flavortext && flavortext_display)
						dat += "<div align='left' style='line-height: 1.2;'>[flavortext_display]</div>"
					if(ooc_notes && ooc_notes_display)
						dat += "<br>"
						dat += "<div align='center'><b>OOC notes</b></div>"
						dat += "<div align='left' style='line-height: 1.2;'>[ooc_notes_display]</div>"
					if(ooc_extra)
						dat += "[ooc_extra]"
					var/datum/browser/popup = new(user, "[real_name]", "<center>[real_name]</center>", width = 480, height = 700)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("ooc_extra")
					if(!donator)
						to_chat(user, "This is a donator exclusive feature, your OOC Extra link will be applied but others will only be able to view it if you are a patreon supporter or Twitch Subscriber.")

					to_chat(user, span_notice("Add a link from a suitable host (catbox, etc) to an mp3, mp4, or jpg / png file to have it embed at the bottom of your OOC notes."))
					to_chat(user, span_notice("If the link doesn't show up properly in-game, ensure that it's a direct link that opens properly in a browser."))
					to_chat(user, span_notice("Videos will be shrunk to a ~300x300 square. Keep this in mind."))
					to_chat(user, "<font color = '#d6d6d6'>Leave a single space to delete it from your OOC notes.</font>")
					to_chat(user, "<font color ='red'>Abuse of this will get you banned.</font>")
					var/new_extra_link = input(user, "Input the accessory link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "OOC Extra", ooc_extra_link) as text|null
					if(new_extra_link == null)
						return
					if(new_extra_link == "")
						new_extra_link = null
						update_menu_data(user)
						return
					if(new_extra_link == " ")	//Single space to delete
						ooc_extra_link = null
						ooc_extra = null
						to_chat(user, span_notice("Successfully deleted OOC Extra."))
					var/static/list/valid_extensions = list("jpg", "png", "jpeg", "gif", "mp4", "mp3")
					if(!is_valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
						new_extra_link = null
						update_menu_data(user)
						return

					var/list/value_split = splittext(new_extra_link, ".")

					// extension will always be the last entry
					var/extension = value_split[length(value_split)]
					var/info
					if(extension in valid_extensions)
						ooc_extra_link = new_extra_link
						ooc_extra = null
						ooc_extra = "<div align ='center'><center>"
						if(extension == "jpg" || extension == "png" || extension == "jpeg" || extension == "gif")
							ooc_extra += "<br>"
							ooc_extra += "<img src='[ooc_extra_link]'/>"
							info = "an embedded image."
						else
							switch(extension)
								if("mp4")
									ooc_extra = "<br>"
									ooc_extra += "<video width=["288"] height=["288"] controls=["true"]>"
									ooc_extra += "<source src='[ooc_extra_link]' type=["video/mp4"]>"
									ooc_extra += "</video>"
									info = "a video."
								if("mp3")
									ooc_extra = "<br>"
									ooc_extra += "<audio controls>"
									ooc_extra += "<source src='[ooc_extra_link]' type=["audio/mp3"]>"
									ooc_extra += "Your browser does not support the audio element."
									ooc_extra += "</audio>"
									info = "embedded audio."
						ooc_extra += "</center></div>"
						to_chat(user, span_notice("Successfully updated OOC Extra with [info]"))
						log_game("[user] has set their OOC Extra to '[ooc_extra_link]'.")
				if("s_tone")
					var/list/listy = pref_species.get_skin_list()
					var/new_s_tone = browser_input_list(user, "CHOOSE YOUR HERO'S [uppertext(pref_species.skin_tone_wording)]", "THE SUN", listy)
					if(new_s_tone)
						skin_tone = listy[new_s_tone]

				if("selected_accent")
					if(length(pref_species.multiple_accents))
						change_accent = TRUE
					else
						change_accent = FALSE
					if(!donator && !change_accent)
						to_chat(user, "Sorry, this option is Donator-exclusive or unavailable to your race.")
						selected_accent = ACCENT_DEFAULT
						return
					var/accent
					if(donator)
						accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", GLOB.accent_list, selected_accent)
						if(accent)
							selected_accent = accent
					else if(change_accent)
						accent = browser_input_list(user, "CHOOSE YOUR HERO'S ACCENT", "VOICE OF THE WORLD", pref_species.multiple_accents, selected_accent)
						if(accent)
							selected_accent = pref_species.multiple_accents[accent]
				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference", ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("asaycolor")
					var/new_asaycolor = input(user, "Choose your ASAY color:", "Game Preference", asaycolor) as color|null
					if(new_asaycolor)
						asaycolor = sanitize_ooccolor(new_asaycolor)
				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps. (0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						parent.fps = desiredfps

				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference", UI_style)  as null|anything in sortList(GLOB.available_ui_styles)
					if(pickedui)
						UI_style = "Rogue"
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))

				if("culture")
					var/list/cultures = list()
					for(var/culture_type in GLOB.culture_singletons)
						var/datum/culture/culture = GLOB.culture_singletons[culture_type]
						if(!culture.is_selectable(src))
							continue
						cultures[culture.name] += culture.type
					var/choice = browser_input_list(user, "CHOOSE YOUR HERO'S CULTURE", "CULTURE", cultures)
					if(!choice)
						return
					culture = cultures[choice]
					to_chat(user, span_notice("[culture::name]"))
					to_chat(user, span_notice("[culture::description]"))
		else
			switch(href_list["preference"])
				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Character Preference", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)
				if("gender")
					var/pickedGender = MALE
					if(gender == MALE)
						pickedGender = FEMALE
					if(pickedGender && pickedGender != gender)
						gender = pickedGender
						real_name = real_name = pref_species.random_name(gender,1)
						reset_jobs(user)
						randomise_appearance_prefs(RANDOMIZE_UNDERWEAR | RANDOMIZE_HAIRSTYLE)
						accessory = "Nothing"
						detail = "Nothing"
				if("domhand")
					if(domhand == 1)
						domhand = 2
					else
						domhand = 1
				if("bespecial")
					if(next_special_trait)
						print_special_text(user, next_special_trait)
						return
					to_chat(user, span_boldwarning("You will become special for one round, this could be something negative, positive or neutral and could have a high impact on your character and your experience. You cannot back out from or reroll this, and it will not carry over to other rounds."))
					if(!donator)
						to_chat(user, span_boldwarning("THIS COSTS 1 TRIUMPH"))
						if(user.get_triumphs() < 1)
							to_chat(user, span_bignotice("YOU DON'T HAVE ENOUGH TRIUMPHS."))
							return
					var/result = alert(user, "You'll receive a unique trait for one round\n You cannot back out from or reroll this.\nDo you really wish to [donator ? "" : "spend 1 triumph and " ]proceed?", "Be Special", "Yes", "No")
					if(result != "Yes")
						return
					if(!donator)
						user.adjust_triumphs(-1)
					if(next_special_trait)
						return
					next_special_trait = roll_random_special(user.client)
					if(next_special_trait)
						log_game("SPECIALS: Rolled [next_special_trait] for ckey: [user.ckey]")
						print_special_text(user, next_special_trait)
						user.playsound_local(user, 'sound/misc/alert.ogg', 100)
						to_chat(user, span_warning("This will be applied on your next game join."))
						to_chat(user, span_warning("You may switch your character and choose any role, if you don't meet the requirements (if any are specified) it won't be applied"))

				if("family")
					var/list/famtree_options_list = list(FAMILY_NONE, FAMILY_PARTIAL, FAMILY_NEWLYWED, FAMILY_FULL, "EXPLAIN THIS TO ME")
					var/new_family = browser_input_list(user, "SELECT YOUR HERO'S BOND", "BLOOD IS THICKER THAN WATER", famtree_options_list, family)
					if(new_family == "EXPLAIN THIS TO ME")
						to_chat(user, span_purple("\
						--[FAMILY_NONE] will disable this feature.<br>\
						--[FAMILY_PARTIAL] will assign you as a progeny of a local house based on your species. This feature will instead assign you as a aunt or uncle to a local family if your older than ADULT.<br>\
						--[FAMILY_NEWLYWED] assigns you a spouse without adding you to a family. Setspouse will prioritize pairing you with another newlywed with the same name as your setspouse.<br>\
						--[FAMILY_FULL] will attempt to assign you as matriarch or patriarch of one of the local houses of the kingdom/town. Setspouse will will prevent \
						players with the setspouse = None from matching with you unless their name equals your setspouse."))

					else if(new_family)
						family = new_family
				//Setspouse is part of the family subsystem. It will check existing families for this character and attempt to place you in this family.
				if("setspouse")
					var/newspouse = browser_input_text(user, "INPUT THE IDENTITY OF ANOTHER HERO", "TIL DEATH DO US PART")
					if(newspouse)
						setspouse = newspouse
					else
						setspouse = null
				//Gender_choice is part of the family subsytem. It will check existing families members with the same preference of this character and attempt to place you in this family.
				if("select_quirks")
					open_quirk_menu(user)

				if("gender_choice")
					// If pronouns are neutral, lock to ANY_GENDER
					if(pronouns == THEY_THEM || pronouns == IT_ITS)
						to_chat(user, span_warning("With neutral pronouns, you may only choose [ANY_GENDER]."))
						gender_choice = ANY_GENDER
					else
						var/list/gender_choice_option_list = list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER)
						var/new_gender_choice  = browser_input_list(user, "SELECT YOUR HERO'S PREFERENCE", "TO LOVE AND TO CHERISH", gender_choice_option_list, gender_choice)
						if(new_gender_choice)
							gender_choice = new_gender_choice
				if("alignment")
					var/new_alignment = browser_input_list(user, "SELECT YOUR HERO'S MORALITY", "CUT FROM THE SAME CLOTH", ALL_ALIGNMENTS_LIST, alignment)
					if(new_alignment)
						alignment = new_alignment
				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED]  input.text-color = #EEEEEE")
					else
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_DISABLED]  input.text-color = #ad9eb4")

				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing

				//here lies the badmins
				if("hear_adminhelps")
					user.client.toggleadminhelpsound()
				if("hear_prayers")
					user.client.toggle_prayer_sound()
				if("announce_login")
					user.client.toggleannouncelogin()
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("toggle_dead_chat")
					user.client.deadchat()
				if("toggle_radio_chatter")
					user.client.toggle_hear_radio()
				if("toggle_prayers")
					user.client.toggleprayers()
				if("toggle_deadmin_always")
					toggles ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					toggles ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					toggles ^= DEADMIN_POSITION_HEAD
				if("toggle_deadmin_security")
					toggles ^= DEADMIN_POSITION_SECURITY
				if("toggle_deadmin_silicon")
					toggles ^= DEADMIN_POSITION_SILICON


				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("toggle_random")
					var/random_type = href_list["random_type"]
					if(randomise[random_type])
						randomise -= random_type
					else
						randomise[random_type] = TRUE

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("ghost_ears")
					if(user.client?.holder)
						chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					if(user.client?.holder)
						chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					if(user.client?.holder)
						chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(parent && parent.screen && parent.screen.len)
						var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_above) in parent.screen
						PM.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.view_size.setDefault(getScreenSize(widescreenpref))

				if("pixel_size")
					switch(pixel_size)
						if(PIXEL_SCALING_AUTO)
							pixel_size = PIXEL_SCALING_1X
						if(PIXEL_SCALING_1X)
							pixel_size = PIXEL_SCALING_1_2X
						if(PIXEL_SCALING_1_2X)
							pixel_size = PIXEL_SCALING_2X
						if(PIXEL_SCALING_2X)
							pixel_size = PIXEL_SCALING_3X
						if(PIXEL_SCALING_3X)
							pixel_size = PIXEL_SCALING_AUTO
					user.client.view_size.apply() //Let's winset() it so it actually works

				if("scaling_method")
					switch(scaling_method)
						if(SCALING_METHOD_NORMAL)
							scaling_method = SCALING_METHOD_DISTORT
						if(SCALING_METHOD_DISTORT)
							scaling_method = SCALING_METHOD_BLUR
						if(SCALING_METHOD_BLUR)
							scaling_method = SCALING_METHOD_NORMAL
					user.client.view_size.setZoomMode()

				if("schizo_voice")
					toggles ^= SCHIZO_VOICE
					if(toggles & SCHIZO_VOICE)
						to_chat(user, "<span class='warning'>You are now a voice.\n\
										As a voice, you will receive meditations from players asking about game mechanics!\n\
										Good voices could be rewarded with PQ by staff for answering meditations, while bad ones are punished.</span>")
					else
						to_chat(user, span_warning("You are no longer a voice."))

				if("loreprimer")
					lore_popup(user)

				if("finished")
					user << browse(null, "window=latechoices") //closes late choices window
					user << browse(null, "window=playersetup") //closes the player setup window
					user << browse(null, "window=preferences") //closes job selection
					user << browse(null, "window=mob_occupation")
					user << browse(null, "window=latechoices") //closes late job selection
					user << browse(null, "window=migration") // Closes migrant menu

					SStriumphs.remove_triumph_buy_menu(user.client)

					winshow(user, "stonekeep_prefwin", FALSE)
					user << browse(null, "window=preferences_browser")
					user << browse(null, "window=lobby_window")
					return

				if("save")
					save_preferences()
					save_character()
					if(isnewplayer(user))
						var/mob/dead/new_player/player = user
						player.cache_multi_ready_characters()

				if("load")
					load_preferences()
					load_character()
					if(isnewplayer(user))
						var/mob/dead/new_player/player = user
						player.cache_multi_ready_characters()

				if("changeslot")
					selected_accent = ACCENT_DEFAULT
					var/list/choices = list()
					if(path)
						var/savefile/S = new /savefile(path)
						if(S)
							for(var/i=1, i<=max_save_slots, i++)
								var/name
								S.cd = "/character[i]"
								S["real_name"] >> name
								if(!name)
									name = "Slot[i]"
								choices[name] = i
					var/choice = browser_input_list(user, "WHO IS YOUR HERO?", "NECRA AWAITS", choices, real_name)
					if(choice)
						choice = choices[choice]
						if(!load_character(choice))
							randomise_appearance_prefs(include_donator = donator)
							save_character()

				if("randomiseappearanceprefs")
					randomise_appearance_prefs(include_donator = donator)
					customizer_entries = list()
					validate_customizer_entries()
					reset_all_customizer_accessory_colors()
					randomize_all_customizer_accessories()
					reset_jobs(user)

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

	update_menu_data(user)
	return 1



/// Sanitization checks to be performed before using these preferences.
/datum/preferences/proc/sanitize_chosen_prefs()
	if(!pref_species || !pref_species.preference_accessible(src))
		pref_species = new /datum/species/human/northern
		customizer_entries = list()
		validate_customizer_entries()
		save_character()

	if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == SPEC_ID_HUMEN))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

/// Applies the randomization prefs, sanitizes the result and then applies the preference to the human mob.
/// This is good if you are applying prefs to a mob as if they were joining the round.
/datum/preferences/proc/safe_transfer_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, is_antag = FALSE)
	apply_character_randomization_prefs(is_antag)
	sanitize_chosen_prefs()
	apply_prefs_to(character, icon_updates)

/// Applies the given preferences to a human mob. Calling this directly will skip sanitisation.
/// This is good if you are applying prefs to a mob as if you were cloning them.
/datum/preferences/proc/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	if(QDELETED(character) || !ishuman(character))
		return
	character.age = age
	character.gender = gender
	character.set_species(pref_species.type, icon_update = FALSE, pref_load = src)
	if(real_name in GLOB.chosen_names)
		character.real_name = pref_species.random_name(gender)
	else
		character.real_name = real_name
	character.name = character.real_name

	character.dna.features = features.Copy()
	character.dna.real_name = character.real_name

	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = eye_color
		organ_eyes.old_eye_color = eye_color

	character.skin_tone = skin_tone
	character.culture = GLOB.culture_singletons[culture]
	character.underwear = underwear
	character.undershirt = undershirt
	character.detail = detail
	character.socks = socks

	/* V: */

	character.headshot_link = headshot_link
	character.flavortext = flavortext
	character.flavortext_display = flavortext_display
	character.ooc_notes = ooc_notes
	character.ooc_notes_display = ooc_notes_display
	character.ooc_extra_link = ooc_extra_link
	character.ooc_extra = ooc_extra
	character.pronouns = pronouns
	character.voice_type = voice_type

	character.domhand = domhand
	character.voice_color = voice_color
	character.set_patron(selected_patron)
	character.familytree_pref = family
	character.gender_choice_pref = gender_choice
	character.setspouse = setspouse

	if(length(quirks))
		// ???
		var/obj/item/bodypart/O = character.get_bodypart(BODY_ZONE_R_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		O = character.get_bodypart(BODY_ZONE_L_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		character.regenerate_limb(BODY_ZONE_R_ARM)
		character.regenerate_limb(BODY_ZONE_L_ARM)
		apply_quirks_to_character(character)

	if(culinary_preferences)
		apply_culinary_preferences(character)

	if(parent)
		var/datum/role_bans/bans = get_role_bans_for_ckey(parent.ckey)
		for(var/datum/role_ban_instance/ban as anything in bans.bans)
			if(!ban.curses)
				continue
			for(var/curse_name as anything in ban.curses)
				var/datum/curse/curse = GLOB.curse_names[curse_name]
				character.add_curse(curse.type)

		apply_trait_bans(character, parent.ckey)

		if(is_misc_banned(parent.ckey, BAN_MISC_LEPROSY))
			ADD_TRAIT(character, TRAIT_LEPROSY, TRAIT_BAN_PUNISHMENT)
		if(is_misc_banned(parent.ckey, BAN_MISC_PUNISHMENT_CURSE))
			ADD_TRAIT(character, TRAIT_PUNISHMENT_CURSE, TRAIT_BAN_PUNISHMENT)

	if(pref_species.multiple_accents && length(pref_species.multiple_accents))
		change_accent = TRUE
	else
		change_accent = FALSE

	if(donator)
		character.accent = selected_accent
	if(change_accent && !donator)
		character.accent = selected_accent
		change_accent = FALSE

	/* :V */

	if(icon_updates)
		character.update_body()
		character.update_body_parts(redraw = TRUE)

/datum/preferences/proc/get_default_name(name_id)
	// you can use name_id to add more here
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "Choose your character's [namedata["qdesc"]]:","Character Preference") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' and .</font>")
			return
		else
			custom_names[name_id] = sanitized_name

/datum/preferences/proc/is_active_migrant()
	if(!migrant)
		return FALSE
	if(!migrant.active)
		return FALSE
	return TRUE

/datum/preferences/proc/allowed_respawn()
	if(!has_spawned)
		return TRUE
	if(is_misc_banned(parent.ckey, BAN_MISC_RESPAWN))
		return FALSE
	return TRUE

/datum/preferences/proc/get_ui_theme_stylesheet()
	switch(ui_theme)

		if(UI_PREFERENCE_LIGHT_MODE)

			. = {"
			<html>
			<head>
			  <style>
			    body {
			      background-color: #ffffff;
			      color: #000000;
			    }

			    a {
			      color: #1a0dab;
			    }

			    a:visited {
			      color: #660099;
			    }

			    hr {
			      border-top: 1px solid #ccc;
			    }
			  </style>
			</head>
			</html>
			"}

		if(UI_PREFERENCE_DARK_MODE)

			. = {"
			<html>
			<head>
			  <style>
			    body {
			      background-color: #121212;
			      color: #e0e0e0;
			    }
			    a {
			      color: #90caf9;
			    }
			    a:visited {
			      color: #ce93d8;
			    }
			    hr {
			      border-top: 1px solid #444;
			    }
			  </style>
			</head>
			</html>
			"}

/datum/preferences/proc/is_valid_headshot_link(mob/user, value, silent = FALSE, list/valid_extensions = list("jpg", "png", "jpeg", "gif"))
	var/static/list/allowed_hosts = list("i.gyazo.com", "a.l3n.co", "b.l3n.co", "c.l3n.co", "images2.imgbox.com", "thumbs2.imgbox.com", "files.catbox.moe")

	if(!length(value))
		return FALSE

	// Ensure link starts with "https://"
	if(findtext(value, "https://") != 1)
		if(!silent)
			to_chat(user, "<span class='warning'>Your link must be https!</span>")
		return FALSE

	// Extract domain from the URL
	var/start_index = length("https://") + 1
	var/end_index = findtext(value, "/", start_index)
	var/domain = (end_index ? copytext(value, start_index, end_index) : copytext(value, start_index))

	// Check if domain is in the allowed list
	if(!(domain in allowed_hosts))
		if(!silent)
			to_chat(user, "<span class='warning'>The image must be hosted on an approved site.</span>")
		return FALSE

	// Extract the filename and extension
	var/list/path_split = splittext(value, "/")
	var/filename = path_split[length(path_split)]
	var/list/file_parts = splittext(filename, ".")

	if(length(file_parts) < 2)
		return FALSE

	var/extension = file_parts[length(file_parts)]

	// Validate extension
	if(!(extension in valid_extensions))
		if(!silent)
			to_chat(user, "<span class='warning'>The image must be one of the following extensions: '[english_list(valid_extensions)]'</span>")
		return FALSE

	return TRUE


/datum/preferences/proc/set_loadout(mob/user, loadout_number, datum/loadout_item/loadout)
	if(!loadout)
		return
	if(!donator)
		to_chat(user, span_danger("This is a donator feature!"))
		return FALSE

	if(loadout == "None")
		vars["loadout[loadout]"] = null
		to_chat(user, span_notice("Who needs stuff anyway?"))
	else
		if(!(loadout in GLOB.loadout_items))
			return
		vars["loadout[loadout_number]"] = loadout
		to_chat(user, span_notice("[loadout.name]"))
		if(loadout.description)
			to_chat(user, "[loadout.description]")

/datum/preferences/proc/get_job_lock_html(datum/job/job, mob/user, used_name)
	var/player_species = user.client.prefs.pref_species.id
	var/fails_allowed = length(job.allowed_races) && !(player_species in job.allowed_races)
	var/fails_blacklist = length(job.blacklisted_species) && (player_species in job.blacklisted_species)
	if(job.required_playtime_remaining(user.client))
		var/list/lines = list()
		for(var/t in job.exp_requirements)
			var/needed = job.exp_requirements[t]
			var/have = user.client.calc_exp_type(t)
			lines += "[t]: [get_exp_format(have)] / [get_exp_format(needed)]"
		var/text = jointext(lines, "<br>")

		return make_lock_row(
			used_name,
			"\[TIME LOCK\]",
			"<b>Requirements:</b><br>[text]"
		)
	if(fails_allowed || fails_blacklist)
		if(!user.client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL))
			var/list/allowed_races = job.allowed_races.Copy()
			for(var/blacklist in job.blacklisted_species)
				allowed_races -= blacklist
			var/races_text = jointext(allowed_races, ", ")
			return make_lock_row(
				used_name,
				"\[SPECIES LOCK\]",
				"<b>Species Needed:</b><br>[races_text]"
			)
	if(length(job.allowed_ages) && !(user.client.prefs.age in job.allowed_ages))
		var/ages_text = jointext(job.allowed_ages, ", ")
		return make_lock_row(
			used_name,
			"\[AGE LOCK\]",
			"<b>Ages Needed:</b><br>[ages_text]"
		)
	if(length(job.allowed_sexes) && !(user.client.prefs.gender in job.allowed_sexes))
		var/sexes_text = jointext(job.allowed_sexes, ", ")
		return make_lock_row(
			used_name,
			"\[SEX LOCK\]",
			"<b>Sexes Needed:</b><br>[sexes_text]"
		)
	if(length(job.allowed_patrons) && !(user.client.prefs.selected_patron.type in job.allowed_patrons))
		var/list/patron_list = list()
		for(var/mult_patron in job.allowed_patrons)
			var/datum/patron/P = new mult_patron
			patron_list += (P.display_name ? P.display_name : P.name)
			qdel(P)
		var/patron_text = jointext(patron_list, ", ")

		return make_lock_row(
			used_name,
			"\[PATRON LOCK\]",
			"<b>Patron Needed:</b><br>[patron_text]"
		)
	// No lock
	return FALSE

/datum/preferences/proc/make_lock_row(used_name, lock_text, body_text)
	return {"
		[used_name]
	</td>
	<td>
		<div class='tutorialhover'>
			<font color=#a36c63>[lock_text]</font>
			<span class='tutorial'>[body_text]</span>
		</div>
	</td>
	</tr>
	"}

