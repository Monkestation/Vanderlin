/datum/stress_event/vice
	timer = 5 MINUTES
	stress_change = 3
	desc = list(span_boldred("I don't indulge my vice."),span_boldred("I need to sate my vice."))

/datum/stress_event/vice1
	timer = 5 MINUTES
	stress_change = 2
	desc = list("<span class='red'>I don't indulge my vice.</span>","<span class='red'>I need to sate my vice.</span>")

/datum/stress_event/vice2
	timer = 5 MINUTES
	stress_change = 4
	desc = list("<span class='red'>I don't need it. I don't need it. I don't need it.</span>","<span class='red'>I'm better than my vices.</span>")

/datum/stress_event/vice3
	timer = 5 MINUTES
	stress_change = 6
	desc = list("<span class='red'>If I don't sate my desire soon, I am going to kill myself..</span>","<span class='red'>I need it. I need it. I need it.</span>")

/datum/stress_event/miasmagas
	timer = 10 SECONDS
	stress_change = 2
	desc = "<span class='red'>Smells like death here.</span>"

/datum/stress_event/peckish
	stress_change = 1
	desc = "<span class='red'>I'm peckish.</span>"

/datum/stress_event/hungry
	stress_change = 2
	desc = "<span class='red'>I'm hungry.</span>"

/datum/stress_event/starving
	stress_change = 3
	desc = "<span class='red'>I'm starving.</span>"

/datum/stress_event/drym
	stress_change = 1
	desc = "<span class='red'>I'm a little thirsty.</span>"

/datum/stress_event/thirst
	stress_change = 2
	desc = "<span class='red'>I'm thirsty.</span>"

/datum/stress_event/parched
	stress_change = 3
	desc = "<span class='red'>I'm going to die of thirst.</span>"

/datum/stress_event/dismembered
	timer = 40 MINUTES
	stress_change = 5
	desc = "<span class='red'>I WAS USING THAT APPENDAGE!</span>"

/datum/stress_event/dwarfshaved
	timer = 40 MINUTES
	stress_change = 6
	desc = "<span class='red'>I'd rather cut my own throat than my beard.</span>"

/datum/stress_event/viewdeath
	timer = 1 MINUTES
	stress_change = 1
	desc = "<span class='red'>Death...</span>"

/datum/stress_event/viewdeath/get_desc(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna?.species)
			return "<span class='red'>Another [lowertext(H.dna.species.name)] perished.</span>"
	return desc

/datum/stress_event/viewdismember
	timer = 5 MINUTES
	stress_change = 2
	desc = "<span class='red'>I've seen men lose their limbs.</span>"

/datum/stress_event/fviewdismember
	timer = 1 MINUTES
	stress_change = 1
	desc = "<span class='red'>This land is brutal.</span>"

/datum/stress_event/viewgib
	timer = 5 MINUTES
	stress_change = 2
	desc = "<span class='red'>Battle stress is getting to me.</span>"

/datum/stress_event/bleeding
	timer = 2 MINUTES
	stress_change = 1
	desc = list("<span class='red'>I think I'm bleeding.</span>","<span class='red'>I'm bleeding.</span>")

/datum/stress_event/bleeding/can_apply(mob/living/user)
	if(user.has_quirk(/datum/quirk/vice/masochist))
		return FALSE
	return TRUE

/datum/stress_event/painmax
	timer = 1 MINUTES
	stress_change = 2
	desc = "<span class='red'>THE PAIN!</span>"

/datum/stress_event/painmax/can_apply(mob/living/user)
	if(user.has_quirk(/datum/quirk/vice/masochist))
		return FALSE
	return TRUE

/datum/stress_event/freakout
	timer = 15 SECONDS
	stress_change = 2
	desc = "<span class='red'>I'm panicking!</span>"

/datum/stress_event/felldown
	timer = 1 MINUTES
	stress_change = 1
//	desc = "<span class='red'>I fell. I'm a fool.</span>"

/datum/stress_event/fullshoe
	stress_change = 1
	desc = span_red("There is something in my shoe.")

/datum/stress_event/uncookedfood
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>IT'S FUCKING RAW!!</span>"

