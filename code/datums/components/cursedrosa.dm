
/datum/component/cursedrosa
	var/cross_trigger
	var/hand_trigger

/datum/component/cursedrosa/Initialize(cross_trigger=FALSE, hand_trigger=TRUE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.cross_trigger = cross_trigger
	src.hand_trigger = hand_trigger

/datum/component/cursedrosa/RegisterWithParent()
	if(cross_trigger)
		RegisterSignals(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_HITBY), PROC_REF(atom_crossed))
	if(hand_trigger)
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(attack_hand))

/datum/component/cursedrosa/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ATTACK_HAND))

/datum/component/cursedrosa/proc/attempt_infection(mob/living/carbon/target, def_zone)
	var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)
	if(!affecting || affecting.status != BODYPART_ORGANIC)
		return
	if(target.getarmor(def_zone, "stab", 0, simulate=TRUE) - rand(ARMOR_LEATHER_GOOD["stab"], ARMOR_MAILLE_GOOD["stab"] + 5) >= 0)
		return //we blocked it
	playsound(parent, 'sound/combat/hits/hi_arrow.ogg', 30, TRUE, -4)
	if(prob(60))
		return
	var/wound_type = get_black_briar_wound_type(def_zone)
	if(wound_type && !affecting.has_wound(wound_type))
		affecting.add_wound(wound_type, TRUE)

/datum/component/cursedrosa/proc/atom_crossed(source, mob/living/carbon/target)
	if(!istype(target))
		return
	if(target.movement_type & (FLYING|FLOATING) || target.throwing)
		return
	if(HAS_TRAIT(target, TRAIT_KNEESTINGER_IMMUNITY) || HAS_TRAIT(target, TRAIT_PIERCEIMMUNE))
		return
	var/potential_zones = list(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
	if(target.body_position == LYING_DOWN)
		potential_zones |= list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	attempt_infection(target, pick(potential_zones))

/datum/component/cursedrosa/proc/attack_hand(source, mob/living/carbon/target)
	if(!istype(target))
		return
	if(HAS_TRAIT(target, TRAIT_PIERCEIMMUNE))
		return
	var/def_zone = (target.active_hand_index == 1 ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND)
	attempt_infection(target, def_zone)
