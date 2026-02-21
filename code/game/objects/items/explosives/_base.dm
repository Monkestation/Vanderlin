/obj/projectile/bullet/glass
	name = "glass shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "small"
	damage = 9
	damage_type = BRUTE
	woundclass = BCLASS_SHOT
	range = 30
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	speed = 1

/obj/item/explosive
	name = "pipe bomb"
	desc = "A bottle filled with an explosive concoction."
	icon_state = "bottle"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32

	///do we explode on impact?
	var/impact_explode = FALSE
	///odds we fail on ignite
	var/prob2fail = 0

	/// Bitfields which prevent the grenade from detonating if set. Includes ([GRENADE_DUD]|[GRENADE_USED])
	var/dud_flags = NONE
	///Were we made sticky?
	var/sticky = FALSE
	///how big of a devastation explosion radius on prime
	var/ex_dev = 0
	///how big of a heavy explosion radius on prime
	var/ex_heavy = 1
	///how big of a light explosion radius on prime
	var/ex_light = 2
	///how big of a flame explosion radius on prime
	var/ex_flame = 0
	///how big the hotspot range is
	var/ex_hotspot_range = 0
	///do we smoke?
	var/ex_smoke = FALSE

	///our ignite timer
	var/explode_timer

	///Is this grenade currently armed?
	var/active = FALSE
	///How long it takes for a grenade to explode after being armed
	var/det_time = 5 SECONDS
	//can this grenade currently be ignited by a spark?
	var/allow_spark = FALSE
	//how long it takes before it can be ignited by a spark
	var/spark_delay = 2.5 SECONDS

	var/turf_debris = /obj/item/natural/glass/shard

	// dealing with creating a [/datum/component/pellet_cloud] on detonate
	/// if set, will spew out projectiles of this type
	var/shrapnel_type = /obj/projectile/bullet/glass
	/// the higher this number, the more projectiles are created as shrapnel
	var/shrapnel_radius = 5
	///Did we add the component responsible for spawning sharpnel to this?
	var/shrapnel_initialized

/obj/item/explosive/Initialize()
	. = ..()
	addtimer(VARSET_CALLBACK(src, allow_spark, TRUE), spark_delay)

/**
 * Checks for various ways to botch priming a grenade.
 *
 * Arguments:
 * * mob/living/carbon/human/user - who is priming our grenade?
 */
/obj/item/explosive/proc/botch_check(mob/living/carbon/human/user)
	if(prob(prob2fail))
		return TRUE

	if(sticky && prob(50)) // to add risk to sticky tape grenade cheese, no return cause we still prime as normal after.
		to_chat(user, span_warning("What the... [src] is stuck to your hand!"))
		ADD_TRAIT(src, TRAIT_NODROP, "sticky")

/obj/item/explosive/attack_self(mob/user)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		to_chat(user, span_notice("You try prying [src] off your hand..."))
		if(do_after(user, 7 SECONDS, target = src))
			to_chat(user, span_notice("You manage to remove [src] from your hand."))
			REMOVE_TRAIT(src, TRAIT_NODROP, "sticky")
		return

/obj/item/explosive/fire_act(added, maxstacks)
	if (active)
		return
	if(usr)
		arm_grenade(usr)
	else
		arm_grenade(null)
	. = ..()

/obj/item/explosive/spark_act()
	if (!allow_spark)
		return
	if (active)
		return
	if(usr)
		arm_grenade(usr)
	else
		arm_grenade(null)
	. = ..()

/obj/item/explosive/extinguish()
	. = ..()
	if(!active)
		return
	if(explode_timer)
		deltimer(explode_timer)
		explode_timer = null
	icon_state = initial(icon_state)
	active = FALSE
	playsound(src, 'sound/items/firesnuff.ogg', 50)

/obj/item/explosive/proc/log_grenade(mob/user)
	log_bomber(user, "has primed a", src, "for detonation", message_admins = !dud_flags)


/**
 * arm_grenade (formerly preprime) refers to when a grenade with a standard time fuze is activated, making it go beepbeepbeep and then detonate a few seconds later.
 * Grenades with other triggers like remote igniters probably skip this step and go straight to [/obj/item/explosive/proc/detonate]
 */
/obj/item/explosive/proc/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	log_grenade(user) //Inbuilt admin procs already handle null users
	playsound(src, 'sound/items/fuse.ogg', 100)
	var/rand_time = rand(det_time * 0.5, det_time)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("You prime [src]! [capitalize(DisplayTimeText(rand_time))]!"))
	if(shrapnel_type && shrapnel_radius)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type = shrapnel_type, magnitude = shrapnel_radius)
	active = TRUE
	icon_state = initial(icon_state) + "_active"
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, rand_time, delayoverride)
	explode_timer = addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? rand_time : delayoverride, TIMER_STOPPABLE)


/**
 * detonate (formerly prime) refers to when the grenade actually delivers its payload (whether or not a boom/bang/detonation is involved)
 *
 * Arguments:
 * * lanced_by- If this grenade was detonated by an elance, we need to pass that along with the COMSIG_GRENADE_DETONATE signal for pellet clouds
 */
/obj/item/explosive/proc/detonate(mob/living/lanced_by)
	if(lanced_by)
		if(botch_check(lanced_by)) // if they botch the prime, it'll be handled in botch_check
			extinguish()
			visible_message(span_warning("The [src] fizzles out!"))
			return FALSE
	if (dud_flags)
		active = FALSE
		return FALSE

	if(shrapnel_type && shrapnel_radius && !shrapnel_initialized) // add a second check for adding the component in case whatever triggered the grenade went straight to prime (badminnery for example)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type = shrapnel_type, magnitude = shrapnel_radius)

	SEND_SIGNAL(src, COMSIG_GRENADE_DETONATE, lanced_by)
	if(ex_dev || ex_heavy || ex_light || ex_flame)
		explosion(src, ex_dev, ex_heavy, ex_light, flame_range = ex_flame, smoke = ex_smoke, hotspot_range = ex_hotspot_range, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	new turf_debris (get_turf(src))

	qdel(src)
	return TRUE

/obj/item/explosive/proc/update_mob()
	if(ismob(loc))
		var/mob/mob = loc
		mob.dropItemToGround(src)

/obj/item/explosive/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(impact_explode)
		if(active)
			detonate(throwingdatum.thrower)
		else
			new turf_debris (get_turf(src))
			qdel(src)
