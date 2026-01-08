#define TROLL_SHAPE_STAGE_1 1
#define TROLL_SHAPE_STAGE_2 2
#define TROLL_SHAPE_STAGE_3 3
#define TROLL_SHAPE_STAGE_4 4

/datum/action/cooldown/spell/undirected/troll_shape
	name = "Troll Shape"
	desc = "Borrow power from the Troll, his favored beast."
	button_icon_state = "trollshape"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)

	invocation = "DENDOR LEND ME YOUR POWER!!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 3.5 MINUTES
	spell_cost = 40

	sound = 'sound/vo/mobs/troll/aggro2.ogg'

	// Im sorry
	var/stage = TROLL_SHAPE_STAGE_1

/datum/action/cooldown/spell/undirected/troll_shape/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(owner))
		return FALSE

/datum/action/cooldown/spell/undirected/troll_shape/cast(atom/cast_on)
	. = ..()
	transformation()

/datum/action/cooldown/spell/undirected/troll_shape/proc/transformation()
	var/mob/living/druid = owner
	var/next_stage_time
	switch(stage)
		if(TROLL_SHAPE_STAGE_1)
			playsound(druid, 'sound/vo/smokedrag.ogg', 100, TRUE)
			druid.emote("rage", forced = TRUE)
			druid.Immobilize(3 SECONDS)
			next_stage_time = 3 SECONDS
		if(TROLL_SHAPE_STAGE_2)
			playsound(druid, 'sound/foley/sewflesh.ogg', 100, TRUE)
			to_chat(druid, span_warning("My body is transforming, growing! Unbearable pain, Dendor has answered my prayers!"))
			druid.emote("pain", forced = TRUE)
			druid.do_jitter_animation(4 SECONDS)
			druid.Immobilize(4 SECONDS)
			next_stage_time = 4 SECONDS
		if(TROLL_SHAPE_STAGE_3)
			playsound(druid, 'sound/gore/flesh_eat_03.ogg', 100, TRUE)
			druid.emote("pain", forced = TRUE)
			druid.Immobilize(2 SECONDS)
			druid.do_jitter_animation(2 SECONDS)
			next_stage_time = 2 SECONDS
		if(TROLL_SHAPE_STAGE_4)
			playsound(druid, 'sound/vo/mobs/troll/idle1.ogg', 100, TRUE)
			to_chat(druid, span_warning("I manifest the power of a troll!"))
			druid.apply_status_effect(/datum/status_effect/buff/trollshape)
			return
		else
			return

	stage++
	addtimer(CALLBACK(src, PROC_REF(transformation)), next_stage_time, TIMER_DELETE_ME)

#undef TROLL_SHAPE_STAGE_1
#undef TROLL_SHAPE_STAGE_2
#undef TROLL_SHAPE_STAGE_3
#undef TROLL_SHAPE_STAGE_4
