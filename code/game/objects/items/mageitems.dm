/obj/item/storage/magebag
	name = "summoners pouch"
	desc = "A pouch for carrying handfuls of summoning ingredients."
	icon_state = "summoning"
	item_state = "summoning"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/magebag

/obj/item/storage/magebag/examine(mob/user)
	. = ..()
	if(contents.len)
		. += span_notice("[contents.len] thing[contents.len > 1 ? "s" : ""] in the pouch.")

/obj/item/storage/magebag/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(length(things))
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/magebag/update_icon_state()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL
	else
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/magebag/apprentice
	populate_contents = list(
		/obj/item/natural/infernalash,
		/obj/item/natural/fairydust,
		/obj/item/natural/elementalmote,
		/obj/item/mana_battery/mana_crystal/standard,
		/obj/item/mana_battery/mana_crystal/standard,
		/obj/item/natural/obsidian,
		/obj/item/natural/obsidian,
		/obj/item/natural/obsidian,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
	)

/obj/item/storage/magebag/poor
	populate_contents = list(
		/obj/item/mana_battery/mana_crystal/standard,
		/obj/item/mana_battery/mana_crystal/standard,
		/obj/item/mana_battery/mana_crystal/small,
		/obj/item/mana_battery/mana_crystal/small,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
	)

/obj/item/chalk
	name = "stick of chalk"
	desc = "A stark-white stick of chalk, possibly made from quicksilver. "
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "chalk"
	dropshrink = 0.7
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32
	var/amount = 8

/obj/item/chalk/natural
	name = "natural stick of chalk"
	amount = 3

/obj/item/chalk/examine(mob/user)
	. = ..()
	desc += "It has [amount] uses left."

/obj/item/chalk/attackby(obj/item/M, mob/user, list/modifiers)
	if(istype(M,/obj/item/ore/cinnabar))
		if(amount < 8)
			amount = 8
			to_chat(user, span_notice("I press arcyne magic into \the [M] and the red crystals within melt into quicksilver, quickly sinking into the [src]."))
	else
		return ..()

