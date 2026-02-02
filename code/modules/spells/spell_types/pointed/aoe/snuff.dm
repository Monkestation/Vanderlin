/datum/action/cooldown/spell/aoe/snuff
	name = "Snuff"
	desc = "Snuff the light around you"
	button_icon_state = "light"
	sound = 'sound/magic/soulsteal.ogg'
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "O'veta tela" // incantation in zizo chant
	invocation_type = INVOCATION_WHISPER
	charge_required = FALSE
	cooldown_time = 1 MINUTES
	spell_cost = 20
	aoe_radius = 2

/datum/action/cooldown/spell/aoe/snuff/is_valid_target(atom/cast_on)
	return isobj(cast_on) || ismob(cast_on)

/datum/action/cooldown/spell/aoe/snuff/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	aoe_radius = initial(aoe_radius) + owner.get_skill_level(associated_skill)

/datum/action/cooldown/spell/aoe/snuff/cast_on_thing_in_aoe(atom/victim, atom/caster)
	if(isobj(victim))
		var/obj/O = victim
		O.extinguish()
	else if(ismob(victim))
		var/mob/living/carbon/M = victim
		M.ExtinguishMob()
