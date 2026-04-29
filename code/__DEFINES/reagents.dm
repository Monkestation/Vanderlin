#define LIQUID_UNIT_NAME_SINGULAR "ligula"
#define LIQUID_UNIT_NAME_PLURAL "ligulae"

/// Format amount and ligula or ligulae correctly based on volume "30 ligulae"
#define UNIT_FORM_STRING(amount) ("[amount] [amount == 1 ? LIQUID_UNIT_NAME_SINGULAR : LIQUID_UNIT_NAME_PLURAL]")

#define SOLID 			1
#define LIQUID			2
#define GAS				3

#define INJECTABLE		(1<<0)	//! Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE		(1<<1)	//! Makes it possible to remove reagents through syringes.

#define REFILLABLE		(1<<2)	//! Makes it possible to add reagents through any reagent container.
#define DRAINABLE		(1<<3)	//! Makes it possible to remove reagents through any reagent container.

#define TRANSPARENT		(1<<4)	//! Used on containers which you want to be able to see the reagents off.
#define AMOUNT_VISIBLE	(1<<5)	//! For non-transparent containers that still have the general amount of reagents in them visible.
#define NO_REACT        (1<<6)  //! Applied to a reagent holder, the contents will not react with each other.

/// Is an open container for all intents and purposes.
#define OPENCONTAINER (REFILLABLE | DRAINABLE | TRANSPARENT)
/// You can transfer to and from other containers
#define TRANSFERABLE (REFILLABLE | DRAINABLE)
/// You can transfer reagents to and from with a syringe
#define SYRINGE_TRANSFER (INJECTABLE | DRAWABLE)

/// Used for splashing.
#define TOUCH (1<<0)
/// Used for ingesting the reagents. Food, drinks, inhaling smoke.
#define INGEST (1<<1)
/// Used by foams, sprays, and blob attacks.
#define VAPOR (1<<2)
/// Used by medical patches and gels.
#define PATCH (1<<3)
/// Used for direct injection of reagents.
#define INJECT (1<<4)
/// Used for direct snorting of reagents
#define SNORT (1<<5)


//defines passed through to the on_reagent_change proc
#define DEL_REAGENT		1	// reagent deleted (fully cleared)
#define ADD_REAGENT		2	// reagent added
#define REM_REAGENT		3	// reagent removed (may still exist)
#define CLEAR_REAGENTS	4	// all reagents were cleared
#define REACT_REAGENTS	5	// a reaction occured

#define MIMEDRINK_SILENCE_DURATION 30  //ends up being 60 seconds given 1 tick every 2 seconds
//used by chem masters and pill presses
#define PILL_STYLE_COUNT 22 //Update this if you add more pill icons or you die
#define RANDOM_PILL_STYLE 22 //Dont change this one though

#define ALCOHOL_RATE 0.005 //The rate at which alcohol affects you
