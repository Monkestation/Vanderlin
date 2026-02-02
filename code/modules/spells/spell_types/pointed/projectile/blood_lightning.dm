/datum/action/cooldown/spell/projectile/blood_bolt
	name = "Blood Bolt"
	desc = "Launch a bolt of blood infused with lightning."
	button_icon_state = "bloodlightning"
	sound = 'sound/magic/vlightning.ogg'

	cast_range = 8
	point_cost = 6
	associated_skill = /datum/skill/magic/blood
	attunements = list(
		/datum/attunement/electric = 0.3,
		/datum/attunement/blood = 0.7,
	)

	invocation = "Blood Bolt!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 30 SECONDS
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/bloodlightning

/obj/projectile/magic/bloodlightning
	name = "blood bolt"
	tracer_type = /obj/effect/projectile/tracer/blood
	hitscan = TRUE
	movement_type = FLYING
	projectile_piercing = PROJECTILE_PIERCE_HIT
	damage = 35
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	light_color = "#802121"
	light_outer_range =  7

/obj/projectile/magic/bloodlightning/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(1, src)
