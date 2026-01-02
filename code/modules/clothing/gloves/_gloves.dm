/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = WEIGHT_CLASS_SMALL

	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	sleevetype = "shirt"

	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'

	siemens_coefficient = 1
	max_heat_protection_temperature = 361

	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_GLOVES
	resistance_flags = FIRE_PROOF

	attack_verb = list("challenged")
	max_integrity = INTEGRITY_WORST

	strip_delay = 2 SECONDS
	equip_delay_other = 4 SECONDS

	sewrepair = TRUE
	anvilrepair = null
	smeltresult = /obj/item/fertilizer/ash
	sewrepair = TRUE
	fiber_salvage = FALSE
	salvage_amount = 1

	grid_width = 64
	grid_height = 32
	item_weight = 4

	var/transfer_prints = FALSE
	abstract_type = /obj/item/clothing/gloves
	var/unarmed_bonus = 1

/obj/item/clothing/gloves/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_blood))

/obj/item/clothing/gloves/proc/clean_blood(datum/source, strength)
	if(strength & CLEAN_TYPE_BLOOD)
		return
	transfer_blood = 0

/obj/item/clothing/gloves/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>\the [src] are forcing [user]'s hands around [user.p_their()] neck! It looks like the gloves are possessed!</span>")
	return OXYLOSS

/obj/item/clothing/gloves/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return 0 // return 1 to cancel attack_hand()
