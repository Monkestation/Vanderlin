/obj/structure/trap
	name = "IT'S A TRAP"
	desc = ""
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_plate"
	density = FALSE
	anchored = TRUE
	alpha = 80
	//shhh
	no_over_text = TRUE
	///What to say when antimagic'd
	var/flare_message
	///What to say when found
	var/found_message
	var/last_trigger = 0
	var/time_between_triggers = 1 MINUTES
	///-1==infinite, otherwise deletes at 0
	var/charges = -1
	var/checks_antimagic = TRUE
	///How difficult is this trap to see in active perception?
	///see on_active_perception
	var/perception_dc = 6

	var/static/list/ignore_typecache
	var/list/mob/immune_minds = list()

	var/sparks = TRUE
	var/datum/effect_system/spark_spread/spark_system

/obj/structure/trap/Initialize(mapload)
	. = ..()
	if(isnull(flare_message))
		flare_message = span_warning("\The [src] fizzles!")
	if(isnull(found_message))
		found_message = span_warning("\The [src] is revealed!")
	spark_system = new
	spark_system.set_up(4,1,src)
	spark_system.attach(src)

	if(isnull(ignore_typecache))
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead))
	RegisterSignal(SSdcs,COMSIG_MOB_ACTIVE_PERCEPTION,PROC_REF(on_active_perception))

/obj/structure/trap/Destroy()
	qdel(spark_system)
	spark_system = null
	UnregisterSignal(SSdcs,COMSIG_MOB_ACTIVE_PERCEPTION)
	. = ..()

/obj/structure/trap/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/luser = user
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= FLOOR((luser.STAPER-4)/4,1))
		to_chat(user,span_notice("I reveal and temporarily disarm \the [src]"))
		flare()

/obj/structure/trap/proc/on_active_perception(datum/controller/subsystem/processing/dcs/unused,mob/living/percepter)
	SIGNAL_HANDLER
	if(!(percepter in view(FLOOR(percepter.STAPER/3,1),src)))
		return
	//10% chance to see over DC
	if(percepter.stat_roll(STATKEY_PER,10,perception_dc))
		alpha = 200
		found_ping(get_turf(src),percepter.client,"trap")
		animate(src, alpha = initial(alpha), time = 4.5 SECONDS)

///Make trap vizible and disarmed for a cooldown time, but dont take charge.
/obj/structure/trap/proc/flare(fizzle = FALSE)
	if(fizzle)
		visible_message(flare_message)
	else
		visible_message(found_message)
	if(sparks)
		spark_system.start()
	no_over_text = FALSE
	alpha = 200
	last_trigger = world.time
	animate(src, alpha = initial(alpha), time = time_between_triggers)
	addtimer(CALLBACK(src, PROC_REF(unflare)), time_between_triggers, (TIMER_UNIQUE|TIMER_CLIENT_TIME))

/obj/structure/trap/proc/unflare()
	no_over_text = TRUE

/obj/structure/trap/Crossed(atom/movable/AM)
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(isliving(AM))
		if(trap_check(AM))
			trigger_step_on(AM)
			return

/obj/structure/trap/Uncrossed(atom/movable/AM)
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(isliving(AM))
		if(trap_check(AM))
			trigger_step_off(AM)
			return

///Knocks off charge, deletes it if it runs out
/obj/structure/trap/proc/lose_charge()
	if(charges < 0)
		return
	if(charges > 0)
		charges--
	if(charges == 0)
		animate(src, alpha = 0, time = 5)
		QDEL_IN(src, 5)
	return
///Common checks to make sure we can trigger the trap.
/// True == Yep we good.
/obj/structure/trap/proc/trap_check(mob/living/victim)
	if(istype(get_area(loc), /area/overlord_lair) && ("overlord" in victim.faction))
		return FALSE
	if(last_trigger + time_between_triggers > world.time)
		return FALSE
	if(victim.controller_mind)
		return FALSE
	if(HAS_TRAIT(victim,TRAIT_LIGHT_STEP))
		return FALSE
	if(victim.mind in immune_minds)
		return FALSE
	if(checks_antimagic && victim.can_block_magic(MAGIC_RESISTANCE))
		flare(TRUE)
		return FALSE
	return TRUE

///Utility to set the last trigger time,show trap, and deduct charges.
/obj/structure/trap/proc/post_triggered()
	lose_charge()
	flare()

///Called when someone steps OFF and we're ready, make sure to call post_triggered()
/obj/structure/trap/proc/trigger_step_off(mob/living/victim)
	playsound(src, 'sound/misc/pressurepad_up.ogg', 65, extrarange = 2)
	return

///Called when someone steps ON and we're ready, make sure to call post_triggered()
/obj/structure/trap/proc/trigger_step_on(mob/living/victim)
	to_chat(victim, span_info("I feel a 'click' beneath me..."))
	playsound(src, 'sound/misc/pressurepad_down.ogg', 65, extrarange = 2)
	return

