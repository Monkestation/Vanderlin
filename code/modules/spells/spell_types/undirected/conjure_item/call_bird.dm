/datum/action/cooldown/spell/undirected/call_bird
	name = "Call Messenger Bird"
	desc = "Calls for your messenger bird."
	button_icon_state = "zad"
	sound = null

	cooldown_time = 30 SECONDS

	has_visual_effects = FALSE
	charge_required = FALSE
	experience_modifier = 0

	attunements = list(
		/datum/attunement/light = 0.3,
	)

	var/bird_called = FALSE
	var/obj/item/reagent_containers/food/snacks/messenger_bird/owned_bird = null

	var/list/destinations = list(
		"My family" = "their family",
		"Cancel" = "cancel",
	)

/datum/action/cooldown/spell/undirected/call_bird/grenzel
	name = "Call Imperial Messenger"
	destinations = list(
		"My family" = "their family",
		"Grenzelhoft Imperiate" = "the Grenzelhoft Imperiate",
		"Cancel" = "cancel",
	)

/datum/action/cooldown/spell/undirected/call_bird/priest
	name = "Call Holy Messenger"
	destinations = list(
		"The Archbishop" = "the Archbishop",
		"Cancel" = "cancel",
	)

/datum/action/cooldown/spell/undirected/call_bird/zalad
	name = "Call Guild Messenger"
	destinations = list(
		"The Mercator Guild" = "the Mercator Guild",
		"Cancel" = "cancel",
	)

/datum/action/cooldown/spell/undirected/call_bird/inquisitor
	name = "Call Inquisitorial Messenger"
	destinations = list(
		"Holy Bishop of the Inquisition" = "the Holy Bishop of the Inquisition",
		"Cancel" = "cancel",
	)

/datum/action/cooldown/spell/undirected/call_bird/Destroy(force)
	owned_bird?.source_spell = null
	owned_bird = null
	return ..()

/datum/action/cooldown/spell/undirected/call_bird/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	return isliving(owner)

/datum/action/cooldown/spell/undirected/call_bird/cast(mob/living/cast_on)
	. = ..()
	cast_on.emote("attnwhistle", forced = TRUE)
	var/turf/location = owner.loc
	if(!istype(location) || !location.can_see_sky())
		to_chat(owner, span_warning("You whistle, but feel like a fool as nothing happens..."))
		return
	if(!bird_called)
		bird_called = TRUE
		playsound(cast_on, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
		owned_bird = new(get_turf(cast_on))
		owned_bird.source_spell = WEAKREF(src)
		cast_on.put_in_hands(owned_bird)
		return
	if(QDELETED(owned_bird) || owned_bird.dead)
		to_chat(owner, span_warning("You whistle, but nothing happens..."))
		owner.add_stress(/datum/stress_event/dead_bird)
		return
	bird_called = FALSE
	playsound(owned_bird, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
	owned_bird.visible_message(span_notice("The messenger bird flies away!"))
	owned_bird = null

/obj/item/reagent_containers/food/snacks/messenger_bird
	name = "messenger bird"
	desc = "A small bird, used by nobles to send messages beyond the borders of this city. It has a small pouch on its leg for carrying notes."
	icon_state = "messenger"
	icon = 'icons/roguetown/mob/monster/messenger.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	foodtype = RAW
	verb_say = "squeaks"
	verb_yell = "squeaks"
	obj_flags = CAN_BE_HIT
	var/dead = FALSE
	eat_effect = /datum/status_effect/debuff/uncookedfood
	max_integrity = 10
	sellprice = 0
	blade_dulling = DULLING_CUT
	rotprocess = null
	static_debris = list(/obj/item/natural/feather=1)
	var/datum/weakref/source_spell

/obj/item/reagent_containers/food/snacks/friedmessenger
	name = "fried messenger"
	desc = "A fried messenger bird. Poor thing."
	icon_state = "fcrow"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("burnt flesh" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0

/obj/item/reagent_containers/food/snacks/messenger_bird/burning(input as num)
	. = ..()
	if(!dead)
		if(burning >= burntime)
			dead = TRUE
			playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
			icon_state = "[icon_state]1"

/obj/item/reagent_containers/food/snacks/messenger_bird/dead
	dead = TRUE
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/messenger_bird/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(dead)
		icon_state = "[icon_state]l"

/obj/item/reagent_containers/food/snacks/messenger_bird/Destroy()
	source_spell = null
	return ..()

/obj/item/reagent_containers/food/snacks/messenger_bird/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_MELEE)
	if(dead)
		..()
	else
		fly_away()
		return

/obj/item/reagent_containers/food/snacks/messenger_bird/atom_destruction(damage_flag)
	if(!dead)
		dead = TRUE
		playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
		icon_state = "[icon_state]1"
		rotprocess = SHELFLIFE_SHORT
		return 1
	return ..()

/obj/item/reagent_containers/food/snacks/messenger_bird/proc/fly_away()
	if(!dead)
		playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
		visible_message(span_notice("The messenger bird flies away!"))
		var/datum/action/cooldown/spell/undirected/call_bird/spell = source_spell.resolve()
		if(spell)
			spell.bird_called = FALSE
		qdel(src)


/obj/item/reagent_containers/food/snacks/messenger_bird/attackby(obj/item/I, mob/user, params)
	if(!dead)
		if(isliving(user))
			var/mob/living/L = user
			var/datum/action/cooldown/spell/undirected/call_bird/spell = source_spell.resolve()
			if(prob(L.STASPD * 2) || spell.owner == user)
				if(istype(I, /obj/item/paper) && spell.owner == user)
					var/obj/item/paper/P = I
					if(length(P.info) > 0)
						to_chat(user, span_notice("You attach your note to the messenger bird."))
						var/noble_info = "[user.key]/([user.real_name]) ([user.job])"
						var/dest = input(user, "Where would you like the bird to go?", "Destination")  as anything in spell.destinations

						if(dest == "Cancel")
							to_chat(user, span_notice("You decide not to send the bird anywhere."))
							return

						to_chat(user, span_notice("You tell the bird to go to [spell.destinations[dest]]"))
						var/strip_info = STRIP_HTML_FULL(replacetext(P.info, "<br>", "\n"), MAX_MESSAGE_LEN)
						log_game("LETTER SENT: from [key_name(user)] to [spell.destinations[dest]]:\n[strip_info]", LOG_GAME)
						strip_info = replacetext(strip_info, "\n", "<br>")
						message_admins("[noble_info] [ADMIN_BIRD_LETTER(user)] [ADMIN_FLW(user)] writes to [spell.destinations[dest]]: <br>[strip_info]")
						fly_away()
						qdel(P)

						return
					else
						to_chat(user, span_warning("The note is blank!"))
						return
			else
				to_chat(user, "<span class='warning'>[src] gets away!</span>")
				fly_away()
				return
	..()


