
/obj/effect/decal/cleanable/ritual_rune
	name = "ritual rune"
	desc = "Strange symbols pulse upon the ground..."
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "6"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	obj_flags = NONE
	layer = SIGIL_LAYER
	color = null

	///controls who can invoke and which skill check is used
	var/datum/attribute/skill/magic/magictype = /datum/attribute/skill/magic/arcane
	/// Tile radius used when scanning for co-invokers and nearby atoms. 0 = the rune's own tile only.
	var/runesize = 0
	var/invoker_name = "basic rune"
	/// Shown to players with the appropriate magic skill when they examine the rune
	var/invoker_desc = "a basic rune with no function."
	/// Words spoken aloud by invokers when the rune fires
	var/invocation = "Aiy ele-mayo!"
	/// How many eligible invokers must be standing near the rune for it to fire
	var/req_invokers = 1
	/// Optional override text for the invoker count requirement shown to players
	var/req_invokers_text
	/// Prevents double-activation while a ritual is resolving
	var/rune_in_use = FALSE
	/// If TRUE, qdel is logged with the erasing player's name
	var/log_when_erased = FALSE
	/// Set TRUE when this rune presents a ritual-picker menu rather than having a single fixed ritual
	var/ritual_number = FALSE
	/// If FALSE, this rune can only be placed by admins or special means
	var/can_be_scribed = TRUE
	var/erase_time = 1.5 SECONDS
	var/scribe_delay = 4 SECONDS
	/// If TRUE, the normal scribe-speed boost is suppressed on certain turfs
	var/no_scribe_boost = FALSE
	/// Flat bonus applied to spells or spellbook reading when standing on this rune
	var/spellbonus = 0
	/// Brute damage dealt to the scriber on creation
	var/scribe_damage = 5
	/// Brute damage dealt to each invoker when the rune fires
	var/invoke_damage = 0
	/// If TRUE, the player must supply a keyword when scribing this rune
	var/req_keyword = FALSE
	var/keyword
	/// Global proc path called while the rune is being created (optional)
	var/started_creating
	/// Global proc path called when rune creation is interrupted (optional)
	var/failed_to_create
	var/active = FALSE
	/// Tier of this rune. Used to gate which rituals are available. 0 = no tiers.
	var/tier = 1
	/// Return value of the last ritual's on_finished_recipe
	var/ritual_result
	/// Atoms within runesize of the rune, populated at invoke time
	var/list/atom/movable/atoms_in_range
	/// The runeritual datum instantiated for the current invocation
	var/datum/runerituals/pickritual
	/// Atoms selected to satisfy the ritual's ingredient requirements
	var/list/selected_atoms
	/// For single-ritual runes: the fixed ritual typepath. Leave null when ritual_number = TRUE.
	var/associated_ritual = null
	/// If TRUE, every item with attunement_values on the rune is pulled into selected_atoms
	var/takes_all_items = FALSE

/obj/effect/decal/cleanable/ritual_rune/Initialize(mapload, set_keyword)
	. = ..()
	if(set_keyword)
		keyword = set_keyword

/// Plays the brief flash-and-fade glow when a rune successfully fires.
/obj/effect/decal/cleanable/ritual_rune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix() * 2, alpha = 0, time = 5, flags = ANIMATION_END_NOW)
	sleep(0.5 SECONDS)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)

