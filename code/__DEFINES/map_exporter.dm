//Bits to save
#define SAVE_OBJECTS (1 << 1) //! Save objects?
#define SAVE_MOBS (1 << 2) //! Save Mobs?
#define SAVE_TURFS (1 << 3) //! Save turfs?
#define SAVE_AREAS (1 << 4) //! Save areas?
#define SAVE_OBJECT_PROPERTIES (1 << 5) //! Save custom properties of objects (obj.on_object_saved() output)
#define SAVE_UUID_STASIS (1 << 6) //! Save objects with UUID_saving to stasis files
#define SAVE_ITEMS (1 << 7)
#define SAVE_WHITELIST (1 << 8) //! This will save special items aswell and remove special items, used for housing

//Ignore turf if it contains
#define SAVE_SHUTTLEAREA_DONTCARE 0
#define SAVE_SHUTTLEAREA_IGNORE 1
#define SAVE_SHUTTLEAREA_ONLY 2

#define DMM2TGM_MESSAGE "MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE"
