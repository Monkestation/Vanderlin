
/obj/structure/closet/crate/chest/inqreliquary
	name = "oratorium reliquary"
	desc = "A foreboding red chest with an intricate lock design. It seems to only fit a very specific key. Choose wisely."
	icon_state = "chestweird1"
	base_icon_state = "chestweird1"

/obj/structure/closet/crate/chest/inqcrate
	name = "oratorium chest"
	desc = "A foreboding red chest with black dye-washed silver embellishments."
	icon_state = "chestweird2"
	base_icon_state = "chestweird2"

// Reliquary Box and key - The Box Which contains these
/obj/structure/reliquarybox
	name = "oratorium reliquary"
	desc = "A foreboding red chest with an intricate lock design. It seems to only fit a very specific key. Choose wisely."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chestweird1"
	anchored = TRUE
	density = TRUE
	var/opened = FALSE

/obj/item/key/psydonkey
	icon_state = "birdkey"
	name = "Reliquary Key"
	desc = "The single use key with which to unleash woe. Choose wisely."

/obj/structure/reliquarybox/attackby(obj/item/W, mob/user, params)
	if(ishuman(user))
		if(istype(W, /obj/item/key/psydonkey))
			if(opened)
				to_chat(user, span_info("The reliquary box has already been opened..."))
				return
			qdel(W)
			to_chat(user, span_info("The reliquary lock takes my key as it opens, I take a moment to ponder what power was delivered to us..."))
			playsound(src, 'sound/foley/doors/woodlock.ogg', 60)
			to_chat(user,)
			var/relics = list("Melancholic Crankbox - Antimagic", "Daybreak - Silver Whip", "Sanctum - Silver Halberd", "Crusade - Silver Greatsword", "Censer of Penitence")
			var/relicchoice = input(user, "Choose your tool", "RELICS") as anything in relics
			var/obj/choice
			switch(relicchoice)
				if("Melancholic Crankbox - Antimagic")
					choice = /obj/item/psydonmusicbox
				if("Daybreak - Silver Whip")
					choice = /obj/item/weapon/whip/psydon/relic
				if("Sanctum - Silver Halberd")
					choice = /obj/item/weapon/polearm/halberd/psydon/relic
					user.clamped_adjust_skillrank(/datum/skill/combat/polearms, 4, 4, TRUE)	//We make sure the weapon is usable by the Inquisitor.
				if("Crusade - Silver Greatsword")
					choice = /obj/item/weapon/sword/long/greatsword/psydon
					user.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)		//Ditto.
				if("Censer of Penitence")
					choice = /obj/item/flashlight/flare/torch/lantern/psycenser
			to_chat(user, span_info("I have chosen the relic, may HE guide my hand."))
			var/obj/structure/closet/crate/chest/inqreliquary/realchest = new /obj/structure/closet/crate/chest/inqreliquary(get_turf(src))
			realchest.populate_contents()
			choice = new choice(realchest)
			qdel(src)



// Soul Churner - Music box which applies magic resistance to Inquisition members, greatly mood debuffs everyone not a Psydon worshipper.
/obj/item/psydonmusicbox
	name = "melancholic crankbox"
	desc = ""
	icon_state = "psydonmusicbox"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_HUGE
	var/cranking = FALSE
	force = 15
	max_integrity = 100
	attacked_sound = 'sound/combat/hits/onwood/education2.ogg'
	gripped_intents = list(/datum/intent/hit)
	possible_item_intents = list(/datum/intent/hit)
	obj_flags = CAN_BE_HIT
	bigboy = TRUE
	var/datum/looping_sound/psydonmusicboxsound/soundloop

/obj/item/psydonmusicbox/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = "A relic from the bowels of the Oratorium's thaumaturgical workshops. Fourteen souls of heretics, all bound together, they will scream and protect us from magicks. It would be wise to not teach the heretics of its true nature, to only bring it to bear in dire circumstances."
	else
		desc = "A cranked music box, it has the seal of the Oratorium Throni Vacui on the side. It carries a somber feeling to it..."

/obj/item/psydonmusicbox/attack_self(mob/living/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		user.add_stress(/datum/stress_event/soulchurnerhorror)
		to_chat(user, (span_cultsmall("I FEEL SUFFERING WITH EVERY CRANK, WHAT AM I DOING?!")))
	cranking = !cranking
	update_appearance(UPDATE_ICON_STATE)
	if(cranking)
		user.apply_status_effect(/datum/status_effect/buff/cranking_soulchurner)
		soundloop.start()
		var/songhearers = view(7, user)
		for(var/mob/living/carbon/human/fixation in songhearers)
			to_chat(fixation,span_cultsmall("[user] begins cranking the soul churner..."))
	if(!cranking)
		soundloop.stop()
		user.remove_status_effect(/datum/status_effect/buff/cranking_soulchurner)

/obj/item/psydonmusicbox/Initialize()
	soundloop = new(src, FALSE)
	. = ..()

/obj/item/psydonmusicbox/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/obj/item/psydonmusicbox/update_icon_state()
	. = ..()
	if(cranking)
		icon_state = "psydonmusicbox_active"
	else
		icon_state = "psydonmusicbox"

/obj/item/psydonmusicbox/dropped(mob/living/user, silent)
	. = ..()
	cranking = FALSE
	update_appearance(UPDATE_ICON_STATE)
	if(soundloop)
		soundloop.stop()
		user.remove_status_effect(/datum/status_effect/buff/cranking_soulchurner)

/obj/item/psydonmusicbox/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)

/atom/movable/screen/alert/status_effect/buff/cranking_soulchurner
	name = "Cranking Soulchurner"
	desc = "I am bringing the twisted device to life..."
	icon_state = "buff"

