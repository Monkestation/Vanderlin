#define CONVERT_TO_ATTUNEMENT_MULT(to_convert) \
	if (to_convert != 0) { \
		if (to_convert > 0) { \
			to_convert = (1/(1+to_convert)); \
		} \
		else { \
			to_convert = (-to_convert+1); \
		} \
	} \
// When other elements are used, add them here

// Alignments
#define MAGIC_ALIGNMENT_NORMAL "Follower of Noc"
#define MAGIC_ALIGNMENT_NECROMANCER "Child of Zizo"
