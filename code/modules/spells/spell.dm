#define TARGET_CLOSEST 1
#define TARGET_RANDOM 2
#define MAGIC_XP_MULTIPLIER 0.3 //used to miltuply the amount of xp gained from spells

/obj/effect/proc_holder
	var/panel = "Debug"//What panel the proc holder needs to go on.
	var/active = FALSE //Used by toggle based abilities.
	var/ranged_mousepointer
	var/mob/living/ranged_ability_user
	var/ranged_clickcd_override = -1
	var/has_action = TRUE
	var/datum/action/spell_action/action = null
	var/action_icon = 'icons/mob/actions/actions_spells.dmi'
	var/action_icon_state = "spell_default"
	var/action_background_icon_state = "bg_spell"
	var/base_action = /datum/action/spell_action
	var/mmb = TRUE
	var/releasedrain = 0
	var/chargedrain = 0
	var/chargetime = 0
	var/warnie = "mobwarning"
	var/list/charge_invocation
	var/no_early_release = FALSE //we can't shoot off early
	var/movement_interrupt = FALSE //we cancel charging when changing mob direction, for concentration spells
	var/chargedloop = null
	var/charging_slowdown = 0
	var/obj/inhand_requirement = null
	var/overlay_state = null

	var/list/attunements
	var/attuned_strength = 1

/obj/effect/proc_holder/Initialize()
	. = ..()
	if(has_action)
		action = new base_action(src)
	update_icon()

/obj/effect/proc_holder/spell/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/proc/deactivate(mob/living/user)
	if(active)
		active = FALSE
	remove_ranged_ability()

/obj/effect/proc_holder/proc/on_gain(mob/living/user)
	return

/obj/effect/proc_holder/proc/on_lose(mob/living/user)
	return

/obj/effect/proc_holder/proc/fire(mob/living/user)
	return TRUE

/obj/effect/proc_holder/proc/get_panel_text()
	return ""

/obj/effect/proc_holder/proc/get_chargetime()
	return chargetime

/obj/effect/proc_holder/proc/get_fatigue_drain()
	return releasedrain

GLOBAL_LIST_INIT(spells, typesof(/obj/effect/proc_holder/spell)) //needed for the badmin verb for now

/obj/effect/proc_holder/Destroy()
	if (action)
		qdel(action)
	if(ranged_ability_user)
		remove_ranged_ability()
	return ..()

/obj/effect/proc_holder/proc/InterceptClickOn(mob/living/requester, params, atom/A)
	if(requester.ranged_ability != src || ranged_ability_user != requester) //I'm not actually sure how these would trigger, but, uh, safety, I guess?
		to_chat(requester, "<span class='info'><b>[requester.ranged_ability.name]</b> has been disabled.</span>")
		requester.ranged_ability.remove_ranged_ability()
		return TRUE //TRUE for failed, FALSE for passed.
	if(ranged_clickcd_override >= 0)
		ranged_ability_user.next_click = world.time + ranged_clickcd_override
	else
		ranged_ability_user.next_click = world.time + CLICK_CD_CLICK_ABILITY
	ranged_ability_user.face_atom(A)
	return FALSE

/obj/effect/proc_holder/proc/add_ranged_ability(mob/living/user, msg, forced)
	if(!user || !user.client)
		return
	if(user.ranged_ability && user.ranged_ability != src)
		if(forced)
//			to_chat(user, "<span class='info'><b>[user.ranged_ability.name]</b> has been replaced by <b>[name]</b>.</span>")
			user.ranged_ability.deactivate(user)
		else
			return
	user.ranged_ability = src
	ranged_ability_user = user
	if(!mmb)
		user.click_intercept = src
		user.update_mouse_pointer()
	else
		user.mmb_intent_change(QINTENT_SPELL)
	if(msg)
		to_chat(ranged_ability_user, msg)
	update_icon()

