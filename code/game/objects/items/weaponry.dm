/obj/item/banhammer
	desc = ""
	name = "banhammer"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "toyhammer"
	slot_flags = ITEM_SLOT_HIP
	throwforce = 0
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7
	attack_verb = list("banned")
	max_integrity = 200
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = 100, "acid" = 70)
	resistance_flags = FIRE_PROOF

/obj/item/banhammer/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to ban [user.p_them()]self from life.</span>")
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)
/*
oranges says: This is a meme relating to the english translation of the ss13 russian wiki page on lurkmore.
mrdoombringer sez: and remember kids, if you try and PR a fix for this item's grammar, you are admitting that you are, indeed, a newfriend.
for further reading, please see: https://github.com/tgstation/tgstation/pull/30173 and https://translate.google.com/translate?sl=auto&tl=en&js=y&prev=_t&hl=en&ie=UTF-8&u=%2F%2Flurkmore.to%2FSS13&edit-text=&act=url
*/
/obj/item/banhammer/attack(mob/M, mob/user, list/modifiers)
	if(user.zone_selected == BODY_ZONE_HEAD)
		M.visible_message("<span class='danger'>[user] is stroking the head of [M] with a banhammer.</span>", "<span class='danger'>[user] is stroking my head with a banhammer.</span>", "<span class='hear'>I hear a banhammer stroking a head.</span>")
	else
		M.visible_message("<span class='danger'>[M] has been banned FOR NO REISIN by [user]!</span>", "<span class='danger'>I have been banned FOR NO REISIN by [user]!</span>", "<span class='hear'>I hear a banhammer banning someone.</span>")
	playsound(src, 'sound/blank.ogg', 15) //keep it at 15% volume so people don't jump out of their skin too much
	if(user.used_intent.type != INTENT_HELP)
		return ..(M, user)

/obj/item/throwing_star
	name = "throwing star"
	desc = ""
	icon_state = "throwingstar"
	item_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 2
	throwforce = 20 //20 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = 28 damage on hit due to guaranteed embedding
	throw_speed = 4
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 100, "embedded_fall_chance" = 0)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_SHARP
	resistance_flags = FIRE_PROOF

	grid_height = 32
	grid_width = 32

/obj/item/throwing_star/ninja
	name = "ninja throwing star"
	throwforce = 30
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 100, "embedded_fall_chance" = 0)

/obj/item/staff
	name = "wizard staff"
	desc = ""
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armor_penetration = 100
	attack_verb = list("bludgeoned", "whacked", "disciplined")
	resistance_flags = FLAMMABLE

/obj/item/staff/stick
	name = "stick"
	desc = ""
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
