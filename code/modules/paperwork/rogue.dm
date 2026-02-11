/obj/item/paper/scroll
	name = "parchment scroll"
	icon_state = "scroll"
	slot_flags = null
	dropshrink = 0.6
	firefuel = 30 SECONDS
	sellprice = 2
	textper = 108
	maxlen = 2000
	throw_range = 3
	var/open = FALSE
	var/old_render = TRUE

/obj/item/paper/scroll/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, "<span class='warning'>Open me.</span>")
			return
	. = ..()

/obj/item/paper/scroll/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,"sx" = 0,"sy" = 0,"nx" = 8,"ny" = 1,"wx" = 0,"wy" = 2,"ex" = 5,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 63,"wturn" = -27,"eturn" = 63,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/scroll/attack_self(mob/user, list/modifiers)
	if(mailer)
		user.visible_message("<span class='notice'>[user] opens the missive from [mailer].</span>")
		mailer = null
		mailedto = null
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		return
	if(!open)
		attack_hand_secondary(user, modifiers)
		return
	..()
	user.update_inv_hands()

/obj/item/paper/scroll/read(mob/user)
	if(!open && !isobserver(user))
		to_chat(user, "<span class='info'>Open me.</span>")
		return
	. = ..()

/obj/item/paper/scroll/show_paper_hud(mob/user)
	if(old_render)
		user << browse_rsc('html/book.png')
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html><head><style type=\"text/css\">
		body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		dat += "[info]<br>"
		dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=460x460;can_close=0;can_minimize=0;can_maximize=0;can_resize=0")
	else
		user.hud_used.reads.icon_state = "scroll"
		user.hud_used.reads.show()
		user.hud_used.reads.maptext = MAPTEXT(info)
		user.hud_used.reads.maptext_width = 230
		user.hud_used.reads.maptext_height = 200
		user.hud_used.reads.maptext_y = 150
		user.hud_used.reads.maptext_x = 120

	onclose(user, "reading", src)

/obj/item/paper/scroll/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/item/paper/scroll/attack_self_secondary(mob/user, list/modifiers)
	attack_hand_secondary(user, modifiers)

/obj/item/paper/scroll/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(open)
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/scroll_close.ogg', 100, FALSE)
	else
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/scroll_open.ogg', 100, FALSE)
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
	user.update_inv_hands()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/paper/scroll/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "scroll_prep"
		open = FALSE
		slot_flags |= ITEM_SLOT_HIP
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(!open)
		icon_state = "scroll_closed"
		return
	if(info)
		icon_state = "scrollwrite"
	else
		icon_state = "scroll"

/obj/item/paper/scroll/update_name()
	. = ..()
	if(mailer)
		name = "missive"
		return
	if(!open)
		name = "scroll"
	else
		name = initial(name)

/obj/item/paper/scroll/cargo
	name = "shipping order"
	icon_state = "contractunsigned"
	open = TRUE
	textper = 150
	var/signedname
	var/signedjob
	var/list/orders = list()
	var/list/reputation_orders = list()
	var/list/fufilled_orders = list()

/obj/item/paper/scroll/cargo/Destroy()
	for(var/datum/supply_pack/SO in orders)
		orders -= SO
	return ..()

/obj/item/paper/scroll/cargo/examine(mob/user)
	. = ..()
	if(signedname)
		. += "This was signed by [signedname] the [signedjob]."

	//for each order, add up total price and display orders

/obj/item/paper/scroll/cargo/update_icon_state()
	. = ..()
	if(!open)
		icon_state = "scroll_closed"
		return ..()
	if(signedname)
		icon_state = "contractsigned"
	else
		icon_state = "contractunsigned"

/obj/item/paper/scroll/cargo/update_name()
	. = ..()
	if(!open)
		name = "scroll"
	else
		name = initial(name)

