
/obj/item/bodypart
	name = "limb"
	desc = ""
	force = 3
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
//	sellprice = 5
	icon = 'icons/mob/human_parts.dmi'
	icon_state = ""
	layer = BELOW_MOB_LAYER //so it isn't hidden behind objects when on the floor
	var/mob/living/carbon/owner
	var/mob/living/carbon/original_owner
	/// a cache of the original owner's DNA unique identifier. only gets updated from shit like changeling absorb so it carries between owners
	var/fingerprint
	var/status = BODYPART_ORGANIC

	var/static_icon = FALSE
	var/body_zone //BODY_ZONE_CHEST, BODY_ZONE_L_ARM, etc , used for def_zone
	var/aux_zone // used for hands
	var/aux_layer
	var/body_part = 0 //bitflag used to check which clothes cover this bodypart
	var/held_index = 0 //are we a hand? if so, which one!

	/// If disabled, limb is as good as missing
	var/bodypart_disabled = BODYPART_NOT_DISABLED
	/// Controls whether bodypart_disabled makes sense or not for this limb.
	var/can_be_disabled = FALSE
	var/body_damage_coeff = 1 //Multiplier of the limb's damage that gets applied to the mob
	var/brutestate = 0
	var/burnstate = 0
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0

	var/cremation_progress = 0 //Gradually increases while burning when at full damage, destroys the limb when at 100

	var/brute_reduction = 0 //Subtracted to brute damage taken
	var/burn_reduction = 0	//Subtracted to burn damage taken

	//Coloring and proper item icon update
	var/skin_tone = ""
	var/body_gender = ""
	var/species_id = ""
	var/should_draw_gender = FALSE
	var/should_draw_greyscale = FALSE
	var/species_color = ""
	var/mutation_color = ""
	var/no_update = 0
	var/species_icon = ""

	var/animal_origin = 0 //for nonhuman bodypart (e.g. monkey)
	var/dismemberable = 1 //whether it can be dismembered with a weapon.
	// var/disableable = 1

	var/px_x = 0
	var/px_y = 0

	var/species_flags_list = list()
	var/dmg_overlay_type //the type of damage overlay (if any) to use when this bodypart is bruised/burned.

	//Damage messages used by help_shake_act()
	var/heavy_brute_msg = "MANGLED"
	var/medium_brute_msg = "battered"
	var/light_brute_msg = "bruised"
	var/no_brute_msg = "unbruised"

	var/heavy_burn_msg = "CHARRED"
	var/medium_burn_msg = "peeling"
	var/light_burn_msg = "blistered"
	var/no_burn_msg = "unburned"

	var/add_extra = FALSE

	var/offset

	var/last_disable = 0
	var/last_crit = 0

	var/list/subtargets = list()		//these are subtargets that can be attacked with weapons (crits)
	var/list/grabtargets = list()		//these are subtargets that can be grabbed

	var/rotted = FALSE
	var/skeletonized = FALSE

	var/fingers = TRUE

	/// Visual markings to be rendered alongside the bodypart
	var/list/markings
	var/list/aux_markings
	/// Visual features of the bodypart, such as hair and accessories
	var/list/bodypart_features

	grid_width = 32
	grid_height = 64

	resistance_flags = FLAMMABLE

	var/wound_icon_state

	var/punch_modifier = 1 // for modifying arm punching damage
	var/acid_damage_intensity = 0
	var/lingering_pain = 0
	var/chronic_pain = 0
	var/chronic_pain_type = null
	var/last_severe_injury_time = 0

/obj/item/bodypart/Initialize()
	. = ..()
	if(can_be_disabled)
		RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
		RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
	update_HP()

/obj/item/bodypart/Destroy()
	if(owner)
		owner.remove_bodypart(src)
		set_owner(null)
	for(var/obj/item/I as anything in embedded_objects)
		remove_embedded_object(I)
	for(var/datum/wound/wound as anything in wounds)
		qdel(wound)
	if(bandage)
		QDEL_NULL(bandage)
	embedded_objects = null
	original_owner = null
	return ..()

/obj/item/bodypart/grabbedintents(mob/living/user, atom/grabbed, precise)
	return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)

/obj/item/bodypart/l_arm/grabbedintents(mob/living/user, atom/grabbed, precise)
	var/used_limb = precise
	if(user == grabbed)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
	if(used_limb == BODY_ZONE_PRECISE_L_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/armdrag)

