/client
	var/list/played_loops = list() //uses dlink to link to the sound

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * Arguments:
 * * source - Origin of sound.
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff_exponent and pressure affection.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * * falloff_exponent - Rate of falloff_exponent for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * frequency - playback speed of audio.
 * * channel - The channel the sound is played at.
 * * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * * ignore_walls - Whether or not the sound can pass through walls.
 * * falloff_distance - Distance at which falloff_exponent begins. Sound is at peak volume (in regards to falloff_exponent) aslong as it is in this range.
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent = SOUND_FALLOFF_EXPONENT, frequency = null, channel, pressure_affected = FALSE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, soundping = FALSE, repeat)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)
	if(!turf_source)
		return

	if(vol < SOUND_AUDIBLE_VOLUME_MIN) // never let sound go below SOUND_AUDIBLE_VOLUME_MIN or bad things will happen
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/S = soundin
	if(!istype(S))
		S = sound(get_sfx(soundin))
	if(!istype(S))
		CRASH("playsound(): sound is still a list after get_sfx")

	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	var/audible_distance = CALCULATE_MAX_SOUND_AUDIBLE_DISTANCE(vol, maxdistance, falloff_distance, max(falloff_exponent, 1))

	if(soundping)
		ping_sound(source)

	var/list/muffled_listeners = list() //this is very rudimentary list of muffled listeners above and below to mimic sound muffling (this is done through modifying the playsounds for them)
	if(!ignore_walls) //these sounds don't carry through walls or vertically
		listeners = listeners & hearers(audible_distance,turf_source)
	else
		if(above_turf)
			listeners += SSmobs.clients_by_zlevel[above_turf.z]
			listeners += SSmobs.dead_players_by_zlevel[above_turf.z]

		if(below_turf)
			listeners += SSmobs.clients_by_zlevel[below_turf.z]
			listeners += SSmobs.dead_players_by_zlevel[below_turf.z]

	listeners += SSmobs.dead_players_by_zlevel[source_z]
	. = list()

	for(var/mob/M as anything in listeners)
		if(get_dist(M, turf_source) <= audible_distance)
			if(M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, max_distance = maxdistance, falloff_distance = falloff_distance, repeat = repeat))
				. += M

	for(var/mob/M as anything in muffled_listeners)
		if(get_dist(M, turf_source) <= audible_distance)
			if(M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, max_distance = maxdistance, falloff_distance = falloff_distance, repeat = repeat, muffled = TRUE))
				. += M
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SOUND_PLAYED, source, soundin)

/proc/ping_sound(atom/A)
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = "emote", layer = ABOVE_MOB_LAYER)
	if(!I)
		return
	I.pixel_y = 6
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay(I, GLOB.clients, 6)