/obj/item/paper/scroll/cargo/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	if(istype(P, /obj/item/natural/feather))
		if(user.is_literate() && open)
			if(signedname)
				to_chat(user, span_warning("[signedname]"))
				return
			switch(alert("Sign your name?",,"Yes","No"))
				if("No")
					return
				if("Yes")
					if(user.mind?.assigned_role)
						if(do_after(user, 2 SECONDS, src))
							signedname = user.real_name
							signedjob = user.mind.assigned_role.get_informed_title(user)
							user.visible_message(span_notice("[user] signs [src]."), span_notice("I sign [src]."))
							update_appearance(UPDATE_ICON_STATE)
							playsound(src, 'sound/items/write.ogg', 100, FALSE)
							rebuild_info()

/obj/item/paper/scroll/cargo/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Shipping Order</h2>"
	info += "<hr/>"

	if(orders.len)
		info += "<ul>"
		for(var/datum/supply_pack/A in orders)
			if(!A.contraband)
				info += "<li style='color:#06080F;font-size:11px;font-family:\"Segoe Script\"'>[A.name] x[orders[A]] - [A.cost * orders[A]] mammons</li><br/>"
			else
				info += "<li style='color:#610018;font-size:11px;font-family:\"Segoe Script\"'>[A.name] x[orders[A]] - [A.cost * orders[A]] mammons</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	if(signedname)
		info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[signedname] the [signedjob] of [SSmapping.config.map_name]</font>"

	info += "</div>"

/obj/item/paper/inqslip
	name = "inquisition slip"
	base_icon_state = "slip"
	dropshrink = 0.75
	icon_state = "slip"
	obj_flags = CAN_BE_HIT
	var/signed
	var/mob/living/carbon/signee
	var/marquevalue = 2
	var/sealed
	var/waxed
	var/sliptype = 1
	var/obj/item/inqarticles/indexer/paired

/obj/item/paper/inqslip/Destroy()
	paired = null
	signee = null
	return ..()

/obj/item/paper/inqslip/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		if(waxed)
			to_chat(user, span_notice("This writ has been signed by [signee.real_name], sealed with redtallow, and can now be mailed back through the Hermes. The Archbishop will be pleased with this one."))
		if(signed)
			to_chat(user, span_notice("This writ has been signed by [signee.real_name], and can now be mailed back through the Hermes. Sealing it with redtallow would garner more favor from the Archbishop."))
		else if(signee)
			to_chat(user, span_notice("This writ is intended to be signed by [signee.real_name]."))
		else
			to_chat(user, span_notice("This writ has not yet been signed."))

/obj/item/paper/inqslip/accusation
	name = "accusation"
	desc = "A writ of religious suspicion, printed on Grenzelhoftian parchment: one signed not in ink, but blood. Press the accusation against your own bleeding wound in order to obtain a signature. Then pair it with an INDEXER full of the accused's blood. Once done, it is ready to be mailed back to the Oratorium. Fold and seal it, it's only proper."
	marquevalue = 4
	sliptype = 0

/obj/item/paper/inqslip/confession
	name = "confession"
	base_icon_state = "confession"
	marquevalue = 6
	desc = "A writ of religious guilt, printed on Grenzelhoftian parchment: one signed not in ink, but blood. Press the confession against a suspect's bleeding wound, in order to obtain their signature. Once done, it is ready to be mailed back to the Oratorium. Fold and seal it, it's only proper."
	sliptype = 2
	var/bad_type // Type of crime confessed to
	var/antag // Specific antagonist type
	var/false_confession

/obj/item/paper/inqslip/confession/attemptsign(mob/user, mob/living/carbon/human/M)
	// Check if they've confessed via torture

	var/forced_signing = HAS_TRAIT(user, TRAIT_HAS_CONFESSED)

	if(paired)
		if(paired.subject != user)
			to_chat(M, span_warning("Why am I trying to make them sign this with the wrong [paired] paired with it?"))
			return
		else if(forced_signing || (alert(user, "SIGN THE CONFESSION?", "CONFIRM OR DENY", "YES", "NO") != "NO"))
			signed = TRUE
			signee = user
			marquevalue += 2
			REMOVE_TRAIT(user, TRAIT_HAS_CONFESSED, TRAIT_GENERIC)
			update_appearance()

	else if(alert(user, "SIGN THE CONFESSION?", "CONFIRM OR DENY", "YES", "NO") != "NO")
		signed = TRUE
		signee = user
		marquevalue += 2
		REMOVE_TRAIT(user, TRAIT_HAS_CONFESSED, TRAIT_GENERIC)
		update_appearance()
	else
		return

