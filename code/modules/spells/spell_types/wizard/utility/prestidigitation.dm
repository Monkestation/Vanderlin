#define PRESTI_CLEAN "presti_clean"
#define PRESTI_SPARK "presti_spark"
#define PRESTI_MOTE "presti_mote"

/obj/effect/proc_holder/spell/targeted/touch/prestidigitation
	name = "Prestidigitation"
	desc = "A few basic tricks many apprentices use to practice basic manipulation of the arcyne."
	drawmessage = "I prepare to perform a minor arcyne incantation."
	dropmessage = "I release my minor arcyne focus."
	school = "transmutation"
	overlay_state = "prestidigitation"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/prestidigitation
	cost = 1
	attunements = list(
		/datum/attunement/arcyne = 0.2,
	)

/obj/item/melee/touch_attack/prestidigitation
	name = "\improper prestidigitating touch"
	desc = "You recall the following incantations you've learned:\n \
	<b>Touch</b>: Use your arcyne powers to scrub an object or something clean, like using soap. Also known as the Apprentice's Woe.\n \
	<b>Shove</b>: Will forth a spark <i>in front of you</i> to ignite flammable items and things like torches, lanterns or campfires. \n \
	<b>Use</b>: Conjure forth an orbiting mote of magelight to light your way."
	catchphrase = null
	possible_item_intents = list(INTENT_HELP, INTENT_DISARM, /datum/intent/use)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD" // this produces green because the icon base is yellow but someone else can fix that if they want
	var/obj/effect/wisp/prestidigitation/mote
	var/cleanspeed = 35 // adjust this down as low as 15 depending on magic skill
	var/motespeed = 20 // mote summoning speed
	var/sparkspeed = 30 // spark summoning speed
	var/spark_cd = 0
	var/xp_interval = 150 // really don't want people to spam this too much for xp - they will, but the intent is for them to not
	var/xp_cooldown = 0
	var/gatherspeed = 35

/obj/item/melee/touch_attack/prestidigitation/Initialize()
	. = ..()
	mote = new(src)

/obj/item/melee/touch_attack/prestidigitation/Destroy()
	if (mote)
		qdel(mote)
	return ..()

/obj/item/melee/touch_attack/prestidigitation/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/prestidigitation/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/fatigue_used
	switch (user.used_intent.type)
		if (INTENT_HELP) // Clean something like a bar of soap
			fatigue_used = handle_cost(user, PRESTI_CLEAN)
			if(istype(target,/obj/structure/well/fountain/mana) || istype(target, /turf/open/lava))
				gather_thing(target, user)
				return
			if (clean_thing(target, user))
				handle_xp(user, fatigue_used, TRUE) // cleaning ignores the xp cooldown because it awards comparatively little
		if (INTENT_DISARM) // Snap your fingers and produce a spark
			fatigue_used = handle_cost(user, PRESTI_SPARK)
			if (create_spark(user))
				handle_xp(user, fatigue_used)
		if (/datum/intent/use) // Summon an orbiting arcane mote for light
			fatigue_used = handle_cost(user, PRESTI_MOTE)
			if (handle_mote(user))
				handle_xp(user, fatigue_used)

/obj/item/melee/touch_attack/prestidigitation/proc/gather_thing(atom/target, mob/living/carbon/human/user)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	gatherspeed = initial(gatherspeed) - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)
	if (istype(target, /turf/open/lava))
		if (do_after(user, src.gatherspeed, target = target))
			to_chat(user, span_notice("I mold a handful of oozing lava  with my arcane power, rapidly hardening it!"))
			new /obj/item/natural/obsidian(user.loc)

