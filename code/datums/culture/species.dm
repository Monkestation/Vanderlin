/datum/culture/species/subterra
	name = "Subterra"
	description = "Known by humens to be hardened by the harsh environment of the world below. \
	To the average humen, a Subterran could refer to anywhere from citizens of the nearest outpost of Zizo, \
	to a deep culture of hermits, or even a group of dwarves who dug too deep. Regardless, none are to be trusted."
	species = list(
		SPEC_ID_DROW,
		SPEC_ID_HALF_DROW,
		SPEC_ID_DWARF,
		SPEC_ID_KOBOLD,
	)

/datum/culture/species/elven
	abstract_type = /datum/culture/species/elven
	species = list(
		SPEC_ID_ELF,
		SPEC_ID_HALF_ELF,
	)

/datum/culture/species/elven/costal
	name = "Coastal Tribes"
	description = "Known by humens to be haughty, wealthy, disconnected pricks. \
	Much of the culture has since been absorbed by Wintermare. Never ask their opinions on any of the Sea Tribes."
	pre_append = "the "

/datum/culture/species/elven/sea
	name = "Sea Tribes"
	description = "Known by humens to be cruel, relentless slavers. \
	They say the basalt sands of their home island are stained with blood. Never ask their opinions on any of the Coastal Tribes."
	pre_append = "the "

/datum/culture/species/elven/desert
	name = "Desert Tribes"
	description = "Known by humens to be rebellious and unruly. Assumed to be involved with the Xylixian freemen of Zaladin."
	pre_append = "the "

/datum/culture/species/elven/crimson
	name = "Crimson Tribes"
	description = "Known by humens to be naive and weak. How they manage to survive the harsh steppe with roaming orc bands is anyone's guess."
	pre_append = "the "

/datum/culture/species/elven/obsidian
	name = "Obsidian Tribes"
	description = "Known by humens to be miserably devout Necrans. \
	They worship their holy tree, \"The Waiting Wood,\" praying to its skulls for but a chance to speak to The Veiled Lady herself."
	species = list(
		SPEC_ID_ELF,
		SPEC_ID_AASIMAR,
	)
	pre_append = "the "

/datum/culture/species/halfling
	name = "Hearthhill"
	description = "Known by humens to be mostly coin-counting-challenged halflings. \
	They are proud of homely crafts, and often prefer bartering over coin. Violence is a foreign concept to most."
	species = list(
		SPEC_ID_HALFLING
	)

/datum/culture/species/half_orc
	abstract_type = /datum/culture/species/half_orc
	species = list(
		SPEC_ID_HALF_ORC,
	)

// /datum/culture/species/half_orc/shellcrest
// 	name = "Shellcrest"

// /datum/culture/species/half_orc/blood_axe
// 	name = "Blood Axe"

// /datum/culture/species/half_orc/splitjaw
// 	name = "Splitjaw"

// /datum/culture/species/half_orc/blackhammer
// 	name = "Blackhammer"

// /datum/culture/species/half_orc/skullseeker
// 	name = "Skullseeker"

// /datum/culture/species/half_orc/crescent_fang
// 	name = "Crescent Fang"

// /datum/culture/species/half_orc/murkwater
// 	name = "Murkwater"

// /datum/culture/species/half_orc/shatterhorn
// 	name = "Shatterhorn"

// /datum/culture/species/half_orc/spiritcrusher
// 	name = "Spiritcrusher"

/datum/culture/species/rakshari
	abstract_type = /datum/culture/species/rakshari
	species = list(
		SPEC_ID_RAKSHARI,
	)
	pre_append = "the "

/datum/culture/species/rakshari/city
	name = "City Tribes"
	description = "Known by humens to be greedy, and descended from desert or oasis rakshari, for the most part, who decided to pause their nomadic lifestyle and settle down in a city. They're as much of a melting pot as Zaladin itself is. City rakshari can be found in any social level of Zaladin, from merchant-kings who gained their wealth through trading, to the average commoner, to a slave. Many cities have districts full of rakshari as they naturally tend to gather together. Of course living in cities often comes with the temptation of thievery, and more criminals are found among this subculture. "

/datum/culture/species/rakshari/desert
	name = "Desert Tribes"
	description = "What humens think of as the 'baseline' rakshari. Desert rakshari are the most numerous, traveling from city to city through the sand. There's no singular tribe of desert rakshari, instead this is a grouping of multiple tribes of the same subculture. Customs can vary throughout individual tribes, due to their numbers."

