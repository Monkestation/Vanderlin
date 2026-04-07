
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
		playsound(user, activate_sound, 50, FALSE, -1)
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
		user.change_stat(STAT_STRENGTH, 2)
		user.change_stat(STAT_CONSTITUTION, 2)
		user.change_stat(STAT_ENDURANCE, 2)
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_notice("Gone is thy hoard."))
		user.change_stat(STAT_STRENGTH, -2)
		user.change_stat(STAT_CONSTITUTION, -2)
		user.change_stat(STAT_ENDURANCE, -2)
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

/obj/item/clothing/ring/signet/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/ring/signet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(tallowed)
		if(tgui_alert(user, "SCRAPE THE TALLOW OFF?", "SIGNET RING", list("Yes", "No")) != "NO")
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
