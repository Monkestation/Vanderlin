/obj/item/clothing/head/helmet/heavy
	name = "helmet template"
	icon_state = "barbute"
	flags_inv = HIDEEARS|HIDEFACE
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_RIGHT|FOV_LEFT
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS
	emote_environment = 3		// Unknown if this actually works and what it does
	melt_amount = 75
	melting_material = /datum/material/steel
	sellprice = VALUE_STEEL_HELMET

	armor = ARMOR_PLATE
	body_parts_covered = FULL_HEAD
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STRONGEST // no moving parts, steel
	abstract_type = /obj/item/clothing/head/helmet/heavy

/obj/item/clothing/head/helmet/heavy/necked		// includes a coif or gorget part to cover neck. Why? So templars can wear their cross on their neck basically, also special thing for Temple
	name = "bastion helm"
	desc = "A modified great helm designed for Templars, this helmet with integrated neck protection serves as an unyielding bastion of protection for the devout."
	icon_state = "topfhelm"
	armor = ARMOR_PLATE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	body_parts_covered = HEAD_NECK
	prevent_crits = ALL_EXCEPT_BLUNT
	block2add = FOV_BEHIND

/obj/item/clothing/head/helmet/heavy/psydonbarbute
	name = "psydonian barbute"
	desc = "A barbute styled with Psydonian Imagery."
	icon_state = "psydonbarbute"
	item_state = "psydonbarbute"
	block2add = FOV_BEHIND

/obj/item/clothing/head/helmet/heavy/psydonhelm
	name ="grenzelhoftian armet"
	desc = "Headwear commonly worn by Templars in service to the Oratorium Throni Vacui. PSYDON Endures."
	icon_state = "psydonarmet"
	item_state = "psydonarmet"
	block2add = FOV_BEHIND

//................ Iron Plate Helmet ............... //
/obj/item/clothing/head/helmet/heavy/ironplate
	name = "iron plate helmet"
	desc = "An iron masked helmet usually worn by armed men, it is a solid design yet antiquated and cheap."
	icon_state = "ironplate"
	flags_inv = HIDEEARS
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_CHEAP_IRON_HELMET
	block2add = FOV_BEHIND

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG //isn't the same as a steel helmet but is better than a skullcap, costs 2 bars and protects the mouth
	item_weight = 6 * IRON_MULTIPLIER

//............... Rusted Barbute ............... //
/obj/item/clothing/head/helmet/heavy/rust
	name = "rusted barbute"
	desc = "A rusted barbute. Relatively fragile, and might turn your hair brown, but offers good protection."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rusthelm"
	item_state = "rusthelm"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD
	item_weight = 6 * IRON_MULTIPLIER

//............... Great Helm ............... //
/obj/item/clothing/head/helmet/heavy/bucket
	name = "great helm"
	desc = "An immovable bulwark of protection for the head of the faithful. Antiquated and impractical, but offering incredible defense."
	icon_state = "topfhelm"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR

	armor = ARMOR_PLATE
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/bucket/gold
	icon_state = "topfhelm_gold"
	item_weight = 9 * GOLD_MULITPLIER

// Vampire Lord is no longer as OP, but the armor should protect against dreaded stabs or it makes the vitae spent on it pointless.
/obj/item/clothing/head/helmet/heavy/vampire
	name = "savoyard"
	desc = "A terrifying yet crude helmet shaped like a humen skull. Commands the inspiring terror of inhumen tyrants from yils past."
	icon_state = "savoyard"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR

	prevent_crits = ALL_CRITICAL_HITS_VAMP
	max_integrity = INTEGRITY_STRONGEST // steel
	body_parts_covered = HEAD_NECK
	block2add = FOV_BEHIND

/obj/item/clothing/head/helmet/heavy/ancient
	name = "ancient savoyard"
	desc = "A terrifying old savoyard."
	icon_state = "ancientsavoyard"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND

//............... Frog Helmet ............... //
/obj/item/clothing/head/helmet/heavy/frog
	name = "frog helmet"
	desc = "A thick, heavy helmet that severely obscures the wearer's vision. Still rather protective."
	icon_state = "froghelm"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

	armor = ARMOR_PLATE_GOOD
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * IRON_MULTIPLIER

//............... Black Knight Helmet ............... //
/obj/item/clothing/head/helmet/heavy/blkknight
	name = "blacksteel helmet"
	desc = "A helmet black as nite. Instills fear upon those that gaze upon it."
	icon_state = "bkhelm"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * BLACKSTEEL_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 2

