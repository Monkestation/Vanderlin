/datum/admins/proc/Secrets()
	if(!check_rights(0))
		return

	var/list/dat = list("<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>")

	dat +={"
			<B>General Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=admin_log'>Admin Log</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=show_admins'>Show Admin List</A><BR>
			<BR>
			"}

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=clear_virus'>Cure all diseases currently in existence</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_bombers'>Bombing List</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_signalers'>Show last [length(GLOB.lastsignalers)] signalers</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_lawchanges'>Show last [length(GLOB.lawchanges)] law changes</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=showailaws'>Show AI Laws</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=showgm'>Show Game Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=manifest'>Show Crew Manifest</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=DNA'>List DNA (Blood)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=fingerprints'>List Fingerprints</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=ctfbutton'>Enable/Disable CTF</A><BR><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=tdomereset'>Reset Thunderdome to default state</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=night_shift_set'>Set Night Shift Mode</A><BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>Fun Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=monkey'>Turn all humans into monkeys</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=anime'>Chinese Cartoons</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=allspecies'>Change the species of all humans</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=power'>Make all areas powered</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=unpower'>Make all areas unpowered</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=quickpower'>Power all SMES</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=traitor_all'>Everyone is the traitor</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=guns'>Summon Guns</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=magic'>Summon Magic</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=events'>Summon Events (Toggle)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=onlyone'>There can only be one!</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=delayed_onlyone'>There can only be one! (40-second delay)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=stupidify'>Give all players brain damage</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=eagles'>Egalitarian Station Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=ancap'>Anarcho-Capitalist Station Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=blackout'>Break all lights</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=whiteout'>Fix all lights</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=customportal'>Spawn a custom portal storm</A><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=changebombcap'>Change bomb cap</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=masspurrbation'>Mass Purrbation</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=massremovepurrbation'>Mass Remove Purrbation</A><BR>
			"}

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>Security Level Elevated</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=infinite_sec'>Remove cap on security officers</A><BR>
			<BR>
			"}

	usr << browse(dat.Join(), "window=secrets")
	return





/datum/admins/proc/Secrets_topic(item,href_list)
	var/datum/round_event/E
	var/ok = 0
	switch(item)
		if("admin_log")
			var/dat = "<B>Admin Log<HR></B>"
			for(var/l in GLOB.admin_log)
				dat += "<li>[l]</li>"
			if(!GLOB.admin_log.len)
				dat += "No-one has done anything this round!"
			usr << browse(dat, "window=admin_log")

		if("show_admins")
			var/dat = "<B>Current admins:</B><HR>"
			if(GLOB.admin_datums)
				for(var/ckey in GLOB.admin_datums)
					var/datum/admins/D = GLOB.admin_datums[ckey]
					dat += "[ckey] - [D.rank.name]<br>"
				usr << browse(dat, "window=showadmins;size=600x500")
		if("night_shift_set")
			if(!check_rights(R_ADMIN))
				return
			var/val = alert(usr, "What do you want to set night shift to? This will override the automatic system until set to automatic again.", "Night Shift", "On", "Off", "Automatic")
			switch(val)
				if("Automatic")
					if(CONFIG_GET(flag/enable_night_shifts))
						SSnightshift.can_fire = TRUE
						SSnightshift.fire()
					else
						SSnightshift.update_nightshift(FALSE, TRUE)
				if("On")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(TRUE, TRUE)
				if("Off")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(FALSE, TRUE)

		if("list_bombers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Bombing List</B><HR>"
			for(var/l in GLOB.bombers)
				dat += text("[l]<BR>")
			usr << browse(dat, "window=bombers")

		if("list_signalers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing last [length(GLOB.lastsignalers)] signalers.</B><HR>"
			for(var/sig in GLOB.lastsignalers)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lastsignalers;size=800x500")

		if("list_lawchanges")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing last [length(GLOB.lawchanges)] law changes.</B><HR>"
			for(var/sig in GLOB.lawchanges)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lawchanges;size=800x500")
		if("showgm")
			if(!check_rights(R_ADMIN))
				return
			if(!SSticker.HasRoundStarted())
				alert("The game hasn't started yet!")
			else
				alert("The game mode is Storytellers")
		if("manifest")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing Crew Manifest.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th></tr>"
			for(var/datum/data/record/t in GLOB.data_core.general)
				dat += "<tr><td>[t.fields["name"]]</td><td>[t.fields["rank"]]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=manifest;size=440x410")
		if("DNA")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing DNA from blood.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
			for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna.human_blood_type]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=DNA;size=440x410")
		if("fingerprints")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing Fingerprints.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
			for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[md5(H.dna.unique_identity)]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=fingerprints;size=440x410")

		if("monkey")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Monkeyize All Humans"))
			for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
				INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon, monkeyize))
			ok = 1

		if("allspecies")
			if(!check_rights(R_FUN))
				return
			var/result = input(usr, "Please choose a new species","Species") as null|anything in GLOB.species_list
			if(result)
				SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Species Change", "[result]"))
				log_admin("[key_name(usr)] turned all humans into [result]", 1)
				message_admins("\blue [key_name_admin(usr)] turned all humans into [result]")
				var/newtype = GLOB.species_list[result]
				for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
					H.set_species(newtype)
		if("changebombcap")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Bomb Cap"))

			var/newBombCap = input(usr,"What would you like the new bomb cap to be. (entered as the light damage range (the 3rd number in common (1,2,3) notation)) Must be above 4)", "New Bomb Cap", GLOB.MAX_EX_LIGHT_RANGE) as num|null
			if (!CONFIG_SET(number/bombcap, newBombCap))
				return

			message_admins("<span class='boldannounce'>[key_name_admin(usr)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]</span>")
			log_admin("[key_name(usr)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]")

		if("blackout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Break All Lights"))
			message_admins("[key_name_admin(usr)] broke all lights")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.break_light_tube()

		if("anime")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Pawsitively Purrfect"))
			message_admins("[key_name_admin(usr)] made everyone purrfect.")
			for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
				SEND_SOUND(H, sound('sound/blank.ogg'))

				if(H.dna.species.id == SPEC_ID_HUMEN)
					if(H.dna.features["tail_human"] == "None" || H.dna.features["ears"] == "None")
						var/obj/item/organ/ears/cat/ears = new
						var/obj/item/organ/tail/cat/tail = new
						ears.Insert(H, drop_if_replaced=FALSE)
						tail.Insert(H, drop_if_replaced=FALSE)
					var/list/honorifics = list("[MALE]" = list("kun"), "[FEMALE]" = list("chan","tan"), "[NEUTER]" = list("san"), "[PLURAL]" = list("san")) //John Robust -> Robust-kun
					var/list/names = splittext(H.real_name," ")
					var/forename = names.len > 1 ? names[2] : names[1]
					var/newname = "[forename]-[pick(honorifics["[H.gender]"])]"
					H.fully_replace_character_name(H.real_name,newname)
				else
					to_chat(H, "<span class='warning'>You're not purrfect enough for this!</span>")

		if("whiteout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Fix All Lights"))
			message_admins("[key_name_admin(usr)] fixed all lights")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.fix()

		if("stupidify")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Braindamage"))
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				to_chat(H, "<span class='boldannounce'>I suddenly feel stupid.</span>")
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60, 80)
			message_admins("[key_name_admin(usr)] made everybody stupid (Mass Braindamage)")

		if("ancap")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Anarcho-capitalist Station"))
			SSeconomy.full_ancap = !SSeconomy.full_ancap
			message_admins("[key_name_admin(usr)] toggled Anarcho-capitalist mode")
			if(SSeconomy.full_ancap)
				priority_announce("The NAP is now in full effect.", null, 'sound/blank.ogg')
			else
				priority_announce("The NAP has been revoked.", null, 'sound/blank.ogg')

	if(E)
		E.processing = FALSE
		if(E.announceWhen>0)
			switch(alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No", "Cancel"))
				if("Yes")
					E.announceChance = 100
				if("Cancel")
					E.kill()
					return
				if("No")
					E.announceChance = 0
		E.processing = TRUE
	if (usr)
		log_admin("[key_name(usr)] used secret [item]")
		if (ok)
			to_chat(world, text("<B>A secret has been activated by []!</B>", usr.key))

/proc/portalAnnounce(announcement, playlightning)
	set waitfor = 0
	if (playlightning)
		sound_to_playing_players('sound/blank.ogg')
		sleep(80)
	priority_announce(replacetext(announcement, "%STATION%", station_name()))
	if (playlightning)
		sleep(20)
		sound_to_playing_players('sound/blank.ogg')

/proc/doPortalSpawn(turf/loc, mobtype, numtospawn, portal_appearance, players, humanoutfit)
	for (var/i in 1 to numtospawn)
		var/mob/spawnedMob = new mobtype(loc)
		if (length(players))
			var/mob/chosen = players[1]
			if (chosen.client)
				chosen.client.prefs.safe_transfer_prefs_to(spawnedMob)
				spawnedMob.key = chosen.key
			players -= chosen
		if (ishuman(spawnedMob) && ispath(humanoutfit, /datum/outfit))
			var/mob/living/carbon/human/H = spawnedMob
			H.equipOutfit(humanoutfit)
	var/turf/T = get_step(loc, SOUTHWEST)
	flick_overlay_static(portal_appearance, T, 15)
	playsound(T, 'sound/blank.ogg', rand(80, 100), TRUE)
