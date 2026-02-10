#define CHAT_MESSAGE_SPAWN_TIME		0.2 SECONDS
#define CHAT_MESSAGE_LIFESPAN		5 SECONDS
#define CHAT_MESSAGE_EOL_FADE		0.8 SECONDS
#define CHAT_SPELLING_DELAY 		0.02 SECONDS
#define CHAT_MESSAGE_EXP_DECAY		0.7 // Messages decay at pow(factor, idx in stack)
#define CHAT_MESSAGE_HEIGHT_DECAY	0.9 // Increase message decay based on the height of the message
#define CHAT_MESSAGE_APPROX_LHEIGHT	11 // Approximate height in pixels of an 'average' line, used for height decay
#define CHAT_MESSAGE_WIDTH			96 // pixels
#define CHAT_MESSAGE_MAX_LENGTH		110 // characters
#define CHAT_GLORF_LIST list(\
							"-ah!!",\
							"-GLORF!!",\
							"-OW!!"\
							)

#define CHAT_SPELLING_PUNCTUATION list(\
										"," = 0.25 SECONDS,\
										"." = 0.4 SECONDS,\
										" " = 0.03 SECONDS,\
										"-" = 0.2 SECONDS,\
										"!" = 0.2 SECONDS,\
										"?" = 0.15 SECONDS,\
										)


#define CHAT_SPELLING_EXCEPTIONS list(\
										"'",\
										)

/// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define boxed_message(str) ("<div class='boxed_message'>" + str + "</div>")
