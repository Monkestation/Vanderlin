
/obj/item/clothing/pants/trou
	name = "work trousers"
	desc = "Padded pants for hardy workers."
	gender = PLURAL
	icon_state = "trou"
	item_state = "trou"
	sewrepair = TRUE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

	armor = ARMOR_PADDED_BAD
	prevent_crits = MINOR_CRITICALS
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	item_weight = 3

/obj/item/clothing/pants/trou/leather
	name = "leather trousers"
	desc = "Standard leather pants for hardy workers."
	icon_state = "leathertrou"
	armor = ARMOR_LEATHER
	max_integrity = INTEGRITY_POOR

/obj/item/clothing/pants/trou/leather/guard
	uses_lord_coloring = LORD_PRIMARY
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/trou/leather/splint
	name = "splint plate trousers"
	desc = "Affordable armored pants for regular soldiers, they seem simple and their craftsmanship is solid, makes sure all stays in place with a plated codpiece."
	icon_state = "splintlegs"
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/pants/trou/leather/guard
	uses_lord_coloring = LORD_PRIMARY
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/trou/leather/advanced
	name = "hardened leather chausses"
	desc = "Sturdy, durable, flexible. The finest leather to protect your nether regions."
	max_integrity = INTEGRITY_POOR + 50
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20,"fire" = 0, "acid" = 0)

/obj/item/clothing/pants/trou/leather/advanced/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/trou/leather/quiltedkilt //close enough!
	name = "quilted kilt"
	desc = "A sturdy quilted kilt."
	icon_state = "lakkarikilt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sewrepair = TRUE
	max_integrity = 175
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	armor = list("blunt" = 65, "slash" = 50, "stab" = 25, "piercing" = 25,"fire" = 0, "acid" = 0)

/obj/item/clothing/pants/trou/leather/quiltedkilt/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/trou/leather/quiltedkilt/colored/blue
	color = CLOTHING_SKY_BLUE

/obj/item/clothing/pants/trou/leather/quiltedkilt/colored/red
	color = CLOTHING_ROYAL_RED

/obj/item/clothing/pants/trou/leather/quiltedkilt/colored/linen
	color = CLOTHING_LINEN

/obj/item/clothing/pants/trou/leather/masterwork
	name = "masterwork leather chausses"
	desc = "These chausses are a craftsmanship marvel. Made with the finest leather. Strong, nimble, reliable."
	max_integrity = INTEGRITY_POOR + 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/pants/trou/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/pants/trou/leather/mourning
	name = "mourning trousers"
	desc = "Dark trousers worn by morticians while performing burial rites."
	icon_state = "leathertrou"
	color = "#151615"

/obj/item/clothing/pants/trou/shadowpants
	name = "silk tights"
	desc = "Form-fitting legwear. Almost too form-fitting."
	mob_overlay_icon = 'icons/roguetown/clothing/newclothes/onmob/onmobsilkpants.dmi'
	sleeved = 'icons/roguetown/clothing/newclothes/onmob/sleeves_pants.dmi'
	icon_state = "shadowpants"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_amount = 1
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/pants/trou/apothecary
	name = "apothecary trousers"
	desc = "Heavily padded trousers. They're stained by countless herbs."
	icon_state = "apothpants"
	item_state = "apothpants"

/obj/item/clothing/pants/trou/artipants
	name = "artificer trousers"
	desc = "Thick leather trousers to protect from sparks or stray gear projectiles. Judging by the wear, it's had plenty of use."
	icon_state = "artipants"
	item_state = "artipants"

/obj/item/clothing/pants/trou/leathertights
	name = "leather tights"
	desc = "Classy leather tights, form-fitting but tasteful."
	icon_state = "leathertights"
	item_state = "leathertights"

/obj/item/clothing/pants/trou/beltpants
	name = "belt-buckled trousers"
	desc = "Dark leather trousers adorned with far too many buckles to be pragmatic."
	icon_state = "beltpants"
	item_state = "beltpants"

//Valorian Duelist Merc - On par with grenzelhoftian's stats.
/obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	desc = "Padded pants, favored by Valoria's Duelists, Legs are often a prime target in a duel, and these pants seem to have seen their fair share of it"
	color = "#5a5a5a"
	armor = ARMOR_PADDED
	prevent_crits = MINOR_CRITICALS
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/pants/trou/formal
	name = "formal trousers"
	desc = "A formal pair of formal trousers."
	icon_state = "butlerpants"
	item_state = "butlerpants"
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	salvage_result = /obj/item/natural/cloth
	detail_color = CLOTHING_DARK_INK

/obj/item/clothing/pants/trou/formal/shorts
	name = "trouser shorts"
	desc = "A pair of formal trouser shorts, fit for any strapping young lad."
	icon_state = "butlershorts"
	item_state = "butlershorts"
	detail_color = CLOTHING_SOOT_BLACK

/obj/item/clothing/pants/trou/courtphysician
	name = "sanguine trousers"
	desc = "A pair of formal trousers, clean to the best of the servant's ability, but some bloodstains are impossible to rid them of"
	icon_state = "docpants"
	item_state = "docpants"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY
