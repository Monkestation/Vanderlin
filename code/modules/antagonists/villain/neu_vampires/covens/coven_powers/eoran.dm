/datum/coven/eora
	name = "Eoran Embrace"
	desc = "Blessed by the Goddess of Love, Family, and Art, these vampires have developed powers that strengthen bonds, inspire beauty, and heal emotional wounds."
	icon_state = "eora"
	power_type = /datum/coven_power/eora
	max_level = 4

/datum/coven_power/eora
	name = "Eora power name"
	desc = "Eora power desc"

//EMPATHIC BOND
/datum/coven_power/eora/empathic_bond
	name = "Empathic Bond"
	desc = "Touch someone to sense their emotional state and immediate needs, making you obsessed with them for a short time."

	level = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 1

	cooldown_length = 10 SECONDS

/datum/coven_power/eora/empathic_bond/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only sense the emotions of other people."))
		return

	var/mob/living/carbon/human/victim = target

	// Generate emotional state based on character's current condition
	var/list/emotions = list()
	var/list/needs = list()

	if(victim.getBruteLoss() > 20 || victim.getFireLoss() > 20)
		emotions += "pain"
		needs += "healing"
	if(victim.getToxLoss() > 20)
		emotions += "sickness"
		needs += "cleansing"
	if(victim.getOxyLoss() > 20)
		emotions += "exhaustion"
		needs += "rest"
	if(victim.nutrition < 200)
		emotions += "hunger"
		needs += "sustenance"
	if(victim.getOrganLoss(ORGAN_SLOT_BRAIN) > 20)
		emotions += "confusion"
		needs += "mental clarity"

	// Add some randomized emotional states
	var/list/possible_emotions = list("loneliness", "contentment", "anxiety", "hope", "sadness", "joy", "fear", "love", "anger", "peace")
	emotions += pick(possible_emotions)

	var/list/possible_needs = list("companionship", "understanding", "safety", "purpose", "acceptance", "creative expression")
	needs += pick(possible_needs)

	var/emotion_text = english_list(emotions)
	var/needs_text = english_list(needs)

	to_chat(owner, span_notice("You sense [victim]'s emotional state: [emotion_text]. They seem to need: [needs_text]."))
	to_chat(victim, span_info("You feel [owner] understanding your inner state with surprising clarity."))
	owner.AddComponent(/datum/component/empathic_obsession, victim, 2 MINUTES)

//ARTISTIC INSPIRATION
/datum/coven_power/eora/artistic_inspiration
	name = "Artistic Inspiration"
	desc = "Inspire others with divine creativity, enhancing their artistic abilities and mood."

	level = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 3

	cooldown_length = 30 SECONDS
	duration_length = 5 MINUTES

/datum/coven_power/eora/artistic_inspiration/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("Only humans can receive artistic inspiration."))
		return

	var/mob/living/carbon/human/inspired = target

	to_chat(owner, span_notice("You whisper words of divine inspiration to [inspired]."))
	to_chat(inspired, span_purple("You feel a surge of creative energy flow through you, your mind buzzing with artistic possibilities!"))

	// Visual effect
	inspired.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/inspiration_overlay = mutable_appearance('icons/effects/clan.dmi', "inspiration", -MUTATIONS_LAYER)
	inspired.overlays_standing[MUTATIONS_LAYER] = inspiration_overlay
	inspired.apply_overlay(MUTATIONS_LAYER)

	// Boost mood and give temporary creative buff do this for now until we add some form of creation quality outside of blacksmithing
	inspired.add_stress(/datum/stress_event/artistic_inspiration)

	addtimer(CALLBACK(src, PROC_REF(deactivate), inspired), duration_length)

/datum/coven_power/eora/artistic_inspiration/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	to_chat(target, span_info("The divine inspiration fades, but the memory of it remains."))

//FAMILIAL BOND
/datum/coven_power/eora/familial_bond
	name = "Familial Bond"
	desc = "Create a temporary spiritual connection between two people, allowing them to sense each other's location and well-being."

	level = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 5

	cooldown_length = 60 SECONDS
	duration_length = 10 MINUTES

