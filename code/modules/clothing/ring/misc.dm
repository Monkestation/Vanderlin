
/obj/item/clothing/ring/silver
	name = "silver ring"
	icon_state = "ring_s"
	sellprice = 33

/obj/item/clothing/ring/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/ring/silver/makers_guild
	name = "makers' ring"
	desc = "The wearer is a proud member of the Makers' guild."
	icon_state = "guild_mason"
	sellprice = 0

/obj/item/clothing/ring/silver/dorpel
	name = "dorpel ring"
	icon_state = "s_ring_diamond"
	sellprice = 140

/obj/item/clothing/ring/silver/blortz
	name = "blortz ring"
	icon_state = "s_ring_quartz"
	sellprice = 110

/obj/item/clothing/ring/silver/saffira
	name = "saffira ring"
	icon_state = "s_ring_sapphire"
	sellprice = 95

/obj/item/clothing/ring/silver/gemerald
	name = "gemerald ring"
	icon_state = "s_ring_emerald"
	sellprice = 80

/obj/item/clothing/ring/silver/toper
	name = "toper ring"
	icon_state = "s_ring_topaz"
	sellprice = 65

/obj/item/clothing/ring/silver/rontz
	name = "rontz ring"
	icon_state = "s_ring_ruby"
	sellprice = 130

/obj/item/clothing/ring/gold
	name = "gold ring"
	icon_state = "ring_g"
	sellprice = 70

/obj/item/clothing/ring/gold/guild_mercator
	name = "Mercator ring"
	desc = "The wearer is a proud member of the Mercator guild."
	icon_state = "guild_mercator"
	sellprice = 0

/obj/item/clothing/ring/gold/dorpel
	name = "dorpel ring"
	icon_state = "g_ring_diamond"
	sellprice = 270

/obj/item/clothing/ring/gold/blortz
	name = "blortz ring"
	icon_state = "g_ring_quartz"
	sellprice = 245

/obj/item/clothing/ring/gold/saffira
	name = "saffira ring"
	icon_state = "g_ring_sapphire"
	sellprice = 200

/obj/item/clothing/ring/gold/gemerald
	name = "gemerald ring"
	icon_state = "g_ring_emerald"
	sellprice = 195

/obj/item/clothing/ring/gold/toper
	name = "toper ring"
	icon_state = "g_ring_topaz"
	sellprice = 180

/obj/item/clothing/ring/gold/rontz
	name = "rontz ring"
	icon_state = "g_ring_ruby"
	sellprice = 255

/obj/item/clothing/ring/jade
	name = "joapstone ring"
	icon_state = "ring_jade"
	sellprice = 60

/obj/item/clothing/ring/coral
	name = "aoetal ring"
	icon_state = "ring_coral"
	sellprice = 70

/obj/item/clothing/ring/onyxa
	name = "onyxa ring"
	icon_state = "ring_onyxa"
	sellprice = 40

/obj/item/clothing/ring/shell
	name = "shell ring"
	icon_state = "ring_shell"
	sellprice = 20

/obj/item/clothing/ring/amber
	name = "petriamber ring"
	icon_state = "ring_amber"
	sellprice = 20

/obj/item/clothing/ring/turq
	name = "ceruleabaster ring"
	icon_state = "ring_turq"
	sellprice = 85

/obj/item/clothing/ring/rose
	name = "rosellusk ring"
	icon_state = "ring_rose"
	sellprice = 25

/obj/item/clothing/ring/opal
	name = "opaloise ring"
	icon_state = "ring_opal"
	sellprice = 90

/obj/item/clothing/ring/active
	var/active = FALSE
	desc = "Unfortunately, like most magic rings, it must be used sparingly. (Right-click me to activate)"
	var/cooldowny
	var/cdtime
	var/activetime
	var/activate_sound
	abstract_type = /obj/item/clothing/ring/active

