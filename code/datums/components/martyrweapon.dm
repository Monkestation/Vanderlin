#define STATE_SAFE 			0
#define STATE_MARTYR		1
#define STATE_MARTYRULT		2

// Im so fucking sorry. This is a mostly 1-1 Azure port. God save my soul for the sins I have comitted
// Stats, traits, and skills are maybe possibly balanced to us? Its still bad.

/datum/component/martyrweapon
	var/list/allowed_areas = list(/area/indoors/town/church/chapel)
	var/list/allowed_patrons = list()
	var/activatecooldown = 30 MINUTES
	var/last_activation = 0
	var/next_activation = 0
	var/end_activation = 0
	var/ignite_chance = 2
	var/traits_applied = list(TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_LONGSTRIDER)
	var/stat_bonus_martyr = 3
	var/mob/living/current_holder
	var/is_active = FALSE
	var/allow_all = FALSE
	var/is_activating
	var/current_state = STATE_SAFE
	var/martyr_duration = 6 MINUTES
	var/safe_duration = 9 MINUTES
	var/ultimate_duration = 2 MINUTES
	var/is_dying = FALSE
	var/death_time
	var/last_time
	var/second_wind

	var/list/active_intents = list()
	var/list/active_intents_wielded = list()
	var/list/inactive_intents = list()
	var/list/inactive_intents_wielded = list()

	var/active_safe_damage
	var/active_safe_damage_wielded

	COOLDOWN_DECLARE(weaponactivate)

/datum/component/martyrweapon/Initialize(list/intents, list/intents_w, active_damage, active_damage_wielded)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(length(intents))
		active_intents = intents.Copy()
	if(length(intents_w))
		active_intents_wielded = intents_w.Copy()

	if(active_damage)
		active_safe_damage = active_damage
	if(active_damage_wielded)
		active_safe_damage_wielded = active_damage_wielded

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

	var/obj/item/I = parent
	inactive_intents = I.possible_item_intents.Copy()
	inactive_intents_wielded = I.gripped_intents.Copy()

	START_PROCESSING(SSdcs, src)

/datum/component/martyrweapon/process()
	if(is_active)
		if(world.time > end_activation)
			handle_end()
		if(world.time > second_wind)
			adjust_stats(STATE_MARTYRULT)
		else
			var/timer = timehint()
			if(timer == 30 && current_state == STATE_MARTYRULT)
				adjust_stats(STATE_MARTYRULT)
	if(is_dying && death_time)
		if(world.time > death_time)
			killhost()

/datum/component/martyrweapon/proc/handle_end()
	deactivate()
	var/mob/living/carbon/C = current_holder
	switch(current_state)
		if(STATE_SAFE)
			var/area/A = get_area(current_holder)
			var/success = FALSE
			for(var/AR in allowed_areas)	//Are we in a whitelisted area? (Church, mainly)
				if(istype(A, AR))
					success = TRUE
					break
			if(!success)
				for(var/turf/T in view(world.view, C))	//One last mercy check to see if it fizzles out while the church is on-screen.
					var/mercyarea = get_area(T)
					for(var/AR in allowed_areas)
						if(istype(mercyarea, AR))
							success = TRUE
			if(success)
				to_chat(current_holder, span_notice("The weapon fizzles out, its energies dissipating across the holy grounds."))
			else
				to_chat(current_holder, span_notice("The weapon begins to fizzle out, but the energy has nowhere to go!"))
				C.freak_out()
				deathprocess()

		if(STATE_MARTYR, STATE_MARTYRULT)
			C.freak_out()
			deathprocess()

/datum/component/martyrweapon/proc/deathprocess()
	if(current_holder)
		current_holder.Stun(16000, 1, 1)	//Even if you glitch out to survive you're still permastunned, you are not meant to come back from this
		var/mob/living/carbon/human/H = current_holder
		if(H.cmode)	//Turn off the music
			H.toggle_cmode()
		addtimer(CALLBACK(src, PROC_REF(killhost)), 30 SECONDS)
		current_holder.visible_message(span_warning("[current_holder] falls to their knees, planting their weapon into the ground as holy energies pulse from their body!"), span_warning("My oath is fulfilled. I hope I made it count. I have thirty seconds to make peace with the Gods and my Kin."))
		current_holder.playsound_local(current_holder, 'sound/health/fastbeat.ogg', 100)