/datum/stress_event/hatezizo
	timer = 99999 MINUTES
	stress_change = 666 // :)
	desc = "<span class='red'>ZIZOZIZOZIZO</span>"

/datum/stress_event/burntmeal
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>YUCK!</span>"

/datum/stress_event/rotfood
	timer = 2 MINUTES
	stress_change = 4
	desc = "<span class='red'>YUCK! MAGGOTS!</span>"

/datum/stress_event/psycurselight
	timer = 1 MINUTES
	stress_change = 5
	desc = "<span class='red'>Oh no! I've received divine punishment!</span>"

/datum/stress_event/psycurse
	timer = INFINITY
	stress_change = 5
	desc = "<span class='red'>Oh no! I've received divine punishment!</span>"

/datum/stress_event/badmeal
	timer = 3 MINUTES
	stress_change = 2
	desc = "<span class='red'>It tastes VILE!</span>"

/datum/stress_event/vomit
	timer = 3 MINUTES
	stress_change = 2
	max_stacks = 3
	stress_change_per_extra_stack = 2
	desc = "<span class='red'>I puked!</span>"

/datum/stress_event/vomitself
	timer = 3 MINUTES
	stress_change = 2
	max_stacks = 3
	stress_change_per_extra_stack = 2
	desc = "<span class='red'>I puked on myself!</span>"

/datum/stress_event/mouthsoap
	timer = 3 MINUTES
	stress_change = 2
	max_stacks = 2
	stress_change_per_extra_stack = 2
	desc = "<span class='red'>I taste soap...</span>"

/datum/stress_event/leechcult
	timer = 1 MINUTES
	stress_change = 3
	desc = list("<span class='red'>There's a little goblin in my head telling me to do things and I don't like it!</span>","<span class='red'>\"Kill your friends.\"</span>","<span class='red'>\"Make them bleed.\"</span>","<span class='red'>\"Give them no time to squeal.\"</span>","<span class='red'>\"Praise Zizo.\"</span>","<span class='red'>\"Death to the Ten.\"</span>","<span class='red'>\"We will recycle them.\"</span>")

/datum/stress_event/ugly
	timer = 30 SECONDS
	stress_change = 1
	desc = span_red("How can one possibly be so ugly?")

/datum/stress_event/ugly_self
	timer = 30 SECONDS
	stress_change = 1
	desc = span_red("Same old ugly mug...")

/datum/stress_event/fishface
	timer = 30 SECONDS
	stress_change = 1
	desc = "<span class='red'>That thing is hideous!.</span>"

/datum/stress_event/fish_monster
	timer = 30 SECONDS
	stress_change = 1
	desc = span_boldred("<B>IT'S A HIDEOUS MONSTER!!!</B>")

/datum/stress_event/fishfaceaintthatugly
	timer = 30 SECONDS
	stress_change = 0
	desc = "Eh, I've seen worse faces than that fish."

/datum/stress_event/delf
	timer = 30 SECONDS
	stress_change = 1
	desc = "<span class='red'>A loathsome dark elf.</span>"

/datum/stress_event/tieb
	timer = 30 SECONDS
	stress_change = 1
	desc = "<span class='red'>Helldweller... better stay away.</span>"

/datum/stress_event/horc
	timer = 30 SECONDS
	stress_change = 1
	desc = "<span class='red'>A beast in human skin.</span>"

/datum/stress_event/paracrowd
	timer = 15 SECONDS
	stress_change = 2
	desc = "<span class='red'>There are too many people who don't look like me here.</span>"

/datum/stress_event/parablood
	timer = 15 SECONDS
	stress_change = 3
	desc = "<span class='red'>There is so much blood here... it's like a battlefield!</span>"

/datum/stress_event/parastr
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>That beast is stronger... and might easily kill me!</span>"

/datum/stress_event/paratalk
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>They are plotting against me in evil tongues...</span>"

/datum/stress_event/paraforeigner
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>A foreigner... are they planning to invade us?</span>"

/datum/stress_event/crowd
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>Why is everyone here...? Are they trying to kill me?!</span>"

/datum/stress_event/nopeople
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>Where did everyone go? Did something happen?!</span>"