/obj/item/chalk/attack_self(mob/living/carbon/human/user, list/modifiers)
	if(!isarcyne(user))//We'll set up other items for other types of rune rituals
		to_chat(user, span_cult("Nothing comes in mind to draw with the chalk."))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = browser_input_list(user, "Runes", "Tier 1&2 Runes", GLOB.t2rune_types)
	pickrune = GLOB.rune_types[runenameinput]
	if(!pickrune)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, pickrune)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	var/crafttime = (10 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE)) * 5))

	user.visible_message(span_warning("[user] begins to scribe something [user.p_their()] [src]!"), \
		span_notice("I start to drag the [src] in the shape of symbols and sigils"))
	playsound(src, 'sound/magic/chalkdraw.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		if(QDELETED(src) || !pickrune)
			return
		user.visible_message(span_warning("[user] scribes an arcyne rune with [user.p_their()] [src]!"), \
		span_notice("I finish dragging the [src] in symbols and circles, leaving behind a [pickrune.name]."))
		src.amount--
		new pickrune(Turf)
	if(amount <= 0)
		qdel(src)

/obj/item/chalk/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue

		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE

/obj/item/weapon/knife/dagger/silver/arcyne
	name = "glowing purple silver dagger"
	desc = "This dagger glows a faint purple. Quicksilver runs across its blade."
	var/is_bled = FALSE

/obj/item/weapon/knife/dagger/silver/arcyne/Initialize()
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/weapon/knife/dagger/silver/attackby(obj/item/M, mob/user, list/modifiers)
	if(istype(M,/obj/item/ore/cinnabar))
		var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE))*5))
		if(do_after(user, crafttime, target = src))
			playsound(src, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("I press arcyne magic into the blade and it throbs in a deep purple..."))
			var/obj/arcyne_knife = new /obj/item/weapon/knife/dagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/weapon/knife/dagger/silver/arcyne/attack_self(mob/living/carbon/human/user, list/modifiers)
	if(!isarcyne(user))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = browser_input_list(user, "Runes", "All Runes", GLOB.t4rune_types)
	pickrune = GLOB.rune_types[runenameinput]
	if(!pickrune)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, pickrune)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	var/chosen_keyword
	if(pickrune.req_keyword)
		chosen_keyword = stripped_input(user, "Keyword for the new rune", "Runes", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	if(!is_bled)
		playsound(src, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user] cuts open [user.p_their()] palm!"), \
			span_cult("I slice open my palm!"))
		if(user.blood_volume)
			user.apply_damage(pickrune.scribe_damage, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
	var/crafttime = (10 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE)) * 5))

	user.visible_message(span_warning("[user] begins to carve something with [user.p_their()] blade!"), \
		span_notice("I start to drag the blade in the shape of symbols and sigils."))
	playsound(src, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		if(QDELETED(src) || !pickrune)
			return
		user.visible_message(span_warning("[user] carves an arcyne rune with [user.p_their()] [src]!"), \
		span_notice("I finish dragging the blade in symbols and circles, leaving behind a [pickrune.name]."))
		new pickrune(Turf, chosen_keyword)

/obj/item/weapon/knife/dagger/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue
		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE

/obj/item/gem/amethyst
	name = "amythortz"
	icon_state = "amethyst"
	sellprice = 18
	arcyne_potency = 25
	desc = "A pink crystal, it surges with magical energy, yet its artificial nature means it's worth little."
	attuned = /datum/attunement/arcyne

/obj/item/mimictrinket
	name = "mimic trinket"
	desc = "A small mimic, imbued with the arcyne to make it docile. It can transform into most things it touches."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "mimic_trinket"
	possible_item_intents = list(/datum/intent/use)
	var/duration = 10 MINUTES
	var/oldicon
	var/oldicon_state
	var/olddesc
	var/oldname
	var/ready = TRUE
	var/timing_id

/obj/item/mimictrinket/attack_self(mob/living/carbon/human/user, list/modifiers)
	revert()

/obj/item/mimictrinket/proc/revert()
	if(oldicon_state)
		icon = oldicon
		icon_state = oldicon_state
		name = oldname
		desc = olddesc
	ready = TRUE
	if(timing_id)
		deltimer(timing_id)
		timing_id = null

/obj/item/mimictrinket/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()

	var/obj/target = attacked_atom
	. = TRUE
	if(ready)
		to_chat(user,span_notice("[src] takes the form of [target]!"))
		oldicon = icon
		oldicon_state = icon_state
		olddesc = desc
		oldname = name
		icon = target.icon
		icon_state = target.icon_state
		name = target.name
		desc = target.desc
		ready = FALSE
		timing_id = addtimer(CALLBACK(src, PROC_REF(revert), user), duration,TIMER_STOPPABLE) // Minus two so we play the sound and decap faster

/obj/item/hourglass/temporal
	name = "temporal hourglass"
	desc = "An arcyne infused hourglass that glows with magick."
	icon = 'icons/obj/hourglass.dmi'
	icon_state = "hourglass_idle"
	var/turf/target
	var/mob/living/victim

/obj/item/hourglass/temporal/toggle(mob/user)
	if(!timing_id)
		to_chat(user,span_notice("I flip the [src]."))
		start()
		flick("hourglass_flip",src)
		target = get_turf(src)
		victim = user
	else
		to_chat(user,span_notice("I stop the [src].")) //Sand magically flows back because that's more convinient to use.
		stop()

/obj/item/hourglass/temporal/stop()
	..()
	do_teleport(victim, target, channel = TELEPORT_CHANNEL_QUANTUM)

/obj/item/natural/feather/infernal
	name = "infernal feather"
	icon_state = "hellfeather"
	possible_item_intents = list(/datum/intent/use)
	desc = "A fluffy feather."

/obj/item/flashlight/flare/torch/lantern/voidlamptern
	name = "void lamptern"
	icon_state = "voidlamp"
	item_state = "voidlamp"
	desc = "An old lamptern that seems darker and darker the longer you look at it."
	light_outer_range = 8
	light_color = "#000000"
	light_power = -3
	on = FALSE

/obj/item/clothing/ring/arcanesigil
	name = "arcyne sigil"
	desc = "A radiantly shimmering sigil within an amulet, It seems to pulse with intense arcynic flows."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "amulet"
	var/cdtime = 30 MINUTES
	var/ready = TRUE

/obj/item/clothing/ring/arcanesigil/attack_self(mob/living/carbon/human/user, list/modifiers)
	if(ready)
		if(do_after(user, 25, target = src))
			to_chat(user,span_notice("[src] heats up to an almost burning temperature, flooding you with overwhelming arcyne knowledge!"))
			ready = FALSE
			addtimer(CALLBACK(src, PROC_REF(revert), user), cdtime,TIMER_STOPPABLE) // Minus two so we play the sound and decap faster
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	else
		to_chat(user,span_notice("[src] remains inert. It must be gathering arcana!"))

/obj/item/clothing/ring/arcanesigil/proc/revert()
	ready = TRUE

/obj/item/clothing/ring/shimmeringlens
	name = "shimmering lens"
	desc = "A radiantly shimmering glass of lens that shimmers with magick. Looking through it gives you a bit of a headache."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "lens"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/active = FALSE

/obj/item/clothing/ring/shimmeringlens/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(loc != user)
		return
	if(!active)
		user.visible_message(span_warning("[user] looks through the [src]!"))
		active = TRUE
		activate(user)
	else
		user.visible_message(span_warning("[user] stops looking through the [src]!"))
		demagicify()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/ring/shimmeringlens/proc/activate(mob/user)
	ADD_TRAIT(user, TRAIT_SEE_LEYLINES, "[type]")
	user.see_invisible = SEE_INVISIBLE_LEYLINES
	user.hud_used?.plane_masters_update()

/obj/item/clothing/ring/shimmeringlens/proc/demagicify()
	var/mob/living/user = usr
	REMOVE_TRAIT(user,TRAIT_SEE_LEYLINES, "[type]")
	user.see_invisible = SEE_INVISIBLE_LIVING
	user.hud_used?.plane_masters_update()
	active = FALSE

/obj/item/sendingstonesummoner
	name = "sending stone summoner"

/obj/item/sendingstonesummoner/OnCrafted(dirin, mob/user)
	. = ..()
	var/obj/item/natural/stone/sending/item1 = new /obj/item/natural/stone/sending
	var/obj/item/natural/stone/sending/item2 = new /obj/item/natural/stone/sending
	item1.paired_with = item2
	item2.paired_with = item1
	item1.icon_state = "whet"
	item2.icon_state = "whet"
	item1.color = "#d8aeff"
	item2.color = "#d8aeff"
	user.put_in_hands(item1, FALSE)
	user.put_in_hands(item2, FALSE)
	qdel(src)

/obj/item/natural/stone/sending
	name = "sending stone"
	desc = "One of a pair of sending stones."
	var/obj/item/natural/stone/sending/paired_with

/obj/item/natural/stone/sending/attack_self(mob/user, list/modifiers)
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		paired_with.say(input_text)

/obj/item/clothing/gloves/nomagic
	icon = 'icons/roguetown/clothing/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	icon_state = "angle"
	w_class = WEIGHT_CLASS_SMALL
	var/active_item

/obj/item/clothing/gloves/nomagic/Initialize(mapload)
	. = ..()
	name = "mana binding gloves"
	resistance_flags = FIRE_PROOF
	///VANDERLIN TO DO

/obj/item/clothing/gloves/nomagic/equipped(mob/living/user, slot)
	if(active_item)
		return
	if(slot & ITEM_SLOT_GLOVES)
		active_item = TRUE
		ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	. = ..()

/obj/item/rope/chain/bindingshackles
	name = "planar binding shackles"
	desc = "arcyne shackles imbued to bind other-planar creatures intelligence to this plane. They will not be under your thrall and a deal will need to be made."
	var/mob/living/fam
	var/tier = 1
	var/being_used = FALSE
	var/sentience_type = SENTIENCE_ORGANIC


/obj/item/rope/chain/bindingshackles/Initialize()
	.=..()
	src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/rope/chain/bindingshackles/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/natural/melded/t2))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE))*5))
			if(do_after(user, crafttime, target = src))
				playsound(src, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I mold the [P] into the [src] with my arcyne power."))
				new /obj/item/rope/chain/bindingshackles/t2(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()
/obj/item/rope/chain/bindingshackles/t2
	name = "greater planar binding shackles"
	tier = 2

/obj/item/rope/chain/bindingshackles/t2/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/natural/melded/t3))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE))*5))
			if(do_after(user, crafttime, target = src))
				playsound(src, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I mold the [P] into the [src] with my arcyne power."))
				new /obj/item/rope/chain/bindingshackles/t3(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()
/obj/item/rope/chain/bindingshackles/t3
	name = "woven planar binding shackles"
	tier = 3

/obj/item/rope/chain/bindingshackles/t3/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/natural/melded/t4))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE))*5))
			if(do_after(user, crafttime, target = src))
				playsound(src, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I mold the [P] into the [src] with my arcyne power."))
				new /obj/item/rope/chain/bindingshackles/t4(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()
/obj/item/rope/chain/bindingshackles/t4
	name = "confluent planar binding shackles"
	tier = 4

/obj/item/rope/chain/bindingshackles/t4/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/natural/melded/t5))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane, TRUE))*5))
			if(do_after(user, crafttime, target = src))
				playsound(src, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I mold the [P] into the [src] with my arcyne power."))
				new /obj/item/rope/chain/bindingshackles/t5(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()

/obj/item/rope/chain/bindingshackles/t5
	name = "aberrant planar binding shackles"
	tier = 5

/obj/item/rope/chain/bindingshackles/attack(mob/living/simple_animal/hostile/retaliate/captive, mob/living/user, list/modifiers)
	var/list/summon_types = list(
		/mob/living/simple_animal/hostile/retaliate/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/infernal/watcher,
		/mob/living/simple_animal/hostile/retaliate/infernal/fiend,
		/mob/living/simple_animal/hostile/retaliate/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/elemental/warden,
		/mob/living/simple_animal/hostile/retaliate/elemental/behemoth,
		/mob/living/simple_animal/hostile/retaliate/elemental/collossus,
		/mob/living/simple_animal/hostile/retaliate/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/fae/dryad,
		/mob/living/simple_animal/hostile/retaliate/fae/sylph,
		/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk,
		/mob/living/simple_animal/hostile/retaliate/voiddragon)

	if(!(captive.type in summon_types))
		to_chat(user, span_warning("[captive] cannot be bound by these shackles!"))
		return
	if(captive.tier > tier)
		to_chat(user, span_warning("[src] is not strong enough to bind [captive]!"))
		return

	var/mob/living/simple_animal/hostile/retaliate/target = captive
	target.visible_message(span_warning("[target.real_name]'s body is entangled by glowing chains..."), runechat_message = TRUE)

	if(!target.ckey) //player is not inside body or has refused, poll for candidates

		var/list/candidates = pollCandidatesForMob("Do you want to play as a Mage's summon?", null, null, null, 100, target, POLL_IGNORE_MAGE_SUMMON, new_players = TRUE)

		// theres at least one candidate
		if(LAZYLEN(candidates))
			var/mob/C = pick(candidates)
			target.awaken_summon(user, C.ckey)
			target.visible_message(span_warning("[target.real_name]'s eyes light up with an intelligence as it awakens fully on this plane."), runechat_message = TRUE)
			custom_name(user,target)

		//no candidates, raise as npc
		else
			to_chat(user, span_notice("The [captive] stares at you with mindless hate. The binding attempt failed to draw out its intelligence!"))

		return FALSE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/proc/awaken_summon(mob/living/carbon/human/master, ckey)
	if(!master)
		return FALSE
	if(ckey) //player
		src.ckey = ckey

	to_chat(src, span_userdanger("My summoner is [master.real_name]. They will need to convince me to obey them."))
	to_chat(src, span_warning("[summon_primer]"))

/obj/item/rope/chain/bindingshackles/proc/custom_name(mob/awakener, mob/chosen_one, iteration = 1)
	if(iteration > 5)
		return
	var/chosen_name = sanitize_name(stripped_input(chosen_one, "What are you named?"))
	if(!chosen_name) // with the way that sanitize_name works, it'll actually send the error message to the awakener as well.
		to_chat(awakener, span_warning("Your weapon did not select a valid name! Please wait as they try again.")) // more verbose than what sanitize_name might pass in it's error message
		return custom_name(awakener, iteration++)
	return chosen_name

////////////////////////////////////////Magic resources go below here////////////////////

//mapfetchable items
/obj/item/natural/obsidian
	name = "obsidian fragment"
	icon = 'icons/obj/shards.dmi'
	icon_state = "obsidian"
	desc = "Volcanic glass cooled from molten lava rapidly."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/natural/leyline
	name = "leyline shards"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "leyline"
	desc = "A shard of a fractured leyline, it glows with lost power."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/produce/manabloom
	name = "mana bloom"
	icon_state = "manabloom"
	icon = 'icons/roguetown/items/natural.dmi'
	desc = "Dense mana that has taken the form of plant life."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer  = 8.9
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	list_reagents = list(/datum/reagent/toxin/manabloom_juice = SNACK_CHUNKY)
	seed = /obj/item/neuFarm/seed/manabloom


/obj/item/natural/artifact
	name = "runed artifact"
	icon_state = "runedartifact"
	desc = "An old stone from age long ago, marked with glowing sigils."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/natural/voidstone
	name = "Voidstone"
	icon_state = "wessence"
	desc = "A piece of blackstone, it feels off to stare at it for long."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL

//combined items
/obj/item/natural/melded
	name = "arcyne meld"
	icon_state = "wessence"
	desc = "You should not be seeing this"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

/obj/item/natural/melded/t1
	name = "arcanic meld"
	icon = 'icons/obj/objects.dmi'
	icon_state = "meld"
	desc = "A melding of infernal ash, fairy dust and elemental mote."

/obj/item/natural/melded/t2
	name = "dense arcanic meld"
	icon = 'icons/obj/objects.dmi'
	icon_state = "dmeld"
	desc = "A melding of hellhound fang, iridescent scales and elemental shard."

/obj/item/natural/melded/t3
	name = "sorcerous weave"
	icon = 'icons/obj/objects.dmi'
	icon_state = "wessence"
	desc = "A melding of molten core, heartwood core and elemental fragment."

/obj/item/natural/melded/t4
	name = "magical confluence"
	icon = 'icons/obj/objects.dmi'
	icon_state = "wessence"
	desc = "A melding of abyssal flame, sylvan essence and elemental relic."

/obj/item/natural/melded/t5
	name = "arcanic aberation"
	icon_state = "wessence"
	desc = "A melding of arcyne fusion and voidstone. It pulses erratically, power coiled tightly within and dangerous. Many would be afraid of going near this, let alone holding it."


/obj/structure/soul
	name = "soul"
	desc = "The soul of the dead"
	icon = 'icons/roguetown/misc/mana.dmi'
	icon_state = "soul"
	plane = LEYLINE_PLANE
	invisibility = INVISIBILITY_LEYLINES
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_over_text = TRUE

	var/mana_amount = 7
	var/datum/weakref/drainer
	var/qdel_timer

/obj/structure/soul/Initialize(mapload)
	. = ..()
	animate(src, pixel_y = 4, time = 1 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -4, time = 1 SECONDS, flags = ANIMATION_RELATIVE)

/obj/structure/soul/Destroy()
	if(qdel_timer)
		deltimer(qdel_timer)
	return ..()

/obj/structure/soul/attack_hand(mob/living/user)
	. = ..()
	if(user.mana_pool?.intrinsic_recharge_sources & MANA_SOULS)
		drain_mana(user)

/obj/structure/soul/proc/init_mana(datum/weakref/dead_guy)
	drainer = dead_guy
	var/mob/living/drained = drainer?.resolve()
	if(!drained)
		return
	mana_amount = drained.mana_pool?.amount
	if(!mana_amount || mana_amount <= 0)
		qdel(src)
		return
	qdel_timer = QDEL_IN_STOPPABLE(src, 10 MINUTES)

/obj/structure/soul/proc/drain_mana(mob/living/user)
	var/datum/beam/transfer_beam = user.Beam(src, icon_state = "drain_life", time = INFINITY)

	var/failed = FALSE
	while(!failed)
		var/mob/living/drained = drainer?.resolve()
		if(!do_after(user, 3 SECONDS, target = src))
			qdel(transfer_beam)
			failed = TRUE
			break
		if(!user.client)
			failed = TRUE
			qdel(transfer_beam)
			break
		var/transfer_amount = min(mana_amount, 20)
		if(!transfer_amount)
			failed = TRUE
			qdel(transfer_beam)
			qdel(src)
			break
		if(drained)
			mana_amount -= drained.mana_pool.transfer_specific_mana(user.mana_pool, transfer_amount, decrement_budget = TRUE)
		else
			mana_amount -= transfer_amount
			user.mana_pool.adjust_mana(transfer_amount)
