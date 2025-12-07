/datum/action/cooldown/spell/healing
	name = "Lesser Miracle"
	desc = "Call upon your patron to heal the wounds of yourself or others."
	button_icon_state = "lesserheal"
	sound = 'sound/magic/heal.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 6
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross)

	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 10

	/// Base healing before adjustments
	var/base_healing = 25
	/// Wound healing modifier
	var/wound_modifier = 0.25
	/// Blood healing amount
	var/blood_restoration = 0
	/// Stuns undead
	var/stun_undead = FALSE
	/// Unholy, profane healing
	var/is_profane = FALSE

/datum/action/cooldown/spell/healing/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/healing/cast(mob/living/cast_on)
	. = ..()
	if(!is_profane)
		if(HAS_TRAIT(cast_on, TRAIT_ASTRATA_CURSE))
			cast_on.visible_message(span_danger("[cast_on] recoils in pain!"), span_userdanger("Divine healing shuns me!"))
			cast_on.cursed_freak_out()
			return
		if(cast_on.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			if(cast_on.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
				cast_on.visible_message(span_warning("[cast_on] overpowers being burned!"), span_greentext("I overpower being burned!"))
				return
			cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
			if(stun_undead)
				cast_on.Paralyze(5 SECONDS)
			cast_on.adjustFireLoss(base_healing)
			cast_on.adjust_divine_fire_stacks(1)
			cast_on.IgniteMob()
			return
		if((cast_on.real_name in GLOB.excommunicated_players) && !HAS_TRAIT(cast_on, TRAIT_FANATICAL))
			cast_on.visible_message(
				span_warning("The angry Ten the flesh of [cast_on]! a foolish blasphemer and heretic!"),
				span_notice("I am despised by the Ten, rejected, and they remind me just how unlovable I am with a wave of pain!"),
			)
			cast_on.emote("scream")
			return

	var/conditional_buff = FALSE
	var/situational_bonus = 10
	//this if chain is stupid, replace with variables on /datum/patron when possible?
	if(isliving(owner))
		var/mob/living/living_owner = owner
		switch(living_owner.patron?.type)
			if(/datum/patron/psydon)
				cast_on.visible_message(span_info("A strange stirring feeling pours from [cast_on]!"), span_notice("Sentimental thoughts drive away my pains!"))

			if(/datum/patron/divine/astrata)
				cast_on.visible_message(span_info("A wreath of gentle light passes over [cast_on]!"), span_notice("I'm bathed in holy light!"))
				// during the day, heal 10 more (basic as fuck)
				if(GLOB.tod == "day")
					conditional_buff = TRUE

			if(/datum/patron/divine/noc)
				cast_on.visible_message(span_info("A shroud of soft moonlight falls upon [cast_on]!"), span_notice("I'm shrouded in gentle moonlight!"))
				// during the night, heal 10 more (i wish this was more interesting but they're twins so whatever)
				if(GLOB.tod == "night")
					conditional_buff = TRUE

			if(/datum/patron/divine/dendor)
				cast_on.visible_message(span_info("A rush of primal energy spirals about [cast_on]!"), span_notice("I'm infused with primal energies!"))
				var/static/list/natural_stuff = typecacheof(list(/obj/structure/flora/grass, /obj/structure/chair/bench/ancientlog, /obj/structure/flora))
				situational_bonus = 0
				// the more natural stuff around US, the more we heal
				for(var/obj/O in oview(5, owner))
					if(is_type_in_typecache(O, natural_stuff))
						situational_bonus = min(situational_bonus + 0.5, 25)
				if(situational_bonus > 0)
					conditional_buff = TRUE

			if(/datum/patron/divine/abyssor)
				cast_on.visible_message(span_info("A mist of salt-scented vapour settles on [cast_on]!"), span_notice("I'm invigorated by healing vapours!"))
				// if our owner or cast_on is standing in water, heal a flat amount extra
				if(istype(get_turf(cast_on), /turf/open/water) || istype(get_turf(owner), /turf/open/water))
					conditional_buff = TRUE
					situational_bonus = 15

			if(/datum/patron/divine/ravox)
				cast_on.visible_message(span_info("An air of righteous defiance rises near [cast_on]!"), span_notice("I'm filled with an urge to fight on!"))
				situational_bonus = 0
				// the bloodier the area around our cast_on is, the more we heal
				for(var/obj/effect/decal/cleanable/blood/O in oview(5, cast_on))
					situational_bonus = min(situational_bonus + 1, 25)
				conditional_buff = TRUE

			if(/datum/patron/divine/necra)
				cast_on.visible_message(span_info("A sense of quiet respite radiates from [cast_on]!"), span_notice("I feel the Undermaiden's gaze turn from me for now!"))
				if(iscarbon(cast_on))
					var/mob/living/carbon/C = cast_on
					// if the cast_on is "close to death" (at or below 25% health)
					if(C.health <= (C.maxHealth * 0.25))
						conditional_buff = TRUE
						situational_bonus = 25

			if(/datum/patron/divine/xylix)
				cast_on.visible_message(span_info("A fugue seems to manifest briefly across [cast_on]!"), span_notice("My wounds vanish as if they had never been there! "))
				// half of the time, heal a little (or a lot) more - flip the coin
				if(prob(50))
					conditional_buff = TRUE
					situational_bonus = rand(1, 25)
			if(/datum/patron/divine/pestra)
				cast_on.visible_message(span_info("An aura of clinical care encompasses [cast_on]!"), span_notice("I'm sewn back together by sacred medicine!"))
				// pestra always heals a little more toxin damage and restores a bit more blood
				cast_on.adjustToxLoss(-situational_bonus)
				cast_on.blood_volume += BLOOD_VOLUME_SURVIVE/2

			if(/datum/patron/divine/malum)
				cast_on.visible_message(span_info("A tempering heat is discharged out of [cast_on]!"), span_notice("I feel the heat of a forge soothing my pains!"))
				situational_bonus = 0
				for(var/obj/machinery/light/fueled/O in oview(5, owner))
					if(!O.on)
						continue
					situational_bonus = min(situational_bonus + 3, 25)
				if(situational_bonus > 0)
					conditional_buff = TRUE

			if(/datum/patron/divine/eora)
				cast_on.visible_message(span_info("An eminence of love blossoms around [cast_on]!"), span_notice("I'm filled with the restorative warmth of love!"))
				// if they're wearing an eoran bud (or are a pacifist), pretty much double the healing.
				situational_bonus = 0
				if (HAS_TRAIT(cast_on, TRAIT_PACIFISM))
					conditional_buff = TRUE
					situational_bonus = 25

			if(/datum/patron/inhumen/zizo)
				cast_on.visible_message(span_info("Vital energies are sapped towards [cast_on]!"), span_notice("The life around me pales as I am restored!"))
				// set up a ritual pile of bones (or just cast near a stack of bones whatever) around us for massive bonuses, cap at 50 for 75 healing total (wowie)
				situational_bonus = 0
				for(var/obj/item/alch/bone/O in oview(5, owner))
					situational_bonus = min(situational_bonus + 5, 50)
				if(situational_bonus > 0)
					conditional_buff = TRUE

			if(/datum/patron/inhumen/graggar)
				cast_on.visible_message(span_info("Foul fumes billow outward as [cast_on] is restored!"), span_notice("A noxious scent burns my nostrils, but I feel better!"))
				// if you've got lingering toxin damage, you get healed more, but your bonus healing doesn't affect toxin
				var/toxloss = cast_on.getToxLoss()
				if(toxloss >= 10)
					conditional_buff = TRUE
					situational_bonus = 25
					cast_on.adjustToxLoss(situational_bonus) // remember we do a global toxloss adjust down below so this is okay

			if(/datum/patron/inhumen/matthios)
				cast_on.visible_message(span_info("A shadowed hand passes [cast_on] a small, stolen vial... its contents glimmer faintly before sinking into their veins..."), span_notice("A quick swig and the ache fades..."))
				// COMRADES! WE MUST BAND TOGETHER! Or Outlaw.
				if(HAS_TRAIT(cast_on, TRAIT_BANDITCAMP) || (cast_on.real_name in GLOB.outlawed_players))
					conditional_buff = TRUE
					situational_bonus = 25

			if(/datum/patron/inhumen/baotha)
				cast_on.visible_message(span_info("A sweet, dizzying haze swirls around [cast_on], their eyes glimmering with bliss..."), span_notice("Mmm... the world softens... and I melt into it..."))
				//If the owner or cast_on are on drugs, they get a heal bonus.
				var/static/list/drugs_buffs = list(
					/datum/status_effect/buff/druqks,
					/datum/status_effect/buff/ozium,
					/datum/status_effect/buff/moondust,
					/datum/status_effect/buff/weed,
					/datum/status_effect/buff/moondust_purest,
				)

				for(var/datum/status_effect/path as anything in drugs_buffs)
					if(living_owner.has_status_effect(path) || cast_on.has_status_effect(path))
						conditional_buff = TRUE
						situational_bonus = 25
						break

			else
				if(istype(living_owner.patron, /datum/patron/godless))
					cast_on.visible_message(span_info("No Gods answer these prayers."), span_notice("No Gods answer these prayers."))
					return
				cast_on.visible_message(span_info("A choral sound comes from above and [cast_on] is healed!"), span_notice("I am bathed in healing choral hymns!"))
	var/amount_healed = base_healing
	
	if(conditional_buff)
		to_chat(owner, span_greentext("Channeling my patron's power is easier in these conditions!"))
		amount_healed += situational_bonus

	cast_on.adjustToxLoss(-amount_healed)
	cast_on.adjustOxyLoss(-amount_healed)
	cast_on.blood_volume += blood_restoration
	if(!iscarbon(cast_on))
		cast_on.adjustBruteLoss(-amount_healed)
		cast_on.adjustFireLoss(-amount_healed)
		return

	var/mob/living/carbon/C = cast_on
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(owner.zone_selected))
	if(affecting)
		affecting.heal_damage(amount_healed, amount_healed)
		affecting.heal_wounds(amount_healed * wound_modifier)
		C.update_damage_overlays()

/datum/action/cooldown/spell/healing/profane
	name = "Corrupt Lesser Miracle"
	antimagic_flags = MAGIC_RESISTANCE_UNHOLY
	required_items = null
	is_profane = TRUE

/datum/action/cooldown/spell/healing/greater
	name = "Miracle"
	button_icon_state = "astrata"

	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 20 SECONDS
	spell_cost = 45

	base_healing = 50
	wound_modifier = 0.5
	blood_restoration = BLOOD_VOLUME_SURVIVE
	stun_undead = TRUE

/datum/action/cooldown/spell/healing/greater/profane
	name = "Corrupt Miracle"
	antimagic_flags = MAGIC_RESISTANCE_UNHOLY
	required_items = null
	stun_undead = FALSE
	is_profane = TRUE