/datum/coven_power/eora/familial_bond/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only bond with other people."))
		return

	var/mob/living/carbon/human/bonded = target

	// Get second target
	var/mob/living/carbon/human/second_target = input(owner, "Who will you bond [bonded] with?") as null|mob in (oviewers(5, owner) - bonded)
	if(!second_target || !ishuman(second_target))
		to_chat(owner, span_warning("You need a second person to create a familial bond."))
		return

	to_chat(owner, span_notice("You weave a spiritual connection between [bonded] and [second_target]."))
	to_chat(bonded, span_purple("You feel a warm connection forming with [second_target], as if they were family."))
	to_chat(second_target, span_purple("You feel a warm connection forming with [bonded], as if they were family."))

	// Store the bond information
	bonded.AddComponent(/datum/component/familial_bond, second_target, duration_length)
	second_target.AddComponent(/datum/component/familial_bond, bonded, duration_length)

//BEAUTY'S RESTORATION
/datum/coven_power/eora/beautys_restoration
	name = "Beauty's Restoration"
	desc = "Channel Eora's power to restore physical beauty and heal disfigurements."

	level = 4
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN | TARGET_SELF
	range = 1

	cooldown_length = 90 SECONDS

/datum/coven_power/eora/beautys_restoration/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only restore the beauty of people."))
		return

	var/mob/living/carbon/human/patient = target

	to_chat(owner, span_notice("You channel Eora's restorative power into [patient]."))
	to_chat(patient, span_purple("You feel divine energy coursing through you, restoring your natural beauty!"))

	// Visual effect
	patient.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/restoration_overlay = mutable_appearance('icons/effects/clan.dmi', "dementation", -MUTATIONS_LAYER)
	patient.overlays_standing[MUTATIONS_LAYER] = restoration_overlay
	patient.apply_overlay(MUTATIONS_LAYER)

	// Heal brute and burn damage (representing restoration of beauty)
	patient.heal_overall_damage(30, 30)

	patient.add_stress(/datum/stress_event/beautiful)

	addtimer(CALLBACK(src, PROC_REF(deactivate), patient), 3 SECONDS)
	owner.AddComponent(/datum/component/empathic_obsession, patient, 5 MINUTES)

/datum/coven_power/eora/beautys_restoration/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

// Helper mood events (these would need to be defined in your mood system)
/datum/stress_event/artistic_inspiration
	desc = "I feel divinely inspired to create something beautiful!"
	stress_change = -3
	timer = 5 MINUTES
	quality_modifier = 4

/datum/stress_event/beautiful
	desc = "I feel beautiful and radiant!"
	stress_change = -2
	timer = 10 MINUTES

/datum/stress_event/divine_love
	desc = "I felt touched by divine love and compassion."
	stress_change = -4
	timer = 15 MINUTES

/datum/component/familial_bond
	var/mob/living/carbon/human/bonded_with
	var/bond_duration
	var/bond_strength = 100 // Bond strength affects range and clarity of sensing
	var/last_health_check = 0
	var/last_location_ping = 0
	var/ping_cooldown = 30 SECONDS
	var/health_check_interval = 15 SECONDS
	var/max_sensing_range = 50 // Maximum range for sensing on same z-level
	var/emergency_threshold = 30 // Health percentage that triggers emergency alerts

/datum/component/familial_bond/Initialize(mob/living/carbon/human/target, duration)
	if(!istype(target) || !istype(parent))
		return COMPONENT_INCOMPATIBLE

	bonded_with = target
	bond_duration = duration
	last_health_check = world.time
	last_location_ping = world.time

	// Notify both parties of the bond formation
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("You feel a warm spiritual connection forming with [bonded_with]."))
	to_chat(bonded_with, span_purple("You feel a warm spiritual connection forming with [parent_mob]."))

	// Set up termination timer
	addtimer(CALLBACK(src, PROC_REF(end_bond)), duration)
	START_PROCESSING(SSprocessing, src)

	// Register signal handlers for enhanced interaction
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_parent_death))
	RegisterSignal(bonded_with, COMSIG_LIVING_DEATH, PROC_REF(on_bonded_death))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_movement))

