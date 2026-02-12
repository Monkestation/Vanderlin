/client/proc/cmd_admin_drop_everything(mob/M in GLOB.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		if(!M.dropItemToGround(W))
			qdel(W)
			M.regenerate_icons()

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	var/msg = "[key_name_admin(usr)] made [ADMIN_LOOKUPFLW(M)] drop everything!"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Everything") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_subtle_message(mob/target in GLOB.mob_list)
	set category = "GameMaster.Gods"
	set name = "Subtle Message"

	if(!ismob(target))
		return FALSE
	if(!check_rights(R_ADMIN))
		return FALSE
	var/mob/user = usr
	var/message

	message_admins("[key_name_admin(user)] has started talking into [ADMIN_LOOKUPFLW(target)]'s head.")
	var/option = alert(user, "What type of SubtlePM do you want?", "Type", "Voice", "Specific God")
	switch(option)
		if("Voice")
			message = input("Message:", text("Subtle PM to [target.key]")) as text|null
			if(!message)
				message_admins("[key_name_admin(user)] decided not to talk into [ADMIN_LOOKUPFLW(target)]'s head")
				return FALSE
			to_chat(target, span_big("[span_abductor("I hear a voice in my head...")] [span_mind_control(message)]"))

		if("Specific God")
			var/list/god_options = list("Generic")
			var/chosen_god
			var/volume = "Normal"
			var/first_time_message
			for(var/patron in COLORFUL_PATRONS)
				if(patron in god_options)
					continue
				god_options += patron
			chosen_god = browser_input_list(user, "Which god?", "God", god_options, "CANCEL", 20 SECONDS)
			if(!chosen_god || (chosen_god == "CANCEL"))
				message_admins("[key_name_admin(user)] decided not to talk into [ADMIN_LOOKUPFLW(target)]'s head")
				return FALSE

			var/first_time = alert(user, "Send a god unique 'feelings' message first?", "Atmosphere", "Yes", "No")
			if(first_time == "Yes")
				first_time_message = get_god_atmosphere_message(chosen_god)
			volume = alert(user, "How loud (big) should your message be?", "Volume", "Normal", "Loud", "Quiet")
			message = input(user, "What will [chosen_god] say?", "Speak for [chosen_god]") as text|null
			if(!message)
				message_admins("[key_name_admin(user)] decided not to talk into [ADMIN_LOOKUPFLW(target)]'s head")
				return FALSE

			if(first_time && first_time_message)
				to_chat(target, SPAN_GOD_FIRST_FEEL(first_time_message))
				message_admins("<span class='adminnotice'><b> SubtleMessage: [key_name_admin(user)] -> [key_name_admin(target)] :</b> [first_time_message]</span>")
			message = "<span class='god_[ckey(chosen_god)]'>[message]</span>"
			switch(volume)
				if("Loud")
					message = SPAN_GOD_LOUD(message)
				if("Quiet")
					message = SPAN_GOD_QUIET(message)
			message = SPAN_PRAYER_WRAPPER(message)
			to_chat(target, "[span_abductor("I hear a voice in my head...")] [message]")
		else
			message_admins("[key_name_admin(user)] decided not to talk into [ADMIN_LOOKUPFLW(target)]'s head")
			return FALSE

	SEND_SOUND(user.client, 'sound/misc/yeoldebwoink.ogg')
	target.playsound_local(soundin = 'sound/misc/yeoldebwoink.ogg', vol = 100)

	log_admin("SubtlePM: [key_name(user)] -> [key_name(target)] : [message]")
	message = "<span class='adminnotice'><b> SubtleMessage: [key_name_admin(user)] -> [key_name_admin(target)] :</b> [message]</span>"
	message_admins(message)
	admin_ticket_log(target, message)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Subtle Message") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/get_god_atmosphere_message(chosen_god)
	var/atmosphere_message
	switch(chosen_god)
		if("Astrata")
			atmosphere_message = SPAN_GOD_ASTRATA("Your body feels warm… it’s as if the sun itself were beaming against your skull… amidst this sensation, the voice of a woman, authoritative, radiant, demanding absolute attention, brands itself in your head.")
		if("Noc")
			atmosphere_message = SPAN_GOD_NOC("Symbols dance in the corner of your vision. For a moment, you are enlightened.. Your mind is imprinted with runes. You are able to decipher the voice of a man. Formal, contemplative, perhaps a little haughty even.")
		if("Abyssor")
			atmosphere_message = SPAN_GOD_ABYSSOR("The rumbling of clouds, the crashing of waves, the smell of salt. You are flooded with a sensation that you could only describe as being lost at sea… the crackling lightning above gives way to a voice. Disgruntled, weary and drowned, the words that you can make out are spoken in a gruff tone.")
		if("Dendor")
			atmosphere_message = SPAN_GOD_DENDOR("The chatter and sounds around you fade into an ambience… Your ears pick up wolves growling, chirping of birds… even the faintest movements of the trees swaying with the wind. A peaceful meditation, violently interrupted several loud thuds. The rustling of the leaves speak in a gravelly voice. Indignant and brittle, as if on the verge of snapping like a twig.")
		if("Ravox")
			atmosphere_message = SPAN_GOD_RAVOX("A sudden rush of righteousness usurps your emotions, the clashing of blades, the symphony of steel on steel. But just abruptly, it fades into a harsh pain of faded glory. As if nostalgia had plunged it dagger into your chest. With a hoarse, mournful yet solemn tone, Justice speaks to you.")
		if("Malum")
			atmosphere_message = SPAN_GOD_MALUM("Your perspective abruptly shifts on the world. Every wall, every gate, even the pavement you’d walk onto clicks to you. The whole world is a big puzzle, a feat of engineering to the inspired mind. Your mind races with ideas, striking you with plan after plan. A loud sizzle snaps you out of this trance, someone speaks to you in a tempered, detached voice, with few words. Direct, and to the point, as if preoccupied with something.")
		if("Eora")
			atmosphere_message = SPAN_GOD_EORA("All manner of troubles seem to evaporate. Everyone, everything around you appeals to have grown softer, more docile. A comfort akin to a mother tucking in her child, your worries are hushed away for now. Amidst this dreamy state, a soft-spoken, appeasing voice cradles your mind. Her tone is compassionate, as if she were right there with you.")
		if("Xylix")
			atmosphere_message = SPAN_GOD_XYLIX("Life is so comical… the drama you will cause will be astronomical! Wouldn’t you just love a show, you should’ve been laughing five minutes ago! The air is light and witty, you begin to truly enjoy this city… Ambiguous is this voice… festive,whimsical, and carefree.. The peak of free choice!")
		if("Pestra")
			atmosphere_message = SPAN_GOD_PESTRA("The body works in curious ways, in fact, have you ever truly taken a moment to question it? A balance of humors, substances flow through the veins, alchemical agents to modify the parameters of your biology. Yet ponder more, if you were to delve into this, you’d at least need a notebook and a few samples to compare. Pensive, hypercritical, and apathetic, she speaks as if this were an examination.")
		if("Necra")
			atmosphere_message = SPAN_GOD_NECRA("Remember you must die. All things will come to an end. It is a grim thought, but not without its merits. In fact, it brings some peace knowing there is a place to look forward to. It is a cold thought, like the breeze of autumn after a long summer. Stillness is in the air. Silence and Serenity. The disembodied voice that follows does not break this silence, it harmonizes with it.  Sedative, ancient, and steady, her message to you is in whispers")
		if("Matthios")
			atmosphere_message = SPAN_GOD_MATTHIOS("A distant coin rolls. You hear it inching every closer to you… until you can only focus on it. It rolls down the split of your mind using the groves within your brain as a path until it stops with a sharp clink. Ideations of wealth beyond measure, yours for the taking, only disturbed by the chuckling of a man. He speaks with many pauses… a trial of your patience, with taunting chuckles between every phrase. Cunning and almost condescending, his breathy voice pings your ears.")
		if("Baotha")
			atmosphere_message = SPAN_GOD_BAOTHA("You feel a sudden drain on your body, it is soothing… as if your troubles have been uplifted, replaced by an ever-sweet ecstasy. All the world seems colorful, vibrant, exciting. You must experience it all, you must live in the moment and relish all it has to offer you. A feminine, honey voice woman hums in your mind. She sounds silvery, and singsong, an addicting melody like a siren.")
		if("Graggar")
			atmosphere_message = SPAN_GOD_GRAGGAR("Your heart begins to race. Blood rushes to your head. Your hands clench into a fist, a rhythmic thumping takes over your hearing. Your eyes narrow down on everything, everyone. You size them all up. There is some primal and feral urge to fight, to shout, to let loose. You can hardly keep your body from lurching forward. As you tremble with the sudden surge of adrenaline, a deep guttural laugh. He roars, a raucous, abrasive and brash voice follows.")
		if("Zizo")
			atmosphere_message = SPAN_GOD_ZIZO("A swirl of shadows overtake your senses, the sphere that is your mind is penetrated and swallowed whole. You are lost in the dark, engulfed and surrounded. As if entombed in a vast void of nothingness. A purple light flickers in your vision, profane, offering no comfort from the dark, however drawing your attention. The voice of a woman, sharp, conceitful, and ensnaring. Her voice is ephemeral, and ghastly. A coldness takes hold of you, bone-chilling and black as death. When she speaks, a shiver runs down your spine.")
	return SPAN_PRAYER_WRAPPER(atmosphere_message)

/client/proc/cmd_admin_mod_antag_rep(client/C in GLOB.clients, operation)
	set category = "GameMaster"
	set name = "Modify Antagonist Reputation"

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""

	if(operation == "zero")
		log_text = "Set to 0"
		SSpersistence.antag_rep -= C.ckey
	else
		var/prompt = "Please enter the amount of reputation to [operation]:"

		if(operation == "set")
			prompt = "Please enter the new reputation value:"

		msg = input("Message:", prompt) as num|null

		if (!msg)
			return

		var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

		if(operation == "set")
			log_text = "Set to [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(0, min(msg, ANTAG_REP_MAXIMUM))
		else if(operation == "add")
			log_text = "Added [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = min(SSpersistence.antag_rep[C.ckey]+msg, ANTAG_REP_MAXIMUM)
		else if(operation == "subtract")
			log_text = "Subtracted [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(SSpersistence.antag_rep[C.ckey]-msg, 0)
		else
			to_chat(src, "Invalid operation for antag rep modification: [operation] by user [key_name(usr)]")
			return

		if(SSpersistence.antag_rep[C.ckey] <= 0)
			SSpersistence.antag_rep -= C.ckey

	log_admin("[key_name(usr)]: Modified [key_name(C)]'s antagonist reputation [log_text]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)]: Modified [key_name(C)]'s antagonist reputation ([log_text])</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Antagonist Reputation") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate()
	set category = "GameMaster.Narrate"
	set name = "Global Narrate"

	if(!check_rights(R_ADMIN))
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text|null

	if (!msg)
		return
	to_chat(world, "[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] Sent a global narrate</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Global Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/send_to_cryo(mob/M in GLOB.mob_list)
	set category = "Admin.Admin"
	set name = "Send To Cryo"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = input("Send who?", "Active Players") as null|anything in GLOB.player_list

	if(!M)
		return
	var/message_to_admins = span_adminnotice("<b> [key_name(usr)] has sent ([M.name]/[M.key]):</b> to cryo. <BR>")
	var/message_to_admin_user = span_notice(cryo_mob(M, TRUE))

	to_chat(src, message_to_admin_user)
	log_admin(message_to_admins)
	message_admins(message_to_admins)
	admin_ticket_log(M, message_to_admins)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Send To Cryo") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(mob/M)
	set category = "GameMaster.Narrate"
	set name = "Direct Narrate"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = input("Direct narrate to whom?", "Active Players") as null|anything in GLOB.player_list

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text|null

	if( !msg )
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = "<span class='adminnotice'><b> DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):</b> [msg]<BR></span>"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Direct Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_local_narrate(atom/A)
	set category = "GameMaster.Narrate"
	set name = "Local Narrate"

	if(!check_rights(R_ADMIN))
		return
	if(!A)
		return
	var/range = input("Range:", "Narrate to mobs within how many tiles:", 7) as num|null
	if(!range)
		return
	var/msg = input("Message:", text("Enter the text you wish to appear to everyone within view:")) as text|null
	if (!msg)
		return
	for(var/mob/M in view(range,A))
		to_chat(M, msg)

	log_admin("LocalNarrate: [key_name(usr)] at [AREACOORD(A)]: [msg]")
	message_admins("<span class='adminnotice'><b> LocalNarrate: [key_name_admin(usr)] at [ADMIN_VERBOSEJMP(A)]:</b> [msg]<BR></span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Local Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M in GLOB.mob_list)
	set category = "GameMaster.Fun"
	set name = "Godmode"
	if(!check_rights(R_ADMIN))
		return

	M.status_flags ^= GODMODE
	to_chat(usr, "<span class='adminnotice'>Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]</span>")

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	var/msg = "[key_name_admin(usr)] has toggled [ADMIN_LOOKUPFLW(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Godmode", "[M.status_flags & GODMODE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/proc/cmd_admin_mute(whom, mute_type, automute = 0)
	if(!whom)
		return

	var/muteunmute
	var/mute_string
	var/feedback_string
	switch(mute_type)
		if(MUTE_IC)
			mute_string = "IC (say and emote)"
			feedback_string = "IC"
		if(MUTE_OOC)
			mute_string = "OOC"
			feedback_string = "OOC"
		if(MUTE_LOOC)
			mute_string = "LOOC"
			feedback_string = "LOOC"
		if(MUTE_PRAY)
			mute_string = "pray"
			feedback_string = "Pray"
		if(MUTE_ADMINHELP)
			mute_string = "adminhelp, admin PM and ASAY"
			feedback_string = "Adminhelp"
		if(MUTE_DEADCHAT)
			mute_string = "deadchat and DSAY"
			feedback_string = "Deadchat"
		if(MUTE_MEDITATE)
			mute_string = "meditate"
			feedback_string = "Meditate"
		if(MUTE_ALL)
			mute_string = "everything"
			feedback_string = "Everything"
		else
			return

	var/client/C
	if(istype(whom, /client))
		C = whom
	else if(istext(whom))
		C = GLOB.directory[whom]
	else
		return

	var/datum/preferences/P
	if(C)
		P = C.prefs
	else
		P = GLOB.preferences_datums[whom]
	if(!P)
		return

	if(automute)
		if(!CONFIG_GET(flag/automute_on))
			return
	else
		if(!check_rights())
			return

	if(automute)
		muteunmute = "auto-muted"
		P.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(whom)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(whom)] from [mute_string].")
		if(C)
			to_chat(C, "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin.")
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Auto Mute [feedback_string]", "1")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(P.muted & mute_type)
		muteunmute = "unmuted"
		P.muted &= ~mute_type
	else
		muteunmute = "muted"
		P.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(whom)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(whom)] from [mute_string].")
	if(C)
		to_chat(C, "You have been [muteunmute] from [mute_string] by [key_name(usr, include_name = FALSE)].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Mute [feedback_string]", "[P.muted & mute_type]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "GameMaster"
	set name = "Respawn Character"
	set desc = ""
	if(!check_rights(R_ADMIN))
		return

	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/dead/observer/G_found
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		to_chat(usr, "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>")
		return

	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something

		//check if they were a monkey
		if(findtext(G_found.real_name,"monkey"))
			if(alert("This character appears to have been a monkey. Would you like to respawn them as such?",,"Yes","No")=="Yes")
				var/mob/living/carbon/monkey/new_monkey = new
				SSjob.SendToLateJoin(new_monkey)
				G_found.mind.transfer_to(new_monkey)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				new_monkey.key = G_found.key
				to_chat(new_monkey, "You have been fully respawned. Enjoy the game.")
				var/msg = "<span class='adminnotice'>[key_name_admin(usr)] has respawned [new_monkey.key] as a filthy xeno.</span>"
				message_admins(msg)
				admin_ticket_log(new_monkey, msg)
				return	//all done. The ghost is auto-deleted


	//Ok, it's not a xeno or a monkey. So, spawn a human.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through GLOB.data_core.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[G_found.real_name][G_found.mind.assigned_role.title]")

		record_found = find_record("id", id, GLOB.data_core.locked)

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields["name"]
		new_character.gender = record_found.fields["gender"]
		new_character.age = record_found.fields["age"]
		new_character.hardset_dna(record_found.fields["identity"], record_found.fields["enzymes"], record_found.fields["name"], record_found.fields["blood_type"], new record_found.fields["species"], record_found.fields["features"])
	else
		var/datum/preferences/A = new()
		A.safe_transfer_prefs_to(new_character)
		A.real_name = G_found.real_name
		new_character.dna.update_dna_identity()

	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
	else
		new_character.mind_initialize()
	if(is_unassigned_job(new_character.mind.assigned_role))
		new_character.mind.set_assigned_role(/datum/job/adventurer)

	new_character.key = G_found.key

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	//Two variables to properly announce later on.
	var/admin = key_name_admin(src)
	var/player_key = G_found.key

	SSjob.EquipRank(new_character, new_character.mind.assigned_role, src)//Or we simply equip them.

	var/msg = "<span class='adminnotice'>[admin] has respawned [player_key] as [new_character.real_name].</span>"
	message_admins(msg)
	admin_ticket_log(new_character, msg)

	to_chat(new_character, "You have been fully respawned. Enjoy the game.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Respawn Character") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return new_character

/client/proc/cmd_admin_rejuvenate(mob/living/M in GLOB.mob_list)
	set category = "GameMaster.Gods"
	set name = "Rejuvenate"

	if(!check_rights(R_ADMIN))
		return

	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return
	M.revive(ADMIN_HEAL_ALL)

	log_admin("[key_name(usr)] healed / revived [key_name(M)]")
	var/msg = "<span class='danger'>Admin [key_name_admin(usr)] healed / revived [ADMIN_LOOKUPFLW(M)]!</span>"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Rejuvinate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_delete(atom/A as obj|mob|turf in world)
	set category = "Admin.Admin"
	set name = "Delete"

	if(!check_rights(R_SPAWN|R_DEBUG))
		return

	admin_delete(A)

/client/proc/cmd_admin_list_open_jobs()
	set category = "Admin.Admin"
	set name = "Manage Job Slots"

	if(!check_rights(R_DEBUG))
		return
	holder.manage_free_slots()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Manage Job Slots") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = "GameMaster.Fun"
	set name = "Explosion"

	if(!check_rights(R_ADMIN))
		return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null)
		return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null)
		return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null)
		return
	var/flames = input("Range of flames. -1 to none", text("Input"))  as num|null
	if(flames == null)
		return
	var/hotspots = input("Range of flames. -1 to none", text("Input"))  as num|null
	if(hotspots == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1) || (flames != -1) || (hotspots != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20) || (flames > 20) || (hotspots > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash, null, null,flames,hotspots)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[hotspots],[flames]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[hotspots],[flames]) at [AREACOORD(O)]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Explosion") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	else
		return

