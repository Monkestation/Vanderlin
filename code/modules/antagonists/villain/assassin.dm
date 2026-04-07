// Assassin, cultist of graggar. Normally found as a drifter.
/datum/antagonist/assassin
	name = "Assassin"
	roundend_category = "Assassins"
	antagpanel_category = "Assassin"
	antag_hud_type = ANTAG_HUD_ASSASSIN
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	confess_lines = list(
		"MY CREED IS BLOOD!",
		"THE DAGGER TOLD ME WHO TO CUT!",
		"DEATH IS MY DEVOTION!",
		"THE DARK SUN GUIDES MY HAND!",
	)
	antag_flags = FLAG_FAKE_ANTAG

	innate_traits = list(
		TRAIT_ASSASSIN,
		TRAIT_DEADNOSE,
		TRAIT_VILLAIN,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_STRONG_GRABBER,
	)

/datum/antagonist/assassin/on_gain()
	var/mob/living/ass = owner.current
	ass.cmode_music = 'sound/music/cmode/antag/CombatAssassin.ogg'
	add_verb(ass, /mob/living/carbon/human/proc/who_targets) // wtf
	ass.set_patron(/datum/patron/inhumen/graggar, TRUE)
	ass.clamped_adjust_skill_level(/datum/attribute/skill/combat/knives, 40, 40)
	ass.clamped_adjust_skill_level(/datum/attribute/skill/misc/sneaking, 50, 50)
	var/yea = /obj/item/weapon/knife/dagger/steel/profane
	var/wah = /obj/item/inqarticles/garrote/razor
	var/gah = /obj/item/lockpick
	owner.special_items["Profane Dagger"] = yea // Assigned assassins can get their special dagger from right clicking certain objects.
	owner.special_items["Profane Razor"] = wah //the mistakes of coders past trickle down to me here, so shitty var names persist
	owner.special_items["Lock Pick"] = gah
	to_chat(ass, "<span class='danger'>I've blended in well up until this point, but it's time for the Hunted of Graggar to perish. I have tools hidden away in case I am captured or need to infiltrate a compound without weapons.</span>")
	return ..()

/mob/living/carbon/human/proc/who_targets() // Verb for the assassin to remember their targets.
	set name = "Remember Targets"
	set category = "RoleUnique"
	if(!mind)
		return
	mind.recall_targets(src)

/datum/antagonist/assassin/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='danger'>The red fog in my mind is fading. I am no longer an [name]!</span>")
	remove_verb(owner.current, /mob/living/carbon/human/proc/who_targets)
	return ..()

/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/weapon/knife/dagger/steel/profane))
			for(var/mob/dead/observer/profane/A in I) // Each trapped soul is announced to the server
				if(A)
					to_chat(world, "The [A.name] has been stolen for Graggar by [owner.name].<span class='greentext'>DAMNATION!</span>")
					traitorwin = TRUE

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		to_chat(world, "<span class='greentext'>The [name] [owner.name] has TRIUMPHED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, "<span class='redtext'>The [name] [owner.name] has FAILED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/assassin/examine_target(mob/living/carbon/examiner, mob/living/examined, list/P, list/examine_contents)
	. = ..()
	if(!istype(examiner) || !istype(examined))
		return
	if(examined.has_quirk(/datum/quirk/vice/hunted) || HAS_TRAIT(src, TRAIT_ZIZOID_HUNTED))
		for(var/obj/item/I in examiner.get_all_gear())
			if(istype(I, /obj/item/weapon/knife/dagger/steel/profane))
				LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, "profane dagger whispers, [span_danger("\"That's [examined.real_name]! Strike their heart!\"")]")
				break