//............... Zizo Frog Helmet ............... //

/obj/item/clothing/head/helmet/heavy/zizo
	name = "darksteel frog helmet"
	desc = "A darksteel frog helmet. This one has an adjustable visor. Called forth from the edge of what should be known. In Her name."
	adjustable = CAN_CADJUST
	icon_state = "zizofrogmouth"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	armor = ARMOR_PLATE
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 5 * STEEL_MULTIPLIER
	block2add = FOV_BEHIND
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

//............... Matthios Helmet ............... //

/obj/item/clothing/head/helmet/heavy/matthios
	name = "gilded visage"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	desc = "A sinister visage. So that your crimes are never brought to you."
	icon_state = "matthioshelm"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor64x64.dmi'
	armor = ARMOR_PLATE
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 5 * STEEL_MULTIPLIER
	block2add = FOV_BEHIND
	sellprice = 0 // See above comment
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64

//............... Graggar Helmet ............... //

/obj/item/clothing/head/helmet/heavy/graggar
	name = "vicious helmet"
	desc = "A rugged and horrifying helmet. A violent aura emanates from it."
	icon_state = "graggarplatehelm"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	armor = ARMOR_PLATE
	flags_cover = HEADCOVERSEYES
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 5 * STEEL_MULTIPLIER
	block2add = FOV_BEHIND
	sellprice = 0 // See above comment

//............... Baothan Helmet ............... //

/obj/item/clothing/head/helmet/heavy/baotha
	name = "willful helmet"
	desc = "Baothan knights are an antithesis : the tiefling queen preaches self preservation at the cost of even family or friend. Choosing to embark on a quest to knightlyhood means facing peril at the forefront. \
	Indeed, many are the upstarts who understood the folly of their journey, and either turned back to the warmth of ozium and wine or died in the process. \
	The original wearer of this helmet is no such pushover : they do not have the might of Graggar nor the magick of Zizo, and instead rely on their wits and grit to proclaim their unicity in the face of this cold, uncaring world. \
	It is rumoured that Baotha offers this baroque piece in person, as a reward for the knight's unflinching will in the face of sheer terror, minute after minute, hour after hour. \
	Fashioned in steel and petals, it has no viewport, the wearer instead having their senses heightened to preternatural levels." // yes, this is a long item description, but it's the only piece of armour unique to Baotha.
	icon_state = "baothahelm"
	icon = 'icons/roguetown/clothing/special/baothanknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor64x64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	armor = ARMOR_PLATE
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 5 * STEEL_MULTIPLIER
	block2add = FOV_BEHIND
	sellprice = 0 // See above comment

//............... Spangenhelm ............... //
/obj/item/clothing/head/helmet/heavy/viking
	name = "spangenhelm"
	desc = "A steel helmet with built-in eye and nose protection, commonly used by warriors of the north."
	icon_state = "Spangenhelm_item"
	item_state = "Spangenhelm_worn"
	icon = 'icons/roguetown/clothing/special/spangenhelm_item.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/spangenhelm_worn.dmi'
	body_parts_covered = HEAD|NOSE|EYES
	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEFACE|HIDEHAIR
	armor = ARMOR_PLATE
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * IRON_MULTIPLIER
	clothing_flags = CANT_SLEEP_IN
	max_integrity = INTEGRITY_STRONGEST
	block2add = FOV_BEHIND

//............... Temple heavy helmets ......................//
//............... Astrata Helmet ............... //
/obj/item/clothing/head/helmet/heavy/necked/astrata
	name = "astrata helmet"
	desc = "A great helmet decorated with a golden sigil of the solar order and a maille neck cover. The dependable companion of many holy warriors of Astrata."
	icon_state = "astratahelm"
	item_weight = 6 * GOLD_MULITPLIER

//............... Noc Helmet ............... //
/obj/item/clothing/head/helmet/heavy/necked/noc
	name = "noc helmet"
	desc = "A sleek and rounded heavy helmet with a maille neck cover. Its unique craft is said to allow holy warriors of Noc additional insight before battle."
	icon_state = "nochelm"
	item_weight = 6 * SILVER_MULTIPLIER
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/heavy/necked/noc/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

//............... Necra Helmet ............... //
/obj/item/clothing/head/helmet/heavy/necked/necra
	name = "necra helmet"
	desc = "A reinforced helmet shaped into the visage of a skull with a maille neck cover under the cloth. A symbol of authority for the battle servants of the Undermaiden."
	icon_state = "necrahelm"
	item_weight = 6 * IRON_MULTIPLIER

