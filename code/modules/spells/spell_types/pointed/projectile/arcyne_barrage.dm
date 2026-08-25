#define ARCYNE_BARRAGE_SLOWDOWN_ID "arcyne_barrage_channel"

/datum/action/cooldown/spell/projectile/arcyne_barrage
	button_icon = 'icons/mob/actions/spells/mage_telomancy.dmi'
	name = "Arcyne Barrage"
	desc = "Barrage a direction with pulses of piercing, ricocheting arcyne bolts for ten seconds. The bolts can pierce up to five targets. \
	You can walk while channeling but you are greatly slowed down and cannot change your direction. \
	Being stunned, knocked down, or grabbed will break the channeling."
	button_icon_state = "arcyne_barrage"
	sound = 'sound/magic/vlightning.ogg'

	click_to_activate = TRUE
	cast_range = 21

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_DESTRUCTION

	invocation_type = INVOCATION_NONE
	var/barrage_invocation = "Ultima Ratio Telum!"

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS
	spell_cost = 60

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/channel_duration = 10 SECONDS
	var/pulse_interval = 2 SECONDS
	var/bolts_per_pulse = 5
	var/pulse_spread = 120
	var/channel_slowdown = 3

/datum/action/cooldown/spell/projectile/arcyne_barrage/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/projectile/arcyne_barrage/fire_projectile(atom/target)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.say(barrage_invocation, forced = "spell", language = /datum/language/common)

	var/locked_angle = dir2angle(H.dir)
	var/end_time = world.time + channel_duration
	var/pulse_index = 0

	H.visible_message(span_danger("<b>[H] unleashes a storm of arcyne bolts!</b>"))
	playsound(get_turf(H), 'sound/magic/vlightning.ogg', 100, TRUE)
	H.add_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID, update = TRUE, priority = 100, multiplicative_slowdown = channel_slowdown, movetypes = GROUND)

	while(world.time < end_time)
		if(!channel_valid(H))
			end_channel(H, TRUE)
			return TRUE

		pulse_index++
		fire_pulse(H, locked_angle, pulse_index)

		new /obj/effect/temp_visual/spell_impact(get_turf(H), spell_color, spell_impact_intensity)
		sleep(pulse_interval)

	end_channel(H, FALSE)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/end_channel(mob/living/carbon/human/H, interrupted)
	if(H)
		H.remove_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID)
	if(interrupted)
		StartCooldown(cooldown_time)
		if(H)
			to_chat(H, span_warning("My barrage falters!"))
	else
		StartCooldown(cooldown_time)

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/channel_valid(mob/living/carbon/human/H)
	if(QDELETED(H))
		return FALSE
	if(H.stat != CONSCIOUS)
		return FALSE
	if(H.IsParalyzed() || H.IsStun() || H.IsKnockdown() || H.IsUnconscious())
		return FALSE
	if(H.pulledby)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_pulse(mob/living/carbon/human/H, locked_angle, pulse_index)
	var/arc_start = locked_angle - (pulse_spread / 2)
	var/step_size = bolts_per_pulse > 1 ? (pulse_spread / (bolts_per_pulse - 1)) : 0
	for(var/i in 1 to bolts_per_pulse)
		fire_barrage_bolt(H, arc_start + (step_size * (i - 1)))

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_barrage_bolt(mob/living/carbon/human/H, angle)
	var/obj/projectile/magic/arcyne_barrage_bolt/bolt = new(get_turf(H))
	bolt.firer = H
	bolt.fired_from = get_turf(H)
	bolt.def_zone = BODY_ZONE_CHEST
	bolt.spell_impact_intensity = SPELL_IMPACT_MEDIUM
	bolt.accuracy += (GET_MOB_ATTRIBUTE_VALUE(H, STAT_INTELLIGENCE) - 9) * 4
	bolt.bonus_accuracy += (GET_MOB_ATTRIBUTE_VALUE(H, STAT_INTELLIGENCE) - 8) * 3
	if(H.mind)
		bolt.bonus_accuracy += (GET_MOB_SKILL_VALUE(H, associated_skill) * 0.5)
	bolt.setAngle(angle)
	bolt.fire()

/obj/projectile/magic/arcyne_barrage_bolt
	name = "greater arcyne bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	damage = 15
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 30
	speed = 3
	accuracy = 60
	ricochets_max = 5
	ricochet_chance = 100
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	var/hits = 0
	var/max_hits = 5

/obj/projectile/magic/arcyne_barrage_bolt/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.can_block_magic())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
	if(!ismob(target))
		return
	hits++
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

#undef ARCYNE_BARRAGE_SLOWDOWN_ID
