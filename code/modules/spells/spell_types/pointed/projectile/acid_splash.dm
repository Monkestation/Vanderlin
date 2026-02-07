/datum/action/cooldown/spell/projectile/acid_splash
	name = "Acid Splash"
	desc = "A slow-moving glob of acid that sprays over an area upon impact."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1
	attunements = list(
		/datum/attunement/blood = 0.3,
		/datum/attunement/death = 0.4,
	)

	invocation = "HYDRO MURIATIC!!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 15 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/acidsplash

/datum/action/cooldown/spell/projectile/acid_splash/ready_projectile(obj/projectile/magic/acidsplash/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= attuned_strength
	to_fire.aoe_range *= attuned_strength
	to_fire.strength_modifier *= attuned_strength

/datum/action/cooldown/spell/projectile/acid_splash/quietus
	name = "Caustic Splash"

	projectile_type = /obj/projectile/magic/acidsplash/quietus

/datum/action/cooldown/spell/projectile/acid_splash/organ
	name = "Acid Spray"
	desc = "Vomit up acid against a foe, at great risk to yourself."
	sound = 'sound/vo/vomit.ogg'
	charge_sound = null

	invocation_type = INVOCATION_EMOTE
	invocation = span_userdanger("<b>%CASTER</b> belches acid!")
	invocation_self_message = span_danger("I spit acid!")
	spell_flags = NONE

	charge_time = 2 SECONDS
	cooldown_time = 1 MINUTES
	spell_type = SPELL_STAMINA

	has_visual_effects = FALSE

	/// Times cast without a failure
	var/sucessive_uses = 0

/datum/action/cooldown/spell/projectile/acid_splash/organ/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(prob(10 + (sucessive_uses * 5)))
		sucessive_uses = 0
		owner.visible_message(span_warning("[owner] chokes on their own acid!"), span_userdanger("I choke on acid! it burns!"))
		owner.emote("gags", forced = TRUE)
		owner.take_damage(15, TOX)
		if(isliving(owner))
			var/mob/living/living_owner = owner
			living_owner.take_overall_damage(burn = 10)
			living_owner.apply_status_effect(/datum/status_effect/debuff/acidsplash)
		StartCooldown()
		return . | SPELL_CANCEL_CAST

/obj/projectile/magic/acidsplash
	name = "acid bubble"
	icon_state = "acid_splash"
	damage = 10
	damage_type = BURN
	range = 15
	speed = 3
	var/aoe_range = 1
	var/strength_modifier = 1

/obj/projectile/magic/acidsplash/quietus
	damage = 80

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	aoe_range = round(aoe_range)
	var/turf/splashed = get_turf(target)
	for(var/turf/turf in RANGE_TURFS(aoe_range, splashed))
		if(turf.density)
			continue
		new /obj/effect/temp_visual/acidsplash5e(turf)
		for(var/mob/living/L in turf)
			if(!L.can_block_magic(MAGIC_RESISTANCE))
				L.apply_status_effect(/datum/status_effect/debuff/acidsplash, null, strength_modifier)

/datum/status_effect/debuff/acidsplash
	id = "acid splash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/acidsplash
	duration = 10 SECONDS
	var/damage_per_tick = 2

/datum/status_effect/debuff/acidsplash/New(atom/A, scaled_damage = 2)
	. = ..()
	damage_per_tick = scaled_damage

/datum/status_effect/debuff/acidsplash/tick()
	var/mob/living/target = owner
	target.adjustFireLoss(damage_per_tick)

/atom/movable/screen/alert/status_effect/debuff/acidsplash
	name = "Acid Burn"
	desc = "My skin is burning!"
	icon_state = "debuff"

/obj/effect/temp_visual/acidsplash5e
	icon = 'icons/effects/effects.dmi'
	icon_state = "acid_pop"
	randomdir = TRUE
	duration = 1 SECONDS
	layer = GAME_PLANE_UPPER
