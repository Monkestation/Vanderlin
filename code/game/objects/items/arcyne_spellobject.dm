/datum/spellobject_entry
	/// Type path of the stored spell
	var/datum/action/cooldown/spell/spell_type = null
	/// Cached display name
	var/spell_name = null
	/// Casts remaining
	var/charges = 1
	/// Live granted spell instance (passive-grant mode only)
	var/datum/action/cooldown/spell/live_spell = null

/obj/item/arcyne_spellobject
	name = "arcyne spell object"
	desc = "An object threaded with arcyne filaments."
	w_class = WEIGHT_CLASS_SMALL

	grid_width = 64
	grid_height = 32
	/// Maximum number of distinct spell slots
	var/max_spells = 3
	/// Minimum accepted spell tier
	var/min_spell_tier = 0
	/// Maximum accepted spell tier
	var/max_spell_tier = 99
	///if we hijack a click or obscure
	var/spellobject_flags = NONE
	/// List of /datum/spellobject_entry
	var/list/datum/spellobject_entry/stored_spells = list()
	/// TRUE while spells are actively granted (passive mode only)
	var/active = FALSE
	/// Whether or not it fills itself on spawn.
	var/has_random_spells = FALSE

/obj/item/arcyne_spellobject/Initialize(mapload)
	. = ..()
	if(has_random_spells)
		generate_random_spells()

/obj/item/arcyne_spellobject/examine(mob/user)
	. = ..()
	if(!length(stored_spells))
		. += span_warning("It is cold and empty.")
		return
	. += span_notice("Spells stored within ([length(stored_spells)]/[max_spells]):")
	for(var/datum/spellobject_entry/E in stored_spells)
		// Chaotic items obscure their spell names
		if(spellobject_flags & SPELLOBJECT_CHAOTIC)
			. += span_notice("  ??? - [E.charges] charge\s remaining.")
		else
			. += span_notice("  [E.spell_name] - [E.charges] charge\s remaining.")
	if(spellobject_flags & SPELLOBJECT_HIJACK_CLICK)
		. += span_notice("It crackles faintly, point and click to unleash its magic.")
	if(spellobject_flags & SPELLOBJECT_CHAOTIC)
		. += span_warning("The magic within feels wild and unpredictable.")

/obj/item/arcyne_spellobject/update_overlays()
	. = ..()
	if(!(spellobject_flags & SPELLOBJECT_VISUAL))
		return
	var/i = 0
	for(var/datum/spellobject_entry/E in stored_spells)
		var/datum/action/cooldown/spell/S = E.spell_type
		var/mutable_appearance/MA = mutable_appearance(initial(S.button_icon), initial(S.button_icon_state))
		MA.alpha = max(40, 120 - i * 20)
		MA.pixel_z = i * 2
		. += MA
		i++

/obj/item/arcyne_spellobject/equipped(mob/user, slot)
	. = ..()
	if(spellobject_flags & SPELLOBJECT_HIJACK_CLICK)
		return
	if(!length(stored_spells))
		return
	grant_all_spells(user)

/obj/item/arcyne_spellobject/dropped(mob/user)
	. = ..()
	if(spellobject_flags & SPELLOBJECT_HIJACK_CLICK)
		return
	if(active)
		revoke_all_spells(user)

/obj/item/arcyne_spellobject/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(!(spellobject_flags & SPELLOBJECT_HIJACK_CLICK))
		return ..()
	//no proximity check; works at any distance
	if(!length(stored_spells))
		to_chat(user, span_warning("Nothing is stored within."))
		return
	fire_hijack_spell(user, target)

