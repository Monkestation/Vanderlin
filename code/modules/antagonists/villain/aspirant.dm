#define CHOICE_SKILL_SWORD "sword_skill"
#define CHOICE_SKILL_KNIFE "knife_skill"
#define CHOICE_SKILL_BOW "bow_skill"
#define CHOICE_SKILL_MACES "maces_skill"
#define CHOICE_SKILL_LOCKPICKING "lockpicking_skill"
#define CHOICE_SKILL_WRESTLING "wrestling_skill"
#define CHOICE_POISON "poison"
#define CHOICE_GUN "gun"
#define CHOICE_BOMB "bomb"

/datum/antagonist/aspirant
	name = "Aspirant"
	roundend_category = "Aspirant"
	antagpanel_category = "Aspirant"
	job_rank = ROLE_ASPIRANT
	show_name_in_check_antagonists = TRUE
	show_in_roundend = TRUE
	confess_lines = list(
		"THE CHOSEN MUST TAKE THE THRONE!",
	)
	increase_votepwr = TRUE
	antag_flags = FLAG_FAKE_ANTAG
	var/static/list/equipment_selection = list(
		"Killer's Ice (strong poison)" = CHOICE_POISON,
		"Sword Skill" = CHOICE_SKILL_SWORD,
		"Knife Skill" = CHOICE_SKILL_KNIFE,
		"Bow Skill" = CHOICE_SKILL_BOW,
		"Maces Skill" = CHOICE_SKILL_MACES,
		"Lockpicking Skill" = CHOICE_SKILL_LOCKPICKING,
		"Gun" = CHOICE_GUN,
		"Bomb" = CHOICE_BOMB,
	)
	///faction we got backing from
	var/datum/weakref/backing_faction_ref

/datum/antagonist/aspirant/proc/give_equipment_prompt()
	var/chosen = browser_input_list(owner.current, "How shall I rise to power?", "YOUR ADVANTAGE", equipment_selection, default = CHOICE_POISON)
	var/mob/aspirant_mob = owner.current
	chosen = LAZYACCESS(equipment_selection, chosen)
	switch(chosen)
		if(CHOICE_POISON)
			owner.special_items["Poison"] = /obj/item/reagent_containers/glass/bottle/killersice
			to_chat(owner, span_notice("I can retrieve my item from a statue, tree or clock by right clicking it."))

		if(CHOICE_SKILL_SWORD)
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 60, 60)

		if(CHOICE_SKILL_KNIFE)
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/combat/knives, 60, 60)

		if(CHOICE_SKILL_BOW)
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/combat/bows, 60, 60)

		if(CHOICE_SKILL_MACES)
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 60, 60)

		if(CHOICE_SKILL_LOCKPICKING)
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/misc/lockpicking, 60, 60)

		if(CHOICE_GUN)
			owner.special_items["Puffer"] = /obj/item/gun/ballistic/powder/wheellock/puffer
			owner.special_items["Puffer Bullets"] = /obj/item/storage/belt/pouch/bullets
			owner.special_items["Puffet Gunpowder"] = /obj/item/reagent_containers/glass/bottle/aflask
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/combat/firearms, 60, 60)
			to_chat(owner, span_notice("I can retrieve my item from a statue, tree or clock by right clicking it."))

		if(CHOICE_BOMB)
			owner.special_items["Bomb"] = /obj/item/explosive/canister_bomb
			aspirant_mob.clamped_adjust_skill_level(/datum/attribute/skill/craft/bombs, 60, 60)
			to_chat(owner, span_notice("I can retrieve my item from a statue, tree or clock by right clicking it."))


/datum/antagonist/aspirant/supporter
	name = "Supporter"
	show_name_in_check_antagonists = TRUE
	show_in_roundend = TRUE
	increase_votepwr = FALSE

/datum/antagonist/aspirant/ruler
	name = "Ruler"
	show_name_in_check_antagonists = TRUE
	show_in_roundend = FALSE
	increase_votepwr = FALSE
	innate_traits = list(
		TRAIT_ASPIRANT_INSIGHT
	)

/datum/antagonist/aspirant/on_gain()
	. = ..()
	owner.special_role = ROLE_ASPIRANT
	SSmapping.retainer.aspirants |= owner
	addtimer(CALLBACK(src, PROC_REF(give_equipment_prompt)), 5 SECONDS)
	create_objectives()
	owner.announce_objectives()

/datum/antagonist/aspirant/supporter/on_gain()
	SHOULD_CALL_PARENT(FALSE)
	owner.special_role = "Supporter"
	SSmapping.retainer.aspirant_supporters |= owner
	create_objectives()
	owner.announce_objectives()

