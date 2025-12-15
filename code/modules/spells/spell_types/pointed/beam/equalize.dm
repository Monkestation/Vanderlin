#define EQUALIZED_GLOW "equalizer glow"

/datum/action/cooldown/spell/beam/equalize
	name = "Equalize"
	desc = "Weaken someone to the difference between me and them."
	button_icon_state = "equalize"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation_type = INVOCATION_NONE

	charge_time = 4 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 2 MINUTES
	spell_cost = 20

	beam_icon_state = "nzcrentrs_power"
	beam_type = /obj/effect/ebeam
	beam_color = "#FFD700"
	time = 6 SECONDS
	max_distance = 4

	var/totalstatshift = 0
	var/totalstatchange = 0
	var/outline_colour = "#FFD700"

/datum/action/cooldown/spell/beam/equalize/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/beam/equalize/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return

	return ishuman(owner)

/datum/action/cooldown/spell/beam/equalize/on_beam_connect(mob/living/carbon/human/cast_on, mob/owner)
	equal(cast_on)

/datum/action/cooldown/spell/beam/equalize/proc/equal(mob/living/carbon/human/victim)
	if(victim.can_block_magic(antimagic_flags))
		victim.visible_message(
			span_warning("The ray fizzles on contact with [victim]!"),
			span_warning("The ray fizzles on contact with me!"),
		)
		playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
		qdel(active)
		return
	var/mob/living/carbon/human/C = owner
	totalstatchange += (victim.STASPD - C.STASPD)
	totalstatchange += ((victim.STASTR - C.STASTR)*2) // We're gonna weigh strength as double, being the strongest stat.
	totalstatchange += (victim.STAEND - C.STAEND)
	totalstatchange += (victim.STALUC - C.STALUC)
	totalstatchange += (victim.STAINT - C.STAINT)
	totalstatchange += (victim.STACON - C.STACON)
	totalstatchange += (victim.STAPER - C.STAPER)
	totalstatchange -= 3 // We need At least a 4 point disadvantage before we start siphoning
	totalstatshift = CLAMP((totalstatchange), 0, 2) // We DO NOT WANT Matthian Clerics stealing 30 stats from Ascendants, Cap the statshift by 2
	if(totalstatshift <1)
		to_chat(owner, "<font color='yellow'>[victim] fire burns dimly, there is nothing worth equalizing.</font>")
		return
	else
		// there is SURELY a better way to do this
		playsound(owner, 'sound/magic/swap.ogg', 100, TRUE)
		owner.add_filter(EQUALIZED_GLOW, 2, outline_filter(1, outline_colour))
		victim.add_filter(EQUALIZED_GLOW, 2, outline_filter(1, outline_colour))
		to_chat(victim, span_danger("I feel my flame being siphoned!"))
		to_chat(owner, "<font color='yellow'>The Equalizing link is made, I am siphoning flame!</font>")
		var/list/statsmod = list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_END, STATKEY_CON, STATKEY_SPD, STATKEY_LCK)
		for(var/stat_key in statsmod)
			victim.set_stat_modifier(STATMOD_EQUALIZE, stat_key, -totalstatshift)
			C.set_stat_modifier(STATMOD_EQUALIZE, stat_key, totalstatshift)
		addtimer(CALLBACK(src, PROC_REF(returnstatstarget), victim), 1 MINUTES) // 2 timers incase only one guy gets deleted or smthing
		addtimer(CALLBACK(src, PROC_REF(returnstatsuser), C), 1 MINUTES)


/datum/action/cooldown/spell/beam/equalize/proc/returnstatstarget(mob/living/target)
	if(QDELETED(target))
		return
	target.remove_filter(EQUALIZED_GLOW)
	target.remove_stat_modifier(STATMOD_EQUALIZE)
	to_chat(target, span_danger("I feel my strength returned to me!"))

/datum/action/cooldown/spell/beam/equalize/proc/returnstatsuser(mob/living/user)
	if(QDELETED(user))
		return
	user.remove_filter(EQUALIZED_GLOW)
	user.remove_stat_modifier(STATMOD_EQUALIZE)
	to_chat(user, "<font color='yellow'>My link wears off, their stolen fire returns to them</font>")

#undef EQUALIZED_GLOW
