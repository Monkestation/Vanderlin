/datum/stress_event/viewsinpunish
	timer = 5 MINUTES
	stress_change = -2
	desc = span_green("I saw a sinner get punished!")

/datum/stress_event/miasmagasmaniac
	timer = 10 SECONDS
	stress_change = -1
	desc = span_green("It smells like death in here.")

/datum/stress_event/viewdeathmaniac
	timer = 30 SECONDS
	stress_change = -1
	desc = span_green("Death. Hehe...")

/datum/stress_event/viewdismembermaniac
	timer = 2 MINUTES
	stress_change = -1
	desc = span_green("I saw limbs fly. Hehe...")

/datum/stress_event/viewgibmaniac
	timer = 2 MINUTES
	stress_change = -2
	desc = span_green("That was amazing! Can someone do it again? I wanna see it again.")

/datum/stress_event/viewexecution
	timer = 5 MINUTES
	stress_change = -3 // to counteract the +1 from watching death
	desc = span_green("Nice civilized entertainment.")

/datum/stress_event/psyprayer
	timer = 30 MINUTES
	stress_change = -2
	desc = span_green("The Gods smiles upon me.")

/datum/stress_event/lovezizo
	timer = 99999 MINUTES
	stress_change = -666 // :)
	desc = span_green("ZIZOZIZOZIZO")

/datum/stress_event/joke
	timer = 1 MINUTES
	stress_change = -2
	desc = span_green("I heard a good joke.")

/datum/stress_event/tragedy
	timer = 1 MINUTES
	stress_change = -2
	desc = span_green("Life isn't so bad after all.")

/datum/stress_event/blessed
	timer = 60 MINUTES
	stress_change = -5
	desc = span_green("I feel soothed.")

/datum/stress_event/blessed/permanent
	timer = INFINITY
	stress_change = -5
	desc = span_green("I feel soothed.")

/datum/stress_event/triumph
	timer = 60 MINUTES
	stress_change = -10
	desc = span_green("I remember a TRIUMPH.")

/datum/stress_event/drunk
	timer = 999 MINUTES
	stress_change = -1
	desc = list(span_green("Alcohol eases the pain."),span_green("Alcohol, my true friend."))

/datum/stress_event/pweed
	timer = 1 MINUTES
	stress_change = -1
	desc = list(span_green("A relaxing smoke."),span_green("A flavorful smoke."))

/datum/stress_event/weed
	timer = 999 MINUTES
	stress_change = -4
	desc = span_blue("I love you sweet leaf.")

/datum/stress_event/high
	timer = 999 MINUTES
	stress_change = -4
	desc = span_blue("I'm so high, don't take away my sky.")

/datum/stress_event/hug
	timer = 30 MINUTES
	stress_change = -1
	desc = span_green("Somebody gave me a nice hug.")

/datum/stress_event/stuffed
	timer = 20 MINUTES
	stress_change = -3
	desc = span_green("I'm stuffed! Feels good.")

/datum/stress_event/goodfood
	timer = 10 MINUTES
	stress_change = -2
	desc = list(span_green("A meal fit for a god!"),span_green("Delicious!"))

/datum/stress_event/prebel
	timer = 5 MINUTES
	stress_change = -5
	desc = span_green("Down with the tyranny!")


//Hygiene

/datum/stress_event/clean
	timer = 20 MINUTES
	stress_change = -1
	desc = span_green("I cleaned myself recently.")

/datum/stress_event/clean_plus
	timer = 30 MINUTES
	stress_change = -1
	desc = span_green("That was an amazing bath.")

/datum/stress_event/filth_lover
	timer = 10 MINUTES
	stress_change = -1
	desc = span_green("I smell horrid.")

//Music
/datum/stress_event/music
	timer = 30 SECONDS
	stress_change = 0 // you suck at music
	desc = span_green("This music is pleasant.")

/datum/stress_event/music/two
	stress_change = -1
	desc = span_green("This music is relaxing.")

/datum/stress_event/music/three
	stress_change = -1
	desc = span_green("This music is wonderful.")

/datum/stress_event/music/four
	stress_change = -2
	desc = span_green("This music is exceptional.")

/datum/stress_event/music/five
	stress_change = -2
	desc = span_green("This music is enchanting.")

/datum/stress_event/music/six
	stress_change = -3
	desc = span_green("This music is divine.")

/datum/stress_event/beautiful
	timer = 2 MINUTES
	stress_change = -2
	desc = span_green("Their face is a work of art!")