/obj/item/clothing/ring/active/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(loc != user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, "<span class='warning'>Nothing happens.</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message("<span class='warning'>[user] twists the [src]!</span>")
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_appearance(UPDATE_ICON_STATE)
	activate(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/ring/active/proc/activate(mob/user)
	user.update_inv_ring()

/obj/item/clothing/ring/active/proc/demagicify()
	active = FALSE
	update_appearance(UPDATE_ICON_STATE)
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message("<span class='warning'>The ring settles down.</span>")
		user.update_inv_ring()


/obj/item/clothing/ring/active/nomag
	name = "ring of null magic"
	icon_state = "ruby"
	activate_sound = 'sound/magic/antimagic.ogg'
	cdtime = 10 MINUTES
	activetime = 30 SECONDS
	sellprice = 100

/obj/item/clothing/ring/active/nomag/update_icon_state()
	. = ..()
	if(active)
		icon_state = "rubyactive"
	else
		icon_state = "ruby"

/obj/item/clothing/ring/active/nomag/activate(mob/user)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_RING, INFINITY, FALSE)

/obj/item/clothing/ring/active/nomag/demagicify()
	. = ..()
	var/datum/component/magcom = GetComponent(/datum/component/anti_magic)
	if(magcom)
		magcom.RemoveComponent()

// ................... Ring of Protection ....................... (rare treasure, not for purchase)
/obj/item/clothing/ring/gold/protection
	name = "ring of protection"
	desc = "Old ring, inscribed with arcyne words. Once held magical powers, perhaps it does still?"
	icon_state = "ring_protection"
	var/antileechy
	var/antimagika	// will cause bugs if equipped roundstart to wizards
	var/antishocky

/obj/item/clothing/ring/gold/protection/Initialize()
	. = ..()
	switch(rand(1,4))
		if(1)
			antileechy = TRUE
		if(2)
			antileechy = TRUE
		if(3)
			antishocky = TRUE
		if(4)
			return

/obj/item/clothing/ring/gold/protection/equipped(mob/user, slot)
	. = ..()
	if(antileechy)
		if ((slot & ITEM_SLOT_RING) && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			ADD_TRAIT(user, TRAIT_LEECHIMMUNE,"[REF(src)]")
	if(antimagika)
		if ((slot & ITEM_SLOT_RING) && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			ADD_TRAIT(user, TRAIT_ANTIMAGIC,"[REF(src)]")
	if(antishocky)
		if ((slot & ITEM_SLOT_RING) && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			ADD_TRAIT(user, TRAIT_SHOCKIMMUNE,"[REF(src)]")

/obj/item/clothing/ring/gold/protection/proc/item_removed(mob/living/carbon/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	REMOVE_TRAIT(wearer, TRAIT_LEECHIMMUNE,"[REF(src)]")
	REMOVE_TRAIT(wearer, TRAIT_ANTIMAGIC,"[REF(src)]")
	REMOVE_TRAIT(wearer, TRAIT_SHOCKIMMUNE,"[REF(src)]")

/obj/item/clothing/ring/gold/ravox
	name = "ring of ravox"
	desc = "Old ring, inscribed with arcyne words. Just being near it imbues you with otherworldly strength."
	icon_state = "ring_ravox"

/obj/item/clothing/ring/gold/ravox/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if((slot & ITEM_SLOT_RING) && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			user.apply_status_effect(/datum/status_effect/buff/ravox)

/obj/item/clothing/ring/gold/ravox/proc/item_removed(mob/living/carbon/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	wearer.remove_status_effect(/datum/status_effect/buff/ravox)

/obj/item/clothing/ring/silver/calm
	name = "soothing ring"
	desc = "A lightweight ring that feels entirely weightless, and easing to your mind as you place it upon a finger."
	icon_state = "ring_calm"

/obj/item/clothing/ring/silver/calm/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if ((slot & ITEM_SLOT_RING) && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			user.apply_status_effect(/datum/status_effect/buff/calm)

/obj/item/clothing/ring/silver/calm/proc/item_removed(mob/living/carbon/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	wearer.remove_status_effect(/datum/status_effect/buff/calm)

/obj/item/clothing/ring/silver/noc
	name = "ring of noc"
	desc = "Old ring, inscribed with arcyne words. Just being near it imbues you with otherworldly knowledge."
	icon_state = "ring_sapphire"

/obj/item/clothing/ring/silver/noc/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if (slot & ITEM_SLOT_RING && istype(user))
			RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
			user.apply_status_effect(/datum/status_effect/buff/noc)

/obj/item/clothing/ring/silver/noc/proc/item_removed(mob/living/carbon/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	wearer.remove_status_effect(/datum/status_effect/buff/noc)


// ................... Ring of Burden ....................... (Gaffer's ring, there should only be one of these at one time)

/obj/item/clothing/ring/gold/burden
	name = "ring of burden"
	icon_state = "ring_protection" //N/A change this to a real sprite after its made
	sellprice = 0

/obj/item/clothing/ring/gold/burden/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, type)

/obj/item/clothing/ring/gold/burden/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += "An ancient ring made of pyrite amalgam, an engraved quote is hidden in the inner bridge; \"Heavy is the head that bows\""
		user.add_stress(/datum/stress_event/ring_madness)
	else
		. += "A very old golden ring appointing its wearer as the Mercenary guild master, its strangely missing the crown for the centre stone"

/obj/item/clothing/ring/gold/burden/attack_hand(mob/user)
	if(is_gaffer_assistant_job(user.mind?.assigned_role))
		to_chat(user, span_danger("It is not mine to have..."))
		return
	. = ..()
	if(!user.mind)
		return

	if(HAS_TRAIT(user, TRAIT_BURDEN))
		return TRUE

	var/gaffed = alert(user, "Will you bear the burden? (Be the next Gaffer)", "YOUR DESTINY", "Yes", "No")
	var/gaffed_time = world.time

	if((gaffed == "No" || world.time > gaffed_time + 5 SECONDS) && user.is_holding(src))
		user.dropItemToGround(src, force = TRUE)
		to_chat(user, span_danger("With great effort, the ring slides off your palm to the floor below"))
		return

	if((gaffed == "Yes") && user.is_holding(src))
		ADD_TRAIT(user, TRAIT_BURDEN, type)
		user.equip_to_slot_if_possible(src, ITEM_SLOT_RING, FALSE, FALSE, TRUE, TRUE)
		to_chat(user, span_danger("A constricting weight grows around your neck as you adorn the ring"))
		return TRUE

	else
		return

/obj/item/clothing/ring/gold/burden/on_mob_death(mob/living/user)
	. = ..()
	if(user.ckey)
		addtimer(CALLBACK(src, PROC_REF(on_mob_death),user), 5 MINUTES)
		return
	user.dropItemToGround(src, force = TRUE)

/obj/item/clothing/ring/gold/burden/dropped(mob/user, slot)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(on_ring_drop),user), 5 MINUTES)
	REMOVE_TRAIT (user, TRAIT_BURDEN, type)
	addtimer(CALLBACK(src, PROC_REF(psstt)), rand(10,20) SECONDS)

/obj/item/clothing/ring/gold/burden/proc/psstt()
	if(!ismob(loc))
		playsound(src, 'sound/vo/psst.ogg', 50)
		addtimer(CALLBACK(src, PROC_REF(psstt)), rand(10,20) SECONDS)

/obj/item/clothing/ring/gold/burden/proc/on_ring_drop(mob/user, slot)
	if(ismob(loc))
		return
	visible_message(span_warning("[src] begins to twitch and shake violently, before crumbling into ash"))
	new /obj/item/fertilizer/ash(loc)
	qdel(src)

/obj/item/clothing/ring/gold/burden/equipped(mob/user, slot)
	. = ..()
	if((slot & ITEM_SLOT_RING) && istype(user)) //this will hopefully be a natural HEADEATER tutorial when HEADEATER is a proper thing
		//say("good choice") as much as I love the aesthetic of the ring speech bubble being in the inventory screen, cant make it whisper like this
		var/message = pick("New...bearer...",
			"The...Guild...",
			"Feed...it...",
			"I...see...you...",
			"Serve...me...")
		message = span_danger(message)
		to_chat(user, "The ring whispers, [message]")
		return

	to_chat(user, span_danger("The moment the [src] is in your grasp, it fuses with the skin of your palm, you can't let it go without choosing your destiny first."))

/obj/item/clothing/ring/gold/burden/Destroy()
	SEND_GLOBAL_SIGNAL(COMSIG_GAFFER_RING_DESTROYED, src)
	. = ..()



/obj/item/clothing/ring/dragon_ring
	name = "dragon ring"
	icon_state = "ring_g" // supposed to have it's own sprite but I'm lazy asf
	desc = "Carrying the likeness of a dragon, this glorious ring hums with a subtle energy."
	sellprice = 666
	var/active_item

/obj/item/clothing/ring/dragon_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot & ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_notice("Here be dragons."))
		user.change_stat(STATKEY_STR, 2)
		user.change_stat(STATKEY_CON, 2)
		user.change_stat(STATKEY_END, 2)
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_notice("Gone is thy hoard."))
		user.change_stat(STATKEY_STR, -2)
		user.change_stat(STATKEY_CON, -2)
		user.change_stat(STATKEY_END, -2)
		active_item = FALSE
	return

/obj/item/clothing/ring/signet
	name = "Signet Ring"
	name = "signet ring"
	icon_state = "signet"
	icon_state = "signet"
	desc = "A large golden ring engraved with the Symbol of Psydon."
	desc = "A large golden signet ring engraved with the Symbol of Psydon."
	sellprice = 135
	sellprice = 135
	var/tallowed = FALSE

/obj/item/clothing/ring/signet/silver
	name = "silver signet ring"
	icon_state = "signet_silver"
	desc = "A ring of blessed silver, bearing the Archbishop's symbol. By dipping it in melted redtallow, it can seal writs of religious importance."
	sellprice = 90

/obj/item/clothing/ring/signet/attack_hand_secondary(mob/user, params)
	. = ..()
	if(tallowed)
		if(alert(user, "SCRAPE THE TALLOW OFF?", "SIGNET RING", "YES", "NO") != "NO")
			tallowed = FALSE
			update_appearance(UPDATE_ICON_STATE)

/obj/item/clothing/ring/signet/update_icon_state()
	. = ..()
	if(tallowed)
		icon_state = "[icon_state]_stamp"
	else
		icon_state = initial(icon_state)

// ................... The Feldsher's ring .......................

/obj/item/clothing/ring/feldsher_ring
	name = "feldsher's ring"
	icon_state = "ring_feldsher"
	desc = "A hallowed copper ring, ritualistically forged by Pestran clergymen upon the graduation of a feldsher. \
	\n This ring is proof of Pestra's blessing, in turn allowing the feldsher to extract and manipulate Lux so long as they follow Her teachings"

// ................... The Apothecary's ring .......................

/obj/item/clothing/ring/apothecary_ring
	name = "apothecary's ring"
	icon_state = "ring_apothecary"
	desc = "" // the description is handled upon examine.


/obj/item/clothing/ring/apothecary_ring/examine(mob/user)
	. = ..()
	if(is_apothecary_job(user.mind.assigned_role))
		. += span_info("A hefty bloody made out of thaumic iron, proof of my successful graduation. \
		It doesn't get any easier to wear with time, but at least it proves I'm a confirmed alchemist \
		and can legally manipulate lux, so long as I follow Pestra's teachings.")
	else
		. += "An uncomfortably heavy ring of thaumic iron. Specifically made for apothecaries upon graduation. \n \
		This gives them the right to both extract and manipulate lux, so long as they follow Pestra's teachings."
