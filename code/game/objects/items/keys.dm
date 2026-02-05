/obj/item/key
	name = "old key"
	desc = "A simple key of simple uses."
	icon_state = "brownkey"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	drop_sound = 'sound/items/gems (1).ogg'
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK|ITEM_SLOT_RING
	grid_height = 64
	grid_width = 32

/obj/item/lockpick
	name = "lockpick"
	desc = "A small, sharp piece of metal to aid opening locks in the absence of a key."
	icon_state = "lockpick"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	max_integrity = 10
	var/picklvl = 1
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	destroy_sound = 'sound/items/pickbreak.ogg'
	grid_width = 32
	grid_height = 64

//custom key
/obj/item/key/custom
	name = "custom key"
	desc = "A custom key designed by a blacksmith."
	icon_state = "brownkey"
	var/access2add

/obj/item/key/custom/copy_access(obj/O)
	if(istype(O, /obj/item/key/custom))
		var/obj/item/key/custom/k = O
		if(k.access2add)
			src.access2add = k.access2add
			return TRUE
	var/list/access = O.get_access()
	if(access)
		access2add = access.Copy()
		return TRUE
	return FALSE

/obj/item/key/custom/examine()
	. += ..()
	if(lockids)
		. += span_info("It has been etched with [access2string()].")
		. += span_info("It can have a name etched with a hammer.")
		return
	. += span_info("Its teeth can be set with a hammer or copied from an existing lock or key.")
	if(access2add)
		. += span_info("It has been marked with [access2add[1]], but has not been finished.")

/obj/item/key/custom/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/weapon/hammer))
		return ..()
	if(lockids)
		var/input = (input(user, "What would you name this key?", "", "") as text)
		if(!input)
			return
		name = input + " key"
		to_chat(user, span_notice("You rename the key to [name]."))
		return
	var/input = input(user, "What would you like to set the key ID to?", "", 0) as num
	input = abs(input)
	if(!input)
		return
	to_chat(user, span_notice("You set the key ID to [input]."))
	access2add = list("[input]")

/obj/item/key/custom/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(lockids)
		to_chat(user, span_warning("[src] has been finished, it cannot be adjusted again!"))
		return
	if(istype(I, /obj/item/weapon/hammer))
		if(!access2add)
			to_chat(user, span_warning("[src] is not ready, its teeth are not set!"))
			return
		lockids = access2add
		access2add = null
		to_chat(user, span_notice("You finish [src]."))
		return
	if(!copy_access(I))
		to_chat(user, span_warning("I cannot forge a key from [I]!"))
		return
	to_chat(user, span_notice("I forge the key based on the workings of [I]."))

/obj/item/key/lord
	name = "master key"
	desc = "The Lord's key."
	icon_state = "bosskey"
	lockids = list(ACCESS_LORD)

/obj/item/key/lord/Initialize()
	. = ..()
	if(!istype(loc, /mob/living/carbon/human/dummy))
		SSroguemachine.key = src

/obj/item/key/lord/Destroy()
	if(SSroguemachine.key == src)
		SSroguemachine.key = null
	return ..()

/obj/item/key/lord/proc/anti_stall()
	visible_message(span_warning("[src] flies up into the sky and into the direction of the keep!"))
	qdel(src) //Anti-stall

///// TOWN KEYS

// Worksmen

/obj/item/key/apothecary
	name = "apothecary's key"
	desc = "Master key of the bathhouse."
	icon_state = "rustkey"
	lockids = list(ACCESS_APOTHECARY)

/obj/item/key/blacksmith
	name = "blacksmith key"
	desc = "The master key for the town Smithy."
	icon_state = "brownkey"
	lockids = list(ACCESS_SMITH)

/obj/item/key/butcher
	name = "butcher key"
	desc = "There's some dried blood on this key, it's probably the butchers."
	icon_state = "rustkey"
	lockids = list(ACCESS_BUTCHER)

/obj/item/key/tailor
	name = "tailor's key"
	icon_state = "rustkey"
	lockids = list(ACCESS_TAILOR)

/obj/item/key/clinic
	name = "clinic key"
	desc = "The Physicker's key, for the Clinic doors."
	icon_state = "mazekey"
	lockids = list(ACCESS_CLINIC)

/obj/item/key/soilson
	name = "Soilson Key"
	desc = "This key is used by the Soilsons."
	icon_state = "rustkey"
	lockids = list(ACCESS_FARM, ACCESS_BUTCHER)