/obj/effect/proc_holder/proc/remove_ranged_ability(msg)
	if(!ranged_ability_user || !ranged_ability_user.client || (ranged_ability_user.ranged_ability && ranged_ability_user.ranged_ability != src)) //To avoid removing the wrong ability
		return
	ranged_ability_user.ranged_ability = null
	if(!mmb)
		ranged_ability_user.click_intercept = null
		ranged_ability_user.update_mouse_pointer()
	else
		ranged_ability_user.mmb_intent_change(null)
	if(msg)
		to_chat(ranged_ability_user, msg)
	ranged_ability_user = null
	update_icon()

/obj/effect/proc_holder/spell
	name = "Spell"
	desc = ""
	panel = "Spells"
	var/sound = null //The sound the spell makes when it is cast
	anchored = TRUE // Crap like fireball projectiles are proc_holders, this is needed so fireballs don't get blown back into your face via atmos etc.
	pass_flags = PASSTABLE
	density = FALSE
	opacity = 0

	var/cost = 0 //how many points it costs to learn this spell

	var/school = "evocation" //not relevant at now, but may be important later if there are changes to how spells work. the ones I used for now will probably be changed... maybe spell presets? lacking flexibility but with some other benefit?

	var/recharge_time = 50 //recharge time in deciseconds if charge_type = "recharge" or starting charges if charge_type = "charges"
	var/charge_counter = 0 //can only cast spells if it equals recharge, ++ each decisecond if charge_type = "recharge" or -- each cast if charge_type = "charges"
	var/still_recharging_msg = "<span class='notice'>The spell is still recharging.</span>"
	var/recharging = TRUE

	var/cast_without_targets = FALSE

	var/holder_var_type = "bruteloss" //only used if charge_type equals to "holder_var"
	var/holder_var_amount = 20 //same. The amount adjusted with the mob's var when the spell is used

	var/nonabstract_req = FALSE //spell can only be cast by mobs that are physical entities
	var/stat_allowed = FALSE //see if it requires being conscious/alive, need to set to 1 for ghostpells
	var/phase_allowed = FALSE // If true, the spell can be cast while phased, eg. blood crawling, ethereal jaunting
	var/antimagic_allowed = FALSE // If false, the spell cannot be cast while under the effect of antimagic
	var/invocation = "" //what is uttered when the wizard casts the spell
	var/invocation_emote_self = null
	var/invocation_type = "none" //can be none, whisper, emote and shout
	var/range = 7 //the range of the spell; outer radius for aoe spells
	var/message = "" //whatever it says to the guy affected by it
	var/selection_type = "view" //can be "range" or "view"
	var/spell_level = 0 //if a spell can be taken multiple times, this raises
	var/level_max = 4 //The max possible level_max is 4
	var/cooldown_min = 0 //This defines what spell quickened four times has as a cooldown. Make sure to set this for every spell
	var/player_lock = TRUE //If it can be used by simple mobs

	var/overlay = 0
	var/overlay_icon = 'icons/obj/wizard.dmi'
	var/overlay_icon_state = "spell"
	var/overlay_lifespan = 0

	var/sparks_spread = 0
	var/sparks_amt = 0 //cropped at 10

	var/list/req_items = list()		//required worn items to cast
	var/req_inhand = null			//required inhand to cast
	var/base_icon_state = "spell"
	var/associated_skill = /datum/skill/magic/arcane
	var/miracle = FALSE
	var/healing_miracle = FALSE
	var/devotion_cost = 0
	var/ignore_cockblock = FALSE //whether or not to ignore TRAIT_SPELLBLOCK
	var/uses_mana = TRUE

	action_icon_state = "spell0"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	action_background_icon_state = ""
	base_action = /datum/action/spell_action/spell

/obj/effect/proc_holder/spell/proc/create_logs(atom/user, list/targets)
	var/list/parsed_target_list = list()
	for(var/atom/target as anything in targets)
		if(ismob(target))
			var/mob/mob_target = target
			parsed_target_list += key_name_admin(mob_target)
		else
			parsed_target_list += target.name
	var/targets_string
	if(parsed_target_list)
		targets_string = parsed_target_list.Join(", ")
		for(var/atom/target as anything in targets)
			target.log_message("was affected by spell [name], caster was [key_name_admin(user)]", LOG_ATTACK, "red", FALSE)
	if(user)
		record_featured_object_stat(FEATURED_STATS_SPELLS, name)
		user.log_message("casted the spell [name][targets_string ? " on [targets_string ]" : ""].", LOG_ATTACK, "red")