/obj/item/bodypart/r_arm/grabbedintents(mob/living/user, atom/grabbed, precise)
	var/used_limb = precise
	if(user == grabbed)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
	if(used_limb == BODY_ZONE_PRECISE_R_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/armdrag)

/obj/item/bodypart/chest/grabbedintents(mob/living/user, atom/grabbed, precise)
	if(precise == BODY_ZONE_PRECISE_GROIN)
		if(user == grabbed)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist)
		else
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/shove)
	if(user == grabbed)
		return list(/datum/intent/grab/move)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/shove)

/obj/item/bodypart/onbite(mob/living/user)
	. = ..()
	if(!.)
		return
	if(status != BODYPART_ORGANIC)
		return TRUE
	if((user.mind && user.mind.has_antag_datum(/datum/antagonist/zombie)) || is_species(/datum/species/werewolf))
		if(user.has_status_effect(/datum/status_effect/debuff/silver_bane))
			to_chat(user, span_notice("My power is weakened, I cannot heal!"))
			return TRUE
		if(!do_after(user, 5 SECONDS, src))
			return TRUE
		user.visible_message(span_warning("[user] consumes [src]!"),\
						span_notice("I consume [src]!"))
		playsound(user, pick(dismemsound), 100, FALSE, -1)
		new /obj/effect/gibspawner/generic(get_turf(src), user)
		user.reagents.add_reagent(/datum/reagent/medicine/healthpot, 30)
		qdel(src)

/obj/item/bodypart/MiddleClick(mob/living/user, list/modifiers)
	var/obj/item/held_item = user.get_active_held_item()
	var/datum/species/S = original_owner?.dna?.species
	if(held_item)
		if(held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
			if(!skeletonized)
				var/used_time = 21 SECONDS
				if(user.mind)
					used_time -= (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 3 SECONDS)
				visible_message("[user] begins to butcher \the [src].")
				playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
				var/steaks = 1
				switch(user.get_skill_level(/datum/skill/labor/butchering))
					if(3)
						steaks = 2
					if(4 to 5)
						steaks = 3
					if(6)
						steaks = 4 // the steaks have never been higher
				var/amt2raise = user.STAINT/3
				if(do_after(user, used_time, src))
					var/obj/item/reagent_containers/food/snacks/meat/steak/steak
					var/steak_type = S?.meat || /obj/item/reagent_containers/food/snacks/meat/steak
					for(steaks, steaks>0, steaks--)
						steak = new steak_type(get_turf(src))	//Meat depends on species.
						if(rotted)
							steak.become_rotten()
					new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
					user.adjust_experience(/datum/skill/labor/butchering, amt2raise, FALSE)
					qdel(src)
			else
				to_chat(user, span_warning("[src] has no meat to butcher."))
	else if(isanimal(user))
		if(!skeletonized)
			visible_message("[user] begins to eat \the [src].")
			playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
			if(do_after(user, 3 SECONDS, src))
				var/obj/item/reagent_containers/food/snacks/meat/steak/steak
				var/steak_type = S?.meat || /obj/item/reagent_containers/food/snacks/meat/steak
				steak = new steak_type(get_turf(src))	//Meat depends on species.
				if(rotted)
					steak.become_rotten()
				new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
				qdel(src)
		else
			to_chat(user, span_warning("[src] has no meat to eat."))
	..()

/obj/item/bodypart/attack(mob/living/carbon/C, mob/user, list/modifiers)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(HAS_TRAIT(C, TRAIT_LIMBATTACHMENT))
			if(!H.get_bodypart(body_zone) && !animal_origin)
				if(H == user)
					H.visible_message("<span class='warning'>[H] jams [src] into [H.p_their()] empty socket!</span>",\
					"<span class='notice'>I force [src] into my empty socket, and it locks into place!</span>")
				else
					H.visible_message("<span class='warning'>[user] jams [src] into [H]'s empty socket!</span>",\
					"<span class='notice'>[user] forces [src] into my empty socket, and it locks into place!</span>")
				user.temporarilyRemoveItemFromInventory(src, TRUE)
				attach_limb(C)
				return
	return ..()

/obj/item/bodypart/head/attackby(obj/item/I, mob/user, list/modifiers)
	if(length(contents) && I.get_sharpness() && !user.cmode)
		add_fingerprint(user)
		playsound(src, 'sound/combat/hits/bladed/genstab (1).ogg', 60, vary = FALSE)
		user.visible_message("<span class='warning'>[user] begins to cut open [src].</span>",\
			"<span class='notice'>You begin to cut open [src]...</span>")
		if(do_after(user, 5 SECONDS, src))
			drop_organs(user)
			user.visible_message("<span class='danger'>[user] cuts [src] open!</span>",\
				"<span class='notice'>You finish cutting [src] open.</span>")
		return
	return ..()

/obj/item/bodypart/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(status != BODYPART_ROBOTIC)
		playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
	pixel_x = base_pixel_x + rand(-3, 3)
	pixel_y = base_pixel_y + rand(-3, 3)
	if(!skeletonized)
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))

