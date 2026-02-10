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

#define MESSAGE_TYPE_SYSTEM "system"
#define MESSAGE_TYPE_LOCALCHAT "localchat"
#define MESSAGE_TYPE_RADIO "radio"
#define MESSAGE_TYPE_INFO "info"
#define MESSAGE_TYPE_WARNING "warning"
#define MESSAGE_TYPE_DEADCHAT "deadchat"
#define MESSAGE_TYPE_OOC "ooc"
#define MESSAGE_TYPE_LOOC "looc"
#define MESSAGE_TYPE_ADMINPM "adminpm"
#define MESSAGE_TYPE_COMBAT "combat"
#define MESSAGE_TYPE_ADMINCHAT "adminchat"
#define MESSAGE_TYPE_PRAYER "prayer"
#define MESSAGE_TYPE_MODCHAT "modchat"
#define MESSAGE_TYPE_EVENTCHAT "eventchat"
#define MESSAGE_TYPE_ADMINLOG "adminlog"
#define MESSAGE_TYPE_ATTACKLOG "attacklog"
#define MESSAGE_TYPE_DEBUG "debug"


/// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define boxed_message(str) ("<div class='boxed_message'>" + str + "</div>")
