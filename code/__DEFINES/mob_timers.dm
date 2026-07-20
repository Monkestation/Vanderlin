// These are just cooldowns. But not only that, these are also used as flags.
// Most of these should just be tracked by a status effect, or another system.
// The mob timer system shouldn't exist.
// But it does. So I will make macros for it.

#define MOBTIMER_SET(target, ident) (target.mob_timers[ident] = world.time)
#define MOBTIMER_UNSET(target, ident) (target.mob_timers -= ident)
#define MOBTIMER_EXISTS(target, ident) (!!target.mob_timers[ident])
#define MOBTIMER_FINISHED(target, ident, mt_time) (world.time >= (target.mob_timers[ident] + (mt_time)))

// DEPRECIATED SYSTEM, DO NOT ADD MORE
/* STATUS */
	#define MT_FREAKOUT "freakout"

	#define MT_LASTDIED "lastdied"
	#define MT_DEATHDIED "deathdied" //! flag

	#define MT_PUKE "puke"

/* CURSES */
	#define MT_CURSE_PESTRA "curse_pestra"
	#define MT_CURSE_BAOTHA "curse_baotha"
	#define MT_CURSE_GRAGGAR "curse_graggar"

/* VILLAIN */
	#define MT_ZOMBIETRIUMPH "zombie_tri" //! flag
	#define MT_VAMPTRANSFORM "becoming_vampire" //! flag
	#define MT_LEPERBLEED "leper_bleed"
	#define MT_REBELOFFER "rebeloffer" //! flag

/* SORTING IS HARD */
	#define MT_AMBUSHLAST "ambushlast"
	#define MT_AMBUSHCHECK "ambush_check"

	#define MT_SLO "slo" //! I literally don't know what this is supposed to be

	#define MT_LASTTRICK "lasttrick"
	#define MT_MIRRORTIME "mirrortime"
	#define MT_FOUNDSNEAK "found_sneak"

	#define MT_MADELOVE "made_love" // sexerlin //unused
	#define MT_RESIST_GRAB "resist_grab" // SORRY FINGER

/* SPECIAL MOBTIMERS */
	// These use timers as you would think mobtimers should be used.
	// Unfortunately, they break mobtimer convention.
	// I've separated then here for clarity's sake.

	#define MT_PAINSTUN "painstun"
