/// List of "primordial" wounds so that we don't have to create new wound datums when running checks to see if a wound should be applied
GLOBAL_LIST_INIT(primordial_wounds, init_primordial_wounds())

/proc/init_primordial_wounds()
	var/list/primordial_wounds = list()
	for(var/wound_type in typesof(/datum/wound))
		primordial_wounds[wound_type] = new wound_type()
	return primordial_wounds

/datum/wound
	abstract_type = /datum/wound
	var/show_in_book = TRUE
	var/category = "Wound"
	/// Name of the wound, visible to players when inspecting a limb and such
	var/name = "wound"
	/// Description for books about the wound
	var/desc = ""
	/// Name that appears on check_for_injuries()
	var/check_name

	/// Wounds get sorted from highest severity to lowest severity
	var/severity = WOUND_SEVERITY_LIGHT

	var/overlay_on_skeleton = FALSE
	/// Overlay to use when this wound is applied to a carbon mob
	var/mob_overlay = "w1"
	/// an alternative layer to render this on for things above clothing
	var/layer_override
	var/armdam_override
	var/legdam_override
	var/use_blood_color = TRUE
	/// Overlay to use when this wound is sewn, and is on a carbon mob
	var/sewn_overlay = ""

	/// Crit message(s) to append when this wound is applied in combat
	var/crit_message
	/// Sound effect(s) to play when this wound is applied
	var/sound_effect

	/// Bodypart that owns this wound, in case it is not a simple one
	var/obj/item/bodypart/bodypart_owner
	/// Mob that owns this wound
	var/mob/living/owner

	/// How many "health points" this wound has, AKA how hard it is to heal
	var/whp = 60
	/// How much this wound bleeds
	var/bleed_rate = 0
	/// Some wounds clot over time, reducing bleeding - This is the rate at which they do so
	var/clotting_rate = 0.01
	/// Clotting will not go below this amount of bleed_rate
	var/clotting_threshold = null
	/// How much pain this wound causes while on a mob
	var/woundpain = 0

	/// How much this wound increases the damage on organ damage rolls
	var/organ_damage_increase = 0
	/// How much this wound reduces organ_damage_minimum in /obj/item/bodypart/damage_internal_organs()
	var/organ_minimum_reduction = 0
	/// How much this wound reduces organ_damaged_required in /obj/item/bodypart/damage_internal_organs()
	var/organ_required_reduction = 0

	/// Will apply this amount of damage to attached organs if set
	var/apply_organ_damage = 0
	/// How much this reduces an attached organ's efficiency, if it does it at all
	var/list/organ_efficiency_reduction

	/// How much this reduces the limb's efficiency
	var/limb_efficiency_reduction = 0
	/// Using this limb in a do_after interaction will multiply the length by this duration (arms and hands)
	var/interaction_efficiency_penalty = 1
	/// Incoming damage on this limb will be multiplied by this, to simulate tenderness and vulnerability
	var/damage_multiplier_penalty = 1.25
	/// If set and this wound is applied to a leg/foot, we take this many deciseconds extra per step on this leg/foot
	var/limp_slowdown = 0

	/// If TRUE, this wound can be sewn
	var/can_sew = FALSE
	/// Sewing progress, because sewing wounds is snowflakey
	var/sew_progress = 0
	/// When sew_progress reaches this, the wound is sewn
	var/sew_threshold = 100
	/// How many "health points" this wound gets after being sewn
	var/sewn_whp = 30
	/// Bleed rate when sewn
	var/sewn_bleed_rate = 0.01
	/// Clotting rate when sewn
	var/sewn_clotting_rate = 0.02
	/// Clotting will not go below this amount of bleed_rate when sewn
	var/sewn_clotting_threshold = 0
	/// Pain this wound causes after being sewn
	var/sewn_woundpain = 0

	/// If TRUE, this wound can be cauterized
	var/can_cauterize = FALSE
	/// If TRUE, this disables limbs
	var/disabling = FALSE
	/// If TRUE, this is a crit wound
	var/critical = FALSE
	/// Some wounds cause instant death for CRITICAL_WEAKNESS
	var/mortal = FALSE

	/// Amount we heal passively while sleeping
	var/sleep_healing = 1
	/// Amount we heal passively, always
	var/passive_healing = 0
	/// Embed chance if this wound allows embedding
	var/embed_chance = 0

	/// Some wounds make no sense on a dismembered limb and need to go
	var/qdel_on_droplimb = FALSE

	/// Werewolf infection probability for bites on this wound
	var/werewolf_infection_probability = 0
	/// Time taken until werewolf infection comes in
	var/werewolf_infection_time = 2 MINUTES
	/// Actual infection timer
	var/werewolf_infection_timer = null

	/// Ingores "bloody wound" checks for wound applications
	var/ignore_bloody = FALSE

	/// List of associated bclasses for this wound
	/// Primary use is for wound application
	var/list/associated_bclasses = list()

	///list of viable zones for this
	var/list/viable_zones = ALL_BODYPARTS

	/// These are effectively try_crit moved onto the wound

	/// Minimum damage required to attempt this wound
	var/min_damage = 5
	/// Minimum damage_dividend (current/max) required
	var/min_damage_dividend = 0
	/// Base probability modifier added to the rolled chance
	var/base_prob_weight = 0
	/// If TRUE, strong RMB intent adds +10 dam before prob calc
	var/strong_intent_bonus = FALSE
	/// If TRUE, aimed RMB intent adds +10 dam before prob calc
	var/aimed_intent_bonus = FALSE
	/// If TRUE, TRAIT_BRITTLE adds +10 dam
	var/brittle_bonus = FALSE
	///if we are able to roll natively
	var/can_roll = TRUE
	///how much we multiply our dividend by for odds
	var/dividend_multi = 20
	///how much we divide our calculated damage by for odds
	var/damage_divisor = 6