/datum/stress_event/hunted // When a hunted character sees someone in a mask
	timer = 2 MINUTES
	stress_change = 2
	desc = "<span class='red'>I can't see their face! Have they found me!?</span>"

/datum/stress_event/profane // When a non-assassin touches a profane dagger
	timer = 3 MINUTES
	stress_change = 2
	desc = "<span class='red'>I hear the voices of the damned from this cursed blade!</span>"

/datum/stress_event/coldhead
	timer = 60 SECONDS
	stress_change = 1
//	desc = "<span class='red'>My head is cold and ugly.</span>"

/datum/stress_event/sleepytime
	timer = 0
	stress_change = 1
	desc = "<span class='red'>I'm tired.</span>"

/datum/stress_event/trainsleep
	timer = 0
	stress_change = 1
	desc = "<span class='red'>My muscles ache.</span>"

/datum/stress_event/tortured
	stress_change = 3
	max_stacks = 5
	stress_change_per_extra_stack = 1
	desc = span_red("I'm broken.")
	timer = 5 MINUTES

/datum/stress_event/torture_small_penalty
	stress_change = 1
	max_stacks = 3
	stress_change_per_extra_stack = 1
	desc = span_red("I tortured an innocent...")
	timer = 5 MINUTES

/datum/stress_event/torture_large_penalty
	stress_change = 3
	max_stacks = 3
	stress_change_per_extra_stack = 3
	desc = span_red("I tortured a fellow believer!")
	timer = 15 MINUTES

/datum/stress_event/painful_reminder
	stress_change = 4
	max_stacks = 1
	desc = span_dead("Melancholy fills my heart.")
	timer = 1 MINUTES

/datum/stress_event/maniac
	stress_change = 4
	desc = "<span class='red'>THE MANIAC COULD BE HERE!</span>"
	timer = 30 MINUTES

/datum/stress_event/drankrat
	stress_change = 1
	desc = "<span class='red'>I drank from a lesser creature.</span>"
	timer = 1 MINUTES

/datum/stress_event/lowvampire
	stress_change = 1
	desc = "<span class='red'>I'm dead... what comes next?</span>"

/datum/stress_event/oziumoff
	stress_change = 20
	desc = "<span class='blue'>I need another hit.</span>"
	timer = 1 MINUTES

/datum/stress_event/sleepfloor
	timer = 1 MINUTES
	stress_change = 2
	desc = "<span class='red'>I slept on the floor. It was uncomfortable.</span>"

/datum/stress_event/sleepfloornoble
	timer = 3 MINUTES
	stress_change = 4
	desc = "<span class='red'>I slept on the floor! What am I, an animal?!</span>"

/datum/stress_event/sadfate
	timer = 60 MINUTES
	stress_change = 1
	desc = "<span class='red'>I feel useless...</span>"

/datum/stress_event/saw_wonder
	stress_change = 4
	desc = span_boldred("<B>I have seen something nightmarish, and I fear for my life!</B>")
	timer = 999 MINUTES


/datum/stress_event/confessed
	stress_change = 3
	desc = span_red("I've confessed to sin.")
	timer = 15 MINUTES

/datum/stress_event/confessedgood
	stress_change = 1
	desc = span_red("I've confessed to sin, it feels good.")
	timer = 15 MINUTES

/datum/stress_event/maniac_woke_up
	stress_change = 10
	desc = span_boldred("No... I want to go back...")
	timer = 999 MINUTES

/datum/stress_event/guillotinefail
	timer = 5 MINUTES
	stress_change = 3
	desc = span_red("This execution is horrifying!")

/datum/stress_event/guillotineexecutorfail
	timer = 15 MINUTES
	stress_change = 5
	desc = span_boldred("I have failed the guillotine drop! What a shame!")

//// 1 stress event for each type of clothing! ///
/datum/stress_event/maiddress
	timer = 999 MINUTES
	stress_change = 5
	desc = span_red("I really don't like wearing this. It's servant clothing.")

/datum/stress_event/maiddress/noble
	stress_change = 6
	desc = span_red("Wearing this is beneath me! I will not tolerate this another second!")

/datum/stress_event/maidband
	timer = 999 MINUTES
	stress_change = 3
	desc = span_red("I really don't like wearing this. It's servant clothing.")