/datum/component/martyrweapon/proc/killhost()
	if(current_holder)
		var/mob/living/carbon/human/H = current_holder
		current_holder.playsound_local(current_holder, 'sound/magic/ahh1.ogg', 100)
		current_holder.visible_message(span_info("[current_holder] fades away."), span_info("Your life led up to this moment. In the face of the decay of the world, you endured. Now you rest. You feel your soul shed from its mortal coils, and the embrace of [H.patron.name]"))
		H.dust(drop_items = TRUE)
		is_dying = FALSE

//This gives a countdown to the user, it's pretty hacky
/datum/component/martyrweapon/proc/timehint()
	var/result = round((end_activation - world.time) / 600)	//Minutes
	if(result != last_time && last_time != 30)
		to_chat(current_holder,span_notice("[result + 1] minute[result ? "s" : ""] left."))
		last_time = result
		return result
	if(result == 0)
		var/resultadv = (end_activation - world.time) / 10	//Seconds
		if(resultadv < 30 && resultadv > 27 && last_time != 30)
			to_chat(current_holder,span_notice("30 SECONDS! MY POWER SURGES!!"))
			last_time = 30
			return 30
		else
			if(resultadv == 10 && last_time != 10)
				to_chat(current_holder,span_crit("10 SECONDS"))
				last_time = resultadv
	return 0

/datum/component/martyrweapon/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(is_active && proximity_flag)
		if(isobj(target))
			target.spark_act()
			target.fire_act()
		else if(isliving(target))
			var/mob/living/M = target
			switch(current_state)
				if(STATE_SAFE)
					return
				if(STATE_MARTYR, STATE_MARTYRULT)
					if(prob(ignite_chance))
						mob_ignite(M)
		else
			return
	else
		return

/datum/component/martyrweapon/proc/mob_ignite(mob/target)
	if(isliving(target))
		var/mob/living/M = target
		M.adjust_fire_stacks(5)
		M.IgniteMob()

/datum/component/martyrweapon/proc/on_equip(datum/source, mob/user, slot)
	if(!allow_all)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(user, TRAIT_ROTMAN) || HAS_TRAIT(user, TRAIT_NOBREATH))
				to_chat(H, span_warn("It burns and sizzles! It does not tolerate my pallid flesh!"))
				H.dropItemToGround(parent)
				return
			var/datum/job/J = SSjob.GetJob(H.job)
			if(J.title != "Grandmaster Templar")
				to_chat(H, span_warn("It slips from my grasp. I can't get a hold."))
				H.dropItemToGround(parent)
				return
			else
				RegisterSignal(user, COMSIG_CLICK_ALT, PROC_REF(altclick), override = TRUE)
				current_holder = user
			if(J.title == "Grandmaster Templar")
				to_chat(user, span_warning("The weapon binds to you."))
	else
		RegisterSignal(user, COMSIG_CLICK_ALT, PROC_REF(altclick), override = TRUE)
		current_holder = user

/datum/component/martyrweapon/proc/altclick(mob/user)
	if(user == current_holder && !is_active && !is_activating)
		var/holding = user.get_active_held_item()
		if(holding == parent)
			if(COOLDOWN_FINISHED(src, weaponactivate))
				if(!allow_all)
					var/A = get_area(user)
					if(A)
						var/area/testarea = A
						var/success = FALSE
						for(var/AR in allowed_areas)	//We check if we're in a whitelisted area (Church)
							if(istype(testarea, AR))
								success = TRUE
								break
						if(success)	//The SAFE option
							if(alert("You are within holy grounds. Do you wish to call your god to aid in its defense? (You will live if the duration ends within the Church.)", "Your Oath", "Yes", "No") == "Yes")
								is_activating = TRUE
								activate(user, STATE_SAFE)
						else	//The NOT SAFE option
							if(alert("You are trying to activate the weapon outside of holy grounds. Do you wish to fulfill your Oath of Vengeance? (You will die.)", "Your Oath", "Yes", "No") == "Yes")
								var/choice = alert("You pray to your god. How many minutes will you ask for? (Shorter length means greater boons)","Your Oath", "Six", "Two", "Nevermind")
								switch(choice)
									if("Six")
										is_activating = TRUE
										activate(user, STATE_MARTYR)
									if("Two")
										is_activating = TRUE
										activate(user, STATE_MARTYRULT)
									if("Nevermind")
										to_chat(user, "You reconsider. It is not the right moment.")
										return
				else
					activate(user)
		else
			to_chat(user, span_info("You must be holding the weapon in your active hand!"))