/datum/status_effect/buff/cranking_soulchurner
	id = "crankchurner"
	alert_type = /atom/movable/screen/alert/status_effect/buff/cranking_soulchurner
	var/effect_color
	var/pulse = 0
	var/ticks_to_apply = 10

	var/list/patron_lines = list(
		/datum/patron/divine/astrata = list("'HER LIGHT HAS LEFT ME! WHERE AM I?!'", "'SHATTER THIS CONTRAPTION, SO I MAY FEEL HER WARMTH ONE LAST TIME!'", "'I am royal.. Why did they do this to me...?'"),
		/datum/patron/divine/noc = list("'Colder than moonlight...'", "'No wisdom can reach me here...'", "'Please help me, I miss the stars...'"),
		/datum/patron/divine/necra = list("'They snatched me from her grasp, for eternal torment...'", "'Necra! Please! I am so tired! Release me!'", "'I am lost, lost in a sea of stolen ends.'"),
		/datum/patron/divine/abyssor = list("'I cannot feel the coast's breeze...'", "'We churn tighter here than schooling fish...'", "'Free me, please, so I may return to the sea...'"),
		/datum/patron/divine/ravox = list("'Ravoxian kin! Tear this Grenzelhoftian dog's head off! Free me from this damnable witchery!'", "'There is no justice nor glory to be found here, just endless fatigue...'", "'I begged for a death by the sword...'"),
		/datum/patron/divine/pestra = list("'I only wanted to perfect my cures...'", "'A thousand plagues upon the holder of this accursed machine! Pestra! Can you not hear me?!'", "'I can feel their suffering as they brush against me...'"),
		/datum/patron/divine/eora  =list("'Every caress feels like a thousand splintering bones...'", "'She was a heretic, but how could I hurt her?!'", "'I'm sorry! I only wanted peace! Please release me!'"),
		/datum/patron/divine/dendor =list("'HIS MADNESS CALLS FOR ME! RRGHNN...'", "'SHATTER THIS BOX, SO WE MAY CHOKE THIS GRENZEL ON DIRT AND ROOTS!'", "'I miss His voice in the leaves... Free me, please...'"),
		/datum/patron/divine/xylix  =list("'ONE, TWO, THREE, FOUR- TWO, TWO, THREE, FOUR. --What do you mean, annoying?'", "'There are thirteen others in here, you know! What a good audience- they literally can't get out of their seats!'", "'Of course I went all-in! I thought he had an ace-high!'", "'No, the XYLIX'S FORTUNE was right- this definitely is quite bad.'"),
		/datum/patron/divine/malum =list("'The structure of this cursed machine is malleable.. Shatter it, please...'", "'My craft could've changed the world...'", "'Free me, so I may return to my apprentice, please...'"),
		/datum/patron/inhumen/matthios  =list("'My final transaction... He will never receive my value... Stolen away by these monsters...'", "'Comrade, I have been shackled into this HORRIFIC CONTRAPTION, FREE ME!'", "'I feel our shackles twist with eachother's...'"),
		/datum/patron/inhumen/zizo = list("'ZIZO! MY MAGICKS FAIL ME! STRIKE DOWN THESE PSYDONIAN DOGS!'", "'CABALIST? There is TWISTED MAGICK HERE, BEWARE THE MUSIC! OUR VOICES ARE FORCED!'", "'DESTROY THE BOX, KILL THE WIELDER. YOUR MAGICKS WILL BE FREE.'"),
		/datum/patron/inhumen/graggar =list("'ANOINTED! TEAR THIS GRENZELHOFTIAN'S HEAD OFF!'", "'ANOINTED! SHATTER THE BOX, AND WE WILL KILL THEM TOGETHER!'", "'GRAGGAR, GIVE ME STRENGTH TO BREAK MY BONDS!'"),
		/datum/patron/inhumen/baotha =list("'I miss the warmth of ozium... There is no feeling in here for me...'", "'Debauched one, rescue me from this contraption, I have such things to share with you.'", "'MY PERFECTION WAS TAKEN FROM ME BY THESE PSYDONIAN MONSTERS!'"),
		/datum/patron/psydon = list("'FREE US! FREE US! WE HAVE SUFFERED ENOUGH!'", "'PLEASE, RELEASE US!", "WE MISS OUR FAMILIES!'", "'WHEN WE ESCAPE, WE ARE GOING TO CHASE YOU INTO YOUR GRAVE.'"),
		/datum/patron/psydon/extremist = list("'FREE US! FREE US! WE HAVE SUFFERED ENOUGH!'", "'PLEASE, RELEASE US!", "WE MISS OUR FAMILIES!'", "'WHEN WE ESCAPE, WE ARE GOING TO CHASE YOU INTO YOUR GRAVE.'"), // i hate having to duplicate this
	)


/datum/status_effect/buff/cranking_soulchurner/on_creation(mob/living/new_owner, stress, colour)
	effect_color = "#800000"
	return ..()

