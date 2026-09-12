/obj/proc/pass_scrying_checks(mob/user)
	return TRUE

/obj/item/scrying
	name = "scrying object"
	desc = "You can see more than you ought with this..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrying"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/blank.ogg'
	sellprice = 30
	dropshrink = 0.6

	grid_height = 32
	grid_width = 32

	abstract_type = /obj/item/scrying

/obj/item/scrying/Initialize(mapload)
	. = ..()
	add_scry_comp()

/obj/item/scrying/proc/add_scry_comp()
	AddComponent(/datum/component/scrying)

/obj/item/scrying/orb
	name = "arcyne scrying orb"
	desc = "Within its glass depths, you can scry on many unsuspecting beings..."

/obj/item/scrying/orb/pass_scrying_checks(mob/living/user)
	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) < 1)
		to_chat(user, span_warning("I do not know what to do with this..."))
		return FALSE
	return TRUE

/obj/item/scrying/orb/miracle
	name = "divine scrying orb"

/obj/item/scrying/orb/miracle/pass_scrying_checks(mob/living/user)
	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/holy) < 1)
		to_chat(user, span_warning("I do not know what to do with this..."))
		return FALSE
	return TRUE

/obj/item/scrying/eye
	name = "accursed eye"
	desc = "It is pulsating."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scryeye"

/obj/item/scrying/eye/add_scry_comp()
	AddComponent(/datum/component/scrying, 8 SECONDS, 5 MINUTES)

/obj/item/scrying/eye/bogwitch
	name = "eye of the hunt"

/obj/item/scrying/eye/bogwitch/add_scry_comp()
	AddComponent(/datum/component/scrying, 8 SECONDS, 60 SECONDS)

/obj/item/scrying/eye/bogwitch/pass_scrying_checks(mob/living/user)
	if(!istype(user.patron, /datum/patron/alternate/great_hunt/proven))
		to_chat(user, span_warning("I do not know what to do with this..."))
		return FALSE
	return TRUE

/obj/item/scrying/flame
	name = "enchanted abyssal flame"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "abyssalflame"
	desc = "A flickering, black flame contained in a crystal; the heart of an archfiend. Or, at least, what passes for one. It pulses with dense thrums of magick. It has been enchanted to see beyond sight."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 50
	item_weight = 50 GRAMS

/obj/item/scrying/flame/add_scry_comp()
	AddComponent(/datum/component/scrying, 10 SECONDS, 50 SECONDS, TRUE, FALSE, "I look into NAME_HERE but only see dark fire. Maybe I should wait.", 17, 13)

/obj/item/scrying/flame/pass_scrying_checks(mob/living/user)
	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/blood) < 1)
		to_chat(user, span_warning("I do not know what to do with this..."))
		return FALSE
	return TRUE

/*	..................   NOC Device (Fixed scrying ball)   ................... */
/obj/structure/scrying/Initialize()
	. = ..()
	add_scry_comp()

/obj/structure/scrying/proc/add_scry_comp()
	AddComponent(/datum/component/scrying)

/obj/structure/scrying/nocdevice
	name = "NOC Device"
	desc = "An intricate lunar observation machine, that allows its user to study the face of Noc in the sky, reflecting the true whereabouts of hidden beings..."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "nocdevice"
	layer = 4.2

/obj/structure/scrying/nocdevice/add_scry_comp()
	AddComponent(/datum/component/scrying, 10 SECONDS, 45 SECONDS, TRUE, FALSE, "I peer into the sky but cannot focus the lens on the face of Noc. Maybe I should wait.")

/obj/structure/scrying/nocdevice/pass_scrying_checks(mob/living/user)
	var/mob/living/carbon/human/human_user = user
	if(!ishuman(human_user) || !HAS_TRAIT(human_user, TRAIT_VIRGIN))
		to_chat(human_user, span_warning("Noc looks angry with me..."))
		return FALSE
	return TRUE

