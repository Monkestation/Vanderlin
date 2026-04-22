/obj/item/organ/ears
	name = "ears"
	icon_state = "ear"
	desc = ""
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_EARS
	slot = ORGAN_SLOT_EARS
	organ_efficiency = list(ORGAN_SLOT_EARS = 100)
	gender = PLURAL
	side = RIGHT_SIDE
	sellprice = DEFAULT_ORGAN_VALUE/2

	healing_factor = STANDARD_ORGAN_HEALING

	organ_volume = 0.25
	max_blood_storage = 2.5
	current_blood = 2.5
	blood_req = 0.5
	oxygen_req = 0.5
	nutriment_req = 0.15
	hydration_req = 0.15

	low_threshold_passed = "<span class='info'>My ears begin to resonate with an internal ring sometimes.</span>"
	now_failing = "<span class='warning'>I am unable to hear at all!</span>"
	now_fixed = "<span class='info'>Noise slowly begins filling my ears once more.</span>"
	low_threshold_cleared = "<span class='info'>The ringing in my ears has died down.</span>"

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/ear_damage_multiplier = 1

/obj/item/organ/ears/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	for(var/datum/wound/facial/ears/ear_wound in M.get_wounds())
		qdel(ear_wound)

/obj/item/organ/ears/on_life(delta_time, times_fired)
	. = ..()
	if(!is_failing())
		applyDeaf(-0.5 * delta_time)

/obj/item/organ/ears/get_slot_efficiency(slot)
	if((slot == ORGAN_SLOT_EARS) && deaf)
		return 0
	return ..()

/obj/item/organ/ears/proc/adjustEarDamage(damage, deafness)
	applyOrganDamage(damage * ear_damage_multiplier)
	applyDeaf(deafness * ear_damage_multiplier)

/obj/item/organ/ears/proc/applyDeaf(damage, maximum = maxHealth)
	if(!damage) //Micro-optimization
		return
	deaf = clamp(deaf + damage, 0, maximum)

/obj/item/organ/ears/proc/restoreEars()
	deaf = 0
	damage = 0
	organ_flags &= ~ORGAN_FAILING

	var/mob/living/carbon/C = owner

	if(iscarbon(owner) && HAS_TRAIT(C, TRAIT_DEAF))
		deaf = 1

/obj/item/organ/ears/proc/minimumDeafTicks(value)
	deaf = max(deaf, value)

/obj/item/organ/ears/invincible
	ear_damage_multiplier = 0


/mob/proc/restoreEars()

/mob/living/carbon/restoreEars()
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.restoreEars()

/mob/proc/adjustEarDamage()

/mob/living/carbon/adjustEarDamage(ddmg, ddeaf)
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.adjustEarDamage(ddmg, ddeaf)

/mob/proc/minimumDeafTicks()

/mob/living/carbon/minimumDeafTicks(value)
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.minimumDeafTicks(value)

/obj/item/organ/ears/cat
	name = "cat ears"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	ear_damage_multiplier = 2

/obj/item/organ/ears/elf
	name = "elf ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elf

/obj/item/organ/ears/elfw
	name = "wood elf ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elfw

/obj/item/organ/ears/halforc
	name = "halforc ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elf

/obj/item/organ/ears/tiefling
	name = "tiefling ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elfw

/obj/item/organ/ears/anthro
	name = "wild-kin ears"

/obj/item/organ/ears/rakshari
	name = "rakshari ears"

/obj/item/organ/ears/rakshari/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	ADD_TRAIT(M, TRAIT_KEENEARS, "[type]")

/obj/item/organ/ears/rakshari/Remove(mob/living/carbon/human/H,  special = 0)
	. = ..()
	REMOVE_TRAIT(H, TRAIT_KEENEARS, "[type]")