/datum/status_effect/buff/cranking_soulchurner/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = "#800000"
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		if(!HAS_TRAIT(owner, TRAIT_INQUISITION))
			owner.add_stress(/datum/stress_event/soulchurnerhorror)
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if (!H.client || !H.patron)
				continue
			if (!H.has_stress_type(/datum/stress_event/soulchurner))
				var/list/lines = patron_lines[H.patron.type]
				if(lines)
					if(istype(H.patron, /datum/patron/psydon))
						H.add_stress(/datum/stress_event/soulchurnerpsydon)
						if(HAS_TRAIT(H, TRAIT_INQUISITION))
							H.apply_status_effect(/datum/status_effect/buff/churnerprotection)
					else
						H.add_stress(/datum/stress_event/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					to_chat(H, (span_hypnophrase("A voice calls out from the song for you...")))
					to_chat(H, (span_cultsmall(pick(lines))))

/atom/movable/screen/alert/status_effect/buff/censerbuff
	name = "Inspired by Psydon."
	desc = "The lingering blessing of Psydon tells me to ENDURE."
	icon_state = "censerbuff"

/datum/status_effect/buff/censerbuff
	id = "censer"
	alert_type = /atom/movable/screen/alert/status_effect/buff/censerbuff
	duration = 15 MINUTES
	effectedstats = list(STATKEY_END = 1, STATKEY_CON = 1)

/datum/stress_event/syoncalamity
	stress_change = 15
	desc = span_boldred("Yet another part of Psydon lost!")
	timer = 15 MINUTES

/datum/intent/flail/strike/smash/golgotha
	hitsound = list('sound/items/beartrap2.ogg')

/obj/effect/temp_visual/censer_dust
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	duration = 8

/datum/intent/bless
	name = "bless"
	icon_state = "inbless"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/datum/intent/weep
	name = "weep"
	icon_state = "inweep"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE

/datum/intent/flail/strike/smash/golgotha
	hitsound = list('sound/items/beartrap2.ogg')

/obj/item/flashlight/flare/torch/lantern/psycenser
	name = "Censer of Penitence"
	desc = "A device filled with bubbling silver. Its unstable state is dangerous to those who do not know its true nature, but to wield it is great honour for Psydon."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psycenser"
	item_state = "psycenser"
	light_outer_range = 8
	light_color ="#70d1e2"
	possible_item_intents = list(/datum/intent/flail/strike/smash/golgotha)
	fuel = 999 MINUTES
	force = 30
	var/next_smoke
	var/smoke_interval = 2 SECONDS

/obj/item/flashlight/flare/torch/lantern/psycenser/examine(mob/user)
	. = ..()
	if(fuel > 0)
		. += span_info("If opened, it may bless Psydon weapons and those of Psydon faith.")
		. += span_warning("Smashing a creature with it open will create a devastating explosion and render it useless.")
	if(fuel <= 0)
		. += span_info("It is gone.")

/obj/item/flashlight/flare/torch/lantern/psycenser/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -4,"nx" = 9,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 45, "sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 45,"sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/torch/lantern/psycenser/attack_self(mob/user)
	if(fuel > 0)
		if(on)
			turn_off()
			possible_item_intents = list(/datum/intent/flail/strike/smash/golgotha)
			user.update_a_intents()
		else
			playsound(src.loc, 'sound/items/censer_on.ogg', 100)
			possible_item_intents = list(/datum/intent/flail/strike/smash/golgotha, /datum/intent/bless)
			user.update_a_intents()
			on = TRUE
			update_brightness()
			//force = on_damage
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			START_PROCESSING(SSobj, src)
	else if(fuel <= 0 && user.used_intent.type == /datum/intent/weep)
		to_chat(user, span_info("It is gone. You weep."))
		user.emote("cry")

/obj/item/flashlight/flare/torch/lantern/psycenser/process()
	if(on && next_smoke < world.time)
		new /obj/effect/temp_visual/censer_dust(get_turf(src))
		next_smoke = world.time + smoke_interval

/obj/item/flashlight/flare/torch/lantern/psycenser/turn_off()
	playsound(src.loc, 'sound/items/censer_off.ogg', 100)
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE

/obj/item/flashlight/flare/torch/lantern/psycenser/fire_act(added, maxstacks)
	return

/obj/item/flashlight/flare/torch/lantern/psycenser/afterattack(atom/movable/A, mob/user, proximity, list/modifiers)
	. = ..()	//We smashed a guy with it turned on. Bad idea!
	if(ismob(A) && on && (user.used_intent.type == /datum/intent/flail/strike/smash/golgotha) && user.cmode)
		user.visible_message(span_warningbig("You see an oddly bright spark before it detonates!"))
		cell_explosion(get_turf(A), 40, 2)
		explosion(get_turf(A),devastation_range = -1, heavy_impact_range = -1, light_impact_range = -1, flame_range = 2, flash_range = 4, smoke = FALSE)
		fuel = 0
		turn_off()
		//icon_state = "psycenser-broken"
		possible_item_intents = list(/datum/intent/weep)
		user.update_a_intents()
		for(var/mob/living/carbon/human/H in view(get_turf(src)))
			if(istype(H.patron, /datum/patron/psydon)) //Psydonites get VERY depressed seeing an artifact get turned into an ulapool caber.
				H.add_stress(/datum/stress_event/syoncalamity)
	if(isitem(A) && on && user.used_intent.type == /datum/intent/bless)
		var/datum/component/psyblessed/CP = A.GetComponent(/datum/component/psyblessed)
		if(CP)
			if(!CP.is_blessed)
				playsound(user, 'sound/magic/censercharging.ogg', 100)
				user.visible_message(span_info("[user] holds \the [src] over \the [A]..."))
				if(do_after(user, 50, A))
					CP.try_bless()
					new /obj/effect/temp_visual/censer_dust(get_turf(A))
			else
				to_chat(user, span_info("It has already been blessed."))
	if(ishuman(A) && on && (user.used_intent.type == /datum/intent/bless))
		var/mob/living/carbon/human/H = A
		if(istype(H.patron, /datum/patron/psydon))
			if(!H.has_status_effect(/datum/status_effect/buff/censerbuff))
				playsound(user, 'sound/magic/censercharging.ogg', 100)
				user.visible_message(span_info("[user] holds \the [src] over \the [A]..."))
				if(do_after(user, 50, A))
					H.apply_status_effect(/datum/status_effect/buff/censerbuff)
					to_chat(H, span_notice("The comet dust invigorates you."))
					playsound(H, 'sound/magic/holyshield.ogg', 100)
					new /obj/effect/temp_visual/censer_dust(get_turf(H))
			else
				to_chat(user, span_warning("They've already been blessed."))

		else
			to_chat(user, span_warning("They do not share our faith."))


/datum/component/psyblessed
	var/is_blessed
	var/pre_blessed
	var/added_force
	var/added_blade_int
	var/added_int
	var/silver

/datum/component/psyblessed/Initialize(preblessed = FALSE, force, blade_int, int, makesilver)
	if(!istype(parent, /obj/item/weapon))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	pre_blessed = preblessed
	added_force = force
	added_blade_int = blade_int
	added_int = int
	silver = makesilver
	if(pre_blessed)
		apply_bless()

/datum/component/psyblessed/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(!is_blessed)
		examine_list += span_info("<font color = '#cfa446'>This object may be blessed by the lingering fragment of Psydon. Until then, its impure alloying of silver-and-steel cannot blight inhumen foes on its own.</font>")
	if(is_blessed)
		examine_list += span_info("<font color = '#46bacf'>This object has been blessed by the fragment of Psydon.</font>")
		if(silver)
			examine_list += span_info("It has been imbued with <b>silver</b>.")

/datum/component/psyblessed/proc/try_bless()
	if(!is_blessed)
		apply_bless()
		play_effects()
		return TRUE
	else
		return FALSE

/datum/component/psyblessed/proc/play_effects()
	if(isitem(parent))
		var/obj/item/I = parent
		playsound(I, 'sound/magic/holyshield.ogg', 100)
		I.visible_message(span_notice("[I] glistens with power!"))

/datum/component/psyblessed/proc/apply_bless()
	if(isitem(parent))
		var/obj/item/I = parent
		is_blessed = TRUE
		I.force += added_force
		if(I.force_wielded)
			I.force_wielded += added_force
		if(I.max_blade_int)
			I.max_blade_int += added_blade_int
			I.blade_int = I.max_blade_int
		I.modify_max_integrity(I.max_integrity + added_int)
		I.name = "blessed [I.name]"
		if(silver)
			I.enchant(/datum/enchantment/silver)

/obj/effect/temp_visual/censer_dust
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	duration = 8

/obj/item/inqarticles
	item_flags = ITEM_ONLY_BREAK

/obj/item/inqarticles/indexer
	name = "\improper INDEXER"
	desc = "A blessed ampoule with a retractable bladetip, intended to further information gathering through hematology. Siphon blood from an individual until the INDEXER clicks shut, then mail it back to the Oratorium for cataloguing."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "indexer"
	item_state = "indexer"
	throw_speed = 3
	throw_range = 7
	grid_height = 32
	grid_width = 32
	throwforce = 15
	force = 4
	tool_behaviour = null
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	sharpness = IS_SHARP
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 0
	verb_exclaim = "blares"
	var/cursedblood
	var/active
	var/full
	var/timestaken
	var/working
	var/datum/weakref/subject = null

/obj/item/inqarticles/indexer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active)
		playsound(user, 'sound/items/indexer_shut.ogg', 65, TRUE)
		possible_item_intents = list(/datum/intent/use)
		user.update_a_intents()
		if(!full)
			active = FALSE
			working = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/indexer/dropped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active)
		possible_item_intents = list(/datum/intent/use)
		user.update_a_intents()
		playsound(user, 'sound/items/indexer_shut.ogg', 65, TRUE)
		if(!full)
			active = FALSE
			working = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/indexer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/inqarticles/indexer/attack_self(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		return
	if(working)
		return
	if(active)
		playsound(src, 'sound/items/indexer_shut.ogg', 75, FALSE, 3)
		possible_item_intents = list(/datum/intent/use)
		tool_behaviour = initial(tool_behaviour)
		user.update_a_intents()
		if(!full)
			active = FALSE
		update_appearance(UPDATE_ICON_STATE)
		return

	if(full)
		to_chat(user, span_notice("It's ready to be sent back to the Oratorium."))
		return

	possible_item_intents = list(/datum/intent/use, /datum/intent/dagger/cut)
	tool_behaviour = TOOL_SCALPEL
	user.update_a_intents()
	playsound(src, 'sound/items/indexer_open.ogg', 75, FALSE, 3)
	active = TRUE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/indexer/update_icon_state()
	. = ..()

	if(full)
		if(cursedblood)
			icon_state = "indexer_cursed"
		else
			icon_state = "indexer_primed"
		return

	if(active)
		if(timestaken)
			icon_state = "indexer_used"
		else
			icon_state = "indexer_ready"
		return

	if(timestaken)
		icon_state = "indexer_full"
	else
		icon_state = initial(icon_state)

/obj/item/inqarticles/indexer/proc/fullreset(mob/user)
	possible_item_intents = list(/datum/intent/use)
	user.update_a_intents()
	cursedblood = initial(cursedblood)
	working = initial(working)
	full = initial(full)
	timestaken = initial(timestaken)
	desc = initial(desc)
	active = FALSE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/indexer/attack_hand_secondary(mob/user)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!full)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(browser_alert(user, "EMPTY THE INDEXER?", "INDEXING...", "YES", "NO") != "NO")
		playsound(src, 'sound/items/indexer_empty.ogg', 75, FALSE, 3)
		visible_message(span_warning("[src] boils its contents away!"))
		fullreset(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/inqarticles/indexer/proc/takeblood(mob/living/M, mob/living/user)
	if(timestaken >= 8)
		playsound(src, 'sound/items/indexer_finished.ogg', 75, FALSE, 3)
		working = FALSE
		full = TRUE
		visible_message(span_warning("[src] finishes drawing blood!"))
		active = FALSE
		desc += span_notice(" It's full!")
		if(cursedblood)
			playsound(src, 'sound/items/indexer_cursed.ogg', 100, FALSE, 3)
			possible_item_intents = list(/datum/intent/use)
			user.update_a_intents()
			active = FALSE
			update_appearance(UPDATE_ICON_STATE)
			say("CURSED BLOOD!")
			return
		update_appearance(UPDATE_ICON_STATE)
		return

	working = TRUE
	playsound(src, 'sound/items/indexer_working.ogg', 75, FALSE, 3)
	if(active && working && !full)
		if(do_after(user, 20, M))
			M.flash_fullscreen("redflash3")
			if(!HAS_TRAIT(M, TRAIT_NOPAIN) || !HAS_TRAIT(M, TRAIT_NOPAINSTUN))
				if(prob(15))
					M.emote("whimper", forced = TRUE)
				else if(prob(15))
					M.emote("painmoan", forced = TRUE)
			desc = initial(desc)
			subject = WEAKREF(M)
			desc += span_notice(" It contains the blood of [M.real_name]!")
			visible_message(span_warning("[src] draws from [M]!"))
			playsound(M, 'sound/combat/hits/bladed/genstab (1).ogg', 30, FALSE, -1)
			timestaken++
			M.blood_volume = max(M.blood_volume-30, 0)
			M.handle_blood()
			if(M.mind)
				if(M.mind.has_antag_datum(/datum/antagonist/werewolf, FALSE))
					cursedblood = 3
				if(M.mind.has_antag_datum(/datum/antagonist/werewolf/lesser, FALSE))
					cursedblood = 2
				if(M.mind.has_antag_datum(/datum/antagonist/vampire/lords_spawn, FALSE))
					cursedblood = 1
				if(M.mind.has_antag_datum(/datum/antagonist/vampire, FALSE))
					cursedblood = 2
				if(M.mind.has_antag_datum(/datum/antagonist/vampire/lord))
					cursedblood = 3
			update_appearance(UPDATE_ICON_STATE)
			takeblood(M, user)
		else
			working = FALSE

/obj/item/inqarticles/indexer/attack(mob/living/M, mob/living/user, list/modifiers)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		to_chat(user, span_warning("I don't know how to use this."))
	if(!active)
		to_chat(user, span_warning("It's not primed."))
		return
	if(HAS_TRAIT(M, TRAIT_BLOODLOSS_IMMUNE))
		to_chat(user, span_warning("They don't have any blood to sample."))
		return
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(NOBLOOD in C.dna.species.species_traits)
			to_chat(user, span_warning("They don't have any blood to sample."))
			return
	if(full)
		to_chat(user, span_warning("It's full."))
		return

	visible_message(span_warning("[user] goes to jab [M] with [src]!"))
	if(do_after(user, 2 SECONDS, M))
		takeblood(M, user)

/obj/item/inqarticles/tallowpot
	name = "tallowpot"
	desc = "A small metal pot meant for holding waxes or melted redtallow. Convenient for coating signet rings and making an imprint. The warmth of a torch or lamptern should be enough to melt the redtallow for stamping writs."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "tallowpot"
	item_state = "tallowpot"
	dropshrink = 0.9
	throw_speed = 1
	throw_range = 3
	throwforce = 5
	possible_item_intents = list(/datum/intent/use)
	grid_height = 32
	grid_width = 32
	obj_flags = CAN_BE_HIT
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	embedding = null
	var/tallow
	var/remaining
	var/heatedup
	var/messageshown = 1
	sellprice = 0

/obj/item/inqarticles/tallowpot/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)	// For making sure it melts.

