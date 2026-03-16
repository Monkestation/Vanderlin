// Defines for common attack types
/// Single turf only
#define SPECIAL_ATTACK_SINGLE (list(list(0, 0)))
/// First three turfs directly in front
#define SPECIAL_ATTACK_SWIPE (list(list(0, 0), list(1, 0), list(-1, 0)))
/// Two turfs in front
#define SPECIAL_ATTACK_POKE (list(list(0, 0), list(0, 1)))

/datum/special_intent/side_sweep
	name = "Distracting Swipe"
	desc = "Swing tall at your primary flank in a distracting fashion. \
		Anyone caught in it will be exposed for a short while. \
		However, those on the floor will not be struck."

	tile_coordinates = list(list(0, 0), list(1, 0), list(1, -1))	//L shape that hugs our -right- flank.

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/sidesweep_hit.ogg'

	stamina_cost = 25

	attack_delay = 0.6 SECONDS
	cooldown = 17 SECONDS

	/// Damage we deal
	var/damage = 20
	/// Users intent when we started the attack, instead of checking it when it happens
	var/target_zone

/datum/special_intent/side_sweep/pre_creation(mob/living/user, obj/item/parent, turf/target)
	if(user.used_hand == 1)	//We invert it if it's the left arm.
		tile_coordinates = list(list(0, 0), list(-1, 0), list(-1, -1))
	else
		tile_coordinates = list(list(0, 0), list(1, 0), list(1, -1))

	var/statmod = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH), GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED), GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION))	//It's a versatile weapon, so the scaling is versatile, too
	if(parent)
		damage = parent.force * (statmod / 10)

	target_zone = null
	if(user.zone_selected != BODY_ZONE_CHEST)
		if(check_zone(user.zone_selected) != user.zone_selected || GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION) < 11)
			if(prob(33))
				target_zone = user.zone_selected
		else
			target_zone = user.zone_selected

	if(!target_zone)
		target_zone = BODY_ZONE_CHEST

/datum/special_intent/side_sweep/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)
		apply_generic_weapon_damage(user, parent, victim, damage, SLASH, target_zone, BCLASS_CUT)

/datum/special_intent/shin_swipe
	name = "Shin Prod"
	desc = "A hasty attack at the legs, extending ourselves. \
		Slows down the opponent if hit. \
		However, those on the floor will not be struck"

	tile_coordinates = SPECIAL_ATTACK_SWIPE

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/shin_swipe.ogg'

	stamina_cost = 25

	attack_delay = 0.5 SECONDS
	cooldown = 20 SECONDS

	var/damage

/datum/special_intent/shin_swipe/pre_creation(mob/living/user, obj/item/parent, turf/target)
	damage = parent.force * max((1 + (((GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) - 10) + (GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION) - 10)) / 10)), 0.1)

/datum/special_intent/shin_swipe/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		victim.Slowdown(5)
		victim.apply_status_effect(/datum/status_effect/debuff/hobbled)
		apply_generic_weapon_damage(user, parent, victim, damage, STAB, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), BCLASS_CUT)

/datum/special_intent/piercing_lunge
	name = "Piercing Lunge"
	desc = "A planned attack at the chest, extending ourselves. \
		Pierces our enemy's armor and knocks the wind from them. \
		However, those on the floor will not be struck"

	tile_coordinates = SPECIAL_ATTACK_POKE

	pre_icon_state = "trap"
	post_icon_state = "stab"
	post_sound = 'sound/combat/parry/bladed/bladedsmall (3).ogg'

	stamina_cost = 20

	attack_delay = 0.5 SECONDS
	cooldown = 20 SECONDS

	var/damage

/datum/special_intent/piercing_lunge/pre_creation(mob/living/user, obj/item/parent, turf/target)
	damage = parent.force * max((1 + (((GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) - 10) + (GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION) - 10)) / 10)), 0.1)

/datum/special_intent/piercing_lunge/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		victim.adjust_stamina(30)
		apply_generic_weapon_damage(user, parent, victim, damage, STAB, BODY_ZONE_CHEST, BCLASS_STAB)

/datum/special_intent/ground_smash
	name = "Ground Smash"
	desc = "Swings downward, leaving a traveling quake for a few tiles. \
		Anyone struck by it will be slowed and offbalanced, or knocked down if they're already off-balanced."

	tile_coordinates = list(list(0, 0), list(0, 1, 0.1 SECONDS), list(0, 2, 0.2 SECONDS))

	pre_icon_state = "trap"
	pre_sound = 'sound/combat/ground_smash_start.ogg'
	post_icon_state = "kick_fx"
	post_sound = list('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg')

	stamina_cost = 30

	attack_delay = 0.7 SECONDS
	cooldown = 25 SECONDS

	immobilize_user = TRUE

/datum/special_intent/ground_smash/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue

		var/victim_dir = get_dir(victim, user)
		var/throw_dir = turn(victim_dir, pick(90, 270))
		var/turf/turf_target = get_ranged_target_turf(victim, throw_dir, rand(1, 3))
		victim.safe_throw_at(turf_target, rand(1, 3), 1, user, force = MOVE_FORCE_STRONG)

		victim.Slowdown(5)
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 2.5 SECONDS)

		if(victim.IsOffBalanced())
			victim.Knockdown(2 SECONDS)
		else
			victim.OffBalance(5 SECONDS)

		apply_generic_weapon_damage(user, parent, victim, parent.force * 2, BLUNT, BODY_ZONE_CHEST, BCLASS_BLUNT)

