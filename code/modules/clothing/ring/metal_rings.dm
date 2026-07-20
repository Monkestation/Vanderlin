/obj/item/clothing/ring/signet/psy
	name = "psydonian signet ring"
	icon_state = "psysignet"
	desc = "A ring of blessed silver, bearing the Archbishop's symbol. Its face is cut to seal writs of religious importance, a bead of tallow nested in the underside."
	sellprice = 90

/obj/item/clothing/ring/signet/psy/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/ring/signet/psy/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Stamping a folded ACCUSATION or CONFESSION will increase the amount of MARQUES it'll reward, once sent through the HERMES.")
	. += span_info("Packing an INDEXER into an ACCUSATION or CONFESSION before folding-and-stamping it will further amplify this financial bonus.")

/obj/item/clothing/ring/signet/psy/g
	name = "psydonian golden signet ring"
	icon_state = "psysignet_gold"
	desc = "A ring of opulent gold, embodying the unforgotten belief in Psydon's eternity. Its face is cut to seal writs of religious importance, a bead of tallow nested in the underside."

/obj/item/clothing/ring/duelist
	name = "duelist's ring"
	desc = "Born out of duelists desire for theatrics, this ring denotes a proposal — an honorable duel, with stakes set ahigh.\nIf both duelists wear this ring, successful baits will off balance them, and clashing disarms will never be unlikely.\n<i>'You shall know his name. You shall know his purpose. You shall die.'</i>"
	icon_state = "ring_duel"
	sellprice = 10

/obj/item/clothing/ring/emeraldbs
	name = "gemerald ring of blacksteel"
	icon_state = "bs_ring_emerald"
	desc = "A mythical blacksteel ring with a polished Gemerald set into it."
	sellprice = 295

/obj/item/clothing/ring/rubybs
	name = "rontz ring of blacksteel"
	icon_state = "bs_ring_ruby"
	desc = "A mythical blacksteel ring with a polished Rontz set into it."
	sellprice = 355

/obj/item/clothing/ring/topazbs
	name = "toper ring of blacksteel"
	icon_state = "bs_ring_topaz"
	desc = "A mythical blacksteel ring with a polished Toper set into it."
	sellprice = 380

/obj/item/clothing/ring/quartzbs
	name = "blortz ring of blacksteel"
	icon_state = "bs_ring_quartz"
	desc = "A mythical blacksteel ring with a polished Blortz set into it."
	sellprice = 345

/obj/item/clothing/ring/sapphirebs
	name = "saffira ring of blacksteel"
	icon_state = "bs_ring_sapphire"
	desc = "A mythical blacksteel ring with a polished Saffira set into it."
	sellprice = 300

/obj/item/clothing/ring/diamondbs
	name = "dorpel ring of blacksteel"
	icon_state = "bs_ring_diamond"
	desc = "A mythical blacksteel ring with a polished Dorpel set into it."
	sellprice = 370
