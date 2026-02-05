/obj/item/clothing/head/padded	// slightly armored subtype for convenience
	armor = ARMOR_MINIMAL
	prevent_crits = MINOR_CRITICALS
	abstract_type = /obj/item/clothing/head/padded

//................ Simple Hats ............... //
/obj/item/clothing/head/dungeoneer
	name = "sack hood"
	desc = "A crude way to conceal one's identity, these are usually worn by local brigands to not get recognised."
	icon_state = "dungeoneer"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	fiber_salvage = FALSE

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
	min_cold_protection_temperature = -5

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A headwrap worn throughout the southern parts of Faience."
	icon_state = "turban"
	min_cold_protection_temperature = -5

/obj/item/clothing/head/headband
	name = "headband"
	desc = "A piece of cloth worn around the temple."
	icon_state = "headband"
	dynamic_hair_suffix = ""
	fiber_salvage = FALSE
	salvage_amount = 1

/obj/item/clothing/head/headband/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/headband/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/head/headband/naledi
	name = "sojourner's headband"
	desc = "A traditional monk's headband, for those disciples who prefer the sweat out of their eyes."
	icon_state = "headband"
	color = "#48443b"
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	armor = ARMOR_HEAD_PSYDON //Higher-tier protection for pugilist-centric classes. Fits the 'glass cannon' style, and prevents instant death through a glancing headshot on the intended archetype.
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = HEAD|HAIR|EARS
	max_integrity = ARMOR_INT_SIDE_STEEL //High leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns.
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	//dropshrink = 0.75
	dynamic_hair_suffix = null

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
	min_cold_protection_temperature = -20

/obj/item/clothing/head/hatblu
	name = "fur hat"
	icon_state = "hatblu"
	min_cold_protection_temperature = -20

/obj/item/clothing/head/papakha
	name = "papakha"
	desc = "A fuzzy helmet of fur typically worn by frontiersmen of the far steppes."
	icon_state = "papakha"
	sellprice = VALUE_FINE_CLOTHING
	max_integrity = INTEGRITY_POOR
	min_cold_protection_temperature = -20

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
	min_cold_protection_temperature = -1

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
	min_cold_protection_temperature = -1


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
	if(slot & ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/sack/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/sack/attack(mob/living/target, mob/living/user, list/modifiers)
	if(target.get_item_by_slot(ITEM_SLOT_HEAD))
		to_chat(user, "<span class='warning'>Remove [target.p_their()] headgear first!</span>")
		return
	target.visible_message("<span class='warning'>[user] forces [src] onto [target]'s head!</span>", \
	"<span class='danger'>[target] forces [src] onto your head!</span>", "<i>I can't see anything.</i>")
	if(ishuman(target)) // If the target is human and not in combat mode, stun them the same way a feint would.
		var/mob/living/carbon/human/T = target
		if(!T.cmode)
			T.emote("whimper", intentional = FALSE)
			T.changeNext_move(8)
			T.Immobilize(10)
	user.dropItemToGround(src)
	target.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD)

//............... Adept's Cowl ............... //

/obj/item/clothing/head/adeptcowl
	name = "adept's cowl"
	desc = "A black cowl worn by the Adepts of the Inquisitorial Lodge"
	icon_state = "adeptscowl"
	item_state = "adeptscowl"
	flags_inv = HIDEEARS|HIDEHAIR

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

/obj/item/clothing/head/armingcap/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/armingcap/colored/dwarf // gnome hat I guess?
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

/obj/item/clothing/head/takuhatsugasa // egyptian
	name = "takuhatsugasa"
	desc = ""
	icon_state = "takuhatsugasa"
	item_flags = ABSTRACT

/obj/item/clothing/head/helmet/pegasusknight
	name = "coifed helmet"
	desc = "Many find the design of this helmet unusual, but it protects the neck well and is easy to see out of."
	icon_state = "lakkarihelm"
	armor = ARMOR_PLATE
	flags_inv = HIDEEARS|HIDEHAIR
	body_parts_covered = HEAD_NECK
	prevent_crits = ALL_EXCEPT_BLUNT
	block2add = FOV_BEHIND
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE

/obj/item/clothing/head/roguehood/psydon
	name = "psydonian hood"
	desc = "A hood worn by Psydon's disciples, oft-worn in conjunction with its matching tabard. Made with spell-laced fabric to provide some protection."
	icon_state = "psydonhood"
	item_state = "psydonhood"
	color = null
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = NECK | HEAD | HAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 70, "stab" = 50, "piercing" = 30, "fire" = 0, "acid" = 0)
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200

/obj/item/clothing/head/roguehood/psydon/AdjustClothes(mob/living/carbon/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]"
			flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			block2add = FOV_BEHIND
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
		user.update_fov_angles()
		user.regenerate_clothes()

/obj/item/clothing/head/roguehood/psydon/ResetAdjust(mob/user)
	. = ..()
	if(toggle_icon_state)
		icon_state = "[initial(icon_state)]_t"
	flags_inv = default_hidden
	if(iscarbon(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/head/roguehood/psydon/confessor
	name = "confessional hood"
	desc = "A loose-fitting piece of leatherwear that can be tightened on the move. Keeps rain, blood, and the tears of the sullied away."
	icon_state = "confessorhood"
	item_state = "confessorhood"
	color = null
	body_parts_covered = NECK | HEAD | HAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 70, "stab" = 50, "piercing" = 30, "fire" = 0, "acid" = 0)
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200