/datum/stress_event/self_fishface
	timer = 2 MINUTES
	stress_change = -1
	desc = span_green("I don't know what others are on about, I look perfectly fine if I do say so myself.")

/datum/stress_event/fellow_fishface
	timer = 2 MINUTES
	stress_change = -2
	desc = span_green("A fellow Triton, looking good!")

/datum/stress_event/eora
	stress_change = -4
	timer = INFINITY
	desc = span_boldgreen("Eora brings me peace.")

// Bard buffs below

/datum/stress_event/bardicbuff
	timer = 30 SECONDS
	desc = span_nicegreen("Bardic inspiration moves mine soul even more!")
	stress_change = -1

/datum/stress_event/vblood
	stress_change = -5
	desc = span_bold("Virgin blood!")
	timer = 5 MINUTES

/datum/stress_event/bathwater
	stress_change = -1
	desc = span_blue("Relaxing.")
	timer = 15 SECONDS

/datum/stress_event/bathwater/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_BATHS_TAKEN)
		SEND_SIGNAL(user, COMSIG_BATH_TAKEN)

/datum/stress_event/ozium
	stress_change = -99
	desc = span_blue("I've taken a hit and entered a painless world.")
	timer = 999 MINUTES

/datum/stress_event/moondust
	stress_change = -5
	desc = span_green("Moondust surges through me.")
	timer = 2 MINUTES

/datum/stress_event/moondust_purest
	stress_change = -6
	desc = span_green("PUREST moondust surges through me!")

/datum/stress_event/calm
	stress_change = -3
	desc = span_green("I feel soothed and calm.")

/datum/stress_event/perfume
	stress_change = -1
	desc = span_green("A soothing fragrance envelops me.")
	timer = 10 MINUTES

/datum/stress_event/odor_lover
	stress_change = -1
	desc = span_green("This pungent odor is wonderful!")
	timer = 10 MINUTES

/datum/stress_event/divine_beauty
	stress_change = -2
	desc = span_green("I feel touched by a divine beauty.")
	timer = 5 MINUTES

/datum/stress_event/apprentice_making_me_proud
	stress_change = -3
	desc = span_green("My apprentice is improving, all thanks to me!")
	timer = 5 MINUTES

/datum/stress_event/saw_old_party
	stress_change = -2
	desc = span_green("It's always good to see an old friend's face.")
	timer = 2 MINUTES

/datum/stress_event/astrata_grandeur
	stress_change = -2
	desc = span_green("Astrata's light shines brightly through me. I must not let others ever forget that.")
	timer = 30 MINUTES

/datum/stress_event/graggar_culling_finished
	stress_change = -2
	desc = span_green("I have prevailed over my rival! Graggar favours me now!")
	timer = INFINITY

/datum/stress_event/abyssor_serenity
	stress_change = -1
	desc = span_blue("Abyssor is calm, and so am I.")
	timer = INFINITY

/datum/stress_event/night_owl_night
	stress_change = -1
	desc = span_green("I love the night!")
	timer = 20 MINUTES

/datum/stress_event/hug
	desc = "<span class='nicegreen'>Hugs are nice.</span>\n"
	stress_change = -1
	timer = 2 MINUTES

/datum/stress_event/betterhug
	desc = "<span class='nicegreen'>Someone was very nice to me.</span>\n"
	stress_change = -3
	timer = 4 MINUTES

/datum/stress_event/besthug
	desc = "<span class='nicegreen'>Someone is great to be around, they make me feel so happy!</span>\n"
	stress_change = -5
	timer = 4 MINUTES

/datum/stress_event/arcade
	desc = "<span class='nicegreen'>I beat the arcade game!</span>\n"
	stress_change = -3
	timer = 8 MINUTES

/datum/stress_event/blessing
	desc = "<span class='nicegreen'>I've been blessed.</span>\n"
	stress_change = -3
	timer = 8 MINUTES

/datum/stress_event/book_nerd
	desc = "<span class='nicegreen'>I have recently read a book.</span>\n"
	stress_change = -1
	timer = 5 MINUTES

/datum/stress_event/exercise
	desc = "<span class='nicegreen'>Working out releases those endorphins!</span>\n"
	stress_change = -2
	timer = 5 MINUTES

/datum/stress_event/pet_animal
	desc = "<span class='nicegreen'>Animals are adorable! I can't stop petting them!</span>\n"
	stress_change = -2
	timer = 5 MINUTES

/datum/stress_event/perform_cpr
	desc = "<span class='nicegreen'>It feels good to save a life.</span>\n"
	stress_change = -6
	timer = 8 MINUTES

