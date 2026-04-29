//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want


/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)

/* Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 * category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 * path is a type path of the actual alert type to throw
 * severity is an optional number that will be placed at the end of the icon_state for this alert
 * For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 * new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 * Clicks are forwarded to master
 * Override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */

	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return 0
		var/obj/old_master = thealert.master_ref?.resolve()
		if(new_master && new_master != old_master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [old_master]")
			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.mob_viewer = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.plane = FLOAT_PLANE
		thealert.add_overlay(new_master)
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "status" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master_ref = WEAKREF(new_master)
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)
	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/atom/movable/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "status"
	name = "Alert"
	desc = ""
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = "rogue"
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/mob_viewer //the mob viewing this alert
	var/alert_group = ALERT_STATUS //decides where on the screen the alert shows up, if it's a debuff, status effect, or buff
	no_over_text = FALSE

/atom/movable/screen/alert/MouseEntered(location,control,params)
	..()
//	if(!QDELETED(src))
//		openToolTip(usr,src,params,title = name,content = desc,theme = alerttooltipstyle)


/atom/movable/screen/alert/MouseExited()
	..()
//	closeToolTip(usr)


//Gas alerts
/atom/movable/screen/alert/not_enough_oxy
	name = "Choking"
	desc = ""
	icon_state = "not_enough_oxy"

/atom/movable/screen/alert/too_much_oxy
	name = "Choking (O2)"
	desc = ""
	icon_state = "too_much_oxy"

/atom/movable/screen/alert/not_enough_nitro
	name = "Choking (No N2)"
	desc = ""
	icon_state = "not_enough_nitro"

/atom/movable/screen/alert/too_much_nitro
	name = "Choking (N2)"
	desc = ""
	icon_state = "too_much_nitro"

/atom/movable/screen/alert/not_enough_co2
	name = "Choking (No CO2)"
	desc = ""
	icon_state = "not_enough_co2"

/atom/movable/screen/alert/too_much_co2
	name = "Choking (CO2)"
	desc = ""
	icon_state = "too_much_co2"

/atom/movable/screen/alert/not_enough_tox
	name = "Choking (No Plasma)"
	desc = ""
	icon_state = "not_enough_tox"

/atom/movable/screen/alert/too_much_tox
	name = "Choking (Plasma)"
	desc = ""
	icon_state = "too_much_tox"
//End gas alerts


/atom/movable/screen/alert/fat
	name = "Fat"
	desc = ""
	icon_state = "fat"

/atom/movable/screen/alert/hungry
	name = "Hungry"
	desc = ""
	icon_state = "hungry"

/atom/movable/screen/alert/starving
	name = "Starving"
	desc = ""
	icon_state = "starving"

/atom/movable/screen/alert/gross
	name = "Grossed out."
	desc = ""
	icon_state = "gross"

/atom/movable/screen/alert/verygross
	name = "Very grossed out."
	desc = ""
	icon_state = "gross2"

/atom/movable/screen/alert/disgusted
	name = "DISGUSTED"
	desc = ""
	icon_state = "gross3"

/atom/movable/screen/alert/status_effect/debuff/hot
	name = "Too Hot"
	desc = ""
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/debuff/cold
	name = "Too Cold"
	desc = ""
	icon_state = "debuff"

/atom/movable/screen/alert/lowpressure
	name = "Low Pressure"
	desc = ""
	icon_state = "lowpressure"

/atom/movable/screen/alert/highpressure
	name = "High Pressure"
	desc = ""
	icon_state = "highpressure"

/atom/movable/screen/alert/hypnosis
	name = "Hypnosis"
	desc = ""
	icon_state = "hypnosis"
	var/phrase

/atom/movable/screen/alert/mind_control
	name = "Mind Control"
	desc = ""
	icon_state = "mind_control"
	var/command

/atom/movable/screen/alert/mind_control/Click()
	..()
	var/mob/living/L = usr
	to_chat(L, "<span class='mind_control'>[command]</span>")

/atom/movable/screen/alert/drunk //Not implemented
	name = "Drunk"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/embeddedobject
	name = "Embedded Objects"
	desc = ""
	icon_state = "embeddedobject"

/atom/movable/screen/alert/embeddedobject/Click()
	if(!..())
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			var/list/msg = list("***\n")
			for(var/obj/item/bodypart/BP as anything in H.bodyparts)
				for(var/obj/item/I as anything in BP.embedded_objects)
					msg += "<a href='byond://?src=[REF(H)];embedded_object=[REF(I)];embedded_limb=[REF(BP)]' class='warning'>[I] - [BP.name]</a>\n"
			msg += "***"
			to_chat(H, "[msg.Join()]")

