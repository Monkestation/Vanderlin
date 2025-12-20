#define PRESTI_CLEAN	/datum/intent/prestidigitation/clean
#define PRESTI_GATHER	/datum/intent/prestidigitation/gather
#define PRESTI_SPARK	/datum/intent/prestidigitation/spark
#define PRESTI_MOTE		/datum/intent/prestidigitation/mote

/datum/action/cooldown/spell/undirected/touch/prestidigitation
	name = "Prestidigitation"
	desc = "A few basic tricks many apprentices use to practice basic manipulation of the arcyne."
	button_icon_state = "prestidigitation"
	can_cast_on_self = TRUE

	point_cost = 1
	school = SCHOOL_TRANSMUTATION
	attunements = list(
		/datum/attunement/arcyne = 0.2,
	)

	cooldown_time = 1 MINUTES

	hand_path = /obj/item/melee/touch_attack/prestidigitation
	draw_message = "I prepare to perform a minor arcyne incantation."
	drop_message = "I release my minor arcyne focus."
	charges = 10

	var/obj/effect/wisp/prestidigitation/mote
	var/sparkspeed = 3 SECONDS
	var/spark_cd = 0

/datum/action/cooldown/spell/undirected/touch/prestidigitation/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	switch(caster.used_intent.type)
		if(PRESTI_CLEAN)
			if(clean_thing(victim))
				after_action(PRESTI_CLEAN)
		if(PRESTI_GATHER)
			if(gather_thing(victim))
				after_action(PRESTI_CLEAN)
		if(PRESTI_SPARK)
			if(create_spark())
				after_action(PRESTI_SPARK)
		if(PRESTI_MOTE)
			if(handle_mote())
				after_action(PRESTI_MOTE)
	return FALSE

/datum/action/cooldown/spell/undirected/touch/prestidigitation/proc/handle_mote()
	// adjusted from /obj/item/wisp_lantern & /obj/item/wisp
	if(mote)
		owner.visible_message(
			span_notice("[owner] wills \the [mote.name] back into [owner.p_their()] hand and closes it, extinguishing its light."),
			span_notice("I will \the [mote.name] back into my palm and close it."),
		)
		QDEL_NULL(mote)
		return FALSE

	owner.visible_message(
		span_notice("[owner] holds open the palm of [owner.p_their()] hand and concentrates..."),
		span_notice("I hold open the palm of my hand and concentrate on my arcyne power..."),
	)

	if(do_after(owner, 2 SECONDS, owner))
		var/skill_level = owner.get_skill_level(associated_skill)
		var/mote_power = clamp(4 + (skill_level - 3), 4, 7) // every step above journeyman should get us 1 more tile of brightness
		mote = new
		mote.set_light_range(new_outer_range = mote_power)
		if(mote.light_system == STATIC_LIGHT)
			mote.update_light()

		var/list/icon_dimensions = get_icon_dimensions(owner.icon)
		var/orbitsize = (icon_dimensions["width"] + icon_dimensions["height"]) * 0.5
		orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

		mote.orbit(owner, orbitsize, pick(list(TRUE, FALSE)), 2000, 36, TRUE)
		return TRUE

	return FALSE

/datum/action/cooldown/spell/undirected/touch/prestidigitation/proc/clean_thing(atom/target)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = owner.get_skill_level(associated_skill)
	var/cleanspeed = 3.5 SECONDS - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)

	if(istype(target, /obj/effect/decal/cleanable))
		owner.visible_message(
			span_notice("[owner] gestures at \the [target.name], arcyne power slowly scouring it away..."),
			span_notice("I begin to scour \the [target.name] away with my arcyne power..."),
		)
		if(do_after(owner, cleanspeed, target))
			to_chat(owner, span_notice("I expunge \the [target.name] with my mana."))
			target.wash(CLEAN_WASH)
			return TRUE
		return FALSE

	owner.visible_message(
		span_notice("[owner] gestures at \the [target.name], tiny motes of arcyne power surging over [target.p_them()]..."),
		span_notice("I begin to clean \the [target.name] with my arcyne power..."),
	)
	if(do_after(owner, cleanspeed, target))
		to_chat(owner, span_notice("I render \the [target.name] clean."))
		for(var/obj/effect/decal/cleanable/C in target)
			C.wash(CLEAN_WASH)
		target.wash(CLEAN_WASH)
		return TRUE
	return FALSE