//IF it gets dropped, somehow (likely delimbing), turn it off immediately.
/datum/component/martyrweapon/proc/on_drop(datum/source, mob/user)
	if(current_holder == user)
		UnregisterSignal(user, COMSIG_CLICK_ALT)
	if(current_state == STATE_SAFE && is_active)
		deactivate()

/datum/component/martyrweapon/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(current_holder && current_holder == user)
		examine_list += span_notice("It looks to be bound to you. Alt + right click to activate it.")
	if(!COOLDOWN_FINISHED(src, weaponactivate))
		examine_list += span_notice("The time remaining until it is prepared: [COOLDOWN_TIMELEFT(src, weaponactivate) / 600] minutes")
	else
		examine_list += span_notice("It looks ready to be used again.")
	if(is_active)
		examine_list += span_warningbig("It is lit afire by godly energies!")
		if(user == current_holder)
			examine_list += span_warningbig("<i>SLAY THE HERETICS! TAKE THEM WITH YOU!</i>")

/datum/component/martyrweapon/proc/adjust_traits(remove = FALSE)
	for(var/trait in traits_applied)
		if(!remove)
			ADD_TRAIT(current_holder, trait, "martyrweapon")
		else
			REMOVE_TRAIT(current_holder, trait, "martyrweapon")

/datum/component/martyrweapon/proc/adjust_stats(state)
	if(current_holder)
		var/mob/living/carbon/human/H = current_holder
		switch(state)
			if(STATE_SAFE) //Lowered damage due to BURN damage type and SAFE activation
				var/obj/item/I = parent
				if(active_safe_damage)
					I.force = active_safe_damage
				if(active_safe_damage_wielded)
					I.force_wielded = active_safe_damage_wielded
				return
			if(STATE_MARTYR)
				current_holder.STASTR += stat_bonus_martyr
				//current_holder.STASPD += stat_bonus_martyr
				current_holder.STACON += stat_bonus_martyr
				current_holder.STAEND += stat_bonus_martyr
				current_holder.STAINT += stat_bonus_martyr
				current_holder.STAPER += stat_bonus_martyr
				current_holder.STALUC += stat_bonus_martyr
				H.adjust_energy(9999)
			if(STATE_MARTYRULT) // This ONLY triggers a minute and a half into the ult. They'll have this for thirty seconds and then DIE. Go off King.
				ADD_TRAIT(current_holder, TRAIT_NOSTAMINA, TRAIT_GENERIC)
				current_holder.STASTR = 20
				current_holder.STAPER = 20
				current_holder.STACON = 20
				current_holder.STAEND = 20

//This is called regardless of the activated state (safe or not)
/datum/component/martyrweapon/proc/deactivate()
	var/obj/item/I = parent
	if(HAS_TRAIT(parent, TRAIT_NODROP))
		REMOVE_TRAIT(parent, TRAIT_NODROP, TRAIT_GENERIC)	//The weapon can be moved by the Priest again (or used, I suppose)
	is_active = FALSE
	I.damtype = BRUTE
	I.possible_item_intents = inactive_intents
	I.gripped_intents = inactive_intents_wielded
	current_holder.update_a_intents()
	I.force = initial(I.force)
	I.force_wielded = initial(I.force_wielded)
	I.max_integrity = initial(I.max_integrity)
	I.slot_flags = initial(I.slot_flags)	//Returns its ability to be sheathed
	last_time = null	//Refreshes the countdown tracker

	COOLDOWN_START(src, weaponactivate, activatecooldown)
	adjust_traits(remove = TRUE)
	adjust_icons(tonormal = TRUE)