/client/proc/cmd_admin_gib(mob/M in GLOB.mob_list)
	set category = "GameMaster.Fun"
	set name = "Gib"

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Drop a brain?", "Confirm", "Yes", "No","Cancel")
	if(confirm == "Cancel")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)
		return

	log_admin("[key_name(usr)] has gibbed [key_name(M)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]")

	if(isobserver(M))
		new /obj/effect/gibspawner/generic(get_turf(M))
		return
	if(confirm == "Yes")
		M.gib()
	else
		M.gib(1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "GameMaster.Fun"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used gibself.")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] used gibself.</span>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib Self") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		mob.gib(1, 1, 1)

/client/proc/cmd_admin_check_contents(mob/living/M in GLOB.mob_list)
	set category = "GameMaster.Equipping"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		to_chat(usr, "[t]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Contents") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_view_range()
	set category = "Admin.Admin"
	set name = "Change View Range"
	set desc = ""

	if(view == CONFIG_GET(string/default_view))
		var/max_view = GHOST_MAX_VIEW_RANGE
		var/list/views = list()
		for(var/i in 7 to max_view)
			views |= i
		views |= 32
		views |= 64
		views |= 128
		view_size.setTo(input("Select view range:", "FUCK YE", 7) in views)
	else
		view_size.resetToDefault()

	log_admin("[key_name(usr)] changed their view range to [view].")
	//message_admins("\blue [key_name_admin(usr)] changed their view range to [view].")	//why? removed by order of XSI

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Change View Range", "[view]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/everyone_random()
	set category = "GameMaster.Equipping"
	set name = "Make Everyone Random"
	set desc = ""

	if(SSticker.HasRoundStarted())
		to_chat(usr, "Nope you can't do this, the game's already started. This only works before rounds!")
		return

	var/frn = CONFIG_GET(flag/force_random_names)
	if(frn)
		CONFIG_SET(flag/force_random_names, FALSE)
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.")
		to_chat(usr, "Disabled.")
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.")

	if(notifyplayers == "Yes")
		to_chat(world, "<span class='adminnotice'>Admin [usr.key] has forced the players to have completely random identities!</span>")

	to_chat(usr, "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>.")

	CONFIG_SET(flag/force_random_names, TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Everyone Random") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"
	set desc = ""
	var/new_are = !CONFIG_GET(flag/allow_random_events)
	CONFIG_SET(flag/allow_random_events, new_are)
	if(new_are)
		to_chat(usr, "Random events enabled")
		message_admins("Admin [key_name_admin(usr)] has enabled random events.")
	else
		to_chat(usr, "Random events disabled")
		message_admins("Admin [key_name_admin(usr)] has disabled random events.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Random Events", "[new_are ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_combo_hud()
	set category = "Admin.Admin Preferences"
	set name = "Toggle Combo HUD"
	set desc = ""

	if(!check_rights(R_ADMIN))
		return

	var/adding_hud = !has_antag_hud()

	for(var/datum/atom_hud/antag/H in GLOB.huds) // add antag huds
		(adding_hud) ? H.add_hud_to(usr) : H.remove_hud_from(usr)

	if(prefs.toggles & COMBOHUD_LIGHTING)
		if(adding_hud)
			mob.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			mob.lighting_alpha = initial(mob.lighting_alpha)

	mob.update_sight()

	to_chat(usr, "You toggled your admin combo HUD [adding_hud ? "ON" : "OFF"].")
	message_admins("[key_name_admin(usr)] toggled their admin combo HUD [adding_hud ? "ON" : "OFF"].")
	log_admin("[key_name(usr)] toggled their admin combo HUD [adding_hud ? "ON" : "OFF"].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Combo HUD", "[adding_hud ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/has_antag_hud()
	var/datum/atom_hud/A = GLOB.huds[ANTAG_HUD_HIDDEN]
	return A.hudusers[mob]

/client/proc/show_tip()
	set category = "Admin.Admin"
	set name = "Show Tip"
	set desc = "Sends a tip (that you specify) to all players. After all \
		you're the experienced player here."

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please specify your tip that you want to send to the players.", "Tip", "") as message|null
	if(!input)
		return

	if(!SSticker)
		return

	SSticker.selected_tip = input

	// If we've already tipped, then send it straight away.
	if(SSticker.tipped)
		SSticker.send_tip_of_the_round()


	message_admins("[key_name_admin(usr)] sent a tip of the round.")
	log_admin("[key_name(usr)] sent \"[input]\" as the Tip of the Round.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Tip")

/client/proc/toggle_hub()
	set category = "Server"
	set name = "Toggle Hub"

	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	message_admins("[key_name_admin(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a filewall is blocking incoming connections.")

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/smite(mob/living/target as mob)
	set name = "Smite"
	set category = "GameMaster.Gods"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return
	var/static/list/punishment_list = list(
		ADMIN_PUNISHMENT_LIGHTNING,
		ADMIN_PUNISHMENT_BRAINDAMAGE,
		ADMIN_PUNISHMENT_GIB,
		ADMIN_PUNISHMENT_BSA,
		ADMIN_PUNISHMENT_ROD,
		ADMIN_PUNISHMENT_SUPPLYPOD_QUICK,
		ADMIN_PUNISHMENT_SUPPLYPOD,
		ADMIN_PUNISHMENT_CBT,
		ADMIN_PUNISHMENT_NECKSNAP,
		ADMIN_PUNISHMENT_HUNTED,
		ADMIN_PUNISHMENT_MEATPIE,
		ADMIN_PUNISHMENT_GODHAND,
		ADMIN_PUNISHMENT_FORCECOLLAR,
		ADMIN_PUNISHMENT_PSYDON,
	)

	var/punishment = input("Choose a punishment", "DIVINE SMITING") as null|anything in sortList(punishment_list)

	if(QDELETED(target) || !punishment)
		return

	switch(punishment)
		if(ADMIN_PUNISHMENT_LIGHTNING)
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			target.adjustFireLoss(75)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.electrocution_animation(40)
			to_chat(target, "<span class='danger'>The gods have punished you for your sins!</span>")
		if(ADMIN_PUNISHMENT_BRAINDAMAGE)
			target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 199, 199)
		if(ADMIN_PUNISHMENT_GIB)
			target.gib(FALSE)
		if(ADMIN_PUNISHMENT_PSYDON)
			sleep(60)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(20)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(15)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(10)
			target.gib(FALSE)

		if(ADMIN_PUNISHMENT_BSA)
			bluespace_artillery(target)

		if(ADMIN_PUNISHMENT_CBT)
			if(!ishuman(target))
				to_chat(usr,"<span class='warning'>Target must be human!</span>")
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_CHEST)
			if(!affecting)
				to_chat(usr,"<span class='warning'>Target must have a chest!</span>")
				return
			affecting.add_wound(/datum/wound/cbt/permanent)
		if(ADMIN_PUNISHMENT_NECKSNAP)
			if(!ishuman(target))
				to_chat(usr,"<span class='warning'>Target must be human!</span>")
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_HEAD)
			if(!affecting)
				to_chat(usr,"<span class='warning'>Target must have a head!</span>")
				return
			affecting.add_wound(/datum/wound/fracture/neck)
		if(ADMIN_PUNISHMENT_HUNTED)
			if(!ishuman(target))
				to_chat(usr,"<span class='warning'>Target must be human!</span>")
				return
			ADD_TRAIT(target, TRAIT_ZIZOID_HUNTED, TRAIT_GENERIC) // Gives the victim a trait to track that they are wanted dead.
			log_hunted("[key_name(target)] playing as [target] had been hunted by Admin punishment.")
			for (var/mob/living/carbon in GLOB.carbon_list) // Admin smite, just tell all assassins whether they have their knife or not
				if (HAS_TRAIT(carbon, TRAIT_ASSASSIN) && !(carbon.stat == DEAD)) //Check if they are an assassin and alive
					// for(var/obj/item/I in carbon) // Checks to see if the assassin has their dagger on them. If so, the dagger will let them know of a new target.
					// 	if(istype(I, /obj/item/weapon/knife/dagger/steel/profane)) // Checks to see if the assassin has their dagger on them.
					to_chat(carbon, "<span class='danger'>\"The Dark Sun Graggar himself has ordered us to punish [target.real_name] for their transgressions!\"</span>")
			to_chat(target.mind, "<span class='danger'>My hair stands on end. Has someone just said my name? I should watch my back.</span>")
		if(ADMIN_PUNISHMENT_MEATPIE)
			if(!ishuman(target))
				to_chat(usr, span_warning("Target must be human!"))
				return
			var/mutable_appearance/meatpie_appearance = mutable_appearance('icons/roguetown/items/food.dmi', "meatpie")
			var/mutable_appearance/transform_scanline = mutable_appearance('icons/effects/effects.dmi', "smoke")
			ADD_TRAIT(target, TRAIT_NO_TRANSFORM, ADMIN_PUNISHMENT_MEATPIE)
			target.transformation_animation(meatpie_appearance, 5 SECONDS, transform_scanline.appearance)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pieify), target), 5 SECONDS)
		if(ADMIN_PUNISHMENT_GODHAND)
			var/list/hands = list(
				"Astrata" = /obj/effect/god_hand,
				"Photorealistic" = /obj/effect/god_hand/photorealistic,
			)
			var/typepath_choice = browser_input_list(src, "Hand of God", "Which hand?", hands)
			if(!typepath_choice)
				return
			target.be_taken_with_hand_of_god(hands[typepath_choice])
		if(ADMIN_PUNISHMENT_FORCECOLLAR)
			if(!ishuman(target))
				to_chat(usr, span_warning("Target must be human!"))
				return
			var/static/list/collar = list(
				"Bell Collar" = /obj/item/clothing/neck/bellcollar,
				"Leather Collar" = /obj/item/clothing/neck/leathercollar,
			)
			var/typepath_choice = browser_input_list(src, "Inflict Suffering", "What kind?", collar) // Hopefully just copying and pasting actual code works <3
			if(!typepath_choice)
				return
			var/mob/living/carbon/human/H = target
			if(H.wear_neck)
				var/obj/I = H.wear_neck
				target.dropItemToGround(I, TRUE)
			var/typepath = collar[typepath_choice]
			var/obj/created_collar = new typepath (get_turf(target))
			H.equip_to_slot(created_collar, ITEM_SLOT_NECK)
			ADD_TRAIT(created_collar, TRAIT_NODROP, "adminabuse")
			to_chat(target, span_userdanger("A ring of darkness restrains my neck, and a collar is made manifest!"))
			H.add_stress(/datum/stress_event/collarcurse)

	punish_log(target, punishment)

