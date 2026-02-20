GLOBAL_LIST_EMPTY(putrid_evolutions)

/obj/structure/meatvine/papameat
	name = "papa meat"
	desc = "You feel a combination of fear and disgust, just by looking at that thing."
	icon = 'icons/obj/cellular/papameat.dmi'
	icon_state = "papameat"
	density = TRUE
	pass_flags = PASSTABLE
	max_integrity = 1000
	pixel_x = -48
	pixel_y = -48
	var/healed = FALSE
	var/obj/effect/abstract/particle_holder/Particle

/obj/structure/meatvine/papameat/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)
	Particle = new(src, /particles/papameat)
	set_light(3, 3, 1, l_color = "#ff6533")

/obj/structure/meatvine/papameat/Destroy()
	if(master)
		master.papameat_destroyed(src)
	puff_gas(TRUE)
	STOP_PROCESSING(SSfastprocess, src)
	qdel(Particle)
	return ..()

/obj/structure/meatvine/papameat/proc/begin_evolution(mob/living/simple_animal/hostile/retaliate/meatvine/evolving_mob)
	to_chat(evolving_mob, span_boldnotice("You begin burrowing into the papa meat..."))

	if(!do_after(evolving_mob, 5 SECONDS, src))
		to_chat(evolving_mob, span_warning("The evolution process was interrupted!"))
		return FALSE

	// Show evolution selection screen
	if(evolving_mob.client)
		show_evolution_screen(evolving_mob)
	else
		var/path = pick(evolving_mob.possible_evolutions)
		var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = new path(get_turf(evolving_mob))
		mob.master = evolving_mob.master
		mob.generate_monitor()
		qdel(evolving_mob)

	return TRUE

/obj/structure/meatvine/papameat/proc/show_evolution_screen(mob/living/simple_animal/hostile/retaliate/meatvine/evolving_mob)
	evolving_mob.density = FALSE
	evolving_mob.alpha = 0
	ADD_TRAIT(evolving_mob, TRAIT_IMMOBILIZED, INNATE_TRAIT)

	var/mob/camera/evolution_picker/picker = new(get_turf(src))
	picker.evolving_mob = evolving_mob
	picker.papa_meat = src
	evolving_mob.client?.eye = picker
	picker.show_evolution_options()

/obj/structure/meatvine/papameat/attackby(obj/item/I, mob/user, params)
	if(!master)
		return ..()

	var/organic_value = 0
	if(istype(I, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/meat = I
		if(meat.foodtype & MEAT)
			organic_value = 10
	else if(istype(I, /obj/item/bodypart))
		organic_value = 50
	else if(istype(I, /mob/living))
		var/mob/living/L = I
		if(L.stat == DEAD)
			organic_value = 100
	else if(istype(I, /obj/item/organ))
		organic_value = 30

	if(organic_value > 0)
		to_chat(user, span_notice("The meatvine absorbs [I]!"))
		master.feed_organic_matter(organic_value)

		// Grant evolution progress to user if they're a meatvine mob
		if(istype(user, /mob/living/simple_animal/hostile/retaliate/meatvine))
			var/mob/living/simple_animal/hostile/retaliate/meatvine/vine_mob = user
			vine_mob.gain_evolution_progress(organic_value * 0.3)

		qdel(I)
		if(prob(30))
			spread()
		return TRUE
	return ..()

/obj/structure/meatvine/papameat/process()
	var/integrity_percent = round(get_integrity()/max_integrity)
	switch(integrity_percent)
		if(75)
			if(prob(10))
				transfer_feromones(2)
		if(50)
			if(prob(10))
				transfer_feromones(5)
			if(prob(1))
				var/mobtype = pick(/mob/living/simple_animal/hostile/retaliate/meatvine, /mob/living/simple_animal/hostile/retaliate/meatvine/range)
				new mobtype(loc)
			if(healed && (master.vines.len <= master.collapse_size) && master.reached_collapse_size)
				master.reached_collapse_size = FALSE
		if(25)
			if(prob(20))
				puff_gas(TRUE)
			if(healed && (master.vines.len >= master.slowdown_size) && master.reached_slowdown_size)
				master.reached_slowdown_size = FALSE
	if(!healed)
		if(!repair_damage(10))
			healed = TRUE

/obj/structure/meatvine/papameat/grow()
	return

/obj/structure/meatvine/papameat/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.)
		var/integrity_percent = atom_integrity / max_integrity
		SEND_GLOBAL_SIGNAL(COMSIG_PAPAMEAT_DAMAGED, src, integrity_percent)
		if(integrity_percent < PAPAMEAT_CRITICAL_HEALTH)
			SEND_GLOBAL_SIGNAL(COMSIG_PAPAMEAT_CRITICAL, src)

/obj/structure/meatvine/papameat/proc/consume_mob(mob/living/sacrifice)
	if(!istype(sacrifice) || sacrifice.stat != DEAD)
		return FALSE
	visible_message(span_danger("[src] absorbs [sacrifice]!"))
	var/heal_amount = 100
	if(ismob(sacrifice))
		var/mob/living/L = sacrifice
		heal_amount = max(50, L.maxHealth * 0.5)
	atom_integrity = min(atom_integrity + heal_amount, max_integrity)
	if(master)
		master.feed_organic_matter(100)
	if(sacrifice.client)
		master.consume_client_mob(sacrifice)
	qdel(sacrifice)
	return TRUE

/obj/structure/meatvine/papameat/proc/sacrifice_living_mob(mob/living/sacrifice)
	if(!istype(sacrifice) || sacrifice.stat == DEAD)
		return FALSE
	visible_message(span_danger("[sacrifice] throws itself into [src], being consumed alive!"))
	sacrifice.adjustBruteLoss(sacrifice.health + 10)
	return consume_mob(sacrifice)