/obj/effect/proc_holder/spell/get_chargetime()
	if(ranged_ability_user && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime - (chargetime * (ranged_ability_user.get_skill_level(associated_skill) * 0.05))
		//int block
		if(ranged_ability_user.STAINT > 10)
			newtime = newtime - (chargetime * (ranged_ability_user.STAINT * 0.02))
		else if(ranged_ability_user.STAINT < 10)
			var/diffy = 10 - ranged_ability_user.STAINT
			newtime = newtime + (chargetime * (diffy * 0.02))
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/obj/effect/proc_holder/spell/get_fatigue_drain()
	if(ranged_ability_user && releasedrain)
		var/newdrain = releasedrain
		//skill block
		newdrain = newdrain - (releasedrain * (ranged_ability_user.get_skill_level(associated_skill) * 0.05))
		var/charged_modifier = 100 - ranged_ability_user.client.chargedprog
		if(charged_modifier != 0)
			newdrain *= max(1, min(5.60 * log(0.0144 * charged_modifier + 1.297) - 0.607, 10))//chat I think this is math

		//int block
		if(ranged_ability_user.STAINT > 10)
			newdrain = newdrain - (releasedrain * (ranged_ability_user.STAINT * 0.02))
		else if(ranged_ability_user.STAINT < 10)
			var/diffy = 10 - ranged_ability_user.STAINT
			newdrain = newdrain + (releasedrain * (diffy * 0.02))
		if(ranged_ability_user.get_encumbrance() > 0.4)
			newdrain += 40
		if(newdrain > 0)
			return newdrain
		else
			return 0.1

	return releasedrain


/obj/effect/proc_holder/spell/proc/cast_check(skipcharge = 0, mob/user = usr) //checks if the spell can be cast based on its settings; skipcharge is used when an additional cast_check is called inside the spell
	if(user.mmb_intent && !skipcharge)
		if(SEND_SIGNAL(user?.mmb_intent, COMSIG_SPELL_BEFORE_CAST))
			return FALSE

	if(player_lock)
		if(!user.mind || !(src in user.mind.spell_list) && !(src in user.mob_spell_list))
			to_chat(user, "<span class='warning'>I shouldn't have this spell! Something's wrong.</span>")
			return FALSE
	else
		if(!(src in user.mob_spell_list))
			return FALSE

	if(!skipcharge)
		if(!charge_check(user))
			return FALSE

	if(user.stat && !stat_allowed)
		to_chat(user, "<span class='warning'>Not when you're incapacitated!</span>")
		return FALSE

	if(!ignore_cockblock && HAS_TRAIT(user, TRAIT_SPELLBLOCK))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_NOC_CURSE))
		to_chat(user, span_warning("My magicka has left me..."))
		return FALSE

	if(!antimagic_allowed)
		var/antimagic = user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE)
		if(antimagic)
			if(isitem(antimagic))
				to_chat(user, "<span class='notice'>[antimagic] is interfering with your magic.</span>")
			else
				to_chat(user, "<span class='warning'>Magic seems to flee from you, you can't gather enough power to cast this spell.</span>")
			return FALSE

	if(!phase_allowed && istype(user.loc, /obj/effect/dummy))
		to_chat(user, "<span class='warning'>[name] cannot be cast unless you are completely manifested in the material plane!</span>")
		return FALSE

	if(ishuman(user))

		var/mob/living/carbon/human/H = user

		if((invocation_type == "whisper" || invocation_type == "shout") && !H.can_speak_vocal())
			to_chat(user, "<span class='warning'>I can't get the words out!</span>")
			return FALSE

		if(miracle)
			var/datum/devotion/cleric_holder/D = H.cleric
			if(!D?.check_devotion(devotion_cost))
				to_chat(H, "<span class='warning'>I don't have enough devotion!</span>")
				return FALSE
	else
		if(nonabstract_req && (isbrain(user)))
			to_chat(user, "<span class='warning'>This spell can only be cast by physical beings!</span>")
			return FALSE

	if(req_items.len)
		var/list/confirmed_items = list()
		for(var/I in req_items)
			for(var/obj/item/IN in user.contents)
				if(istype(IN, I))
					confirmed_items += IN
					continue
		if(confirmed_items.len != req_items.len)
			to_chat(user, "<span class='warning'>I'm missing something to cast this.</span>")
			return FALSE

	if(req_inhand)
		if(!istype(user.get_active_held_item(), req_inhand))
			to_chat(user, "<span class='warning'>I'm missing something to cast this.</span>")
			return FALSE

	if(!skipcharge)
		charge_counter = 0
	if(action)
		action.UpdateButtonIcon()
	return TRUE

