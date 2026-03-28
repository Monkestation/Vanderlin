/datum/action/cooldown/spell/projectile/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "Stagger your enemy through throwing a blood orb into their eyes, blurring their view and exposing them to your attacks. Finish them off for GRAGGAR!!"
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/antimagic.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	attunements = list(
		/datum/attunement/blood = 0.5,
	)
	projectile_type = /obj/projectile/magic/revel_in_slaughter
	charge_time = 1 SECONDS
	charge_drain = 1
	cooldown_time = 20 SECONDS
	spell_cost = 40


/obj/projectile/magic/revel_in_slaughter
	name = "blood orb"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 3 //Low range, used only in combat

/obj/projectile/magic/revel_in_slaughter/on_hit(atom/hit_atom)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!isliving(hit_atom))
		return
	var/mob/living/target = hit_atom
	target.visible_message(
		span_danger("[target] is struck by boiling blood!"),
		span_userdanger("I'm struck by boiling blood!"),
	)
	target.spawn_gibs()
	target.apply_status_effect(/datum/status_effect/debuff/exposed, 8 SECONDS)
	target.apply_status_effect(/datum/status_effect/eye_blur, 5 SECONDS)
	target.apply_status_effect(/datum/status_effect/incapacitating/immobilized, 2 SECONDS)

	playsound(target, 'sound/combat/caught.ogg', 50, TRUE)

