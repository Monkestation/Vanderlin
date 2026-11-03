/datum/action/cooldown/spell/projectile/blood_dagger
	name = "Blood Sting"
	desc = "Fire off a piercing bloodsteel-dagger, a sharp sting at your fingertips!"
	button_icon_state = "moondagger"

	sound = 'sound/combat/Ranged/blowgun_shot.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	spell_type = SPELL_BLOOD
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_CREATION

	associated_skill = /datum/attribute/skill/magic/blood

	invocation = "Sanguis Aculeus!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 30 SECONDS
	spell_cost = 35

	projectile_type = /obj/projectile/magic/blood_dagger

/obj/projectile/magic/blood_dagger
	name = "bloodsteel dagger"
	icon_state = "corruptdagger_proj"
	nodamage = FALSE
	damage_type = BRUTE
	damage = DAMAGE_DAGGER + 15
	range = 7