/obj/item/arcyne_spellobject/proc/fire_hijack_spell(mob/living/user, mob/living/intended_target)
	var/datum/spellobject_entry/E = stored_spells[1]
	var/datum/action/cooldown/spell/spell_type = E.spell_type
	var/skill_level = GET_MOB_SKILL_VALUE(user, initial(spell_type.associated_skill))
	var/requirement
	if(skill_level >= SKILL_LEVEL_LEGENDARY)
		requirement = SPELLOBJECT_AIM_REQ_LEGENDARY
	else if(skill_level >= SKILL_LEVEL_MASTER)
		requirement = SPELLOBJECT_AIM_REQ_MASTER
	else if(skill_level >= SKILL_LEVEL_EXPERT)
		requirement = SPELLOBJECT_AIM_REQ_EXPERT
	else if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		requirement = SPELLOBJECT_AIM_REQ_JOURNEYMAN
	else if(skill_level >= SKILL_LEVEL_APPRENTICE)
		requirement = SPELLOBJECT_AIM_REQ_APPRENTICE
	else if(skill_level >= SKILL_LEVEL_NOVICE)
		requirement = SPELLOBJECT_AIM_REQ_NOVICE
	else
		requirement = SPELLOBJECT_AIM_REQ_NONE

	var/roll_result = user.diceroll(requirement = requirement, crit = 3)

	var/mob/living/actual_target
	if(spellobject_flags & SPELLOBJECT_STABLE)
		actual_target = intended_target
	else
		switch(roll_result)
			if(DICE_CRIT_SUCCESS)
				actual_target = intended_target
				user.visible_message(
					span_notice("[user] levels [src], a searing bolt lances straight and true!"),
					span_notice("The magic responds perfectly [E.spell_name] fires true.")
				)
			if(DICE_SUCCESS)
				actual_target = intended_target
				user.visible_message(
					span_notice("[user] levels [src] and a burst of energy lances toward [intended_target]!"),
					span_notice("The spell fires toward [intended_target].")
				)
			if(DICE_FAILURE)
				if(spellobject_flags & SPELLOBJECT_CHAOTIC)
					var/list/nearby = get_hearers_in_view(7, user) - user
					actual_target = length(nearby) ? pick(nearby) : user
					user.visible_message(
						span_warning("[user]'s [src] sputters, the magic lurches wildly toward [actual_target]!"),
						span_warning("The magic slips your control the spell careens toward [actual_target]!")
					)
				else
					actual_target = user
					user.visible_message(
						span_warning("[user]'s [src] sputters, the magic turns back on them!"),
						span_warning("The magic slips your control [E.spell_name] snaps back at you!")
					)
			if(DICE_CRIT_FAILURE)
				if(spellobject_flags & SPELLOBJECT_CHAOTIC)
					var/list/wild = get_hearers_in_view(14, user) - user
					actual_target = length(wild) ? pick(wild) : user
					user.visible_message(
						span_boldwarning("[user]'s [src] erupts in wild light, the spell screams toward [actual_target]!"),
						span_boldwarning("Catastrophic misfire the spell explodes toward [actual_target]!")
					)
				else
					actual_target = user
					user.visible_message(
						span_boldwarning("[user]'s [src] violently misfires, the spell explodes back into them!"),
						span_boldwarning("The magic catastrophically misfires [E.spell_name] erupts into you!")
					)

	var/datum/action/cooldown/spell/instance = new E.spell_type(user)
	instance.point_cost = 0
	instance.spell_cost = 0
	instance.cooldown_time = 0
	instance.spell_flags |= SPELL_TEMPORARY
	instance.Grant(user)
	instance.cast(actual_target)
	instance.Remove(user)
	qdel(instance)

	consume_entry_charge(user, E)


/obj/item/arcyne_spellobject/proc/consume_entry_charge(mob/living/user, datum/spellobject_entry/E)
	E.charges--
	if(E.charges <= 0)
		if(active && E.live_spell)
			revoke_entry(user, E)
		stored_spells -= E
		user.visible_message(
			span_notice("A thread of light unravels from [user]'s [name], [E.spell_name] is spent."),
			span_notice("The last charge of [E.spell_name] is spent.")
		)
		qdel(E)
		update_appearance(UPDATE_OVERLAYS)
		if(!length(stored_spells))
			if(active)
				UnregisterSignal(user, COMSIG_MOB_ABILITY_FINISHED)
				active = FALSE
			user.visible_message(
				span_warning("[user]'s [name] dims — all spells exhausted."),
				span_warning("The [name] is now empty.")
			)
			if(spellobject_flags & SPELLOBJECT_CONSUMABLE)
				qdel(src)
	else
		to_chat(user, span_notice("[E.spell_name]: [E.charges] charge\s remaining."))