/obj/item/key/merchant
	name = "merchant's key"
	desc = "A key used by the Merchant's Guild."
	icon_state = "cheesekey"
	lockids = list(ACCESS_MERCHANT)

/obj/item/key/tavern // Room keys at bottom of file
	name = "inn key"
	desc = "This key should open and close any Inn door."
	icon_state = "hornkey"
	lockids = list(ACCESS_INN)

/obj/item/key/artificer
	name = "artificer's key"
	desc = "This bronze key should open the Artificer's guild."
	icon_state = "brownkey"
	lockids = list(ACCESS_ARTIFICER)

/obj/item/key/miner
	name = "miner's key"
	desc = "This bronze key should open the Miner's quarters."
	icon_state = "brownkey"
	lockids = list(ACCESS_MINER)

// Residents

/obj/item/key/matron
	name = "matron's key"
	icon_state = "rustkey"
	lockids = list(ACCESS_MATRON)

/obj/item/key/elder
	name = "elder's key"
	icon_state = "rustkey"
	lockids = list(ACCESS_ELDER)

/obj/item/key/veteran
	name = "veteran's key"
	icon_state = "rustkey"
	lockids = list(ACCESS_VETERAN)

/obj/item/key/feldsher
	name = "feldsher's key"
	desc = "The key to the Feldsher's own clinic."
	icon_state = "birdkey"
	lockids = list(ACCESS_FELDSHER)

/obj/item/key/tower
	name = "tower key"
	desc = "This key should open anything within the tower."
	icon_state = "greenkey"
	lockids = list(ACCESS_TOWER)

/obj/item/key/bathhouse
	name = "bathhouse key"
	desc = "A key for the Bathhouse."
	icon_state = "brownkey"
	lockids = list(ACCESS_BATHHOUSE)

// Garrison

/obj/item/key/garrison
	name = "city watch key"
	desc = "This key belongs to the City Watch."
	icon_state = "spikekey"
	lockids = list(ACCESS_GARRISON)

/obj/item/key/lieutenant
	name = "city watch lieutenant key"
	desc = "This key belongs to the Lieutenant of the City Watch."
	icon_state = "spikekey"
	lockids = list(ACCESSS_LIEUTENANT)

/obj/item/key/forrestgarrison
	name = "forest guard key"
	desc = "This key belongs to the Forest Guard."
	icon_state = "spikekey"
	lockids = list(ACCESS_FOREST)

/obj/item/key/captain
	name = "captain's key"
	desc = "This key belongs to the Captain of the City Watch."
	icon_state = "cheesekey"
	lockids = list(ACCESS_CAPTAIN)

// Other

/obj/item/key/mercenary
	name = "mercenary key"
	desc = "Why, a mercenary would not kick doors down."
	icon_state = "greenkey"
	lockids = list(ACCESS_MERC)

/obj/item/key/gaffer
	name = "Mercenary guild master's key"
	desc = "\"Humble\" would be a kinder word to use for its current state..."
	icon_state = "rustkey"
	lockids = list(ACCESS_GAFFER)

/obj/item/key/warehouse
	name = "Warehouse key"
	desc = "This key opens the Steward's warehouse."
	icon_state = "rustkey"
	lockids = list(ACCESS_WAREHOUSE)

////// MANOR

/obj/item/key/manor
	name = "manor key"
	desc = "This key will open most Manor doors."
	icon_state = "mazekey"
	lockids = list(ACCESS_MANOR)

/obj/item/key/hand
	name = "hand's key"
	desc = "This regal key belongs to the Monarch's Right Hand."
	icon_state = "cheesekey"
	lockids = list(ACCESS_HAND)

/obj/item/key/steward
	name = "steward's key"
	desc = "This key belongs to the Monarch's greedy Steward."
	icon_state = "cheesekey"
	lockids = list(ACCESS_STEWARD)

/obj/item/key/vault
	name = "vault key"
	desc = "This key opens the mighty Vault."
	icon_state = "cheesekey"
	lockids = list(ACCESS_VAULT)

/obj/item/key/dungeon
	name = "dungeon key"
	desc = "This key should unlock the rusty bars and doors of the dungeon."
	icon_state = "rustkey"
	lockids = list(ACCESS_DUNGEON)

/obj/item/key/consort
	name = "consort key"
	desc = "The Consort's key."
	icon_state = "mazekey"
	lockids = list(ACCESS_LORD)