/client/proc/heart_attack(mob/living/carbon/target as mob)
	set name = "Heart Attack"
	set category = "GameMaster.Gods"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return

	var/obj/item/organ/heart/heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(!heart)
		to_chat(usr,span_warning("The target does not have a Heart!"))
		return

	var/custom_message
	var/check = browser_alert(usr, "Do you want a custom message for the heart attack?", "Confirmation", DEFAULT_INPUT_CHOICES)
	if(check == CHOICE_YES)
		custom_message = browser_input_text(usr, "Write the Custom Message", "Custom Message")
		if(!custom_message)
			to_chat(usr, span_notice("You didn't write the custom message!"))
			return

	if(QDELETED(target))
		return

	target.visible_message(target, span_danger("[target] clutches at [target.p_their()] chest!"))
	target.emote("breathgasp", forced = TRUE)
	shake_camera(target, 1, 3)
	target.set_eye_blur_if_lower(80 SECONDS)
	var/stuffy = list("ZIZO GRABS MY WEARY HEART!","ARGH! MY HEART BEATS NO MORE!","NO... MY HEART HAS BEAT IT'S LAST!","MY HEART HAS GIVEN UP!","MY HEART BETRAYS ME!","THE METRONOME OF MY LIFE STILLS!")
	if(custom_message)
		to_chat(target, span_danger("[custom_message]"))
	else
		to_chat(target, span_danger("[pick(stuffy)]"))

	punish_log(target, punishment = "Heart Attack")
	spawn(3 SECONDS)
		if(!QDELETED(target))
			target.set_heartattack(TRUE)

