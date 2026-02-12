GLOBAL_LIST_EMPTY_TYPED(vampire_clans, /datum/clan)	//>:3

/*
This datum stores a declarative description of clans, in order to make an instance of the clan component from this implementation in runtime
And it also helps for the character set panel
*/
/datum/clan
	var/name = "Caitiff"
	var/desc = "The clanless. The rabble. Of no importance."

	var/list/clan_covens = list() //coven datums
	var/list/restricted_covens = list()
	var/list/common_covens = list() //Covens that you don't start with but are easier to purchase like catiff instead of non clan discs

	/// List of traits that are applied to members of this Clan
	var/list/clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_NOENERGY,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_NOAMBUSH,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
	)

	var/blood_preference = BLOOD_PREFERENCE_ALL

	var/list/disliked_clans = list()
	var/list/liked_clans = list()


	var/list/clan_members = list()
	var/list/non_vampire_members = list()
	/// Whether this clan allows non-vampire members
	var/allows_non_vampires = TRUE
	/// Title for non-vampire members
	var/non_vampire_title = "Slave"
	var/datum/clan_hierarchy_node/hierarchy_root
	var/list/datum/clan_hierarchy_node/all_positions = list()
	var/curse = "None."

	var/clane_curse //There should be a reference here.
	///The Clan's unique body sprite
	var/alt_sprite
	///If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale = FALSE

	var/humanitymod = 1
	var/frenzymod = 1
	var/start_humanity = 7
	var/is_enlightened = FALSE
	var/whitelisted = FALSE
	var/accessories = list()
	var/accessories_layers = list()
	var/current_accessory

	var/mob/living/clan_leader
	var/leader_title = "Vampire Lord"
	var/datum/clan_leader/leader = /datum/clan_leader/lord
	var/force_VL_if_clan_is_empty = TRUE
	var/selectable_by_vampires = TRUE // Set to FALSE for clans that shouldn't be selectable

/datum/clan/proc/get_downside_string()
	return "burn in sunlight"

/datum/clan/proc/get_blood_preference_string()
	return "any blood"

/datum/clan/proc/handle_bloodsuck(mob/living/carbon/human/drinker, blood_types)
	var/unwanted_blood = (blood_types & ~blood_preference)

	if(blood_types & BLOOD_PREFERENCE_EUPHORIC)
		drinker.apply_status_effect(/datum/status_effect/debuff/blood_euphoria)

	if(!unwanted_blood)
		return
	drinker.apply_status_effect(/datum/status_effect/debuff/blood_disgust)
	to_chat(drinker, span_warning("This blood tastes revolting to you!"))

/datum/clan/proc/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	initialize_rune_words()

	var/datum/action/clan_menu/menu_action = new /datum/action/clan_menu(H.mind)
	menu_action.Grant(H)

	// Add to appropriate member lists
	clan_members |= H
	if(is_vampire)
		apply_clan_components(H)
		RegisterSignal(H, COMSIG_HUMAN_LIFE, PROC_REF(on_vampire_life))

		// Apply vampire-specific traits
		for (var/trait in clane_traits)
			ADD_TRAIT(H, trait, "clan")

		// Apply vampire-specific changes
		H.has_reflection = FALSE
		H.cut_overlay(H.reflective_icon)
		H.mob_biotypes = MOB_UNDEAD

		if(alt_sprite)
			if (!alt_sprite_greyscale)
				H.skin_tone = "#fff4e6"
			H.dna.species.limbs_id = alt_sprite
			H.update_body_parts()
			H.update_body()

		setup_vampire_abilities(H)
		apply_vampire_look(H)

		var/datum/component/vampire_disguise/disguise_comp = H.GetComponent(/datum/component/vampire_disguise)
		disguise_comp.apply_disguise(H)

		H.playsound_local(get_turf(H), 'sound/music/vampintro.ogg', 80, FALSE, pressure_affected = FALSE)
		for(var/datum/coven/coven as anything in clan_covens)
			H.give_coven(coven)
	else
		non_vampire_members |= H
		// Apply non-vampire specific benefits (lighter version)
		apply_non_vampire_look(H)

	// Handle accessories for all members
	if(length(accessories))
		if(current_accessory)
			H.remove_overlay(accessories_layers[current_accessory])
			var/mutable_appearance/acc_overlay = mutable_appearance('icons/effects/clan.dmi', current_accessory, -accessories_layers[current_accessory])
			H.overlays_standing[accessories_layers[current_accessory]] = acc_overlay
			H.apply_overlay(accessories_layers[current_accessory])

	if(!hierarchy_root)
		initialize_hierarchy()

	handle_member_joining(H, is_vampire)
	post_gain(H)


