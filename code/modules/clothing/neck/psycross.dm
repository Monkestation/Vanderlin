
/obj/item/clothing/neck/psycross
	name = "psycross"
	desc = "Let His name be naught but forgot'n."
	icon_state = "psycross_wood"
	//dropshrink = 0.75
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 10
	experimental_onhip = TRUE

// Hunt
/obj/item/clothing/neck/psycross/great_hunt
	name = "bone amulet"
	icon_state = "bone_amulet"
	desc = "An amulet made of parched bones and animal sinews, a common representation of faith used in Ossland."
	sellprice = 30

// INHUMEN PSYCROSSES

/obj/item/clothing/neck/psycross/zizo
	name = "Amulet of Zizo"
	desc = "Through power dominate, through domination rule, through Zizo become the divinity you were always meant to be."
	icon_state = "zcross"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 0
	experimental_onhip = TRUE

/* // GRONN PSYCROSSES
/obj/item/clothing/neck/psycross/gronn
	name = "carved talisman" //plotting talisman
	desc = "'The hunt, the studying of your prey, the learning of its routes, the knowledge our ancestors passed down, the empowerment of your people and yourself. Learn of the world, or fade away.'  </br>  </br>The Plotting Wolf embodies the virtues of progress and knowledge, so that no obstacle nor threat to the homeland remains insurmountable. To understand the truths of beast-and-bronze is to lighten the future's hardships. Do not humor magicka, however, for playing with fire shall always end in someone being burned."
	icon_state = "gronnzizo"

/obj/item/clothing/neck/psycross/gronn/baothagronn
	name = "carved talisman" //relishing talisma
	desc = "'“The excess of desire, the want of more, the glory of victory, the lover's embrace. Embrace the Leopard, or forget your strength.'  </br>  </br>The Relishing Leopard embodies the virtues of love and glory, both in battle and at home. Enjoy the flesh, the drink, and the spice; but be wary to avoid overindulgence, for it shall leave you despondant and lethargic. To become too comfortable is to become weak, and such weakness would turn you into a delicious snack for the Leopard."
	icon_state = "gronnbaotha"

/obj/item/clothing/neck/psycross/gronn/matthios
	name = "carved talisman" //starving talisman
	desc = "'“The hunger, the destruction, the impending frost, the enemy of my enemy. Feed the Bear, or be consumed.'  </br>  </br>The Starving Bear embodies not a virtue, but the necessity to thrive above all else. Avarice is not a sin, but a virtue; to ensure that the homeland never suffers from poverty nor starvation again. Pillage, plunder, and perforate the wealth that others would keep from you, but do not forget that every choice begets consequences."
	icon_state = "gronnmatthios"

/obj/item/clothing/neck/psycross/gronn/graggar
	name = "carved talisman" //grinning talisman
	desc = "'The battle, the combat, the violence, the rush of victory, the honored glories. Defeat the foe, or die with them.'  </br>  </br>The Grinning Moose embodies the virtues of strengh and domination; to survive both the homeland's frigid blizzards and those who'd seek to maraude its countrymen. Be untamed and unstoppable, but do not lose yourself in the haze; for even the Moose was chained, once. Kill your own without reason, and the chain shall be tugged; and your soul, too, shall be impaled on their horns."
	icon_state = "gronngraggar"

/obj/item/clothing/neck/psycross/gronn/dendor
	name = "carved talisman" //volfskinned talisman
	desc = "'The world above, of knifetoothed plants and rotting carrion. From jungle to desert, even the stones are nature. Heed its call with the respect it commands, or succumb to madness.'  </br>  </br>The Volfskinned Man embodies the virtue of nature and temperance; to live in harmony with the world and its spirits. Pluck a jackberry, plant a seed - Slay a beast, see no part wasted. Yet, temperance must be shown; to take from the world without respect-nor-exchange is to curse the homeland with misfortune. Yet, to completely embrace the world's primality is to lose your humanity - and worse, to become the very beast you hunt."
	icon_state = "gronndendor"

/obj/item/clothing/neck/psycross/gronn/abyssor
	name = "carved talisman" //hadal talisman
	desc = "'The chaos below, of coldblack pressure and crushing weight. Be the current. Control the waves. Reign your sails and hold fast against the storm, or be washed away onto an odyssey with no end.'  </br>  </br>The Spiraling Kraken is no virtue, but a presence; the homeland's nautical warden, who's tentacled presence is as unpredictable as the oceans it lords over. To embrace the uncertainty of lyfe is to be rewarded with fortune and mercy when it is most needed. Do not embrace such futility, however, lest you are swept away with all the others into the abyss."
	icon_state = "gronnabyssor"

/obj/item/clothing/neck/psycross/gronn/special
	name = "carved talisman" //familial talisman
	desc = "'The memories of the past, and the dreams of the future. A fetish of a beaste, and the carvings of a force that no one beyond your homeland could understand. Sail gracefully, countryman.'"
 */