/obj/effect/proc_holder/spell/proc/charge_check(mob/user, silent = FALSE)
	if(charge_counter < recharge_time)
		if(!silent)
			to_chat(user, still_recharging_msg)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/proc/invocation(mob/user = usr) //spelling the spell out and setting it on recharge/reducing charges amount
	if(!invocation)
		return
	switch(invocation_type)
		if("shout")
			if(prob(50))//Auto-mute? Fuck that noise
				user.say(invocation, forced = "spell")
			else
				user.say(invocation, forced = "spell")
		if("whisper")
			if(prob(50))
				user.whisper(invocation)
			else
				user.whisper(invocation)
		if("emote")
			user.visible_message(invocation, invocation_emote_self) //same style as in mob/living/emote.dm

/obj/effect/proc_holder/spell/proc/playMagSound()
	var/ss = sound
	if(islist(sound))
		ss = pick(sound)
	playsound(get_turf(usr), ss,100,FALSE)

/obj/effect/proc_holder/spell/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

	still_recharging_msg = "<span class='warning'>[name] is still recharging!</span>"
	charge_counter = recharge_time

/obj/effect/proc_holder/spell/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(action)
	return ..()

/obj/effect/proc_holder/spell/Click()
	if(cast_check())
		choose_targets()
	return 1

/obj/effect/proc_holder/spell/proc/choose_targets(mob/user = usr) //depends on subtype - /targeted or /aoe_turf
	return

/obj/effect/proc_holder/spell/proc/can_target(mob/living/target)
	return TRUE

/obj/effect/proc_holder/spell/proc/start_recharge()
	recharging = TRUE

/obj/effect/proc_holder/spell/process()
	if(recharging && (charge_counter < recharge_time))
		charge_counter += 2	//processes 5 times per second instead of 10.
		if(charge_counter >= recharge_time)
			action.UpdateButtonIcon()
			charge_counter = recharge_time
			recharging = FALSE

/obj/effect/proc_holder/spell/proc/set_attuned_strength(list/incoming_attunements)
	var/total_value = 1
	for(var/datum/attunement/attunement as anything in attunements)
		if(!(attunement in incoming_attunements))
			continue
		if(attunements[attunement] < 0)
			total_value += incoming_attunements[attunement] + attunements[attunement]
		else
			total_value += incoming_attunements[attunement] - attunements[attunement]
	attuned_strength = total_value
	return

/obj/effect/proc_holder/spell/proc/perform(list/targets, recharge = TRUE, mob/user = usr) //if recharge is started is important for the trigger spells
	if(length(targets) && miracle && healing_miracle)
		var/mob/living/target = targets[1]
		if(istype(target))
			var/lux_state = target.get_lux_status()
			if(lux_state != LUX_HAS_LUX)
				target.visible_message(span_warning("[target] recoils in disgust!"))

	before_cast(targets)
	invocation(user)

	var/list/datum/mana_pool/usable_pools = list()

	for (var/atom/movable/thing as anything in user.get_all_contents())
		if (!isnull(thing.mana_pool) && HAS_TRAIT(thing, TRAIT_POOL_AVAILABLE_FOR_CAST))
			usable_pools += thing.mana_pool

	if (!isnull(user.mana_pool))
		usable_pools += user.mana_pool

	var/list/total_attunements = GLOB.default_attunements.Copy()

	for(var/datum/mana_pool/pool as anything in usable_pools)
		for(var/negative_attunement in pool.negative_attunements)
			total_attunements[negative_attunement] += pool.negative_attunements[negative_attunement]
		for(var/attunement in pool.attunements)
			total_attunements[attunement] += pool.attunements[attunement]

	set_attuned_strength(total_attunements)
	if(user && user.ckey)
		create_logs(user, targets)
	if(recharge)
		recharging = FALSE
	if(cast(targets,user=user))
		start_recharge()
		if(sound)
			playMagSound()
		after_cast(targets)
		if(action)
			action.UpdateButtonIcon()
		return TRUE
	else
		to_chat(user,span_warn("Your spell [name] fizzles!"))
		revert_cast(user)

