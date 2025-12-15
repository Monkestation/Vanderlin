/obj/item/clothing/cloak/eastcloak1
	name = "cloud-cutter's cloak"
	desc = "A brown cloak with white swirls. A few may recognize it as an old militaristic symbol."
	color = null
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak1"
	item_state = "eastcloak1"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/cloak/eastcloak2
	name = "leather cloak"
	desc = "A brown cloak. There's nothing special on it."
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	color = null
	icon_state = "eastcloak2"
	item_state = "eastcloak2"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/cloak/psyaltrist
	name = "psyalter's stole"
	desc = "A silk stole embroidered with silver filigree and with concealed pockets in its back worn over a hymnal-scroll. It is worn as the traditional garb of a graduate of the choir leaders of the cathedrals of Grenzelhoft, and is a symbol of their station."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	icon_state = "psaltertabard"
	item_state = "psaltertabard"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE


/obj/item/clothing/cloak/psyaltrist/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/head/spellcasterhat
	name = "spellsinger hat"
	desc = "An oddly shaped hat made of tightly-sewn leather, commonly worn by spellsinger."
	icon_state = "spellcasterhat"
	item_state = "spellcasterhat"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_HELMET_LEATHER
	blocksound = SOFTHIT
	sewrepair = TRUE
	flags_inv = HIDEEARS
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	body_parts_covered = HEAD|HAIR|EARS|NOSE|EYES
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shirt/robe/spellcasterrobe
	slot_flags = ITEM_SLOT_ARMOR
	name = "spellsinger robes"
	desc = "A set of reinforced, leather-padded robes worn by spellblades."
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	armor_class = AC_LIGHT
	icon_state = "spellcasterrobe"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/armor/basiceast
	name = "simple dobo robe"
	desc = "A dirty dobo robe with white lapels. Can be upgraded through the use of a tailor to increase its integrity and protection."
	icon_state = "eastsuit3"
	item_state = "eastsuit3"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = TRUE
	nodismemsleeves = TRUE
	sellprice = 20
	armor_class = AC_LIGHT
	allowed_race = RACES_PLAYER_ALL
	flags_inv = HIDEBOOB

//less integrity than a leather cuirass, incredibly weak to blunt damage - great against slash - standard leather value against stab
//the intent for these armors is to create specific weaknesses/strengths for people to play with

/obj/item/clothing/armor/basiceast/crafteast
	name = "decorated dobo robe"
	desc = "A dobo robe with a red tassel. Leather inlays are sewn in. It looks sturdier than a simple robe."
	icon_state = "eastsuit2"
	item_state = "eastsuit2"
	armor = ARMOR_LEATHER_GOOD // Makes it the equivalence of studded with less integrity and better armor
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

//craftable variation of eastsuit, essentially requiring the presence of a tailor with relevant materials
//still weak against blunt

/obj/item/clothing/armor/basiceast/mentorsuit
	name = "old dobo robe"
	desc = "The scars on your body were once stories of strength and bravado."
	icon_state = "eastsuit1"
	item_state = "eastsuit1"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM


/obj/item/clothing/armor/basiceast/captainrobe
	name = "foreign robes"
	desc = "Flower-styled robes."
	icon_state = "eastsuit4"
	item_state = "eastsuit4"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25 // Head Honcho gets a buff
	sellprice = 25


// this robe spawns on a role that offers no leg protection nor further upgrades to the loadout, in exchange for better roundstart gear

/obj/item/storage/belt/leather/exoticsilkbelt
	name = "exotic silk belt"
	desc = "A gold adorned belt with the softest of silks barely concealing one's bits."
	icon_state = "exoticsilkbelt"
	var/max_storage = 5
	sewrepair = TRUE

/obj/item/clothing/shoes/anklets
	name = "golden anklets"
	desc = "Luxurious anklets made of the finest gold. They leave the feet bare while adding an exotic flair."
	gender = PLURAL
	icon_state = "anklets"
	item_state = "anklets"
	is_barefoot = TRUE
	sewrepair = TRUE
	armor = ARMOR_BOOTS_BAD

/obj/item/clothing/shoes/rumaclan
	name = "raised sandals"
	desc = "A pair of strange sandals that push you off the ground."
	icon_state = "eastsandals"
	item_state = "eastsandals"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	armor = ARMOR_BOOTS

/obj/item/clothing/gloves/eastgloves1
	name = "black gloves"
	desc = "Sleek gloves typically used by swordsmen."
	icon_state = "eastgloves1"
	item_state = "eastgloves1"
	armor = ARMOR_GLOVES_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE

/obj/item/clothing/gloves/eastgloves2
	name = "stylish gloves"
	desc = "Unusual gloves worn by foreign gangs."
	icon_state = "eastgloves2"
	item_state = "eastgloves2"
	armor = ARMOR_GLOVES_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE

/obj/item/clothing/head/mentorhat
	name = "worn bamboo hat"
	desc = "A reinforced bamboo hat."
	icon_state = "easthat"
	item_state = "easthat"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_HELMET_LEATHER
	blocksound = SOFTHIT
	sewrepair = TRUE
	flags_inv = HIDEEARS
	body_parts_covered = HEAD|HAIR|EARS|NOSE|EYES
	resistance_flags = FIRE_PROOF

/obj/item/clothing/face/facemask/yoruku_oni
	name = "oni mask"
	desc = "A wood mask carved in the visage of demons said to stalk the mountains of Kazengun."
	icon_state = "oni"

/obj/item/clothing/face/facemask/yoruku_kitsune
	name = "kitsune mask"
	desc = "A wood mask carved in the visage of the fox spirits said to ply their tricks in the forests of Kazengun."
	icon_state = "kitsune"


/obj/item/clothing/neck/psycross/pearl //put it as a psycross so it can be used for miracles
	name = "pearl amulet"
	icon_state = "pearlcross"
	desc = "An amulet made of white pearls, usually worn by fishers or sailors."
	sellprice = 80

/obj/item/clothing/neck/psycross/bpearl
	name = "blue pearl amulet"
	icon_state = "bpearlcross"
	desc = "An amulet made of rare blue pearls, usually worn by priests and worshippers of Abyssor, or as lucky charms for captains of ships."
	sellprice = 220

/obj/item/clothing/neck/psycross/shell
	name = "oyster shell necklace"
	icon_state = "oyster_necklace"
	desc = "A necklace of strung-up seashells, the calming noise they make when they clack together is reminiscent of a shellfish's claws. They remind you that while men no longer live in water, Abyssor will always remember our origins."
	sellprice = 25

/obj/item/clothing/neck/psycross/shell/bracelet
	name = "shell bracelet"
	icon_state = "oyster_bracelet"
	desc = "A beaded bracelet made from seashells, their rough exterior and glossy interior reminding you that Abyssor's children hide the best gifts at the deepest spots beneath the waves."
	sellprice = 15
	slot_flags = ITEM_SLOT_WRISTS

/obj/item/clothing/pants/trou/leather/eastpants1
	name = "cut-throat's pants"
	desc = "Foreign pants, with leather insewns."
	icon_state = "eastpants1"
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/pants/trou/leather/eastpants2
	name = "strange ripped pants"
	desc = "Weird pants typically worn by the destitute in Kazengun. Or, those looking to make a fashion statement."
	icon_state = "eastpants2"
	allowed_race = RACES_PLAYER_ALL


/obj/item/clothing/shirt/dress/silkdress/loudmouth
	color = null
	name = "crier's garb"
	desc = "A robe that speaks volumes!"
	icon_state = "loudmouthrobe"
	item_state = "loudmouthrobe"

//WEDDING CLOTHES
/obj/item/clothing/shirt/dress/silkdress/weddingdress
	name = "wedding silk dress"
	desc = "A dress woven from fine silks, with golden threads inlaid in it. Made for that special day."
	icon_state = "weddingdress"
	item_state = "weddingdress"

/obj/item/clothing/shirt/exoticsilkbra
	name = "exotic silk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon_state = "exoticsilkbra"
	item_state = "exoticsilkbra"
	body_parts_covered = CHEST
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT

//kazengite content
/obj/item/clothing/shirt/undershirt/eastshirt1
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "black foreign shirt"
	desc = "A shirt typically used by thugs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt1"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDEBOOB
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/shirt/undershirt/eastshirt2
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "white foreign shirt"
	desc = "A shirt typically used by foreign gangs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt2"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDEBOOB
	allowed_race = RACES_PLAYER_ALL

/obj/item/clothing/shirt/undershirt/easttats
	name = "bouhoi bujeog tattoos"
	desc = "A mystic style of tattoos used to honor the kin that fell generations ago, a sign of companionship and secretive brotherhood. These are styled into the shape of clouds, created by a mystical ink which shifts and moves in ripples like a pond to harden where your skin is struck. Its movement causes you to shudder."
	resistance_flags = FIRE_PROOF
	icon_state = "easttats"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = RACES_PLAYER_ALL
	surgery_cover = FALSE
	max_integrity = 600 //Bad armor protection and very basic crit protection, but incredibly hard to break completely
	flags_inv = null //free the breast
	var/repair_amount = 6 //The amount of integrity the tattoos will repair themselves
	var/repair_time = 20 SECONDS //The amount of time between each repair
	var/last_repair //last time the tattoos got repaired

/obj/item/clothing/shirt/undershirt/easttats/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shirt/undershirt/easttats/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/shirt/undershirt/easttats/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(atom_integrity < max_integrity)
		START_PROCESSING(SSobj, src)
		return

/obj/item/clothing/shirt/undershirt/easttats/process()
	if(atom_integrity >= max_integrity)
		STOP_PROCESSING(SSobj, src)
		src.visible_message(span_notice("The [src] flow more calmly, as they finish resting and regain their strength."), vision_distance = 1)
		return
	else if(world.time > src.last_repair + src.repair_time)
		src.last_repair = world.time
		update_integrity(min(atom_integrity + src.repair_amount, src.max_integrity))
	..()