/datum/component/familial_bond/Destroy()
	UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
	if(bonded_with)
		UnregisterSignal(bonded_with, COMSIG_LIVING_DEATH)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/familial_bond/process()
	if(!bonded_with || QDELETED(bonded_with) || !parent || QDELETED(parent))
		end_bond()
		return

	var/mob/living/carbon/human/parent_mob = parent

	// Check if we're still on the same server/existence plane
	if(bonded_with.z == 0 || parent_mob.z == 0)
		return

	// Periodic health monitoring
	if(world.time >= last_health_check + health_check_interval)
		check_bonded_health()
		last_health_check = world.time

	// Location sensing with reduced frequency
	if(world.time >= last_location_ping + ping_cooldown)
		provide_location_sense()
		last_location_ping = world.time

	// Bond strength naturally degrades over time (adds realism)
	if(prob(5))
		bond_strength = max(bond_strength - 1, 20)

/datum/component/familial_bond/proc/check_bonded_health()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !bonded_with)
		return

	var/bonded_health_percent = (bonded_with.health / bonded_with.maxHealth) * 100

	// Emergency health alerts
	if(bonded_health_percent <= emergency_threshold)
		to_chat(parent_mob, span_danger("You feel a sharp pain in your chest - [bonded_with] is in serious danger!"))
		// Add a subtle screen effect
		parent_mob.overlay_fullscreen("familial_pain", /atom/movable/screen/fullscreen/painflash, 1)
		addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "familial_pain"), 3 SECONDS)

	// Mutual health awareness at close range
	if(get_dist(parent_mob, bonded_with) <= 7 && parent_mob.z == bonded_with.z)
		if(bonded_health_percent <= 50)
			to_chat(parent_mob, span_warning("You sense [bonded_with] is hurt."))
		else if(bonded_health_percent >= 90)
			to_chat(parent_mob, span_notice("You sense [bonded_with] is in good health."))

/datum/component/familial_bond/proc/provide_location_sense()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !bonded_with)
		return

	// Different z-levels
	if(parent_mob.z != bonded_with.z)
		to_chat(parent_mob, span_info("You sense [bonded_with] is on a different level of existence."))
		return

	var/distance = get_dist(parent_mob, bonded_with)
	var/direction = get_dir(parent_mob, bonded_with)

	// Range check based on bond strength
	var/effective_range = max_sensing_range * (bond_strength / 100)
	if(distance > effective_range)
		to_chat(parent_mob, span_info("Your bond with [bonded_with] is too distant to sense clearly."))
		return

	// Provide detailed location information based on distance
	var/distance_desc
	var/direction_text = dir2text(direction)

	switch(distance)
		if(0 to 3)
			distance_desc = "very close"
		if(4 to 7)
			distance_desc = "nearby"
		if(8 to 15)
			distance_desc = "some distance away"
		if(16 to 25)
			distance_desc = "far"
		if(26 to INFINITY)
			distance_desc = "very far"

	// Add emotional context based on bond strength
	var/bond_feeling = ""
	if(bond_strength >= 80)
		bond_feeling = " Your connection feels strong and warm."
	else if(bond_strength >= 50)
		bond_feeling = " The bond feels stable."
	else if(bond_strength >= 30)
		bond_feeling = " The connection feels somewhat faint."
	else
		bond_feeling = " The bond is weakening."

	to_chat(parent_mob, span_info("You sense [bonded_with] is [distance_desc] to the [direction_text].[bond_feeling]"))

/datum/component/familial_bond/proc/on_parent_death(mob/living/source)
	SIGNAL_HANDLER

	if(bonded_with)
		to_chat(bonded_with, span_danger("You feel a terrible emptiness as your bond with [source] is severed by death."))
		bonded_with.add_stress(/datum/stress_event/bond_death)
	end_bond()

/datum/component/familial_bond/proc/on_bonded_death(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(parent_mob)
		to_chat(parent_mob, span_danger("You feel a terrible emptiness as your bond with [source] is severed by death."))
		parent_mob.add_stress(/datum/stress_event/bond_death)
	end_bond()

/datum/component/familial_bond/proc/on_movement(mob/living/source)
	SIGNAL_HANDLER

	// Chance to feel movement of bonded person when very close
	if(get_dist(source, bonded_with) <= 3 && prob(30))
		to_chat(bonded_with, span_info("You sense [source] moving nearby."))

/datum/component/familial_bond/proc/strengthen_bond(amount = 10)
	bond_strength = min(bond_strength + amount, 100)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("Your familial bond grows stronger."))
	if(bonded_with)
		to_chat(bonded_with, span_purple("Your familial bond grows stronger."))

