/obj/item/contraption
	name = "random piece of machinery"
	desc = "A cog with teeth meticulously crafted for tight interlocking."
	icon_state = "gear"
	var/on_icon
	var/off_icon
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/bronze
	slot_flags = ITEM_SLOT_HIP
	var/obj/item/accepted_power_source = /obj/item/gear/metal
	/// This is the amount of charges we get per power source
	var/charge_per_source = 5
	var/current_charge = 0
	var/misfire_chance
	var/sneaky_misfire_chance
	/// Are we misfiring? Important for chain reactions.
	var/misfiring = FALSE
	obj_flags_ignore = TRUE
	/// If this contraption should accept cogs that alter its behaviour
	var/special_cog = FALSE

/obj/item/contraption/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -6,
"sy" = -2,
"nx" = 9,
"ny" = -1,
"wx" = -6,
"wy" = -1,
"ex" = -2,
"ey" = -3,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 21,
"sturn" = -18,
"wturn" = -18,
"eturn" = 21,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/contraption/examine(mob/user)
	. = ..()
	if(!istype(user, /mob/living))
		return
	var/mob/living/player = user
	var/skill = player.get_skill_level(/datum/skill/craft/engineering)
	if(current_charge)
		. += span_warning("The contraption has [current_charge] charges left.")
	if(!current_charge)
		. += span_warning("This contraption requires a new [initial(accepted_power_source.name)] to function.")
	if(misfire_chance)
		if(skill > 2)
			. += span_warning("You calculate this contraptions chance of failure to be anywhere between [max(0, (misfire_chance - skill) - rand(4))]% and [max(2, (misfire_chance - skill) + rand(3))]%.")
		else
			. += span_warning("It seems slightly unstable...")
	if(skill >= 6 && sneaky_misfire_chance)
		. += span_warning("This contraption has a chance for catastrophic failure in the hands of the inexperient.")

