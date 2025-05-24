/obj/item/clothing/face/spectacles
	name = "spectacles"
	icon_state = "glasses"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 20
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
//	block2add = FOV_BEHIND

/obj/item/clothing/face/spectacles/golden
	name = "golden spectacles"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES

/obj/item/clothing/face/spectacles/Crossed(mob/crosser)
	if(isliving(crosser) && !obj_broken)
		take_damage(11, BRUTE, "blunt", 1)
	..()

/obj/item/clothing/face/spectacles/inqglasses
	name = "crimson spectacles"
	desc = "Spectacles evoking the stained glass of Grenzelhoftian cathedrals. See all evil."
	icon_state = "bglasses"

/obj/item/clothing/face/spectacles/sglasses
	name = "smokey onyxa spectacles"
	desc = "Death has come to your little town, Sheriff. Now, you can either ignore it, or you can help me to stop it."
	icon_state = "sglasses"
