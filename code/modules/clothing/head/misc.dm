/obj/item/clothing/head/padded	// slightly armored subtype for convenience
	armor = ARMOR_MINIMAL
	prevent_crits = MINOR_CRITICALS

//................ Simple Hats ............... //
/obj/item/clothing/head/menacing
	name = "sack hood"
	desc = "A crude way to conceal one's identity, these are usually worn by local brigands to not get recognised."
	icon_state = "menacing"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	fiber_salvage = FALSE

/obj/item/clothing/head/knitcap
	name = "knit cap"
	desc = "A crude peasant cap worn by about every serf under Astrata's radiance."
	icon_state = "knitcap"

/obj/item/clothing/head/headband
	name = "headband"
	desc = "A piece of cloth worn around the temple."
	icon_state = "headband"
	dynamic_hair_suffix = ""
	fiber_salvage = FALSE
	salvage_amount = 1

/obj/item/clothing/head/headband/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/head/softcap
	name = "soft cap"
	desc = "A white cap worn by most manual laborers to protect from sunburn."
	icon_state = "armingcap"
	flags_inv = HIDEEARS

/obj/item/clothing/head/shawl
	name = "shawl"
	desc = "Keeps the hair in check, and looks proper."
	icon_state = "shawl"
	flags_inv = HIDEEARS

/obj/item/clothing/head/brimmed
	name = "brimmed hat"
	desc = "A simple brimmed hat that provides some relief from the sun."
	icon_state = "brimmed"


//................ Fur Hats ............... //
/obj/item/clothing/head/hatfur
	name = "fur hat"
	desc = "A hat made of fur typically worn by guildsmen."
	icon_state = "hatfur"

/obj/item/clothing/head/hatblu
	name = "fur hat"
	icon_state = "hatblu"

/obj/item/clothing/head/papakha
	name = "papakha"
	desc = "A fuzzy helmet of fur typically worn by frontiersmen of the far steppes."
	icon_state = "papakha"
	sellprice = VALUE_FINE_CLOTHING
	max_integrity = INTEGRITY_POOR

//................ Fancy Hats ............... //

/obj/item/clothing/head/antlerhood
	name = "antlerhood"
	desc = "a hood suited for druids and shamans."
	color = null
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "antlerhood"
	item_state = "antlerhood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	max_integrity = 100
	armor = list("blunt" = 16, "slash" = 19, "stab" = 15,  "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_TWIST)
	anvilrepair = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide

/obj/item/clothing/head/helmet/leather/saiga
	name = "saiga skull"
	desc = "Skull from big game. Looks like it could withstand some damage."
	icon_state = "saigahead"
	item_state = "saigahead"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	armor = list("blunt" = 60, "slash" = 40, "stab" = 45,  "piercing" = 0, "fire" = 0, "acid" = 0)
	flags_inv = HIDEEARS|HIDEFACE
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES


//................ Briar Thorns ............... //	- Dendor Briar
/obj/item/clothing/head/padded/briarthorns
	name = "briar thorns"
	desc = "The pain it causes perhaps can distract from the whispers of a mad God overpowering your sanity..."
	icon_state = "briarthorns"

/obj/item/clothing/head/padded/briarthorns/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_warning ("The thorns prick me."))
	user.adjustBruteLoss(4)

//................ Hennin ............... //
/obj/item/clothing/head/hennin
	name = "hennin"
	desc = "A fashionable conical hat typically worn by princesses."
	icon_state = "hennin"
	sellprice = VALUE_FINE_CLOTHING


//......................................................................................................
/*------------------\
|			 	 	|
|  Basic Helmets	|
|			 	 	|
\------------------*/


//................ Nasal Helmet ............... //



//............... Arming Cap ............... //
/obj/item/clothing/head/armingcap // arming caps are padded caps worn under maille coifs and such, should basically be on par with leather coif (it should BE the coif but whatever)
	name = "arming cap"
	desc = "A white padded cap worn by most manual laborers to protect from sunburn."
	icon_state = "armingcap"
	flags_inv = HIDEEARS

	armor = ARMOR_PADDED
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits =  MINOR_CRITICALS
	max_integrity = INTEGRITY_POOR



/*------------------\
| Feldsher headwear |
\-------------------*/



//......................................................................................................
/*----------------------\
| Unique helmets & hats |	- Unique means no crafting them, no importing, nothing but spawn with the intended class
\----------------------*/


//............... Rare Helmets ............... //
///obj/item/clothing/head/helmet/rare

/*-------------------\
| Antagonist Helmets |
\-------------------*/


/*---------------------\
| Magic hats & helmets |
\---------------------*/

//............... Wizard Hat ........................... (unique effects for court mage. Not any more so just a plain hat)

//............... Thermal Vision Circlet ............... //

//............... Black bag for inquisition ............... //
/obj/item/clothing/head/sack
	name = "black bag"
	desc = "An eyeless sack, used to blindfold prisoners or hostages."
	icon_state = "sacked"
	item_state = "sacked"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	tint = TINT_BLIND

/obj/item/clothing/head/sack/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		user.become_blind("blindfold[REF(src)]")

/obj/item/clothing/head/sack/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/sack/attack(mob/living/target, mob/living/user)
	if(target.get_item_by_slot(SLOT_HEAD))
		to_chat(user, "<span class='warning'>Remove [target.p_their()] headgear first!</span>")
		return
	target.visible_message("<span class='warning'>[user] forces [src] onto [target]'s head!</span>", \
	"<span class='danger'>[target] forces [src] onto your head!</span>", "<i>I cant see anything.</i>")
	if(ishuman(target)) // If the target is human and not in combat mode, stun them the same way a feint would.
		var/mob/living/carbon/human/T = target
		if(!T.cmode)
			T.emote("whimper", intentional = FALSE)
			T.changeNext_move(8)
			T.Immobilize(10)
	user.dropItemToGround(src)
	target.equip_to_slot_if_possible(src, SLOT_HEAD)



/*----------\
| Graveyard |	- Not used or ingame in any way except admeme spawning them.
\-----------*/

/obj/item/clothing/head/priesthat // bishops mitre really
	name = "priest's hat"
	desc = "The sacred headpiece of a priest."
	icon_state = "priest"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	dynamic_hair_suffix = "+generic"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"

	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/head/headdress // egyptian
	name = "foreign headdress"
	desc = ""
	icon_state = "headdress"

/obj/item/clothing/head/headdress/alt
	icon_state = "headdressalt"

/obj/item/clothing/head/armingcap/dwarf // gnome hat I guess?
	color = "#cb3434"

/obj/item/clothing/head/vampire
	name = "crown of darkness"
	icon_state = "vcrown"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 1000
	resistance_flags = FIRE_PROOF

//................ Faceless Hood ............... //	- Faceless One

/obj/item/clothing/head/faceless //A hood that doesn't cover the face.
	name = "hood"
	desc = "Conceals your face, whether against the rain, or the gazes of others."
	icon_state = "facelesshood"
	item_state = "facelesshood"
	color = CLOTHING_SOOT_BLACK
	dynamic_hair_suffix = ""
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	var/default_hidden = null
	body_parts_covered = NECK
	salvage_amount = 1
	salvage_result = /obj/item/natural/cloth

/obj/item/clothing/head/faceless/AdjustClothes(mob/living/carbon/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			body_parts_covered = NECK|HAIR|EARS|HEAD
			dynamic_hair_suffix = "+generic"
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			block2add = FOV_BEHIND
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			dynamic_hair_suffix = ""
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_head()
		user.update_fov_angles()
		user.regenerate_clothes()
