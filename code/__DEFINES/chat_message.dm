#define CHAT_MESSAGE_SPAWN_TIME		0.2 SECONDS
#define CHAT_MESSAGE_LETTER_FADE_TIME	0.1 SECONDS
#define CHAT_MESSAGE_LETTER_MOVE_TIME	0.1 SECONDS
#define CHAT_MESSAGE_LIFESPAN		5 SECONDS
#define CHAT_MESSAGE_EOL_FADE		0.8 SECONDS
#define CHAT_MESSAGE_REPLACED_FADE	1.5 SECONDS
#define CHAT_MESSAGE_LETTER_SPAWN_RISE	5
#define CHAT_SPELLING_DELAY 		0.04 SECONDS
#define CHAT_MESSAGE_EXP_DECAY		0.7 // Messages decay at pow(factor, idx in stack)
#define CHAT_MESSAGE_HEIGHT_DECAY	0.9 // Increase message decay based on the height of the message
#define CHAT_MESSAGE_APPROX_LHEIGHT	11 // Approximate height in pixels of an 'average' line, used for height decay
#define CHAT_MESSAGE_WIDTH			112 // pixels
#define CHAT_MESSAGE_VISIBLE_LINES	5
#define CHAT_MESSAGE_MAX_LENGTH		110 // characters

#define CHAT_GLORF_LIST list(\
	"-ah!!",\
	"-GLORF!!",\
	"-OW!!"\
)

#define CHAT_SPELLING_PUNCTUATION list(\
	"," = 0.35 SECONDS,\
	"." = 0.45 SECONDS,\
	" " = 0.05 SECONDS,\
	"-" = 0.25 SECONDS,\
	"!" = 0.25 SECONDS,\
	"?" = 0.25 SECONDS,\
)


#define CHAT_SPELLING_EXCEPTIONS list(\
	"'",\
)