/mob/proc/playsound_local(atom/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel, pressure_affected = TRUE, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, repeat, muffled)
	if(!client || !can_hear())
		return FALSE

	if(!S)
		S = sound(get_sfx(soundin))

	if(!istype(S))
		CRASH("playsound_local(): sound is still a list after get_sfx")

	S.wait = 0 //No queue
	S.channel = channel || SSsounds.random_available_channel()

	if(muffled)
		S.environment = 11
		if(falloff_exponent)
			falloff_exponent *= 1.5
		else
			falloff_exponent = SOUND_FALLOFF_EXPONENT * 1.5
		vol *= 0.75

	var/vol2use = vol
	if(client.prefs)
		vol2use = vol * (client.prefs.mastervol * 0.01)
	vol2use = min(vol2use, 100)

	S.volume = vol2use

	var/area/A = get_area(src)
	if(A)
		if(A.soundenv != -1)
			S.environment = A.soundenv

	if(vary)
		S.frequency = get_rand_frequency()
	if(frequency)
		S.frequency = frequency

	var/distance = 0

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//sound volume falloff_exponent with distance
		distance = max(get_dist(T, turf_source) * distance_multiplier, 0)

		if(max_distance && falloff_exponent) //If theres no max_distance we're not a 3D sound, so no falloff.
			S.volume -= CALCULATE_SOUND_VOLUME(vol2use, distance, max_distance, falloff_distance, falloff_exponent)

		if(S.volume < SOUND_AUDIBLE_VOLUME_MIN)
			return //No sound

		var/dx = turf_source.x - x
		if(dx <= 1 && dx >= -1)
			S.x = 0
		else
			S.x = dx
		var/dz = turf_source.y - y
		if(dz <= 1 && dz >= -1)
			S.z = 0
		else
			S.z = dz

		var/dy = turf_source.z - z
		S.y = dy

		S.falloff = max_distance || 0 //use max_distance, else just use 0 as we are a direct sound so falloff isnt relevant.

	if(repeat && istype(repeat, /datum/looping_sound))
		var/datum/looping_sound/D = repeat
		if(src in D.thingshearing) //we are already hearing this loop
			if(client.played_loops[D])
				var/sound/DS = client.played_loops[D]["SOUND"]
				if(DS)
					var/volly = client.played_loops[D]["VOL"]
					if(volly != S.volume)
						DS.x = S.x
						DS.y = S.y
						DS.z = S.z
						DS.falloff = S.falloff
						client.played_loops[D]["VOL"] = S.volume
						update_sound_volume(DS, S.volume)
						if(client.played_loops[D]["MUTESTATUS"]) //we have sound so turn this off
							client.played_loops[D]["MUTESTATUS"] = null
		else
			D.thingshearing += src
			client.played_loops[D] = list()
			client.played_loops[D]["SOUND"] = S
			client.played_loops[D]["VOL"] = S.volume
			client.played_loops[D]["MUTESTATUS"] = null
			S.repeat = 1

	if(HAS_TRAIT(src, TRAIT_SOUND_DEBUGGED))
		to_chat(src, span_admin("Max Range-[max_distance] Distance-[distance] Vol-[round(S.volume, 0.01)] Sound-[S.file]"))

	SEND_SOUND(src, S)

	return TRUE

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, null, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/mob/proc/mute_sound_channel(chan)
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_MUTE | SOUND_UPDATE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound_channel(chan)
	if(!client)
		return
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_UPDATE
			S.status &= ~SOUND_MUTE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/mob/proc/mute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_MUTE | SOUND_UPDATE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_UPDATE
	S.status &= ~SOUND_MUTE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

/mob/proc/update_sound_volume(sound/S, vol)
	if(!client)
		return
	if(!S)
		return
	if(vol)
		S.volume = vol
		S.status |= SOUND_UPDATE
		S.status &= ~SOUND_MUTE
		SEND_SOUND(src, S)
		S.status &= ~SOUND_UPDATE

/mob/proc/update_music_volume(chan, vol)
	if(client)
		if(client.musicfading)
			if(vol > client.musicfading)
				return
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE
	else
		mute_sound_channel(chan)

/mob/proc/update_channel_volume(chan, vol)
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE

/client/proc/playtitlemusic()
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = prefs.musicvol, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/proc/get_rand_frequency()
	return rand(43100, 45100) //Frequency stuff only works with 45kbps oggs.

/proc/get_rand_frequency_higher_range()
	return rand(40000, 48100)