/datum/component/martyrweapon/proc/flash_lightning(mob/user)
	for(var/mob/living/carbon/M in viewers(world.view, user))
		M.lightning_flashing = TRUE
		M.update_sight()
	var/turf/T = get_step(get_step(user, NORTH), NORTH)
	T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
	playsound(user, 'sound/magic/lightning.ogg', 100, FALSE)

/datum/component/martyrweapon/proc/adjust_icons(tonormal = FALSE)
	var/obj/item/I = parent
	if(!tonormal)
		if(current_state == STATE_MARTYR || current_state == STATE_MARTYRULT)
			I.toggle_state = "[initial(I.icon_state)]_ulton"
		else
			I.toggle_state = "[initial(I.icon_state)]_on"
		I.item_state = "[I.toggle_state]1"
		I.icon_state = "[I.toggle_state]1"
	else
		I.icon_state = initial(I.icon_state)
		I.item_state = initial(I.item_state)
		I.toggle_state = null

	current_holder.regenerate_icons()

//This is called once all the checks are passed and the options are made by the player to commit.
/datum/component/martyrweapon/proc/activate(mob/user, status_flag)
	current_holder.visible_message("[span_notice("[current_holder] begins invoking their Oath!")]", span_notice("You begin to invoke your oath."))
	if(do_after(user, 5 SECONDS, parent))
		flash_lightning(user)
		var/obj/item/I = parent
		I.damtype = BURN	//Changes weapon damage type to fire
		I.possible_item_intents = active_intents
		I.gripped_intents = active_intents_wielded
		user.update_a_intents()
		I.slot_flags = null	//Can't sheathe a burning sword

		ADD_TRAIT(parent, TRAIT_NODROP, TRAIT_GENERIC)	//You're committed, now.

		if(status_flag)	//Important to switch this early.
			current_state = status_flag
		adjust_icons()
		switch(current_state)
			if(STATE_SAFE)
				end_activation = world.time + safe_duration	//Only a duration and nothing else.
				adjust_stats(current_state)	//Lowers the damage of the sword due to safe activation.
				current_holder.energy = current_holder.max_energy
				current_holder.stamina = 0
				I.blade_int = I.max_blade_int
			if(STATE_MARTYR)
				end_activation = world.time + martyr_duration

				I.max_blade_int = 9999
				I.blade_int = I.max_blade_int
				adjust_stats(current_state)	//Gives them extra stats.

				current_holder.stamina = 0
				current_holder.energy = current_holder.max_energy

			if(STATE_MARTYRULT)
				end_activation = world.time + ultimate_duration
				second_wind = world.time + ultimate_duration - 30 SECONDS

				I.max_blade_int = 9999
				I.blade_int = I.max_blade_int

				current_holder.adjust_skillrank(/datum/skill/misc/athletics, 6, FALSE)

				adjust_stats(STATE_MARTYR)

				current_holder.energy = current_holder.max_energy
				current_holder.stamina = 0

				current_holder.adjust_skillrank(/datum/skill/combat/swords, 1, FALSE)
				current_holder.adjust_skillrank(/datum/skill/combat/axesmaces, 1, FALSE)
				current_holder.adjust_skillrank(/datum/skill/combat/polearms, 1, FALSE)

			else
				end_activation = world.time + safe_duration

		if(ishuman(current_holder))
			var/mob/living/carbon/human/H = current_holder
			switch(status_flag)
				if(STATE_MARTYR)
					SEND_SOUND(H, sound(null))
					H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg' // Gets their normal music until pizza finishes his Great Work
				if(STATE_MARTYRULT)
					SEND_SOUND(H, sound(null))
					H.cmode_music = 'sound/music/cmode/church/CombatMartyrUlt.ogg'
			adjust_traits(remove = FALSE)
			if(!H.cmode)	//Turns on combat mode (it syncs up the audio neatly)
				H.toggle_cmode()
			else		//Gigajank to reset your combat music
				H.toggle_cmode()
				H.toggle_cmode()

		is_activating = FALSE
		is_active = TRUE
	else
		is_activating = FALSE
		SEND_SOUND(current_holder, sound(null))

#undef STATE_SAFE
#undef STATE_MARTYR
#undef STATE_MARTYRULT