/obj/item/paper/inqslip/arrival
	name = "arrival slip"
	desc = "A writ of arrival, printed on Grenzelhoftian parchment: one signed not in ink, but blood. Intended for one person and one person only. Press the slip against one's own weeping wounds in order to obtain a fitting signature. Once done, it is ready to be mailed back to the Oratorium."

/obj/item/paper/inqslip/arrival/ortho
	marquevalue = 4

/obj/item/paper/inqslip/arrival/inq
	marquevalue = 10

/obj/item/paper/inqslip/arrival/abso
	marquevalue = 6

/obj/item/paper/inqslip/proc/attemptsign(mob/user, mob/living/carbon/human/M)
	if(alert(user, "SIGN THE SLIP?", "CONFIRM OR DENY", "YES", "NO") != "NO")
		signed = TRUE
		signee = user
		update_appearance()

/obj/item/paper/inqslip/attack(mob/living/carbon/human/M, mob/user, list/modifiers)
	if(sealed)
		return
	if(signed)
		to_chat(user, span_warning("It's already been signed."))
		return
	if(paired && !paired.full)
		to_chat(user, span_warning("I should separate [paired] from [src] before signing it."))
		return
	if(sliptype != 2)
		if(M != user)
			to_chat(user, span_warning("This is meant to be signed by the holder."))
			return
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("It must be signed in blood."))
		return
	if(sliptype == 1)
		if(signee == M)
			attemptsign(user)
		else
			to_chat(user, span_warning("This slip isn't meant for me."))
	else if(!sliptype)
		attemptsign(user)
	else
		attemptsign(M, user)

/obj/item/paper/inqslip/attack_self(mob/user)
	if(!signed)
		to_chat(user, span_warning("It hasn't been signed yet. Why would I seal it?"))
		return
	if(waxed)
		to_chat(user, span_notice("It's been sealed. It's ready to send back to the Oratorium."))
		return
	else if(!sealed)
		sealed = TRUE
		update_appearance()
	else
		sealed = FALSE
		update_appearance()

/obj/item/paper/inqslip/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(paired)
		if(!user.get_active_held_item())
			user.put_in_active_hand(paired, user.active_hand_index)
			paired = null
			update_appearance()
		return TRUE

/obj/item/paper/inqslip/update_icon_state()
	. = ..()
	throw_range = initial(throw_range)
	if(!sealed)
		if(paired)
			if(!paired.full)
				icon_state = "[base_icon_state]_indexer"
			else
				icon_state = "[base_icon_state]_indexer[signed ? "_signed" : "_blood"]"
		else
			icon_state = "[base_icon_state][signed ? "_signed" : ""]"
	else
		if(!waxed)
			icon_state = "[base_icon_state]_unsealed"
		else
			icon_state = "[base_icon_state]_sealed"
	return

/obj/item/paper/inqslip/arrival/equipped(mob/user, slot, initial)
	. = ..()
	if(!signee)
		signee = user

/obj/item/paper/inqslip/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/S = I
		if(S.tallowed && sealed)
			waxed = TRUE
			update_appearance()
			S.tallowed = FALSE
			S.update_appearance()
			playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
			marquevalue += 2
		else if(S.tallowed && !sealed)
			to_chat(user,  span_warning("I need to fold the [src] first."))
		else
			to_chat(user,  span_warning("The ring hasn't been waxed."))

	if(sliptype != 1)
		if(istype(I, /obj/item/inqarticles/indexer))
			var/obj/item/inqarticles/indexer/Q = I
			if(paired)
				return
			if(!Q.subject)
				if(signed)
					to_chat(user, span_warning("I should fill [Q] before pairing it with [src]."))
					return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_appearance()
			else if(Q.subject && Q.full)
				if(sliptype == 2)
					if(Q.subject == signee)
						paired = Q
						user.transferItemToLoc(Q, src, TRUE)
						update_appearance()
					else
						if(signed)
							to_chat(user, span_warning("[Q] doesn't contain the blood of the one who signed [src]."))
						else
							to_chat(user, span_warning("I should get a signature before pairing [Q] with [src]."))
						return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_appearance()
			else
				to_chat(user,  span_warning("[Q] isn't completely full."))