//empties the bodypart from its organs and other things inside it
/obj/item/bodypart/proc/drop_organs(mob/user, violent_removal)
	var/turf/T = get_turf(src)
	if(status != BODYPART_ROBOTIC)
		playsound(T, 'sound/blank.ogg', 50, TRUE, -1)
	for(var/obj/item/I in src)
		I.forceMove(T)

/obj/item/bodypart/proc/skeletonize(lethal = TRUE)
	if(bandage)
		remove_bandage()
	for(var/obj/item/I in embedded_objects)
		remove_embedded_object(I)
	for(var/obj/item/I in src) //dust organs
		qdel(I)
	skeletonized = TRUE

/obj/item/bodypart/chest/skeletonize(lethal = TRUE)
	. = ..()
	if(lethal && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		owner.death()

/obj/item/bodypart/head/skeletonize(lethal = TRUE)
	. = ..()
	if(lethal && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		owner.death()

/obj/item/bodypart/proc/update_HP()
	if(!is_organic_limb() || !owner)
		return
	var/old_max_damage = max_damage
	var/new_max_damage = initial(max_damage) * (owner.STACON / 10)
	if(new_max_damage != old_max_damage)
		max_damage = new_max_damage

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_status = null, flashes = TRUE)
	update_HP()
	var/hit_percent = (100-blocked)/100
	if((!brute && !burn) || hit_percent <= 0)
		return FALSE
	if(owner && (owner.status_flags & GODMODE))
		return FALSE	//godmode

	if(required_status && (status != required_status))
		return FALSE

	var/dmg_mlt = CONFIG_GET(number/damage_multiplier) * hit_percent
	brute = round(max(brute * dmg_mlt, 0),DAMAGE_PRECISION)
	burn = round(max(burn * dmg_mlt, 0),DAMAGE_PRECISION)
	brute = max(0, brute - brute_reduction)
	burn = max(0, burn - burn_reduction)

	if(!brute && !burn)
		return FALSE

	//cap at maxdamage
	if(brute_dam + brute > max_damage)
		set_brute_dam(max_damage)
	else
		set_brute_dam(brute_dam + brute)
	if(burn_dam + burn > max_damage)
		set_burn_dam(max_damage)
	else
		set_burn_dam(burn_dam + burn)

	if(owner && flashes)
		if((brute + burn) < 10)
			owner.flash_fullscreen("redflash1")
		else if((brute + burn) < 20)
			owner.flash_fullscreen("redflash2")
		else if((brute + burn) >= 20)
			owner.flash_fullscreen("redflash3")

	if(owner)
		if(can_be_disabled)
			update_disabled()
		if(updating_health)
			owner.updatehealth()

	// Add new lingering pain when taking significant damage
	var/current_damage_percent = ((brute_dam + burn_dam) / max_damage) * 100
	if(current_damage_percent > 40) // Only significant injuries cause lingering pain
		var/new_lingering = (current_damage_percent - 40) * 0.5 // Scale factor
		lingering_pain += max(0, (new_lingering - lingering_pain) / 4)

		// Track severe injuries for chronic pain development
		if(current_damage_percent > 60)
			last_severe_injury_time = world.time

	return update_bodypart_damage_state() || .

//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/bodypart/proc/heal_damage(brute, burn, required_status, updating_health = TRUE)
	update_HP()
	if(required_status && (status != required_status)) //So we can only heal certain kinds of limbs, ie robotic vs organic.
		return

	if(brute)
		set_brute_dam(round(max(brute_dam - brute, 0), DAMAGE_PRECISION))
	if(burn)
		set_burn_dam(round(max(burn_dam - burn, 0), DAMAGE_PRECISION))

	if(owner)
		if(can_be_disabled)
			update_disabled()
		if(updating_health)
			owner.updatehealth()
	//cremation_progress = min(0, cremation_progress - ((brute_dam + burn_dam)*(100/max_damage)))
	return update_bodypart_damage_state()

///Proc to hook behavior associated to the change of the brute_dam variable's value.
/obj/item/bodypart/proc/set_brute_dam(new_value)
	if(brute_dam == new_value)
		return
	. = brute_dam
	brute_dam = new_value

///Proc to hook behavior associated to the change of the burn_dam variable's value.
/obj/item/bodypart/proc/set_burn_dam(new_value)
	if(burn_dam == new_value)
		return
	. = burn_dam
	burn_dam = new_value

//Returns total damage.
/obj/item/bodypart/proc/get_damage()
	return brute_dam + burn_dam

//Checks disabled status thresholds
/obj/item/bodypart/proc/update_disabled()
	update_HP()
	if(!owner)
		return
	if(!can_be_disabled)
		set_disabled(FALSE)
		CRASH("update_disabled called with can_be_disabled false")

	//yes this does mean vampires can use rotten limbs
	if((rotted || skeletonized) && !(owner.mob_biotypes & MOB_UNDEAD))
		return set_disabled(BODYPART_DISABLED_ROT)
	for(var/datum/wound/ouchie as anything in wounds)
		if(!ouchie.disabling)
			continue
		return set_disabled(BODYPART_DISABLED_WOUND)
	if(HAS_TRAIT(owner, TRAIT_PARALYSIS) || HAS_TRAIT(src, TRAIT_PARALYSIS))
		return set_disabled(BODYPART_DISABLED_PARALYSIS)
	var/surgery_flags = get_surgery_flags()
	if(surgery_flags & SURGERY_CLAMPED)
		return set_disabled(BODYPART_DISABLED_CLAMPED)
	var/total_dam = get_damage()
	if((total_dam >= max_damage) || (HAS_TRAIT(owner, TRAIT_EASYLIMBDISABLE) && (total_dam >= (max_damage * 0.6))))
		return set_disabled(BODYPART_DISABLED_DAMAGE)
	return set_disabled(BODYPART_NOT_DISABLED)

/obj/item/bodypart/proc/set_disabled(new_disabled)
	if(bodypart_disabled == new_disabled)
		return
	. = bodypart_disabled
	bodypart_disabled = new_disabled

	if(!owner)
		return

	last_disable = world.time
	if(owner)
		owner.update_health_hud() //update the healthdoll
		owner.update_body()

/obj/item/bodypart/proc/reset_fingerprint()
	if(status != BODYPART_ORGANIC)
		fingerprint = null
		return
	if(owner?.dna?.unique_identity)
		fingerprint = md5(owner.dna.unique_identity)

///Proc to change the value of the `owner` variable and react to the event of its change.
/obj/item/bodypart/proc/set_owner(mob/living/carbon/new_owner)
	SHOULD_CALL_PARENT(TRUE)

	if(owner == new_owner)
		return FALSE //`null` is a valid option, so we need to use a num var to make it clear no change was made.
	var/mob/living/carbon/old_owner = owner
	owner = new_owner
	var/needs_update_disabled = FALSE //Only really relevant if there's an owner
	if(old_owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(old_owner, TRAIT_NOLIMBDISABLE))
				if(!owner || !HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
					set_can_be_disabled(initial(can_be_disabled))
					needs_update_disabled = TRUE
			UnregisterSignal(old_owner, list(
				SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_ADDTRAIT(TRAIT_PARALYSIS),
				SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS),
				))
	if(owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE)) // owner is new_owner, don't listen to owner TRAIT_PARALYSIS signals if TRAIT_NOLIMBDISABLE
				set_can_be_disabled(FALSE)
				needs_update_disabled = FALSE
			else
				RegisterSignal(new_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
				RegisterSignal(new_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
			RegisterSignal(new_owner, SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_loss))
			RegisterSignal(new_owner, SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_gain))

		if(needs_update_disabled)
			update_disabled()

	return old_owner