//............... Dendor Helmet ............... //	This one seems a bit out of place
/obj/item/clothing/head/helmet/heavy/necked/dendorhelm
	name = "dendor helmet"
	desc = "A great helmet with twisted metalwork that imitates the twisting of bark, or the horns of a beast."
	icon_state = "dendorhelm"
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 6 * IRON_MULTIPLIER

//............... Eora Helmet ............... //
/obj/item/clothing/head/helmet/sallet/eoran
	name = "eora helmet"
	desc = "A standard helmet forged in the style typical of Eoran worshippers, a simple yet practical protective piece of equipment. Upon it lays several laurels of flowers and other colorful ornaments, followed by several symbols and standards of the user's chapter, accomplishments or even punishment"
	icon_state = "eorahelm"
	item_state = "eorahelm"
	item_weight = 5 * IRON_MULTIPLIER


//............... Pestra Helmet ............... //
/obj/item/clothing/head/helmet/heavy/necked/pestrahelm
	name = "pestran helmet"
	desc = "A great helmet made of coarse, tainted steel. It is modeled after a plagued carrion, a blessed abomination of Pestra."
	icon_state = "pestrahelm"
	item_state = "pestrahelm"
	item_weight = 6 * IRON_MULTIPLIER

//................ Malum Helmet ............. //
/obj/item/clothing/head/helmet/heavy/necked/malumhelm
	name = "malumite helmet"
	desc = "A great helmet of sturdy dark steel. Its chiseled countenance reminds the viewer of Malum's stern gaze."
	icon_state = "malumhelm"
	item_state = "malumhelm"
	item_weight = 6 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/necked/ravox
	name = "ravoxian helmet"
	desc = "Headwear commonly worn by Templars in service to Ravox. It resembles a heavily-adorned visored sallet."
	icon_state = "ravoxhelm"
	item_state = "ravoxhelm"
	item_weight = 6 * IRON_MULTIPLIER

//................ Xylix Helmet ............. //
/obj/item/clothing/head/helmet/heavy/necked/xylix
	name = "xylix helmet"
	desc = "A great helmet forged from steel, and fashioned in the visage of a jester, jingling bells and all. Commonly worn by Templars in service to Xylix"
	icon_state = "xylixhelm"
	item_state = "xylixhelm"
	item_weight = 6 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/necked/xylix/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = list(SFX_JINGLE_BELLS))

//................ Abyssor Helmet ............. //
/obj/item/clothing/head/helmet/heavy/necked/abyssor
	name = "abyssor helmet"
	desc = "A great helmet crafted from bronze. The visor is slitted and ridged, evoking the gills of a great sea-beast."
	icon_state = "abyssorhelm"
	item_state = "abyssorhelm"
	item_weight = 6 * IRON_MULTIPLIER

//............... Sinistar (Graggar) Helmet ............... //
/obj/item/clothing/head/helmet/heavy/sinistar
	name = "sinistar helmet"
	desc = "Glorious star, smeared in guts and greeted with a chorus of howls."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64
	icon_state = "sinistarhelm"
	dropshrink = 0.9
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	melt_amount = 75
	melting_material = /datum/material/steel
	item_weight = 7 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/decorated	// template
	name = "a template"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_TINY
	var/picked = FALSE

	prevent_crits = ALL_CRITICAL_HITS
	abstract_type = /obj/item/clothing/head/helmet/heavy/decorated

/obj/item/clothing/head/helmet/heavy/decorated/update_overlays()
	. = ..()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon, "[icon_state][detail_tag]")
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	. += pic

//............... Decorated Knight Helmet ............... //
/obj/item/clothing/head/helmet/heavy/decorated/knight
	name = "knights helmet"
	desc = "A lavish knights helmet which allows a crest to be mounted on top."
	icon_state = "decorated_knight"
	item_weight = 9 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/decorated/knight/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = HELMET_KNIGHT_DECORATIONS
		var/choice = input(user, "Choose a crest.", "Knightly crests") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		update_appearance(UPDATE_ICON)
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//............... Decorated Hounskull ............... //
/obj/item/clothing/head/helmet/heavy/decorated/hounskull
	name = "hounskull"
	desc = "A lavish hounskull which allows a crest to be mounted on top."
	icon_state = "decorated_hounskull"
	armor = ARMOR_PLATE_GOOD
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * IRON_MULTIPLIER


