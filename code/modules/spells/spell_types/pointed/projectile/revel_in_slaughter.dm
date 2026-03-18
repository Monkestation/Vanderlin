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
	range = 2 //Low range, used only in combat

/obj/projectile/magic/revel_in_slaughter/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!iscarbon(hit_atom))
		return
	stagger(hit_atom)

/obj/projectile/magic/revel_in_slaughter/proc/stagger(mob/living/carbon/C)
	visible_message("<span class='danger'>\The [src] staggers [C] using boiling blood!</span>")
	to_chat(C, "<span class='danger'>\The [src] staggers you!</span>")
	C.spawn_gibs()
	C.apply_status_effect(/datum/status_effect/debuff/exposed)
	C.apply_status_effect(/datum/status_effect/eye_blur, 20)
	C.apply_status_effect(/datum/status_effect/incapacitating/immobilized, 3)

	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