/datum/culture/species/rakshari/deep_desert
	name = "Deep Desert Tribes"
	description = "Barely known to humens as desert-maddened heretics. Deep desert tribes are isolated by choice, distrustful, or too arrogant to mingle with other species. Each tribe leans into a sort of folk mysticism. Handmade charms for luck or to ward off evil are common, tied onto rakshari clothing or beasts of burden. Some tribes take the rakshari not being chosen by any of the Ten to heart, and make their own religion, elaborate and secretive. Outsiders rarely see any of these tribesmen, and those that leave the isolation of the deep desert often have strong reasons to do so."

/datum/culture/species/rakshari/mountain
	name = "Mountain Tribes"
	description = "Known to humens as surprisingly welcoming to trade. These are the furthest tribes from the desert's centre, living in mountain caverns for generations. They have more fur than most rakshari, resembling the lykoi breed of cat. Heavier clothing is common here, swapping the flowy, covering desert robes for thicker fabric, often woven from the fur of the gotes that roam the mountain. These rakshari are isolated by happenstance, not by choice, and welcome traders who make the long journey to the mountains. They have a strong culture of passing down history and folk tales, and uncanny balance on the mountainside, with stronger, thicker claws for keeping their footing."

/datum/culture/species/rakshari/oasis
	name = "Oasis Tribes"
	description = "Known to humens to be rich and as status-focused as Wintermarians. These tribes settled down in places rich in natural resources, and as the settlements of Zaladin grew around the water, the oasis rakshari grew rich controlling access. In modern days, access to resources is controlled by the Merchant-King of the region, but many rakshari are among the upper classes, old money. Many others are throughout the other social classes. In any major Zaladin city, you will find mostly city and oasis rakshari. The distinction is whether the individual's family arrived first or joined the city after."

/datum/culture/species/rakshari/oasis_shade
	name = "Oasis Shade Tribes"
	description = "Known to humens as even more rich and elitist than oasis rakshari. These are the elite among the oasis rakshari. They trace their lineages with pride, and are those most likely to know the history of the rakshari, at least among their local tribes. Some opt to tattoo their history on their skin in an ink that stands out, depending on the skin tone of the individual. They value status highly. These are the rakshari most likely to turn up their nose at unfavourable courtships and deals."

/datum/culture/species/rakshari/quicksand
	name = "Quicksand Tribes"
	description = "Known to humens to be stern and quick to aggression. Quicksand rakshari are near the jungle at the edge of Zaladin. As inhospitable as the desert is, the jungle is just as dangerous, and these rakshari train all of their people in defending against it, as well as against any foreign soldiers, mostly from Grenzelhoft, who manage to navigate the jungle intact. They have a stronger warrior culture than the other rakshari tribes, valuing strength and discipline. They may be standoffish to foreigners, but a bit friendlier to Zaladin citizens. In either case, they come off as harsh at first."

/datum/culture/species/kobold
	abstract_type = /datum/culture/species/kobold
	species = list(
		SPEC_ID_KOBOLD
	)
	pre_append = "the "

/datum/culture/species/kobold/emberhide
	name = "Emberhide tribes"
	description = "Known by humens to be mainly found in Kruskros, serving the Great-Wyrm. Among kobold races, they're one of those more prone to burrowing, making the less-civilised ones among them a bit of a nuisance when they migrate out of their mountain home."

/datum/culture/species/kobold/moonshade
	name = "Moonshade tribes"
	description = "Known by humens to originate in the Isle of Enigma, they were often underfoot in Heartfelt and Rockhill before the fall, digging around the great chasm that held Heartfelt's main automaton controller, and living in the massive brass cooling pipes of the machine. Many of them were caught in the fall of Heartfelt, and most of the survivors fled out of the island."

/datum/culture/species/kobold/sandswept
	name = "Sandswept tribes"
	description = "Known to humens as pests in Kingsfield, with many of them aiming to eat the fossilized tree in the grand church, much to the displeasure of the local aasimar. The tree is what's given these kobolds their pale colour."

/datum/culture/species/kobold/stonepaw
	name = "Stonepaw tribes"
	description = "Known to humens and dwarves as proficient burrowers from the mountains of the Dwarven Federations, and tend to be hard workers, getting along well with the dwarves, though it varies between groups of kobolds. They mine and burrow as fast as the dwarves, and this habit often carries over even when they leave the mountains. Some migrated to Grenzelhoft with the dwarven population there and promptly became a pest eating the stone foundations of cellars."

/datum/culture/species/kobold/sunstreak
	name = "Sunstreak tribes"
	description = "Known to humens to be rare and surprisingly skilled, these kobolds evolved in volcanoes, adjusting to the heat and turning the same orange as the lava for camouflage. They are crafters, specialising in glass-blowing, one of the few crafts they beat the taller races at. The leader of any given Sunstreak tribe is the kobold who can make the largest unbroken glass globe. They lose their position if it breaks - or if a jealous rival smashes it."

