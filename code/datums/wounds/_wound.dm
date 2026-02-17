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

	/// Overlay to use when this wound is applied to a carbon mob
	var/mob_overlay = "w1"
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
/datum/wound/proc/get_check_name(mob/user)
	return check_name

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
	LAZYADD(affected.wounds, src)
	sortTim(affected.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
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
	var/obj/item/bodypart/was_bodypart = bodypart_owner
	var/mob/living/was_owner = owner
	LAZYREMOVE(bodypart_owner.wounds, src)
	bodypart_owner = null //honestly shouldn't be nulling the owner before calling on loss procs
	owner = null
	on_bodypart_loss(was_bodypart, was_owner)
	on_mob_loss(was_owner)
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

/// Heals this wound by the given amount, and deletes it if it's healed completely
/datum/wound/proc/heal_wound(heal_amount)
	// Wound cannot be healed normally, whp is null
	if(isnull(whp) || !heal_amount)
		return FALSE
	var/amount_healed = min(whp, round(heal_amount, DAMAGE_PRECISION))
	whp -= amount_healed
	if(whp <= 0)
		if(!should_persist())
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

	var/healing_power = (doctor.get_skill_level(/datum/skill/misc/medicine, TRUE) + 1) * 12.5
	var/was_completed = FALSE

	var/mob/living/patient = owner
	var/obj/item/bodypart/affecting = bodypart_owner

	sew_progress = clamp(round(sew_progress + healing_power), 0, sew_threshold)

	if(sew_progress == sew_threshold)
		sew_wound()
		was_completed = TRUE

	var/modifier = was_completed ? 1.5 : 0.3
	var/amt2raise = doctor.STAINT * modifier
	doctor.adjust_experience(/datum/skill/misc/medicine, amt2raise * doctor.get_learning_boon(/datum/skill/misc/medicine))

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
	human_owner.vomit(1, blood = TRUE, stun = FALSE)
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

/datum/wound/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html>
		<head>
			<link rel="stylesheet" type="text/css" href="slop_menustyle2.css">
		</head>
		<body>
			<div class='book'>
				<div class='page'>
					<h1>[name]</h1>
					<div class='info'>
	"}
	if(desc)
		html += "<p class='step-desc'>[desc]</p>"

	var/severity_text = "Unknown"
	var/severity_color = "white"
	switch(severity)
		if(WOUND_SEVERITY_LIGHT)
			severity_text = "Light"
			severity_color = "green"
		if(WOUND_SEVERITY_MODERATE)
			severity_text = "Moderate"
			severity_color = "yellow"
		if(WOUND_SEVERITY_SEVERE)
			severity_text = "Severe"
			severity_color = "orange"
		if(WOUND_SEVERITY_CRITICAL)
			severity_text = "Critical"
			severity_color = "red"
		if(WOUND_SEVERITY_BIOHAZARD)
			severity_text = "BIOHAZARD"
			severity_color = "purple"

	html += "<div class='brew-time' style='color: [severity_color];'><b>Severity: [severity_text]</b></div>"

	if(critical)
		html += "<div style='color: red;'><b>CRITICAL WOUND</b></div>"
	if(mortal)
		html += "<div style='color: darkred;'><b>MORTAL WOUND</b></div>"
	if(disabling)
		html += "<div style='color: orange;'><b>DISABLING WOUND</b></div>"

	html += "<div class='section'><h2>Treatment Options</h2>"
	var/list/treatments = list()
	if(can_sew)
		treatments += "Can be sewn shut ([sew_threshold] sewing progress required)"
	if(can_cauterize)
		treatments += "Can be cauterized (heals 40 WHP, stops bleeding to threshold)"
	if(!length(treatments))
		treatments += "No special treatments available"
	for(var/treatment in treatments)
		html += "• [treatment]<br>"
	html += "</div>"

	html += "<h2>Wound Information</h2>"

	html += "<div class='section'>"
	html += "<b>Wound Health Points:</b> [whp]<br>"
	if(can_sew)
		html += "<b>Health After Sewing:</b> [sewn_whp]<br>"
	if(passive_healing)
		html += "<b>Passive Healing:</b> [passive_healing] per heartbeat<br>"
	if(sleep_healing)
		html += "<b>Sleep Healing:</b> [sleep_healing] per heartbeat<br>"
	html += "</div>"

	if(!isnull(bleed_rate))
		html += "<div class='section'><h2>Bleeding</h2>"
		html += "<b>Bleed Rate:</b> [bleed_rate]<br>"
		if(can_sew)
			html += "<b>Bleed Rate (Sewn):</b> [sewn_bleed_rate]<br>"
		if(clotting_rate)
			html += "<b>Clotting Rate:</b> [clotting_rate] per heartbeat<br>"
			if(!isnull(clotting_threshold))
				html += "<b>Clots Down To:</b> [clotting_threshold]<br>"
		if(can_sew && sewn_clotting_rate)
			html += "<b>Clotting Rate (Sewn):</b> [sewn_clotting_rate] per heartbeat<br>"
			if(!isnull(sewn_clotting_threshold))
				html += "<b>Clots Down To (Sewn):</b> [sewn_clotting_threshold]<br>"
		html += "</div>"

	if(woundpain)
		html += "<div class='section'><h2>Pain</h2>"
		html += "<b>Pain Level:</b> [woundpain]<br>"
		if(can_sew && sewn_woundpain != woundpain)
			html += "<b>Pain Level (Sewn):</b> [sewn_woundpain]<br>"
		html += "</div>"

	var/list/special_props = list()
	if(embed_chance)
		special_props += "Can embed weapons ([embed_chance]% chance)"
	if(werewolf_infection_probability)
		special_props += "Can cause werewolf infection ([werewolf_infection_probability]% chance)"
	if(qdel_on_droplimb)
		special_props += "Removed when limb is severed"

	if(length(special_props))
		html += "<div class='section'><h2>Special Properties</h2>"
		for(var/prop in special_props)
			html += "[prop]<br>"
		html += "</div>"

	if(check_name)
		html += "<div class='section'><h2>When checked with medical tools</h2>"
		html += "\"[check_name]\"<br>"
		html += "</div>"

	html += {"
				</div>
			</div>
		</body>
		</html>
	"}

	return html

/datum/wound/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=wound;size=600x900")

/// Basis for dynamic wounds that increase in severity with damage
/datum/wound/dynamic
	abstract_type = /datum/wound/dynamic
	clotting_rate = 0.4
	/// Has reached the maximum level
	var/is_maxed = FALSE
	/// Has reached the maximum level clamped by armor
	var/is_armor_maxed = FALSE
	/// Assoc list, name to severity ie ("lethal" = 15) by default uses bleed rate but can be overriden
	var/list/severity_names = list()

	// Upgrade vars
	// Damage is used to increase each value by a multiplier
	/// Multiplier that bleeding is increased by possibly clamped by bleed_clamp and bleed_clamp_armor
	var/upgrade_bleed_rate = 0
	/// Bleeding clamp upgrade per level
	var/upgrade_bleed_clamp = null
	/// Bleeding clamp when armored per level
	var/upgrade_bleed_clamp_armor = null
	/// Full clamp to bleed when effective armour is on the wounded limb
	var/protected_bleed_clamp = null

	/// Multiplier that whp increased by
	var/upgrade_whp = 0
	/// Multiplier that sew threshold is increased by
	var/upgrade_sew_threshold = 0
	/// Multiplier that wound pain is increased by
	var/upgrade_pain = 0

/datum/wound/dynamic/heal_wound(heal_amount)
	. = ..()
	if(!. || QDELETED(src))
		return
	var/healing_multiplier = clamp(1 / get_relevant_increase(), 0.5, 1.5)
	var/healing_amount = round(heal_amount, DAMAGE_PRECISION) * 0.01 * healing_multiplier

	downgrade(healing_amount)

/datum/wound/dynamic/sew_wound()
	if(!can_sew)
		return FALSE
	sewn_bleed_rate = round(bleed_rate * 0.05, DAMAGE_PRECISION)
	sewn_whp = round(whp * 0.45, DAMAGE_PRECISION)
	sewn_clotting_rate = round(clotting_rate * 1.2, DAMAGE_PRECISION)
	sewn_clotting_threshold = round(clotting_threshold * 0.45, DAMAGE_PRECISION)
	sewn_woundpain = round(woundpain * 0.4, DAMAGE_PRECISION)
	return ..()

/datum/wound/dynamic/sewing_step_complete(mob/living/doctor)
	if(!doctor)
		return

	// Inverse, bigger wound = less heal
	// BUT only effects value reduction not sewing progress
	var/healing_multiplier = clamp(1 / get_relevant_increase(), 0.5, 1.5)
	// Reduces the upgrade values by this percentage, can never fully deplete the said values
	var/healing_power = 0.03 * healing_multiplier * ((doctor.get_skill_level(/datum/skill/misc/medicine, TRUE) + 1) * 1.4) // Vibe numbers...

	downgrade(healing_power)

	return ..()

/// Get the increase multiplier of the relevant upgrade value (bleed_rate by default)
/datum/wound/dynamic/proc/get_relevant_increase()
	if(!bleed_rate || !initial(bleed_rate))
		return 1
	return bleed_rate / initial(bleed_rate)

/// Update name based on severity
/datum/wound/dynamic/proc/update_name()
	var/prefix
	for(var/sevname in severity_names)
		if(severity_names[sevname] <= bleed_rate)
			prefix = sevname
	name = "[prefix ? "[prefix] " : ""][initial(name)]"	//[adjective] [name], aka, "gnarly slash" or "slash"

#define CLOT_THRESHOLD_INCREASE_PER_HIT 0.1	//This raises the MINIMUM bleed the wound can clot to.
#define CLOT_DECREASE_PER_HIT 0.05	//This reduces the amount of clotting the wound has.

/// Upgrades a wound's stats based on damage dealt.
/datum/wound/dynamic/proc/upgrade(bclass, damage)
	SHOULD_CALL_PARENT(TRUE)

	if(is_maxed || is_sewn())
		return FALSE

	var/obj/item/clothing/armor
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		armor = human_owner.check_crit_armor(src, bclass)

	// Ass code we need diseases
	if(!armor && werewolf_infection_timer)
		deltimer(werewolf_infection_timer)
		werewolf_infection_timer = null
		werewolf_infect_attempt()

	var/upper_clamp = ARTERY_LIMB_BLEEDRATE
	if(armor && upgrade_bleed_clamp_armor)
		upper_clamp = upgrade_bleed_clamp_armor
	else if(upgrade_bleed_clamp)
		upper_clamp = upgrade_bleed_clamp
	bleed_rate += clamp(damage * upgrade_bleed_rate, 0.1, upper_clamp)
	whp += damage * upgrade_whp
	sew_threshold += damage * upgrade_sew_threshold
	woundpain += damage * upgrade_pain

	if(armor_check(armor))
		return FALSE

	if(maxed_check())
		is_maxed = TRUE
		return TRUE

	update_name()

	if(clotting_rate)
		clotting_rate = max(0.01, (clotting_rate - CLOT_DECREASE_PER_HIT))
	if(clotting_threshold)
		clotting_threshold += CLOT_THRESHOLD_INCREASE_PER_HIT

	return TRUE

#undef CLOT_THRESHOLD_INCREASE_PER_HIT
#undef CLOT_DECREASE_PER_HIT

/// Like upgrade() but takes a multipler as percentage to decrease values by instead
/datum/wound/dynamic/proc/downgrade(multiplier)
	if(is_sewn())
		return // All these values get changed at this point so additional modifiers aren't required

	whp = max(whp - (whp * multiplier), initial(whp))

	if(sew_threshold > 0)
		sew_threshold = max(sew_threshold - (sew_threshold * multiplier), initial(sew_threshold))
	if(woundpain > 0)
		woundpain = max(woundpain - (woundpain * multiplier), initial(woundpain))
	if(bleed_rate > 0)
		var/clamp = initial(bleed_rate)
		if(!isnull(clotting_threshold) && clotting_threshold < clamp)
			clamp = clotting_threshold
		bleed_rate = max(bleed_rate - (bleed_rate * multiplier), clamp)

	update_name()

#define CLOT_RATE_ARTERY 0	//Artery exceptions. Essentially overrides the clotting threshold.
#define CLOT_THRESHOLD_ARTERY 2

/// Check if the wound is maxed out, by default uses bleeding rate but something like a hemotoma might want to change that
/datum/wound/dynamic/proc/maxed_check()
	if(bleed_rate < ARTERY_LIMB_BLEEDRATE)
		return FALSE
	bleed_rate = ARTERY_LIMB_BLEEDRATE
	clotting_rate = CLOT_RATE_ARTERY
	clotting_threshold = CLOT_THRESHOLD_ARTERY
	playsound(owner, 'sound/combat/wound_tear.ogg', 100, TRUE)
	owner.visible_message(
		span_crit("The wound gushes open from [bodypart_owner.owner]'s \
		<b>[bodypart_owner]</b>, nicking an artery!")
	)
	update_name()
	return TRUE

#undef CLOT_RATE_ARTERY
#undef CLOT_THRESHOLD_ARTERY

/datum/wound/dynamic/proc/armor_check(obj/item/clothing/armor)
	if(!armor || isnull(protected_bleed_clamp))
		is_armor_maxed = FALSE
		return FALSE
	if(bleed_rate < protected_bleed_clamp)
		return FALSE
	bleed_rate = protected_bleed_clamp
	if(is_armor_maxed)
		return TRUE
	playsound(owner, 'sound/combat/armored_wound.ogg', 100, TRUE)
	owner.visible_message(
		span_crit("The wound tears open from [bodypart_owner.owner]'s \
		<b>[bodypart_owner]</b>, but [bodypart_owner.p_their()] [armor] won't let it go any further!")
	)
	is_armor_maxed = TRUE
	update_name()
	return TRUE
