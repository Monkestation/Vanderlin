// Once a blessing Dendor's champions, now a curse suffering endless hunger from Graggar's corruption.

/datum/antagonist/werewolf
	name = "Werevolf"
	roundend_category = "Werewolves"
	antagpanel_category = "Werewolf"
	job_rank = ROLE_WEREWOLF
	antag_hud_type = ANTAG_HUD_WEREWOLF
	antag_hud_name = "werewolf"
	confess_lines = list(
		"THE BEAST INSIDE ME!",
		"BEWARE THE BEAST!",
		"MY LUPINE MARK!",
	)
	var/special_role = ROLE_WEREWOLF
	/// Are we currently out of our human form? Redundancy to easily check for transformation
	var/transformed
	/// How much rage decays by while transformed
	var/transformed_rage_decay = 5

	var/wolfname = "Werevolf"
	var/list/datum/action/werewolf_form_powers = list(
		/datum/action/cooldown/spell/undirected/howl, \
		/datum/action/cooldown/spell/undirected/claws, \
		/datum/action/cooldown/spell/aoe/repulse/howl, \
		/datum/action/cooldown/spell/woundlick, \
		/datum/action/cooldown/spell/lunge, \
		/datum/action/cooldown/spell/throw_target
	)
	COOLDOWN_DECLARE(message_cooldown)

	innate_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_BESTIALSENSE,
		TRAIT_BRUSHWALK
	)

/datum/antagonist/werewolf/lesser
	name = "Lesser Werevolf"
	antag_hud_type = ANTAG_HUD_WEREWOLF
	antag_hud_name = "werewolf_lesser"
	increase_votepwr = FALSE

/datum/antagonist/werewolf/lesser/roundend_report()
	return

/datum/antagonist/werewolf/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/werewolf/lesser))
		return span_boldnotice("A young lupine kin.")
	if(istype(examined_datum, /datum/antagonist/werewolf))
		return span_boldnotice("An elder lupine kin.")
	if(examiner.Adjacent(examined))
		if(istype(examined_datum, /datum/antagonist/vampire/lord))
			if(transformed)
				return span_boldwarning("An Ancient Vampire. I must be careful!")
		if(istype(examined_datum, /datum/antagonist/vampire))
			if(transformed)
				return span_boldwarning("A vampire.")

/datum/antagonist/werewolf/on_gain()
	SSmapping.retainer.werewolves |= owner
	owner.special_role = name
	if(increase_votepwr)
		forge_werewolf_objectives()
	owner.current.add_spell(/datum/action/cooldown/spell/undirected/werewolf_form)
	owner.current.grant_language(/datum/language/beast)

	var/datum/rage/werewolf/new_rage = new
	new_rage.grant_to_holder(owner.current)
	RegisterSignal(owner.current, COMSIG_RAGE_BOTTOMED, PROC_REF(remove_werewolf))
	RegisterSignal(owner.current, COMSIG_RAGE_OVERRAGE, PROC_REF(begin_transform))

	wolfname = "[pick(strings("werewolf_names.json", "wolf_prefixes"))] [pick(strings("werewolf_names.json", "wolf_suffixes"))]"
	return ..()

/datum/antagonist/werewolf/on_removal()
	remove_werewolf(forced = TRUE)
	// owner.current should now be the original human mob, if not something is terribly wrong
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("I am no longer a [special_role]!"))
	owner.special_role = null
	owner.current.remove_spell(/datum/action/cooldown/spell/undirected/werewolf_form)
	owner.current.remove_language(/datum/language/beast)

	UnregisterSignal(owner.current, list(COMSIG_RAGE_BOTTOMED, COMSIG_RAGE_OVERRAGE))
	if(ishuman(owner.current))
		var/mob/living/carbon/human/current_human = owner.current
		QDEL_NULL(current_human.rage_datum)

	return ..()

/datum/antagonist/werewolf/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/werewolf/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/werewolf/proc/forge_werewolf_objectives()
	var/list/primary = pick(list("1","2"))
	var/list/secondary = pick(list("1", "2"))
	switch(primary)
		if("1")
			objectives += new /datum/objective/dominate/werewolf()
		if("2")
			var/datum/objective/werewolf/spread/T = new
			objectives += T
	switch(secondary)
		if("1")
			var/datum/objective/werewolf/infiltrate/one/T = new
			objectives += T
		if("2")
			var/datum/objective/werewolf/infiltrate/two/T = new
			objectives += T

	var/datum/objective/werewolf/survive/survive = new
	objectives += survive

/datum/antagonist/werewolf/greet()
	to_chat(owner.current, span_userdanger("Ever since that bite, I have been a [name]."))
	owner.announce_objectives()
	return ..()

/mob/living/carbon/human/proc/can_werewolf()
	if(!mind)
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/werewolf_check(werewolf_type = /datum/antagonist/werewolf/lesser)
	if(!mind)
		return
	var/already_wolfy = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(already_wolfy)
		return already_wolfy
	if(!can_werewolf())
		return
	return mind.add_antag_datum(werewolf_type)

/mob/living/carbon/human/proc/werewolf_infect_attempt()
	var/datum/antagonist/werewolf/wolfy = werewolf_check()
	var/mob/living/carbon/human/H = src
	if(istype(H.wear_neck, /obj/item/clothing/neck/psycross/silver) || istype(H.wear_wrists, /obj/item/clothing/neck/psycross/silver) )
		if(prob(50))
			return
	if(!wolfy)
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return
	to_chat(src, span_danger("I feel horrible... REALLY horrible..."))
	MOBTIMER_SET(src, MT_PUKE)
	vomit(1, blood = TRUE, stun = FALSE)
	return wolfy

/mob/living/carbon/human/proc/werewolf_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	if(src.has_status_effect(/datum/status_effect/debuff/silver_bane))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/clothing/armor/regenerating/skin/werewolf_skin
	slot_flags = null
	name = "werevolf's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	resistance_flags = FIRE_PROOF
	armor = ARMOR_BRIGANDINE
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = INTEGRITY_STRONG
	item_flags = DROPDEL
	repair_time = 15 SECONDS

/datum/intent/simple/werewolf
	name = "claw"
	icon_state = "inclaw"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "claw"
	hitsound = "genslash"
	penfactor = 45
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_damage_type = "slash"

/obj/item/weapon/werewolf_claw
	name = "verevolf claw"
	desc = ""
	icon = 'icons/roguetown/weapons/32/special.dmi'
	item_state = null
	lefthand_file = null
	righthand_file = null
	max_blade_int = 900
	max_integrity = 900
	force = 15
	block_chance = 0
	wdefense = AVERAGE_PARRY
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = EASY_TO_DODGE
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL

/obj/item/weapon/werewolf_claw/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/werewolf_claw/right
	icon_state = "claw_r"

/obj/item/weapon/werewolf_claw/left
	icon_state = "claw_l"

/obj/item/weapon/werewolf_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)