/datum/culture/species/kobold/icepack
	name = "Icepack tribes"
	description = "Known to humens as sneaky little bastards, these kobolds evolved in Subterra, learning to be quick and harsher among the difficult wildlife. The Zizo-led drow often use them as miners, when they manage to actually catch the lizards. They're a bit more eccentric and suspicious of strangers compared to the other kobold races, owing to the vigilance demanded of their home."

/datum/culture/species/medicator
	name = "Swamps of Enigma"
	description = "Known to humens to be from the polluted swamps of the Isle of Enigma, particularly around Rockhill, where the land's pollution gave birth to the medicator species.\
	At least, before they developed sapience."
	species = list(
		SPEC_ID_MEDICATOR
	)
	pre_append = "the "

/datum/culture/species/triton
	abstract_type = /datum/culture/species/triton
	species = list(
		SPEC_ID_TRITON
	)
	pre_append = "the "

/datum/culture/species/triton/reef
	name = "Reef colonies"
	description = "Known to humens to be fond of bright colours, these triton often collect shells and other trinkets to adorn themselves and impress their allies. They perform the most ritualistic traditions of the known triton cultures."

/datum/culture/species/triton/depths
	name = "Deepwater colonies"
	description = "Barely known to humens, these triton tend to be solitary hunters. Those who come to the surface are often paranoid, with light-sensitive eyes. This caution makes them excellent guards."

/datum/culture/species/triton/abyssal
	name = "Abyssal colonies"
	description = "Nearly entirely unknown to humens. Those deepest in the darkest depths hear Abyssor's demands for worship, and another voice whispering beneath."

/datum/culture/species/triton/shallows
	name = "Shallow colonies"
	description = "Known to humens as the most sociable of triton cultures, they tend to be much more open to trade, and often join ships on their journeys across the seas, saving the lives of many a sailor fallen overboard."

/datum/culture/species/tiefling
	abstract_type = /datum/culture/species/tiefling
	species = list(
		SPEC_ID_TIEFLING
	)

//put some tiefling stuff here bug

/datum/culture/species/aasimar
	abstract_type = /datum/culture/species/aasimar
	species = list(
		SPEC_ID_AASIMAR
	)

/datum/culture/species/aasimar/celestial
	name = "Celestial origin"
	description = "Known to humens to have appeared one dae, cast down from the heavens by the Ten. These aasimar are the most melancholy, often trying to redeem themselves in the eyes of their creator."

/datum/culture/species/aasimar/grounded
	name = "Grounded origin"
	description = "Known to humens to be the most level-headed of aasimar, these were placed on Psydonia to serve a purpose there, and may vary in whether they have accomplished it at all, or been discarded."

/datum/culture/species/aasimar/seer
	name = "Great Tree"
	description = "Known by humens to originate from Kingsfield, falling from the crystal leaf buds of the great petrified tree. These aasimar have no memory of what they were doing within the tree, waking within craters from their fall."
	pre_append = "the "

/datum/culture/species/dwarf
	abstract_type = /datum/culture/species/dwarf
	species = list(
		SPEC_ID_DWARF
	)
	pre_append = "the "

/datum/culture/species/dwarf/federation
	name = "Dwarven Federation"
	description = "Known to humens to be from the great dwarven clans that span the entire continent of Faience."

/datum/culture/species/dwarf/brass
	name = "Brass clan"
	description = "Known to humens to be clever inventors, these dwarves are mostly seen around the Isle of Enigma, Vanderlin, and the newly-discovered Hearthhill."

/datum/culture/species/dwarf/iron
	name = "Iron clan"
	description = "Known to humens to be capable of incredibly skilled blacksmithing, these dwarves are mostly in the mountains of the Federation, but often travel to sell their wares and prove their skill."

/datum/culture/species/dwarf/blackpowder
	name = "Blackpowder clan"
	description = "Known to humens as inventors of the modern firearm and explosive. They have strong ties with Grenzelhoft, especially after the rise of Zizo's hordes."

/datum/culture/species/dwarf/malachite
	name = "Malachite clan"
	description = "Known to humens as the premier jewelers of Psydonia, these dwarves are both the primary source of dwarven wedding gems, and the makers of crowns and royal rings."

/datum/culture/species/dwarf/cerargyrite
	name = "Cerargyrite clan"
	description = "Known to humens for their unmatched skill in enchanting, these dwarves are among the most common to see outside the Federation."

/datum/culture/species/dwarf/aurum
	name = "Aurum clan"
	description = "Known to humens for their faith in Malum and their endless toil in brewing alcohol. Prone to bar fights. Their beers are the best in the land."

/datum/culture/species/dwarf/platinum
	name = "Platinum clan"
	description = "Known to humens for their peerless talent as clothiers. Many monarchs strive to adorn themselves in the textiles of the Platinum dwarves."

//dark elf here
