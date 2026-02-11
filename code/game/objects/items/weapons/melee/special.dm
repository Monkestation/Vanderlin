/obj/item/weapon/lordscepter
	name = "master's rod"
	desc = "Bend the knee."
	icon_state = "scepter"
	icon = 'icons/roguetown/weapons/32/special.dmi'
	force = DAMAGE_MACE
	force_wielded = DAMAGE_MACE
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(/datum/intent/lordbash, /datum/intent/lord_electrocute, /datum/intent/lord_silence)
	gripped_intents = list(/datum/intent/lordbash)
	minstr = 5

	sharpness = IS_BLUNT
	//dropshrink = 0.75
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = FIRE_PROOF|LAVA_PROOF|ACID_PROOF // Nigh indestructible due to how important it is
	associated_skill = /datum/skill/combat/axesmaces
	smeltresult = null // No
	melting_material = null
	swingsound = BLUNTWOOSH_MED
	blade_dulling = DULLING_BASHCHOP
	var/static/list/rod_jobs = null
	COOLDOWN_DECLARE(scepter)

	grid_height = 96
	grid_width = 32

/datum/intent/lordbash
	name = "bash"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	penfactor = 10
	item_damage_type = "blunt"

/datum/intent/lord_electrocute
	name = "electrocute"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/datum/intent/lord_silence
	name = "silence"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/obj/item/weapon/lordscepter/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -7,"nx" = 11,"ny" = -6,"wx" = -1,"wy" = -6,"ex" = 3,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -1,"sy" = -4,"nx" = 1,"ny" = -3,"wx" = -1,"wy" = -6,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 20,"wturn" = 18,"eturn" = -19,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 4,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/weapon/lordscepter/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	user.changeNext_move(CLICK_CD_MELEE)


	if(ishuman(user))
		var/mob/living/carbon/human/HU = user

		if(!is_lord_job(HU.mind?.assigned_role))
			to_chat(user, "<span class='danger'>The rod doesn't obey me.</span>")
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target

			user.visible_message("<span class='warning'>[user] points [src] at [target].</span>")

			if(H == HU)
				return

			if(H.can_block_magic(MAGIC_RESISTANCE))
				return

			if(!rod_jobs)
				rod_jobs = GLOB.noble_positions | GLOB.garrison_positions | list(
				/datum/job/jester::title,
				/datum/job/servant::title,
				/datum/job/adventurer/courtagent::title,
				/datum/job/butler::title,
				/datum/job/squire::title,
			)

			if(!((H.mind?.assigned_role.title in rod_jobs)))
				return

			if(!COOLDOWN_FINISHED(src, scepter))
				to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, scepter) / 10, 1)] seconds left!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_electrocute))
				HU.visible_message(span_warning("[HU] electrocutes [H] with \the [src]."))
				user.Beam(target, icon_state = "lightning[rand(1, 12)]", time = 0.5 SECONDS) // LIGHTNING
				playsound(user, 'sound/magic/lightningshock.ogg', 70, TRUE)
				H.electrocute_act(5, src)
				HU.log_message("has shocked [H.real_name] with the [src]!", LOG_ATTACK)
				to_chat(H, span_danger("I'm electrocuted by the scepter!"))
				COOLDOWN_START(src, scepter, 20 SECONDS)
				return

			if(istype(user.used_intent, /datum/intent/lord_silence))
				HU.visible_message(span_warning("[HU] silences [H] with \the [src]."))
				H.set_silence(20 SECONDS)
				HU.log_message("has silenced [H.real_name] with the [src]!", LOG_ATTACK)
				to_chat(H, span_danger("I'm silenced by the scepter!"))
				COOLDOWN_START(src, scepter, 10 SECONDS)
				return

/obj/item/weapon/mace/stunmace
	name = "stunmace"
	icon = 'icons/roguetown/weapons/32/special.dmi'
	icon_state = "stunmace0"
	desc = "A dwarven invention, a mace that bears tiny soul-gems that imbue the crown of the mace with lightning mana."
	force = DAMAGE_CLUB
	force_wielded = DAMAGE_CLUB
	wdefense = BAD_PARRY
	wbalance = DODGE_CHANCE_NORMAL
	possible_item_intents = list(/datum/intent/mace/strike/stunner, /datum/intent/mace/smash/stunner)
	gripped_intents = null
	minstr = 5
	w_class = WEIGHT_CLASS_NORMAL
	var/charge = 100
	var/on = FALSE