/datum/wound/Destroy(force)
	. = ..()
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()
	if(werewolf_infection_timer)
		deltimer(werewolf_infection_timer)
		werewolf_infection_timer = null
	bodypart_owner = null
	owner = null

/// Description of this wound returned to the player when a bodypart is examined and such
/datum/wound/proc/get_visible_name(mob/user)
	if(!name)
		return
	var/visible_name = name
	if(is_sewn())
		visible_name += " <span class='green'>(sewn)</span>"
	if(is_clotted())
		visible_name += " <span class='danger'>(clotted)</span>"
	return visible_name

/// Description of this wound returned to the player when the bodypart is checked with check_for_injuries()
/datum/wound/proc/get_check_name(mob/user, advanced)
	return check_name

/datum/wound/proc/apply_organ_modifications()
	if(!bodypart_owner || !length(organ_efficiency_reduction))
		return

	for(var/organ_slot as anything in organ_efficiency_reduction)
		var/obj/item/organ/organ = bodypart_owner.getorganslot(organ_slot)
		organ?.apply_efficiency_modification(organ_efficiency_reduction[organ_slot], organ_slot, src)

/datum/wound/proc/remove_organ_modifications()
	if(!bodypart_owner || !length(organ_efficiency_reduction))
		return

	for(var/organ_slot as anything in organ_efficiency_reduction)
		var/obj/item/organ/organ = bodypart_owner.getorganslot(organ_slot)
		organ?.remove_efficiency_modification(organ_slot, src)

/// Crit message that should be appended when this wound is applied in combat
/datum/wound/proc/get_crit_message(mob/living/affected, obj/item/bodypart/affected_bodypart)
	if(!length(crit_message))
		return
	var/final_message = pick(crit_message)
	if(affected)
		final_message = replacetext(final_message, "%VICTIM", "[affected.name]")
		final_message = replacetext(final_message, "%P_THEIR", "[affected.p_their()]")
	else
		final_message = replacetext(final_message, "%VICTIM", "victim")
		final_message = replacetext(final_message, "%P_THEIR", "their")
	if(affected_bodypart)
		final_message = replacetext(final_message, "%BODYPART", "[affected_bodypart.name]")
	else
		final_message = replacetext(final_message, "%BODYPART", parse_zone(BODY_ZONE_CHEST))
	if(critical)
		final_message = "<span class='crit'><b>Critical hit!</b> [final_message]</span>"
	return final_message

