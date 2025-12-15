//////////////////////////
/// ALCOHOLIC BOTTLES ///	- add fancy var to retain custom descriptions when corking
//////////////////////////

// BEER - Cheap, Plentiful, Saviours of Family Life
/obj/item/reagent_containers/glass/bottle/beer
	name = "bottle of beer"
	desc = "A bottle that contains a generic housebrewed small-beer. It has an improvised cork-seal made of hardened clay."
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 70)
	fancy = TRUE
	auto_label = TRUE

/obj/item/reagent_containers/glass/bottle/beer/spottedhen
	desc = "A bottle with the spotted-hen cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/spottedhen = 70)
	auto_label_name = "spotted hen"
	auto_label_desc = "An extremely cheap lager hailing from a local brewery."

/obj/item/reagent_containers/glass/bottle/beer/blackgoat
	desc = "A bottle with the black goat kriek cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/blackgoat = 70)
	auto_label_name = "black goat"
	auto_label_desc = "A fruit-sour beer brewed with jacksberries for a tangy taste."

/obj/item/reagent_containers/glass/bottle/beer/ratkept
	desc = "A bottle with surprisingly no cork-seal. On the glass is carved the word \"ONI-N\", the 'O' seems to have been scratched out completely. Dubious."
	list_reagents = list(/datum/reagent/consumable/ethanol/onion = 70)
	auto_label_name = "\"ONI-N\""
	auto_label_desc = "The parchment depicts an illustration; rats guarding a cellar filled with bottles, against a hoard of beggars."

/obj/item/reagent_containers/glass/bottle/beer/hagwoodbitter
	desc = "A bottle with the hagwood bitters cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/hagwoodbitter = 70)
	auto_label_name = "hagwood bitters"
	auto_label_desc = "The least bitter thing to be exported from the Grenzelhoft occupied state of Zorn."

/obj/item/reagent_containers/glass/bottle/beer/aurorian
	desc = "A bottle with the aurorian brewhouse cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/aurorian = 70)
	auto_label_name = "the aurorian"
	auto_label_desc = "An Elvish beer brewed from an herbal gruit."

/obj/item/reagent_containers/glass/bottle/beer/fireleaf
	desc = "A bottle with a generic leaf cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/fireleaf= 70)
	auto_label_name = "fireleaf"
	auto_label_desc = "An Elvish beer formed by distilling cabbages."

/obj/item/reagent_containers/glass/bottle/beer/butterhairs
	desc = "A bottle with the Dwarven Federation Trade Alliance cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/butterhairs = 70)
	auto_label_name = "butter hairs"
	auto_label_desc = "This beer is widely considered one of the greatest exported by the Dwarves."

/obj/item/reagent_containers/glass/bottle/beer/stonebeardreserve
	desc = "A bottle with the House Stoutenson cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/stonebeards = 70)
	auto_label_name = "stonebeard's reserve"
	auto_label_desc = "Stonebeards Reserve is one of the most legendary beers in existence, with only a few hundred barrels made every year."

/obj/item/reagent_containers/glass/bottle/beer/voddena
	desc = "A bottle with the House Stoutenson cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/voddena = 45)
	auto_label_name = "voddena"
	auto_label_desc = "This strange liquid is considered as the most spicy and alcoholic drink in all the Mountainhomes. Bought by nobles of all ages, mostly those with a deathwish."

// WINES - Expensive, Nobleblooded
/obj/item/reagent_containers/glass/bottle/wine
	name = "bottle of wine"
	desc = "A bottle that contains a generic red-wine, likely from Zaladin. It has a red-clay cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 70)
	fancy = TRUE
	auto_label = TRUE

/obj/item/reagent_containers/glass/bottle/wine/sourwine
	desc = "A bottle with a black ink cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/sourwine = 70)
	auto_label_name = "black eagle sour"
	auto_label_desc = "A Grenzelhoft classic, extremely sour wine that is watered down with mineral water."

