GLOBAL_LIST_EMPTY(biggates)

/obj/structure/gate
	name = "gate"
	desc = "A strong steel gate."
	icon = 'icons/roguetown/misc/gate.dmi'
	icon_state = "gate1"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 5000
	bound_width = 96
	appearance_flags = NONE
	opacity = TRUE
	var/base_state = "gate"
	var/isSwitchingStates = FALSE
	var/list/turfsy = list()
	var/list/blockers = list()
	var/gid
	attacked_sound = list('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg')
	var/obj/structure/attached_to
	/// this is dumb but I'm not refactoring this right meow.
	var/is_big_gate = TRUE
	/// which bodyparts we affect when crushing a carbon mob.
	var/static/list/bodyparts_to_crush = list(
			BODY_ZONE_HEAD,
			BODY_ZONE_CHEST,
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_ARM,
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG,
		)

/obj/structure/gate/preopen
	icon_state = "gate0"

/obj/structure/gate/preopen/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/structure/gate/bars
	icon_state = "bar1"
	base_state = "bar"
	opacity = FALSE
	pass_flags_self = PASSGRILLE|LETPASSTHROW|PASSSTRUCTURE|NOTLETPASSTHROWNMOB

/obj/structure/gate/bars/preopen
	icon_state = "bar0"

/obj/structure/gate/bars/preopen/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/gblock
	name = ""
	desc = ""
	icon = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/gblock/not_opaque
	opacity = FALSE

/obj/structure/gate/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON)
	var/turf/current_turf = loc
	var/blocker_ref
	var/blocker

	if(!opacity)
		blocker_ref = /obj/gblock/not_opaque
	else
		blocker_ref = /obj/gblock
	blocker = new blocker_ref(current_turf)
	turfsy += current_turf
	blockers += blocker
	current_turf = get_step(current_turf, EAST)
	blocker = new blocker_ref(current_turf)
	turfsy += current_turf
	blockers += blocker
	current_turf = get_step(current_turf, EAST)
	blocker = new blocker_ref(current_turf)
	turfsy += current_turf
	blockers += blocker
	if(is_big_gate)
		GLOB.biggates += src

/obj/structure/gate/Destroy()
	if(is_big_gate)
		GLOB.biggates -= src
	for(var/A as anything in blockers)
		QDEL_NULL(A)
	blockers.Cut()
	turfsy.Cut()
	return ..()

/obj/structure/gate/update_icon_state()
	. = ..()
	icon_state = "[base_state][density]"

/obj/structure/gate/update_overlays()
	. = ..()
	if(isSwitchingStates)
		return
	. += mutable_appearance(icon, "[base_state][density]_part", ABOVE_MOB_LAYER)

/obj/structure/gate/redstone_triggered(mob/user)
	if(!isSwitchingStates)
		toggle()

/obj/structure/gate/proc/toggle()
	if(density)
		open()
	else
		close()

/obj/structure/gate/proc/open()
	if(isSwitchingStates || !density)
		return
	isSwitchingStates = TRUE
	playsound(src, 'sound/misc/gate.ogg', 100, extrarange = 5)
	flick("[base_state]_opening",src)
	layer = initial(layer)
	addtimer(CALLBACK(src, PROC_REF(finish_open)), 1.5 SECONDS)

/obj/structure/gate/proc/finish_open()
	density = FALSE
	set_opacity(FALSE)
	for(var/obj/gblock/B in blockers)
		B.set_opacity(FALSE)
	isSwitchingStates = FALSE
	update_appearance(UPDATE_ICON)

/obj/structure/gate/proc/close()
	if(isSwitchingStates || density)
		return
	isSwitchingStates = TRUE
	update_appearance(UPDATE_ICON)
	layer = ABOVE_MOB_LAYER
	playsound(src, 'sound/misc/gate.ogg', 100, extrarange = 5)
	flick("[base_state]_closing",src)
	addtimer(CALLBACK(src, PROC_REF(finish_close)), 1 SECONDS)

/obj/structure/gate/proc/finish_close()
	for(var/turf/T in turfsy)
		for(var/mob/living/M in T)
			M.log_message("has been crushed by the [src]!", LOG_ATTACK)
			crush(M)
	density = initial(density)
	set_opacity(initial(opacity))
	layer = initial(layer)
	for(var/obj/gblock/B in blockers)
		B.set_opacity(initial(B.opacity))
	isSwitchingStates = FALSE
	update_appearance(UPDATE_ICON)

/obj/structure/gate/proc/crush(mob/living/crushed_mob)
	crushed_mob.gib()

/obj/structure/gate/bars/crush(mob/living/crushed_mob)
	if(iscarbon(crushed_mob))
		var/mob/living/carbon/crushed_carbon = crushed_mob
		for(var/limb_index in bodyparts_to_crush)
			var/obj/item/bodypart/limb_to_crush = crushed_carbon.get_bodypart(limb_index)
			if(limb_to_crush)
				var/random_number = rand(50, 120)
				if(crushed_carbon.apply_damage(random_number, BRUTE, limb_to_crush, crushed_carbon.run_armor_check(limb_to_crush, BCLASS_STAB)))
					limb_to_crush.try_crit(BCLASS_STAB, random_number/7.5)
		crushed_carbon.update_damage_overlays()
		return
	crushed_mob.gib()

/obj/structure/winch
	name = "winch"
	desc = "A Gatekeeper's only, and most important responsibility."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "winch"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	COOLDOWN_DECLARE(winch_cooldown)

/obj/structure/winch/attack_hand(mob/user)
	. = ..()
	if(!redstone_attached)
		to_chat(user, span_warning("The chain is not attached to anything."))
		return
	if(!isliving(user))
		return
	if(!COOLDOWN_FINISHED(src, winch_cooldown))
		return
	var/mob/living/L = user
	L.changeNext_move(CLICK_CD_MELEE)
	var/used_time = 10.5 SECONDS - (GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH) * 10)
	if(!do_after(user, used_time))
		return
	COOLDOWN_START(src, winch_cooldown, 1.5 SECONDS)
	for(var/obj/structure/structure in redstone_attached)
		INVOKE_ASYNC(structure, PROC_REF(redstone_triggered), user)
	trigger_wire_network(user)
	user.visible_message(span_warning("[user] cranks [src]."), span_warning("I crank [src]."))
	playsound(src, 'sound/foley/winch.ogg', 100, extrarange = 3)
