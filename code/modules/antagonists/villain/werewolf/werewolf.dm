/datum/antagonist/werewolf
	name = "Verewolf"
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
	//rogue_enabled = TRUE
	var/special_role = ROLE_WEREWOLF
	var/transformed
	var/transforming
	var/untransforming
	var/wolfname = "Verewolf"

/datum/antagonist/werewolf/lesser
	name = "Lesser Verewolf"
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
				return span_boldwarning("A lesser Vampire.")

/datum/antagonist/werewolf/on_gain()
	owner.special_role = name
	if(increase_votepwr)
		forge_werewolf_objectives()

	wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
	return ..()

/datum/antagonist/werewolf/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("I am no longer a [special_role]!"))
	owner.special_role = null
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
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
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
	if(src.has_status_effect(/datum/status_effect/debuff/silver_curse))
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

/obj/item/clothing/armor/skin_armor/werewolf_skin
	slot_flags = null
	name = "verewolf's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	armor = ARMOR_SCALE
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = INTEGRITY_STRONG
	item_flags = DROPDEL

/datum/intent/simple/werewolf
	name = "claw"
	icon_state = "inclaw"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "claw"
	hitsound = "genslash"
	penfactor = 30
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_damage_type = "slash"

/obj/item/weapon/werewolf_claw
	name = "verevolf claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/32.dmi'
	max_blade_int = 900
	max_integrity = 900
	force = 15
	block_chance = 0
	wdefense = 2
	armor_penetration = 15
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
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
	AddComponent(/datum/component/walking_stick)

/obj/item/weapon/werewolf_claw/right
	icon_state = "claw_r"

/obj/item/weapon/werewolf_claw/left
	icon_state = "claw_l"

/obj/item/weapon/werewolf_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)