/datum/component/familial_bond/proc/weaken_bond(amount = 15)
	bond_strength = max(bond_strength - amount, 10)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_warning("Your familial bond weakens."))
	if(bonded_with)
		to_chat(bonded_with, span_warning("Your familial bond weakens."))

	if(bond_strength <= 10)
		to_chat(parent_mob, span_danger("Your familial bond is nearly broken!"))
		// Chance for early termination if bond is too weak
		if(prob(25))
			end_bond()

/datum/component/familial_bond/proc/end_bond()
	var/mob/living/carbon/human/parent_mob = parent

	if(parent_mob)
		to_chat(parent_mob, span_info("Your familial bond fades away, but the memory of connection remains."))
		parent_mob.add_stress(/datum/stress_event/bond_ended)

	if(bonded_with)
		to_chat(bonded_with, span_info("Your familial bond fades away, but the memory of connection remains."))
		bonded_with.add_stress(/datum/stress_event/bond_ended)

	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/datum/stress_event/bond_death
	desc = "Someone I was bonded with has died. I feel empty inside."
	stress_change = 6
	timer = 30 MINUTES

/datum/stress_event/bond_ended
	desc = "A familial bond has ended, but I feel grateful for the connection we shared."
	stress_change = -1
	timer = 10 MINUTES

/datum/component/empathic_obsession
	var/mob/living/carbon/human/obsession_target
	var/obsession_duration
	var/obsession_intensity = 100 // How strongly the caster is obsessed (affects mood penalties)
	var/last_health_check = 0
	var/last_proximity_check = 0
	var/health_check_interval = 10 SECONDS
	var/proximity_check_interval = 15 SECONDS
	var/max_comfortable_distance = 10 // Distance before anxiety kicks in
	var/last_known_health = 100
	var/separation_anxiety_active = FALSE
	var/critical_health_threshold = 40
	var/panic_mode = FALSE

/datum/component/empathic_obsession/Initialize(mob/living/carbon/human/target, duration)
	if(!istype(target) || !istype(parent))
		return COMPONENT_INCOMPATIBLE

	obsession_target = target
	obsession_duration = duration
	last_health_check = world.time
	last_proximity_check = world.time
	last_known_health = (target.health / target.maxHealth) * 100

	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("You feel an intense emotional connection forming with [target]. Their wellbeing becomes deeply important to you."))

	// Initial positive mood from forming the bond
	parent_mob.add_stress(/datum/stress_event/empathic_bond_formed)

	// Set up termination timer
	addtimer(CALLBACK(src, PROC_REF(end_obsession)), duration)
	START_PROCESSING(SSprocessing, src)

	// Register signal handlers
	RegisterSignal(obsession_target, COMSIG_LIVING_DEATH, PROC_REF(on_target_death))
	RegisterSignal(obsession_target, COMSIG_LIVING_REVIVE, PROC_REF(on_target_revive))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_parent_death))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))

/datum/component/empathic_obsession/Destroy()
	if(obsession_target)
		UnregisterSignal(obsession_target, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE))
	UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/empathic_obsession/process()
	if(!obsession_target || QDELETED(obsession_target) || !parent || QDELETED(parent))
		end_obsession()
		return

	// Periodic health monitoring
	if(world.time >= last_health_check + health_check_interval)
		monitor_target_health()
		last_health_check = world.time

	// Proximity anxiety checks
	if(world.time >= last_proximity_check + proximity_check_interval)
		check_proximity_anxiety()
		last_proximity_check = world.time

	// Obsession intensity can fluctuate based on circumstances
	adjust_obsession_intensity()