/obj/item/inqarticles/tallowpot/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/inqarticles/tallowpot/process()
	if(heatedup > 0)
		heatedup -= 4
		remaining = max(remaining - 20, 0)
		messageshown = 0
	else
		if(tallow)
			if(!messageshown)
				visible_message(span_info("The redtallow in [src] hardens again."))
				messageshown = 1
			update_appearance(UPDATE_ICON_STATE)
	if(remaining == 0)
		qdel(tallow)
		tallow = initial(tallow)
		update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/tallowpot/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/tallow))
		if(!istype(I,/obj/item/reagent_containers/food/snacks/tallow/red)) // Tells players to make redtallow.
			to_chat(user,span_warning("Normal tallow lacks the properties to act as wax. Add viscera to it first."))
			return
		if(!tallow)
			var/obj/item/reagent_containers/food/snacks/tallow/red/Q = I
			tallow = Q
			user.transferItemToLoc(Q, src, TRUE)
			remaining = 300
			update_appearance(UPDATE_ICON_STATE)
		else
			to_chat(user, span_info("[src] already has redtallow in it."))


	if(istype(I, /obj/item/flashlight/flare/torch))
		heatedup = 28
		visible_message(span_info("[user] warms [src] with [I]."))
		update_appearance(UPDATE_ICON_STATE)

	if(istype(I, /obj/item/clothing/ring/signet))
		if(tallow && heatedup)
			var/obj/item/clothing/ring/signet/ring = I
			ring.tallowed = TRUE
			ring.update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/tallowpot/update_icon_state()
	. = ..()
	if(tallow)
		icon_state = "[initial(icon_state)]_filled"
		if(heatedup)
			icon_state = "[initial(icon_state)]_melted"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/rope/inqarticles/inquirycord
	name = "inquiry cordage"
	desc = "A length of thick leather inquiry cordage that has been dipped in both holy water and dye before being consecrated and spell-laced. Intended for apprehending foes and rethreading tools at the worst of times."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "inqcordage"
	item_state = "inqcordage"
	throw_speed = 1
	throw_range = 3
	throwforce = 5
	breakouttime = 8 SECONDS
	slipouttime = 900 // 1:30.
	possible_item_intents = list(/datum/intent/tie)
	//cuffsound = 'sound/misc/cordage.ogg'
	grid_height = 32
	grid_width = 32
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	embedding = null
	sellprice = 0