/datum/intent/mace/strike/stunner/afterchange()
	var/obj/item/weapon/mace/stunmace/I = get_master_item()
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/datum/intent/mace/smash/stunner/afterchange()
	var/obj/item/weapon/mace/stunmace/I = get_master_mob()
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/obj/item/weapon/mace/stunmace/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/mace/stunmace/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/mace/stunmace/funny_attack_effects(mob/living/target, mob/living/user, nodmg)
	. = ..()
	if(on)
		target.electrocute_act(5, src)
		charge -= 33
		if(charge <= 0)
			on = FALSE
			charge = 0
			update_appearance(UPDATE_ICON_STATE)
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()

/obj/item/weapon/mace/stunmace/update_icon_state()
	. = ..()
	icon_state = "stunmace[on]"

/obj/item/weapon/mace/stunmace/attack_self(mob/user, list/modifiers)
	if(on)
		on = FALSE
	else
		if(charge <= 33)
			to_chat(user, "<span class='warning'>It's out of mana.</span>")
			return
		user.visible_message("<span class='warning'>[user] flicks [src] on.</span>")
		on = TRUE
		charge--
	playsound(user, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	update_appearance(UPDATE_ICON_STATE)
	add_fingerprint(user)

/obj/item/weapon/mace/stunmace/process()
	if(on)
		charge--
	else
		if(charge < 100)
			charge++
	if(charge <= 0)
		on = FALSE
		charge = 0
		update_appearance(UPDATE_ICON_STATE)
		var/mob/user = loc
		if(istype(user))
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

/obj/item/weapon/mace/stunmace/extinguish()
	if(on)
		var/mob/living/user = loc
		if(istype(user))
			user.electrocute_act(5, src)
		on = FALSE
		charge = 0
		update_appearance(UPDATE_ICON_STATE)
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 10
	item_damage_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 30
	chargetime = 0
	clickcd = 14
	item_damage_type = "stab"

/obj/item/weapon/katar
	name = "katar"
	desc = "A blade that sits above the users fist. Commonly used by those proficient at unarmed fighting"
	icon = 'icons/roguetown/weapons/32/fists_claws.dmi'
	icon_state = "katar"
	force = DAMAGE_KATAR
	throwforce = DAMAGE_KATAR - 3
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_SHORT
	possible_item_intents = list(KATAR_CUT, KATAR_THRUST)
	max_blade_int = 150
	max_integrity = INTEGRITY_WORST - 20

	gripsprite = FALSE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	thrown_bclass = BCLASS_CUT
	melting_material = /datum/material/steel
	melt_amount = 75

/obj/item/weapon/katar/psydon
	name = "psydonian katar"
	desc = "An exotic weapon taken from the hands of wandering monks, an esoteric design to the Grenzelhoftian nation. Special care was taken into account towards the user's knuckles: silver-tipped steel from tip to edges, and His holy cross reinforcing the heart of the weapon, with curved shoulders to allow its user to deflect incoming blows - provided they lead it in with the blade."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psykatar"

/obj/item/weapon/katar/psydon/Initialize(mapload)
	. = ..()						//+3 force, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/katar/abyssor
	name = "barotrauma"
	desc = "A gift from a creature of the sea. The claw is sharpened to a wicked edge."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "abyssorclaw"
	max_integrity = INTEGRITY_STRONG - 50

/datum/intent/knuckles/strike
	name = "punch"
	blade_class = BCLASS_BLUNT
	attack_verb = list("punches", "clocks")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = -100
	clickcd = 8
	damfactor = 1.1
	swingdelay = 0
	icon_state = "inpunch"
	item_damage_type = "blunt"

/datum/intent/knuckles/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = -100
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
	//intent_intdamage_factor = 1.35
	icon_state = "insmash"
	item_damage_type = "blunt"

/obj/item/weapon/knuckles
	name = "steel knuckles"
	desc = "A mean looking pair of steel knuckles."
	icon = 'icons/roguetown/weapons/32/fists_claws.dmi'
	icon_state = "steelknuckle"
	force = DAMAGE_KNUCKLES
	throwforce = DAMAGE_KNUCKLES - 10
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_SHORT
	possible_item_intents = list(KNUCKLE_STRIKE, KNUCKLE_SMASH)
	max_integrity = INTEGRITY_STRONG

	gripsprite = FALSE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	anvilrepair = /datum/skill/craft/weaponsmithing
	melting_material = /datum/material/steel
	melt_amount = 75
	grid_width = 64
	grid_height = 32

/obj/item/weapon/knuckles/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/knuckles/psydon
	name = "psydonian knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, finished with three stumps - Psydon's crown - to crush the heretics' garments and armor into smithereens."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyknuckle"

/obj/item/weapon/knuckles/psydon/Initialize(mapload)
	. = ..()							//+3 force, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/knuckles/eora
	name = "close caress"
	desc = "Some times call for a more intimate approach."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "eoraknuckle"
	force = DAMAGE_KNUCKLES + 2