/datum/wound/proc/get_crit_prob(bclass, dam, damage_dividend, mob/living/user, obj/item/bodypart/affected, zone_precise, list/modifiers)
	if(!can_roll)
		return 0
	if(!(bclass in associated_bclasses))
		return 0
	if(dam < min_damage)
		return 0
	if(damage_dividend < min_damage_dividend)
		if(!(brittle_bonus && HAS_TRAIT(affected, TRAIT_BRITTLE))) // brittle skips the dividend gate
			return 0
	if(length(viable_zones) && !(zone_precise in viable_zones) && viable_zones != ALL_BODYPARTS)
		return 0

	var/used = base_prob_weight + (modifiers?[CRIT_MOD_CHANCE] || 0)
	var/calc_dam = dam

	if(strong_intent_bonus && user && istype(user.rmb_intent, /datum/rmb_intent/strong))
		calc_dam += 10
	if(aimed_intent_bonus && user && istype(user.rmb_intent, /datum/rmb_intent/aimed))
		calc_dam += 10
	if(brittle_bonus && HAS_TRAIT(affected, TRAIT_BRITTLE))
		calc_dam += 10
	if(HAS_TRAIT(affected, TRAIT_CRITICAL_RESISTANCE))
		used -= 10

	used += round(damage_dividend * dividend_multi + (calc_dam / damage_divisor), 1)
	return used

/// Override per wound to add post-application effects
/datum/wound/proc/on_crit_applied(obj/item/bodypart/affected, mob/living/user, zone_precise, list/modifiers)
	return

/// Sound that plays when this wound is applied to a mob
/datum/wound/proc/get_sound_effect(mob/living/affected, obj/item/bodypart/affected_bodypart)
	if(critical && prob(3))
		return 'sound/combat/CriticalHit.ogg'
	return pick(sound_effect)

/// Returns whether or not this wound can be applied to a given bodypart
/datum/wound/proc/can_apply_to_bodypart(obj/item/bodypart/affected)
	if(bodypart_owner || owner || QDELETED(affected) || QDELETED(affected.owner))
		return FALSE
	if(!ignore_bloody && !isnull(bleed_rate) && !affected.can_bloody_wound())
		return FALSE
	for(var/datum/wound/other_wound as anything in affected.wounds)
		if(!can_stack_with(other_wound))
			return FALSE
	return TRUE

/// Returns whether or not this wound can be applied while this other wound is present
/datum/wound/proc/can_stack_with(datum/wound/other)
	return TRUE

