/datum/action/cooldown/spell/undirected/conjure_item/summon_trident
	name = "Summon Trident"
	desc = "Summon a trident with magic"
	button_icon_state = "lightning"
	sound = 'sound/foley/jumpland/waterland.ogg'

	associated_skill = /datum/skill/magic/arcane

	invocation = "Innkalle trefork"
	invocation_type = INVOCATION_SHOUT
	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 1 MINUTES
	spell_cost = 20

	delete_old = TRUE
	item_type = /obj/item/fishingrod/abyssor_trident/arcane
	item_duration = 0

/datum/action/cooldown/spell/undirected/conjure_item/summon_trident/miracle
	name = "Summon Abyssal Trident"
	desc = "Summon a trident from Abyssor's domain."
	button_icon_state = "lightning"
	sound = 'sound/foley/jumpland/waterland.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)

	invocation = "Let Abyssor's wrath be known!"
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 1 MINUTES
	spell_cost = 45

	delete_old = TRUE
	item_type = /obj/item/fishingrod/abyssor_trident
	item_duration = 0

/obj/item/fishingrod/abyssor_trident
	name = "trident of the depths"
	desc = "An instrument of Abyssor's wrath to claim his bounties and punish the ignorant."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "tridentgold"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR + 2
	throwforce = DAMAGE_SPEAR_WIELD
	wdefense = GREAT_PARRY
	wlength = WLENGTH_GREAT
	possible_item_intents = list(SPEAR_THRUST, ROD_AUTO, ROD_CAST)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, POLEARM_BASH)
	max_blade_int = 50
	max_integrity = INTEGRITY_WORST / 2 // not meant for long-term combat
	minstr = 7

	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	sharpness = IS_SHARP
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	blade_dulling = DULLING_BASHCHOP
	dropshrink = 0.9
	thrown_bclass = BCLASS_STAB

	throw_speed = 3
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 5, "embedded_ignore_throwspeed_threshold" = 1)

	associated_skill = /datum/skill/combat/polearms

	obj_flags = CAN_BE_HIT
	resistance_flags = FIRE_PROOF
	experimental_onback = TRUE
	armor_penetration = 5
	can_parry = TRUE
	has_inspect_verb = TRUE

/obj/item/fishingrod/abyssor_trident/Initialize()
	. = ..()
	reel = new /obj/item/fishing/reel/abytrident(src)
	hook = new /obj/item/fishing/hook/abytrident(src)
	line = new /obj/item/fishing/line/no_line(src)
	baited = new /obj/item/fishing/lure/no_bait(src)
	AddElement(/datum/element/walking_stick)

/obj/item/fishingrod/abyssor_trident/examine(mob/user)
	. = ..()
	. = list("[get_examine_string(user, TRUE)].[get_inspect_button()]", span_info("[desc]")) // to hide fishing rod examine text

/obj/item/fishingrod/abyssor_trident/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/fishingrod/abyssor_trident/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!is_embedded)
		src.visible_message(span_warning("[src] dissipates into a splash of water!"), vision_distance = COMBAT_MESSAGE_RANGE)
		qdel(src)

/obj/item/fishingrod/abyssor_trident/unembedded()
	if(!QDELETED(src))
		src.visible_message(span_warning("[src] dissipates into a splash of water!"), vision_distance = COMBAT_MESSAGE_RANGE)
		qdel(src)
		return TRUE

/obj/item/fishingrod/abyssor_trident/attack_hand_secondary(mob/user, list/modifiers)
	return SECONDARY_ATTACK_CALL_NORMAL

/obj/item/fishingrod/abyssor_trident/afterattack(obj/target, mob/user, proximity_flag, list/modifiers)
	. = ..()
	baited = new /obj/item/fishing/lure/no_bait(src)

/obj/item/fishing/reel/abytrident
	name = "trident shaft"
	linehealth = 14
	difficultymod = 1

/obj/item/fishing/hook/abytrident
	name = "trident prong"
	fishing_hook_traits = FISHING_HOOK_NO_ESCAPE|FISHING_HOOK_KILL

/obj/item/fishing/line/no_line
	name = "lack of attachment"


/obj/item/fishing/lure/no_bait
	name = "lack of bait"
	desc = "A special fishing lure for unique circumstances."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "no_bait"
	spin_frequency = list(2 SECONDS, 3 SECONDS)

/obj/item/fishing/lure/no_bait/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Scares off tiny and small fish
	if(fish.size <= fish.average_size * 1.1)
		return FALSE

	// Catches carps, eels, shrimp, anglerfish, and clownfish
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/carp))
		return TRUE
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/eel))
		return TRUE
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/shrimp))
		return TRUE
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/angler))
		return TRUE
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/clownfish))
		return TRUE
	return FALSE

/obj/item/fishingrod/abyssor_trident/arcane
	name = "Arcane Trident"
	desc = "A conjured trident, it resonates with arcyne energy."
	icon_state = "tridentblue"
