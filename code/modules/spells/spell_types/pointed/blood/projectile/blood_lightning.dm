/datum/action/cooldown/spell/projectile/blood_bolt
	name = "Blood Bolt"
	desc = "Launch a bolt of blood infused with lightning."
	button_icon_state = "bloodlightning"
	sound = 'sound/magic/vlightning.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	cast_range = 8
	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_DESTRUCTION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation = "Blood Bolt!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 30 SECONDS
	spell_cost = 150
	spell_flags = SPELL_UNETCHABLE
	projectile_type = /obj/projectile/magic/bloodlightning

/datum/action/cooldown/spell/projectile/blood_bolt/arcyne
	name = "Arcyne Blood Bolt"
	desc = "A weaker mimicry of a darker spell, launch a bolt of blood infused with lightning."
	required_level = 4

	spell_type = SPELL_MANA
	required_form = FORM_WATER
	spell_flags = SPELL_RITUOS
	heretical_spell = FALSE
	projectile_type = /obj/projectile/magic/bloodlightning/lesser

/obj/projectile/magic/bloodlightning
	name = "blood bolt"
	tracer_type = /obj/effect/projectile/tracer/blood
	hitscan = TRUE
	movement_type = FLYING
	projectile_piercing = PROJECTILE_PIERCE_HIT
	damage = 60
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_outer_range =  7

/obj/projectile/magic/bloodlightning/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(1, src)

/obj/projectile/magic/bloodlightning/lesser
	damage = 35