/atom/movable/screen/alert/weightless
	name = "Weightless"
	desc = ""
	icon_state = "weightless"

/atom/movable/screen/alert/highgravity
	name = "High Gravity"
	desc = ""
	icon_state = "paralysis"

/atom/movable/screen/alert/veryhighgravity
	name = "Crushing Gravity"
	desc = ""
	icon_state = "paralysis"

/atom/movable/screen/alert/fire
	name = "On Fire"
	desc = ""
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	..()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(!HAS_TRAIT(L, TRAIT_IMMOBILIZED))
		return L.resist_fire() //I just want to start a flame in your hearrrrrrtttttt.

//Ethereal

/atom/movable/screen/alert/etherealcharge
	name = "Low Blood Charge"
	desc = ""
	icon_state = "etherealcharge"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/atom/movable/screen/alert/notify_cloning
	name = "Revival"
	desc = ""
	icon_state = "template"
	timeout = 300

/atom/movable/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client)
		return
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/alert/notify_action
	name = "Body created"
	desc = ""
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	..()
	if(!usr || !usr.client)
		return
	if(!target)
		return
	var/mob/dead/observer/G = usr
	if(!istype(G))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(G)
		if(NOTIFY_JUMP)
			var/turf/T = get_turf(target)
			if(T && isturf(T))
				G.forceMove(T)
		if(NOTIFY_ORBIT)
			G.ManualFollow(target)

//OBJECT-BASED

/atom/movable/screen/alert/restrained/buckled
	name = "Buckled"
	desc = ""
	icon_state = "buckled"

/atom/movable/screen/alert/restrained/handcuffed
	name = "Restrained (arms)"
	desc = ""
	icon_state = "restrained"

/atom/movable/screen/alert/restrained/legcuffed
	name = "Restrained (legs)"
	desc = ""
	icon_state = "restrained"

/atom/movable/screen/alert/restrained/Click()
	..()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(!HAS_TRAIT(L, TRAIT_IMMOBILIZED) && (L.last_special <= world.time))
		return L.resist_restraints()

/atom/movable/screen/alert/restrained/buckled/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	if(!L.buckled)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		if(L.resist_buckle())
			L.set_resting(FALSE, FALSE)

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= alerts.len, i++)
			mymob.client.screen -= alerts[alerts[i]]
		return 1
	var/list/buffs = list()
	var/list/debuffs = list()
	var/list/status_effects = list()
	for(var/i = 1, i <= alerts.len, i++)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
//		if(alert.icon_state == "template")
//			alert.icon = ui_style
		switch(alert.alert_group)
			if(ALERT_STATUS)
				status_effects += alert
				switch(status_effects.len)
					if(1)
						. = ui_alert1
					if(2)
						. = ui_alert2
					if(3)
						. = ui_alert3
					if(4)
						. = ui_alert4
					if(5)
						. = ui_alert5
					if(6)
						. = ui_alert6
					if(7)
						. = ui_alert7
					if(8)
						. = ui_alert8
					if(9)
						. = ui_alert9
					if(10)
						. = ui_alert10
					else
						. = ""
			if(ALERT_BUFF)
				buffs += alert
				switch(buffs.len)
					if(1)
						. = ui_balert1
					if(2)
						. = ui_balert2
					if(3)
						. = ui_balert3
					if(4)
						. = ui_balert4
					if(5)
						. = ui_balert5
					if(6)
						. = ui_balert6
					if(7)
						. = ui_balert7
					if(8)
						. = ui_balert8
					if(9)
						. = ui_balert9
					if(10)
						. = ui_balert10
					else
						. = ""
			if(ALERT_DEBUFF)
				debuffs += alert
				switch(debuffs.len)
					if(1)
						. = ui_dalert1
					if(2)
						. = ui_dalert2
					if(3)
						. = ui_dalert3
					if(4)
						. = ui_dalert4
					if(5)
						. = ui_dalert5
					if(6)
						. = ui_dalert6
					if(7)
						. = ui_dalert7
					if(8)
						. = ui_dalert8
					if(9)
						. = ui_dalert9
					if(10)
						. = ui_dalert10
					else
						. = ""
		alert.screen_loc = .
		mymob.client.screen |= alert
	return 1

/atom/movable/screen/alert/Destroy()
	severity = 0
	mob_viewer = null
	screen_loc = ""
	return ..()
