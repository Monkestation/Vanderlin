/obj/item/clothing/head/helmet/leather
	name = "leather helmet"
	desc = "A conical leather helmet. It's comfortable and won't protect much, but it's better than nothing."
	icon_state = "leatherhelm"
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	blocksound = SOFTHIT
	resistance_flags = FLAMMABLE // Made of leather
	smeltresult = /obj/item/fertilizer/ash
	anvilrepair = null
	sewrepair = TRUE
	sellprice = VALUE_LEATHER_HELMET

	armor = ARMOR_LEATHER_BAD
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	prevent_crits = CUT_AND_MINOR_CRITS
	max_integrity = INTEGRITY_STANDARD
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	item_weight = 1.6

//THE ARMOUR VALUES OF ADVANCED AND MASTERWORK HELMETS ARE INTENDED
//KEEP THIS IN MIND

/obj/item/clothing/head/helmet/leather/advanced
	name = "hardened leather helmet"
	desc = "Sturdy, durable, flexible. A comfortable and reliable hood made of hardened leather."
	max_integrity = INTEGRITY_STANDARD + 50
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|MOUTH
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/leather/masterwork
	name = "masterwork leather helmet"
	desc = "This helmet is a craftsmanship marvel. Made with the finest leather. Strong, nimble, reliable."
	max_integrity = INTEGRITY_STANDARD + 100
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|MOUTH
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP) //we're adding chop here!
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/head/helmet/leather/headscarf // repathing isnt needed really
	name = "headscarf"
	desc = "Rolled cloth. Gives some protection at least."
	icon_state = "headscarf"
	color = CLOTHING_BARK_BROWN
	sellprice = VALUE_LEATHER_HELMET/2
	armor = ARMOR_PADDED
	body_parts_covered = HEAD|HAIR
	prevent_crits =  MINOR_CRITICALS
	max_integrity = INTEGRITY_POOR
	clothing_flags = NONE
	item_weight = 0.5

/obj/item/clothing/head/helmet/leather/headscarf/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/helmet/leather/headscarf/colored/red
	color = CLOTHING_ROYAL_RED

//............... Buckled Hat ............... //
/obj/item/clothing/head/helmet/leather/inquisitor
	name = "buckled hat"
	desc = "A black top hat with a buckle on top, favored by Witch Hunters and Inquisitors."
	icon_state = "puritan_hat"

//............... Tricorn ............... //
/obj/item/clothing/head/helmet/leather/tricorn
	name = "tricorn hat"
	desc = "A black leather hat with a shaped brim that has been folded to form three points."
	icon_state = "renegadetricorn"

//............... Ominous Hood ............... //
/obj/item/clothing/head/helmet/leather/hood_ominous // a leather coif locked to headslot since you cannot pull it back. Crit prevent between armor items a little weird, this is leather coif, compare to helmet
	name = "ominous hood"
	desc = "Madmen. Cursed dogs. Beware."
	icon_state = "ominous"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	sellprice = VALUE_LEATHER_HELMET/2

	armor = ARMOR_PADDED_GOOD
	body_parts_covered = NECK|HAIR|EARS|HEAD

//............... Hardened Helmet ............... //
/obj/item/clothing/head/helmet/leather/conical // old helmet sprite
	name = "hardened helmet"
	desc = "A conical helmet made from boiled leather and metal fittings."
	icon_state = "leatherhelm_old"

//............... Volf Helmet ............... //
/obj/item/clothing/head/helmet/leather/volfhelm
	name = "volf helmet"
	desc = "A leather helmet fashioned from a volf's pelt."
	icon_state = "volfhead"

	body_parts_covered = HEAD|HAIR|EARS

//............... Miners Helmet ............... //
/obj/item/clothing/head/helmet/leather/minershelm
	name = "miners helmet"
	desc = "Boiled leather kettle-like helmet with a headlamp, fueled by magiks."
	icon_state = "minerslamp"
	item_state = "minerslamp"
	sellprice = VALUE_LEATHER_HELMET+BONUS_VALUE_MODEST

	armor = ARMOR_PADDED
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_TWIST, BCLASS_BLUNT)
	item_weight = 3 * IRON_MULTIPLIER

	actions_types = list(/datum/action/item_action/toggle_light)

	var/brightness_on = 4 //less than a torch; basically good for one person.
	var/on = FALSE

/obj/item/clothing/head/helmet/leather/minershelm/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_updates_onmob)
	return ..()

/obj/item/clothing/head/helmet/leather/minershelm/attack_self(mob/living/user, list/modifiers)
	toggle_helmet_light(user)

/obj/item/clothing/head/helmet/leather/minershelm/proc/toggle_helmet_light(mob/living/user)
	on = !on
	if(on)
		turn_on(user)
	else
		turn_off(user)
	update_appearance(UPDATE_ICON_STATE)

/obj/item/clothing/head/helmet/leather/minershelm/update_icon_state()
	. = ..()
	icon_state = "minerslamp[on]"
	item_state = "minerslamp[on]"

/obj/item/clothing/head/helmet/leather/minershelm/proc/turn_on(mob/user)
	set_light(brightness_on)

/obj/item/clothing/head/helmet/leather/minershelm/proc/turn_off(mob/user)
	set_light(0)

/obj/item/clothing/head/leather/duelhat
	name = "valorian duelist hat"
	desc = "A dainty looking feathered hat that is actually quite heavy and thick, Duelists from Valoria are known to value winning fights without dirtying the white feather on top"
	icon_state = "duelisthat"
	item_state = "duelisthat"
	sewrepair = TRUE
	prevent_crits =  MINOR_CRITICALS
	body_parts_covered = HEAD|HAIR
	dynamic_hair_suffix = ""