/obj/item/reagent_containers/glass/bottle/redwine
	desc = "A bottle with the Valorian Merchant Guild cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 70)
	auto_label_name = "young valorian red"
	auto_label_desc = "This one appears to be labelled as a relatively young red-wine from the coinlord state."

/obj/item/reagent_containers/glass/bottle/whitewine
	desc = "A bottle with the Valorian Merchant Guild cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/whitewine = 70)
	auto_label_name = "sweet valorian white"
	auto_label_desc = "This one appears to be labelled as a sweet wine from the colder northern regions."

/obj/item/reagent_containers/glass/bottle/elfred
	desc = "A bottle gilded with a silver cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/elfred = 70)
	auto_label_name = "valorian red"
	auto_label_desc = "An Elvish red wine from Valoria. Likely worth more than what an entire village makes!"

/obj/item/reagent_containers/glass/bottle/elfblue
	desc = "A bottle gilded with a golden cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/elfblue = 70)
	auto_label_name = "valmora blue"
	auto_label_desc = "This is the legendary Valmora Blue from the Vineyard of Valmora, headed by a sainted Dark-Elf swordsmaster. This bottle would swoon Gods over!"

/obj/item/reagent_containers/glass/bottle/tiefling_wine
	list_reagents = list(/datum/reagent/consumable/ethanol/tiefling/aged = 45)
	auto_label_name = "tiefling-blood wine"
	auto_label_desc = "This plain looking wine is a noble delicacy. It glows faintly in the darkness and has a strong taste and a fiery kick, not for the faint of heart."

/obj/item/reagent_containers/glass/bottle/jagdtrunk
	desc = "A bottle with a Saigabuck cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/jagdtrunk = 48)
	auto_label_name = "jagdtrunk"
	auto_label_desc = "This dark liquid is the strongest alcohol coming out of Grenzelhoft available. A herbal schnapps, sure to burn out any disease."

/obj/item/reagent_containers/glass/bottle/apfelweinheim
	desc = "A bottle with an Apfelweinheim cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/apfelweinheim = 48)
	auto_label_name = "apfelweinheim crush cider"
	auto_label_desc = "A cider from the Grenzelhoftian town of Apfelweinheim. Well received for its addition of pear, alongside crisp apples."

/obj/item/reagent_containers/glass/bottle/rtoper
	desc = "A bottle with the Lirvas-crest cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/rtoper = 48)
	auto_label_name = "larvas cider"
	auto_label_desc = "An especially tart cider from the petty kingdom of Lirvas. Rumor has it the brewers let the barrels age in the bog, which results in that especially strong flavour."

/obj/item/reagent_containers/glass/bottle/nred
	desc = "A bottle with the City of Norwandine cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/nred = 48)
	auto_label_name = "molten gold"
	auto_label_desc = "A red ale brewed to perfection in the lands of Hammerhold."

/obj/item/reagent_containers/glass/bottle/gronnmead
	desc = "A bottle with a Shieldmaiden Brewery cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/gronnmead = 48)
	auto_label_name = "gronn mead"
	auto_label_desc = "A deep red honey-wine, refined with the red berries native to Gronns highlands."

/obj/item/reagent_containers/glass/bottle/avarmead
	desc = "A bottle with a simple cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/avarmead = 48)
	auto_label_name = "steppe mead"
	auto_label_desc = "A golden honey-wine brewed in the steppes. Manages to keep a proper taste while staying strong."

/obj/item/reagent_containers/glass/bottle/avarrice
	desc = "A bottle with a simple cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/avarrice = 48)
	auto_label_name = "steppe rice"
	auto_label_desc = "A murky, white wine made from rice grown in the steppes."

/obj/item/reagent_containers/glass/bottle/saigamilk
	desc = "A bottle with a Running Saiga cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/saigamilk = 48)
	auto_label_name = "saiga kumis"
	auto_label_desc = "A form of alcohol brewed from the milk of a saiga and salt. Common drink of the nomads living in the steppe."