/datum/stress_event/maidband/noble
	stress_change = 4
	desc = span_red("Wearing this is beneath me! I will not tolerate this another second!")

/datum/stress_event/maidapron
	timer = 999 MINUTES
	stress_change = 3
	desc = span_red("I really don't like wearing this. It's servant clothing.")

/datum/stress_event/maidapron/noble
	stress_change = 5
	desc = span_red("Wearing this is beneath me! I will not tolerate this another second!")

/// End Maid stress

/datum/stress_event/noble_impoverished_food
	stress_change = 3
	desc = span_boldred("This is disgusting. How can anyone eat this?")
	timer = 10 MINUTES

/datum/stress_event/noble_desperate
	stress_change = 6
	desc = span_boldred("What level of desperation have I fallen to?")
	timer = 60 MINUTES

/datum/stress_event/noble_bland_food
	stress_change = 2
	desc = span_red("This fare is really beneath me. I deserve better than this...")
	timer = 5 MINUTES

/datum/stress_event/tortured/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_TORTURES)

/datum/stress_event/noble_bad_manners
	stress_change = 1
	desc = span_red("I should've used a spoon...")
	timer = 5 MINUTES

/datum/stress_event/noble_ate_without_table
	stress_change = 1
	desc = span_red("Eating such a meal without a table? Churlish.")
	timer = 5 MINUTES

/datum/stress_event/noble_ate_without_plate
	stress_change = 1
	desc = span_red("To eat without a plate... how utterly uncivilized.")
	timer = 5 MINUTES

/datum/stress_event/noble_ate_with_just_a_fork
	stress_change = 1
	desc = span_red("Eating off a bare fork, this is hardly proper dining.")
	timer = 5 MINUTES

/datum/stress_event/noble_tarnished_cloth
	stress_change = 1
	desc = span_red("This is beneath me... a noble should dry their cloth in a proper place.")
	timer = 5 MINUTES

/datum/stress_event/noble_polishing_shoe
	stress_change = 3
	desc = span_red("This menial chore insults my station, i should not need to polish a pair of shoes.")
	timer = 5 MINUTES

/datum/stress_event/destroyed_past //gaffer destroying their trophies
	stress_change = 4
	desc = span_red("A piece of my history is destroyed, how will they know my great past?")
	timer = 10 MINUTES

/datum/stress_event/ring_madness // ring bearer examines at HEAD EATER related thing
	stress_change = 1
	desc = span_red("It mocks me, toys with my mind!")
	timer = 1 MINUTES

/datum/stress_event/eora_matchmaking
	stress_change = 2
	desc = span_rose("Eora calls for me to be wed! I must find my destined partner before I die all alone...")
	timer = 30 MINUTES

/datum/stress_event/graggar_culling_unfinished
	stress_change = 1
	desc = span_red("I must eat my opponent's heart before he eats MINE!")
	timer = INFINITY

/datum/stress_event/mother_calling
	timer = 1 MINUTES
	stress_change = 2
	desc = span_red("The Matron is calling for me by my full name..")

/datum/stress_event/friend_calling
	timer = 30 SECONDS
	stress_change = 1
	desc = span_red("That voice.. That old thief is calling for me, what is it now?")

/datum/stress_event/night_owl_dawn
	desc = span_warning("I don't like the dae..")
	stress_change = 1
	timer = 10 MINUTES

/datum/stress_event/hithead
	timer = 2 MINUTES
	stress_change = 2
	desc = span_red("Oww, my head...")

/datum/stress_event/divine_punishment
	timer = 5 MINUTES
	stress_change = 4
	desc = span_warning("The gods have not taken kindly to my deeds.")

/datum/stress_event/taken_hostage
	timer = INFINITY
	stress_change = 3
	desc = span_red("I've been taken hostage!")

/datum/stress_event/perfume_hater
	stress_change = 1
	desc = span_red("The scent of flowers makes me nauseous!")
	timer = 10 MINUTES

/datum/stress_event/odor
	stress_change = 1
	desc = span_red("The scent of body odor violates my nostrils!")
	timer = 10 MINUTES

//Hygiene