/obj/item/clothing/head/helmet/heavy/decorated/hounskull/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = HELMET_HOUNSKULL_DECORATIONS
		var/choice = input(user, "Choose a crest.", "Knightly crests") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		update_appearance(UPDATE_ICON)
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//............... Decorated Great Helm ............... //
/obj/item/clothing/head/helmet/heavy/decorated/bucket
	name = "great helm"
	desc = "A lavish great helm which allows a crest to be mounted on top."
	icon_state = "decorated_bucket"
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 9 * IRON_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/decorated/bucket/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = HELMET_BUCKET_DECORATIONS
		var/choice = input(user, "Choose a crest.", "Knightly crests") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		update_appearance(UPDATE_ICON)
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//............... Decorated Gold Helm ............... //
/obj/item/clothing/head/helmet/heavy/decorated/golden
	name = "gold helm"
	desc = "A lavish gold-trimmed greathelm which allows a crest to be mounted on top."
	icon_state = "decorated_gbucket"
	prevent_crits = ALL_CRITICAL_HITS
	item_weight = 7 * GOLD_MULITPLIER

/obj/item/clothing/head/helmet/heavy/decorated/golden/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = HELMET_GOLD_DECORATIONS
		var/choice = input(user, "Choose a crest.", "Knightly crests") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		update_appearance(UPDATE_ICON)
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/head/helmet/heavy/decorated/bascinet
	name = "bascinet"
	desc = "A simple steel helmet that can be decorated with a crest. Somewhat basic, but you'll be the envy of those who cannot afford such a fancy helmet."
	icon_state = "decorated_bascinet"
	flags_inv = HIDEEARS
	sellprice = VALUE_STEEL_HELMET
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	block2add = null

	body_parts_covered = HEAD|HAIR|EARS
	item_weight = 9 * STEEL_MULTIPLIER

/obj/item/clothing/head/helmet/heavy/decorated/bascinet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = BASCINET_DECORATIONS
		var/choice = input(user, "Choose a crest.", "Knightly crests") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		update_appearance(UPDATE_OVERLAYS)
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/head/helmet/heavy/ordinatorhelm
	name = "inquisitorial ordinator's helmet"
	desc = "A design suggested by a Grenzelhoftian smith, inspired by an eccentric count who insisted on sleeping in a coffin. A steel casket with thin slits that allow for deceptively clear vision. The tainted will drown in the blood you bring their way, while this high helm keeps it out of your face."
	icon_state = "ordinatorhelm"
	item_state = "ordinatorhelm"
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	adjustable = CAN_CADJUST
	block2add = FOV_BEHIND
	max_integrity = 350
	var/plumed = FALSE

/obj/item/clothing/head/helmet/heavy/ordinatorhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather))
		user.visible_message(span_warning("[user] starts to fashion plumage using [W] for [src]."))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/head/helmet/heavy/ordinatorhelm/plume/P = new /obj/item/clothing/head/helmet/heavy/ordinatorhelm/plume(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user] stops fashioning plumage for [src]."))
		return

/obj/item/clothing/head/helmet/heavy/ordinatorhelm/plume
	icon_state = "ordinatorhelmplume"
	item_state = "ordinatorhelmplume"

/obj/item/clothing/head/helmet/heavy/ordinatorhelm/plume/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather))
		return

/obj/item/clothing/head/helmet/heavy/absolver
	name = "psydonian conical helm"
	desc = "Its shape confounds and confuses the enemies of Psydon. Offering unfound protection in its visage, the gaze is horrific to those without understanding."
	icon_state = "absolutionisthelm"
	item_state = "absolutionisthelm"
	emote_environment = 3
	block2add = null
	body_parts_covered = FULL_HEAD|NECK
	max_integrity = 450 // Worst vision. Yes.
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	clothing_flags = NONE

/obj/item/clothing/head/helmet/heavy/psybucket
	name = "psydonian bucket helmet"
	desc = "Originally just a bucket with a psycross nailed on, it proved surprisingly effective, making its way into common use for inquisitorial templars. Steel encapsulates your head, and His cross facing enemies reminds them that you will endure until they meet oblivion. Only then may you rest."
	icon_state = "psybucket"
	item_state = "psybucket"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	adjustable = CAN_CADJUST
	block2add = FOV_BEHIND
	max_integrity = 400

/obj/item/clothing/head/helmet/heavy/psysallet
	name = "psydonian sallet"
	desc = "A boiled leather cap, crowned with steel and veiled with His cross. Fear not - He will show you the way, and He will see your blows well-struck."
	icon_state = "psysallet"
	item_state = "psysallet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	adjustable = CAN_CADJUST
	block2add = FOV_BEHIND
	max_integrity = 400