/datum/special_intent/flail_sweep
	name = "Flail Sweep"
	desc = "Swings in a perfect circle all around you, pushing people aside. \
		However, those on the floor will not be struck"

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/flail_sweep.ogg'

	stamina_cost = 30

	attack_delay = 0.7 SECONDS
	cooldown = 25 SECONDS

	immobilize_user = TRUE

/datum/special_intent/flail_sweep/build_affected_turfs(mob/living/user, turf/start_override)
	var/list/affected = list()

	for(var/turf/adjacent in orange(1, user))
		if(adjacent.is_blocked_turf(TRUE))
			continue
		LAZYADDASSOCLIST(affected, adjacent, 0)

	return affected

/datum/special_intent/flail_sweep/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		var/turf/throw_target = get_edge_target_turf(user, get_dir(user, get_step_away(victim, user)))
		victim.safe_throw_at(throw_target, rand(1, 2), 1, user, force = MOVE_FORCE_STRONG)
		victim.Immobilize(1 SECONDS)
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		apply_generic_weapon_damage(user, parent, victim, parent.force * 1.5, STAB, BODY_ZONE_CHEST, BCLASS_STAB)

#define GREAT_OUTER_DELAY 0.7 SECONDS

/datum/special_intent/greatsword_swing
	name = "Great Swing"
	desc = "Swing your greatsword all around you in a ring of Judgement."

	tile_coordinates = list(
		list(0, 0),
		list(1, 0),
		list(1, -1),
		list(1, -2),
		list(0, -2),
		list(-1, -2),
		list(-1, -1),
		list(-1, 0),
		list(0, 1, GREAT_OUTER_DELAY),
		list(1, 1, GREAT_OUTER_DELAY),
		list(-1, 1, GREAT_OUTER_DELAY),
		list(1, -3, GREAT_OUTER_DELAY),
		list(0, -3, GREAT_OUTER_DELAY),
		list(-1, -3, GREAT_OUTER_DELAY),
		list(-2, 0, GREAT_OUTER_DELAY),
		list(-2, -1, GREAT_OUTER_DELAY),
		list(-2, -2, GREAT_OUTER_DELAY),
		list(2, 0, GREAT_OUTER_DELAY),
		list(2, -1, GREAT_OUTER_DELAY),
		list(2, -2, GREAT_OUTER_DELAY),
	)

	pre_icon_state = "fx_trap_long"
	pre_sound = 'sound/combat/rend_hit.ogg'
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/wooshes/bladed/wooshlarge (3).ogg'

	stamina_cost = 35

	attack_delay = 0.7 SECONDS
	cooldown = 30 SECONDS

	immobilize_user = TRUE

/datum/special_intent/greatsword_swing/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		apply_generic_weapon_damage(user, parent, victim, parent.force * 1.5, SLASH, BODY_ZONE_CHEST, BCLASS_CUT)

#undef GREAT_OUTER_DELAY

#define AXE_SWING_GRID_DEFAULT 	list(list(-1,0), list(0,0, 0.2 SECONDS), list(1,0, 0.4 SECONDS))
#define AXE_SWING_GRID_MIRROR	list(list(-1,0, 0.4 SECONDS), list(0,0, 0.2 SECONDS), list(1,0))

/datum/special_intent/axe_swing
	name = "Hefty Swing"
	desc = "Swings from left to right. Anyone caught in the swing get immobilized and exposed."

	tile_coordinates = AXE_SWING_GRID_DEFAULT

	pre_icon_state = "trap"
	pre_sound = 'sound/combat/rend_start.ogg'
	post_icon_state = "sweep_fx"
	post_sound = list('sound/combat/sp_axe_swing1.ogg', 'sound/combat/sp_axe_swing2.ogg', 'sound/combat/sp_axe_swing3.ogg')

	stamina_cost = 20

	attack_delay = 0.5 SECONDS
	cooldown = 25 SECONDS

	immobilize_user = TRUE

	var/damage = 20

/datum/special_intent/axe_swing/pre_creation(mob/living/user, obj/item/parent, turf/target)
	damage = (parent.force * (GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH) / 10)) + 10

	if(user.used_hand == 1)	//We mirror it if it's the left arm.
		tile_coordinates += AXE_SWING_GRID_MIRROR
	else
		tile_coordinates += AXE_SWING_GRID_DEFAULT //Initial() doesn't work with lists so we copy paste the original

/datum/special_intent/axe_swing/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 6 SECONDS)
		victim.Immobilize(2.5 SECONDS)
		apply_generic_weapon_damage(user, parent, victim, damage, SLASH, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), BCLASS_CHOP)

#undef AXE_SWING_GRID_DEFAULT
#undef AXE_SWING_GRID_MIRROR