/obj/item/melee/touch_attack/prestidigitation/proc/handle_cost(mob/living/carbon/human/user, action)
	// handles fatigue/stamina deduction, this stuff isn't free - also returns the cost we took to use for xp calculations
	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	var/fatigue_used = base_spell.get_fatigue_drain() //note that as our skills/stats increases, our fatigue drain DECREASES, so this means less xp, too. which is what we want since this is a basic spell, not a spam-for-xp-forever kinda beat
	var/extra_fatigue = 0 // extra fatigue isn't considered in xp calculation
	switch (action)
		if (PRESTI_CLEAN)
			fatigue_used *= 0.2 // going to be spamming a lot of this probably
		if (PRESTI_SPARK)
			extra_fatigue = 5 // just a bit of extra fatigue on this one
		if (PRESTI_MOTE)
			extra_fatigue = 15 // same deal here

	user.adjust_stamina(fatigue_used + extra_fatigue)

	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	if (skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0 // we do this after we've actually changed fatigue because we're hard-capping the raises this gives to Expert

	return fatigue_used

/obj/item/melee/touch_attack/prestidigitation/proc/handle_xp(mob/living/carbon/human/user, fatigue, ignore_cooldown = TRUE)
	if (!ignore_cooldown)
		if (world.time < xp_cooldown + xp_interval)
			return

	xp_cooldown = world.time

	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	if (user)
		adjust_experience(user, base_spell.associated_skill, fatigue)

/obj/item/melee/touch_attack/prestidigitation/proc/handle_mote(mob/living/carbon/human/user)
	// adjusted from /obj/item/wisp_lantern & /obj/item/wisp
	if (!mote)
		return // should really never happen

	//let's adjust the light power based on our skill, too
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	var/mote_power = clamp(4 + (skill_level - 3), 4, 7) // every step above journeyman should get us 1 more tile of brightness
	mote.set_light_range(new_outer_range = mote_power)
	if(mote.light_system == STATIC_LIGHT)
		mote.update_light()

	if (mote.loc == src)
		user.visible_message(span_notice("[user] holds open the palm of [user.p_their()] hand and concentrates..."), span_notice("I hold open the palm of my hand and concentrate on my arcyne power..."))
		if(do_after(user, motespeed))
			mote.orbit(user, 18, pick(list(TRUE, FALSE)), 2000, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] wills \the [mote.name] back into [user.p_their()] hand and closes it, extinguishing its light."), span_notice("I will \the [mote.name] back into my palm and close it."))
		mote.forceMove(src)
		return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/create_spark(mob/living/carbon/human/user)
	// adjusted from /obj/item/flint
	if (world.time < spark_cd + sparkspeed)
		return
	spark_cd = world.time
	playsound(user, 'sound/foley/finger-snap.ogg', 100, FALSE)
	user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, producing a spark!"), span_notice("I will forth a tiny spark with a snap of my fingers."))
	flick("flintstrike", src)

	user.flash_fullscreen("whiteflash")
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_step(user, user.dir)
	S.set_up(1, 1, front)
	S.start()

/obj/item/melee/touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	cleanspeed = initial(cleanspeed) - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)

	if (istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] gestures at \the [target.name], arcyne power slowly scouring it away..."), span_notice("I begin to scour \the [target.name] away with my arcyne power..."))
		if(do_after(user, cleanspeed, target))
			to_chat(user, span_notice("I expunge \the [target.name] with my mana."))
			target.wash(CLEAN_WASH)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] gestures at \the [target.name], tiny motes of arcyne power surging over [target.p_them()]..."), span_notice("I begin to clean \the [target.name] with my arcyne power..."))
		if(do_after(user, cleanspeed, target))
			to_chat(user, span_notice("I render \the [target.name] clean."))
			for (var/obj/effect/decal/cleanable/C in target)
				qdel(C)
			target.wash(CLEAN_WASH)
			return TRUE
		return FALSE

// Intents for prestidigitation

/obj/effect/wisp/prestidigitation
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	pixel_x = 20
	light_outer_range =  4
	light_color = "#3FBAFD"

	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"

#undef PRESTI_CLEAN
#undef PRESTI_SPARK
#undef PRESTI_MOTE
