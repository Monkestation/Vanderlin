/datum/intent
	var/name = "intent"
	var/desc = ""
//	icon = 'icons/mob/roguehud.dmi'		so you can find the icons
	var/icon_state = "instrike"
	var/list/attack_verb = list("hits", "strikes")
	/// Weakref to the item the mastermob is holding
	var/datum/weakref/masteritem
	/// Weakref to the master mob or our holder
	var/datum/weakref/mastermob
	var/unarmed = FALSE
	var/intent_type
	var/animname = "strike"
	var/blade_class = BCLASS_BLUNT
	var/list/hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	var/canparry = TRUE
	var/candodge = TRUE
	var/iparrybonus = 0
	var/idodgebonus = 0
	var/chargetime = 0 //if above 0, this attack must be charged to reach full damage
	var/chargedrain = 0 //how much fatigue is removed every second when at max charge
	var/releasedrain = 1 //drain when we go off, regardless
	var/misscost = 1	//extra drain from missing only, ALSO APPLIED IF ENEMY DODGES
	var/tranged = 0
	var/noaa = FALSE //turns off auto aiming, also turns off the 'swooshes'
	var/warnie = ""
	var/pointer = 'icons/effects/mousemice/human_attack.dmi'
	var/charge_pointer = null // Simple unique charge icon
	var/charged_pointer = null // Simple unique charged icon
	var/clickcd = CLICK_CD_MELEE //the cd invoked clicking on stuff with this intent
	var/list/charge_invocation //list of stuff to say while charging
	var/no_early_release = FALSE //we can't shoot off early
	var/movement_interrupt = FALSE //we cancel charging when changing mob direction, for concentration spells
	var/rmb_ranged = FALSE //we execute a proc with the same name when rmbing at range with no offhand intent selected
	var/tshield = FALSE //probably needed or something
	var/datum/looping_sound/chargedloop = null
	var/keep_looping = TRUE
	var/damfactor = 1 //multiplied by weapon's force for damage
	var/penfactor = 0 //see armor_penetration
	var/knockback = 0 //If the weapon can knockdown with a large endurance difference between players
	var/acc_bonus = 0 //Accuracy bonus to hitting bodyparts
	var/charging_slowdown = 0
	var/warnoffset = 0
	var/swingdelay = 0
	var/no_attack = FALSE //causes a return in /attack() but still allows to be used in attackby(
	var/reach = 1 //In tiles, how far this weapon can reach; 1 for adjacent, which is default
	var/miss_text //THESE ARE FOR UNARMED MISSING ATTACKS
	var/miss_sound //THESE ARE FOR UNARMED MISSING ATTACKS

	var/item_damage_type = "blunt"
	var/move_limit = 0

	var/static/list/bonk_animation_types = list(
		BCLASS_BLUNT,
		BCLASS_SMASH,
		BCLASS_DRILL,
	)
	var/static/list/swipe_animation_types = list(
		BCLASS_CUT,
		BCLASS_CHOP,

	)
	var/static/list/thrust_animation_types = list(
		BCLASS_STAB,
		BCLASS_SHOT,
		BCLASS_PICK,
	)

/datum/intent/Destroy()
	if(chargedloop)
		chargedloop.stop()
	var/mob/master = get_master_mob()
	if(master?.curplaying == src)
		master.curplaying = null
	masteritem = null
	mastermob = null
	return ..()

/// returns the attack animation type this intent uses
/datum/intent/proc/get_attack_animation_type()
	if(blade_class in bonk_animation_types)
		return ATTACK_ANIMATION_BONK
	if(blade_class in swipe_animation_types)
		return ATTACK_ANIMATION_SWIPE
	if(blade_class in thrust_animation_types)
		return ATTACK_ANIMATION_THRUST
	return null

