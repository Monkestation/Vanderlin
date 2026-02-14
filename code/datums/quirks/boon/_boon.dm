/datum/quirk/boon
	abstract_type = /datum/quirk/boon
	quirk_category = QUIRK_BOON

/datum/quirk/boon/keen_eye
	name = "Keen Eye"
	desc = "Years of hunting and tracking have honed your sight. You're better at noticing details and spotting hidden things."
	point_value = -5
	incompatible_quirks = list(
		/datum/quirk/vice/bad_sight
	)

/datum/quirk/boon/light_footed
	name = "Light Footed"
	desc = "You move with grace and agility. Your steps are quieter then most."
	point_value = -6

/datum/quirk/boon/light_footed/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, "[type]")

/datum/quirk/boon/light_footed/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, "[type]")

/datum/quirk/boon/quick_learner
	name = "Quick Learner"
	desc = "You pick up new skills faster than most. Your mind is sharp and eager to learn."
	point_value = -5

/datum/quirk/boon/iron_will
	name = "Iron Will"
	desc = "Your resolve is unshakeable. You handle the horrors of war better then most."
	point_value = -4

/datum/quirk/boon/iron_will/on_spawn()
	ADD_TRAIT(owner, TRAIT_STEELHEARTED, "[type]")

/datum/quirk/boon/iron_will/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_STEELHEARTED, "[type]")

/datum/quirk/boon/composed
	name = "Composed"
	desc = "You handle stress better than most. Pressure doesn't get to you as easily."
	point_value = -3

/datum/quirk/boon/composed/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(prob(1) && H.get_stress_amount() > 5)
		H.adjust_stress(-1)

/* This is a future idea
/datum/quirk/boon/light_sleeper
	name = "Light Sleeper"
	desc = "You wake easily and need less sleep than most. Years of dangerous living have trained you to be alert even in rest."
	point_value = -2

/datum/quirk/boon/light_sleeper/on_spawn()
	ADD_TRAIT(owner, TRAIT_LIGHT_SLEEPER, "[type]")

/datum/quirk/boon/light_sleeper/on_remove()
	REMOVE_TRAIT(owner, TRAIT_LIGHT_SLEEPER, "[type]")
*/

/datum/quirk/boon/second_language
	name = "Second Language"
	desc = "You know an additional language."
	quirk_category = QUIRK_BOON
	point_value = -1
	customization_label = "Choose Language"
	customization_options = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/deepspeak,
		/datum/language/zalad,
		/datum/language/oldpsydonic,
		/datum/language/hellspeak,
		/datum/language/orcish,
	)

/datum/quirk/boon/second_language/on_spawn()
	if(!customization_value || !ispath(customization_value, /datum/language))
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.grant_language(customization_value)

/datum/quirk/boon/pet
	name = "Loyal Companion"
	desc = "You have a loyal animal companion that will follow and protect you."
	point_value = -3
	customization_label = "Choose Pet Type"
	preview_render = FALSE
	customization_options = list(
		/mob/living/simple_animal/pet/cat/cabbit,
		/mob/living/simple_animal/pet/cat/black,
		/mob/living/simple_animal/hostile/retaliate/frog,
		/mob/living/simple_animal/hostile/retaliate/chicken,
		/mob/living/simple_animal/hostile/retaliate/fox,
		/mob/living/simple_animal/hostile/retaliate/raccoon,
	)

	/// Reference to the spawned pet
	var/mob/living/simple_animal/pet_mob

/datum/quirk/boon/pet/on_spawn()
	if(!get_turf(owner))
		addtimer(CALLBACK(src, PROC_REF(on_spawn)), 0.5 SECONDS)
		return

	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	// Check if a pet type was selected
	if(!customization_value || !ispath(customization_value, /mob/living/simple_animal))
		customization_value = /mob/living/simple_animal/pet/cat/black

	// Spawn the pet at the owner's location
	pet_mob = new customization_value(get_turf(H))

	if(!pet_mob)
		return

	// Tame the pet to the owner
	pet_mob.tamed(H)
	ADD_TRAIT(pet_mob, TRAIT_TINY, "[type]")

	// Set a name if the pet doesn't have a unique one
	if(pet_mob.name == initial(pet_mob.name))
		var/new_name = stripped_input(H, "What is your pet's name?", "Pet Name", initial(pet_mob.name), MAX_NAME_LEN)
		if(new_name)
			pet_mob.fully_replace_character_name(null, new_name)

	var/datum/component/obeys_commands/command_component = pet_mob.GetComponent(/datum/component/obeys_commands)
	if(command_component)
		var/datum/pet_command/follow/follow_command = command_component.available_commands["Follow"]
		if(follow_command)
			pet_mob.ai_controller?.set_blackboard_key(BB_CURRENT_PET_TARGET, H)
			follow_command.execute_action(pet_mob.ai_controller)

/datum/quirk/boon/pet/on_remove()
	// Don't delete the pet when quirk is removed, just release it
	if(pet_mob && !QDELETED(pet_mob))
		pet_mob.owner = null
		pet_mob.tame = FALSE
		pet_mob = null

