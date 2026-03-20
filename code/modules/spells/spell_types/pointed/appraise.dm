/datum/action/cooldown/spell/appraise
	name = "Secular Appraise"
	desc = "Check how much someone has."
	button_icon_state = "appraise"
	has_visual_effects = FALSE
	cast_range = 2
	associated_skill = /datum/attribute/skill/misc/reading
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_cost = 0

/datum/action/cooldown/spell/appraise/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/appraise/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mammonsonperson = get_mammons_in_atom(cast_on)
	var/mammonsinbank = SStreasury.bank_accounts[cast_on]
	var/totalvalue = mammonsinbank + mammonsonperson
	to_chat(owner, (span_notice("[cast_on] has [mammonsonperson] mammons on them, [mammonsinbank] in their meister, for a total of [totalvalue] mammons.")))

/datum/action/cooldown/spell/appraise/holy
	name = "Appraise"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