/obj/effect/proc_holder/spell/proc/before_cast(list/targets)
	if(overlay)
		for(var/atom/target in targets)
			var/location
			if(isliving(target))
				location = target.loc
			else if(isturf(target))
				location = target
			var/obj/effect/overlay/spell = new /obj/effect/overlay(location)
			spell.icon = overlay_icon
			spell.icon_state = overlay_icon_state
			spell.anchored = TRUE
			spell.density = FALSE
			QDEL_IN(spell, overlay_lifespan)

/obj/effect/proc_holder/spell/proc/after_cast(list/targets)
	for(var/atom/target in targets)
		var/location
		if(isliving(target))
			location = target.loc
		else if(isturf(target))
			location = target
		if(isliving(target) && message)
			to_chat(target, text("[message]"))
		if(sparks_spread)
			do_sparks(sparks_amt, FALSE, location)
	if(ismob(usr))
		var/mob/living/user = usr
		if(user.mmb_intent)
			SEND_SIGNAL(user.mmb_intent, COMSIG_SPELL_AFTER_CAST, targets)


/obj/effect/proc_holder/spell/proc/cast(list/targets,mob/user = usr)
	if(miracle)
		var/mob/living/carbon/human/C = user
		var/datum/devotion/cleric_holder/D = C.cleric
		D.update_devotion(-devotion_cost)
	return TRUE

/obj/effect/proc_holder/spell/proc/view_or_range(distance = world.view, center=usr, type="view")
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)

/obj/effect/proc_holder/spell/proc/revert_cast(mob/user = usr) //resets recharge or readds a charge
	charge_counter = recharge_time
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/proc/adjust_var(mob/living/target = usr, type, amount) //handles the adjustment of the var when the spell is used. has some hardcoded types
	if (!istype(target))
		return
	switch(type)
		if("bruteloss")
			target.adjustBruteLoss(amount)
		if("fireloss")
			target.adjustFireLoss(amount)
		if("toxloss")
			target.adjustToxLoss(amount)
		if("oxyloss")
			target.adjustOxyLoss(amount)
		if("stun")
			target.AdjustStun(amount)
		if("knockdown")
			target.AdjustKnockdown(amount)
		if("paralyze")
			target.AdjustParalyzed(amount)
		if("immobilize")
			target.AdjustImmobilized(amount)
		if("unconscious")
			target.AdjustUnconscious(amount)
		else
			target.vars[type] += amount //I bear no responsibility for the runtimes that'll happen if you try to adjust non-numeric or even non-existent vars

/obj/effect/proc_holder/spell/targeted //can mean aoe for mobs (limited/unlimited number) or one target mob
	var/max_targets = 1 //leave 0 for unlimited targets in range, 1 for one selectable target in range, more for limited number of casts (can all target one guy, depends on target_ignore_prev) in range
	var/target_ignore_prev = 1 //only important if max_targets > 1, affects if the spell can be cast multiple times at one person from one cast
	var/include_user = 0 //if it includes usr in the target list
	var/random_target = 0 // chooses random viable target instead of asking the caster
	var/random_target_priority = TARGET_CLOSEST // if random_target is enabled how it will pick the target


/obj/effect/proc_holder/spell/aoe_turf //affects all turfs in view or range (depends)
	var/inner_radius = -1 //for all your ring spell needs

