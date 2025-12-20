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
	var/datum/antagonist/werewolf/werewolf_player = owner.mind.has_antag_datum(/datum/antagonist/werewolf)

	// sound played for owner
	playsound(owner, pick('sound/vo/mobs/wwolf/howl (1).ogg', 'sound/vo/mobs/wwolf/howl (2).ogg'), 75, TRUE)

	for(var/mob/player as anything in (GLOB.player_list - owner))
		if(!player.mind)
			continue
		if(player.stat == DEAD)
			continue

		// Announcement to other werewolves (and anyone else who has beast language somehow)
		if(player.mind.has_antag_datum(/datum/antagonist/werewolf) || (use_language && player.has_language(/datum/language/beast)))
			to_chat(player, span_boldannounce("[werewolf_player ? werewolf_player.wolfname : owner.real_name] howls to the hidden moon: [message]"))

		if(get_dist(player, owner) > 7)
			player.playsound_local(get_turf(player), pick('sound/vo/mobs/wwolf/howldist (1).ogg','sound/vo/mobs/wwolf/howldist (2).ogg'), 50, FALSE, pressure_affected = FALSE)

	owner.log_message("howls: [message] (WEREWOLF)", LOG_ATTACK)

/datum/action/cooldown/spell/undirected/claws
	name = "Lupine Claws"
	desc = "!"
	button_icon_state = "claws"
	has_visual_effects = FALSE
	antimagic_flags = NONE
	spell_flags = SPELL_IGNORE_SPELLBLOCK

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	var/extended = FALSE

/datum/action/cooldown/spell/undirected/claws/cast(atom/cast_on)
	. = ..()
	var/obj/item/weapon/werewolf_claw/left/l
	var/obj/item/weapon/werewolf_claw/right/r

	l = owner.get_active_held_item()
	r = owner.get_inactive_held_item()

	if(extended)
		if(istype(owner.get_active_held_item(), /obj/item/weapon/werewolf_claw))
			owner.dropItemToGround(l, TRUE)
			owner.dropItemToGround(r, TRUE)
			qdel(l)
			qdel(r)
			//owner.visible_message("Your claws retract.", "You feel your claws retracting.", "You hear a sound of claws retracting.")
			extended = FALSE
	else
		l = new(owner, 1)
		r = new(owner, 2)
		owner.put_in_hands(l, TRUE, FALSE, TRUE)
		owner.put_in_hands(r, TRUE, FALSE, TRUE)
		//owner.visible_message("Your claws extend.", "You feel your claws extending.", "You hear a sound of claws extending.")
		extended = TRUE

/datum/action/cooldown/spell/woundlick
	name = "Lick the wounds"
	desc = "Heal the wounds of somebody"
	button_icon_state = "diagnose"

	cast_range = 1

	spell_cost = 0
	charge_required = FALSE

/datum/action/cooldown/spell/woundlick/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(!istype(cast_on))
		return

	if(do_after(owner, 7 SECONDS, cast_on))
		var/ramount = 20
		var/rid = /datum/reagent/medicine/healthpot
		cast_on.reagents.add_reagent(rid, ramount)
		rid = /datum/reagent/water
		cast_on.reagents.add_reagent(rid, ramount)

		if(cast_on.mind?.has_antag_datum(/datum/antagonist/werewolf))
			cast_on.visible_message(span_green("[owner] is licking [cast_on]'s wounds with its tongue!"), span_notice("My kin has covered my wounds..."))
		else
			cast_on.visible_message(span_green("[owner] is licking [cast_on]'s wounds with its tongue!"), span_notice("That thing... Did it lick my wounds?"))