/datum/component/empathic_obsession/proc/monitor_target_health()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !obsession_target)
		return

	var/current_health = (obsession_target.health / obsession_target.maxHealth) * 100
	var/health_change = current_health - last_known_health

	// React to health changes
	if(health_change < -15) // Significant health loss
		to_chat(parent_mob, span_danger("You feel a wave of distress - [obsession_target] is being hurt!"))
		parent_mob.add_stress(/datum/stress_event/obsession_target_hurt)

		// Visual distress effect
		parent_mob.overlay_fullscreen("empathic_distress", /atom/movable/screen/fullscreen/painflash, 2)
		addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "empathic_distress"), 5 SECONDS)

	else if(health_change > 15) // Significant healing
		to_chat(parent_mob, span_notice("You feel relief as [obsession_target] recovers."))
		parent_mob.add_stress(/datum/stress_event/obsession_target_healed)
		parent_mob.remove_stress(/datum/stress_event/obsession_target_hurt)

	// Critical health panic
	if(current_health <= critical_health_threshold && !panic_mode)
		enter_panic_mode()
	else if(current_health > critical_health_threshold && panic_mode)
		exit_panic_mode()

	last_known_health = current_health

/datum/component/empathic_obsession/proc/check_proximity_anxiety()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !obsession_target)
		return

	var/distance = get_dist(parent_mob, obsession_target)
	var/different_z = (parent_mob.z != obsession_target.z)

	// Separation anxiety
	if(distance > max_comfortable_distance || different_z)
		if(!separation_anxiety_active)
			separation_anxiety_active = TRUE
			to_chat(parent_mob, span_warning("You feel anxious being separated from [obsession_target]."))
			parent_mob.add_stress(/datum/stress_event/separation_anxiety)
	else
		if(separation_anxiety_active)
			separation_anxiety_active = FALSE
			to_chat(parent_mob, span_notice("You feel calmer now that [obsession_target] is nearby."))
			parent_mob.remove_stress(/datum/stress_event/separation_anxiety)
			parent_mob.add_stress(/datum/stress_event/proximity_comfort)

/datum/component/empathic_obsession/proc/adjust_obsession_intensity()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	// Intensity increases with stress and decreases with comfort
	if(separation_anxiety_active || panic_mode)
		obsession_intensity = min(obsession_intensity + 2, 150)
	else if(get_dist(parent_mob, obsession_target) <= 3)
		obsession_intensity = max(obsession_intensity - 1, 50)

	// Provide feedback on obsession level changes
	if(obsession_intensity >= 120 && prob(5))
		to_chat(parent_mob, span_warning("Your thoughts keep returning to [obsession_target]. You can't stop thinking about them."))
	else if(obsession_intensity <= 60 && prob(5))
		to_chat(parent_mob, span_notice("You feel slightly more at ease about [obsession_target]."))

/datum/component/empathic_obsession/proc/enter_panic_mode()
	panic_mode = TRUE
	var/mob/living/carbon/human/parent_mob = parent

	to_chat(parent_mob, span_userdanger("You feel overwhelming panic - [obsession_target] is in mortal danger!"))
	parent_mob.add_stress(/datum/stress_event/obsession_panic)

	// Strong visual effect
	parent_mob.overlay_fullscreen("empathic_panic", /atom/movable/screen/fullscreen/high, 1)

	// Compulsive behavior - try to move toward target if possible
	if(get_dist(parent_mob, obsession_target) <= 20 && parent_mob.z == obsession_target.z)
		parent_mob.create_walk_to(5 SECONDS, obsession_target)
		to_chat(parent_mob, span_danger("You feel compelled to reach [obsession_target] immediately!"))

/datum/component/empathic_obsession/proc/exit_panic_mode()
	panic_mode = FALSE
	var/mob/living/carbon/human/parent_mob = parent

	to_chat(parent_mob, span_notice("You feel intense relief as [obsession_target] seems to be recovering."))
	parent_mob.remove_stress(/datum/stress_event/obsession_panic)
	parent_mob.add_stress(/datum/stress_event/crisis_relief)
	parent_mob.clear_fullscreen("empathic_panic")

