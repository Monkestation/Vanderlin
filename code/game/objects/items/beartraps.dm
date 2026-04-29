//Legcuffs

/obj/item/restraints/legcuffs
	name = "leg cuffs"
	desc = ""
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 10 SECONDS
	item_weight = 400 GRAMS

/obj/item/restraints/legcuffs/beartrap
	icon = 'icons/roguetown/items/misc.dmi'
	name = "mantrap"
	gender = NEUTER
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	desc = "A crude and old spring trap, used to snare interlopers, or prey on a hunt. Looks almost like it'll break at any moment."
	var/old = TRUE // Is it an old trap? Will most likely be destroyed if not handled right
	var/armed = FALSE // Is it armed?
	var/trap_damage = 90 // How much brute damage the trap will do to its victim
	var/used_time = 12 SECONDS // How many seconds it takes to disarm the trap
	var/makeshift_prob = 0
	max_integrity = 100
	grid_width = 64
	grid_height = 64
	item_weight = 3 KILOGRAMS

/obj/item/restraints/legcuffs/beartrap/attack_hand(mob/user)
	var/boon = user?.get_learning_boon(/datum/attribute/skill/craft/traps)
	if(iscarbon(user) && armed && isturf(loc))
		var/mob/living/carbon/C = user
		var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
		var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
		if(!BP)
			return FALSE
		if(C.stat_roll(STAT_FORTUNE,5,10,TRUE))
			add_mob_blood(C)
			if(!BP.is_object_embedded(src))
				BP.add_embedded_object(src)
			close_trap(user)
			C.visible_message("<span class='boldwarning'>[C] triggers \the [src].</span>", \
					"<span class='userdanger'>I trigger \the [src]!</span>")
			C.emote("agony")
			C.Stun(80)
			BP.add_wound(/datum/wound/fracture)
			if(BP.can_be_disabled)
				BP.update_disabled()
			C.apply_damage(trap_damage, BRUTE, def_zone, C.run_armor_check(def_zone, "stab", damage = trap_damage))
			C.update_sneak_invis(TRUE)
			C.consider_ambush()
			return FALSE
		else
			if(C.mind)
				used_time -= max((GET_MOB_SKILL_VALUE_OLD(C, /datum/attribute/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
			if(do_after(user, used_time, src))
				armed = FALSE
				anchored = FALSE
				update_appearance(UPDATE_ICON_STATE)
				src.alpha = 255
				C.visible_message("<span class='notice'>[C] disarms \the [src].</span>", \
						"<span class='notice'>I disarm \the [src].</span>")
				C.adjust_experience(/datum/attribute/skill/craft/traps, GET_MOB_ATTRIBUTE_VALUE(C, STAT_INTELLIGENCE) * boon, FALSE)
				return FALSE
			else
				add_mob_blood(C)
				if(!BP.is_object_embedded(src))
					BP.add_embedded_object(src)
				close_trap(user)
				C.visible_message("<span class='boldwarning'>[C] triggers \the [src].</span>", \
						"<span class='userdanger'>I trigger \the [src]!</span>")
				C.emote("agony")
				BP.add_wound(/datum/wound/fracture)
				if(BP.can_be_disabled)
					BP.update_disabled()
				C.apply_damage(trap_damage, BRUTE, def_zone, C.run_armor_check(def_zone, "stab", damage = trap_damage))
				C.update_sneak_invis(TRUE)
				C.consider_ambush()
				return FALSE
	..()

/obj/item/restraints/legcuffs/beartrap/attackby(obj/item/W, mob/user, list/modifiers)
	if(W.force && armed)
		user.visible_message("<span class='warning'>[user] triggers \the [src] with [W].</span>", \
				"<span class='danger'>I trigger \the [src] with [W]!</span>")
		W.take_damage(20)
		close_trap(user, W)
		if(isliving(user))
			var/mob/living/L = user
			L.update_sneak_invis(TRUE)
			L.consider_ambush()
		return
	..()

/obj/item/restraints/legcuffs/beartrap/armed
	armed = TRUE
	anchored = TRUE // Pre mapped traps (bad mapping btw, don't) start anchored

/obj/item/restraints/legcuffs/beartrap/armed/camouflage
	armed = TRUE
	alpha = 80

/obj/item/restraints/legcuffs/beartrap/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/restraints/legcuffs/beartrap/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][armed]"

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is sticking [user.p_their()] head in the [src.name]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user, list/modifiers)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	var/boon = user?.get_learning_boon(/datum/attribute/skill/craft/traps)
	if(ishuman(user) && !user.stat && !HAS_TRAIT(src, TRAIT_RESTRAINED))
		var/mob/living/L = user
		if(do_after(user, (5 SECONDS) - (GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH)*2), user))
			if(prob(50 - makeshift_prob + (GET_MOB_SKILL_VALUE_OLD(L, /datum/attribute/skill/craft/traps) * 10))) // 100% chance to set traps properly at Master trapping, assuming the trap isn't makeshift
				armed = TRUE // Impossible to use in hand if it's armed
				L.log_message("has armed the [src]!", LOG_ATTACK)
				L.dropItemToGround(src) // We drop it instantly on the floor beneath us
				anchored = TRUE // And anchor it so that it can't be carried inside chests (prevents exploit)
				update_appearance(UPDATE_ICON_STATE)
				src.alpha = 80 // Set lower visibility for everyone
				L.adjust_experience(/datum/attribute/skill/craft/traps, GET_MOB_ATTRIBUTE_VALUE(L, STAT_INTELLIGENCE) * boon, FALSE) // We learn how to set them better, little by little.
				to_chat(user, span_notice("I arm \the [src]."))
			else
				if(old)
					user.visible_message(span_warning("The old [src.name] breaks under stress!"))
					playsound(src, 'sound/foley/breaksound.ogg', 100, TRUE, -1)
					qdel(src)
				else
					user.visible_message(span_warning("Curses! I couldn't keep [src.name] open tight enough!"))
					playsound(src, 'sound/items/beartrap.ogg', 300, TRUE, -1)
					return

