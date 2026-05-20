//This is basically the baystation wound datum, which i thought would synergize well with the TG wounds
/****************************************************
				INJURY DATUM
****************************************************/
//Note that the MINIMUM damage before a injury can be applied should correspond to
//the damage amount for the stage with the same name as the injury.
//e.g. /datum/injury/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
/datum/injury
	/// Description of the injury - default in case something borks
	var/desc = "injury"
	/// Number representing the current stage
	var/current_stage = 0
	/// Amount of damage this injury is currently causing
	var/damage = 0
	/// How much we bleed on each tick per 40 damage
	var/bleed_rate = 1
	/// Ticks of bleeding left
	var/bleed_timer = 0
	/// Above this amount of damage, you will need to treat the injury to stop bleeding, regardless of bleed_timer
	var/bleed_threshold = 30
	/// Amount of damage the current injury type requires (less means we need to apply the next healing stage)
	var/min_damage = 0
	/// General flags like INJURY_BANDAGED, INJURY_SALVED
	var/injury_flags = (INJURY_SOUND_HINTS)
	/// world.time when this injury was created
	var/created = 0
	/// Number of inuries stored in this datum
	var/amount = 1
	/// Amount of germs in the injury
	var/germ_level = 0
	/// Rate of infection for this injury
	var/infection_rate = 1
	/// Time it takes for the injury to fade away once healed up
	var/fade_away_time = 1 MINUTES
	/// The bodypart the injury is on, if on a bodypart
	var/obj/item/bodypart/parent_bodypart
	/// The mob the injury is on, if on a mob
	var/mob/living/carbon/parent_mob

	// ~these are defined by the injury type and should not be changed here
	/// Stages such as "cut", "deep cut", etc.
	var/list/stages
	/// Maximum stage at which bleeding should still happen - Beyond this stage bleeding is prevented
	var/max_bleeding_stage = 0
	/// One of WOUND_BLUNT, WOUND_SLASH, WOUND_PIERCE, WOUND_BURN
	var/damage_type = WOUND_SLASH
	/// The maximum amount of damage that this injury can have and still autoheal
	var/autoheal_cutoff = 15
	/// How much having this injury will add to all future check_wounding() rolls on this limb
	var/threshold_penalty = 0

	// ~helper lists
	var/list/desc_list = list()
	var/list/damage_list = list()

	/// Limb status required for this injury
	var/required_status = BODYPART_ORGANIC

	// ~shit that got embedded on this injury
	var/list/embedded_objects

/datum/injury/New()
	. = ..()
	created = world.time
	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/stage in stages)
		desc_list += stage
		damage_list += stages[stage]

/datum/injury/Destroy()
	if(parent_bodypart)
		remove_from_bodypart()
	if(parent_mob)
		remove_from_mob()
	embedded_objects = null
	return ..()

/datum/injury/proc/get_desc(count = TRUE)
	if(count && (amount > 1))
		return "[desc]s"
	return desc

/datum/injury/proc/get_bleed_rate_of_change()
	if((bleed_timer > 0 || damage_per_injury() > bleed_threshold) && current_stage <= max_bleeding_stage)
		return BLOOD_FLOW_STEADY
	return BLOOD_FLOW_DECREASING

/datum/injury/proc/set_mob(mob/living/carbon/new_owner, sound_hint = TRUE)
	parent_mob = new_owner
	LAZYADD(new_owner.all_injuries, src)

/datum/injury/proc/set_bodypart(obj/item/bodypart/new_owner, sound_hint = TRUE)
	parent_bodypart = new_owner
	LAZYADD(parent_bodypart.injuries, src)

/datum/injury/proc/transfer_injury(mob/living/carbon/new_owner, sound_hint = TRUE)
	var/obj/item/bodypart/old_bodypart = parent_bodypart

	var/obj/item/bodypart/new_bodypart = new_owner.get_bodypart(old_bodypart.body_zone)
	if(!new_bodypart)
		return

	remove_from_bodypart()
	remove_from_mob()
	set_mob(new_owner, sound_hint)
	set_bodypart(new_bodypart, sound_hint)

/datum/injury/proc/remove_from_mob()
	if(!parent_mob)
		return
	LAZYREMOVE(parent_mob.all_injuries, src)
	parent_mob = null

/datum/injury/proc/remove_from_bodypart()
	if(!parent_bodypart)
		return
	LAZYREMOVE(parent_bodypart.injuries, src)
	if(parent_bodypart.last_injury == src)
		parent_bodypart.last_injury = null
	parent_bodypart = null

//applies the injury on a limb proper
/datum/injury/proc/apply_injury(our_damage, obj/item/bodypart/parent)
	//aaaaaaaaah
	damage = our_damage

	//initialize with the appropriate stage and bleeding ticks
	bleed_timer += our_damage
	init_stage(our_damage)

	if(istype(parent))
		set_bodypart(parent)
		if(parent_bodypart.owner)
			set_mob(parent_bodypart.owner)