/obj/item/merctoken
	name = "mercenary token"
	desc = "A small, palm-fitting bound scroll - a miniature writ of commendation for a mercenary under MGE."
	icon_state = "merctoken"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	firefuel = 30 SECONDS
	sellprice = 2
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	var/signee = null
	var/signeejob = null

/obj/item/merctoken/examine(mob/user)
	. = ..()
	if(!signee)
		. += span_info("Present to a Guild representative for signing.")
	else
		. += span_info("SIGNEE: [signee], [signeejob] of Vanderlin.")

/obj/item/merctoken/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!user.can_read(src))
			to_chat(user, span_warning("Even a reader would find these verba incomprehensible."))
			return
		if(signee)
			to_chat(user, span_warning("This token has already been signed."))
			return
		if(!is_gaffer_job(user.mind.assigned_role) && !is_merchant_job(user.mind.assigned_role))
			if(is_mercenary_job(user.mind.assigned_role))
				to_chat(user, span_warning("I can not sign my own commendation."))
			else
				to_chat(user, span_warning("This is incomprehensible."))
			return
		else
			signee = user.real_name
			signeejob = user.mind.assigned_role.get_informed_title(user)
			visible_message(span_warning("[user] writes [user.p_their()] name on [src]."))
			playsound(src, 'sound/items/write.ogg', 100, FALSE)
			return


/obj/item/paper/scroll/frumentarii/roundstart/Initialize()
	. = ..()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(get_agents)))
	else
		get_agents()

/obj/item/paper/scroll/frumentarii/roundstart/proc/get_agents()
	for(var/CA in GLOB.roundstart_court_agents)
		fingers[CA] = TRUE
	rebuild_info()

/obj/item/paper/scroll/frumentarii
	name = "frumentarii scroll"
	desc = "A list of the hand's fingers. Strike a candidate with this to allow them servitude. Use a writing utensil to cross out a finger."

	//assoc list of TRUE and FALSE. TRUE indicates the agent is an active finger while FALSE is a severed finger
	var/list/fingers = list()
	var/names = 5
	writable = FALSE
	resistance_flags = FIRE_PROOF // let's maybe not burn this

/obj/item/paper/scroll/frumentarii/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!user.mind)
		return
	if(!HAS_TRAIT(user, TRAIT_NOBLE))
		return
	if(length(fingers) >= names)
		to_chat(user, span_notice("[src] is full"))
		return
	if(!isliving(target))
		return
	var/mob/living/attacked_target = target
	if(!attacked_target.client)
		return
	if(attacked_target.real_name in fingers)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.family_datum == SSfamilytree.ruling_family)
			to_chat(user, span_warning("I can't turn a member of the royal family into a finger."))
			return

	var/choice = input(attacked_target,"Do you wish to become one of the Hand's fingers?","Binding Contract",null) as null|anything in list("Yes", "No")
	if(choice != "Yes")
		return

	fingers[attacked_target.real_name] = TRUE
	user.mind.cached_frumentarii = fingers
	rebuild_info()

/obj/item/paper/scroll/frumentarii/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			return
		var/list/choices = list()
		for(var/F in fingers)
			if(fingers[F] == TRUE)
				choices[F] = F
			else
				choices["<s>[F]</s>"] = F
		var/choice = browser_input_list(user, "Reattach/Sever a Finger", "THE LIST", choices)
		if(!choice || QDELETED(src) || QDELETED(user))
			return
		var/finger = choices[choice]
		fingers[finger] = !fingers[finger]
		user.mind.cached_frumentarii = fingers
		playsound(src, 'sound/items/write.ogg', 50, FALSE, -4, ignore_walls = FALSE)
	rebuild_info()