///Proc to change the value of the `can_be_disabled` variable and react to the event of its change.
/obj/item/bodypart/proc/set_can_be_disabled(new_can_be_disabled)
	if(can_be_disabled == new_can_be_disabled)
		return
	. = can_be_disabled
	can_be_disabled = new_can_be_disabled
	if(can_be_disabled)
		if(owner)
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
				CRASH("set_can_be_disabled to TRUE with for limb whose owner has TRAIT_NOLIMBDISABLE")
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
		update_disabled()
	else if(.)
		if(owner)
			UnregisterSignal(owner, list(
				SIGNAL_ADDTRAIT(TRAIT_PARALYSIS),
				SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS),
				))
		set_disabled(FALSE)

///Called when TRAIT_PARALYSIS is added to the limb.
/obj/item/bodypart/proc/on_paralysis_trait_gain(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(can_be_disabled)
		set_disabled(TRUE)

///Called when TRAIT_PARALYSIS is removed from the limb.
/obj/item/bodypart/proc/on_paralysis_trait_loss(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(can_be_disabled)
		update_disabled()

///Called when TRAIT_NOLIMBDISABLE is added to the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	set_can_be_disabled(FALSE)

///Called when TRAIT_NOLIMBDISABLE is removed from the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	set_can_be_disabled(initial(can_be_disabled))

//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/bodypart/proc/update_bodypart_damage_state()
	var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
	var/tburn	= round( (burn_dam/max_damage)*3, 1 )
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		return TRUE
	return FALSE

//Change organ status
/obj/item/bodypart/proc/change_bodypart_status(new_limb_status, heal_limb, change_icon_to_default)
	status = new_limb_status
	if(heal_limb)
		burn_dam = 0
		brute_dam = 0
		brutestate = 0
		burnstate = 0

	if(change_icon_to_default)
		if(status == BODYPART_ORGANIC)
			icon = species_icon

	if(owner)
		owner.updatehealth()
		owner.update_body() //if our head becomes robotic, we remove the lizard horns and human hair.
		owner.update_damage_overlays()

/obj/item/bodypart/proc/is_organic_limb()
	return (status == BODYPART_ORGANIC)

//we inform the bodypart of the changes that happened to the owner, or give it the informations from a source mob.
/obj/item/bodypart/proc/update_limb(dropping_limb, mob/living/carbon/source)
	var/mob/living/carbon/C
	if(source)
		C = source
		if(!original_owner)
			original_owner = source
	else if(original_owner && owner != original_owner) //Foreign limb
		no_update = TRUE
	else
		C = owner
		no_update = FALSE

	if(C && HAS_TRAIT(C, TRAIT_HUSK) && is_organic_limb())
		species_id = "husk" //overrides species_id
		dmg_overlay_type = "" //no damage overlay shown when husked
		should_draw_gender = FALSE
		should_draw_greyscale = FALSE
		no_update = TRUE

	if(no_update)
		return

	if(!animal_origin)
		var/mob/living/carbon/human/H = C
		should_draw_greyscale = FALSE
		if(!H.dna?.species)
			return
		var/datum/species/S = H.dna.species
		species_id = S.limbs_id
		if(H.gender == MALE)
			species_icon = S.limbs_icon_m
		else
			species_icon = S.limbs_icon_f
		if(H.age == AGE_CHILD)
			species_icon = S.child_icon
		species_flags_list = H.dna.species.species_traits


		if(S.use_skintones)
			skin_tone = H.skin_tone
			should_draw_greyscale = TRUE
		else
			skin_tone = ""

		body_gender = H.gender
		should_draw_gender = S.sexes

		species_color = ""

		mutation_color = ""

		dmg_overlay_type = S.damage_overlay_type

	else if(animal_origin == MONKEY_BODYPART) //currently monkeys are the only non human mob to have damage overlays.
		dmg_overlay_type = animal_origin

	if(status == BODYPART_ROBOTIC)
		dmg_overlay_type = "robotic"

	if(dropping_limb)
		no_update = TRUE //when attached, the limb won't be affected by the appearance changes of its mob owner.

//to update the bodypart's icon when not attached to a mob
/obj/item/bodypart/proc/update_icon_dropped()
	cut_overlays()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	add_overlay(standing)

//Gives you a proper icon appearance for the dismembered limb
/obj/item/bodypart/proc/get_limb_icon(dropped, hideaux = FALSE)
	icon_state = "" //to erase the default sprite, we're building the visual aspects of the bodypart through overlays alone.

	. = list()
	var/icon_gender = (body_gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable

	var/image_dir = 0
	if(dropped && !skeletonized)
		if(static_icon)
			icon = initial(icon)
			icon_state = initial(icon_state)
			return
		image_dir = SOUTH
		if(dmg_overlay_type)
			if(brutestate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_[brutestate]0_[icon_gender]", -DAMAGE_LAYER, image_dir)
			if(burnstate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_0[burnstate]_[icon_gender]", -DAMAGE_LAYER, image_dir)

	var/mutable_appearance/limb = mutable_appearance(layer = -BODYPARTS_LAYER)
	if(wound_icon_state)
		limb.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[wound_icon_state]_flesh"), flags = MASK_INVERSE)
	if(acid_damage_intensity)
		limb.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[body_zone]_acid[acid_damage_intensity]_flesh"), flags = MASK_INVERSE)
	limb.dir = image_dir
	var/image/aux

	. += limb

	if(animal_origin)
		if(is_organic_limb())
			limb.icon = 'icons/mob/animal_parts.dmi'
			if(species_id == "husk")
				limb.icon_state = "[animal_origin]_husk_[body_zone]"
			else
				limb.icon_state = "[animal_origin]_[body_zone]"
		return

//	if((body_zone != BODY_ZONE_HEAD && body_zone != BODY_ZONE_CHEST))
//		should_draw_gender = FALSE
	should_draw_gender = TRUE

	var/skel = skeletonized ? "_s" : ""

	if(is_organic_limb())
		if(should_draw_greyscale)
			limb.icon = species_icon
			if(should_draw_gender)
				limb.icon_state = "[body_zone][skel]"
				if(wound_icon_state || acid_damage_intensity)
					var/mutable_appearance/skeleton = mutable_appearance(layer = -(BODY_LAYER))
					skeleton.icon = species_icon
					skeleton.icon_state = "[body_zone]_s"
					if(wound_icon_state)
						skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', wound_icon_state))
					if(acid_damage_intensity)
						skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[body_zone]_acid[acid_damage_intensity]"))
					skeleton.dir = image_dir
					. += skeleton
			else
				limb.icon_state = "[body_zone][skel]"
				if(wound_icon_state || acid_damage_intensity)
					var/mutable_appearance/skeleton = mutable_appearance(layer = -(BODY_LAYER))
					skeleton.icon = species_icon
					skeleton.icon_state = "[body_zone]_s"
					if(wound_icon_state)
						skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', wound_icon_state))
					if(acid_damage_intensity)
						skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[body_zone]_acid[acid_damage_intensity]"))
					skeleton.dir = image_dir
					. += skeleton
		else
			limb.icon = 'icons/mob/human_parts.dmi'
			if(should_draw_gender)
				limb.icon_state = "[species_id]_[body_zone]_[icon_gender]"
			else
				limb.icon_state = "[species_id]_[body_zone]"
		if(aux_zone && !hideaux)
			aux = image(limb.icon, "[aux_zone][skel]", -(aux_layer), image_dir)
			. += aux
			if(wound_icon_state || acid_damage_intensity)
				var/mutable_appearance/skeleton = mutable_appearance(layer = -(aux_layer))
				skeleton.icon = species_icon
				skeleton.icon_state = "[aux_zone]_s"
				if(wound_icon_state)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', wound_icon_state))
				if(acid_damage_intensity)
					skeleton.filters += alpha_mask_filter(icon=icon('icons/effects/wounds.dmi', "[aux_zone]_acid[acid_damage_intensity]"))
				skeleton.dir = image_dir
				. += skeleton
		if(blocks_emissive != EMISSIVE_BLOCK_NONE && !istype(owner, /mob/living/carbon/human/dummy))
			var/mutable_appearance/limb_em_block = mutable_appearance(limb.icon, limb.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
			limb_em_block.dir = image_dir
			limb_em_block.color = GLOB.em_block_color
			limb.overlays += limb_em_block

			if(aux_zone && !hideaux)
				var/mutable_appearance/aux_em_block = mutable_appearance(aux.icon, aux.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
				aux_em_block.dir = image_dir
				aux_em_block.color = GLOB.em_block_color
				aux.overlays += aux_em_block


	else
		limb.icon = species_icon
		limb.icon_state = "pr_[body_zone]"
		if(aux_zone)
			if(!hideaux)
				aux = image(limb.icon, "pr_[aux_zone]", -aux_layer, image_dir)
				. += aux
		return

	var/draw_organ_features = TRUE
	var/draw_bodypart_features = TRUE
	if(owner && owner.dna)
		var/datum/species/owner_species = owner.dna.species
		if(NO_ORGAN_FEATURES in owner_species.species_traits)
			draw_organ_features = FALSE
		if(NO_BODYPART_FEATURES in owner_species.species_traits)
			draw_bodypart_features = FALSE

	if(!skeletonized && draw_organ_features)
		for(var/obj/item/organ/organ as anything in get_organs())
			if(!organ.is_visible())
				continue
			var/mutable_appearance/organ_appearance = organ.get_bodypart_overlay(src)
			if(organ_appearance)
				. += organ_appearance

	// Feature overlays
	if(!skeletonized && draw_bodypart_features)
		for(var/datum/bodypart_feature/feature as anything in bodypart_features)
			var/overlays = feature.get_bodypart_overlay(src)
			if(!overlays)
				continue
			. += overlays

	if(should_draw_greyscale && !skeletonized)
		var/draw_color =  mutation_color || species_color || skin_tone
		if(rotted || (owner && HAS_TRAIT(owner, TRAIT_ROTMAN)))
			draw_color = SKIN_COLOR_ROT
		if(draw_color)
			limb.color = "#[draw_color]"
			if(aux_zone && !hideaux)
				aux.color = "#[draw_color]"

///since organs aren't actually stored in the bodypart themselves while attached to a person, we have to query the owner for what we should have
/obj/item/bodypart/proc/get_organs()
	if(!owner)
		return FALSE

	var/list/bodypart_organs
	for(var/obj/item/organ/organ_check as anything in owner.internal_organs) //internal organs inside the dismembered limb are dropped.
		if(check_zone(organ_check.zone) == body_zone)
			LAZYADD(bodypart_organs, organ_check) // this way if we don't have any, it'll just return null

	for(var/obj/item/organ/organ_check in contents)
		if(check_zone(organ_check.zone) == body_zone)
			LAZYADD(bodypart_organs, organ_check) // this way if we don't have any, it'll just return null

	return bodypart_organs

/obj/item/bodypart/deconstruct(disassembled = TRUE)
	drop_organs()
	return ..()
/obj/item/bodypart/chest
	name = "chest"
	desc = ""
	icon_state = "default_human_chest"
	max_damage = 200
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	px_x = 0
	px_y = 0
	var/obj/item/cavity_item
	aux_zone = "boob"
	aux_layer = BODYPARTS_LAYER
	subtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	grabtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	offset = OFFSET_ARMOR
	dismemberable = FALSE

	grid_width = 64
	grid_height = 96

/obj/item/bodypart/chest/set_disabled(new_disabled)
	. = ..()
	if(!.)
		return
	if(bodypart_disabled == BODYPART_DISABLED_DAMAGE || bodypart_disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, "<span class='warning'>I feel a sharp pain in my back!</span>")

/obj/item/bodypart/chest/Destroy()
	QDEL_NULL(cavity_item)
	return ..()

/obj/item/bodypart/chest/drop_organs(mob/user, violent_removal)
	if(cavity_item)
		cavity_item.forceMove(drop_location())
		cavity_item = null
	..()

/obj/item/bodypart/chest/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_chest"
	animal_origin = MONKEY_BODYPART

/obj/item/bodypart/chest/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/l_arm
	name = "left arm"
	desc = ""
	icon_state = "default_human_l_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 100
	body_zone = BODY_ZONE_L_ARM
	body_part = ARM_LEFT
	aux_zone = BODY_ZONE_PRECISE_L_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 1
	px_x = -6
	px_y = 0
	subtargets = list(BODY_ZONE_PRECISE_L_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM)
	offset = OFFSET_GLOVES
	dismember_wound = /datum/wound/dismemberment/l_arm
	can_be_disabled = TRUE

/obj/item/bodypart/l_arm/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_L_ARM))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_L_ARM))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM))
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_L_ARM))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_L_ARM trait.
/obj/item/bodypart/l_arm/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_L_ARM trait.
/obj/item/bodypart/l_arm/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/l_arm/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='boldwarning'>I can no longer move my [name]!</span>")
	// 	if(held_index)
	// 		owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_hands(owner.usable_hands - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(!bodypart_disabled)
		owner.set_usable_hands(owner.usable_hands + 1)

	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/hand_screen_object = owner.hud_used.hand_slots["[held_index]"]
		hand_screen_object?.update_appearance(UPDATE_OVERLAYS)

