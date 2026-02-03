/datum/action/cooldown/spell/projectile/blowingdust
	name = "Enrapturing Powder"
	desc = "Baotha's presence is always known, finding her blessings gathering on you like dust. With a good swipe, I could make others indulge in her fruits."
	button_icon_state = "curse2"
	sound = 'sound/magic/whiteflame.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation =  "Have a taste of the maiden's pure-bliss..."
	invocation_type = INVOCATION_WHISPER

	attunements = list(
		/datum/attunement/electric = 0.3,
		/datum/attunement/aeromancy = 0.3,
	)

	charge_time = 2 SECONDS
	cooldown_time = 10 SECONDS
	spell_cost = 30
	projectile_type = /obj/projectile/magic/blowingdust

/obj/projectile/magic/blowingdust //Slightly different from how the other one work..
	name = "unholy dust"
	icon_state = "spark"
	range = 3
	nondirectional_sprite = TRUE
	nodamage = FALSE
	damage = 1

/obj/projectile/magic/blowingdust/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		to_chat(L, span_warning("Gah! Something.. got in my - eyes.."))
		L.reagents.add_reagent(/datum/reagent/berrypoison, 5)
		L.apply_status_effect(/datum/status_effect/debuff/baothadruqks)
		L.set_eye_blur_if_lower(4 SECONDS)
