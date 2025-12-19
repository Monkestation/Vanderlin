/obj/structure/meatvineborder
	name = "meat clump"
	desc = "What is that?!"
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "border"

	anchored = TRUE
	flags_1 = ON_BORDER_1

	//armor = list(MELEE = 10, BULLET = 30, LASER = -10, ENERGY = 100, BOMB = -10, BIO = 100, FIRE = -200, ACID = -300)
	max_integrity = 10
	resistance_flags = CAN_BE_HIT

	/// Living mobs can lay down to go past
	var/pass_crawl = TRUE
	/// Projectiles can go past
	var/pass_projectile = TRUE
	/// Throwing atoms can go past
	var/pass_throwing = TRUE
	/// Throwing/Flying non mobs can always exit the turf regardless of other flags
	var/allow_flying_outwards = TRUE

/obj/structure/meatvineborder/CanPass(atom/movable/mover, turf/target, height=0)
	. = ..()
	if(get_dir(loc, target) != dir)
		return TRUE
	if(pass_crawl && isliving(mover))
		var/mob/living/M = mover
		if(M.body_position == LYING_DOWN)
			return TRUE
	if(mover.movement_type & (FLOATING|FLYING))
		if(istype(mover, /obj/projectile) && !pass_projectile)
			return FALSE
		return TRUE
	if(pass_throwing && mover.throwing)
		return TRUE

/obj/structure/meatvineborder/CanAStarPass(ID, to_dir, requester)
	if(dir in CORNERDIRS)
		return TRUE
	if(ismovable(requester))
		var/atom/movable/mover = requester
		if(mover.movement_type & (FLOATING|FLYING))
			return TRUE
	if(to_dir == dir)
		return FALSE
	return TRUE
