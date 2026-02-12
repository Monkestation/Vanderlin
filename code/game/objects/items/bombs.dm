/obj/item/smokebomb
	name = "smoke bomb"
	desc = "A soft sphere with an alchemical mixture and a dispersion mechanism hidden inside. Will shatter on impact."
	icon = 'icons/obj/bombs.dmi'
	icon_state = "smokebomb"
	w_class = WEIGHT_CLASS_NORMAL
	//dropshrink = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.75
	grid_width = 32
	grid_height = 64
	var/datum_to_spread = /datum/effect_system/smoke_spread

/obj/item/smokebomb/attack_self(mob/user, list/modifiers)
	. = ..()
	explode()

/obj/item/smokebomb/ex_act()
	if(!QDELETED(src))
		. = ..()
	explode()

/obj/item/smokebomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	explode()

/obj/item/smokebomb/proc/explode()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(!T)
		return
	playsound(src, 'sound/items/smokebomb.ogg' , 50)
	var/radius = 3
	var/datum/effect_system/smoke_spread/S = new datum_to_spread
	S.set_up(radius, T)
	S.start()
	if(prob(25))
		new /obj/item/fertilizer/ash(T)
	qdel(src)

/obj/item/smokebomb/poison_bomb
	name = "poison bomb"
	datum_to_spread = /datum/effect_system/smoke_spread/poison

/obj/item/holy_grenade
	name = "\improper The Holy Hand Grenade of Antioch"
	desc = "A sacred relic carried by Brother Maynard."
	icon = 'icons/obj/holy_grenade.dmi'
	icon_state = "holy_grenade"
	var/fuze = 25
	var/primed = FALSE

	/// How many lines have been heard
	var/scripture_heard = 0
	/// The next wanted scripture
	var/scripture_wanted
	/// The required scripture
	var/list/scripture_required = list(
		"And Saint Attila raised the Hand Grenade up on high, saying,",
		"'O Lord, bless this Thy Hand Grenade that, with it, Thou mayest blow Thine enemies into tiny bits in Thy mercy.'",
		"And the Lord did grin, and the people did feast upon the lambs and sloths and carp and anchovies and orangutans and breakfeast cereals and fruit bats and large chu--",
		"Skip a bit, Brother.",
		"And the Lord spake, saying, 'First shalt thou take out the Holy Pin. Then, shalt thou count to three. No more. No less.",
		"Three shalt be the number thou shalt count, and the number of the counting shall be three.",
		"Four shalt thou not count, nor either count thou two, excepting that thou then proceed to three. Five is right out.",
		"Once the number three, being the third number, be reached, then, lobbest thou thy Holy Hand Grenade of Antioch towards thy foe, who, being naughty in My sight, shall snuff it.'",
		"Amen",
	)

/obj/item/holy_grenade/Initialize(mapload, ...)
	. = ..()
	become_hearing_sensitive()
	scripture_wanted = LAZYACCESS(scripture_required, 1)

/obj/item/holy_grenade/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/holy_grenade/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/holy_grenade/equipped(mob/user, slot, initial)
	. = ..()
	to_chat(user, span_nicegreen("You hear a chant: \"Pie lesu domine, dona eis requiem.\""))

/obj/item/holy_grenade/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(findtext(html_decode(original_message), scripture_wanted))
		scripture_heard++
		if(scripture_heard > length(scripture_required))
			lose_hearing_sensitivity()
			return
		scripture_wanted = scripture_required[scripture_heard++]

/obj/item/holy_grenade/attack_self(mob/user, list/modifiers)
	. = ..()
	if(scripture_heard < length(scripture_required))
		to_chat(user, span_notice("I pull the holy pin... but it doesn't release! Bring forth the Book of Armaments!"))
		return
	to_chat(user, span_userdanger("I pull the holy pin! Count to three!"))
	playsound(user, 'sound/foley/industrial/clunk.ogg', 40, FALSE, -1)
	icon_state = "[icon_state]_armed"
	primed = TRUE
	START_PROCESSING(SSfastprocess, src)

/obj/item/holy_grenade/proc/explode()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	explosion(T, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 4, flash_range = 6, flame_range = 2, smoke = TRUE, soundin = 'sound/magic/hallelujah.ogg')
	qdel(src)

/obj/item/holy_grenade/longer_fuze
	fuze = 50

/obj/item/holy_grenade/ready
	scripture_heard = 1
	scripture_required = list()

/obj/item/holy_grenade/ready/Initialize(mapload, ...)
	. = ..()
	lose_hearing_sensitivity()