/obj/item/key/walls
	name = "manor gatehouse key"
	desc = "This is a rusty key for the Manor gatehouse."
	icon_state = "rustkey"
	lockids = list(ACCESS_MANOR_GATE)

/obj/item/key/archive
	name = "archive key"
	desc = "This key looks barely used."
	icon_state = "ekey"
	lockids = list(ACCESS_ARCHIVE)

/obj/item/key/mage
	name = "magicians's key"
	desc = "This is the Court Magician's key. It watches you..."
	icon_state = "eyekey"
	lockids = list(ACCESS_MAGE)

/obj/item/key/atarms
	name = "keep garrison key"
	desc = "A key given to the Monarch's men-at-arms."
	icon_state = "spikekey"
	lockids = list(ACCESS_AT_ARMS)

/obj/item/key/guest
	name = "guest key"
	desc = "The key to the manor's guest room. Given to visiting nobles."
	icon_state = "greenkey"
	lockids = list(ACCESS_GUEST)

/obj/item/key/courtphys
	name = "court physician's key"
	desc = "A key granted to the honored Court Physician."
	icon_state = "ankhkey"
	lockids = list(ACCESS_PHYSICIAN)

////// CHURCH

/obj/item/key/church
	name = "church key"
	desc = "This bronze key should open almost all doors in the church."
	icon_state = "brownkey"
	lockids = list(ACCESS_CHURCH)

/obj/item/key/priest
	name = "priest's key"
	desc = "The key to the Priest's chambers."
	icon_state = "cheesekey"
	lockids = list(ACCESS_PRIEST)

/obj/item/key/graveyard
	desc = "This rusty key belongs to the Gravetenders."
	icon_state = "rustkey"
	lockids = list(ACCESS_GRAVE)

/obj/item/key/inquisition
	name = "inquisition key"
	desc = "This is an intricate key."
	icon_state = "mazekey"
	lockids = list(ACCESS_RITTER)

// HOUSES

/obj/item/key/houses
	name = "REPORT TO MAPPERS"
	icon_state = "brownkey"

/obj/item/key/houses/house1
	name = "house I key"
	lockids = list("house1")

/obj/item/key/houses/house2
	name = "house II key"
	lockids = list("house2")

/obj/item/key/houses/house3
	name = "house III key"
	lockids = list("house3")

/obj/item/key/houses/house4
	name = "house IV key"
	lockids = list("house4")

/obj/item/key/houses/house5
	name = "house V key"
	lockids = list("house5")

/obj/item/key/houses/house6
	name = "house VI key"
	lockids = list("house6")

/obj/item/key/houses/house7
	name = "house VII key"
	lockids = list("house7")

/obj/item/key/houses/house8
	name = "house VIII key"
	lockids = list("house8")

/obj/item/key/houses/house9
	name = "house IX key"
	lockids = list("house9")

/obj/item/key/houses/waterfront1
	name = "I waterfront street key"
	lockids = list("waterfront1")

/obj/item/key/houses/waterfront2
	name = "II waterfront street key"
	lockids = list("waterfront2")

/obj/item/key/houses/waterfront3
	name = "III waterfront street key"
	lockids = list("waterfront3")

/obj/item/key/houses/waterfront4
	name = "IV waterfront street key"
	lockids = list("waterfront4")

/obj/item/key/houses/waterfront5
	name = "V waterfront street key"
	lockids = list("waterfront5")

// APARTMENTS AND PENTHOUSES

/obj/item/key/apartments
	name = "REPORT TO MAPPERS"
	icon_state = "brownkey"

/obj/item/key/apartments/slums1
	name = "slums I key"
	lockids = list("slums1")

/obj/item/key/apartments/slums2
	name = "slums II key"
	lockids = list("slums2")

/obj/item/key/apartments/slums3
	name = "slums III key"
	lockids = list("slums3")

/obj/item/key/apartments/slums4
	name = "slums IV key"
	lockids = list("slums4")

/obj/item/key/apartments/slums5
	name = "slums V key"
	lockids = list("slums5")

/obj/item/key/apartments/slums6
	name = "slums VI key"
	lockids = list("slums6")

/obj/item/key/apartments/apartment1
	name = "apartment i key"
	lockids = list("apartment1")

/obj/item/key/apartments/apartment2
	name = "apartment ii key"
	lockids = list("apartment2")

/obj/item/key/apartments/apartment3
	name = "apartment iii key"
	lockids = list("apartment3")