/*	..................   THE EYE   ................... */
/mob/scry_eye
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 100
	hud_type = /datum/hud/obscured
	invisibility = INVISIBILITY_GHOST
	see_invisible = SEE_INVISIBLE_LIVING
	var/mob/living/user_mob
	var/moving_eye = FALSE

/mob/scry_eye/Move(n, direct)
	if(!moving_eye)
		return
	..()

/mob/scry_eye/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	if(!user_mob)
		qdel(src)
		return
	user_mob.Hear(message, speaker, message_language, raw_message, radio_freq, spans, message_mods, original_message)
	return


/* VAMPIRE EYE */
/mob/scry_eye/eye_of_night
	name = "Arcane Eye"
	sight = 0
	see_in_dark = 2
	invisibility = INVISIBILITY_GHOST
	see_invisible = SEE_INVISIBLE_GHOST

	var/mob/living/carbon/human/vampirelord = null
	icon_state = "arcaneeye"
	hud_type = /datum/hud/eye
	moving_eye = TRUE

/mob/scry_eye/eye_of_night/proc/scry_tele()
	set category = "RoleUnique.Arcane Eye"
	set name = "Teleport"
	set desc= "Teleport to a location"
	set hidden = 0

	if(!isscryeye(usr))
		to_chat(usr, span_warning("You're not an Eye!"))
		return
	var/list/filtered = list()
	for(var/area/A as anything in get_sorted_areas())
		if(A.area_flags & (HIDDEN_AREA|NO_TELEPORT))
			continue
		filtered += A
	var/area/thearea  = input("Area to jump to", "VANDERLIN") as null|anything in filtered

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(usr, span_warning("No area available."))
		return

	usr.forceMove(pick(L))

/mob/scry_eye/eye_of_night/Initialize()
	. = ..()
	var/list/verbs = list(
		/mob/scry_eye/eye_of_night/proc/scry_tele,
		/mob/scry_eye/eye_of_night/proc/cancel_scry,
		/mob/scry_eye/eye_of_night/proc/eye_down,
		/mob/scry_eye/eye_of_night/proc/eye_up,
		/mob/scry_eye/eye_of_night/proc/vampire_telepathy
	)
	add_verb(src, verbs)
	grant_all_languages()

/mob/scry_eye/eye_of_night/proc/cancel_scry()
	set category = "RoleUnique.Arcane Eye"
	set name = "Cancel Eye"
	set desc= "Return to Body"

	if(vampirelord)
		vampirelord.ckey = ckey
		qdel(src)
	else
		to_chat(src, "My body has been destroyed! I'm trapped!")

/mob/scry_eye/eye_of_night/Crossed(mob/living/L)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/cross_human = L
		var/holyskill = GET_MOB_SKILL_VALUE_OLD(cross_human, /datum/attribute/skill/magic/holy)
		var/magicskill = GET_MOB_SKILL_VALUE_OLD(cross_human, /datum/attribute/skill/magic/arcane)
		if(magicskill >= 2)
			to_chat(cross_human, "<font color='red'>An ancient and unusual magic looms in the air around you.</font>")
			return
		if(holyskill >= 2)
			to_chat(cross_human, "<font color='red'>An ancient and unholy magic looms in the air around you.</font>")
			return
		if(prob(20))
			to_chat(cross_human, "<font color='red'>You feel like someone is watching you, or something.</font>")
			return

/mob/scry_eye/eye_of_night/proc/vampire_telepathy()
	set name = "Telepathy"
	set category = "RoleUnique.Arcane Eye"

	var/msg = input("Send a message.", "Command") as text|null
	if(!msg)
		return
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		to_chat(V, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		to_chat(D, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/mob/scry_eye/eye_of_night/A in GLOB.mob_list)
		to_chat(A, span_boldnotice("A message from [src.real_name]:[msg]"))

/mob/scry_eye/eye_of_night/proc/eye_up()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, span_notice("I move upwards."))

/mob/scry_eye/eye_of_night/proc/eye_down()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("I move down."))