/datum/intent/proc/examine(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b> intent</span>"
	if(desc)
		inspec += "\n[desc]"
	if(reach != 1)
		inspec += "\n<b>Reach:</b> [reach]"
	if(damfactor != 1)
		inspec += "\n<b>Damage:</b> [damfactor]"
	if(penfactor)
		inspec += "\n<b>Armor Penetration:</b> [penfactor]"
	if(get_chargetime())
		inspec += "\n<b>Charge Time</b>"
	if(movement_interrupt)
		inspec += "\n<b>Interrupted by Movement</b>"
	if(no_early_release)
		inspec += "\n<b>No Early Release</b>"
	if(chargedrain)
		inspec += "\n<b>Drain While Charged:</b> [chargedrain]"
	if(releasedrain)
		inspec += "\n<b>Drain On Release:</b> [releasedrain]"
	if(misscost)
		inspec += "\n<b>Drain On Miss:</b> [misscost]"
	if(clickcd != CLICK_CD_MELEE)
		inspec += "\n<b>Recovery Time: </b> "
		if(clickcd < CLICK_CD_MELEE)
			inspec += "Quick"
		if(clickcd > CLICK_CD_MELEE)
			inspec += "Slow"

	return inspec

/datum/intent/proc/get_chargetime()
	if(chargetime)
		return chargetime
	else
		return 0

/datum/intent/proc/get_chargedrain()
	if(chargedrain)
		return chargedrain
	else
		return 0

/datum/intent/proc/get_releasedrain()
	if(releasedrain)
		return releasedrain
	else
		return 0

/datum/intent/proc/parrytime()
	return 0

/datum/intent/proc/prewarning()
	return

/datum/intent/proc/rmb_ranged(atom/target, mob/user)
	return

/datum/intent/proc/can_charge()
	return TRUE

/datum/intent/proc/afterchange()
	var/obj/item/master_item = get_master_item()
	var/mob/master_mob = get_master_mob()
	if(master_item)
		master_item.damage_type = item_damage_type
		var/list/benis = hitsound
		if(benis)
			master_item.hitsound = benis
	if(istype(master_mob, /mob/living/simple_animal))
		var/mob/living/simple_animal/master = master_mob
		master.damage_type = item_damage_type

/datum/intent/proc/height2limb(height as num)
	var/list/returned
	switch(height)
		if(2)
			returned += list(BODY_ZONE_HEAD)
		if(1)
			returned += list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_CHEST)
		if(0)
			returned += list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	return returned

/datum/intent/New(Mastermob, Masteritem)
	. = ..()
	if(Mastermob)
		if(isliving(Mastermob))
			mastermob = WEAKREF(Mastermob)
			if(chargedloop)
				update_chargeloop()
	if(Masteritem)
		masteritem = WEAKREF(Masteritem)

/datum/intent/proc/get_master_item()
	var/obj/item/master = masteritem?.resolve()
	if(!master)
		return
	return master

/datum/intent/proc/get_master_mob()
	var/mob/master = mastermob?.resolve()
	if(!master)
		return
	return master

/datum/intent/proc/update_chargeloop() //what the fuck is going on here lol
	var/mob/master = get_master_mob()
	if(master && chargedloop)
		if(!istype(chargedloop))
			chargedloop = new chargedloop(master)

/datum/intent/proc/on_charge_start() //what the fuck is going on here lol
	var/mob/master = get_master_mob()
	if(!master)
		return
	if(master.curplaying)
		master.curplaying.chargedloop.stop()
		master.curplaying = null
	if(chargedloop)
		if(!istype(chargedloop, /datum/looping_sound))
			chargedloop = new chargedloop(master)
		else
			chargedloop.stop()
		chargedloop.start(chargedloop.parent)
		master.curplaying = src

/datum/intent/proc/on_mouse_up()
	var/mob/master = get_master_mob()
	if(chargedloop)
		chargedloop.stop()
	if(master?.curplaying == src)
		master?.curplaying = null


/datum/intent/use
	name = "use"
	icon_state = "inuse"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH
	item_damage_type = "blunt"

/datum/intent/kick
	name = "kick"
	candodge = TRUE
	canparry = TRUE
	chargetime = 0
	chargedrain = 0
	noaa = FALSE
	swingdelay = 5
	misscost = 20
	unarmed = TRUE
	animname = "kick"
	pointer = 'icons/effects/mousemice/human_kick.dmi'
	item_damage_type = "blunt"

/datum/intent/bite
	name = "bite"
	candodge = TRUE
	canparry = TRUE
	chargedrain = 0
	chargetime = 0
	swingdelay = 0
	unarmed = TRUE
	noaa = FALSE
	attack_verb = list("bites")
	item_damage_type = "stab"

/datum/intent/jump
	name = "jump"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE
	pointer = 'icons/effects/mousemice/human_jump.dmi'