/datum/clan/proc/apply_non_vampire_look(mob/living/carbon/human/H)
	// Subtle changes for non-vampires - they look more human but with slight clan influence
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)

	if(eyes && prob(50)) // Only sometimes change eye color
		eyes.heterochromia = FALSE
		eyes.eye_color = "#AA0000" // Darker red than vampires

	H.update_body()
	H.update_body_parts(redraw = TRUE)


/datum/clan/proc/add_non_vampire_member(mob/living/carbon/human/H)
	if(!allows_non_vampires)
		return FALSE

	if(H in clan_members)
		return FALSE // Already a member

	H.clan = src
	on_gain(H, is_vampire = FALSE)

	to_chat(H, "<span class='notice'>You have been inducted into [name] as a [non_vampire_title]!</span>")

	// Announce to clan
	for(var/mob/living/carbon/human/member in clan_members)
		if(member != H)
			to_chat(member, "<span class='notice'>[H.real_name] has joined [name] as a [non_vampire_title].</span>")

	return TRUE

/datum/clan/proc/handle_member_joining(mob/living/carbon/human/H, is_vampire = TRUE)
	// If no clan leader exists, make this person the leader (vampires only)
	if(!clan_leader && is_vampire && force_VL_if_clan_is_empty)
		hierarchy_root.assign_member(H)
		if(ispath(leader))
			var/datum/clan_leader/new_leader = new leader()
			leader = new_leader
		leader.lord_title = leader_title
		leader.make_new_leader(H)
		clan_leader = H
		to_chat(H, "<span class='notice'>You have been appointed as the [leader_title] of [name]!</span>")
		return

	// Otherwise, they join as an unassigned member
	var/member_type = is_vampire ? "vampire" : non_vampire_title
	to_chat(H, "<span class='notice'>You have joined [name] as a [member_type]! Speak with leadership for position assignment.</span>")

/datum/clan/proc/initialize_hierarchy()
	if(hierarchy_root)
		return

	// Create the root leadership position
	hierarchy_root = new /datum/clan_hierarchy_node("Clan Leader", "The supreme leader of the clan", 0)
	hierarchy_root.position_color = "#gold"
	hierarchy_root.can_assign_positions = TRUE
	hierarchy_root.max_subordinates = 10
	all_positions += hierarchy_root


/datum/clan/proc/create_position(position_name, position_desc, datum/clan_hierarchy_node/superior_position, rank_level)
	if(!superior_position || !superior_position.can_assign_positions)
		return null

	var/datum/clan_hierarchy_node/new_position = new /datum/clan_hierarchy_node(position_name, position_desc, rank_level)

	if(superior_position.add_subordinate(new_position))
		all_positions += new_position
		return new_position
	else
		qdel(new_position)
		return null

/datum/clan/proc/remove_position(datum/clan_hierarchy_node/position)
	if(!position || position == hierarchy_root)
		return FALSE // Can't remove root position

	if(position.superior)
		for(var/datum/clan_hierarchy_node/subordinate in position.subordinates)
			position.superior.add_subordinate(subordinate)

	position.remove_member()
	if(position.superior)
		position.superior.remove_subordinate(position)

	all_positions -= position
	qdel(position)
	return TRUE

/datum/clan/proc/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/sunlight_vulnerability)
	H.AddComponent(/datum/component/vampire_disguise)


/datum/clan/proc/disable_covens(mob/living/carbon/human/vampire)
	for(var/coven as anything in vampire.covens)
		var/datum/coven/real_coven = vampire.covens[coven]
		if(real_coven?.coven_action?.active)
			real_coven.current_power?.deactivate()

/**
 * Undoes the effects of on_gain to more or less
 * remove the effects of gaining the Clan. By default,
 * this proc only removes unique traits and resets
 * the mob's alternative sprite.
 *
 * Arguments:
 * * vampire - Human losing the Clan.
 */