/obj/item/reagent_containers/glass/bottle/kgunlager
	desc = "A bottle with a Yamaguchi Brewery cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunlager = 48)
	auto_label_name = "kazengun lager"
	auto_label_desc = "A pale lager brewed in the far-away lands of Kazengun, refined with green tea for an unique flavour-profile. Even lighter than elven-brew!"

/obj/item/reagent_containers/glass/bottle/kgunsake
	desc = "A bottle with a Golden Swan cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunsake = 48)
	auto_label_name = "kazengun sake"
	auto_label_desc = "A translucent, pale-blue liquid made from rice. A favourite drink of the warlords and nobles of Kazengun."

/obj/item/reagent_containers/glass/bottle/kgunplum
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunplum = 48)
	desc = "A bottle with a Golden Swan cork-seal."
	auto_label_name = "kazengun fruit brandy"
	auto_label_desc = "A reddish-golden alcohol made from a fruit commonly found on the Kazengun-isles. A favourite of the commoners."

/obj/item/reagent_containers/glass/bottle/kgunshochu
	desc = "A bottle with a Golden Swan cork-seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunshochu = 48)
	auto_label_name = "kazengun shochu"
	auto_label_desc = "A clean alcohol made by distilling rice. With a dry and clean finish. Popular amongst the warrior caste of Kazengun."

// Zhongese Drinks
/obj/item/reagent_containers/glass/bottle/black/huangjiu
	desc = "A bottle with a red seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/huangjiu = 48)
	auto_label_name = "huangjiu"
	auto_label_desc = "A strong, sweet yellow rice wine that is often used in cooking."

/obj/item/reagent_containers/glass/bottle/black/baijiu
	desc = "A bottle with a red seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/baijiu = 48)
	auto_label_name = "baijiu"
	auto_label_desc = "A strong, clear liquor made from fermented sorghum or rice. The favored drink of wandering warriors."

/obj/item/reagent_containers/glass/bottle/black/yaojiu
	desc = "A bottle with a red seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/yaojiu = 48)
	auto_label_name = "yaojiu"
	auto_label_desc = "A strong, sweet rice wine infused with medicinal herbs, including Ginseng. Often prescribed as a medicine on the Zhongese mainland."

/obj/item/reagent_containers/glass/bottle/black/shejiu
	desc = "A bottle with a red seal."
	list_reagents = list(/datum/reagent/consumable/ethanol/shejiu = 48)
	auto_label_name = "shejiu"
	auto_label_desc = "A strong rice wine with a dead snake inside. In the land of Zhong, It is believed that drinking this will improve one's virility and blood circulation."

/obj/item/reagent_containers/glass/bottle/black/murkwine
	desc = "A bottle with a Possumtail Brewery mark."
	list_reagents = list(/datum/reagent/consumable/ethanol/murkwine = 48)
	auto_label_name = "murk wine"
	auto_label_desc = "A special brew made from murky water and swampweed. A Heartfelt special, and a rare find now."

/obj/item/reagent_containers/glass/bottle/black/nocshine
	desc = "A bottle with a blue, Crescent moon mark."
	list_reagents = list(/datum/reagent/consumable/ethanol/nocshine = 48)
	auto_label_name = "noc shine"
	auto_label_desc = "A special brew that is extremely potent and toxic, but strengthen the body. If you dare."

/obj/item/reagent_containers/glass/bottle/black/whipwine
	desc = "A strange bottle with a concerningly brown color."
	list_reagents = list(/datum/reagent/consumable/ethanol/whipwine = 48)
	auto_label_name = "whip wine"
	auto_label_desc = "It bears the seal of a snake's head over a leaf. Markings indicate the contents are supposed to be good for health..."

/obj/item/reagent_containers/glass/bottle/black/komuchisake
	desc = "A dusty, ancient bottle with a red-ochre coloring."
	list_reagents = list(/datum/reagent/consumable/ethanol/komuchisake = 48)
	auto_label_name = "komuchisake"
	auto_label_desc = "It bears an intricately detailed golden skull seal, and the markings on it are clearly of the Shogunate. It looks to be filled with herbs inside."