/datum/intent/steal
	name = "steal"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/give
	name = "give"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/looping_sound/invokegen
	mid_sounds = list('sound/magic/charging.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokefire
	mid_sounds = list('sound/magic/charging_fire.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokelightning
	mid_sounds = list('sound/magic/charging_lightning.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokeholy
	mid_sounds = list('sound/magic/holycharging.ogg')
	mid_length = 320
	volume = 100
	extra_range = 3

/datum/looping_sound/flailswing
	mid_sounds = list('sound/combat/wooshes/flail_swing.ogg')
	mid_length = 7
	volume = 100


/datum/intent/hit
	name = "hit"
	icon_state = "instrike"
	attack_verb = list("hit", "strike")
	item_damage_type = "blunt"
	chargetime = 0
	swingdelay = 0

/datum/intent/stab
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stab")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	animname = "stab"
	blade_class = BCLASS_STAB
	item_damage_type = "stab"
	chargetime = 0
	swingdelay = 0

/datum/intent/pick
	name = "pick"
	icon_state = "inpick"
	attack_verb = list("picks","impales")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	item_damage_type = "stab"
	animname = "strike"
	blade_class = BCLASS_PICK
	chargetime = 0
	swingdelay = 3

/datum/intent/drill
	name = "drill"
	icon_state = "inpick"
	attack_verb = list("drills","augers")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	animname = "strike"
	item_damage_type = "stab"
	blade_class = BCLASS_DRILL
	chargetime = 0.3
	swingdelay = 3

/datum/intent/shoot //shooting crossbows or other guns, no parrydrain
	name = "shoot"
	icon_state = "inshoot"
	tranged = 1
	warnie = "aimwarn"
	chargetime = 0.1
	no_early_release = FALSE
	item_damage_type = "stab"
	noaa = TRUE
	charging_slowdown = 2
	warnoffset = 20

/datum/intent/shoot/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

/datum/intent/arc
	name = "arc"
	icon_state = "inarc"
	tranged = 1
	warnie = "aimwarn"
	item_damage_type = "blunt"
	chargetime = 0
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/proc/arc_check()
	return FALSE

/datum/intent/arc/arc_check()
	return TRUE

/datum/intent/arc/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

/datum/intent/simple/headbutt
	name = "headbutt"
	icon_state = "instrike"
	attack_verb = list("headbutts", "rams")
	animname = "smash"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 13
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"
	miss_text = "thrusts their head at nothing!"
	miss_sound = PUNCHWOOSH

/datum/intent/simple/hind_kick
	name = "kick"
	icon_state = "instrike"
	attack_verb = list("kicks", "rams")
	animname = "smash"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 13
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"
	miss_text = "thrusts their legs at nothing!"
	miss_sound = PUNCHWOOSH

/datum/intent/simple/claw
	name = "claw"
	icon_state = "inclaw"
	attack_verb = list("slashes", "claws")
	animname = "claw"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 5
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	item_damage_type = "slash"

/datum/intent/simple/peck
	name = "peck"
	icon_state = "instrike"
	attack_verb = list("pecks", "scratches")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 2
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	miss_text = "pecks the air!"
	item_damage_type = "stab"

/datum/intent/simple/bite
	name = "bite"
	icon_state = "instrike"
	attack_verb = list("bites")
	animname = "bite"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "stab"
	miss_text = "bites the air!"

//Applies no wounds.
/datum/intent/simple/touch
	name = "touch"
	icon_state = "instrike"
	attack_verb = list("grasps", "touches", "taps")
	animname = "blank22"
	blade_class = null
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 25
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE

/datum/intent/unarmed/claw	// defined as attack with some AP
	name = "claw"
	icon_state = "inclaw"
	attack_verb = list("claws", "scratches", "rends", "tears")
	animname = "claw"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	penfactor = 20
	candodge = TRUE
	canparry = TRUE
	miss_text = "claws the air!"
	miss_sound = "blunthwoosh"
	chargetime = 0
	misscost = 5
	releasedrain = 5
	swingdelay = 0
	rmb_ranged = TRUE
	item_damage_type = "slash"

/datum/intent/unarmed/ascendedclaw
	name = "claw"
	icon_state = "inclaw"
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "claw"
	blade_class = BCLASS_CHOP
	hitsound = "genslash"
	penfactor = 131
	damfactor = 40
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_damage_type = "slash"

/datum/intent/simple/sting
	name = "sting"
	icon_state = "instrike"
	attack_verb = list("stings")
	animname = "blank22"
	blade_class = BCLASS_STAB
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 1
	swingdelay = 0
	candodge = FALSE
	canparry = FALSE
	miss_text = "stings the air!"
	item_damage_type = "stab"

/datum/intent/simple/bigbite
	name = "big bite"
	icon_state = "instrike"
	attack_verb = list("gnashes", "viciously bites")
	animname = "bite"
	blade_class = BCLASS_CHOP
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 20
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "stab"
	miss_text = "bites the air!"
	miss_sound = PUNCHWOOSH

/datum/intent/simple/stab
	name = "stab"
	icon_state = "instrike"
	attack_verb = list("impales", "stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 25
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	miss_text = "stabs the air!"
	item_damage_type = "stab"

/datum/intent/simple/axe
	name = "hack"
	icon_state = "instrike"
	attack_verb = list("hacks at", "chops at", "bashes")
	animname = "chop"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "slash"

/datum/intent/simple/spear
	name = "spear"
	icon_state = "instrike"
	attack_verb = list("stabs", "skewers", "bashes")
	animname = "stab"
	blade_class = BCLASS_CUT
	hitsound = list("genthrust", "genstab")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "stab"

/datum/intent/simple/wereclaw
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "claw"
	blade_class = BCLASS_CHOP
	hitsound = "genslash"
	chargetime = 0
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = BLADEWOOSH_LARGE
	item_damage_type = "slash"

/datum/intent/simple/werebite
	name = "bite"
	icon_state = "instrike"
	attack_verb = list("bites")
	animname = "bite"
	blade_class = BCLASS_BITE
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 30
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	miss_text = "bites the air!"
	miss_sound = PUNCHWOOSH
	item_damage_type = "stab"