/obj/item/restraints/legcuffs/beartrap/proc/close_trap(atom/triggerer, atom/item)
	armed = FALSE
	anchored = FALSE // Take it off the ground
	alpha = 255
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/items/beartrap.ogg', 300, TRUE, -1)
	triggerer.log_message("has triggered the [src][item ? " with [item]" : ""]!", LOG_ATTACK)

/obj/item/restraints/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed && isturf(loc))
		if(isliving(AM))
			var/mob/living/cross_mob = AM
			var/snap = TRUE
			if(cross_mob.throwing)
				return ..()

			if(cross_mob.movement_type & (MOVETYPES_NOT_TOUCHING_GROUND)) //don't close the trap if they're flying/floating over it.
				return ..()
			if(HAS_TRAIT(cross_mob, TRAIT_LIGHT_STEP))
				return ..()

			var/def_zone = BODY_ZONE_CHEST
			if(snap && iscarbon(cross_mob))
				var/mob/living/carbon/carbon_mob = cross_mob
				if(carbon_mob.body_position == STANDING_UP)
					def_zone = pick(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
					var/obj/item/bodypart/BP = carbon_mob.get_bodypart(def_zone)
					if(BP)
						add_mob_blood(carbon_mob)
						if(!BP.is_object_embedded(src))
							BP.add_embedded_object(src)
						carbon_mob.emote("agony")
				//BP.set_disabled(BODYPART_DISABLED_WOUND)
				// BP.add_wound(/datum/wound/fracture)
			else if(snap && isanimal(cross_mob))
				var/mob/living/simple_animal/SA = cross_mob
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				close_trap(cross_mob)
				cross_mob.visible_message(span_danger("[cross_mob] triggers \the [src]."), \
						span_danger("I trigger \the [src]!"))
				if(cross_mob.apply_damage(trap_damage, BRUTE, def_zone, cross_mob.run_armor_check(def_zone, "stab", damage = trap_damage)))
					cross_mob.Stun(80)
				cross_mob.consider_ambush()
	..()

// When craftable beartraps get added, make these the ones crafted.
/obj/item/restraints/legcuffs/beartrap/crafted
	old = FALSE
	desc = "Curious is the trapmaker's art. Their efficacy unwitnessed by their own eyes."
	melting_material = /datum/material/iron
	melt_amount = 75

/obj/item/restraints/legcuffs/beartrap/crafted/makeshift
	makeshift_prob = 15 //50 - 15 = 35% chance to set up instead of flat 50%
	trap_damage = 80 //10 less damage than the actual metal beartrap
	name = "makeshift mantrap"
	melting_material = null
	item_weight = 1.5 KILOGRAMS

/obj/item/restraints/legcuffs/beartrap/hunting_snare
	name = "hunting snare"
	trap_damage = 0
	armed = TRUE
	anchored = TRUE
	melting_material = null
	makeshift_prob = 50 // Precaution, no manually setting it up
	item_weight = 300 GRAMS

/obj/item/restraints/legcuffs/beartrap/hunting_snare/suicide_act(mob/user)
	return
