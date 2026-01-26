/datum/action/cooldown/spell/revive
	name = "Anastasis"
	desc = "Return a soul from Necra's grasp with the light of Astrata."
	button_icon_state = "revive"
	sound = 'sound/magic/revive.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 1
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/astrata)

	charge_time = 5 SECONDS
	charge_slowdown = 0.7
	cooldown_time = 2 MINUTES
	spell_cost = 100

	var/obj/structure/fluff/psycross/target_cross

/datum/action/cooldown/spell/revive/Destroy()
	target_cross = null
	return ..()

/datum/action/cooldown/spell/revive/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/revive/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.stat != DEAD)
		to_chat(owner, span_warning("There is no way to revive the living!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(cast_on.get_lux_status() != LUX_HAS_LUX)
		to_chat(owner, span_warning("This filth cannot be revived by holy light!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	for(var/obj/item/bodypart/bodypart as anything in cast_on.bodyparts)
		if(bodypart.skeletonized || bodypart.rotted)
			to_chat(owner, span_warning("The rotten are unsuitable."))
			reset_spell_cooldown()
			return . | SPELL_CANCEL_CAST

	if(HAS_TRAIT(cast_on, TRAIT_NECRA_CURSE))
		to_chat(owner, span_warning("Necra holds tight to this one."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	for(var/obj/structure/fluff/psycross/S in view(5, owner))
		target_cross = S
		break

	if(!target_cross)
		to_chat(owner, span_warning("I need a holy cross."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/revive/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(QDELETED(target_cross))
		return
	target_cross.AOE_flash(owner, 7)
	target_cross = null
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		if(cast_on.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
			cast_on.visible_message(span_warning("[cast_on] overpowers being unmade!"), span_greentext("I overpower being unmade!"))
			return
		cast_on.visible_message(
			span_danger("[cast_on] is unmade by holy light!"),
			span_userdanger("I'm unmade by holy light!"),
		)
		cast_on.gib()
		return
	if(!cast_on.can_be_revived())
		cast_on.visible_message(span_warning("Holy light engulfs [cast_on], but they remain limp..."))
		return
	if(!cast_on.revive())
		to_chat(owner, span_warning("Astrata's light fails to revive [cast_on]!"))
		return
	if(cast_on.health > HALFWAYCRITDEATH)
		cast_on.adjustOxyLoss(cast_on.health - HALFWAYCRITDEATH)
	cast_on.grab_ghost(force = TRUE, grab_spirit = TRUE) // even suicides
	record_round_statistic(STATS_ASTRATA_REVIVALS)
	cast_on.emote("breathgasp")
	cast_on.adjust_jitter(100 SECONDS)
	cast_on.visible_message(span_notice("[cast_on] is revived by holy light!"), span_green("I awake from the void."))
	cast_on.apply_status_effect(/datum/status_effect/debuff/revive)
	cast_on.remove_client_colour(/datum/client_colour/monochrome/death)