/obj/structure/trap/shock
	name = "lightning plate trap"
	var/stun_time = 5 SECONDS

/obj/structure/trap/shock/trigger_step_on(mob/living/victim)
	..()
	victim.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	victim.Paralyze(stun_time)
	post_triggered()

/obj/structure/trap/fire
	name = "flamejet plate trap"

/obj/structure/trap/fire/trigger_step_on(mob/living/victim)
	..()
	to_chat(victim,span_danger("The ground suddenly erupts in flame!"))
	new /obj/effect/hotspot(get_turf(src))
	post_triggered()

/obj/structure/trap/chill
	name = "frost plate trap"

/obj/structure/trap/chill/trigger_step_on(mob/living/victim)
	..()
	to_chat(victim, span_danger("I am suddenly frozen solid!"))
	victim.apply_status_effect(/datum/status_effect/frost_trap)
	post_triggered()

/obj/structure/trap/spike
	name = "spike plate trap"

/obj/structure/trap/spike/trigger_step_on(mob/living/victim)
	..()
	to_chat(victim, span_danger("Spikes erupt from the ground, skewering me momentarily!"))
	victim.Paralyze(5 SECONDS)
	var/obj/item/bodypart/part = victim.get_bodypart(prob(50) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG)
	if(isnull(part))
		part = victim.get_bodypart(BODY_ZONE_CHEST)
	part?.receive_damage(30)
	part?.add_wound(/datum/wound/puncture)
	victim.emote("scream")
	post_triggered()

/obj/structure/trap/poison
	name = "poisonous plate trap"

/obj/structure/trap/poison/trigger_step_on(mob/living/victim)
	..()
	to_chat(victim,span_danger("I feel a slight prick from beneath me!"))
	victim.reagents?.add_reagent(/datum/reagent/berrypoison,2.5)
	post_triggered()

/obj/structure/trap/bomb
	name = "bomb plate trap"
	icon_state = "bomb_trap_plate"
	charges = 1

/obj/structure/trap/bomb/trigger_step_off(mob/living/victim)
	..()
	explosion(src, light_impact_range = 1, hotspot_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	post_triggered()

/obj/structure/trap/mine
	name = "mine plate trap"
	icon_state = "bomb_trap_plate"
	charges = 1

/obj/structure/trap/mine/trigger_step_off(mob/living/victim)
	..()
	explosion(src, heavy_impact_range = 2, light_impact_range = 3, flash_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	post_triggered()

/obj/structure/trap/saw_blades
	name = "saw plate trap"
	icon_state = "saw_trap_plate"
	charges = 1

/obj/structure/trap/saw_blades/trigger_step_off(mob/living/victim)
	..()
	var/obj/structure/sawblade_trap/saw = new(get_turf(src))
	saw.dir = dir
	visible_message(span_danger("\The [saw] suddenly erupts from underneath [src]!"))
	post_triggered()

/obj/structure/sawblade_trap
	name = "saw blade"
	desc = "A fast spinning saw blade, propelled by some unknown mechanism"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_saw"
	density = FALSE
	anchored = TRUE
	max_integrity = 100

/obj/structure/sawblade_trap/Crossed(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/victim = AM
		to_chat(victim,span_danger("\The [src] tears into me!"))
		var/obj/item/bodypart/part = victim.get_bodypart(prob(50) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG)
		if(isnull(part))
			part = victim.get_bodypart(BODY_ZONE_CHEST)
		part?.receive_damage(40)
		part?.add_wound(/datum/wound/slash/large)
		victim.emote("scream")

/obj/structure/trap/wall_projectile
	name = "arrow plate trap"
	icon_state = "arrow_trap_plate"
	var/turf/closed/home_wall
	///How far we look for a 'home' wall
	var/wall_range = 7
	///What're we shooting at the victim? Should be an /obj/projectile/
	var/fired = /obj/projectile/bullet/reusable/arrow/stone

/obj/structure/trap/wall_projectile/fireball
	name = "fireball plate trap"
	icon_state = "fireball_trap_plate"
	fired = /obj/projectile/magic/aoe/fireball/rogue

/obj/structure/trap/wall_projectile/Initialize(mapload)
	. = ..()
	for(var/step in 1 to wall_range)
		var/location = get_ranged_target_turf(src,dir,step)
		if(isclosedturf(location))
			home_wall = location
			break
	if(!home_wall)
		return INITIALIZE_HINT_QDEL

/obj/structure/trap/wall_projectile/trigger_step_on(mob/living/victim)
	..()
	if(!home_wall || !ispath(fired,/obj/projectile))
		return
	var/obj/projectile/suprise = new fired(get_step_towards2(home_wall,src))
	suprise.preparePixelProjectile(victim,home_wall)
	suprise.fire()
	to_chat(victim, span_danger("\The [suprise] erupts from a hidden slit in \the [home_wall]!"))
	post_triggered()

/obj/structure/trap/wall_projectile/Destroy()
	home_wall = null
	. = ..()
