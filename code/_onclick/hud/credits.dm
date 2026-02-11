#define CREDIT_ROLL_SPEED 125
#define CREDIT_SPAWN_SPEED 50
#define CREDIT_ANIMATE_HEIGHT (14 * world.icon_size)
#define CREDIT_EASE_DURATION 22
#define CREDITS_PATH "icons/fullblack.dmi"

/client/proc/RollCredits()
	set waitfor = FALSE
//	if(!fexists(CREDITS_PATH))
//		return
//	var/icon/credits_icon = new(CREDITS_PATH)
	LAZYINITLIST(credits)
	var/list/_credits = credits
//	add_verb(src, /client/proc/ClearCredits)
//	var/static/list/credit_order_for_this_round
//	if(isnull(credit_order_for_this_round))
//		credit_order_for_this_round = list("Thanks for playing!") + (shuffle(icon_states(credits_icon)) - "Thanks for playing!")
	var/list/coomer = GLOB.credits_icons.Copy()
	sleep(50)
	for(var/I in coomer)
//		if(!credits)
//			return
		_credits += new /atom/movable/screen/credit(null, null, I, src, coomer[I]["icon"])
		sleep(CREDIT_SPAWN_SPEED)
//	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)
//	add_verb(src, /client/proc/ClearCredits)
//	qdel(credits_icon)

/client/proc/ClearCredits()
	set name = "Hide Credits"
	set category = "OOC"
	add_verb(src, /client/proc/ClearCredits)
	QDEL_LIST(credits)
	credits = null

/atom/movable/screen/credit
	mouse_opacity = 1
	alpha = 0
	screen_loc = "1,1"
	plane = SPLASHSCREEN_PLANE
	var/client/parent
	var/creditee
	var/upvoted

/atom/movable/screen/credit/Click()
	if(upvoted)
		return
	upvoted = TRUE
	var/image/I = new('icons/effects/effects.dmi', "hearty")
	I.pixel_x = rand(-32,32)
	animate(I, pixel_y = 64, alpha = 0, time = 18, flags = ANIMATION_PARALLEL)
	add_overlay(I)
	for(var/client/C in GLOB.clients)
		if(C == parent)
			continue
		for(var/atom/movable/screen/credit/CR in C.screen)
			if(CR.creditee == creditee)
				var/image/IR = new('icons/effects/effects.dmi', "hearty")
				IR.pixel_x = rand(-32,32)
				animate(IR, pixel_y = 64, alpha = 0, time = 18, flags = ANIMATION_PARALLEL)
				CR.add_overlay(IR)

/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P, icon/I)
	. = ..()
	icon = I
	parent = P
	var/voicecolor = LAZYACCESSASSOC(GLOB.credits_icons, credited, "vc") || "dc0174"
	maptext = MAPTEXT_CENTER("<span style='vertical-align:top; color: #[voicecolor]'>[credited]</span>")
	creditee = credited
	maptext_x = -32
	maptext_y = 8
	maptext_width = 150
	var/matrix/M = matrix(transform)
	M.Translate(224, 64)
	transform = M
	M = matrix(transform)
	M.Translate(-288, 0)
	animate(src, transform = M, time = 90)
	animate(src, alpha = 255, time = 10, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), 80)
	QDEL_IN(src, 90)
	P.screen += src

/atom/movable/screen/credit/Destroy()
	var/client/P = parent
	if(!P)
		return ..()
	P.screen -= src
	icon = null
	LAZYREMOVE(P.credits, src)
	parent = null
	return ..()

/atom/movable/screen/credit/proc/FadeOut()
	animate(src, alpha = 0, time = 10,  flags = ANIMATION_PARALLEL)

#undef CREDIT_ROLL_SPEED
#undef CREDIT_SPAWN_SPEED
#undef CREDIT_ANIMATE_HEIGHT
#undef CREDIT_EASE_DURATION
#undef CREDITS_PATH