/datum/component/empathic_obsession/proc/on_target_death(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	to_chat(parent_mob, span_userdanger("You feel a devastating emptiness as [source] dies. Part of you dies with them."))

	// Severe negative mood effects
	parent_mob.add_stress(/datum/stress_event/obsession_death)
	parent_mob.remove_stress(/datum/stress_event/empathic_bond_formed)
	parent_mob.remove_stress(/datum/stress_event/proximity_comfort)
	parent_mob.remove_stress(/datum/stress_event/crisis_relief)

	// Dramatic visual effect
	parent_mob.overlay_fullscreen("empathic_death", /atom/movable/screen/fullscreen/blind, 2)
	addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "empathic_death"), 10 SECONDS)

	// Extend obsession duration due to grief
	obsession_duration += 20 MINUTES
	addtimer(CALLBACK(src, PROC_REF(end_obsession)), obsession_duration)

/datum/component/empathic_obsession/proc/on_target_revive(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	to_chat(parent_mob, span_purple("You feel overwhelming joy and relief as [source] returns to life!"))
	parent_mob.remove_stress(/datum/stress_event/obsession_death)
	parent_mob.add_stress(/datum/stress_event/obsession_revival)
	panic_mode = FALSE

/datum/component/empathic_obsession/proc/on_parent_death(mob/living/source)
	SIGNAL_HANDLER
	end_obsession()

/datum/component/empathic_obsession/proc/on_parent_moved(mob/living/source)
	SIGNAL_HANDLER
	// Reset proximity check timer when parent moves to get immediate feedback
	last_proximity_check = world.time - proximity_check_interval

/datum/component/empathic_obsession/proc/end_obsession()
	var/mob/living/carbon/human/parent_mob = parent

	if(parent_mob)
		to_chat(parent_mob, span_info("Your intense emotional connection to [obsession_target] gradually fades, though the memory remains."))
		parent_mob.add_stress(/datum/stress_event/obsession_ended)

		// Clear all obsession-related mood events
		parent_mob.remove_stress(/datum/stress_event/empathic_bond_formed)
		parent_mob.remove_stress(/datum/stress_event/separation_anxiety)
		parent_mob.remove_stress(/datum/stress_event/proximity_comfort)
		parent_mob.remove_stress(/datum/stress_event/obsession_panic)
		parent_mob.remove_stress(/datum/stress_event/crisis_relief)
		parent_mob.remove_stress(/datum/stress_event/obsession_target_hurt)
		parent_mob.remove_stress(/datum/stress_event/obsession_target_healed)

		parent_mob.clear_fullscreen("empathic_panic")
		parent_mob.clear_fullscreen("empathic_distress")

	STOP_PROCESSING(SSprocessing, src)
	qdel(src)


// Missing mood events for the empathic obsession component

/datum/stress_event/empathic_bond_formed
	desc = "I feel a deep emotional connection with someone special."
	stress_change = -3
	timer = 30 MINUTES

/datum/stress_event/obsession_target_hurt
	desc = "Someone I care deeply about is hurt! I feel their pain."
	stress_change = 4
	timer = 10 MINUTES

/datum/stress_event/obsession_target_healed
	desc = "I feel relief knowing someone important to me is recovering."
	stress_change = -2
	timer = 5 MINUTES

/datum/stress_event/separation_anxiety
	desc = "I feel anxious being away from someone I'm emotionally connected to."
	stress_change = 3
	timer = 0 // Persistent while active

/datum/stress_event/proximity_comfort
	desc = "I feel calm and comfortable being near someone I care about."
	stress_change = -2
	timer = 5 MINUTES

/datum/stress_event/obsession_panic
	desc = "I'm overwhelmed with panic about someone's safety!"
	stress_change = 6
	timer = 0 // Persistent while active

/datum/stress_event/crisis_relief
	desc = "I feel intense relief that a crisis has passed."
	stress_change = -4
	timer = 15 MINUTES

/datum/stress_event/obsession_death
	desc = "Someone I was deeply connected to has died. I feel devastated."
	stress_change = 8
	timer = 60 MINUTES

/datum/stress_event/obsession_revival
	desc = "Someone precious to me has returned to life! I feel overwhelming joy!"
	stress_change = -6
	timer = 30 MINUTES

/datum/stress_event/obsession_ended
	desc = "An intense emotional connection has faded, but I remember it fondly."
	stress_change = -1
	timer = 10 MINUTES
