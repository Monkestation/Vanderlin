//Largely beneficial effects go here, even if they have drawbacks. An example is provided in Shadow Mend.

/datum/status_effect/shadow_mend
	id = "shadow_mend"
	duration = 30
	alert_type = /atom/movable/screen/alert/status_effect/shadow_mend

/atom/movable/screen/alert/status_effect/shadow_mend
	name = "Shadow Mend"
	desc = ""
	icon_state = "shadow_mend"

/datum/status_effect/shadow_mend/on_apply()
	owner.visible_message("<span class='notice'>Violet light wraps around [owner]'s body!</span>", "<span class='notice'>Violet light wraps around my body!</span>")
	playsound(owner, 'sound/blank.ogg', 50, TRUE)
	return ..()

/datum/status_effect/shadow_mend/tick()
	owner.adjustBruteLoss(-15)
	owner.adjustFireLoss(-15)

/datum/status_effect/shadow_mend/on_remove()
	. = ..()
	owner.visible_message("<span class='warning'>The violet light around [owner] glows black!</span>", "<span class='warning'>The tendrils around you cinch tightly and reap their toll...</span>")
	playsound(owner, 'sound/blank.ogg', 50, TRUE)
	owner.apply_status_effect(STATUS_EFFECT_VOID_PRICE)

/datum/status_effect/void_price
	id = "void_price"
	duration = 300
	tick_interval = 30
	alert_type = /atom/movable/screen/alert/status_effect/void_price

/atom/movable/screen/alert/status_effect/void_price
	name = "Void Price"
	desc = ""
	icon_state = "shadow_mend"

/datum/status_effect/void_price/tick()
	SEND_SOUND(owner, sound('sound/blank.ogg', volume = 25))
	owner.adjustBruteLoss(3)


/datum/status_effect/cyborg_power_regen
	id = "power_regen"
	duration = 100
	alert_type = /atom/movable/screen/alert/status_effect/power_regen
	var/power_to_give = 0 //how much power is gained each tick

/datum/status_effect/cyborg_power_regen/on_creation(mob/living/new_owner, duration_override, new_power_per_tick)
	. = ..()
	if(. && isnum(new_power_per_tick))
		power_to_give = new_power_per_tick

/atom/movable/screen/alert/status_effect/power_regen
	name = "Power Regeneration"
	desc = ""
	icon_state = "power_regen"


/datum/status_effect/wish_granters_gift //Fully revives after ten seconds.
	id = "wish_granters_gift"
	duration = 50
	alert_type = /atom/movable/screen/alert/status_effect/wish_granters_gift

/datum/status_effect/wish_granters_gift/on_apply()
	to_chat(owner, "<span class='notice'>Death is not my end! The Wish Granter's energy suffuses you, and you begin to rise...</span>")
	return ..()

/datum/status_effect/wish_granters_gift/on_remove()
	. = ..()
	owner.revive(ADMIN_HEAL_ALL)
	owner.visible_message("<span class='warning'>[owner] appears to wake from the dead, having healed all wounds!</span>", "<span class='notice'>I have regenerated.</span>")

/atom/movable/screen/alert/status_effect/wish_granters_gift
	name = "Wish Granter's Immortality"
	desc = ""
	icon_state = "wish_granter"

/datum/status_effect/sword_spin
	id = "Bastard Sword Spin"
	duration = 50
	tick_interval = 8
	alert_type = null


/datum/status_effect/sword_spin/on_apply()
	owner.visible_message("<span class='danger'>[owner] begins swinging the sword with inhuman strength!</span>")
	var/oldcolor = owner.color
	owner.color = "#ff0000"
	owner.add_stun_absorption("bloody bastard sword", duration, 2, "doesn't even flinch as the sword's power courses through them!", "You shrug off the stun!", " glowing with a blazing red aura!")
	owner.spin(duration,1)
	animate(owner, color = oldcolor, time = duration, easing = EASE_IN)
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/atom, update_atom_colour)), duration)
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()


/datum/status_effect/sword_spin/tick()
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	var/obj/item/slashy
	slashy = owner.get_active_held_item()
	for(var/mob/living/M in orange(1,owner))
		slashy.attack(M, owner)

/datum/status_effect/sword_spin/on_remove()
	. = ..()
	owner.visible_message("<span class='warning'>[owner]'s inhuman strength dissipates and the sword's runes grow cold!</span>")

//Used by changelings to rapidly heal
//Heals 10 brute and oxygen damage every second, and 5 fire
//Being on fire will suppress this healing
/datum/status_effect/fleshmend
	id = "fleshmend"
	duration = 100
	alert_type = /atom/movable/screen/alert/status_effect/fleshmend

/datum/status_effect/fleshmend/tick()
	if(owner.on_fire)
		linked_alert.icon_state = "fleshmend_fire"
		return
	else
		linked_alert.icon_state = "fleshmend"
	owner.adjustBruteLoss(-10, FALSE)
	owner.adjustFireLoss(-5, FALSE)
	owner.adjustOxyLoss(-10)

/atom/movable/screen/alert/status_effect/fleshmend
	name = "Fleshmend"
	desc = ""
	icon_state = "fleshmend"

/datum/status_effect/exercised
	id = "Exercised"
	duration = 1200
	alert_type = null

/datum/status_effect/exercised/on_creation(mob/living/new_owner, duration_override, ...)
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)
	START_PROCESSING(SSprocessing, src) //this lasts 20 minutes, so SSfastprocess isn't needed.

/datum/status_effect/exercised/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/status_effect/good_music
	id = "Good Music"
	alert_type = null
	duration = 6 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/good_music/tick()
	if(owner.can_hear())
		owner.adjust_dizzy(-4 SECONDS)
		owner.adjust_jitter(-4 SECONDS)
		owner.adjust_confusion(-1 SECONDS)
		owner.add_stress(/datum/stress_event/goodmusic)

/atom/movable/screen/alert/status_effect/regenerative_core
	name = "Regenerative Core Tendrils"
	desc = ""
	icon_state = "regenerative_core"

/datum/status_effect/regenerative_core
	id = "Regenerative Core"
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/regenerative_core

/datum/status_effect/regenerative_core/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)
	owner.adjustBruteLoss(-25)
	owner.adjustFireLoss(-25)
	owner.fully_heal(HEAL_CC_STATUS|HEAL_TEMP)
	owner.bodytemperature = BODYTEMP_NORMAL
	return TRUE

/datum/status_effect/regenerative_core/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)

/datum/status_effect/antimagic
	id = "antimagic"
	duration = 10 SECONDS

/datum/status_effect/antimagic/on_apply()
	owner.visible_message("<span class='notice'>[owner] is coated with a dull aura!</span>")
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))
	//glowing wings overlay
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()

/datum/status_effect/antimagic/get_examine_text()
	return span_notice("They seem to be covered in a dull, grey aura.")

/datum/status_effect/antimagic/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))
	owner.visible_message("<span class='warning'>[owner]'s dull aura fades away...</span>")
