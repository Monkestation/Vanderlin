/datum/migrant_pref
	/// Reference to our prefs
	var/datum/preferences/prefs
	/// Whether the user wants to be a migrant
	var/active = FALSE
	/// Role preferences of the user, the things he clicks on to be preferred to be
	var/list/role_preferences = list()
	///are we viewing the page?
	var/viewer = FALSE

/datum/migrant_pref/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/migrant_pref/proc/set_active(new_state, silent = FALSE)
	if(active == new_state)
		return
	if((new_state == TRUE) && SSmigrants.admin_disabled)
		to_chat(prefs.parent, span_boldwarning("Migration is disabled!"))
		return
	role_preferences.Cut()
	active = new_state
	if(!silent && prefs.parent)
		if(new_state)
			to_chat(prefs.parent, span_notice("You are now in the migrant queue, and will join the game with them when they arrive"))
		else
			to_chat(prefs.parent, span_boldwarning("You are no longer in the migrant queue"))

/datum/migrant_pref/proc/toggle_role_preference(role_type)
	if(!active)
		set_active(TRUE)
	if(role_type in role_preferences)
		role_preferences -= role_type
		return
	role_preferences.Cut()
	if(SSmigrants.can_be_role(prefs.parent, role_type))
		role_preferences += role_type
		var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
		to_chat(prefs.parent, span_nicegreen("You have prioritized the [role.name]. This does not guarantee getting the role"))

/datum/migrant_pref/proc/post_spawn()
	set_active(FALSE, TRUE)
	hide_ui()

