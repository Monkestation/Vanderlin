//nutrition
/datum/stress_event/fat
	desc = "<span class='warning'><B>I'm so fat...</B></span>\n" //muh fatshaming
	stress_change = -6

/datum/stress_event/wellfed
	desc = "<span class='nicegreen'>I'm stuffed!</span>\n"
	stress_change = 8

/datum/stress_event/fed
	desc = "<span class='nicegreen'>I have recently had some food.</span>\n"
	stress_change = 5

/datum/stress_event/hungry
	desc = "<span class='warning'>I'm getting a bit hungry.</span>\n"
	stress_change = -6

/datum/stress_event/starving
	desc = "<span class='boldwarning'>I'm starving!</span>\n"
	stress_change = -10

//Disgust
/datum/stress_event/gross
	desc = "<span class='warning'>I saw something gross.</span>\n"
	stress_change = -4

/datum/stress_event/verygross
	desc = "<span class='warning'>I think I'm going to puke...</span>\n"
	stress_change = -6

/datum/stress_event/disgusted
	desc = "<span class='boldwarning'>Oh god that's disgusting...</span>\n"
	stress_change = -8

/datum/stress_event/disgust/bad_smell
	desc = "<span class='warning'>I smell something horribly decayed inside this room.</span>\n"
	stress_change = -6

/datum/stress_event/disgust/nauseating_stench
	desc = "<span class='warning'>The stench of rotting carcasses is unbearable!</span>\n"
	stress_change = -12

//Generic needs events
/datum/stress_event/favorite_food
	desc = "<span class='nicegreen'>I really enjoyed eating that.</span>\n"
	stress_change = 5
	timer = 4 MINUTES

/datum/stress_event/gross_food
	desc = "<span class='warning'>I really didn't like that food.</span>\n"
	stress_change = -2
	timer = 4 MINUTES

/datum/stress_event/disgusting_food
	desc = "<span class='warning'>That food was disgusting!</span>\n"
	stress_change = -6
	timer = 4 MINUTES

/datum/stress_event/breakfast
	desc = "<span class='nicegreen'>Nothing like a hearty breakfast to start the shift.</span>\n"
	stress_change = 2
	timer = 10 MINUTES

/datum/stress_event/feet_free
	desc = span_nicegreen("I can move my feet freely!")
	stress_change = -1
	timer = -1

/datum/stress_event/feet_constrained
	desc = span_userdanger("I can't move my feet at all... It's uncomfortable.")
	stress_change = 1
	timer = -1