/obj/item/contraption/proc/battery_collapse(atom/A, mob/living/user)
	to_chat(user, span_info("The [accepted_power_source.name] wastes away into nothing."))
	playsound(src, pick('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, FALSE)
	shake_camera(user, 1, 1)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(src)
	S.set_up(1, 1, front)
	S.start()
	return

/obj/item/contraption/proc/misfire(atom/A, mob/living/user)
	user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT * 5))
	to_chat(user, span_info("Oh fuck."))
	playsound(src, 'sound/misc/bell.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(misfire_result), A, user), rand(5, 30))

/obj/item/contraption/proc/misfire_result(atom/A, mob/living/user)
	misfiring = TRUE
	explosion(src, light_impact_range = 3, flame_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/item/contraption/proc/charge_deduction(atom/A, mob/living/user, deduction)
	current_charge -= deduction
	if(!current_charge)
		addtimer(CALLBACK(src, PROC_REF(battery_collapse), A, user), 5)

/obj/item/contraption/attackby(obj/item/I, mob/user, list/modifiers)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(src)
	if(istype(I, /obj/item/gear/wood) && special_cog)
		var/obj/item/gear/wood/cog = I
		if(cog.misfire_modification)
			misfire_chance = CLAMP(misfire_chance + cog.misfire_modification, 0, 100)
		if(cog.name_prefix)
			name = "[cog.name_prefix] [initial(name)]"
		else
			name = initial(name)
		qdel(cog)
		playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
		shake_camera(user, 1, 1)
		S.set_up(1, 1, front)
		S.start()
		to_chat(user, "<span class='warning'>I use [cog] to modify [src]!</span>")
		return
	if(istype(I, accepted_power_source))
		user.changeNext_move(CLICK_CD_FAST)
		S.set_up(1, 1, front)
		S.start()
		if(current_charge)
			to_chat(user, span_info("I try to insert the [I.name] but there's already \a [initial(accepted_power_source.name)] inside!"))
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			shake_camera(user, 1, 1)
		else
			to_chat(user, span_info("I insert the [I.name] and the [name] starts ticking."))
			current_charge = charge_per_source
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			qdel(I)
			addtimer(CALLBACK(src, PROC_REF(play_clock_sound)), 5)
	if(istype(I, /obj/item/weapon/hammer))
		hammer_action(I, user)
	..()

/obj/item/contraption/proc/hammer_action(obj/item/I, mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	flick(off_icon, src)
	user.visible_message(span_info("[user] beats the [name] into submission!"))
	playsound(src, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
	shake_camera(user, 1, 1)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(I)
	S.set_up(1, 1, front)
	S.start()
	var/probability = rand(1, 100)
	if(!current_charge)
		misfire(I, user)
		return
	if(probability <= 5)
		misfire(I, user)
	else if(probability <= 40)
		if(current_charge < charge_per_source)
			current_charge += 1
		misfire_chance = rand(1, 30)
	else
		misfire_chance = rand(10, 100)

/obj/item/contraption/proc/play_clock_sound()
	playsound(src, 'sound/misc/clockloop.ogg', 25, TRUE)

/obj/item/contraption/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!current_charge)
		flick(off_icon, src)
		to_chat(user, span_info("The contraption beeps! It requires \a [initial(accepted_power_source.name)]!"))
		playsound(src, 'sound/magic/magic_nulled.ogg', 100, TRUE)
		return TRUE
	. = ..()

/obj/item/contraption/wood_metalizer
	name = "wood metalizer"
	desc = "A creation of genius or insanity. This cursed contraption is somehow able to turn wood into metal."
	icon_state = "metalizer"
	on_icon = "metalizer_flick"
	off_icon = "metalizer_off"
	w_class = WEIGHT_CLASS_BULKY
	misfire_chance = 15
	charge_per_source = 5
	special_cog = TRUE

/obj
	/// This is the result when the wood metalizer artifact is used on this item
	var/metalizer_result
	/// The smelting result, used by the smelter or by the portable smelter
	var/smeltresult

/obj/item/contraption/wood_metalizer/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()

	var/obj/O = attacked_atom
	. = TRUE
	if(!current_charge)
		return
	if(!O.metalizer_result)
		to_chat(user, span_info("The [name] refuses to function."))
		playsound(user, 'sound/items/flint.ogg', 100, FALSE)
		flick(off_icon, src)
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(O)
		S.set_up(1, 1, front)
		S.start()
		return
	var/skill = user.get_skill_level(/datum/skill/craft/engineering, TRUE)
	if(istype(O, /obj/structure/door)) //This is to ensure the new door will retain its lock
		var/obj/structure/door/door = O
		var/obj/structure/door/new_door = new door.metalizer_result(get_turf(door))
		if(door.lock?.uses_key)
			var/datum/lock/key/oldlock = door.lock
			var/datum/lock/key/newlock = new(new_door, oldlock.lockid_list)
			newlock.locked = oldlock.locked
			newlock.difficulty = oldlock.difficulty
			new_door.lock = newlock
		qdel(door)
	else
		var/obj/I = O
		new I.metalizer_result(get_turf(I))
		qdel(I)
	flick(on_icon, src)
	charge_deduction(O, user, 1)
	shake_camera(user, 1, 1)
	playsound(src, 'sound/magic/swap.ogg', 100, TRUE)
	user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT / 2))
	if(misfire_chance && prob(max(0, misfire_chance - user.stat_roll(STATKEY_LCK,2,10) - skill)))
		misfire(O, user)
	return

/obj/item/contraption/wood_metalizer/misfire_result()
	misfiring = TRUE
	for(var/obj/object in oview(3, src))
		if(object.metalizer_result)  // Check if the object is within the flame range
			new object.metalizer_result(get_turf(object))
			playsound(object, 'sound/magic/swap.ogg', 100, TRUE)
			qdel(object)
	explosion(src, heavy_impact_range = 1, light_impact_range = 3, flame_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/item/contraption/smelter
	name = "portable smelter"
	desc = "Furnaces are a thing of the past. The future is here!"
	icon_state = "smelter"
	on_icon = "smelter_flick"
	off_icon = "smelter_off"
	w_class = WEIGHT_CLASS_BULKY
	smeltresult = /obj/item/ingot/bronze
	accepted_power_source = /obj/item/ore/coal
	misfire_chance = 10
	charge_per_source = 6
	special_cog = TRUE

/obj/item/contraption/smelter/misfire_result()
	misfiring = TRUE
	for(var/obj/object in oview(3, src))
		if(object.smeltresult)  // Check if the object is within the flame range
			if(istype(object, /obj/item/ingot))
				continue
			if(istype(object, /obj/item/contraption))
				var/obj/item/contraption/I = object
				if(I.misfiring)
					continue
				addtimer(CALLBACK(I, PROC_REF(misfire_result)), rand(5))
				continue
			object.popcorn_smelt()

	explosion(src, light_impact_range = 3, flame_range = 1, hotspot_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/proc/popcorn_smelt()
	var/turf/T = get_turf(src)
	moveToNullspace()
	playsound(T, pick('sound/combat/hits/burn (1).ogg','sound/combat/hits/burn (2).ogg'), 50)
	addtimer(CALLBACK(src, PROC_REF(popcorn_smelt_result), T), rand(10, 40))

/obj/proc/popcorn_smelt_result(turf)
	new smeltresult(turf)
	playsound(turf, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg'), 100, TRUE)
	qdel(src)

/obj/item/contraption/smelter/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()

	var/obj/O = attacked_atom
	. = TRUE
	if(!current_charge)
		return
	if(!O.smeltresult)
		to_chat(user, span_info("The [name] refuses to function."))
		playsound(user, 'sound/items/flint.ogg', 100, FALSE)
		flick(off_icon, src)
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(O)
		S.set_up(1, 1, front)
		S.start()
		return
	user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT / 3))
	charge_deduction(O, user, 1)
	flick(on_icon, src)
	playsound(src, 'sound/misc/machinevomit.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(smelt_part2), O, user), 5)
	return

/obj/item/contraption/smelter/proc/smelt_part2(obj/O, mob/living/user)
	var/skill = user.get_skill_level(/datum/skill/craft/engineering, TRUE)
	var/turf/turf = get_turf(O)
	playsound(O, pick('sound/combat/hits/burn (1).ogg','sound/combat/hits/burn (2).ogg'), 100)
	O.moveToNullspace()
	if(misfire_chance && prob(max(0, misfire_chance - user.stat_roll(STATKEY_LCK,2,10) - skill)))
		misfire(O, user)
	addtimer(CALLBACK(O, PROC_REF(popcorn_smelt_result), turf), 20)
	return

/obj/item/contraption/shears
	name = "amputation shears"
	desc = "A powered shear used for achieving a clean separation between limb and patient. Keeping the patient still is imperative to aligning the blades."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "shears"
	on_icon = "shears"
	off_icon = "shears"
	w_class = WEIGHT_CLASS_BULKY
	smeltresult = /obj/item/ingot/bronze
	charge_per_source = 4

/obj/item/contraption/shears/hammer_action(obj/item/I, mob/user)
	return

/obj/item/contraption/shears/attack(mob/living/amputee, mob/living/user, list/modifiers)
	if(!current_charge)
		return

	if(!iscarbon(amputee))
		return

	var/targeted_zone = check_zone(user.zone_selected)
	if(targeted_zone == BODY_ZONE_CHEST || targeted_zone == BODY_ZONE_HEAD)
		to_chat(user, span_warning("I can't amputate that!"))
		return

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("[patient]'s limbs look too sturdy to amputate."))
		return

	var/obj/item/bodypart/limb_snip_candidate

	limb_snip_candidate = patient.get_bodypart(targeted_zone)
	if(!limb_snip_candidate)
		to_chat(user, span_warning("[patient] is already missing that limb, what more do you want?"))
		return

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user] begins to secure [src] around [patient]'s [limb_snip_candidate.name]."), span_userdanger("[user] begins to secure [src] around your [limb_snip_candidate.name]!"))
	playsound(patient, 'sound/misc/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || patient.buckled || locate(/obj/structure/table/optable) in get_turf(patient))
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && (patient.has_status_effect(/datum/status_effect/jitter) || patient.body_position != LYING_DOWN)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25

	var/skill_modifier = 1.5 - (user.get_skill_level(/datum/skill/craft/engineering, TRUE) / 6)
	if(do_after(user, 15 SECONDS * amputation_speed_mod * skill_modifier, target = patient))
		playsound(patient, 'sound/misc/guillotine.ogg', 20, TRUE)
		limb_snip_candidate.drop_limb()
		user.visible_message(span_danger("[src] violently slams shut, amputating [patient]'s [limb_snip_candidate.name]."), span_notice("You amputate [patient]'s [limb_snip_candidate.name] with [src]."))
		charge_deduction(amputee, user, 1)

//Shamelessly stolen multitool code
/obj/item/contraption/linker
	name = "engineering wrench"
	desc = "This strange contraption is able to connect machinery through an unknown calibration method, allowing them to communicate over long distances."
	icon = 'icons/obj/wrenches.dmi'
	icon_state = "brasswrench"
	w_class = WEIGHT_CLASS_NORMAL
	tool_behaviour = TOOL_MULTITOOL
	var/datum/buffer // simple machine buffer for device linkage
	smeltresult = /obj/item/ingot/bronze
	charge_per_source = 10
	grid_height = 96
	grid_width = 96

/obj/item/contraption/linker/hammer_action(obj/item/I, mob/user)
	return

/obj/item/contraption/linker/Destroy()
	if(buffer)
		remove_buffer(buffer)
	return ..()

/obj/item/contraption/linker/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ENGINEERING_GOGGLES) || user.get_skill_level(/datum/skill/craft/engineering) >= 1)
		. += span_notice("Its buffer [buffer ? "contains [buffer]." : "is empty."]")
	else
		. += span_notice("All you can make out is a bunch of gibberish.")

