/obj/item/ammo_casing/proc/fire_casing(atom/target, mob/living/user, modifiers, distro, quiet, zone_override, spread, atom/fired_from)
	distro += variance
	for(var/i = max(1, pellets), i > 0, i--)
		var/targloc = get_turf(target)
		ready_proj(target, user, quiet, zone_override, fired_from)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round((i / pellets - 0.5) * distro)
		var/obj/projectile/thrown_proj = throw_proj(target, targloc, user, modifiers, spread, fired_from)
		if(isnull(thrown_proj))
			return FALSE
		if(i > 1)
			newshot()

	if(click_cooldown_override)
		user?.changeNext_move(click_cooldown_override)
	else
		user?.changeNext_move(CLICK_CD_RANGE)

	update_appearance()

	return TRUE

/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if(!loaded_projectile)
		return

	loaded_projectile.original = target
	loaded_projectile.firer = user
	loaded_projectile.fired_from = fired_from
	loaded_projectile.arcshot = user?.used_intent?.arc_check()

	if(loaded_projectile.arcshot)
		loaded_projectile.range = get_dist_euclidian(target, user)

	if(zone_override)
		loaded_projectile.def_zone = zone_override
	else
		loaded_projectile.def_zone = user.zone_selected

	if(isgun(fired_from))
		var/obj/item/gun/gun = fired_from
		gun.modify_projectile(user, target, loaded_projectile)

	loaded_projectile.suppressed = quiet

	if(reagents && loaded_projectile.reagents)
		reagents.trans_to(loaded_projectile, reagents.total_volume, transfered_by = user) //For chemical darts/bullets
		qdel(reagents)

/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, list/modifiers, spread, atom/fired_from)
	var/turf/curloc = get_turf(fired_from)
	if (!istype(targloc) || !istype(curloc) || !loaded_projectile)
		return null

	var/firing_dir
	if(loaded_projectile.firer)
		firing_dir = loaded_projectile.firer.dir

	if(!loaded_projectile.suppressed && firing_effect_type)
		new firing_effect_type(get_turf(src), firing_dir)

	var/direct_target
	if(targloc == curloc)
		if(target) //if the target is right on our location we'll skip the travelling code in the proj's fire()
			direct_target = target

	if(!direct_target)
		loaded_projectile.preparePixelProjectile(target, isnull(user) ? src : user, modifiers, spread)

	loaded_projectile.fire(null, direct_target)
	loaded_projectile = null

	return TRUE

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)