/datum/migrant_pref/proc/build_html_data()
	var/client/client = prefs.parent
	if(!client)
		return

	var/current_migrants = SSmigrants.get_active_migrant_amount()
	var/list/main_dat = list()

	if(SSmigrants.admin_disabled)
		main_dat += "<center> <h1> <b style='color:red;'> Migration has been disabled by an admin! </b>  </h1> </center>"
		return main_dat

	var/player_triumph = SStriumphs.get_triumphs(client.ckey)

	// Build main content (left side)
	main_dat += "<div style='padding: 10px;'>"
	main_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px;'>WAVE: \Roman[SSmigrants.wave_number] | TRIUMPH: [player_triumph]</div>"
	main_dat += "<div style='text-align: center; margin-bottom: 10px;'><b>BE A MIGRANT: <a href='byond://?src=[REF(src)];task=toggle_active'>[active ? "YES" : "NO"]</a></b></div>"
	main_dat += "<div style='text-align: center; margin-bottom: 15px;'>Wandering fools: [current_migrants ? "\Roman[current_migrants]" : "None"]</div>"

	if(!SSmigrants.current_wave)
		main_dat += "<div style='text-align: center; margin-bottom: 15px;'>The mist will clear out of the way in [(SSmigrants.time_until_next_wave / (1 SECONDS))] seconds...</div>"
	else
		var/datum/migrant_wave/wave = MIGRANT_WAVE(SSmigrants.current_wave)
		main_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px;'>[wave.name]</div>"
		main_dat += "<div style='text-align: center; margin-bottom: 10px;'>[wave.greet_text]</div>"

		// Show if this wave was triumph-influenced
		if(wave.triumph_total > 0)
			var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0
			if(player_contribution > 0)
				main_dat += "<div style='text-align: center; color: cyan; margin-bottom: 10px;'>You influenced this wave! ([player_contribution] triumph)</div>"
			else
				main_dat += "<div style='text-align: center; color: yellow; margin-bottom: 10px;'>This wave was influenced by triumph!</div>"

		for(var/role_type in wave.roles)
			var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
			var/role_amount = wave.roles[role_type]
			var/role_name = role.name
			if(active  && (role_type in role_preferences))
				role_name = "<u><b>[role_name]</b></u>"
			var/stars_amount = SSmigrants.get_stars_on_role(role_type)
			var/stars_string = ""
			if(stars_amount)
				stars_string = "(*\Roman[stars_amount])"

			// Show triumph bonus for selection
			var/triumph_bonus = SSmigrants.get_triumph_selection_bonus(client, SSmigrants.current_wave)
			var/triumph_bonus_string = ""
			if(triumph_bonus > 0)
				triumph_bonus_string = " <span style='color: gold;'>(+[triumph_bonus])</span>"

			main_dat += "<div style='text-align: center; margin: 5px 0;'><a href='byond://?src=[REF(src)];task=toggle_role_preference;role=[role_type]'>[role_name]</a> - \Roman[role_amount] [stars_string][triumph_bonus_string]</div>"
		main_dat += "<div style='text-align: center; margin-top: 15px;'>They will arrive in [(SSmigrants.wave_timer / (1 SECONDS))] seconds...</div>"

	main_dat += "</div>"

	// Build wave influence sidebar (right side)
	var/list/sidebar_dat = list()
	sidebar_dat += "<div style='padding: 10px; background-color: #1a1a1a; height: 100%; overflow-y: auto;' id='wave-sidebar'>"
	sidebar_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px; color: #cccccc;'>WAVE INFLUENCE</div>"

	// Calculate total weights for percentage calculation
	var/list/wave_weights = list()
	var/total_weight = 0
	var/list/available_waves = SSmigrants.get_influenceable_waves()

	for(var/wave_type in available_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		var/weight = SSmigrants.calculate_triumph_weight(wave)
		wave_weights[wave_type] = weight
		total_weight += weight

	for(var/wave_type in available_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		var/triumph_display = "[wave.triumph_total]/[wave.triumph_threshold]"
		var/threshold_reached = wave.triumph_total >= wave.triumph_threshold
		var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0

		// Check if wave has hit max spawns
		var/is_maxed_out = FALSE
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(SSmigrants.spawned_waves[used_wave_type] && SSmigrants.spawned_waves[used_wave_type] >= wave.max_spawns)
				is_maxed_out = TRUE

		var/wave_color = "#ffffff"
		var/wave_name = wave.name
		if(is_maxed_out)
			wave_color = "#666666"
			wave_name = "[wave.name] (MAXED)"
		else if(threshold_reached)
			wave_color = "gold"
			wave_name = "[wave.name] (READY!)"
		else if(player_contribution > 0)
			wave_color = "cyan"
			wave_name = "[wave.name] ([player_contribution])"

		// Progress bar
		var/progress_percent = min((wave.triumph_total / wave.triumph_threshold) * 100, 100)

		// Calculate roll percentage
		var/roll_percentage = 0
		if(is_maxed_out)
			roll_percentage = "0% (Maxed)"
		else if(threshold_reached)
			roll_percentage = "100% (Guaranteed)"
		else if(total_weight > 0)
			var/wave_weight = wave_weights[wave_type]
			roll_percentage = "[round((wave_weight / total_weight) * 100, 0.1)]%"
		else
			roll_percentage = "0%"

		sidebar_dat += "<div style='margin-bottom: 12px; padding: 8px; border: 1px solid #444; border-radius: 4px;' title='Roll Chance: [roll_percentage] (Base: [wave.weight], Triumph: +[wave.triumph_total * 2])'>"
		sidebar_dat += "<div style='color: [wave_color]; font-weight: bold; margin-bottom: 4px;'>[wave_name]</div>"
		sidebar_dat += "<div style='background-color: #333; height: 12px; border-radius: 6px; margin-bottom: 4px;'>"
		sidebar_dat += "<div style='background-color: [threshold_reached ? "gold" : (is_maxed_out ? "#666666" : "cyan")]; height: 100%; width: [progress_percent]%; border-radius: 6px;'></div>"
		sidebar_dat += "</div>"
		sidebar_dat += "<div style='display: flex; justify-content: space-between; align-items: center; font-size: 12px;'>"
		sidebar_dat += "<span>[triumph_display]</span>"

		// Only show contribution button if wave isn't maxed out
		if(!is_maxed_out)
			sidebar_dat += "<a href='byond://?src=[REF(src)];task=contribute_triumph;wave=[wave_type]' style='background-color: #4a4a4a; color: white; text-decoration: none; padding: 2px 6px; border-radius: 3px; font-size: 11px;'>+T</a>"
		else
			sidebar_dat += "<span style='background-color: #333; color: #666; padding: 2px 6px; border-radius: 3px; font-size: 11px;'>MAX</span>"

		sidebar_dat += "</div>"
		sidebar_dat += "</div>"

	sidebar_dat += "</div>"

	// Combine into two-column layout
	var/list/dat = list()
	dat += {"<style>
		body { margin: 0; padding: 0; font-family: monospace; background-color: #2a2a2a; color: #ffffff; }
		.container { display: flex; height: 100vh; }
		.main-content { flex: 1; overflow-y: auto; }
		.sidebar { width: 280px; border-left: 1px solid #444; }
		a { color: #88aaff; }
		a:hover { color: #aaccff; }

		/* Tooltip styling */
		\[title\] {
			position: relative;
			cursor: help;
		}

		\[title\]:hover::after {
			content: attr(title);
			position: absolute;
			bottom: 100%;
			left: 50%;
			transform: translateX(-50%);
			background-color: #1a1a1a;
			color: #ffffff;
			padding: 8px 12px;
			border-radius: 6px;
			white-space: nowrap;
			font-size: 12px;
			border: 1px solid #555;
			z-index: 1000;
			box-shadow: 0 2px 8px rgba(0,0,0,0.3);
		}

		\[title\]:hover::before {
			content: '';
			position: absolute;
			bottom: 100%;
			left: 50%;
			transform: translateX(-50%) translateY(1px);
			border: 5px solid transparent;
			border-top-color: #555;
			z-index: 1000;
		}
	</style>
	<div class='container'>
		<div class='main-content' id='main-content'>
			[main_dat.Join()]
		</div>
		<div class='sidebar'>
			[sidebar_dat.Join()]
		</div>
	</div>
	<script>
		// Cookie functions
		function setCookie(name, value, days) {
			var expires = "";
			if (days) {
				var date = new Date();
				date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
				expires = "; expires=" + date.toUTCString();
			}
			document.cookie = name + "=" + (value || "") + expires + "; path=/";
		}

		function getCookie(name) {
			var nameEQ = name + "=";
			var ca = document.cookie.split(';');
			for(var i = 0; i < ca.length; i++) {
				var c = ca\[i\];
				while (c.charAt(0) == ' ') c = c.substring(1, c.length);
				if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
			}
			return null;
		}

		// Restore scroll position from cookie
		var mainContent = document.getElementById('main-content');
		var sidebar = document.getElementById('wave-sidebar');

		if(mainContent) {
			var savedScroll = getCookie('migrant_scroll');
			if(savedScroll) {
				mainContent.scrollTop = parseInt(savedScroll);
			}

			// Save scroll position to cookie when scrolling
			mainContent.addEventListener('scroll', function() {
				setCookie('migrant_scroll', this.scrollTop, 1); // Save for 1 day
			});
		}

		if(sidebar) {
			var savedSidebarScroll = getCookie('migrant_sidebar_scroll');
			if(savedSidebarScroll) {
				sidebar.scrollTop = parseInt(savedSidebarScroll);
			}

			// Save sidebar scroll position too
			sidebar.addEventListener('scroll', function() {
				setCookie('migrant_sidebar_scroll', this.scrollTop, 1);
			});
		}
	</script>"}


	return dat

/datum/migrant_pref/proc/show_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	var/list/dat = list()
	dat = build_html_data()

	var/datum/browser/popup = new(client.mob, "migration", "<center>Find a purpose</center>", 650, 500, src)
	popup.set_content(dat.Join())
	popup.open()
	client.prefs.migrant.viewer = TRUE

/datum/migrant_pref/Topic(href, href_list)
	var/client/client = prefs.parent
	if(!client)
		return

	if(href_list["close"])
		if(active)
			client.prefs.migrant.set_active(FALSE)
		hide_ui()
		return

	switch(href_list["task"])
		if("toggle_active")
			set_active(!active)
		if("toggle_role_preference")
			var/role_type = text2path(href_list["role"])
			toggle_role_preference(role_type)
		if("contribute_triumph")
			var/wave_type = text2path(href_list["wave"])
			handle_triumph_contribution(wave_type)
	show_ui()

/datum/migrant_pref/proc/handle_triumph_contribution(wave_type)
	var/client/client = prefs.parent
	if(!client)
		return

	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return

	var/current_triumph = SStriumphs.get_triumphs(client.ckey)
	if(current_triumph <= 0)
		to_chat(client, span_warning("You don't have any triumph to contribute!"))
		return

	var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0
	var/max_contribute = min(current_triumph, 25) // Cap individual contributions

	var/amount = input(client, "Contribute triumph to '[wave.name]'?\n\nYour triumph: [current_triumph]\nYour contribution: [player_contribution]\nWave total: [wave.triumph_total]/[wave.triumph_threshold]\n\nAmount to contribute (1-[max_contribute]):", "Triumph Contribution") as null|num

	if(!amount || amount <= 0 || amount > max_contribute)
		return

	SSmigrants.contribute_triumph_to_wave(client, wave_type, amount)

/datum/migrant_pref/proc/hide_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	client.mob << browse(null, "window=migration")
	client.prefs.migrant.viewer = FALSE

/mob/living/carbon/human/proc/adv_hugboxing_start()
	to_chat(src, span_warning("I will be in danger once I start moving."))
	status_flags |= GODMODE
	ADD_TRAIT(src, TRAIT_PACIFISM, "hugbox")
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(adv_hugboxing_moved), TRUE)
	//Lies, it goes away even if you don't move after enough time
	if(GLOB.adventurer_hugbox_duration_still)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration_still)

/mob/living/carbon/human/proc/adv_hugboxing_moved()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	to_chat(src, span_danger("I have [DisplayTimeText(GLOB.adventurer_hugbox_duration)] to begone!"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration)

/mob/living/carbon/human/proc/adv_hugboxing_end()
	if(QDELETED(src))
		return
	//hugbox already ended
	if(!(status_flags & GODMODE))
		return
	status_flags &= ~GODMODE
	REMOVE_TRAIT(src, TRAIT_PACIFISM, "hugbox")
	to_chat(src, span_danger("My joy is gone! Danger surrounds me."))

/mob/living/carbon/human/proc/adv_hugboxing_cancel()
	adv_hugboxing_end()
	SSrole_class_handler.cancel_class_handler(src)