/obj/item/contraption/linker/attack_self(mob/user, list/modifiers)
	. = ..()
	if(user.get_skill_level(/datum/skill/craft/engineering) >= 1)
		to_chat(user, "You wipe [src] of its stored buffer.")
		remove_buffer(src)
	else
		to_chat(user, span_warning("I have no idea how to use [src]!"))

/obj/item/contraption/linker/proc/set_buffer(datum/buffer)
	if(src.buffer)
		remove_buffer(src.buffer)
	src.buffer = buffer
	if(!QDELETED(buffer))
		RegisterSignal(buffer, COMSIG_PARENT_QDELETING, PROC_REF(remove_buffer))

/**
 * Called when the buffer's stored object is deleted
 *
 * This proc does not clear the buffer of the multitool, it is here to
 * handle the deletion of the object the buffer references
 */
/obj/item/contraption/linker/proc/remove_buffer(datum/source)
	SIGNAL_HANDLER
	SEND_SIGNAL(src, COMSIG_MULTITOOL_REMOVE_BUFFER, source)
	UnregisterSignal(buffer, COMSIG_PARENT_QDELETING)
	buffer = null

/obj/item/folding_table_stored
	name = "folding table"
	desc = "A folding table, useful for setting up a temporary workspace."
	icon = 'icons/roguetown/items/gadgets.dmi'
	icon_state = "folding_table_stored"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/folding_table_stored/attack_self(mob/user)
	. = ..()
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the folding table here!"))
		return NONE
	if(isopenspace(target_turf))
		return NONE
	if(isopenturf(target_turf))
		deploy_folding_table(user, target_turf)
		return TRUE
	return NONE

/obj/item/folding_table_stored/proc/deploy_folding_table(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You deploy the folding table.</span>")
	new /obj/structure/table/wood/folding(location)
	qdel(src)

/obj/structure/table/wood/folding
	name = "folding table"
	desc = "A folding table, useful for setting up a temporary workspace."
	icon = 'icons/roguetown/items/gadgets.dmi'
	icon_state = "folding_table_deployed"
	resistance_flags = FLAMMABLE
	max_integrity = 50
	debris = list(/obj/item/grown/log/tree/small = 1)
	climbable = TRUE
	climb_offset = 10

/obj/structure/table/wood/folding/examine()
	. = ..()
	. += span_blue("Right-Click to fold the table.")

/obj/structure/table/wood/folding/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
	new /obj/item/folding_table_stored(drop_location())
	qdel(src)
	return ..()

/obj/machinery/light/fueled/hearth/mobilestove
	name = "mobile stove"
	desc = "A portable bronze stovetop. The underside is covered in an esoteric pattern of small tubes. Whatever heats the hob is hidden inside the body of the device"
	icon_state = "hobostove1"
	base_state = "hobostove"
	brightness = 4
	bulb_colour ="#4ac77e"
	density = FALSE
	anchored = TRUE
	climbable = FALSE
	climb_offset = FALSE
	layer = TABLE_LAYER
	on = FALSE
	crossfire = FALSE

/obj/machinery/light/fueled/hearth/mobilestove/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(attachment)
		if(!user.put_in_active_hand(attachment))
			attachment.forceMove(user.loc)
		attachment = null
	if(!on)
		user.visible_message(span_notice("[user] begins packing up \the [src]."))
		if(!do_after(user, 2 SECONDS, TRUE, src))
			return
		var/obj/item/mobilestove/new_mobilestove = new /obj/item/mobilestove(get_turf(src))
		new_mobilestove.color = src.color
		qdel(src)
		return

	var/mob/living/carbon/human/H = user
	if(!istype(user))
		return
	H.visible_message(span_notice("[user] begins packing up \the [src]. It's still hot!"))
	if(!do_after(H, 4 SECONDS, src))
		return
	var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	to_chat(H, span_warning("HOT! I burned myself!"))
	if(affecting && affecting.receive_damage(0, 5))
		H.update_damage_overlays()
	new /obj/item/mobilestove(get_turf(src))
	burn_out()
	qdel(src)

/obj/item/mobilestove
	name = "packed stove"
	desc = "A portable bronze stovetop. The underside is covered in an esoteric pattern of small tubes. Whatever heats the hob is hidden inside the body of the device"
	icon = 'icons/roguetown/misc/lighting.dmi'
	icon_state = "hobostovep"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	grid_width = 32
	grid_height = 64

/obj/item/mobilestove/attack_self(mob/user, list/modifiers)
	..()
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("I need ground to plant this on!"))
		return
	for(var/obj/A in T)
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("There is already something here!</span>"))
			return
	user.visible_message(span_notice("[user] begins placing \the [src] down on the ground."))
	if(do_after(user, 2 SECONDS, src))
		new /obj/machinery/light/fueled/hearth/mobilestove(get_turf(src))
		qdel(src)