/datum/stress_event/oblivious
	desc = "<span class='nicegreen'>What a lovely day.</span>\n"
	stress_change = -3

/datum/stress_event/jolly
	desc = "<span class='nicegreen'>I feel happy for no particular reason.</span>\n"
	stress_change = -6
	timer = 2 MINUTES

/datum/stress_event/focused
	desc = "<span class='nicegreen'>I have a goal, and I will reach it, whatever it takes!</span>\n" //Used for syndies, nukeops etc so they can focus on their goals
	stress_change = -4
	hidden = TRUE

/datum/stress_event/creeping
	desc = "<span class='greentext'>The voices have released their hooks on my mind! I feel free again!</span>\n" //creeps get it when they are around their obsession
	stress_change = -18
	timer = 3 SECONDS
	hidden = TRUE

/datum/stress_event/revolution
	desc = "<span class='nicegreen'>VIVA LA REVOLUTION!</span>\n"
	stress_change = -3
	hidden = TRUE

/datum/stress_event/cult
	desc = "<span class='nicegreen'>I have seen the truth, praise the almighty one!</span>\n"
	stress_change = -10 //maybe being a cultist isnt that bad after all
	hidden = TRUE

/datum/stress_event/family_heirloom
	desc = "<span class='nicegreen'>My family heirloom is safe with me.</span>\n"
	stress_change = -1

/datum/stress_event/goodmusic
	desc = "<span class='nicegreen'>There is something soothing about this music.</span>\n"
	stress_change = -3
	timer = 60 SECONDS

/datum/stress_event/chemical_euphoria
	desc = "<span class='nicegreen'>Heh...hehehe...hehe...</span>\n"
	stress_change = -4

/datum/stress_event/chemical_laughter
	desc = "<span class='nicegreen'>Laughter really is the best medicine! Or is it?</span>\n"
	stress_change = -4
	timer = 3 MINUTES

/datum/stress_event/chemical_superlaughter
	desc = "<span class='nicegreen'>*WHEEZE*</span>\n"
	stress_change = -12
	timer = 3 MINUTES

/datum/stress_event/religiously_comforted
	desc = "<span class='nicegreen'>I am comforted by the presence of a holy person.</span>\n"
	stress_change = -3
	timer = 5 MINUTES

/datum/stress_event/sacrifice_good
	desc ="<span class='nicegreen'>The gods are pleased with this offering!</span>\n"
	stress_change = -5
	timer = 3 MINUTES

/datum/stress_event/artok
	desc = "<span class='nicegreen'>It's nice to see people are making art around here.</span>\n"
	stress_change = -2
	timer = 5 MINUTES

/datum/stress_event/artgood
	desc = "<span class='nicegreen'>What a thought-provoking piece of art. I'll remember that for a while.</span>\n"
	stress_change = -4
	timer = 5 MINUTES

/datum/stress_event/artgreat
	desc = "<span class='nicegreen'>That work of art was so great it made me believe in the goodness of humanity. Says a lot in a place like this.</span>\n"
	stress_change = -6
	timer = 5 MINUTES

/datum/stress_event/bottle_flip
	desc = "<span class='nicegreen'>The bottle landing like that was satisfying.</span>\n"
	stress_change = -2
	timer = 3 MINUTES

/datum/stress_event/nanite_happiness
	desc = "<span class='nicegreen robot'>+++++++HAPPINESS ENHANCEMENT+++++++</span>\n"
	stress_change = -7

/datum/stress_event/bathcleaned
	desc = "<span class='nicegreen'>I feel like I've been scrubbed by a Goddess!</span>\n"
	stress_change = -5
	timer = 10 MINUTES

/datum/stress_event/cozy_sleep
	stress_change = -2
	desc = span_green("Sleeping on a tidy bed is so much better!")
	timer = 5 MINUTES

/datum/stress_event/washed_cloth
	stress_change = -2
	desc = span_green("This cloth was washed and dried, it smells better.")
	timer = 5 MINUTES

/datum/stress_event/shiny_shoes
	stress_change = -1
	desc = span_green("My shoes are shiny, it is nice to look at them.")
	timer = 15 MINUTES

/datum/stress_event/extra_shiny_shoes
	stress_change = -2
	desc = span_green("My shoes are SO shiny, this is incredible!")
	timer = 15 MINUTES

/datum/stress_event/noble_seen_servant_work
	stress_change = -2
	desc = span_green("The servants are working well as they should.. what a great place.")
	timer = 10 MINUTES

/datum/stress_event/poohit_nice
	stress_change = -1
	desc = span_green("Someone gave me a good pie-ing.")
	timer = 3 MINUTES