//increase or decrease infection
/datum/injury/proc/adjust_germ_level(add_germs, minimum_germs = 0, maximum_germs = GERM_LEVEL_MAXIMUM)
	germ_level = clamp(germ_level + add_germs, minimum_germs, maximum_germs)

//makes the injury get infected more when the victim is moving around
/datum/injury/proc/movement_infect(mob/living/carbon/source)
	if(parent_bodypart && prob(25) && infection_check())
		adjust_germ_level(infection_rate)

//special proc for when the parent bodypart receives some damage
/datum/injury/proc/receive_damage(damage_received = 0, pain_received = 0, wounding_type = WOUND_BLUNT)
	return FALSE

// returns 1 if there's a next stage, 0 otherwise
/datum/injury/proc/init_stage(initial_damage)
	current_stage = stages.len

	while(current_stage > 1 && damage_list[current_stage-1] <= initial_damage / amount)
		current_stage--

	min_damage = damage_list[current_stage]
	desc = desc_list[current_stage]

// the amount of damage per injury
/datum/injury/proc/damage_per_injury()
	return (damage/amount)

/datum/injury/proc/can_autoheal()
	if(parent_mob.stat == DEAD)
		return FALSE
	if(required_status != BODYPART_ORGANIC)
		return FALSE
	if(parent_bodypart.is_retracted())
		return FALSE
	if(germ_level > INFECTION_LEVEL_ONE)
		return FALSE
	return ((damage_per_injury() <= autoheal_cutoff) ? TRUE : (is_treated() || parent_bodypart?.limb_flags & BODYPART_GOOD_HEALER))

// checks whether the injury has been appropriately treated
/datum/injury/proc/is_treated()
	switch(damage_type)
		if(WOUND_SLASH, WOUND_PIERCE, WOUND_BITE)
			return (is_bandaged() || is_sutured() || parent_bodypart.bandage)
		if(WOUND_BLUNT, WOUND_LASH, WOUND_DIVINE)
			return (is_bandaged() || parent_bodypart.bandage)
		if(WOUND_BURN)
			return (is_salved() || (is_disinfected() && (is_bandaged() || parent_bodypart.bandage) ) )

// Checks whether other other can be merged into src.
/datum/injury/proc/can_merge(datum/injury/other)
	if(other.damage_type != damage_type)
		return FALSE
	if(other.type != type)
		return FALSE
	if(other.current_stage != current_stage)
		return FALSE
	if(other.can_autoheal() != can_autoheal())
		return FALSE
	if(other.injury_flags != injury_flags)
		return FALSE
	if(other.parent_bodypart != parent_bodypart)
		return FALSE
	return TRUE

/datum/injury/proc/merge_injury(datum/injury/other)
	embedded_objects = (src.embedded_objects | other.embedded_objects)

	damage += other.damage
	amount += other.amount
	bleed_timer += other.bleed_timer
	germ_level = max(germ_level, other.germ_level)
	injury_flags |= other.injury_flags
	created = max(created, other.created)	//take the newer created time
	parent_bodypart?.last_injury = src
	qdel(other)

// checks if injury is considered open for external infections
// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if injury is bigger
/datum/injury/proc/infection_check(delta_time = 2, times_fired)
	if((damage < 10) && germ_level < INFECTION_LEVEL_ONE)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return FALSE
	if(is_treated() && damage < 25)	//anything less than a flesh injury (or equivalent) isn't infectable if treated properly
		return FALSE
	if(is_disinfected())
		return FALSE
	if(required_status & BODYPART_ROBOTIC) //Robotic injury
		return FALSE

	if(damage_type == WOUND_BLUNT && !is_bleeding()) //bruises only infectable if bleeding
		return FALSE


	switch(damage_type)
		if(WOUND_BLUNT)
			return DT_PROB(damage/2, delta_time)
		if(WOUND_BURN)
			return DT_PROB(damage*2, delta_time)
		if(WOUND_SLASH)
			return DT_PROB(damage, delta_time)
		if(WOUND_PIERCE)
			return DT_PROB(damage*1.25, delta_time)
		if(WOUND_LASH)
			return DT_PROB(damage * 1.15, delta_time)
	return FALSE

//bleeding from being dragged against the ground
/datum/injury/proc/drag_bleed_amt()
	if(!is_bleeding())
		return FALSE
	return CEILING(get_bleed_rate() * 0.2, 0.1)

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
/datum/injury/proc/heal_damage(amount_heal)
	var/healed_damage = min(src.damage, amount_heal)
	damage -= healed_damage
	while(damage_per_injury() < damage_list[current_stage] && current_stage < length(desc_list))
		current_stage++
	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(!damage)
		qdel(src)

	// return amount of healing still leftover, can be used for other injuries
	return (amount_heal - healed_damage)