/datum/action/cooldown/spell/undirected/touch/prestidigitation/proc/gather_thing(atom/target)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	var/skill_level = owner.get_skill_level(associated_skill)
	var/gatherspeed =  3.5 SECONDS - (skill_level * 3)
	if (istype(target, /turf/open/lava))
		if (do_after(owner, gatherspeed, target))
			to_chat(owner, span_notice("I mold a handful of oozing lava with my arcyne power, rapidly hardening it!"))
			new /obj/item/natural/obsidian(owner.loc)

/datum/action/cooldown/spell/undirected/touch/prestidigitation/proc/create_spark()
	// adjusted from /obj/item/flint
	if (world.time < spark_cd + sparkspeed)
		return FALSE
	spark_cd = world.time
	playsound(owner, 'sound/foley/finger-snap.ogg', 100, FALSE)
	owner.visible_message(span_notice("[owner] snaps [owner.p_their()] fingers, producing a spark!"), span_notice("I will forth a tiny spark with a snap of my fingers."))
	flick("flintstrike", src)

	owner.flash_fullscreen("whiteflash")
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_step(owner, owner.dir)
	S.set_up(1, 1, front)
	S.start()

	return TRUE

/datum/action/cooldown/spell/undirected/touch/prestidigitation/proc/after_action(action_type)
	var/fatigue_used = get_adjusted_cost() //note that as our skills/stats increases, our fatigue drain DECREASES, so this means less xp, too. which is what we want since this is a basic spell, not a spam-for-xp-forever kinda beat
	var/extra_fatigue = 0 // extra fatigue isn't considered in xp calculation
	switch(action_type)
		if(PRESTI_CLEAN)
			fatigue_used *= 0.2 // going to be spamming a lot of this probably
		if(PRESTI_SPARK)
			extra_fatigue = 5 // just a bit of extra fatigue on this one
		if(PRESTI_MOTE)
			extra_fatigue = 15 // same deal here

	owner.adjust_stamina(fatigue_used + extra_fatigue)

	var/skill_level = owner.get_skill_level(associated_skill)
	if (skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0 // we do this after we've actually changed fatigue because we're hard-capping the raises this gives to Expert

	if(fatigue_used > 0)
		adjust_experience(owner, associated_skill, fatigue_used)

/obj/item/melee/touch_attack/prestidigitation
	name = "\improper prestidigitating touch"
	desc = "You recall the following incantations you've learned:\n \
	<b>Touch</b>: Use your arcyne powers to scrub an object or something clean, like using soap. Also known as the Apprentice's Woe.\n \
	<b>Grab</b>: Use your arcyne powers to gather magical materials. \n \
	<b>Shove</b>: Will forth a spark <i>in front of you</i> to ignite flammable items and things like torches, lanterns or campfires. \n \
	<b>Use</b>: Conjure forth an orbiting mote of magelight to light your way."
	color = "#3FBAFD"
	possible_item_intents = list(PRESTI_CLEAN, PRESTI_GATHER, PRESTI_SPARK, PRESTI_MOTE)

/datum/intent/prestidigitation
	reach = 3
	noaa = TRUE
	misscost = 0
	releasedrain = 0
	candodge = TRUE
	canparry = TRUE

/datum/intent/prestidigitation/clean
	name = "touch"
	icon_state = "intouch"

/datum/intent/prestidigitation/gather
	name = "grab"
	icon_state = "ingrab"

/datum/intent/prestidigitation/spark
	name = "shove"
	icon_state = "inshove"

/datum/intent/prestidigitation/mote
	name = "use"
	icon_state = "inuse"

/obj/effect/wisp/prestidigitation
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	light_outer_range =  4
	light_color = "#3FBAFD"
	SET_BASE_PIXEL(20, 0)

#undef PRESTI_CLEAN
#undef PRESTI_GATHER
#undef PRESTI_SPARK
#undef PRESTI_MOTE