/obj/item/paper/scroll/frumentarii/read(mob/user)
	. = ..()
	user.mind.cached_frumentarii += fingers

/obj/item/paper/scroll/frumentarii/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Known Agents</h2>"
	info += "<hr/>"

	for(var/F in fingers)
		if(fingers[F])
			info += "<li style='color:#06080F;font-size:11px;font-family:\"Segoe Script\"'>[F]</li><br/>"
		else
			info += "<s><li style='color:#610018;font-size:11px;font-family:\"Segoe Script\"'>[F]</li></s><br/>"
	info += "</div>"


/obj/item/paper/scroll/keep_plans
	name = "keep architectural drawings"
	desc = "Paper etched with the floor plans for the entire keep."

/obj/item/paper/scroll/keep_plans/read(mob/user)
	if(!user.mind)
		return
	to_chat(user, span_purple("<b>These look like secret passages...</b>"))
	ADD_TRAIT(user.mind, TRAIT_KNOW_KEEP_DOORS, "[type]")
	user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)


/obj/item/paper/scroll/sold_manifest
	name = "shipping manifest"
	var/list/count = list()
	var/list/items = list()

/obj/item/paper/scroll/sold_manifest/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Sold Items</h2>"
	info += "<hr/>"

	if(length(items))
		for(var/real_name in items)
			info += "<li style='color:#06080F;font-size:11px;font-family:\"Segoe Script\"'>[count[real_name]]x[real_name] - [items[real_name]] mammons</li><br/>"

	info += "</div>"


/obj/item/paper/scroll/sell_price_changes
	name = "updated purchasing prices"
	icon_state = "contractsigned"
	var/list/sell_prices
	var/writers_name
	var/faction

/obj/item/paper/scroll/sell_price_changes/Initialize(mapload, list/prices, faction_name)
	. = ..()

	faction = faction_name
	if(!faction)
		faction = pick("Heartfelt", "Zalad", "Grenzelhoft", "Kingsfield")

	sell_prices = prices
	if(!length(sell_prices))
		sell_prices = generated_test_data()
	writers_name = pick( world.file2list("strings/rt/names/human/humnorm.txt") )
	rebuild_info()

/obj/item/paper/scroll/sell_price_changes/update_icon_state()
	. = ..()
	if(open)
		icon_state = "contractsigned"
	else
		icon_state = "scroll_closed"

/obj/item/paper/scroll/sell_price_changes/update_name()
	. = ..()
	if(open)
		name = initial(name)
	else
		name = "scroll"

/obj/item/paper/scroll/sell_price_changes/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Purchasing Prices</h2>"
	info += "<hr/>"

	if(!sell_prices)
		return
	if(sell_prices.len)
		info += "<ul>"
		for(var/atom/type_path as anything in sell_prices)
			var/list/prices = sell_prices[type_path]
			info += "<li style='color:#06080F;font-size:9px;font-family:\"Segoe Script\"'>[initial(type_path.name)] [prices[1]] > [prices[2]] mammons</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[writers_name] Shipwright of [faction]</font>"
	info += "<br/>"
	info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>Time: [gameTimestamp("hh:mm:ss", world.time - SSticker.round_start_time)]</font>"
	info += "</div>"

/obj/item/paper/scroll/sell_price_changes/proc/generated_test_data()

	var/list/prices = list()
	for(var/i = 1 to rand(2, 4))
		var/datum/supply_pack/pack = pick(SSmerchant.supply_packs)
		if(islist(pack.contains))
			continue
		var/path = pack.contains
		if(!path)
			continue
		prices |= path
		var/starting_rand  = rand(100, 50)
		prices[path] = list("[starting_rand]", "[round(starting_rand * 0.5, 1)]")
	sell_prices = prices
