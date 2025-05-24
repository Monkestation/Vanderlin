/obj/effect/mapping_helpers/structure/breaker
	name = "structure breaker"

/obj/effect/mapping_helpers/structure/breaker/payload(obj/structure/payload)
	if(QDELETED(payload))
		return
	if(!payload.max_integrity)
		log_mapping("[src] at [AREACOORD(src)] placed on object that cannot be damaged.")
		return
	if(!payload.integrity_failure)
		log_mapping("[src] at [AREACOORD(src)] placed on object that can only be destroyed.")
		return
	if(payload.obj_broken)
		log_mapping("[src] at [AREACOORD(src)] placed on object that is already broken.")
		return
	payload.obj_integrity *= payload.integrity_failure
	payload.obj_break(silent = TRUE)