/obj/item/arcyne_spellobject/proc/grant_all_spells(mob/user)
	if(active)
		return
	active = TRUE
	for(var/datum/spellobject_entry/E in stored_spells)
		grant_entry(user, E)
	RegisterSignal(user, COMSIG_MOB_ABILITY_FINISHED, PROC_REF(on_spell_fired))
	to_chat(user, span_hierophant_warning("The [name] thrums, [length(stored_spells)] spell\s ready."))

/obj/item/arcyne_spellobject/proc/revoke_all_spells(mob/user)
	if(!active)
		return
	UnregisterSignal(user, COMSIG_MOB_ABILITY_FINISHED)
	for(var/datum/spellobject_entry/E in stored_spells)
		revoke_entry(user, E)
	active = FALSE

/obj/item/arcyne_spellobject/proc/grant_entry(mob/user, datum/spellobject_entry/E)
	if(E.live_spell || !E.spell_type)
		return
	E.live_spell = new E.spell_type(user)
	E.live_spell.point_cost = 0
	E.live_spell.cooldown_time = 0
	E.live_spell.spell_cost = 0
	E.live_spell.spell_flags |= SPELL_TEMPORARY
	E.live_spell.background_icon_state = "spelltemp"
	E.live_spell.base_background_icon_state = "spelltemp0"
	E.live_spell.active_background_icon_state = "spelltemp1"
	E.live_spell.Grant(user)

/obj/item/arcyne_spellobject/proc/revoke_entry(mob/user, datum/spellobject_entry/E)
	if(!E.live_spell)
		return
	E.live_spell.Remove(user)
	qdel(E.live_spell)
	E.live_spell = null

/obj/item/arcyne_spellobject/proc/on_spell_fired(mob/source, datum/action/cooldown/spell/fired)
	SIGNAL_HANDLER
	var/datum/spellobject_entry/fired_entry = null
	for(var/datum/spellobject_entry/E in stored_spells)
		if(E.live_spell == fired)
			fired_entry = E
			break
	if(!fired_entry)
		return
	consume_entry_charge(source, fired_entry)

/obj/item/arcyne_spellobject/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	. = ..()
	// If passive-grant item is no longer held by the mob that had it, revoke
	if(active && !istype(loc, /mob))
		var/mob/M = old_loc
		if(istype(M))
			revoke_all_spells(M)

/obj/item/arcyne_spellobject/proc/imbue_spell(mob/caster, datum/action/cooldown/spell/spell_type_path, spell_tier, charges = 1)
	if(length(stored_spells) >= max_spells)
		to_chat(caster, span_hierophant_warning("The [name] is already full ([max_spells] spells)."))
		return FALSE
	if(spell_tier < min_spell_tier || spell_tier > max_spell_tier)
		to_chat(caster, span_hierophant_warning("This object cannot hold a spell of that tier."))
		return FALSE

	var/datum/action/cooldown/spell/live = null
	for(var/datum/action/cooldown/spell/S in caster.actions)
		if(S.type == spell_type_path)
			live = S
			break
	if(!live)
		to_chat(caster, span_warning("You don't know that spell, you can't store what you don't have."))
		return FALSE

	var/mana_cost = live.spell_cost * 2
	if(caster.mana_pool.amount < mana_cost)
		to_chat(caster, span_phobia("You need [mana_cost] mana to imbue this spell (you have [caster.mana_pool.amount])."))
		return FALSE
	caster.mana_pool.adjust_mana(-mana_cost)
	live.StartCooldown()

	var/datum/spellobject_entry/E = new()
	E.spell_type = spell_type_path
	E.spell_name = live.name
	E.charges = charges
	stored_spells += E

	update_appearance(UPDATE_OVERLAYS)
	to_chat(caster, span_hierophant_warning("You pour [mana_cost] mana into the [name], [live.name] is sealed within."))
	return TRUE

