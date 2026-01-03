///these mob spawn subtypes trigger immediately (New or Initialize) and are not player controlled... since they're dead, you know?
/obj/effect/mob_spawn/corpse
	abstract_type = /obj/effect/mob_spawn/corpse
	///when this mob spawn should auto trigger.
	var/spawn_when = CORPSE_INSTANT

	////damage values (very often, mappers want corpses to be mangled)

	///brute damage this corpse will spawn with
	var/brute_damage = 0
	///oxy damage this corpse will spawn with
	var/oxy_damage = 0
	///burn damage this corpse will spawn with
	var/burn_damage = 0

/obj/effect/mob_spawn/corpse/Initialize(mapload)
	. = ..()
	switch(spawn_when)
		if(CORPSE_INSTANT)
			INVOKE_ASYNC(src, PROC_REF(create))
		if(CORPSE_ROUNDSTART)
			if(mapload || (SSticker && SSticker.current_state > GAME_STATE_SETTING_UP))
				INVOKE_ASYNC(src, PROC_REF(create))

/obj/effect/mob_spawn/corpse/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.death(TRUE)
	spawned_mob.adjustOxyLoss(oxy_damage)
	spawned_mob.adjustBruteLoss(brute_damage)
	spawned_mob.adjustFireLoss(burn_damage)

/obj/effect/mob_spawn/corpse/create(mob/mob_possessor, newname)
	. = ..()
	qdel(src)