/obj/item/bodypart/l_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_l_arm"
	animal_origin = MONKEY_BODYPART
	px_x = -5
	px_y = -3


/obj/item/bodypart/l_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/r_arm
	name = "right arm"
	desc = ""
	icon_state = "default_human_r_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 100
	body_zone = BODY_ZONE_R_ARM
	body_part = ARM_RIGHT
	aux_zone = BODY_ZONE_PRECISE_R_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 2
	px_x = 6
	px_y = 0
	subtargets = list(BODY_ZONE_PRECISE_R_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_ARM)
	offset = OFFSET_GLOVES
	dismember_wound = /datum/wound/dismemberment/r_arm
	can_be_disabled = TRUE

/obj/item/bodypart/r_arm/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_R_ARM))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_R_ARM))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM))
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_R_ARM))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_R_ARM trait.
/obj/item/bodypart/r_arm/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_R_ARM trait.
/obj/item/bodypart/r_arm/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/r_arm/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer move my [name]!</span>")
	// 	if(held_index)
	// 		owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_hands(owner.usable_hands - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(!bodypart_disabled)
		owner.set_usable_hands(owner.usable_hands + 1)

	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/hand_screen_object = owner.hud_used.hand_slots["[held_index]"]
		hand_screen_object?.update_appearance(UPDATE_OVERLAYS)