// returns whether this injury can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe injury types
/datum/injury/proc/can_worsen(damage_type, damage)
	if(src.damage_type != damage_type)
		return FALSE	//incompatible damage types

	if(amount > 1)
		return FALSE	//multiple injuries cannot be worsened

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh injury, etc.
	var/max_injury_damage = 1.5 * damage_list[1]
	if(src.damage + damage > max_injury_damage)
		return FALSE

	return TRUE

// closes the injury
/datum/injury/proc/close_injury()
	current_stage = min(max_bleeding_stage + 1, length(damage_list))
	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(damage > min_damage)
		heal_damage(damage-min_damage)
	injury_flags &= ~INJURY_RETRACTED
	parent_bodypart?.update_bodypart_damage_state()
	parent_bodypart?.owner?.update_damage_overlays()

// opens the injury and worsens it
/datum/injury/proc/open_injury(damage, retracting = FALSE)
	src.damage += damage
	bleed_timer += damage

	while(current_stage > 1 && damage_list[current_stage-1] < damage_per_injury())
		current_stage--

	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(retracting)
		injury_flags |= INJURY_RETRACTED
	if(parent_bodypart)
		parent_bodypart.last_injury = src
		parent_bodypart.update_bodypart_damage_state()
		parent_bodypart.owner?.update_damage_overlays()

// disinfects the injury
/datum/injury/proc/disinfect_injury()
	injury_flags |= INJURY_DISINFECTED
	return TRUE

// undisinfects the injury (differs from infecting the injury)
/datum/injury/proc/undisinfect_injury()
	injury_flags &= ~INJURY_DISINFECTED
	return TRUE

// salves the injury
/datum/injury/proc/salve_injury()
	injury_flags |= INJURY_SALVED
	return TRUE

// unsalves the injury
/datum/injury/proc/unsalve_injury()
	injury_flags &= ~INJURY_SALVED
	return TRUE

// clamps the injury
/datum/injury/proc/clamp_injury()
	injury_flags |= INJURY_CLAMPED
	return TRUE

// unclamps the injury
/datum/injury/proc/unclamp_injury()
	injury_flags &= ~INJURY_CLAMPED
	return TRUE

// sutures the injury
/datum/injury/proc/suture_injury()
	injury_flags |= INJURY_SUTURED
	if(parent_bodypart?.spilled)
		parent_bodypart.spilled = FALSE
	return TRUE

// unsutures the injury
/datum/injury/proc/unsuture_injury()
	injury_flags &= ~INJURY_SUTURED
	return TRUE

// bandages the injury
/datum/injury/proc/bandage_injury()
	injury_flags |= INJURY_BANDAGED
	return TRUE

// unbandages the injury
/datum/injury/proc/unbandage_injury()
	injury_flags |= INJURY_BANDAGED
	return TRUE

/datum/injury/proc/is_bleeding()
	for(var/thing in embedded_objects)
		var/obj/item/item = thing
		if(item.w_class >= WEIGHT_CLASS_SMALL)
			return FALSE
	if(is_bandaged() || is_clamped() || is_sutured())
		return FALSE
	return ((bleed_timer > 0 || damage_per_injury() > bleed_threshold) && current_stage <= max_bleeding_stage)

/datum/injury/proc/get_bleed_rate()
	if(!is_bleeding())
		return 0
	var/bad_embeddies = 0
	for(var/obj/item/item in embedded_objects)
		if((item.w_class < WEIGHT_CLASS_SMALL))
			bad_embeddies += 1
	return max(0.1, (bleed_rate * damage)/20 + bad_embeddies)

/datum/injury/proc/is_surgical()
	if(CHECK_BITFIELD(injury_flags, INJURY_SURGICAL))
		return TRUE
	return FALSE

/datum/injury/proc/is_disinfected()
	if(CHECK_BITFIELD(injury_flags, INJURY_DISINFECTED) && (germ_level <= 0))
		return TRUE
	return FALSE

/datum/injury/proc/is_salved()
	if(CHECK_BITFIELD(injury_flags, INJURY_SALVED))
		return TRUE
	return FALSE

/datum/injury/proc/is_clamped()
	if(CHECK_BITFIELD(injury_flags, INJURY_CLAMPED))
		return TRUE
	return FALSE

/datum/injury/proc/is_sutured()
	if(CHECK_BITFIELD(injury_flags, INJURY_SUTURED))
		return TRUE
	return FALSE

/datum/injury/proc/is_bandaged()
	if(CHECK_BITFIELD(injury_flags, INJURY_BANDAGED))
		return TRUE
	return FALSE
