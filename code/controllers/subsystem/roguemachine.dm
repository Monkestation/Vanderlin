
PROCESSING_SUBSYSTEM_DEF(roguemachine)
	name = "roguemachine"
	wait = 20
	flags = SS_NO_INIT
	priority = 1
	var/list/hermailers = list()
	var/list/cameras = list()
	var/list/scomm_machines = list()
	var/list/stock_machines = list()
	var/hermailermaster
	var/list/death_queue = list()
	var/last_death_report
	var/obj/item/crown
	var/obj/item/key
	var/obj/structure/fake_machine/hailer/hailer

/datum/controller/subsystem/processing/roguemachine/fire(resumed = 0)
	. = ..()
	if(!length(death_queue) || !SSroguemachine.hermailermaster)
		return
	if(world.time < last_death_report + 3 SECONDS)
		return
	last_death_report = world.time

	var/obj/item/fake_machine/mastermail/mailer = SSroguemachine.hermailermaster
	for(var/I in death_queue)
		var/obj/item/paper/P = new(mailer.loc)
		P.mailer = "death witness"
		P.mailedto = "steward of roguetown"
		P.update_appearance(UPDATE_NAME | UPDATE_ICON_STATE)
		P.info = I
		var/datum/storage/storage = mailer.atom_storage
		storage.attempt_insert(P, override = TRUE)
		mailer.new_mail = TRUE
		mailer.update_appearance(UPDATE_ICON_STATE)

	playsound(mailer, 'sound/misc/hiss.ogg', 100, FALSE, -1)

	death_queue = null

/proc/is_in_roguetown(atom/A)
	if(!A)
		return
	var/turf/T = get_turf(A)
	if(!T)
		return
	var/area/AR = get_area(T)
	var/list/L = list(/area/outdoors/town,\
/area/indoors/town,\
/area/under/town)
	for(var/X in L)
		if(istype(AR, X))
			return TRUE
#ifdef TESTING
/mob/living/verb/maxzcdec()
	set category = "DEBUGTEST"
	set name = "IsInRoguetown"
	set desc = ""
	if(is_in_roguetown(src))
		to_chat(src, "\n<font color='purple'>IS IN</font>")
	else
		to_chat(src, "\n<font color='purple'>IS NOT IN</font>")
#endif