/obj/item/bodypart/r_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_r_arm"
	animal_origin = MONKEY_BODYPART
	px_x = 5
	px_y = -3

/obj/item/bodypart/r_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/l_leg
	name = "left leg"
	desc = ""
	icon_state = "default_human_l_leg"
	attack_verb = list("kicked", "stomped")
	max_damage = 100
	body_zone = BODY_ZONE_L_LEG
	body_part = LEG_LEFT
	body_damage_coeff = 1
	px_x = -2
	px_y = 12
	aux_zone = "l_leg_above"
	aux_layer = LEG_PART_LAYER
	subtargets = list(BODY_ZONE_PRECISE_L_FOOT)
	grabtargets = list(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_L_LEG)
	dismember_wound = /datum/wound/dismemberment/l_leg
	can_be_disabled = TRUE

/obj/item/bodypart/l_leg/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_L_LEG))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_LEG))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_L_LEG))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_LEG)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_LEG))
	if(new_owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_L_LEG))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_LEG)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_LEG), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_LEG)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_LEG), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_L_LEG trait.
/obj/item/bodypart/l_leg/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_LEG)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_LEG))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_LEG), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_L_LEG trait.
/obj/item/bodypart/l_leg/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_LEG)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_LEG))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_LEG), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/l_leg/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer move my [name]!</span>")
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_legs(owner.usable_legs - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
	else if(!bodypart_disabled)
		owner.set_usable_legs(owner.usable_legs + 1)

/obj/item/bodypart/l_leg/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_l_leg"
	animal_origin = MONKEY_BODYPART
	px_y = 4

/obj/item/bodypart/l_leg/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/r_leg
	name = "right leg"
	desc = ""
	// alternative spellings of 'pokey' are availible
	icon_state = "default_human_r_leg"
	attack_verb = list("kicked", "stomped")
	max_damage = 100
	body_zone = BODY_ZONE_R_LEG
	body_part = LEG_RIGHT
	body_damage_coeff = 1
	px_x = 2
	px_y = 12
	aux_zone = "r_leg_above"
	aux_layer = LEG_PART_LAYER
	subtargets = list(BODY_ZONE_PRECISE_R_FOOT)
	grabtargets = list(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_LEG)
	dismember_wound = /datum/wound/dismemberment/r_leg
	can_be_disabled = TRUE

/obj/item/bodypart/r_leg/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_R_LEG))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_LEG))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_R_LEG))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_LEG)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_LEG))
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_R_LEG))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_LEG)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_LEG), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_LEG)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_LEG), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_R_LEG trait.
/obj/item/bodypart/r_leg/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_LEG)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_LEG))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_LEG), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_R_LEG trait.
/obj/item/bodypart/r_leg/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_LEG)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_LEG))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_LEG), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/r_leg/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer move my [name]!</span>")
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_legs(owner.usable_legs - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
	else if(!bodypart_disabled)
		owner.set_usable_legs(owner.usable_legs + 1)

/obj/item/bodypart/r_leg/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_r_leg"
	animal_origin = MONKEY_BODYPART
	px_y = 4


/obj/item/bodypart/r_leg/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART
