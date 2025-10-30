/datum/component/squeak
	var/static/list/default_squeak_sounds = list('sound/blank.ogg'=1)
	var/list/override_squeak_sounds

	var/squeak_chance = 100
	var/volume = 30

	// This is so shoes don't squeak every step
	var/steps = 1
	var/step_delay = 0

	// This is to stop squeak spam from inhand usage
	COOLDOWN_DECLARE(spam_cooldown)
	var/use_delay = 2 SECONDS

	///extra-range for this component's sound
	var/sound_extra_range = -1
	///when sounds start falling off for the squeak
	var/sound_falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE
	///sound exponent for squeak. Defaults to 10 as squeaking is loud and annoying enough.
	var/sound_falloff_exponent = 10

/datum/component/squeak/Initialize(custom_sounds, volume_override, chance_override, step_delay_override, use_delay_override, extrarange, falloff_exponent, fallof_distance)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_BLOB_ACT, COMSIG_ATOM_ATTACKBY), PROC_REF(play_squeak))
	if(ismovableatom(parent))
		RegisterSignal(parent, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_IMPACT), PROC_REF(play_squeak))
		RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(play_squeak_crossed))
		RegisterSignal(parent, COMSIG_ITEM_WEARERCROSSED, PROC_REF(play_squeak_crossed))
		if(isitem(parent))
			RegisterSignal(parent, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_OBJ, COMSIG_ITEM_HIT_REACT), PROC_REF(play_squeak))
			RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(use_squeak))
			if(istype(parent, /obj/item/clothing))
				RegisterSignal(parent, COMSIG_CLOTHING_STEP_ACTION, PROC_REF(step_squeak))

	override_squeak_sounds = custom_sounds
	if(chance_override)
		squeak_chance = chance_override
	if(volume_override)
		volume = volume_override
	if(isnum(step_delay_override))
		step_delay = step_delay_override
	if(isnum(use_delay_override))
		use_delay = use_delay_override
	if(isnum(extrarange))
		sound_extra_range = extrarange
	if(isnum(falloff_exponent))
		sound_falloff_exponent = falloff_exponent
	if(isnum(fallof_distance))
		sound_falloff_distance = fallof_distance

/datum/component/squeak/proc/play_squeak()
	if(prob(squeak_chance))
		if(!override_squeak_sounds)
			playsound(parent, pickweight(default_squeak_sounds), volume, TRUE, sound_extra_range, sound_falloff_exponent, falloff_distance = sound_falloff_distance)
		else
			playsound(parent, pickweight(override_squeak_sounds), volume, TRUE, sound_extra_range, sound_falloff_exponent, falloff_distance = sound_falloff_distance)

/datum/component/squeak/proc/step_squeak()
	if(steps > step_delay)
		play_squeak()
		steps = 0
	else
		steps++

/datum/component/squeak/proc/play_squeak_crossed(datum/source, atom/movable/AM)
	if(isitem(AM))
		var/obj/item/I = AM
		if(I.item_flags & ABSTRACT)
			return
		else if(istype(AM, /obj/projectile))
			var/obj/projectile/P = AM
			if(P.original != parent)
				return
	if(istype(AM, /obj/effect/dummy/phased_mob)) //don't squeek if they're in a phased/jaunting container.
		return
	if(AM.movement_type & (FLYING|FLOATING))
		return
	if(ismob(AM) && !AM.density) // Prevents 10 overlapping mice from making an unholy sound while moving
		return
	if(isliving(AM))
		var/mob/living/living_arrived = AM
		if(living_arrived.mob_size < MOB_SIZE_HUMAN)
			return
	var/atom/current_parent = parent
	if(isturf(current_parent.loc))
		play_squeak()

/datum/component/squeak/proc/use_squeak()
	SIGNAL_HANDLER

	if(COOLDOWN_FINISHED(src, spam_cooldown))
		COOLDOWN_START(src, spam_cooldown, use_delay)
		play_squeak()


/datum/component/squeak/proc/holder_dir_change(datum/source, old_dir, new_dir)
	//If the dir changes it means we're going through a bend in the pipes, let's pretend we bumped the wall
	if(old_dir != new_dir)
		play_squeak()