// SILVER PSYCROSS START

/obj/item/clothing/neck/psycross/silver
	name = "silver psycross"
	desc = "Let His name be naught but forgot'n. Let the wicked undead burn at my touch."
	icon_state = "psycross_silver"
	resistance_flags = FIRE_PROOF
	sellprice = 50
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/neck/psycross/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

// PANTHEON SILVER PSYCROSSES START
/obj/item/clothing/neck/psycross/silver/divine
	name = "amulet of the ten"
	desc = "The Ten eternal, strength in unity. Stalwart for centuries against the darkness."
	icon_state = "undivided"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/divine/astrata
	name = "amulet of Astrata"
	desc = "Blessed be everything the light of the sun touches, for it is protected by Her grace."
	icon_state = "astrata"

/obj/item/clothing/neck/psycross/silver/divine/noc
	name = "amulet of Noc"
	desc = "Diligence, study, pursuit of truth and wisdom. Let nothing deter you from it."
	icon_state = "noc"

/obj/item/clothing/neck/psycross/silver/divine/dendor
	name = "amulet of Dendor"
	desc = "Nature is a body of which we are but its entrails."
	icon_state = "dendor"

/obj/item/clothing/neck/psycross/silver/divine/abyssor
	name = "amulet of Abyssor"
	desc = "Oceanshaper and guardian of the seas, make them remember his name."
	icon_state = "abyssor"

/obj/item/clothing/neck/psycross/silver/divine/necra
	name = "amulet of Necra"
	desc = "Where, grave, thy victory? I triumph still while the Veiled Lady abides by me."
	icon_state = "necra"

/obj/item/clothing/neck/psycross/silver/divine/ravox
	name = "amulet of Ravox"
	desc = "Struggle. Challenge. And rise to struggle again. That is the sword of he who yet lives to fight again."
	icon_state = "ravox"

/obj/item/clothing/neck/psycross/silver/divine/xylix
	name = "amulet of Xylix"
	desc = "Be not fooled, and be not afraid to."
	icon_state = "xylix"

/obj/item/clothing/neck/psycross/silver/divine/eora
	name = "amulet of Eora"
	desc = "And I love thee because thou art love."
	icon_state = "eora"

/obj/item/clothing/neck/psycross/silver/divine/eora/potion
	name = "Eora's love potion"
	desc = "Eora's blessing is upon thy, use me on someone else and you shall be soulbond."
	icon_state = "eora"

/obj/item/clothing/neck/psycross/silver/divine/eora/potion/attack(mob/living/love_target, mob/user, list/modifiers)
	if(!isliving(love_target) || love_target.stat == DEAD)
		to_chat(user, span_warning("The love potion only works on living things, sicko!"))
		return ..()
	if(user == love_target)
		to_chat(user, span_warning("You can't drink the love potion. What are you, a narcissist?"))
		return ..()
	if(love_target.has_status_effect(/datum/status_effect/in_love))
		to_chat(user, span_warning("[love_target] is already lovestruck!"))
		return ..()

	love_target.visible_message(span_danger("[user] starts to feed [love_target] a love potion!"),
		span_userdanger("[user] starts to feed you a love potion!"))

	if(!do_after(user, 5 SECONDS, love_target))
		return
	to_chat(user, span_notice("You feed [love_target] the love potion!"))
	to_chat(love_target, span_notice("You develop feelings for [user], and anyone [user.p_they()] like[user.p_s()]."))
	love_target.faction |= "[REF(user)]"
	love_target.apply_status_effect(/datum/status_effect/in_love, user)
	qdel(src)

/obj/item/clothing/neck/psycross/silver/divine/pestra
	name = "amulet of Pestra"
	desc = "When pure, alcohol is best used as a cleanser of wounds and a cleanser of the palate."
	icon_state = "pestra"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/divine/malum
	name = "amulet of Malum"
	desc = "Blessed be our works, made in His name."
	icon_state = "malum"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/divine/malum/steel
	name = "amulet of Malum"
	desc = "Let the tools that guide thee be thy hands."
	icon_state = "malum_alt"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/gold
	name = "golden psycross"
	desc = "Let His name be naught but forgot'n. Let devotion to Him endure, in heart and in deed, beyond the veil of sight."
	icon_state = "psycross_gold"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	smeltresult = /obj/item/ingot/gold
