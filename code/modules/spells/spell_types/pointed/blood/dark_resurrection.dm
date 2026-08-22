/datum/action/cooldown/spell/dark_resurrection
	name = "Dark Resurrection"
	desc = "Drag a soul from Necra's embrace with unholy Blood Magic, cursing them to be cut off from Divine healing indefinitely."
	button_icon_state = "pestra_revive"
	sound = 'sound/magic/marked.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	cast_range = 2
	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_RESTORATION
	required_level = 14
	spell_flags = SPELL_UNETCHABLE
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation_type = INVOCATION_SHOUT
	invocation = "Excieo cruor!!"
	self_cast_possible = FALSE

	charge_time = 8 SECONDS
	charge_slowdown = 0.7
	cooldown_time = 3 MINUTES
	spell_cost = 500

/datum/action/cooldown/spell/dark_resurrection/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/dark_resurrection/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.stat != DEAD)
		to_chat(owner, span_warning("There is no way to resurrect the living!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	for(var/obj/item/bodypart/bodypart as anything in cast_on.bodyparts)
		if(bodypart.skeletonized || HAS_TRAIT(bodypart, TRAIT_ROTTEN))
			to_chat(owner, span_warning("The rotten are unsuitable."))
			reset_spell_cooldown()
			return . | SPELL_CANCEL_CAST

	if(HAS_TRAIT(cast_on, TRAIT_NECRA_CURSE))
		to_chat(owner, span_warning("Necra holds tight to this one."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/dark_resurrection/cast(mob/living/carbon/human/cast_on)
	. = ..()

	if(!cast_on.can_be_revived())
		cast_on.visible_message(span_warning("Crimson light engulfs [cast_on], but they remain limp..."))
		return
	if(!cast_on.revive())
		to_chat(owner, span_warning("The Blood Magic fails to resurrect [cast_on]!"))
		return
	if(cast_on.health > HALFWAYCRITDEATH)
		cast_on.adjustOxyLoss(cast_on.health - HALFWAYCRITDEATH)
	cast_on.adjustOrganLoss(ORGAN_SLOT_BRAIN, -100)
	cast_on.reagents.add_reagent(/datum/reagent/medicine/atropine, 20)
	cast_on.grab_ghost(force = TRUE, grab_spirit = TRUE) // even suicides
	record_round_statistic(STATS_BLOODMAGIC_REVIVALS)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_BLOODMAGIC_REVIVE, 1)
	cast_on.emote("breathgasp")
	cast_on.adjust_jitter(100 SECONDS)
	cast_on.adjust_blood_volume(BLOOD_VOLUME_OKAY, maximum = BLOOD_VOLUME_OKAY)
	cast_on.visible_message(span_bloody("[cast_on] is revived by crimson light!"), span_bloody("I awake from the void."))
	if(!HAS_TRAIT(cast_on, TRAIT_BLOOD_MAGE) && !HAS_TRAIT(cast_on, TRAIT_BLOOD_SORCERER) && !cast_on.mind?.has_antag_datum(/datum/antagonist/vampire))
		cast_on.apply_status_effect(/datum/status_effect/debuff/revive_bloodmagic)
