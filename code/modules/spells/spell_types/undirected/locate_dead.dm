/datum/action/cooldown/spell/undirected/locate_dead
	name = "Locate Corpse"
	desc = ""
	button_icon_state = "necraeye"
	sound = 'sound/magic/whiteflame.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/necra)

	invocation = "Undermaiden, guide my hand to those who have lost their way."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 60 SECONDS
	spell_cost = 50

/datum/action/cooldown/spell/undirected/locate_dead/cast(atom/cast_on)
	. = ..()

	var/list/mob/corpses = list()
	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind || !is_in_zweb(C.z, owner.z))
			continue

		var/time_dead = 0
		if(C.timeofdeath)
			time_dead = world.time - C.timeofdeath
		var/corpse_name = ""

		if(time_dead < 5 MINUTES)
			corpse_name = "Fresh corpse "
		else if(time_dead < 10 MINUTES)
			corpse_name = "Recently deceased "
		else if(time_dead < 30 MINUTES)
			corpse_name = "Long dead "
		else
			corpse_name = "Forgotten remains of "

		corpse_name += " [copytext(C.name, 1, 2)]..."
		corpses[corpse_name] = C

	if(!length(corpses))
		to_chat(owner, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/mob/selected = browser_input_list(owner, "Which body shall I seek?", "Available Bodies", corpses)

	if(QDELETED(src) || QDELETED(owner) || QDELETED(corpses[selected]) || !can_cast_spell())
		to_chat(owner, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/corpse = corpses[selected]

	var/direction = get_dir(owner, corpse)
	var/direction_name = "unknown"
	switch(direction)
		if(NORTH)
			direction_name = "north"
		if(SOUTH)
			direction_name = "south"
		if(EAST)
			direction_name = "east"
		if(WEST)
			direction_name = "west"
		if(NORTHEAST)
			direction_name = "northeast"
		if(NORTHWEST)
			direction_name = "northwest"
		if(SOUTHEAST)
			direction_name = "southeast"
		if(SOUTHWEST)
			direction_name = "southwest"

	to_chat(owner, span_notice("The Undermaiden pulls on your hand, guiding you [direction_name]."))
