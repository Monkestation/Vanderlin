/datum/action/cooldown/spell/blood_healing
	name = "Blood Mending"
	desc = "Wield the power of blood to heal yourself or another."
	button_icon = 'icons/mob/actions/spells/mage_augmentation.dmi'
	button_icon_state = "blood_rush"
	sound = 'sound/magic/enter_blood.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	cast_range = 6
	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_RESTORATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 50
	spell_flags = SPELL_UNETCHABLE

	/// Base healing before adjustments
	var/base_healing = 12.5
	/// Wound healing modifier
	var/wound_modifier = 0.25
	/// Blood healing amount
	var/blood_restoration = BLOOD_VOLUME_SURVIVE / 15

/datum/action/cooldown/spell/blood_healing/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/blood_healing/cast(mob/living/cast_on)
	. = ..()
	var/amount_healed = base_healing
	var/blood_restored = blood_restoration

	cast_on.visible_message(span_info("[cast_on]'s blood reacts to strange forces!"), span_notice("My blood feels like its boiling and pulsing!"))
	if((cast_on != owner) && (cast_on.mind?.has_antag_datum(/datum/antagonist/vampire) || HAS_TRAIT(cast_on, TRAIT_BLOOD_MAGE) || HAS_TRAIT(cast_on, TRAIT_BLOOD_SORCERER)))
		to_chat(owner, span_bloody("My blood mending is stronger upon a master of Vitae!"))
		amount_healed *= 2
		blood_restored *= 1.5

	SEND_SIGNAL(owner, COMSIG_LIVING_HEALED_OTHER, amount_healed)
	cast_on.adjustToxLoss(-amount_healed)
	cast_on.adjustOxyLoss(-amount_healed)
	cast_on.adjust_blood_volume(blood_restored, maximum = BLOOD_VOLUME_NORMAL)
	if(!iscarbon(cast_on))
		cast_on.adjustBruteLoss(-amount_healed)
		cast_on.adjustFireLoss(-amount_healed)
		return

	var/mob/living/carbon/C = cast_on
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(owner.zone_selected))
	if(!affecting)
		to_chat(owner, span_danger("[C] is missing their [affecting]!"))
		return

	if(affecting.heal_wounds(amount_healed * wound_modifier, src))
		record_round_statistic(STATS_WOUNDS_FIXED)
	if(affecting.heal_damage(brute = amount_healed, burn = amount_healed))
		C.update_damage_overlays()

	for(var/obj/item/organ/possible_organ as anything in affecting.getorganlist(/obj/item/organ))
		if(ORGAN_SLOT_ARTERY in possible_organ.organ_efficiency)
			possible_organ.applyOrganDamage(-amount_healed * wound_modifier)
			continue
		if(possible_organ.scarred_below(40))
			continue
		if(possible_organ.organ_flags & ORGAN_DESTROYED)
			possible_organ.organ_flags &= ~ORGAN_DESTROYED
			possible_organ.scar_organ(20, 40)
		possible_organ.applyOrganDamage(-amount_healed * wound_modifier)

/datum/action/cooldown/spell/blood_healing/greater
	name = "Greater Blood Mending"
	desc = "Wield the power of blood to heal yourself or another with even greater potency."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "healer" //Vampiric icon in theme with more of a vampiric strength.

	charge_required = TRUE
	charge_time = 2 SECONDS
	cooldown_time = 20 SECONDS
	spell_cost = 100
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED

	invocation_type = INVOCATION_WHISPER
	invocation = "Sanguis restora"

	base_healing = 30
	wound_modifier = 0.5
	blood_restoration = BLOOD_VOLUME_SURVIVE / 2
	required_level = 7
