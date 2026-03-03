/datum/action/cooldown/spell/instill_perfection
	name = "Instill Perfection"
	desc = "Grants target a super-natural beauty for a time, increasing their mood."
	button_icon_state = "perfume"
	sound = 'sound/magic/churn.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/eora)

	invocation = "Eora, lend some of your divine beauty!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 20

/datum/action/cooldown/spell/instill_perfection/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/instill_perfection/cast(mob/living/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/buff/divine_beauty)
	cast_on.wash(CLEAN_WASH)
	cast_on.AddComponent(/datum/component/temporary_pollution_emission, pick(subtypesof(/datum/pollutant/fragrance)), 1, 2 MINUTES)
	if(ishuman(cast_on))
		var/mob/living/carbon/human/stinky_boy = cast_on
		stinky_boy.set_hygiene(HYGIENE_LEVEL_CLEAN)
