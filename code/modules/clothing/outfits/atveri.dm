
/obj/item/clothing/armor/chainmail/hauberk/atgervi
	name = "vagarian hauberk"
	desc = "The pride of the Hammerhold mercenaries a well crafted blend of chain and leather into a dense protective coat."
	icon_state = "atgervi_raider_mail"
	item_state = "atgervi_raider_mail"
	max_integrity = 400

/obj/item/clothing/armor/leather/heavy/atgervi
	name = "shamanic coat"
	desc = "A furred protective coat, Often made by hand it embodies the second trial of the Iskarn Shamans. To honor the leopard is to desire for more."
	icon_state = "atgervi_shaman_coat"
	item_state = "atgervi_shaman_coat"

/obj/item/clothing/pants/trou/leather/atgervi
	name = "fur pants"
	desc = "Thick fur pants made to endure the coldest winds, offering a share of protection from fang and claw of beast or men alike."
	icon_state = "atgervi_pants"
	item_state = "atgervi_pants"

/obj/item/clothing/gloves/angle/atgervi
	name = "fur-lined leather gloves"
	desc = "Thick, padded gloves made for the harshest of climates, and wildest of beasts encountered in the untamed lands."
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"

/obj/item/clothing/gloves/plate/atgervi
	name = "beast claws"
	desc = "A menacing pair of plated claws, A closely protected tradition of the Shamans. The four claws embodying the four great beasts. Decorated with symbols of the gods they praise and the Gods they reject."
	icon_state = "atgervi_shaman_gloves"
	item_state = "atergvi_shaman_gloves"

/obj/item/clothing/head/helmet/bascinet/atgervi
	name = "owl helmet"
	desc = "A carefully forged steel helmet in the shape of an owl's face, with added chain to cover the face and neck against many blows."
	icon_state = "atgervi_raider"
	item_state = "atgervi_raider"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48

/obj/item/clothing/head/helmet/leather/saiga/atgervi
	name = "moose hood"
	desc = "A deceptively strong hood of hide with a pair of large heavy antlers. It is the reward of the fourth trial of the Iskarn Shamans, To slay a Grinning moose in the final hunt alone and fashion a hood from its head."
	icon_state = "atgervi_shaman"
	item_state = "atgervi_shaman"
	flags_inv = HIDEEARS|HIDEFACE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	flags_inv = HIDEEARS
	bloody_icon = 'icons/effects/blood64x64.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 48
	experimental_inhand = TRUE
	experimental_onhip = FALSE

/obj/item/clothing/shoes/boots/leather/atgervi
	name = "atgervi leather boots"
	desc = "A pair of strong leather boots, designed to endure battle and the chill of the frozen north both."
	icon_state = "atgervi_boots"
	item_state = "atgervi_boots"

/obj/item/weapon/shield/atgervi
	name = "kite shield"
	desc = "A large but light wooden shield with a steel boss in the center to deflect blows more easily."
	icon_state = "atgervi_shield"
	item_state = "atgervi_shield"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = DAMAGE_SHIELD + 5
	throwforce = DAMAGE_SHIELD
	dropshrink = 0.8
	coverage = 80
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	experimental_inhand = FALSE

/obj/item/weapon/shield/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.7,"sx" = -17,"sy" = -15,"nx" = -15,"ny" = -15,"wx" = -12,"wy" = -15,"ex" = -18,"ey" = -15,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