/datum/special_intent/backstep
	name = "Backstep"
	desc = "A defensive attack used to quickly gain distance, shoving back any pursuer backwards, slowing and exposing them."

	tile_coordinates = SPECIAL_ATTACK_SWIPE

	pre_icon_state = "fx_trap_long"
	pre_sound = 'sound/combat/polearm_woosh.ogg'
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/rend_hit.ogg'

	stamina_cost = 20

	attack_delay = 0.5 SECONDS
	cooldown = 15 SECONDS

	check_starting_loc = FALSE

	var/push_dir

/datum/special_intent/backstep/after_creation(mob/living/user, obj/item/parent, list/turfs)
	. = ..()

	var/turf/throw_target = get_edge_target_turf(user, get_dir(user, get_step_away(user, get_step(get_turf(user), user.dir))))
	push_dir = user.dir
	user.safe_throw_at(throw_target, 1, 1, user, force = MOVE_FORCE_EXTREMELY_STRONG)

	if(user.z != starting_loc.z)
		return FALSE // we got thrown off a cliff or something

	if(user.body_position != STANDING_UP)
		return FALSE // we got thrown at a wall and fell over :(

/datum/special_intent/backstep/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue

		victim.Slowdown(5)

		var/turf/throw_target = get_edge_target_turf(user, push_dir)
		victim.safe_throw_at(throw_target, 1, 1, user, force = MOVE_FORCE_EXTREMELY_STRONG)
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 4.5 SECONDS)

		apply_generic_weapon_damage(user, parent, victim, parent.force, BLUNT, BODY_ZONE_CHEST, BCLASS_BLUNT)

/datum/special_intent/upper_cut
	name = "Upper Cut"
	desc = "Charge up a devastating strike infront of you, if the target is Exposed they will fall over and be flung back with tremendous damage, if not exposed they will be pushed slightly back.."

	tile_coordinates = SPECIAL_ATTACK_SINGLE

	pre_icon_state = "trap"
	pre_sound = 'sound/combat/ground_smash_start.ogg'
	post_icon_state = "kick_fx"
	post_sound = 'sound/combat/hits/punch/punch_hard (2).ogg'

	stamina_cost = 20

	attack_delay = 0.5 SECONDS
	cooldown = 15 SECONDS

	var/damage = 30

/datum/special_intent/upper_cut/apply_hit(mob/living/user, obj/item/parent, turf/target)
	var/mob/living/victim = locate() in target // Only one
	if(!victim || victim == user)
		return

	var/turf/throw_target = get_edge_target_turf(user, get_dir(user, get_step_away(victim, user)))
	var/throw_dist = 1
	var/target_zone = BODY_ZONE_CHEST

	if(victim.has_status_effect(/datum/status_effect/debuff/exposed))
		victim.Knockdown(1 SECONDS)
		throw_dist = rand(2, 4)
		damage = 120
		target_zone = BODY_ZONE_HEAD

	victim.safe_throw_at(throw_target, throw_dist, 1, user, force = MOVE_FORCE_EXTREMELY_STRONG)
	apply_generic_weapon_damage(user, parent, target, damage, BLUNT, target_zone, BCLASS_BLUNT)

/datum/special_intent/whip_coil
	name = "Whip Coil"
	desc = "A long-range lash that coils around the ankles of the target, trying pulling them off their feet."

	tile_coordinates = SPECIAL_ATTACK_SINGLE

	pre_icon_state = "trap"
	pre_sound = 'sound/combat/sp_whip_start.ogg'
	post_icon_state = "strike"

	stamina_cost = 20

	attack_delay = 0.4 SECONDS
	cooldown = 15 SECONDS

	use_clickloc = TRUE
	range = 3

/datum/special_intent/whip_coil/apply_hit(mob/living/user, obj/item/parent, turf/target)
	var/mob/living/victim = locate() in target // Only one
	if(!victim || victim == user)
		playsound(target, 'sound/combat/sp_whip_whiff.ogg', 100, TRUE)
		return

	if(victim.body_position == STANDING_UP && victim.IsOffBalanced())
		victim.Knockdown(1 SECONDS)
	else
		victim.Immobilize(3 SECONDS)

	playsound(target, 'sound/combat/sp_whip_hit.ogg', 100, TRUE)

/datum/special_intent/triple_stab
	name = "Triple Stab"
	desc = "Stab for the chest three times in quick succession."

	tile_coordinates = list(list(0, 0), list(0, 0, 0.3 SECONDS), list(0, 0, 0.6 SECONDS))

	pre_icon_state = "trap"
	post_icon_state = "stab"

	stamina_cost = 30

	attack_delay = 0.4 SECONDS
	cooldown = 20 SECONDS

/datum/special_intent/triple_stab/apply_hit(mob/living/user, obj/item/parent, turf/target)
	var/mob/living/victim = locate() in target // Only one
	if(!victim || victim == user)
		return

	apply_generic_weapon_damage(user, parent, victim, parent.force * 0.6, STAB, BODY_ZONE_CHEST, BCLASS_STAB)

#undef SPECIAL_ATTACK_SINGLE
#undef SPECIAL_ATTACK_SWIPE
#undef SPECIAL_ATTACK_POKE