/datum/antagonist/aspirant/ruler/on_gain()
	SHOULD_CALL_PARENT(FALSE)
	create_objectives()
	owner.current.add_spell(/datum/action/cooldown/sway_faction_head)

/datum/antagonist/aspirant/greet()
	to_chat(owner, span_redtextbig("I have grown weary of being near the throne, but never on it. I have decided that it is time I ruled [SSmapping.config.map_name]."))
	addtimer(CALLBACK(src, PROC_REF(show_supporters_to_aspirant)), 10 SECONDS) // this is ass but I can't think of anything else rn, it's 22:00
	..()

/datum/antagonist/aspirant/supporter/greet()
	to_chat(owner, span_redtextbig("Long live the Monarch! But not this one. I have been approached by an Aspirant and swayed to their cause. I must ensure they take the throne."))
	addtimer(CALLBACK(src, PROC_REF(show_aspirant_to_supporter)), 10 SECONDS) // this is ass but I can't think of anything else rn, it's 22:00

/datum/antagonist/aspirant/ruler/greet() // No alert for the ruler to always keep them guessing.
	return

/datum/antagonist/aspirant/proc/show_aspirant_to_supporter()
	var/datum/mind/aspirant
	for(var/datum/mind/being_checked as anything in SSmapping.retainer.aspirants)
		if(being_checked.antag_datums)
			for(var/datum/antagonist/antag_datum as anything in being_checked.antag_datums)
				if(antag_datum.type == /datum/antagonist/aspirant)
					aspirant = being_checked
	if(!aspirant) // FUCK
		CRASH("Aspirant supporters spawned without an aspirant!")
	to_chat(owner, span_reallybighypnophrase("[aspirant.name] is the one I pledge allegiance to."))

/datum/antagonist/aspirant/proc/show_supporters_to_aspirant()
	var/list/supporters_list = SSmapping.retainer.aspirant_supporters.Copy()

	var/supporters_string_formatted
	for(var/datum/mind/supporter as anything in supporters_list)
		supporters_string_formatted += "[supporter.name] the [supporter.assigned_role.title]<br>"

	if(!length(supporters_list))
		supporters_string_formatted = "I have no supporters!"

	to_chat(owner, "[span_bold("My [span_nicegreen("supporters")] are:")] <br>[span_nicegreen(supporters_string_formatted)]")

/datum/antagonist/aspirant/proc/create_objectives()
	if(istype(src, /datum/antagonist/aspirant/ruler))
		var/datum/objective/aspirant/loyal/one/G = new
		objectives += G
		return

	if(istype(src, /datum/antagonist/aspirant/supporter))
		var/datum/objective/aspirant/coup/two/G = new
		objectives += G
		for(var/datum/mind/aspirant in SSmapping.retainer.aspirants)
			if(aspirant.special_role == ROLE_ASPIRANT)
				G.our_aspirant = aspirant.current
				break
	else
		var/datum/objective/aspirant/coup/one/G = new
		objectives += G

/datum/objective/aspirant/coup/one
	name = "Take the throne"
	explanation_text = "I must ensure that I am crowned as the Monarch."
	triumph_count = 5

/datum/objective/aspirant/coup/one/check_completion()
	if(owner?.current == SSticker.rulermob)
		return TRUE
	else
		return FALSE

/datum/objective/aspirant/coup/two
	name = "Support the Aspirant"
	explanation_text = "I must ensure that the Aspirant takes the throne."
	triumph_count = 3
	var/our_aspirant

/datum/objective/aspirant/coup/two/check_completion()
	if(SSticker.rulermob == our_aspirant)
		return TRUE
	else
		return FALSE

/datum/objective/aspirant/loyal/one
	name = "Keep the throne"
	explanation_text = "I must remain the ruler."
	triumph_count = 3
	hidden = TRUE

/datum/objective/aspirant/loyal/one/check_completion()
	if(owner?.current == SSticker.rulermob)
		return TRUE
	else
		return FALSE

/datum/antagonist/aspirant/roundend_report()
	to_chat(world, span_header(" * [name] * "))

	if(length(objectives))
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(world, span_greentext("The Aspirant has ascended! SUCCESS!"))
		else
			to_chat(world, span_redtext("The Aspirant was thwarted! FAIL!"))

/datum/antagonist/aspirant/ruler/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("You defended your throne! SUCCESS!"))
		else
			to_chat(owner, span_redtext("You were deposed! FAIL!"))