/obj/item/key/apartments/apartment4
	name = "apartment iv key"
	lockids = list("apartment4")

/obj/item/key/apartments/apartment5
	name = "apartment v key"
	lockids = list("apartment5")

/obj/item/key/apartments/apartment6
	name = "apartment vi key"
	lockids = list("apartment6")

/obj/item/key/apartments/apartment7
	name = "apartment vii key"
	lockids = list("apartment7")

/obj/item/key/apartments/apartment8
	name = "apartment viii key"
	lockids = list("apartment8")

/obj/item/key/apartments/apartment9
	name = "apartment ix key"
	lockids = list("apartment9")

/obj/item/key/apartments/apartment10
	name = "apartment x key"
	lockids = list("apartment10")

/obj/item/key/apartments/apartment11
	name = "apartment xi key"
	lockids = list("apartment11")

/obj/item/key/apartments/apartment12
	name = "apartment xii key"
	lockids = list("apartment12")

/obj/item/key/apartments/apartment13
	name = "apartment xiii key"
	lockids = list("apartment13")

/obj/item/key/apartments/apartment14
	name = "apartment xiv key"
	lockids = list("apartment14")

/obj/item/key/apartments/apartment15
	name = "apartment xv key"
	lockids = list("apartment15")

/obj/item/key/apartments/apartment16
	name = "apartment xvi key"
	lockids = list("apartment16")

/obj/item/key/apartments/apartment17
	name = "apartment xvii key"
	lockids = list("apartment17")

/obj/item/key/apartments/apartment18
	name = "apartment xviii key"
	lockids = list("apartment18")

/obj/item/key/apartments/apartment19
	name = "apartment xix key"
	lockids = list("apartment19")

/obj/item/key/apartments/apartment20
	name = "apartment xx key"
	lockids = list("apartment20")

/obj/item/key/apartments/apartment21
	name = "apartment xxi key"
	lockids = list("apartment21")

/obj/item/key/apartments/apartment22
	name = "apartment xxii key"
	lockids = list("apartment22")

/obj/item/key/apartments/apartment23
	name = "apartment xxiii key"
	lockids = list("apartment23")

/obj/item/key/apartments/apartment24
	name = "apartment xxiv key"
	lockids = list("apartment24")

/obj/item/key/apartments/apartment25
	name = "apartment xxv key"
	lockids = list("apartment25")

/obj/item/key/apartments/penthouse1
	name = "penthouse i key"
	lockids = list("penthouse1")

/obj/item/key/apartments/penthouse2
	name = "penthouse ii key"
	lockids = list("penthouse2")

// SHOP KEYS

/obj/item/key/shops
	name = "REPORT TO MAPPERS"
	icon_state = "rustkey"

/obj/item/key/shops/shop1
	name = "shop I key"
	lockids = list("shop1")

/obj/item/key/shops/shop2
	name = "shop II key"
	lockids = list("shop2")

/obj/item/key/shops/shop3
	name = "shop III key"
	lockids = list("shop3")

/obj/item/key/shops/shop4
	name = "shop IV key"
	lockids = list("shop4")

/obj/item/key/shops/shop5
	name = "shop V key"
	lockids = list("shop5")

/obj/item/key/shops/shop6
	name = "shop VI key"
	lockids = list("shop6")

/obj/item/key/shops/shop7
	name = "shop VII key"
	lockids = list("shop7")

/obj/item/key/shops/shop8
	name = "shop VIII key"
	lockids = list("shop8")

/obj/item/key/shops/shop9
	name = "shop IX key"
	lockids = list("shop9")

// INN ROOMS

/obj/item/key/roomi
	name = "room I key"
	desc = "The key to the first room."
	icon_state = "brownkey"
	lockids = list("roomi")

/obj/item/key/roomii
	name = "room II key"
	desc = "The key to the second room."
	icon_state = "brownkey"
	lockids = list("roomii")

/obj/item/key/roomiii
	name = "room III key"
	desc = "The key to the third room."
	icon_state = "brownkey"
	lockids = list("roomiii")

/obj/item/key/roomiv
	name = "room IV key"
	desc = "The key to the fourth room."
	icon_state = "brownkey"
	lockids = list("roomiv")

/obj/item/key/roomv
	name = "room V key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockids = list("roomv")

/obj/item/key/roomvi
	name = "room VI key"
	desc = "The key to the sixth room."
	icon_state = "brownkey"
	lockids = list("roomvi")