/datum/quirk/boon/pet/get_option_name(option)
	if(ispath(option, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = option
		return initial(A.name)
	return ..()

/datum/quirk/boon/folk_hero
	name = "Folk Hero"
	desc = "You're a local legend who saved your community from great danger. People recognize you, even as a foreigner."
	point_value = -10
	blocked_ages = list(
		AGE_CHILD,
	)
	preview_render = FALSE

/datum/quirk/boon/folk_hero/on_spawn()
	if(!ishuman(owner))
		return
	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/quirk/boon/folk_hero/on_remove()
	if(!ishuman(owner))
		return
	UnregisterSignal(owner, COMSIG_PARENT_EXAMINE)

/datum/quirk/boon/folk_hero/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	if(!ishuman(user) || !ishuman(source))
		return

	var/mob/living/carbon/human/source_mob = source
	var/mob/living/carbon/human/examiner = user

	if(!examiner.mind || !source_mob.mind)
		return

	// Folk heroes are recognized by others
	if(prob(80)) // 80% chance people recognize them
		examine_list += span_notice("You recognize [source_mob.real_name], the folk hero!")

		// Add them to known people if not already known
		if(!examiner.mind.do_i_know(source_mob.mind))
			examiner.mind.share_identities(source_mob.mind)

/datum/quirk/boon/quick_hands
	name = "Quick Hands"
	desc = "You have great hand-eye coordination and know how to move your fingers fast. All crafts are 10% faster."
	point_value = -4

/datum/quirk/boon/quick_hands/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_QUICK_HANDS, "[type]")

/datum/quirk/boon/quick_hands/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_QUICK_HANDS, "[type]")

/datum/quirk/boon/naturalist
	name = "Naturalist"
	desc = "Your body is attuned to the natural world. You extract more nourishment from unprocessed, natural foods - fruits, vegetables, and simple preparations sustain you better than they do others."
	point_value = -8

/datum/quirk/boon/naturalist/on_spawn()
	ADD_TRAIT(owner, TRAIT_FORAGER, "[type]")

/datum/quirk/boon/naturalist/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_FORAGER, "[type]")

/datum/quirk/boon/always_prepared
	name = "Always Prepared"
	desc = "You start with a cart, lantern, and tent. You're ready for anything."
	point_value = -6
	preview_render = FALSE
	incompatible_quirks = list(
		/datum/quirk/vice/rough_start,
	)
	customization_label = "With or Without Cart"
	customization_options = list(
		"With Cart",
		"Without Cart"
	)

	var/obj/item/flashlight/flare/torch/lantern/L
	var/obj/item/tent_kit/tent

/datum/quirk/boon/always_prepared/on_spawn()
	if(!owner)
		return
	if(!customization_value)
		customization_value = "Without Cart"


	var/turf/T = get_turf(owner)

	if(customization_value == "With Cart")
		L = new(T)
		tent = new(T)
		var/obj/structure/handcart/cart = new(T)
		cart.put_in(null, L)
		cart.put_in(null, tent)

	to_chat(owner, span_notice("Your equipment is ready. You're well prepared for the journey ahead."))

/datum/quirk/boon/always_prepared/after_job_spawn(datum/job/job)
	if(customization_value == "Without Cart") // we run this shit back incase jobs changed stuff
		var/turf/T = get_turf(owner)
		L = new(T)
		tent = new(T)
		if(!owner.equip_to_appropriate_slot(L) || isturf(L.loc)) //missing a limb can cause phantom success procs
			for(var/obj/item/storage/storage in owner.contents)
				if(storage)
					if(SEND_SIGNAL(storage, COMSIG_TRY_STORAGE_INSERT, L, null))
						break
		if(!owner.equip_to_appropriate_slot(tent)|| isturf(tent.loc))
			for(var/obj/item/storage/storage in owner.contents)
				if(storage)
					if(SEND_SIGNAL(storage, COMSIG_TRY_STORAGE_INSERT, tent, null))
						break
	L = null
	tent = null

/datum/quirk/boon/packmule
	name = "Packmule"
	desc = "There's no such thing as having too much storage! You start with a backpack."
	point_value = -8
	preview_render = FALSE

	var/obj/item/storage/backpack/B

/datum/quirk/boon/packmule/after_job_spawn(datum/job/job)
	var/turf/T = get_turf(owner)
	B = new(T)
	if(!owner.equip_to_appropriate_slot(B) || isturf(B.loc)) //missing a limb can cause phantom success procs
		for(var/obj/item/storage/storage in owner.contents)
			if(storage)
				if(SEND_SIGNAL(storage, COMSIG_TRY_STORAGE_INSERT, B, null))
					break
	B = null

/datum/quirk/boon/rider
	name = "Experienced Rider"
	desc = "You begin with expert riding skills and your own mount."
	point_value = -6
	preview_render = FALSE

/datum/quirk/boon/rider/on_spawn()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	var/turf/T = get_turf(owner)
	if(!T)
		return
	var/mob/living/simple_animal/hostile/retaliate/saiga/S = new(T)
	S.tamed(H)

	to_chat(owner, span_notice("Your trusted mount awaits you."))

/datum/quirk/boon/rider/after_job_spawn(datum/job/job)
	. = ..()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	H.clamped_adjust_skillrank(/datum/skill/misc/riding, 2, 2, TRUE)

/datum/quirk/boon/beautiful
	name = "Strikingly Beautiful"
	desc = "You are remarkably attractive, improving social interactions."
	point_value = -4

/datum/quirk/boon/beautiful/on_spawn()
	if(!owner)
		return

	ADD_TRAIT(owner, TRAIT_BEAUTIFUL, "[type]")

	to_chat(owner, span_notice("You catch your reflection and can't help but admire yourself."))

/datum/quirk/boon/beautiful/on_remove()
	if(!owner)
		return
	REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, "[type]")