/datum/antagonist/aspirant/supporter/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("Your claimant took the throne! SUCCESS!"))
		else
			to_chat(owner, span_redtext("Your claimant failed! FAIL!"))

/datum/antagonist/aspirant/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(examined_datum.type == /datum/antagonist/aspirant)
		return span_nicegreen("I will hold the crown.")

	if(examined_datum.type == /datum/antagonist/aspirant/supporter)
		return span_nicegreen("It is one of my supporters.")

	if(examined_datum.type == /datum/antagonist/aspirant/ruler)
		return span_userdanger("It is my rival.")

/datum/antagonist/aspirant/supporter/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(examined_datum.type == /datum/antagonist/aspirant)
		return span_nicegreen("It is the Aspirant.")

	if(examined_datum.type == /datum/antagonist/aspirant/supporter)
		return span_nicegreen("It is another supporter of the Aspirant.")

	if(examined_datum.type == /datum/antagonist/aspirant/ruler)
		return span_userdanger("No ruler of mine.")

/datum/antagonist/aspirant/ruler/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	return

#undef CHOICE_SKILL_SWORD
#undef CHOICE_SKILL_KNIFE
#undef CHOICE_SKILL_BOW
#undef CHOICE_SKILL_MACES
#undef CHOICE_SKILL_LOCKPICKING
#undef CHOICE_SKILL_WRESTLING
#undef CHOICE_POISON
#undef CHOICE_GUN
#undef CHOICE_BOMB

/datum/action/cooldown/sway_faction_head
	name = "Sway Faction Head"
	desc = "Convince the head of a noble house to back your claim to the throne."
	button_icon_state = "patronage"
	click_to_activate = TRUE
	cooldown_time = 5 MINUTES
	retrigger_after_cooldown = TRUE

/datum/action/cooldown/sway_faction_head/Activate(atom/target)
	var/mob/living/carbon/human/aspirant_mob = owner
	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/head = target
	var/datum/noble_faction/faction = head.mind?.noble_faction
	if(!faction)
		to_chat(aspirant_mob, span_warning("[head.real_name] leads no house."))
		return FALSE
	if(faction.head_ref?.resolve() != head)
		to_chat(aspirant_mob, span_warning("[head.real_name] doesn't speak for [faction.name]."))
		return FALSE
	if(faction.backing_aspirant_ref?.resolve() == aspirant_mob)
		to_chat(aspirant_mob, span_warning("[faction.name] already stands with you."))
		return FALSE

	var/datum/antagonist/aspirant/aspirant_datum = locate(/datum/antagonist/aspirant) in aspirant_mob.mind?.antag_datums
	if(!aspirant_datum)
		return FALSE

	var/prompt_text = "[aspirant_mob.real_name] asks [faction.name] to back their claim to the throne."
	var/mob/living/carbon/human/current_claimant = faction.backing_aspirant_ref?.resolve()
	if(current_claimant)
		prompt_text += " Doing so breaks your house's allegiance to [current_claimant.real_name]."

	var/answer = tgui_alert(head, prompt_text, "A Proposition", list("Accept", "Decline"))
	if(answer != "Accept")
		to_chat(aspirant_mob, span_warning("[head.real_name] refuses to hear you out."))
		StartCooldown()
		return FALSE

	faction.set_backing_aspirant(aspirant_mob)
	aspirant_datum.backing_faction_ref = WEAKREF(faction)

	to_chat(aspirant_mob, span_notice("[head.real_name] has pledged [faction.name] to your cause."))
	to_chat(head, span_notice("You have pledged [faction.name] to [aspirant_mob.real_name]'s cause."))
	head.add_spell(new /datum/action/cooldown/rally_house(head, faction))

	StartCooldown()
	return TRUE

/datum/action/cooldown/rally_house
	name = "Rally the House"
	desc = "Tell your house who they now serve."
	button_icon_state = "patronage"
	click_to_activate = TRUE
	cooldown_time = 0
	retrigger_after_cooldown = FALSE
	var/datum/noble_faction/faction

/datum/action/cooldown/rally_house/New(Target, datum/noble_faction/faction)
	. = ..()
	src.faction = faction

/datum/action/cooldown/rally_house/Activate(atom/target)
	if(!faction)
		return FALSE
	for(var/mob/living/carbon/human/member as anything in faction.members)
		to_chat(member, span_reallybighypnophrase("[faction.name] now stands behind a claimant to the throne."))
		member.mind?.add_antag_datum(/datum/antagonist/aspirant/supporter)
	Remove(owner)
	return TRUE
