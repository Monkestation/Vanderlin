/datum/action/cooldown/spell/undirected/howl
	name = "Howl"
	desc = "!"
	button_icon_state = "howl"
	has_visual_effects = FALSE
	antimagic_flags = NONE
	spell_flags = SPELL_IGNORE_SPELLBLOCK

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	var/message
	var/use_language = FALSE

/datum/action/cooldown/spell/undirected/howl/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	message = browser_input_text(owner, "Howl at the hidden moon...", "MOONCURSED", multiline = TRUE)
	if(QDELETED(src) || QDELETED(owner) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/howl/cast(atom/cast_on)
	. = ..()

	// sound played for owner
	playsound(owner, pick('sound/vo/mobs/wwolf/howl (1).ogg', 'sound/vo/mobs/wwolf/howl (2).ogg'), 75, TRUE)

	// for(var/mob/player as anything in (GLOB.player_list - owner))
	// 	if(!player.mind)
	// 		continue
	// 	if(player.stat == DEAD)
	// 		continue

	// 	// Announcement to other werewolves (and anyone else who has beast language somehow)
	// 	if(player.mind.has_antag_datum(/datum/antagonist/werewolf) || (use_language && player.has_language(/datum/language/beast)))
	// 		to_chat(player, span_boldannounce("[werewolf_player ? werewolf_player.wolfname : owner.real_name] howls to the hidden moon: [message]"))

	// 	if(get_dist(player, owner) > 7)
	// 		player.playsound_local(get_turf(player), pick('sound/vo/mobs/wwolf/howldist (1).ogg','sound/vo/mobs/wwolf/howldist (2).ogg'), 50, FALSE, pressure_affected = FALSE)

	owner.log_message("howls: [message] (WEREWOLF)", LOG_ATTACK)

/datum/action/cooldown/spell/undirected/claws
	name = "Lupine Claws"
	desc = "!"
	button_icon_state = "claws"
	has_visual_effects = FALSE
	antimagic_flags = NONE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	associated_skill = null

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	var/extended = FALSE

/datum/action/cooldown/spell/undirected/claws/cast(atom/cast_on)
	. = ..()
	var/obj/item/weapon/werewolf_claw/left/left_claw
	var/obj/item/weapon/werewolf_claw/right/right_claw

	if(extended)
		for(var/obj/item/weapon/werewolf_claw/claw in owner.held_items)
			qdel(claw)
		to_chat(owner, "You feel your claws retracting.")
		//owner.visible_message("Your claws retract.", "You feel your claws retracting.", "You hear a sound of claws retracting.")
	else
		left_claw = new()
		right_claw = new()
		if(!owner.put_in_l_hand(left_claw))
			qdel(left_claw)
		if(!owner.put_in_r_hand(right_claw))
			qdel(right_claw)
		to_chat(owner, "You feel your claws extending.")
		//owner.visible_message("Your claws extend.", "You feel your claws extending.", "You hear a sound of claws extending.")
	extended = !extended

/datum/action/cooldown/spell/woundlick
	name = "Lick the wounds"
	desc = "Heal the wounds of somebody"
	button_icon_state = "diagnose"

	cast_range = 1

	spell_cost = 5
	cooldown_time = 5 SECONDS
	charge_required = FALSE
	associated_skill = null
	has_visual_effects = FALSE

/datum/action/cooldown/spell/woundlick/is_valid_target(atom/target_atom)
	. = ..()
	if(!.)
		return FALSE
	return ismob(target_atom)

/datum/action/cooldown/spell/woundlick/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(!istype(cast_on))
		return

	if(do_after(owner, 4 SECONDS, cast_on))
		var/ramount = 5 // fully metabolized just under 9 seconds. DO NOT ALLOW REAGENT STACKING
		var/rid = /datum/reagent/medicine/healthpot
		cast_on.reagents.add_reagent(rid, ramount)

		if(cast_on.mind?.has_antag_datum(/datum/antagonist/werewolf))
			cast_on.visible_message(span_green("[owner] is licking [cast_on]'s wounds with its tongue!"), span_notice("My kin has covered my wounds..."), vision_distance = COMBAT_MESSAGE_RANGE)
		else
			cast_on.visible_message(span_green("[owner] is licking [cast_on]'s wounds with its tongue!"), span_notice("That thing... Did it lick my wounds?"), vision_distance = COMBAT_MESSAGE_RANGE)
