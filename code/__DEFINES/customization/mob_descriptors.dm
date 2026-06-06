#define MOB_DESCRIPTOR_SLOT_NOTHING 1
#define MOB_DESCRIPTOR_SLOT_FACE_SHAPE 2
#define MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION 3
#define MOB_DESCRIPTOR_SLOT_BODY 4
#define MOB_DESCRIPTOR_SLOT_SKIN 5
#define MOB_DESCRIPTOR_SLOT_VOICE 6
#define MOB_DESCRIPTOR_SLOT_STATURE 7
#define MOB_DESCRIPTOR_SLOT_PROMINENT 8
#define MOB_DESCRIPTOR_SLOT_AGE 9
#define MOB_DESCRIPTOR_SLOT_HEIGHT 10

#define CUSTOM_DESCRIPTOR_AMOUNT 2
#define CUSTOM_DESCRIPTOR_TEXT_LENGTH 32

#define CUSTOM_PREFIX_HAS_A 1
#define CUSTOM_PREFIX_HAS_AN 2
#define CUSTOM_PREFIX_IS 3
#define CUSTOM_PREFIX_LOOKS 4
#define CUSTOM_PREFIX_HAS 5

#define CUSTOM_PREFIX_AMOUNT 5 //Keep this to match the max

#define CUSTOM_PREFIX_INPUT_LIST list(\
	"Has a" = CUSTOM_PREFIX_HAS_A,\
	"Has an" = CUSTOM_PREFIX_HAS_AN,\
	"Is" = CUSTOM_PREFIX_IS,\
	"Looks" = CUSTOM_PREFIX_LOOKS,\
	"Has" = CUSTOM_PREFIX_HAS\
)

#define CUSTOM_PREFIX_TRANSLATION_LIST list(\
	"[CUSTOM_PREFIX_HAS_A]" = "Has a",\
	"[CUSTOM_PREFIX_HAS_AN]" = "Has an",\
	"[CUSTOM_PREFIX_IS]" = "Is",\
	"[CUSTOM_PREFIX_LOOKS]" = "Looks",\
	"[CUSTOM_PREFIX_HAS]" = "Has"\
)

#define MOB_DESCRIPTOR(descriptor_type) GLOB.mob_descriptors[descriptor_type]

GLOBAL_LIST_INIT(mob_descriptors, build_descriptor_types())

/proc/build_descriptor_types()
	. = list()
	for(var/datum/mob_descriptor/type as anything in typesof(/datum/mob_descriptor))
		if(IS_ABSTRACT(type))
			continue
		.[type] = new type()
	return .

#define DESCRIPTOR_CHOICE(choice_type) GLOB.descriptor_choices[choice_type]
GLOBAL_LIST_INIT(descriptor_choices, build_descriptor_choices())

/proc/build_descriptor_choices()
	. = list()
	for(var/datum/descriptor_choice/type as anything in typesof(/datum/descriptor_choice))
		if(IS_ABSTRACT(type))
			continue
		.[type] = new type()
	return .
