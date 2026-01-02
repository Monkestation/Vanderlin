
/obj/item/clothing/armor/regenerating
	name = "regenerating armour"
	desc = "Abstract parent. Contact developer if you see this."
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

	/// Feedback messages
	var/repairmsg_begin = "My armour begins to slowly mend its abuse.."
	var/repairmsg_continue = "My armour mends some of its abuse.."
	var/repairmsg_stop = "My armour stops mending from the onslaught!"
	var/repairmsg_end = "My armour has become taut with newfound vigor!"

	/// Time taken for regeneration
	var/repair_time
	/// Holder for timer
	var/reptimer

	/// Regen interrupt vars
	var/interrupt_damount
	var/interrupt_dtype
	var/interrupt_dflag
	var/interrupt_ddir

/obj/item/clothing/armor/regenerating/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	..()
	if(reptimer)
		if(!regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir))
			return
		to_chat(loc, span_notice(repairmsg_stop))
		deltimer(reptimer)

	to_chat(loc, span_notice(repairmsg_begin))
	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/item/clothing/armor/regenerating/proc/armour_regen(var/repair_percent = 0.2 * max_integrity)
	if(atom_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		if(reptimer)
			deltimer(reptimer)
		return

	to_chat(loc, span_notice(repairmsg_continue))
	update_integrity(min(atom_integrity + repair_percent, max_integrity))
	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/item/clothing/armor/regenerating/proc/regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir)
	if(interrupt_damount && interrupt_damount > damage_amount)
		return FALSE
	if(interrupt_dtype && interrupt_dtype != damage_type)
		return FALSE
	if(interrupt_dflag && interrupt_dflag != damage_flag)
		return FALSE
	if(interrupt_ddir && interrupt_ddir != attack_dir)
		return FALSE
	return TRUE


// SKIN ARMOUR

/obj/item/clothing/armor/regenerating/skin
	name = "regenerating skin"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	flags_inv = null //Exposes the chest and-or breasts.
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = AC_LIGHT
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	armor = ARMOR_PADDED
	surgery_cover = FALSE
	clothing_flags = NONE

	repairmsg_begin = "My skin begins to slowly mend its abuse.."
	repairmsg_continue = "My skin mends some of its abuse.."
	repairmsg_stop = "My skin stops mending from the onslaught!"
	repairmsg_end = "My skin has become taut with newfound vigor!"

/obj/item/clothing/armor/regenerating/skin/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/armor/regenerating/skin/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/armor/regenerating/skin/disciple
	name = "disciple's skin"
	desc = "It's far more than just an oath. Mercurial circles of silver are etched into the skin of this person, engraved with fanatic zeal and faithful reverence. May it ward the darkness. It seems to be written in red ink."
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) //Custom value; padded gambeson's slash- and stab- armor.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	max_integrity = 300
	repair_time = 20 SECONDS