/proc/get_sfx(soundin)
	if(islist(soundin))
		soundin = pick(soundin)
	if(istext(soundin))
		switch(soundin)
			if (SFX_SPARKS)
				soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if ("rustle")
				soundin = pick('sound/foley/equip/rummaging-01.ogg','sound/foley/equip/rummaging-02.ogg','sound/foley/equip/rummaging-03.ogg')
			if ("bodyfall")
				soundin = pick('sound/foley/bodyfall (1).ogg','sound/foley/bodyfall (2).ogg','sound/foley/bodyfall (3).ogg','sound/foley/bodyfall (4).ogg')
			if ("clothwipe")
				soundin = pick('sound/foley/cloth_wipe (1).ogg','sound/foley/cloth_wipe (2).ogg','sound/foley/cloth_wipe (3).ogg')
			if ("glassbreak")
				soundin = pick('sound/combat/hits/onglass/glassbreak (1).ogg','sound/combat/hits/onglass/glassbreak (2).ogg','sound/combat/hits/onglass/glassbreak (3).ogg')
			if ("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
			if ("unarmparry")
				soundin = pick('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
			if ("dagger")
				soundin = pick('sound/combat/parry/bladed/bladedsmall (1).ogg', 'sound/combat/parry/bladed/bladedsmall (2).ogg', 'sound/combat/parry/bladed/bladedsmall (3).ogg')
			if ("rapier")
				soundin = pick('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
			if ("sword")
				soundin = pick('sound/combat/parry/bladed/bladedmedium (1).ogg', 'sound/combat/parry/bladed/bladedmedium (2).ogg', 'sound/combat/parry/bladed/bladedmedium (3).ogg')
			if ("largeblade")
				soundin = pick('sound/combat/parry/bladed/bladedlarge (1).ogg', 'sound/combat/parry/bladed/bladedlarge (2).ogg', 'sound/combat/parry/bladed/bladedlarge (3).ogg')
			if ("unsheathe_sword")
				soundin = pick('sound/foley/equip/swordsmall1.ogg', 'sound/foley/equip/swordsmall2.ogg')
			if ("brandish_blade")
				soundin = pick('sound/foley/equip/swordlarge1.ogg', 'sound/foley/equip/swordlarge2.ogg')
			if ("burn")
				soundin = pick('sound/combat/hits/burn (1).ogg','sound/combat/hits/burn (2).ogg')
			if ("nodmg")
				soundin = pick('sound/combat/hits/nodmg (1).ogg','sound/combat/hits/nodmg (2).ogg')
			if ("plantcross")
				soundin = pick('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
			if ("smashlimb")
				soundin = pick('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
			if("genblunt")
				soundin = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg')
			if("wetbreak")
				soundin = pick('sound/combat/fracture/fracturewet (1).ogg',
'sound/combat/fracture/fracturewet (2).ogg',
'sound/combat/fracture/fracturewet (3).ogg')
			if("fracturedry")
				soundin = pick('sound/combat/fracture/fracturedry (1).ogg',
'sound/combat/fracture/fracturedry (2).ogg',
'sound/combat/fracture/fracturedry (3).ogg')
			if("headcrush")
				soundin = pick('sound/combat/fracture/headcrush (1).ogg',
'sound/combat/fracture/headcrush (2).ogg',
'sound/combat/fracture/headcrush (3).ogg',
'sound/combat/fracture/headcrush (4).ogg')
			if("punch")
				soundin = pick('sound/combat/hits/punch/punch (1).ogg','sound/combat/hits/punch/punch (2).ogg','sound/combat/hits/punch/punch (3).ogg')
			if("punch_hard")
				soundin = pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg')
			if("smallslash")
				soundin = pick('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
			if("fart")
				soundin = pick('sound/vo/fart1.ogg','sound/vo/fart2.ogg','sound/vo/fart3.ogg')
			if("woodimpact")
				soundin = pick('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
			if("bubbles")
				soundin = pick('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg')
			if("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg','sound/combat/parry/wood/parrywood (2).ogg','sound/combat/parry/wood/parrywood (3).ogg')
			if("whiz")
				soundin = pick('sound/foley/whiz (1).ogg','sound/foley/whiz (2).ogg','sound/foley/whiz (3).ogg','sound/foley/whiz (4).ogg')
			if("genslash")
				soundin = pick('sound/combat/hits/bladed/genslash (1).ogg','sound/combat/hits/bladed/genslash (2).ogg','sound/combat/hits/bladed/genslash (3).ogg')
			if("bladewooshsmall")
				soundin = pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
			if("bluntwooshmed")
				soundin = pick('sound/combat/wooshes/blunt/wooshmed (1).ogg','sound/combat/wooshes/blunt/wooshmed (2).ogg','sound/combat/wooshes/blunt/wooshmed (3).ogg')
			if("bluntwooshlarge")
				soundin = pick('sound/combat/wooshes/blunt/wooshlarge (1).ogg','sound/combat/wooshes/blunt/wooshlarge (2).ogg','sound/combat/wooshes/blunt/wooshlarge (3).ogg')
			if("punchwoosh")
				soundin = pick('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
			if("changeling_absorb") // turn these into defines
				soundin = pick(
					'sound/surgery/changeling_absorb/changeling_absorb1.ogg',
					'sound/surgery/changeling_absorb/changeling_absorb2.ogg',
					'sound/surgery/changeling_absorb/changeling_absorb3.ogg',
					'sound/surgery/changeling_absorb/changeling_absorb4.ogg',
					'sound/surgery/changeling_absorb/changeling_absorb5.ogg',
				)
			if(SFX_CHAIN_STEP)
				soundin = pick('sound/foley/footsteps/armor/chain (1).ogg',\
							'sound/foley/footsteps/armor/chain (2).ogg',\
							'sound/foley/footsteps/armor/chain (3).ogg',\
							)
			if(SFX_PLATE_STEP)
				soundin = pick('sound/foley/footsteps/armor/plate (1).ogg',\
							'sound/foley/footsteps/armor/plate (2).ogg',\
							'sound/foley/footsteps/armor/plate (3).ogg',\
							)
			if(SFX_PLATE_COAT_STEP)
				soundin = pick('sound/foley/footsteps/armor/coatplates (1).ogg',\
							'sound/foley/footsteps/armor/coatplates (2).ogg',\
							'sound/foley/footsteps/armor/coatplates (3).ogg',\
							)
			if(SFX_JINGLE_BELLS)
				soundin = pick('sound/items/jinglebell (1).ogg',\
							'sound/items/jinglebell (2).ogg',\
							'sound/items/jinglebell (3).ogg',\
							'sound/items/jinglebell (4).ogg',\
							)
			if(SFX_INQUIS_BOOT_STEP)
				soundin = pick('sound/foley/footsteps/armor/inquisitorboot (1).ogg',\
							'sound/foley/footsteps/armor/inquisitorboot (2).ogg',\
							'sound/foley/footsteps/armor/inquisitorboot (3).ogg',\
							'sound/foley/footsteps/armor/inquisitorboot (4).ogg'\
							)
			if(SFX_POWER_ARMOR_STEP)
				soundin = pick('sound/foley/footsteps/armor/powerarmor (1).ogg',\
							'sound/foley/footsteps/armor/powerarmor (2).ogg',\
							'sound/foley/footsteps/armor/powerarmor (3).ogg',\
							)
			if(SFX_WATCH_BOOT_STEP)
				soundin = pick('sound/foley/footsteps/armor/heavy-footstep (1).ogg',\
							'sound/foley/footsteps/armor/heavy-footstep (2).ogg',\
							'sound/foley/footsteps/armor/heavy-footstep (3).ogg',\
							'sound/foley/footsteps/armor/heavy-footstep (4).ogg',\
							'sound/foley/footsteps/armor/heavy-footstep (5).ogg'\
							)
			if(SFX_CAT_MEOW)
				soundin = pickweight(list(
					'sound/vo/cat/cat_meow1.ogg' = 33,
					'sound/vo/cat/cat_meow2.ogg' = 33,
					'sound/vo/cat/cat_meow3.ogg' = 33,
					'sound/vo/cat/oranges_meow1.ogg' = 1,
				))
			if(SFX_CAT_PURR)
				soundin = pick(
					'sound/vo/cat/cat_purr1.ogg',
					'sound/vo/cat/cat_purr2.ogg',
					'sound/vo/cat/cat_purr3.ogg',
					'sound/vo/cat/cat_purr4.ogg',
				)
			if(SFX_EGG_HATCHING)
				soundin = pick(
					'sound/foley/egg_hatching/egghatching1.ogg',
					'sound/foley/egg_hatching/egghatching2.ogg',
					'sound/foley/egg_hatching/egghatching3.ogg',
				)
			if(SFX_DEFAULT_FISH_SLAP)
				soundin = pick(
					'sound/mobs/non-humanoids/fish/fish_slap1.ogg',
				)

			if(SFX_ALT_FISH_SLAP)
				soundin = pick(
					'sound/mobs/non-humanoids/fish/fish_slap2.ogg',
				)
			if(SFX_REEL)
				soundin = pick(
					'sound/items/reel/reel1.ogg',
					'sound/items/reel/reel2.ogg',
					'sound/items/reel/reel3.ogg',
					'sound/items/reel/reel4.ogg',
					'sound/items/reel/reel5.ogg',
				)
	return soundin
