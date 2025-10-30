/obj/item/clothing/shirt/shadowshirt
	name = "silk shirt"
	desc = "A sleeveless shirt woven of glossy material."
	icon_state = "shadowshirt"
	item_state = "shadowshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS
	allowed_race = RACES_PLAYER_ELF_ALL
	allowed_sex = list(FEMALE)
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/shirt/apothshirt
	name = "apothecary shirt"
	desc = "When trudging through late-autumn forests, one needs to keep warm."
	icon_state = "apothshirt"
	item_state = "apothshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/shirt/rags
	slot_flags = ITEM_SLOT_ARMOR
	name = "rags"
	desc = "Better than going naked? You be the judge."
	body_parts_covered = CHEST|GROIN|VITALS
	color = "#b0b0b0"
	icon_state = "rags"
	item_state = "rags"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	fiber_salvage = FALSE

/obj/item/clothing/shirt/tribalrag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tribalrag"
	desc = ""
	body_parts_covered = CHEST|VITALS
	boobed = TRUE
	icon_state = "tribalrag"
	item_state = "tribalrag"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDEBOOB

/obj/item/clothing/shirt/jester
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "jester's tunick"
	desc = "Just remember that the last laugh is on you."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "jestershirt"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/shirt/grenzelhoft
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "grenzelhoftian hip-shirt"
	desc = "A true fashion statement worn by Grenzelhoftian swordsmen."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	armor = list("blunt" = 20, "slash" = 20, "stab" = 20,  "piercing" = 10, "fire" = 0, "acid" = 0)
	icon_state = "grenzelshirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	var/picked = FALSE
	colorgrenz = TRUE

/obj/item/clothing/shirt/grenzelhoft/Initialize()
	. = ..()
	if(!picked)
		var/mob/living/carbon/human/L = loc
		if(!istype(L))
			return
		if(!L.client)
			return
		INVOKE_ASYNC(src, PROC_REF(get_player_input))

/obj/item/clothing/shirt/grenzelhoft/proc/get_player_input()
	if(!ishuman(loc))
		return

	var/list/colors = list(
	"PURPLE"="#865c9c",
	"RED"="#933030",
	"BROWN"="#685542",
	"GREEN"="#79763f",
	"BLUE"="#395480",
	"YELLOW"="#b5b004",
	"TEAL"="#249589",
	"WHITE"="#ffffff",
	"ORANGE"="#b86f0c",
	"Royal Majenta"="#962e5c")
	var/mob/living/carbon/human/L = loc
	var/choice = input(L, "Choose a color.", "GRENZELHOFTIAN COLORPLEX") as anything in colors
	var/playerchoice = colors[choice]
	picked = TRUE
	detail_color = playerchoice
	update_appearance(UPDATE_OVERLAYS)
	for(var/obj/item/clothing/V in L.get_equipped_items(FALSE))
		if(V.colorgrenz)
			V.detail_color = playerchoice
			V.update_appearance(UPDATE_OVERLAYS)
	L.regenerate_icons()

/obj/item/clothing/shirt/ornate
	name = "ornate base"
	desc = "If you see this, someone messed up and either spawned the wrong item or mapped in the wrong item, yell at them!"
	icon = 'icons/roguetown/clothing/ornate_tunic.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/ornate_tunic.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/ornate_tunic.dmi'
	boobed = TRUE
	abstract_type = /obj/item/clothing/shirt/ornate

/obj/item/clothing/shirt/ornate/tunic
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "ornate tunic"
	desc = "A red tunic with gold accents, fit for nobility."
	icon_state = "ornatetunic"
	sellprice = 150

/obj/item/clothing/shirt/ornate/dress
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "ornate dress"
	desc = "A red dress with gold accents, fit for nobility."
	icon_state = "ornatedress"
	sellprice = 150

/obj/item/clothing/shirt/clothvest
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	name = "cloth vest"
	desc = "a plain cloth vest, versatile and fashionable."
	icon_state = "clothvest"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/clothvest/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/clothvest/colored/random/Initialize()
	color = pick(CLOTHING_LINEN, CLOTHING_BARK_BROWN, CLOTHING_FOREST_GREEN, CLOTHING_BERRY_BLUE, CLOTHING_BLOOD_RED, CLOTHING_PEAR_YELLOW, CLOTHING_ROYAL_TEAL)
	return ..()