/client/proc/punish_log(whom, punishment)
	var/msg = "[key_name_admin(usr)] punished [key_name_admin(whom)] with [punishment]."
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(usr)] punished [key_name(whom)] with [punishment].")

/client/proc/cmd_admin_check_player_exp()	//Allows admins to determine who the newer players are.
	set category = "Admin.Admin"
	set name = "Player Playtime"
	if(!check_rights(R_ADMIN))
		return

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>")
		return

	var/list/msg = list()
	msg += "<html><head><title>Playtime Report</title></head><body>Playtime:<BR><UL>"
	for(var/client/C in GLOB.clients)
		msg += "<LI> - [key_name_admin(C)]: <A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(C.mob)]'>" + C.get_exp_living() + "</a></LI>"
	msg += "</UL></BODY></HTML>"
	src << browse(msg.Join(), "window=Player_playtime_check")

/datum/admins/proc/cmd_show_exp_panel(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>")
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>")
		return

	var/list/body = list()
	body += "<html><head><title>Playtime for [C.key]</title></head><BODY><BR>Playtime:"
	body += C.get_exp_report()
	body += "<A href='?_src_=holder;[HrefToken()];toggleexempt=[REF(C)]'>Toggle Exempt status</a>"
	body += "</BODY></HTML>"
	usr << browse(body.Join(), "window=playerplaytime[C.ckey];size=550x615")

/datum/admins/proc/toggle_exempt_status(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>")
		return

	if(!C.set_db_player_flags())
		to_chat(usr, "<span class='danger'>ERROR: Unable read player flags from database. Please check logs.</span>")
	var/dbflags = C.prefs.db_flags
	var/newstate = FALSE
	if(dbflags & DB_FLAG_EXEMPT)
		newstate = FALSE
	else
		newstate = TRUE

	if(C.update_flag_db(DB_FLAG_EXEMPT, newstate))
		to_chat(usr, "<span class='danger'>ERROR: Unable to update player flags. Please check logs.</span>")
	else
		message_admins("[key_name_admin(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name_admin(C)]")
		log_admin("[key_name(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name(C)]")

/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/availible_traits = list()

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.traits_by_type)
				if(istype(D,key))
					availible_traits += GLOB.traits_by_type[key]
		if("Remove")
			if(!GLOB.trait_name_map)
				GLOB.trait_name_map = generate_trait_name_map()
			for(var/trait in D.status_traits)
				var/name = GLOB.trait_name_map[trait] || trait
				availible_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in sortList(availible_traits)
	if(!chosen_trait)
		return
	chosen_trait = availible_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			if(GLOB.movement_type_trait_to_flag[chosen_trait]) //include the required element.
				D.AddElement(/datum/element/movetype_handler)
			ADD_TRAIT(D, chosen_trait, source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in sortList(D.status_traits[chosen_trait])
					if(!source)
						return
			REMOVE_TRAIT(D,chosen_trait,source)

/client/proc/send_bird_letter(mob/M in GLOB.player_list)
	set name = "Send Messenger Bird Letter"
	set category = "GameMaster.Interactions"

	if(!ismob(M))
		return
	if(!check_rights(R_ADMIN))
		return

	message_admins("[key_name_admin(src)] has started answering [ADMIN_LOOKUPFLW(M)]'s letter.")

	var/msg = input("Message:", text("Letter to [M.key]")) as message|null
	if(!msg)
		message_admins("[key_name_admin(src)] decided not to answer [ADMIN_LOOKUPFLW(M)]'s letter.")
		return

	var/obj/item/paper/letter = new /obj/item/paper()
	letter.clearpaper()
	var/penned_msg = letter.parsepencode(msg, new /obj/item/natural/feather())
	letter.info = penned_msg
	letter.updateinfolinks()
	letter.update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

	if(M.put_in_hands(letter))
		to_chat(M, "<span class='notice'>A messenger bird drops a letter in your hand!</span>")
	else
		letter.loc = get_turf(M)
		to_chat(M, "<span class='notice'>A messenger bird drops a letter at your feet!</span>")

	playsound(M, 'sound/vo/mobs/bird/birdfly.ogg', 100, FALSE, -1)
	log_admin("Letter: [key_name(usr)] -> [key_name(M)] : [msg]")
	message_admins(span_adminnotice("Messenger Bird Letter: [key_name_admin(usr)] -> [key_name_admin(M)] : [msg]"))
	log_game("LETTER RECEIVED: [key_name(usr)] -> [key_name(M)]: \n[msg]")
	SSblackbox.record_feedback("tally", "admin_verb_send_messenger_bird", 1, "Messenger Bird Letter") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