/// Called when the rune fails to activate. Shows a fizzle and resets rune_in_use.
/obj/effect/decal/cleanable/ritual_rune/proc/fail_invoke()
	visible_message(span_warning("The markings pulse with a small flash of light, then fall dark."))
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/attack_hand(mob/living/user)
	if(!ritual_number && !associated_ritual)
		return ..() // this is basically are we a type 2 rune
	if(GET_MOB_SKILL_VALUE(user, magictype) < SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return

	if(rune_in_use)
		to_chat(user, span_notice("Someone is already using this rune."))
		return
	if(.)
		return

	var/list/invokers = can_invoke(user)
	var/have = length(invokers)
	if(have < req_invokers)
		to_chat(user, span_danger("You need [req_invokers - have] more adjacent invokers to use this rune in such a manner."))
		fail_invoke()
		return

	if(!ritual_number)
		// Single fixed ritual - no menu needed.
		if(associated_ritual)
			invoke(invokers, associated_ritual)
		return

	// Multi-ritual rune: build the ritual list for this rune's tier, then ask.
	var/list/rituals = get_ritual_list_for_rune()
	if(!length(rituals))
		fail_invoke()
		return

	var/chosen_name = input(user, "Rituals", "Vanderlin") as null|anything in rituals
	var/datum/runerituals/chosen = rituals[chosen_name]
	if(!chosen)
		rune_in_use = FALSE
		return
	if(chosen.tier > src.tier)
		to_chat(user, span_hierophant_warning("Your ritual rune is not strong enough to perform this ritual."))
		rune_in_use = FALSE
		return

	invoke(invokers, chosen)
	. = ..()

/// Returns the appropriate ritual list for this rune type and tier.
/// Override on subtype if you need a different pool.
/obj/effect/decal/cleanable/ritual_rune/proc/get_ritual_list_for_rune()
	return GLOB.allowedrunerituallist


/// Marks the rune as in-use and returns the list of eligible invokers.
/// Always includes user as the first entry if supplied.
/obj/effect/decal/cleanable/ritual_rune/proc/can_invoke(mob/living/user = null)
	rune_in_use = TRUE
	var/list/invokers = list()
	if(user)
		invokers += user
	if(req_invokers <= 1)
		return invokers
	for(var/mob/living/invoker in range(runesize, src))
		if(invoker == user)
			continue
		if(!invoker.can_speak() || invoker.stat != CONSCIOUS)
			continue
		if(GET_MOB_SKILL_VALUE(invoker, magictype) > SKILL_LEVEL_NONE)
			invokers += invoker
	return invokers


/obj/effect/decal/cleanable/ritual_rune/proc/invoke(list/invokers, datum/runerituals/runeritual)
	SHOULD_CALL_PARENT(TRUE)
	rune_in_use = FALSE

	// Gather all movable, visible, non-abstract atoms in range.
	atoms_in_range = list()
	for(var/atom/movable/close_atom as anything in range(runesize, src))
		if(isitem(close_atom))
			var/obj/item/close_item = close_atom
			if(close_item.item_flags & ABSTRACT)
				continue
		if(close_atom.invisibility || close_atom == usr || close_atom == src)
			continue
		atoms_in_range += close_atom

	pickritual = new runeritual()

	// Copy requirement and ban lists so we can decrement without mutating the datum.
	var/list/requirements = pickritual.required_atoms.Copy()
	var/list/banned = pickritual.banned_atom_types.Copy()
	selected_atoms = list()

	// Match nearby atoms against requirements.
	for(var/atom/movable/nearby as anything in atoms_in_range)
		for(var/req_type in requirements)
			if(requirements[req_type] <= 0)
				continue
			if(islist(req_type))
				if(!is_type_in_list(nearby, req_type))
					continue
			else if(!istype(nearby, req_type))
				continue
			if(length(banned) && (nearby.type in banned))
				continue
			selected_atoms |= nearby
			requirements[req_type]--

		// Attunement items are always collected when takes_all_items is set.
		if(takes_all_items && isitem(nearby) && length(nearby:attunement_values))
			selected_atoms |= nearby

	// Report any unfulfilled requirements.
	var/list/missing = list()
	for(var/req_type in requirements)
		if(requirements[req_type] <= 0)
			continue
		var/count = requirements[req_type]
		var/label
		if(islist(req_type))
			var/list/options = list()
			for(var/possible as anything in req_type)
				options += pickritual.parse_required_item(possible)
			label = "[count] [english_list(options, and_text = "or")]"
		else
			label = pickritual.parse_required_item(req_type)
		missing += label

	if(length(missing))
		to_chat(usr, span_hierophant_warning("Ritual failed, missing components!"))
		to_chat(usr, span_hierophant_warning("You are missing [english_list(missing)] in order to complete the ritual \"[pickritual.name]\"."))
		fail_invoke()
		return FALSE

	playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
	ritual_result = pickritual.on_finished_recipe(usr, selected_atoms, loc)
	return TRUE

/// Plays invocations, deals damage, and fires the glow after a successful invoke.
/// Call this at the end of every subtype invoke() proc.
/obj/effect/decal/cleanable/ritual_rune/proc/finish_invoke(list/invokers)
	for(var/atom/invoker_atom in invokers)
		if(!isliving(invoker_atom))
			continue
		var/mob/living/M = invoker_atom
		if(invocation)
			M.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			M.apply_damage(invoke_damage, BRUTE)
			to_chat(M, span_italics("[src] saps your strength!"))
	do_invoke_glow()

/obj/effect/decal/cleanable/ritual_rune/arcyne
	name = "arcane ritual rune"
	desc = "Subtype used for arcane rituals — you should not be seeing this."
	magictype = /datum/attribute/skill/magic/arcane
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/ritual_rune/divine
	magictype = /datum/attribute/skill/magic/holy
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/ritual_rune/druid
	magictype = /datum/attribute/skill/magic/druidic
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/ritual_rune/blood
	magictype = /datum/attribute/skill/magic/blood
	can_be_scribed = FALSE