/datum/stress_event/dirty
	timer = INFINITY
	desc = span_red("I smell horrid.")
	stress_change = 1

/datum/stress_event/disgusting
	timer = INFINITY
	desc = span_red("I smell <i>DISGUSTING!</i>")
	stress_change = 2

/datum/stress_event/forced_clean
	timer = 10 MINUTES
	desc = span_red("My wonderful musk has been washed away...")
	stress_change = 1
/datum/stress_event/startled
	desc = span_warning("Hearing that word made me think about something scary.")
	stress_change = 1
	max_stacks = 2
	stress_change_per_extra_stack = 1
	timer = 1 MINUTES

/datum/stress_event/phobia
	desc = span_red("I saw something very frightening.")
	stress_change = 4
	max_stacks = 2
	stress_change_per_extra_stack = 2
	timer = 4 MINUTES

/datum/stress_event/handcuffed
	desc = "<span class='warning'>I guess my antics have finally caught up with me.</span>\n"
	stress_change = 1

/datum/stress_event/on_fire
	desc = "<span class='boldwarning'>I'M ON FIRE!!!</span>\n"
	stress_change = 12

/datum/stress_event/suffocation
	desc = "<span class='boldwarning'>CAN'T... BREATHE...</span>\n"
	stress_change = 12

/datum/stress_event/burnt_thumb
	desc = "<span class='warning'>I shouldn't play with lighters...</span>\n"
	stress_change = 1
	timer = 2 MINUTES

/datum/stress_event/cold
	desc = "<span class='warning'>It's way too cold in here.</span>\n"
	stress_change = 5

/datum/stress_event/hot
	desc = "<span class='warning'>It's getting hot in here.</span>\n"
	stress_change = 5

/datum/stress_event/creampie
	desc = "<span class='warning'>I've been creamed. Tastes like pie flavor.</span>\n"
	stress_change = 2
	timer = 3 MINUTES

/datum/stress_event/slipped
	desc = "<span class='warning'>I slipped. I should be more careful next timer...</span>\n"
	stress_change = 2
	timer = 3 MINUTES

/datum/stress_event/eye_stab
	desc = "<span class='boldwarning'>I used to be an adventurer like you, until I took a screwdriver to the eye.</span>\n"
	stress_change = 4
	timer = 3 MINUTES

/datum/stress_event/depression
	desc = "<span class='warning'>I feel sad for no particular reason.</span>\n"
	stress_change = 12
	timer = 2 MINUTES

/datum/stress_event/shameful_suicide //suicide_acts that return SHAME, like sord
	desc = "<span class='boldwarning'>I can't even end it all!</span>\n"
	stress_change = 15
	timer = 60 SECONDS

/datum/stress_event/dismembered
	desc = "<span class='boldwarning'>AHH! I WAS USING THAT LIMB!</span>\n"
	stress_change = 10
	timer = 8 MINUTES

/datum/stress_event/embedded
	desc = "<span class='boldwarning'>Pull it out!</span>\n"
	stress_change = 7

/datum/stress_event/table_headsmash
	desc = "<span class='warning'>My fucking head, that hurt...</span>"
	stress_change = 3
	timer = 3 MINUTES

/datum/stress_event/brain_damage
	stress_change = 3

/datum/stress_event/epilepsy //Only when the mutation causes a seizure
	desc = "<span class='warning'>I should have paid attention to the epilepsy warning.</span>\n"
	stress_change = 3
	timer = 5 MINUTES

/datum/stress_event/nyctophobia
	desc = "<span class='warning'>It sure is dark around here...</span>\n"
	stress_change = 3

/datum/stress_event/family_heirloom_missing
	desc = "<span class='warning'>I'm missing my family heirloom...</span>\n"
	stress_change = 4

/datum/stress_event/healsbadman
	desc = "<span class='warning'>I feel like I'm held together by flimsy string, and could fall apart at any moment!</span>\n"
	stress_change = 4
	timer = 2 MINUTES

/datum/stress_event/jittery
	desc = "<span class='warning'>I'm nervous and on edge and I can't stand still!!</span>\n"
	stress_change = 2

