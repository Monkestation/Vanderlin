/obj/projectile/magic
	name = "bolt of nothing"
	icon_state = "energy"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	armor_penetration = 100
	pass_flags = PASSTABLE | PASSGRILLE
	flag = "magic"
	/// determines what type of antimagic can block the spell projectile
	var/antimagic_flags = MAGIC_RESISTANCE
	/// determines the drain cost on the antimagic item
	var/antimagic_charge_cost = 1

/obj/projectile/magic/prehit_pierce(mob/living/target)
	. = ..()
	if(istype(target) && target.can_block_magic(antimagic_flags, antimagic_charge_cost))
		visible_message(span_warning("[src] fizzles on contact with [target]!"))
		return PROJECTILE_DELETE_WITHOUT_HITTING

/obj/projectile/magic/death
	name = "bolt of death"
	icon_state = "pulse1_bl"

/obj/projectile/magic/death/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(isliving(M))
			var/mob/living/L = M
			if(L.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
				if(L.hellbound && L.stat == DEAD)
					return BULLET_ACT_BLOCK
				if(L.revive(full_heal = TRUE, admin_revive = TRUE))
					L.grab_ghost(force = TRUE) // even suicides
					to_chat(L, "<span class='notice'>I rise with a start, I'm undead!!!</span>")
				else if(L.stat != DEAD)
					to_chat(L, "<span class='notice'>I feel great!</span>")
			else
				L.death(0)
		else
			M.death(0)

/obj/projectile/magic/resurrection
	name = "bolt of resurrection"
	icon_state = "ion"
	damage = 0
	damage_type = OXY
	nodamage = TRUE

/obj/projectile/magic/resurrection/on_hit(mob/living/carbon/target)
	. = ..()
	if(isliving(target))
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			target.death(0)
		else
			if(target.hellbound && target.stat == DEAD)
				return BULLET_ACT_BLOCK
			if(target.revive(full_heal = TRUE, admin_revive = TRUE))
				target.grab_ghost(force = TRUE) // even suicides
				to_chat(target, "<span class='notice'>I rise with a start, you're alive!!!</span>")
			else if(target.stat != DEAD)
				to_chat(target, "<span class='notice'>I feel great!</span>")

/obj/projectile/magic/teleport
	name = "bolt of teleportation"
	icon_state = "bluespace"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	var/inner_tele_radius = 0
	var/outer_tele_radius = 6

/obj/projectile/magic/teleport/on_hit(mob/target)
	. = ..()
	var/teleammount = 0
	var/teleloc = target
	if(!isturf(target))
		teleloc = target.loc
	for(var/atom/movable/stuff in teleloc)
		if(!stuff.anchored && stuff.loc && !isobserver(stuff))
			if(do_teleport(stuff, stuff, 10, channel = TELEPORT_CHANNEL_MAGIC))
				teleammount++
				var/datum/effect_system/smoke_spread/smoke = new
				smoke.set_up(max(round(4 - teleammount),0), stuff.loc) //Smoke drops off if a lot of stuff is moved for the sake of sanity
				smoke.start()

/obj/projectile/magic/safety
	name = "bolt of safety"
	icon_state = "bluespace"
	damage = 0
	damage_type = OXY
	nodamage = TRUE

/obj/projectile/magic/safety/on_hit(atom/target)
	. = ..()
	if(isturf(target))
		return BULLET_ACT_HIT

	var/turf/origin_turf = get_turf(target)
	var/turf/destination_turf = find_safe_turf()

	if(do_teleport(target, destination_turf, channel=TELEPORT_CHANNEL_MAGIC))
		for(var/t in list(origin_turf, destination_turf))
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(0, t)
			smoke.start()

/obj/projectile/magic/spellblade
	name = "blade energy"
	icon_state = "lavastaff"
	damage = 15
	damage_type = BURN
	flag = "magic"
	dismemberment = 50
	nodamage = FALSE

/obj/projectile/magic/arcane_barrage
	name = "arcane bolt"
	icon_state = "arcane_barrage"
	damage = 20
	damage_type = BURN
	nodamage = FALSE
	armor_penetration = 0
	flag = "magic"
	hitsound = 'sound/blank.ogg'

/obj/projectile/magic/flying
	name = "bolt of flying"
	icon_state = "flight"

/obj/projectile/magic/flying/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		var/atom/throw_target = get_edge_target_turf(L, angle2dir(Angle))
		L.throw_at(throw_target, 200, 4)

/obj/projectile/magic/bounty
	name = "bolt of bounty"
	icon_state = "bounty"

/obj/projectile/magic/bounty/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(STATUS_EFFECT_BOUNTY, null, firer)

/obj/projectile/magic/antimagic
	name = "bolt of antimagic"
	icon_state = "antimagic"

/obj/projectile/magic/antimagic/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(STATUS_EFFECT_ANTIMAGIC)

/obj/projectile/magic/fetch
	name = "bolt of fetching"
	icon_state = "cursehand0"
	range = 15

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	var/atom/throw_target = get_step(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		L.throw_at(throw_target, 200, 3) //4 is the default threshold speed to embed
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_turf(firer)
			I.throw_at(throw_target, 200, 3)

/obj/projectile/magic/sapping
	name = "bolt of sapping"
	icon_state = "sapping"

/obj/projectile/magic/sapping/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.add_stress(/datum/stress_event/sapped)

/obj/projectile/magic/necropotence
	name = "bolt of necropotence"
	icon_state = "necropotence"

/obj/projectile/magic/necropotence/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		to_chat(L, "<span class='danger'>My body feels drained and there is a burning pain in my chest.</span>")
		L.setMaxHealth(L.maxHealth - 20)
		L.set_health(L.health)
		if(L.getMaxHealth() <= 0)
			to_chat(L, "<span class='danger'>My weakened soul is completely consumed by the [src]!</span>")
			L.mind.hasSoul = FALSE
		for(var/datum/action/cooldown/spell/spell in L.actions)
			spell.StartCooldown()

/obj/projectile/magic/aoe
	name = "Area Bolt"
	desc = ""
	damage = 0
	var/aoe_range = 0
	var/proxdet = TRUE

/obj/projectile/magic/aoe/Range()
	if(proxdet)
		for(var/mob/living/L in range(aoe_range, get_turf(src)))
			if(L.stat != DEAD && L != firer && !L.can_block_magic(MAGIC_RESISTANCE))
				return Bump(L)
	..()


/obj/projectile/magic/aoe/fireball
	name = "bolt of fireball"
	icon_state = "fireball"
	damage = 10
	damage_type = BRUTE
	nodamage = FALSE
	light_color = "#f8af07"
	light_outer_range =  2

	//explosion values
	var/exp_devi = -1
	var/exp_heavy = 0
	var/exp_light = 2
	var/exp_flash = 3
	var/exp_fire = 2
	var/exp_hotspot = 0
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/projectile/magic/aoe/fireball/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.adjust_fire_stacks(6)
		M.IgniteMob()

	var/turf/T
	if(isturf(target))
		if(isclosedturf(target))
			var/hitdevi = 0
			var/hitheavy = 0
			var/hitlight = 0
			if(exp_devi > 0)
				hitdevi = 1
			if(exp_heavy > 0)
				hitheavy = 1
			if(exp_light > 0)
				hitlight = 1
			explosion(get_turf(target), hitdevi, hitheavy, hitlight, 0, 0, 0, visfx = "firespark", soundin = null)
			var/datum/point/vector/previous = trajectory.return_vector_after_increments(1,-1)
			T = previous.return_turf()
			explosion(T, exp_devi, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, hotspot_range = exp_hotspot, soundin = explode_sound)
			return TRUE
		else
			T = target
	else
		T = get_turf(target)
	explosion(T, 0, 0, 0, exp_flash, 0, flame_range = exp_fire, hotspot_range = exp_hotspot, soundin = explode_sound)
	cell_explosion(T, exp_light * 5, 0.1)