/obj/item/key/medroomi
	name = "medium room I key"
	desc = "The key to the first medium room."
	icon_state = "brownkey"
	lockids = list("medroomi")

/obj/item/key/medroomii
	name = "medium room II key"
	desc = "The key to the second medium room."
	icon_state = "brownkey"
	lockids = list("medroomii")

/obj/item/key/medroomiii
	name = "medium room III key"
	desc = "The key to the third medium room."
	icon_state = "brownkey"
	lockids = list("medroomiii")

/obj/item/key/medroomiv
	name = "medium room IV key"
	desc = "The key to the fourth medium room."
	icon_state = "brownkey"
	lockids = list("medroomiv")

/obj/item/key/medroomv
	name = "medium room V key"
	desc = "The key to the fifth medium room."
	icon_state = "brownkey"
	lockids = list("medroomv")

/obj/item/key/medroomvi
	name = "medium room VI key"
	desc = "The key to the sixth medium room."
	icon_state = "brownkey"
	lockids = list("medroomvi")

/obj/item/key/luxroomi
	name = "luxury room I key"
	desc = "The key to the first luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomi")

/obj/item/key/luxroomii
	name = "luxury room II key"
	desc = "The key to the second luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomii")

/obj/item/key/luxroomiii
	name = "luxury room III key"
	desc = "The key to the third luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomiii")

/obj/item/key/luxroomiv
	name = "luxury room IV key"
	desc = "The key to the fourth luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomiv")

/obj/item/key/luxroomv
	name = "luxury room V key"
	desc = "The key to the fifth luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomv")

/obj/item/key/luxroomvi
	name = "luxury room VI key"
	desc = "The key to the sixth luxury room."
	icon_state = "brownkey"
	lockids = list("luxroomvi")

/obj/item/key/roomhunt
	name = "room HUNT key"
	desc = "The key to the most luxurious Inn room."
	icon_state = "brownkey"
	lockids = list("roomhunt")

/obj/item/key/thatchwood
	name = "ABSTRACT THATCHWOOD KEY CALL CODERS"
	desc = "Contact a dev on the discord, or make a bug report"
	icon_state = "brownkey"
	abstract_type = /obj/item/key/thatchwood

/obj/item/key/thatchwood/farm
	name = "old farmhouse key"
	desc = "A rusty key. Specs of dirt and soil cover its handle."
	lockids = list("oldfarm")

/obj/item/key/thatchwood/smithy
	name = "old smithy key"
	desc = "A rusty key."
	lockids = list("oldsmith")

/obj/item/key/thatchwood/inn1
	name = "room I key"
	desc = "A rusty key. The number I has been engraved on its handle."
	lockids = list("oldinn1")

/obj/item/key/thatchwood/inn2
	name = "room II key"
	desc = "A rusty key. The number II has been engraved on its handle."
	lockids = list("oldinn2")

/obj/item/key/thatchwood/inn3
	name = "side room key"
	desc = "A rusty key. Something was engraved on its handle, but you can't make it out anymore."
	lockids = list("oldinn3")

// Special Keys

// grenchensnacker
/obj/item/key/porta
	name = "strange key"
	desc = "Was this key enchanted by a locksmith...?"
	icon_state = "eyekey"
	lockids = list("porta")

/obj/item/key/vampire
	desc = "This key is awfully pink and weirdly shaped."
	icon_state = "vampkey"
	lockids = list("mansionvampire")

/obj/item/key/bandit
	icon_state = "mazekey"
	lockids = list("banditcamp")


////// MINOR NOBLES
/obj/item/key/mnoble1_blue
	name = "Key of the noble house 1"
	desc = "A very detailed steel key, has gold details and a purple gemstone on it... is for the noble house number one."
	icon_state = "noble1"
	lockids = list(ACCESS_NOBLE1)

/obj/item/key/mnoble2_yellow
	name = "Key of the noble house 2"
	desc = "A very detailed steel key, has gold details and a yellow gemstone on it... is for the noble house number two."
	icon_state = "noble2"
	lockids = list(ACCESS_NOBLE2)

/obj/item/key/mnoble3_red
	name = "Key of the noble house 3"
	desc = "A very detailed steel key, has gold details and a red gemstone on it... is for the noble house number three?"
	icon_state = "noble3"
	lockids = list(ACCESS_NOBLE3)
