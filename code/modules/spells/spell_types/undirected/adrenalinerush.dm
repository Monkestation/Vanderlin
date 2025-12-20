/datum/action/cooldown/spell/undirected/adrenalinerush
	name = "Adrenaline Rush"
	desc = "Unknown reagents coarse through your heart, granting you speed and stamina at the cost of your health."
	button_icon_state = "bloodrage"
	sound = 'sound/magic/machineinject.ogg'

	antimagic_flags = NONE

	associated_skill = /datum/skill/combat/unarmed
	associated_stat = STATKEY_SPD

	charge_required = FALSE
	has_visual_effects = FALSE
	cooldown_time = 3 MINUTES
	spell_type = SPELL_STAMINA

/datum/action/cooldown/spell/undirected/adrenalinerush/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(owner)

/datum/action/cooldown/spell/undirected/adrenalinerush/cast(mob/living/cast_on)
	. = ..()
	cast_on.emote("laugh", forced = TRUE)
	cast_on.adjustBruteLoss(20) //Till I can figure out how the hell to add Berrypoison to this, they're taking straight brute.
	cast_on.apply_status_effect(/datum/status_effect/buff/adrenalinerush)
	// L.reagents.add_reagent(/datum/reagent/berrypoison, 5) // GOD I need to figure out how to add this.
