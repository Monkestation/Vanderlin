/datum/unit_test/projectile_movetypes/Run()
	for(var/obj/projectile/projectile as anything in typesof(/obj/projectile))
		if(initial(projectile.movement_type) & PHASING)
			TEST_FAIL("[projectile] has default movement type PHASING. Piercing projectiles should be done using the projectile piercing system, not movement_types!")