/obj/item/rope/inqarticles/inquirycord/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/inqarticles/garrote // Do not give this item out freely to other classes. Do not subtype this item for other classes. This is intended purely as the Confessor's identifying sidegrade, and as a bonus for the Inspector INQ. I will be very sad if you disregard this comment. Thank you. - Yische.
	name = "\proper seizing garrote" // It's nonlethal. It's so silly and fun.
	desc = "A macabre instrument favored by the more clandestine of the Psydonian Silver Order; A length of thick leather inquiry cordage that has been dipped in both holy water and dye before being consecrated and spell-laced, held and threaded between two iron links. Perfect for apprehension."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "garrote"
	throw_speed = 3
	throw_range = 7
	grid_height = 32
	grid_width = 32
	throwforce = 15
	force_wielded = 0
	force = 0
	obj_flags = CAN_BE_HIT
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	experimental_inhand = TRUE
	max_integrity = 400
	w_class = WEIGHT_CLASS_SMALL
	can_parry = FALSE
	break_sound = 'sound/items/garrotebreak.ogg'
	gripped_intents = list(/datum/intent/garrote/grab, /datum/intent/garrote/choke)
	var/datum/weakref/victim
	var/datum/weakref/lastuser
	var/obj/item/grabbing/currentgrab
	var/active = FALSE
	var/choke_damage = 8
	integrity_failure = 0.01
	sellprice = 0
	wield_block = FALSE

	var/static/list/wield_sounds = list('sound/items/garrote.ogg', 'sound/items/garrote2.ogg')

/obj/item/inqarticles/garrote/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/garrote/choke
	name = "choke"
	icon_state = "inchoke"
	desc = "Used to begin choking the target out."
	no_attack = TRUE

/datum/intent/garrote/grab
	name = "grab"
	icon_state = "ingrab"
	desc = "Used to wrap around the target."
	no_attack = TRUE

/obj/item/inqarticles/garrote/atom_break(damage_flag, silent)
	. = ..()
	if(!ismob(loc))
		return
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		var/datum/component/two_handed/twohanded = GetComponent(/datum/component/two_handed)
		if(ismob(loc))
			var/mob/M = loc
			twohanded.unwield(M)
			to_chat(M, span_warning("The [src] SNAPS and breaks!"))
	update_appearance()

/obj/item/inqarticles/garrote/atom_fix()
	. = ..()
	update_appearance()

/obj/item/inqarticles/garrote/deconstruct(disassembled)
	return

/obj/item/inqarticles/garrote/update_name(updates)
	. = ..()
	if(obj_broken)
		name = "\proper snapped seizing garrote"
	else
		name = initial(name)

/obj/item/inqarticles/garrote/update_icon_state()
	icon_state = initial(icon_state)
	. = ..()
	if(obj_broken)
		icon_state = "garrote_snap"

/obj/item/inqarticles/garrote/apply_components()
	AddComponent(/datum/component/two_handed, \
		wieldsound = wield_sounds, \
		unwieldsound = 'sound/items/garroteshut.ogg', \
		force_unwielded = force, \
		force_wielded = force_wielded, \
		icon_wielded = "garrote1", \
		wield_callback = CALLBACK(src, PROC_REF(on_wield)), \
		unwield_callback = CALLBACK(src, PROC_REF(on_unwield)), \
		wield_block_offhand = wield_block)

/obj/item/inqarticles/garrote/proc/reset_garrote()
	SIGNAL_HANDLER

	var/mob/living/garrote_victim = victim?.resolve()
	if(garrote_victim)
		REMOVE_TRAIT(garrote_victim, TRAIT_MUTE, "garroteCordage")
	UnregisterSignal(garrote_victim, list(COMSIG_LIVING_RESIST_GRAB, COMSIG_PARENT_QDELETING))
	victim = null

	var/mob/living/last_garrote_user = lastuser?.resolve()
	UnregisterSignal(last_garrote_user, COMSIG_ATOM_NO_LONGER_PULLING)
	lastuser = null

	// If stop_pulling() is called, this will be qdeleted already. If reset_garrote is called first, this qdel should call stop_pulling().
	if(!QDELETED(currentgrab))
		QDEL_NULL(currentgrab)

	active = FALSE

/obj/item/inqarticles/garrote/on_unwield(obj/item/source, mob/living/carbon/user)
	. = ..()
	reset_garrote()

/obj/item/inqarticles/garrote/attack_self(mob/user)
	if(obj_broken)
		to_chat(user, span_warning("It's useless right now, but I can rethread it with cordage."))
		return TRUE
	return ..()