/obj/item/arcyne_spellobject/Destroy()
	if(active && istype(loc, /mob))
		revoke_all_spells(loc)
	stored_spells.Cut()
	return ..()

/obj/item/arcyne_spellobject/scroll
	name = "arcyne scroll"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "Dry parchment veined with cold arcyne light. Whatever is written here was not meant to last."
	icon_state = "scroll"
	max_spells = 1
	w_class = WEIGHT_CLASS_SMALL
	spellobject_flags = SPELLOBJECT_HIJACK_CLICK | SPELLOBJECT_CONSUMABLE | SPELLOBJECT_VISUAL | SPELLOBJECT_STABLE

/obj/item/arcyne_spellobject/scroll/random
	has_random_spells = TRUE

/obj/item/arcyne_spellobject/spellstone
	name = "arcyne spellstone"
	desc = "A polished stone threaded with arcyne filaments. Hold it to channel its spells."
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "quartz"
	max_spells = 3
	spellobject_flags = SPELLOBJECT_VISUAL

/obj/item/arcyne_spellobject/spellstone/random
	has_random_spells = TRUE

/obj/item/arcyne_spellobject/spellstone/lesser
	name = "lesser arcyne spellstone"
	icon_state = "quartz"
	max_spells = 2
	max_spell_tier = 1

/obj/item/arcyne_spellobject/spellstone/greater
	name = "greater arcyne spellstone"
	icon_state = "sapphire"
	max_spells = 3
	min_spell_tier = 1
	max_spell_tier = 2

/obj/item/arcyne_spellobject/spellstone/supreme
	name = "supreme arcyne spellstone"
	icon_state = "ruby"
	max_spells = 4
	min_spell_tier = 2
	max_spell_tier = 3

/obj/item/arcyne_spellobject/wand
	name = "arcyne wand"
	desc = "A slender wand crackling with stored magic. Point and click to fire."
	icon = 'icons/roguetown/items/wands.dmi'
	icon_state = "wand_lesser"
	w_class = WEIGHT_CLASS_SMALL
	spellobject_flags = SPELLOBJECT_HIJACK_CLICK
	max_spells = 1
	max_spell_tier = 1

/obj/item/arcyne_spellobject/wand/greater
	name = "greater arcyne wand"
	icon_state = "wand_greater"
	max_spells = 2
	min_spell_tier = 1
	max_spell_tier = 2

/obj/item/arcyne_spellobject/wand/chaotic
	name = "chaotic arcyne wand"
	desc = "A warped wand fizzing with wild magic. Something is inside but what?"
	spellobject_flags = SPELLOBJECT_HIJACK_CLICK | SPELLOBJECT_CHAOTIC
	max_spells = 1
	max_spell_tier = 2

/obj/item/arcyne_spellobject/wand/chaotic/random
	name = "chaotic arcyne wand"
	desc = "A warped wand fizzing with wild magic. Something is inside but what?"
	has_random_spells = TRUE

/obj/item/arcyne_spellobject/proc/generate_random_spells()
	var/datum/action/cooldown/spell/spell_type_path = pick(subtypesof(/datum/action/cooldown/spell))
	while(IS_ABSTRACT(spell_type_path) || initial(spell_type_path.spell_tier) < min_spell_tier || initial(spell_type_path.spell_tier) > max_spell_tier || (initial(spell_type_path.spell_flags) & SPELL_UNETCHABLE) || (initial(spell_type_path.spell_flags) & SPELL_ESSENCE))
		spell_type_path = pick(subtypesof(/datum/action/cooldown/spell))

	var/datum/spellobject_entry/E = new()
	E.spell_type = spell_type_path
	E.spell_name = initial(spell_type_path.name)
	E.charges = rand(1, 3)
	stored_spells += E
	update_appearance(UPDATE_OVERLAYS)