/obj/effect/proc_holder/spell/targeted/choose_targets(mob/user = usr)
	var/list/targets = list()

	switch(max_targets)
		if(0) //unlimited
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target))
					continue
				targets += target
		if(1) //single target can be picked
			if(range < 0)
				targets += user
			else
				var/possible_targets = list()

				for(var/mob/living/M in view_or_range(range, user, selection_type))
					if(!include_user && user == M)
						continue
					if(!can_target(M))
						continue
					possible_targets += M

				//targets += input("Choose the target for the spell.", "Targeting") as mob in possible_targets
				//Adds a safety check post-input to make sure those targets are actually in range.
				var/mob/M
				if(!random_target)
					M = input("Choose the target for the spell.", "Targeting") as null|mob in sortNames(possible_targets)
				else
					switch(random_target_priority)
						if(TARGET_RANDOM)
							M = pick(possible_targets)
						if(TARGET_CLOSEST)
							for(var/mob/living/L in possible_targets)
								if(M)
									if(get_dist(user,L) < get_dist(user,M))
										if(los_check(user,L))
											M = L
								else
									if(los_check(user,L))
										M = L
				if(M in view_or_range(range, user, selection_type))
					targets += M

		else
			var/list/possible_targets = list()
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target))
					continue
				possible_targets += target
			for(var/i=1,i<=max_targets,i++)
				if(!possible_targets.len)
					break
				if(target_ignore_prev)
					var/target = pick(possible_targets)
					possible_targets -= target
					targets += target
				else
					targets += pick(possible_targets)

	if(!include_user && (user in targets))
		targets -= user

	if(!targets.len && !cast_without_targets) //doesn't waste the spell
		revert_cast(user)
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/aoe_turf/choose_targets(mob/user = usr)
	var/list/targets = list()

	for(var/turf/target in view_or_range(range,user,selection_type))
		if(!can_target(target))
			continue
		if(!(target in view_or_range(inner_radius,user,selection_type)))
			targets += target

	if(!targets.len) //doesn't waste the spell
		revert_cast()
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/proc/updateButtonIcon(status_only, force)
	action.UpdateButtonIcon(status_only, force)

/obj/effect/proc_holder/spell/proc/can_be_cast_by(mob/caster)
	return TRUE

/obj/effect/proc_holder/spell/proc/los_check(mob/A,mob/B)
	//Checks for obstacles from A to B
	var/obj/effect/dummy = new(A.loc)
	dummy.pass_flags |= PASSTABLE
	dummy.movement_type = FLYING
	dummy.invisibility = INVISIBILITY_ABSTRACT
	for(var/turf/turf in getline(A,B))
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1

/obj/effect/proc_holder/spell/proc/can_cast(mob/user = usr)
	if(((!user.mind) || !(src in user.mind.spell_list)) && !(src in user.mob_spell_list))
		return FALSE

	if(!charge_check(user,TRUE))
		return FALSE

	if(user.stat && !stat_allowed)
		return FALSE

	if(!ignore_cockblock && HAS_TRAIT(user, TRAIT_SPELLBLOCK))
		return FALSE

	if(!antimagic_allowed && user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE))
		return FALSE

	if(!ishuman(user))
		if(nonabstract_req && (isbrain(user)))
			return FALSE
	if((invocation_type == "whisper" || invocation_type == "shout") && isliving(user))
		var/mob/living/living_user = user
		if(!living_user.can_speak_vocal())
			return FALSE

	return TRUE

/obj/effect/proc_holder/spell/self //Targets only the caster. Good for buffs and heals, but probably not wise for fireballs (although they usually fireball themselves anyway, honke)
	range = -1 //Duh

/obj/effect/proc_holder/spell/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

/obj/effect/proc_holder/spell/self/basic_heal //This spell exists mainly for debugging purposes, and also to show how casting works
	name = "Lesser Heal"
	desc = ""
	recharge_time = 100
	invocation = "Victus sano!"
	invocation_type = "whisper"
	school = "restoration"
	sound = 'sound/blank.ogg'

/obj/effect/proc_holder/spell/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>I wreath myself in healing light!</span>")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)