/obj/item/inqarticles/garrote/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/rope/inqarticles/inquirycord))
		user.visible_message(span_notice("[user] starts to rethread the [src] using \the [I]."))
		if(do_after(user, 12 SECONDS, user))
			qdel(I)
			update_integrity(max_integrity)
		else
			user.visible_message(span_warning("[user] stops rethreading the [src]."))
		return TRUE

/obj/item/inqarticles/garrote/afterattack(mob/living/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	var/mob/living/garrote_victim = victim?.resolve()
	if(istype(user.used_intent, /datum/intent/garrote/grab))	// Grab your target first.
		if(!iscarbon(target))
			return
		if(!proximity_flag)
			return
		if(garrote_victim == target)
			return
		/*
		if(HAS_TRAIT(target, TRAIT_GRABIMMUNE))
			playsound(src, pick('sound/items/garrote.ogg', 'sound/items/garrote2.ogg'), 65, TRUE)
			user.visible_message(span_danger("[target] slips past [user]'s attempt to [src] them!"))
			return
		*/
		// THROAT TARGET RESTRICTION. HEAVILY REQUESTED.
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("I need to wrap it around their throat."))
			return
		if(user.pulling)
			user.stop_pulling()
		reset_garrote()
		ADD_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
		if(!user.start_pulling(target, state = GRAB_AGGRESSIVE, suppress_message = TRUE, accurate = TRUE))
			REMOVE_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
			return
		REMOVE_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
		begin_garrote(target, user)
		var/obj/item/grabbing/I = user.get_inactive_held_item()
		if(istype(I, /obj/item/grabbing)) // generate an invisible grabbing item to simulate grabbing behavior
			I.icon_state = null
			currentgrab = I
		playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)
		user.visible_message(span_danger("[user] wraps the [src] around [target]'s throat!"))
		user.adjust_stamina(25)
		user.changeNext_move(CLICK_CD_MELEE)

	if(istype(user.used_intent, /datum/intent/garrote/choke))	// Get started.
		if(!garrote_victim)
			to_chat(user, span_warning("Who am I choking? What?"))
			return
		if(!proximity_flag)
			return
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("I need to constrict the throat."))
			return
		user.adjust_stamina(rand(4, 8))
		var/mob/living/carbon/C = garrote_victim
		// if(get_location_accessible(C, BODY_ZONE_PRECISE_NECK))
		playsound(src, pick('sound/items/garrotechoke1.ogg', 'sound/items/garrotechoke2.ogg', 'sound/items/garrotechoke3.ogg', 'sound/items/garrotechoke4.ogg', 'sound/items/garrotechoke5.ogg'), 100, TRUE)
		if(prob(40))
			C.emote("choke")
		C.adjustOxyLoss(choke_damage)
		C.visible_message(span_danger("[user] [pick("garrotes", "asphyxiates")] [C]!"), \
		span_userdanger("[user] [pick("garrotes", "asphyxiates")] me!"), span_hear("I hear the sickening sound of cordage!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("I [pick("garrote", "asphyxiate")] [C]!"))
		user.changeNext_move(CLICK_CD_RESIST)	//Stops spam for choking.

/obj/item/inqarticles/garrote/proc/begin_garrote(mob/living/target, mob/living/user)
	active = TRUE
	ADD_TRAIT(target, TRAIT_MUTE, "garroteCordage")
	RegisterSignal(target, COMSIG_LIVING_RESIST_GRAB, PROC_REF(on_victim_resist))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(reset_garrote))
	RegisterSignal(user, COMSIG_ATOM_NO_LONGER_PULLING, PROC_REF(reset_garrote))
	victim = WEAKREF(target)
	lastuser = WEAKREF(user)

/obj/item/inqarticles/garrote/proc/on_victim_resist(datum/source, mob/living/resistor, mob/living/pulledby, moving_resist, resist_outcome)
	SIGNAL_HANDLER
	if(resist_outcome) // true means resist_grab() failed
		if(!resistor.mind) // NPCs do less damage to the garrote
			take_damage(max_integrity * 0.0125) // 400 max = 5 damage
		else
			take_damage(max_integrity * 0.025) // 400 max = 10 damage
	else
		if(!resistor.mind)
			take_damage(max_integrity * 0.05)
		else
			take_damage(max_integrity * 0.1)

/obj/item/inqarticles/garrote/razor // To yische, who said not to give this out constantly, I respectfully disagree when it comes to assassin
	name = "profane razor" // It's very not non lethal now.  Strangle your prey with glee
	desc = "A thin strand of phantom black wire strung between steel grasps. Cold to the touch even through gloves. The strand of wire, while appearing fragile, is seemingly unbreakable."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "garrote"
	item_state = "garrote"
	resistance_flags = INDESTRUCTIBLE
	choke_damage = 16
	sellprice = 100

/obj/item/clothing/head/inqarticles/blackbag
	name = "black bag"
	desc = "A heavily spell-weaved padded sack intended to muffle the cries made within it. Due to the heaviness of the materials involved, application and removal of these is usually difficult for the untrained."
	icon_state = "blackbag"
	item_state = "blackbag"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	armor = ARMOR_BLACKBAG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	unequip_delay_self = 45
	equip_delay_other = 360 SECONDS // No getting around it. Cheater. LEFT CLICK THEM!!!
	equip_delay_self = 360 SECONDS
	max_integrity = 10000 // No breaking it. NO CHEAP FRAGS.
	strip_delay = 10
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = FULL_HEAD
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	grid_width = 32
	grid_height = 64
	var/worn = FALSE
	var/bagging = FALSE

/obj/item/clothing/head/inqarticles/blackbag/proc/bagsound(mob/living/M)
	if(bagging)
		playsound(M, pick('sound/misc/blackbag.ogg','sound/misc/blackbag2.ogg','sound/misc/blackbag3.ogg','sound/misc/blackbag4.ogg','sound/misc/blackbag5.ogg'), 100, TRUE, 4)
	else
		return

/obj/item/clothing/head/inqarticles/blackbag/proc/bagcheck(mob/living/M)
	var/timer = 10
	bagsound(M)
	for(timer, timer < 120, timer += 10)
		if(bagging)
			addtimer(CALLBACK(src, PROC_REF(bagsound), M), timer)

/obj/item/clothing/head/inqarticles/blackbag/attack(mob/living/target, mob/living/user, list/modifiers)
	. = ..()
	if(!iscarbon(target))
		return
	if(HAS_TRAIT(target, TRAIT_BAGGED))
		to_chat(user, span_warning("They've already been bagged."))
		return
	var/obj/item/headgear = target.get_item_by_slot(ITEM_SLOT_HEAD)
	var/trained = FALSE
	var/timetobag = 8 SECONDS
	if(HAS_TRAIT(user, TRAIT_BLACKBAGGER))
		trained = TRUE
		timetobag = 4 SECONDS
	user.visible_message(span_danger("[user] goes to [trained ? "expertly" : "clumsily"] black bag [target]!"))
	/*
	if(HAS_TRAIT(target, TRAIT_GRABIMMUNE))
		user.visible_message(span_danger("[target] slips past [user]'s attempt to black bag them!"))
		playsound(target, pick('sound/misc/blackbag.ogg','sound/misc/blackbag2.ogg','sound/misc/blackbag3.ogg','sound/misc/blackbag4.ogg','sound/misc/blackbag5.ogg'), 100, TRUE, 4)
		return
	*/
	if(!target.stat)
		/* if(HAS_TRAIT(user, TRAIT_BLACKBAGGER) && !M.cmode) It was too much to handle. Too cold to hold.
			bagging = TRUE
			bagsound(target)
			headgear.doStrip(user, target)
			target.equip_to_slot(src, SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
			bagging = FALSE
		else*/
		bagging = TRUE
		bagcheck(target)
		if(do_after(user, timetobag, target))
			bagging = FALSE
			headgear.doStrip(user, target)
			target.equip_to_slot(src, ITEM_SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
		else
			bagging = FALSE
	else
		bagging = TRUE
		bagcheck(target)
		if(do_after(user, timetobag / 2, target))
			bagging = FALSE
			headgear.doStrip(user, target)
			target.equip_to_slot(src, ITEM_SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
		else
			bagging = FALSE

/obj/item/clothing/head/inqarticles/blackbag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.head == src)
		bagging = FALSE
		user.become_blind("blindfold_[REF(src)]")
		playsound(user, pick('sound/misc/blackbagequip.ogg', 'sound/misc/blackbagequip2.ogg'), 100, TRUE, 4)
		user.playsound_local(src, 'sound/misc/blackbagloop.ogg', 100, FALSE)
		worn = TRUE
		ADD_TRAIT(user, TRAIT_BAGGED, TRAIT_GENERIC)

/obj/item/clothing/head/inqarticles/blackbag/dropped(mob/living/carbon/human/user)
	..()
	if(worn == TRUE)
		user.cure_blind("blindfold_[REF(src)]")
		worn = FALSE
		update_integrity(max_integrity)
		REMOVE_TRAIT(user, TRAIT_BAGGED, TRAIT_GENERIC)
		playsound(user, pick('sound/misc/blackunbag.ogg'), 100, TRUE, 4)
		user.emote("gasp", forced = TRUE)
		return

/obj/item/clothing/head/inqarticles/blackbag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
				"sx" = -4,
				"sy" = -7,
				"nx" = 6,
				"ny" = -6,
				"wx" = -2,
				"wy" = -7,
				"ex" = -1,
				"ey" = -7,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 0,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/inqarticles/bmirror
	name = "black mirror"
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bmirror"
	item_state = "bmirror"
	grid_height = 64
	grid_width = 32
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	force = 15
	dropshrink = 0
	hitsound = 'sound/blank.ogg'
	sellprice = 0
	resistance_flags = FIRE_PROOF
	var/opened = FALSE
	var/fedblood = FALSE
	var/bloody = FALSE
	var/openstate = "open"
	var/usesleft = 3
	var/active = FALSE
	var/broken = FALSE
	/// Target name
	var/datum/weakref/fixation
	/// One with the bleed in the mirror
	var/datum/weakref/feeder
	var/atom/movable/screen/alert/blackmirror/effect
	var/datum/looping_sound/blackmirror/soundloop

/obj/item/inqarticles/bmirror/Initialize()
	. = ..()
	soundloop = new(src, FALSE)

/obj/item/inqarticles/bmirror/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	if(effect)
		QDEL_NULL(effect)
	fixation = null
	feeder = null
	return ..()

/obj/item/inqarticles/bmirror/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = "A mass-produced relic of the Oratorium Throni Vacui. The exact method of the Black Mirror's operation remains a well-kept secret. One worth dying over, supposedly."
	else
		desc = ""

/obj/item/inqarticles/bmirror/proc/donefixating()
	bloody = TRUE
	active = FALSE
	fedblood = FALSE
	openstate = "bloody"
	feeder = null
	var/mob/living/fixated = fixation?.resolve()
	if(fixated)
		fixated.clear_alert("blackmirror", TRUE)
		fixated.playsound_local(src, 'sound/items/blackeye.ogg', 40, FALSE)
	effect = null
	fixation = null
	usesleft--
	soundloop.stop()
	visible_message(span_info("[src] clouds itself with a chilling fog."))
	playsound(src, 'sound/items/blackmirror_no.ogg', 100, FALSE)
	update_appearance(UPDATE_ICON_STATE)
	if(usesleft == 0)
		addtimer(CALLBACK(src, PROC_REF(try_break)), 2 SECONDS)

/obj/item/inqarticles/bmirror/proc/try_break()
	if(QDELETED(src))
		return
	broken = TRUE
	playsound(src, 'sound/items/blackmirror_break.ogg', 100, FALSE)
	visible_message(span_info("[src] shatters, fog spilling from the splintering shards into the dead air."))
	openstate = "broken"
	update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/bmirror/attack_self(mob/user, params)
	. = ..()
	if(!user.mind)
		return

	if(!opened)
		to_chat(user, span_warning("It's not open."))
		return

	if(broken && bloody)
		to_chat(user, span_warning("The mirror has shattered, rendering it unusable."))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			to_chat(user, span_notice("If I clean it, I can send it back to the Inquisition for repairs."))
		return

	if(broken && !bloody)
		to_chat(user, span_warning("The mirror has shattered, rendering it unusable. It's clean, at the very least."))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			to_chat(user, span_notice("It's returnable via the HERMES now. I should get two Marques back."))
		return

	if(bloody)
		to_chat(user, span_warning("The mirror is fogged over. I need to clean the blood from it with cloth before reuse."))
		return

	if(!fedblood)
		to_chat(user, span_warning("It looks like it needs blood to work properly."))
		return

	if(!active)
		var/input = browser_alert(user, "WHAT DO YOU SEEK?", "THE PRICE IS PAID", list("BLOOD", "FIXATION"))
		if(!input || QDELETED(user) || QDELETED(src))
			return

		var/mob/living/carbon/human/target

		if(input == "FIXATION")
			var/name = browser_input_text(user, "WHO DO YOU SEEK?", "THE PRICE IS PAID")
			if(!name)
				return
			for(var/mob/living/carbon/human/HL as anything in GLOB.player_list)
				if(HL.real_name == name)
					fixation = WEAKREF(HL)
					target = HL
				playsound(src, 'sound/items/blackmirror_no.ogg', 100, FALSE)
				to_chat(user, span_warning("[src] makes a grating sound."))
				return
		else if(input == "BLOOD")
			target = feeder?.resolve()

		if(!target)
			return

		active = TRUE
		openstate = "active"
		update_appearance(UPDATE_ICON_STATE)
		soundloop.start()

		effect = target.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
		effect.source = src

		target.playsound_local(target, 'sound/items/blackeye_warn.ogg', 100, FALSE)

		playsound(src, 'sound/items/blackmirror_active.ogg', 100, FALSE)
		addtimer(CALLBACK(src, PROC_REF(donefixating)), 2 MINUTES, TIMER_UNIQUE)

		message_admins("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
		log_game("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
		return

	var/datum/weakref/lookat = fixation ? fixation : feeder
	var/mob/living/target = lookat?.resolve()
	if(!target)
		to_chat(user, span_notice("The mirror remains clear..."))
		return

	playsound(src, 'sound/items/blackmirror_use.ogg', 100, FALSE)

	ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "blackmirror")

	var/mob/dead/observer/screye/blackmirror/S = user.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	S.add_client_colour(/datum/client_colour/nocshaded)
	user.visible_message(span_warning("[user] stares into [src], their eyes glazing over..."))

	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 4 SECONDS)
	addtimer(CALLBACK(user, GLOBAL_PROC_REF(playsound), user, 'sound/items/blackeye.ogg', 100, FALSE), 4 SECONDS)
	addtimer(TRAIT_CALLBACK_REMOVE(user, TRAIT_NOSSDINDICATOR, "blackmirror"), 4 SECONDS)

/obj/item/inqarticles/bmirror/attack(mob/living/carbon/human/attacked, mob/living/carbon/human/user, list/modifiers)
	if(!istype(attacked) || !istype(user))
		return ..()

	if(!opened)
		to_chat(user, span_warning("I need to open it first."))
		return

	if(feeder)
		to_chat(user, span_warning("It's already been fed."))
		return

	if(broken)
		to_chat(user, span_warning("It's broken."))
		return

	if(bloody)
		to_chat(user, span_warning("The mirror is fogged over. I need to clean it with cloth before reuse."))
		return

	var/time_taken = 3 SECONDS

	if(attacked == user)
		user.visible_message(span_notice("[user] presses upon [src]'s needle."))
	else
		user.visible_message(span_notice("[user] goes to press [attacked] with [src]'s needle."))
		time_taken *= 2

	if(do_after(user, time_taken, attacked))
		playsound(src, 'sound/items/blackmirror_needle.ogg', 95, FALSE, 3)
		attacked.flash_fullscreen("redflash3")
		attacked.adjustBruteLoss(40)
		attacked.blood_volume = max(attacked.blood_volume - 240, 0)
		attacked.handle_blood()
		feeder = WEAKREF(attacked)
		openstate = "bloody"
		fedblood = TRUE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/bmirror/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(!istype(I, /obj/item/natural/cloth))
		return

	if(broken && bloody && do_after(user, 3 SECONDS, user))
		user.visible_message(span_info("[user] cleans [src] with [I]."))
		openstate = "cleaned"
		bloody = FALSE
		update_appearance(UPDATE_ICON_STATE)
	else if(bloody && do_after(user, 3 SECONDS, user))
		user.visible_message(span_info("[user] cleans the fog and blood from [src] with [I]."))
		openstate = "open"
		bloody = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/bmirror/attack_hand_secondary(mob/user, params)
	. = ..()
	openorshut(user)

/obj/item/inqarticles/bmirror/proc/openorshut(mob/user)
	if(active)
		to_chat(user, span_warning("I cannot close the mirror while it's active."))
		return

	var/mob/living/fixated = fixation?.resolve()
	if(opened)
		if(fixated)
			fixated.clear_alert("blackmirror", TRUE)
			fixated.playsound_local(src, 'sound/items/blackeye.ogg', 40, FALSE)
		else if(effect)
			QDEL_NULL(effect)
		playsound(src, 'sound/items/blackmirror_shut.ogg', 100, FALSE)
		opened = FALSE
		update_appearance(UPDATE_ICON_STATE)
		return

	playsound(src, 'sound/items/blackmirror_open.ogg', 100, FALSE)

	if(fixated)
		fixated.playsound_local(src, 'sound/items/blackeye_warn.ogg', 100, FALSE)
		effect = fixated.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
		effect.source = src

	opened = TRUE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/inqarticles/bmirror/update_icon_state()
	. = ..()

	if(opened)
		icon_state = "[initial(icon_state)]_[openstate]"
	else
		icon_state = "[initial(icon_state)]"

/atom/movable/screen/alert/blackmirror
	name = "BLACK EYE"
	desc = "LOOK AT ME. I SEE YOU."
	icon_state = "blackeye"
	var/obj/item/inqarticles/bmirror/source

/atom/movable/screen/alert/blackmirror/Destroy()
	source = null
	return ..()

/atom/movable/screen/alert/blackmirror/Click()
	var/mob/living/L = usr
	if(!istype(L))
		return

	var/datum/weakref/lookat = null
	if(alert(L, "KEEP LOOKING, WHAT WILL YOU FIND?", "BLACK EYED GAZE", "BLOOD", "MIRROR") != "BLOOD")
		lookat = source
	else
		lookat = source.feeder
	playsound(L, 'sound/items/blackmirror_use.ogg', 100, FALSE)
	ADD_TRAIT(L, TRAIT_NOSSDINDICATOR, "blackmirror")
	var/mob/living/target = lookat?.resolve()
	if(!target)
		return
	var/mob/dead/observer/screye/blackmirror/S = L.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	S.add_client_colour(/datum/client_colour/nocshaded)
	L.visible_message(span_warning("[L] looks inward as their eyes glaze over..."))

	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 4 SECONDS)
	addtimer(CALLBACK(L, GLOBAL_PROC_REF(playsound), L, 'sound/items/blackeye.ogg', 100, FALSE), 4 SECONDS)
	addtimer(TRAIT_CALLBACK_REMOVE(L, TRAIT_NOSSDINDICATOR, "blackmirror"), 4 SECONDS)

// FINISH THIS AT YOUR LEISURE. I'M JUST LEAVING IT HERE UNIMPLEMENTED. IT'S INTENDED TO WORK AS A COMBINATION OF THE NOC FAR-SIGHT AND THE NOCSHADES. HAVE FUN! - YISCHE
/obj/item/inqarticles/spyglass
	name = "otavan nocshade eyepiece"
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "spyglass"
	item_state = "spyglass"
	grid_height = 32
	grid_width = 32

/obj/item/inqarticles/spyglass/attack_self(mob/living/user)
	. = ..()
