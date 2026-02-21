/mob/living/carbon/human/proc/sire_spawn()
	set name = "Sire Mortal"
	set category = "RoleUnique.Vampire"

	if(!mind)
		return

	if(!clan)
		return
	if(!clan_position?.can_assign_positions)
		to_chat(src, span_warning("I cannot sire..."))
		return

	var/obj/item/grabbing/bite/bite = get_item_by_slot(ITEM_SLOT_MOUTH)
	if(!ishuman(bite?.grabbed) || bite.sublimb_grabbed != BODY_ZONE_PRECISE_NECK)
		to_chat(src, span_warning("I must have someone's neck within my jaws."))
		return
	var/mob/living/carbon/human/victim = bite.grabbed
	if(!(victim.ckey || ckey(victim.last_mind?.key)))
		to_chat(src, span_warning("[victim.p_theyre(TRUE)] too simple to be sired."))
		return
	if(HAS_TRAIT(victim, "offered_vampirism"))
		to_chat(src, span_warning("[victim.p_theyve(TRUE)] already been offered a blessing."))
		return
	var/obj/item/organ/brain/victim_brain = victim.getorgan(/obj/item/organ/brain)
	if(!victim_brain)
		to_chat(src, span_warning("[victim.p_their(TRUE)] brain is gone."))
		return
	if(victim_brain.brain_death)
		to_chat(src, span_warning("[victim.p_their(TRUE)] brain is too damaged."))
		return
	if(victim.blood_volume > BLOOD_VOLUME_BAD)
		to_chat(src, span_warning("[victim.p_their(TRUE)] blood is not thin enough to sire [victim.p_them()]."))
		return
	var/datum/antagonist/zombie/Z = victim.mind.has_antag_datum(/datum/antagonist/zombie)
	if(Z?.revived)
		to_chat(src, span_warning("The dead already walk. This one is the Dark Lady's servant."))
	if(victim.clan || victim.mind.has_antag_datum(/datum/antagonist/vampire))
		to_chat(src, span_warning("[victim] has already been sired."))
		return
	if(victim.mind.has_antag_datum(/datum/antagonist/werewolf))
		to_chat(src, span_warning("[victim] tastes of beast. [victim.p_they()] will not sire."))
		return
	if(stat == DEAD && (world.time - victim.timeofdeath) > 4 MINUTES)
		to_chat(src, span_warning("[victim.p_their(TRUE)] body has gone stiff. Too far gone to sire."))
		return
	if(browser_alert(src, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", list("MAKE IT SO", "I RESCIND")) != "MAKE IT SO")
		to_chat(src, span_warning("I decide [victim] is unworthy."))
		return
	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

/mob/living/carbon/human/proc/vampire_telepathy()
	var/TELEPATHY_COOLDOWN = 30 SECONDS

	set name = "Telepathy"
	set category = "RoleUnique.Vampire"

	if(!mind)
		return

	if(!clan)
		return

	if(world.time < src.last_telepathy_use + TELEPATHY_COOLDOWN)
		var/remaining = round((src.last_telepathy_use + TELEPATHY_COOLDOWN - world.time) / 10, 1)
		to_chat(src, span_warning("You must wait [remaining] seconds before using Telepathy again!"))
		return

	var/msg = browser_input_text(src, "Send a message", "COMMAND", max_length = MAX_MESSAGE_LEN, multiline = TRUE)
	if(!msg)
		return

	if(src.bloodpool > 25)
		src.adjust_bloodpool(-25)
	else
		to_chat(src, span_danger("I don't have enough blood to send a telepathy message!"))
		return

	// set cooldown
	src.last_telepathy_use = world.time

	var/message = span_narsie("<B>A message from <span style='color:#[voice_color]'>[real_name]</span>: [msg]</B>")
	to_chat(clan?.clan_members, message)

/mob/living/carbon/human/proc/disguise_button()
	set name = "Disguise"
	set category = "RoleUnique.Vampire"

	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	if(!disguise_comp)
		to_chat(src, span_warning("I cannot disguise myself."))
		return

	if(disguise_comp.disguised)
		disguise_comp.remove_disguise(src)
	else
		disguise_comp.apply_disguise(src)

/mob/living/carbon/human/proc/vampire_disguise(datum/antagonist/vampire/VD)
	if(clan)
		return
	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	disguise_comp.apply_disguise(src)

/mob/living/carbon/human/proc/vampire_undisguise(datum/antagonist/vampire/VD)
	if(clan)
		return
	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	disguise_comp.remove_disguise(src)


/mob/living/carbon/human/proc/blood_strength()
	set name = "Night Muscles"
	set category = "RoleUnique.Vampire"

	if(!clan)
		return
	if(SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))
		to_chat(src, span_warning("My curse is hidden."))
		return
	if(bloodpool < 500)
		to_chat(src, span_warning("Not enough vitae."))
		return


	// Gain experience towards blood magic
	var/mob/living/carbon/human/licker = usr
	var/boon = usr.get_learning_boon(/datum/skill/magic/blood)
	var/amt2raise = licker.STAINT*2
	usr.adjust_experience(/datum/skill/magic/blood, floor(amt2raise * boon), FALSE)
	adjust_bloodpool(-500)
	apply_status_effect(/datum/status_effect/buff/bloodstrength)
	to_chat(src, "<span class='greentext'>! NIGHT MUSCLES !</span>")
	src.playsound_local(get_turf(src), 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/status_effect/buff/bloodstrength
	id = "bloodstrength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bloodstrength
	effectedstats = list(STATKEY_STR = 6)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/bloodstrength
	name = "Night Muscles"
	desc = ""
	icon_state = "bleed1"

/mob/living/carbon/human/proc/blood_celerity()
	set name = "Quickening"
	set category = "RoleUnique.Vampire"

	if(!clan)
		return
	if(SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))
		to_chat(src, "<span class='warning'>My curse is hidden.</span>")
		return
	if(bloodpool < 500)
		to_chat(src, "<span class='warning'>Not enough vitae.</span>")
		return

	// Gain experience towards blood magic
	var/mob/living/carbon/human/licker = usr
	var/boon = usr.get_learning_boon(/datum/skill/magic/blood)
	var/amt2raise = licker.STAINT*2
	usr.adjust_experience(/datum/skill/magic/blood, floor(amt2raise * boon), FALSE)
	adjust_bloodpool(-500)
	apply_status_effect(/datum/status_effect/buff/celerity)
	to_chat(src, "<span class='greentext'>! QUICKENING !</span>")
	src.playsound_local(get_turf(src), 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)


/datum/status_effect/buff/celerity
	id = "celerity"
	alert_type = /atom/movable/screen/alert/status_effect/buff/celerity
	effectedstats = list(STATKEY_SPD = 15, STATKEY_PER = 10)
	duration = 30 SECONDS

/datum/status_effect/buff/celerity/nextmove_modifier()
	return 0.60

/atom/movable/screen/alert/status_effect/buff/celerity
	name = "Quickening"
	desc = ""
	icon_state = "bleed1"

/mob/living/carbon/human/proc/blood_fortitude()
	set name = "Armor of Darkness"
	set category = "RoleUnique.Vampire"

	if(clan)
		return
	if(SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))
		to_chat(src, "<span class='warning'>My curse is hidden.</span>")
		return
	if(bloodpool < 500)
		to_chat(src, "<span class='warning'>Not enough vitae.</span>")
		return

	// Gain experience towards blood magic
	var/mob/living/carbon/human/licker = usr
	var/boon = usr.get_learning_boon(/datum/skill/magic/blood)
	var/amt2raise = licker.STAINT*2
	usr.adjust_experience(/datum/skill/magic/blood, floor(amt2raise * boon), FALSE)
	adjust_bloodpool(-500)
	apply_status_effect(/datum/status_effect/buff/fortitude)
	to_chat(src, "<span class='greentext'>! ARMOR OF DARKNESS !</span>")
	src.playsound_local(get_turf(src), 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)


/datum/status_effect/buff/fortitude
	id = "fortitude"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortitude
	effectedstats = list(STATKEY_END = 20, STATKEY_CON = 20)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/fortitude
	name = "Armor of Darkness"
	desc = ""
	icon_state = "bleed1"

/datum/status_effect/buff/fortitude/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		QDEL_NULL(H.skin_armor)
		H.skin_armor = new /obj/item/clothing/armor/skin_armor/vampire_fortitude(H)
	owner.add_stress(/datum/stress_event/weed)

/datum/status_effect/buff/fortitude/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(istype(H.skin_armor, /obj/item/clothing/armor/skin_armor/vampire_fortitude))
			QDEL_NULL(H.skin_armor)
	. = ..()

/obj/item/clothing/armor/skin_armor/vampire_fortitude
	slot_flags = null
	name = "vampire's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100,  "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = TRUE
	resistance_flags = INDESTRUCTIBLE