/datum/clan/proc/on_lose(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	UnregisterSignal(vampire, COMSIG_HUMAN_LIFE)

	// Remove unique Clan feature traits
	for (var/trait in clane_traits)
		REMOVE_TRAIT(vampire, trait, "clan")


	vampire.update_body()

	var/datum/component/sunlight_vulnerability/sun_comp = vampire.GetComponent(/datum/component/sunlight_vulnerability)
	if(sun_comp)
		qdel(sun_comp)

	var/datum/component/vampire_disguise/disguise_comp = vampire.GetComponent(/datum/component/vampire_disguise)
	if(disguise_comp)
		qdel(disguise_comp)

	vampire.has_reflection = TRUE
	vampire.create_reflection()
	vampire.update_reflection()

	clan_members -= vampire

	if(vampire.clan_position)
		vampire.clan_position.remove_member()

	for(var/datum/coven/coven as anything in clan_covens)
		vampire.remove_coven(coven)

	var/list/spells_to_remove = list(
		/datum/action/clan_menu,
		/datum/action/cooldown/spell/undirected/transfix,
	)
	for(var/spell_type in spells_to_remove)
		var/datum/action/spell_instance = locate(spell_type) in vampire.actions
		if(spell_instance)
			spell_instance.Remove(vampire)

	remove_verb(vampire, /mob/living/carbon/human/proc/disguise_button)
	remove_verb(vampire, /mob/living/carbon/human/proc/vampire_telepathy)

	if(vampire == clan_leader)
		leader.remove_leader(vampire)
		clan_leader = null
		handle_leadership_succession()

/datum/clan/proc/handle_leadership_succession()
	// Find someone else with a position to promote
	var/mob/living/carbon/human/new_leader

	// Look for someone with can_assign_positions (like a lieutenant)
	for(var/datum/clan_hierarchy_node/position in all_positions)
		if(position.can_assign_positions && position.assigned_member)
			new_leader = position.assigned_member
			position.remove_member() // Remove from old position
			break

	// If no lieutenants, pick any positioned member
	if(!new_leader)
		for(var/datum/clan_hierarchy_node/position in all_positions)
			if(position != hierarchy_root && position.assigned_member)
				new_leader = position.assigned_member
				position.remove_member() // Remove from old position
				break

	// If still no one, pick any clan member
	if(!new_leader && length(clan_members))
		new_leader = pick(clan_members)

	if(new_leader)
		hierarchy_root.assign_member(new_leader)
		leader.make_new_leader(new_leader)

		to_chat(new_leader, "<span class='notice'>You have been promoted to [leader_title] of [name]!</span>")

		// Announce to clan
		for(var/mob/living/carbon/human/member in clan_members)
			if(member != new_leader)
				to_chat(member, "<span class='notice'>[new_leader.real_name] has become the new [leader_title] of [name].</span>")


/datum/clan/proc/frenzy_message(mob/living/message)
	to_chat(message,"I'm full of <span class='danger'><b>ANGER</b></span>, and I'm about to flare up in <span class='danger'><b>RAGE</b></span>.")

/datum/clan/proc/adjust_bloodpool_size(adjust)
	for(var/mob/living/mob as anything in clan_members)
		mob.maxbloodpool += adjust

/datum/clan/proc/on_vampire_life(mob/living/carbon/human/H)
	H.process_vampire_life()

/datum/clan/proc/setup_vampire_abilities(mob/living/carbon/human/H)
	add_verb(H, /mob/living/carbon/human/proc/disguise_button)
	add_verb(H, /mob/living/carbon/human/proc/vampire_telepathy)


	H.cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

	H.adjust_skillrank(/datum/skill/magic/blood, 2, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/misc/athletics, 5, 5, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 4, 4, TRUE)
	H.change_stat(STATKEY_STR, pick(1,2))
	H.change_stat(STATKEY_SPD, 1)
	H.remove_stat_modifier(STATMOD_AGE)
	var/datum/action/cooldown/spell/undirected/transfix/transfix = new(H.mind)
	transfix.Grant(H)


/datum/clan/proc/apply_vampire_look(mob/living/carbon/human/H)
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)

	// Apply vampire appearance
	H.skin_tone = "c9d3de"
	H.set_hair_color("#181a1d", FALSE)
	H.set_facial_hair_color("#181a1d", FALSE)

	if(eyes)
		eyes.heterochromia = FALSE
		eyes.eye_color = "#FF0000"

	H.update_organ_colors()
	H.update_body()
	H.update_body_parts(redraw = TRUE)

/datum/clan/proc/post_gain(mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)
	if(!clan_leader && ispath(leader) && force_VL_if_clan_is_empty)
		var/datum/clan_leader/new_leader = new leader()
		leader = new_leader
		leader.lord_title = leader_title
		leader.make_new_leader(H)
		clan_leader = H


