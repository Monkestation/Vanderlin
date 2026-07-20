
/**
 * Sends [COMSIG_ATOM_EXTINGUISH] signal, which properly removes burning component if it is present.
 *
 * Default behaviour is to send [COMSIG_ATOM_ACID_ACT] and return
 */
/atom/proc/extinguish()
	SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(src, COMSIG_ATOM_EXTINGUISH)
