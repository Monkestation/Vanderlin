/obj/item/clothing/cloak/templar
	var/overarmor = TRUE

/obj/item/clothing/cloak/templar/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/templar/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))


/obj/item/clothing/cloak/templar/astratan
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "astratan tabard"
	desc = "The washed out golds of an astratan crusader adorn these fine robes."
	icon_state = "astratatabard"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/cloak/templar/malumite
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "tabard of malum"
	desc = "Light blacks and greys, with a tinge of red, the everlasting fire of Malum's iron hammer as it strikes."
	icon_state = "malumtabard"

/obj/item/clothing/cloak/templar/necran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "necran tabard"
	desc = "Deep dark blacks, swallowing all light as if the night itself."
	icon_state = "necratabard"

/obj/item/clothing/cloak/templar/pestran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "pestran tabard"
	desc = "A simple covering of green cloth, meant to keep rot and blood alike off its wearer."
	icon_state = "pestratabard"

/obj/item/clothing/cloak/templar/eoran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "eoran tabard"
	desc = "A complex covering of translucent pink and beige clothes. They carry the scent of flowers in them."
	icon_state = "eoratabard"

/obj/item/clothing/cloak/templar/xylixian
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "xylixian cloak"
	desc = "Swirling cloth, jingling bells! Oh, how I love the path to hell!"
	icon_state = "xylixcloak"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"


/obj/item/clothing/cloak/templar/undivided
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "undivided tabard"
	desc = "The refuge of the TEN upon my back. An Undivided House, standing eternal against the encroaching darkness."
	icon_state = "seetabard"


/obj/item/clothing/cloak/wardencloak
	name = "warden cloak"
	desc = "A cloak worn by the Wardens of Azuria's Forests"
	icon_state = "wardencloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/wardencloak/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/graggar
	name = "vicious cloak"
	desc = "The only motive force in this rotten world is violence. Be its wielder, not its victim."
	icon_state = "graggarcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE


/obj/item/clothing/cloak/forrestercloak
	name = "forrester cloak"
	desc = "A cloak worn by the Black Oaks of Azuria."
	icon_state = "forestcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/forrestercloak/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/forrestercloak/snow
	name = "snow cloak"
	desc = "A cloak meant to keep one's body warm in the cold of the mountains as well as the dampness of Azuria."
	icon_state = "snowcloak"

/obj/item/clothing/cloak/templar/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the tabard over my armor" : "wear the tabard under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/templar/eora
	name = "eora tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Eora on it."
	icon_state = "tabard_eora"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB

/obj/item/clothing/cloak/templar/pestra
	name = "pestra tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Pestra on it."
	icon_state = "tabard_pestra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB

/obj/item/clothing/cloak/ravox
	name = "ravox tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Ravox on it."
	icon_state = "tabard_ravox"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB

/obj/item/clothing/cloak/templar/xylix
	name = "xylix tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Xylix on it."
	icon_state = "tabard_xylix"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDEBOOB


/obj/item/clothing/head/veiled
	name = "nurse's veil"
	desc = "A chirurgeon's bonnet, veiled with petal-stuffed linen. The stitchwork is often donned by the likes of wandering plague doctors and clerics; especially, those who're beholden to Pestra and Psydon."
	icon_state = "veil"
	item_state = "veil"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDEEARS
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|NECK|MOUTH|NOSE|EYES
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = SOFTHIT
	max_integrity = 100
	sewrepair = TRUE
	adjustable = CAN_CADJUST

/obj/item/clothing/head/veiled/update_overlays()
	. = ..()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		. += pic

/obj/item/clothing/head/veiled/loudmouth
	name = "loudmouth's headcover"
	desc = "Said to be worn by only the loudest and proudest. The mask is adjustable."
	icon_state = "loudmouth"
	item_state = "loudmouth"
	color = "#8b2323"

/obj/item/clothing/head/helmet/heavy/xylixhelm
	name = "xylixian helmet"
	desc = "I dance, I sing! I'll be your fool!"
	icon_state = "xylixhelmet"
	item_state = "xylixhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/xylixhelm/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)

/obj/item/clothing/head/helmet/heavy/astratahelm
	name = "astrata helmet"
	desc = "Headwear commonly worn by Templars in service to Astrata. The firstborn child's light will forever shine on within its crest."
	icon_state = "astratanhelm"
	item_state = "astratanhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/nochelm
	name = "noc helmet"
	desc = "Headwear commonly worn by Templars in service to Noc. Without the night there can be no day; without Noc there can be no light in the dark hours."
	icon_state = "nochelm"
	item_state = "nochelm"
	emote_environment = 3
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/necrahelm
	name = "necra helmet"
	desc = "Headwear commonly worn by Templars in service to Necra. Let its skeletal features remind you of the only thing which is guaranteed in life: You will die."
	icon_state = "necranhelm"
	item_state = "necranhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/dendorhelm
	name = "dendor helmet"
	desc = "Headwear commonly worn by Templars in service to Dendor. Its protrusions almost resemble branches. Take root in the earth, and you will never be moved."
	icon_state = "dendorhelm"
	item_state = "dendorhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/abyssorgreathelm
	name = "abyssorite helmet"
	desc = "A helmet commonly worn by Templars in service to Abyssor. It evokes imagery of the sea with a menacing crustacean visage."
	icon_state = "abyssorgreathelm"
	item_state = "abyssorgreathelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/ravoxhelm
	name = "justice eagle"
	desc = "Forged in reverence to Ravox, this helm bears the stylized visage of an eagle, symbol of unyielding judgment and divine vigilance. Its hollow eyes see not just foes, but the truth behind every deed."
	icon_state = "ravoxhelmet"
	item_state = "ravoxhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/clothing/head/helmet/heavy/ravoxhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	var/list/colorlist = list(
		"PURPLE"="#865c9c",
		"RED"="#8f3636",
		"BLACK"="#2f352f",
		"BROWN"="#685542",
		"GREEN"="#58793f",
		"BLUE"="#395480",
		"YELLOW"="#b5b004",
		"TEAL"="#249589",
		"WHITE"="#c7c0b5",
		"ORANGE"="#b47011",
		"MAJENTA"="#822b52",
	)

	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Plume") as anything in colorlist
		detail_color = colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/helmet/heavy/volfplate
	name = "volf-face helm"
	desc = "A steel bascinet helmet with a volfish visor protecting the head, ears, eyes, nose and mouth."
	icon_state = "volfplate"
	item_state = "volfplate"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	melting_material = /datum/material/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	adjustable = CAN_CADJUST

/obj/item/clothing/head/helmet/heavy/volfplate/puritan
	name = "volfskulle bascinet"
	desc = "A steel bascinet helmet with a snarling visor that protects the entire head and face. It mimics the guise of a terrible nitebeast; intimidating to the levyman, inspiring to the hunter."


/obj/item/clothing/face/facemask/psydonmask
	name = "psydonic mask"
	desc = "A silver mask, forever locked in a rigor of uncontestable joy. The Order of Saint Xylix can't decide on whether it's meant to represent Psydon's 'mirthfulness,' 'theatricality,' or the unpredictable melding of both."
	icon_state = "psydonmask"
	item_state = "psydonmask"