/// Adds this wound to a given bodypart
/datum/wound/proc/apply_to_bodypart(obj/item/bodypart/affected, silent = FALSE, crit_message = FALSE)
	if(QDELETED(src) || QDELETED(affected) || QDELETED(affected.owner))
		return FALSE
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()
	apply_organ_modifications()
	LAZYADD(affected.wounds, src)
	sortTim(affected.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	affected.update_wounds(FALSE)
	affected.update_limb_efficiency()
	bodypart_owner = affected
	owner = bodypart_owner.owner
	on_bodypart_gain(affected)
	INVOKE_ASYNC(src, PROC_REF(on_mob_gain), affected.owner) //this is literally a fucking lint error like new species cannot possible spawn with wounds until after its ass
	if(crit_message)
		var/message = get_crit_message(affected.owner, affected)
		if(message)
			affected.owner.next_attack_msg += " [message]"
	if(!silent)
		var/sounding = get_sound_effect(affected.owner, affected)
		if(sounding)
			playsound(affected.owner, sounding, 100, vary = FALSE)
	return TRUE

/// Effects when a wound is gained on a bodypart
/datum/wound/proc/on_bodypart_gain(obj/item/bodypart/affected)
	if(bleed_rate && affected.bandage)
		affected.bandage_expire() //new bleeding wounds always expire bandages, fuck you
	if(disabling && affected.can_be_disabled)
		affected.update_disabled()

/// Removes this wound from a given bodypart
/datum/wound/proc/remove_from_bodypart()
	if(!bodypart_owner)
		return FALSE
	remove_organ_modifications()
	var/obj/item/bodypart/was_bodypart = bodypart_owner
	var/mob/living/was_owner = owner
	LAZYREMOVE(bodypart_owner.wounds, src)
	SEND_SIGNAL(was_bodypart, COMSIG_BODYPART_WOUND_REMOVED, src)
	bodypart_owner = null //honestly shouldn't be nulling the owner before calling on loss procs
	owner = null
	on_bodypart_loss(was_bodypart, was_owner)
	on_mob_loss(was_owner)
	was_bodypart.update_wounds(FALSE)
	was_bodypart.update_limb_efficiency()
	return TRUE

/// Effects when a wound is lost on a bodypart
/datum/wound/proc/on_bodypart_loss(obj/item/bodypart/affected, mob/living/affected_mob)
	if(disabling && affected.can_be_disabled)
		affected.update_disabled()

/// Returns whether or not this wound can be applied to a given mob
/datum/wound/proc/can_apply_to_mob(mob/living/affected)
	if(bodypart_owner || owner || QDELETED(affected) || !HAS_TRAIT(affected, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	for(var/datum/wound/other_wound as anything in affected.simple_wounds)
		if(!can_stack_with(other_wound))
			return FALSE
	return TRUE

/// Adds this wound to a given mob
/datum/wound/proc/apply_to_mob(mob/living/affected, silent = FALSE, crit_message = FALSE)
	if(QDELETED(affected) || !HAS_TRAIT(affected, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()

	LAZYADD(affected.simple_wounds, src)
	sortTim(affected.simple_wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	owner = affected
	on_mob_gain(affected)
	if(crit_message)
		var/message = get_crit_message(affected)
		if(message)
			affected.next_attack_msg += " [message]"
	if(!silent)
		var/sounding = get_sound_effect(affected)
		if(sounding)
			playsound(affected, sounding, 100, vary = FALSE)
	return TRUE

/// Effects when this wound is applied to a given mob
/datum/wound/proc/on_mob_gain(mob/living/affected)
	if(mob_overlay)
		affected.update_damage_overlays()
	if(werewolf_infection_timer)
		deltimer(werewolf_infection_timer)
		werewolf_infection_timer = null
		werewolf_infect_attempt()
	if(mortal && HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.death()

/// Removes this wound from a given, simpler than adding to a bodypart - No extra effects
/datum/wound/proc/remove_from_mob()
	if(!owner)
		return FALSE
	on_mob_loss(owner)
	LAZYREMOVE(owner.simple_wounds, src)
	owner = null
	return TRUE

/// Effects when this wound is removed from a given mob
/datum/wound/proc/on_mob_loss(mob/living/affected)
	if(mob_overlay)
		affected.update_damage_overlays()

/// Called on handle_wounds(), on the life() proc
/datum/wound/proc/on_life()
	if(!isnull(clotting_threshold) && clotting_rate && (bleed_rate > clotting_threshold))
		bleed_rate = max(clotting_threshold, bleed_rate - clotting_rate)
	if(passive_healing)
		heal_wound(passive_healing)
	return TRUE

/// Called on handle_wounds(), on the life() proc
/datum/wound/proc/on_death()
	return

/// Heals this wound by the given amount, and deletes it if it's healed completely. Extra args passed to subtypes for checks
/datum/wound/proc/heal_wound(heal_amount, datum/source, forced = FALSE)
	// Wound cannot be healed normally, whp is null
	if(isnull(whp) || (!heal_amount))
		return FALSE
	var/amount_healed = min(whp, round(heal_amount, DAMAGE_PRECISION))
	whp -= amount_healed
	if(whp <= 0)
		if(!forced && !should_persist())
			if(bodypart_owner)
				remove_from_bodypart(src)
			else if(owner)
				remove_from_mob(src)
			else
				qdel(src)
	return amount_healed

// Kinda icky
/// Repeatable step that heals the wound, on the wound for overrides
/datum/wound/proc/do_sewing_step(mob/living/doctor, obj/item/needle/sewing)
	if(!doctor || !sewing || QDELETED(src))
		return FALSE

	while(sew_progress < sew_threshold)
		if(sewing?.stringamt < 1 || QDELETED(src) || QDELETED(owner) || QDELETED(doctor) || QDELETED(sewing))
			return FALSE

		playsound(owner, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)

		if(!do_after(doctor, 5 SECONDS, owner))
			return FALSE

		if(owner)
			log_combat(doctor, owner, "sew wound", sewing)

		sewing_step_complete(doctor, owner)

		sewing?.use(1)

	return TRUE

/datum/wound/proc/sewing_step_complete(mob/living/doctor)
	if(!doctor || QDELETED(src))
		return FALSE

	var/healing_power = (GET_MOB_SKILL_VALUE_OLD(doctor, /datum/attribute/skill/misc/medicine) + 1) * 12.5
	var/was_completed = FALSE

	var/mob/living/patient = owner
	var/obj/item/bodypart/affecting = bodypart_owner

	sew_progress = clamp(round(sew_progress + healing_power), 0, sew_threshold)

	if(sew_progress == sew_threshold)
		sew_wound()
		was_completed = TRUE

	var/modifier = was_completed ? 1.5 : 0.3
	var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_INTELLIGENCE) * modifier
	doctor.adjust_experience(/datum/attribute/skill/misc/medicine, amt2raise * doctor.get_learning_boon(/datum/attribute/skill/misc/medicine))

	var/extra_text

	if(was_completed)
		extra_text = " The wound closes."

	if(patient == doctor)
		doctor.visible_message(span_notice("[doctor] sews \a [name] on [doctor.p_them()]self.[extra_text]"), span_notice("I stitch \a [name] on [affecting ? "my [affecting]" : "myself"].[extra_text]"))
	else
		if(affecting)
			doctor.visible_message(span_notice("[doctor] sews \a [name] on [patient]'s [affecting].[extra_text]"), span_notice("I stitch \a [name] on [patient]'s [affecting].[extra_text]"))
		else
			doctor.visible_message(span_notice("[doctor] sews \a [name] on [patient].[extra_text]"), span_notice("I stitch \a [name] on [patient].[extra_text]"))

	return was_completed

/// Sews the wound up, changing its properties to the sewn ones
/datum/wound/proc/sew_wound()
	if(!can_sew)
		return FALSE
	var/old_overlay = mob_overlay
	mob_overlay = sewn_overlay
	bleed_rate = sewn_bleed_rate
	clotting_rate = sewn_clotting_rate
	clotting_threshold = sewn_clotting_threshold
	woundpain = sewn_woundpain
	whp = min(whp, sewn_whp)
	disabling = FALSE
	can_sew = FALSE
	sleep_healing = max(sleep_healing, 1)
	passive_healing = max(passive_healing, 1)
	if(mob_overlay != old_overlay)
		owner?.update_damage_overlays()
	record_round_statistic(STATS_WOUNDS_SEWED)
	return TRUE

/// Checks if this wound has a special infection (zombie or werewolf)
/datum/wound/proc/has_special_infection()
	return (werewolf_infection_timer)

/// Some wounds cannot go away naturally
/datum/wound/proc/should_persist()
	if(has_special_infection())
		return TRUE
	return FALSE

/// Cauterizes the wound
/datum/wound/proc/cauterize_wound()
	if(!can_cauterize)
		return FALSE
	if(!isnull(clotting_threshold) && bleed_rate > clotting_threshold)
		bleed_rate = clotting_threshold
	heal_wound(40)
	return TRUE

/// Checks if this wound is sewn
/datum/wound/proc/is_sewn()
	return (sew_progress >= sew_threshold)

/// Checks if this wound is clotted
/datum/wound/proc/is_clotted()
	return !isnull(clotting_threshold) && (bleed_rate <= clotting_threshold)

/datum/wound/proc/werewolf_infect_attempt()
	if(QDELETED(src) || QDELETED(owner) || QDELETED(bodypart_owner))
		return FALSE
	if(werewolf_infection_timer || !ishuman(owner) || !prob(werewolf_infection_probability))
		return
	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.can_werewolf())
		return
	if(human_owner.stat >= DEAD) //forget it
		return
	var/static/list/silver_items = list(
		/obj/item/clothing/neck/psycross/silver,
		/obj/item/clothing/neck/silveramulet
	)
	if(is_type_in_list(human_owner.wear_wrists, silver_items) || is_type_in_list(human_owner.wear_neck, silver_items))
		if(prob(50))
			return
	to_chat(human_owner, span_danger("I feel horrible... REALLY horrible..."))
	MOBTIMER_SET(human_owner, MT_PUKE)
	werewolf_infection_timer = addtimer(CALLBACK(src, PROC_REF(wake_werewolf)), werewolf_infection_time, TIMER_STOPPABLE)
	severity = WOUND_SEVERITY_BIOHAZARD
	if(bodypart_owner)
		sortTim(bodypart_owner.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	return TRUE

/datum/wound/proc/wake_werewolf()
	if(QDELETED(src) || QDELETED(owner) || QDELETED(bodypart_owner))
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/human_owner = owner
	var/datum/antagonist/werewolf/wolfy = human_owner.werewolf_check()
	if(!wolfy)
		return FALSE
	werewolf_infection_timer = null
	owner.flash_fullscreen("redflash3")
	to_chat(owner, span_danger("It hurts... Is this really the end for me?"))
	owner.emote("scream") // heres your warning to others bro
	owner.Knockdown(1)
	return wolfy

/// Returns whether or not this wound should embed an item
/datum/wound/proc/should_embed(obj/item/embedder)
	if(!embedder)
		return FALSE
	if(!embedder.can_embed())
		return FALSE
	return prob(embed_chance)