/datum/stress_event/vomit
	desc = "<span class='warning'>I just threw up. Gross.</span>\n"
	stress_change = 2
	timer = 2 MINUTES

/datum/stress_event/vomitself
	desc = "<span class='warning'>I just threw up all over myself. This is disgusting.</span>\n"
	stress_change = 4
	timer = 3 MINUTES

/datum/stress_event/painful_medicine
	desc = "<span class='warning'>Medicine may be good for me but right now it stings like hell.</span>\n"
	stress_change = 5
	timer = 60 SECONDS

/datum/stress_event/spooked
	desc = "<span class='warning'>The rattling of those bones...It still haunts me.</span>\n"
	stress_change = 4
	timer = 4 MINUTES

/datum/stress_event/loud_gong
	desc = "<span class='warning'>That loud gong noise really hurt my ears!</span>\n"
	stress_change = 3
	timer = 2 MINUTES

/datum/stress_event/notcreeping
	desc = "<span class='warning'>The voices are not happy, and they painfully contort my thoughts into getting back on task.</span>\n"
	stress_change = 6
	timer = 30
	hidden = TRUE

/datum/stress_event/notcreepingsevere//not hidden since it's so severe
	desc = "<span class='boldwarning'>THEY NEEEEEEED OBSESSIONNNN!!</span>\n"
	stress_change = 30
	timer = 30

/datum/stress_event/sapped
	desc = "<span class='boldwarning'>Some unexplainable sadness is consuming me...</span>\n"
	stress_change = 15
	timer = 90 SECONDS

/datum/stress_event/back_pain
	desc = "<span class='boldwarning'>Bags never sit right on my back, this hurts like hell!</span>\n"
	stress_change = 15

/datum/stress_event/sad_empath
	desc = "<span class='warning'>Someone seems upset...</span>\n"
	stress_change = 2
	timer = 60 SECONDS

/datum/stress_event/sacrifice_bad
	desc = "<span class='warning'>Those darn savages!</span>\n"
	stress_change = 5
	timer = 2 MINUTES

/datum/stress_event/artbad
	desc = "<span class='warning'>I've produced better art than that from my ass.</span>\n"
	stress_change = 2
	timer = 1200

/datum/stress_event/graverobbing
	desc = "<span class='boldwarning'>I just desecrated someone's grave... I can't believe I did that...</span>\n"
	stress_change = 8
	timer = 3 MINUTES

/datum/stress_event/ear_crushed
	desc = span_red("My phantom ear was destroyed!")
	stress_change = 1
	timer = 2 MINUTES

/datum/stress_event/collarcurse
	desc = "<span class='boldwarning'>It's uncomfortable, and I can't take it off!</span>\n" //torture yay!
	stress_change = 50
	timer = 1000 MINUTES

/datum/stress_event/consumed_tainted_lux
	desc = span_warning("Why did I drink that?")
	stress_change = 15
	timer = 10 MINUTES

/datum/stress_event/dead_bird
	timer = 5 MINUTES
	stress_change = 3
	desc = span_red("My precious bird won't answer my call...")

/datum/stress_event/soulchurnerhorror
	timer = 10 SECONDS
	stress_change = 50
	desc = span_red("The horrid wails of the dead call for relief! WHAT HAVE I DONE?!")

/datum/stress_event/soulchurner
	timer = 1 MINUTES
	stress_change = 10
	desc = span_red("The horrid wails of the dead call for relief!")


/datum/stress_event/soulchurnerpsydon
	timer = 1 MINUTES
	stress_change = 1
	desc = span_red("The horrid wails of the dead call for relief! I can ENDURE such calls...")

/datum/stress_event/wet_cloth
	stress_change = 1
	desc = span_red("I am wearing wet clothes.. ugh.")
	timer = 1 MINUTES

/datum/stress_event/dirty_platter
	stress_change = 1
	desc = span_red("I ate off a dirty platter..")
	timer = 1 MINUTES

/datum/stress_event/dirty_bowl
	stress_change = 1
	desc = span_red("I ate off a dirty bowl..")
	timer = 1 MINUTES

/datum/stress_event/poohit
	timer = 3 MINUTES
	stress_change = 2
	desc = span_red("I'm covered in feces! Disgusting!")