/datum/clan/proc/add_coven_to_clan(datum/coven/new_coven, give_to_all = TRUE)
	if(new_coven in clan_covens)
		return FALSE // Already have this coven

	clan_covens += new_coven

	if(give_to_all)
		// Give the coven to all current clan members
		for(var/mob/living/carbon/human/member in clan_members)
			if(member in non_vampire_members)
				continue
			member.give_coven(new_coven)
			to_chat(member, "<span class='notice'>Your clan has gained access to the [new_coven.name] coven!</span>")

	return TRUE

/datum/clan/proc/handle_fear(mob/vampire, atom/fear)
	return FALSE

/datum/clan/proc/return_fear_list()
	return GLOB.fires_list + SShotspots.hotspots

/datum/clan/proc/return_fear(mob/vampire)
	var/list/fears = return_fear_list()
	for(var/atom/atom in fears)
		if(atom.z != vampire.z)
			continue
		if(get_dist(vampire, atom) > 7)
			continue
		return atom
/**
 * Gives the human an established vampiric Clan, applying
 * on_gain effects and post_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */
/mob/living/carbon/human/proc/set_clan_direct(datum/clan/new_clan)
	var/datum/clan/previous_clan = clan
	previous_clan?.on_lose(src)
	clan = new_clan
	if (!new_clan)
		return
	clan.on_gain(src)


/**
 * Gives the human a vampiric Clan, applying
 * on_gain effects and post_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */

/mob/living/carbon/human/proc/set_clan(setting_clan, joining_round)
	if(!length(GLOB.vampire_clans))
		for(var/clan_type in subtypesof(/datum/clan))
			var/datum/clan/clan = new clan_type
			GLOB.vampire_clans[clan_type] = clan
		sortList(GLOB.vampire_clans)

	var/datum/clan/previous_clan = clan

	// Convert typepaths to Clan singletons, or just directly assign if already singleton
	var/datum/clan/new_clan = ispath(setting_clan) ? GLOB.vampire_clans[setting_clan] : setting_clan

	previous_clan?.on_lose(src)

	clan = new_clan

	if (!new_clan)
		return

	clan.on_gain(src, joining_round)

/datum/clan/proc/open_clan_menu(mob/living/carbon/human/user)
	if(!user.covens || !length(user.covens))
		to_chat(user, "<span class='warning'>You have no covens to manage!</span>")
		return

	user.open_clan_menu()

/datum/action/clan_menu
	name = "Clan Menu"
	desc = "Open your clan's power management interface"
	background_icon_state = "spell"
	button_icon_state = "coven"

/datum/action/clan_menu/Trigger(trigger_flags)
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/user = owner
	if(!user.clan)
		to_chat(user, "<span class='warning'>You have no clan!</span>")
		return

	user.open_clan_menu()


/datum/status_effect/debuff/blood_disgust
	id = "blood_disgust"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_disgust
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/blood_disgust
	name = "Sanguine Curse"
	desc = span_warning("This type of blood does not go down well.")
	icon_state = "hunger2"

/datum/status_effect/debuff/blood_disgust/on_apply()
	. = ..()
	if(.)
		owner.add_stress(/datum/stress_event/bad_blood)
		owner.adjustBruteLoss(5)

/datum/status_effect/debuff/blood_disgust/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/bad_blood)

/datum/stress_event/bad_blood
	desc = span_warning("That blood was revolting!")
	stress_change = 3
	max_stacks = 10
	stress_change_per_extra_stack = 3
	timer = 10 MINUTES


/datum/status_effect/debuff/blood_euphoria
	id = "blood_euphoria"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_euphoria
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/buff/blood_euphoria
	name = "Sanguine Euphoria"
	desc = span_good("This type of blood goes down incredibly well.")
	icon_state = "hunger2"

/datum/status_effect/buff/blood_euphoria/on_apply()
	. = ..()
	if(.)
		owner.add_stress(/datum/stress_event/good_blood)
		owner.adjustBruteLoss(-5)

/datum/status_effect/buff/blood_euphoria/tick()
	. = ..()
	owner.adjustBruteLoss(-2)

/datum/status_effect/buff/blood_euphoria/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/good_blood)

/datum/stress_event/good_blood
	desc = span_good("That blood was euphoric!")
	stress_change = 3
	max_stacks = 10
	stress_change_per_extra_stack = 3
	timer = 10 MINUTES
